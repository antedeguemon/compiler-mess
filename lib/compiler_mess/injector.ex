defmodule CompilerMess.Injector do
  @probe_module CompilerMess.Probe

  def loop(seen_modules \\ []) do
    case :ets.tab2list(:elixir_modules) do
      [] ->
        unless length(seen_modules) > 0 and is_nil(Process.get(Mix.Compilers.Elixir)) do
          loop(seen_modules)
        end

      [_ | _] = modules ->
        seen_modules = inject(modules, seen_modules) ++ seen_modules
        loop(seen_modules)
    end
  end

  defp inject(modules, seen_modules) do
    Enum.map(modules, fn
      {@probe_module, _, _, _, _} ->
        nil

      {module, {_set, bag}, _, _source, _} ->
        unless module in seen_modules do
          IO.puts("Injected @before_compile into #{module}")

          :ets.insert(
            bag,
            {{:accumulate, :before_compile}, {@probe_module, :__before_compile__}}
          )

          module
        end
    end)
  end
end
