defmodule AOC do
  defmacro __using__(day: day) do
    quote do
      @input_dir "#{__DIR__}/inputs"
      def input() do
        filename = "#{unquote(day)}.txt"
        read_file(filename)
      end

      def sample_input() do
        filename = "sample_#{unquote(day)}.txt"
        read_file(filename)
      end

      defp read_file(filename) do
        @input_dir
        |> Path.join(filename)
        |> File.read!()
        |> String.split("\n", trim: true)
      end
    end
  end
end
