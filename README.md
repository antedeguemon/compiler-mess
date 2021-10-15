# CompilerMess

For some mysterious reason you want to add a `@before_compile` hook to all
modules in our project? Or perhaps you want to spice your day with some race
conditions in your compiler?

This is a piece of concept repository about messing around with Elixir
compilation process by tampering its internal ETS tables.

## What?

```elixir
$ iex -S mix
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

Messing around with the Elixir compiler
Compiling 4 files (.ex)
Injected @before_compile to Elixir.CompilerMess
Injected @before_compile to Elixir.CompilerMess.Injector
Injected @before_compile to Elixir.Mix.Tasks.Compile.CompilerMess
Interactive Elixir (1.12.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> CompilerMess.injected?()
true
iex(2)> CompilerMess.inspect()  
"Hey, that hurts..."
```

Note that `CompilerMess` does not have any `@before_compile`:

```elixir
# lib/compiler_mess.ex
defmodule CompilerMess do
  @moduledoc """
  The sole purpose of the existence of this module is to allow me to test if
  functions from `CompilerMess.Probe` got injected correctly.
  """
end
```

## How?

There is an additional compiler in `mix.exs`:

```elixir
compilers: Mix.compilers() ++ [:compiler_mess]
```

This new compiler is a compilation task that:
1. Spawns a loop that keeps updating Elixir internal `elixir_modules` ETS table.
  a. Checks for new modules on the table and injects a `before_hook` into them
  calling `CompilerMess.Probe` module.
2. Runs `mix compile.elixir --force` so all project modules are re-compiled.

The `elixir_modules` table is where module callbacks are stored during module
compilation by [Elixir module compiler](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/src/elixir_module.erl).

Since the `elixir_modules` table is constantly being tampered with an additional 
`before_hook` callback, all (depending on the luck) modules will have the new
`before_hook`.

This can be extended to other scenarios:
- Add a module attribute to all your modules
- General hooking yourself into the Elixir compiler without touching the
compiler code.
- ??? I can't imagine a good use case

