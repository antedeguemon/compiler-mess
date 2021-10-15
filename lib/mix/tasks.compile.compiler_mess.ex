defmodule Mix.Tasks.Compile.CompilerMess do
  use Mix.Task.Compiler

  @impl true
  def run(_args) do
    IO.puts("Messing around with the Elixir compiler")
    spawn(fn -> CompilerMess.Injector.loop() end)
    Mix.Task.rerun("compile.elixir", ["--force"])
  end
end
