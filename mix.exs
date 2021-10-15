defmodule CompilerMess.MixProject do
  use Mix.Project

  def project do
    [
      app: :compiler_mess,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: [],
      compilers: Mix.compilers() ++ [:compiler_mess]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
