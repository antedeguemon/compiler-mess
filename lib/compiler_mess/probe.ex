defmodule CompilerMess.Probe do
  defmacro __before_compile__(_env) do
    quote do
      def injected?, do: true
      def inspect, do: Enum.random(["Moooh!", "Ouch.", "Hey, that hurts..."])
    end
  end
end
