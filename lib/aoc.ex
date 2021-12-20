defmodule AOC do
  defmacro __using__(day: day) do
    quote do
      @input_dir "#{__DIR__}/inputs"
      def input() do
        :input
        |> input_filename()
        |> read_file()
      end

      def sample_input() do
        :sample
        |> input_filename()
        |> read_file()
      end

      def raw_input(name) do
        name
        |> input_filename()
        |> then(fn filename -> Path.join(@input_dir, filename) end)
        |> File.read!()
      end

      def input_filename(:sample), do: "sample_#{unquote(day)}.txt"
      def input_filename(:input), do: "#{unquote(day)}.txt"

      defp read_file(filename) do
        @input_dir
        |> Path.join(filename)
        |> File.read!()
        |> String.split("\n", trim: true)
      end
    end
  end
end
