defmodule WordFrequency do

  def wordCount(readFile) do
     readFile
     |> words
     |> count
     |> tocsv
  end

  defp words(file) do
    file
    |> File.stream!
    |> Stream.map(&String.trim_trailing(&1))
    |> Stream.map(&String.split(&1,~r{[^A-Za-z0-9_]}))
    |> Enum.to_list
    |> List.flatten
    |> Enum.map(&String.downcase(&1))
  end

  defp count(words) when is_list(words) do
    Enum.reduce(words, %{}, &update_count/2)
  end

  defp update_count(word, acc) do
    Map.update acc, String.to_atom(word), 1, &(&1 + 1)
  end

  defp tocsv(map) do
    File.open("wordFreq.csv", [:write, :utf8], fn(file) ->
      Enum.each(map, &IO.write(file, Enum.join(Tuple.to_list(&1), ", ")<>"\n"))
    end)
  end

end

WordFrequency.wordCount("text.txt")
