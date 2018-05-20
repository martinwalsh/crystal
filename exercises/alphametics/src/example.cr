module Alphametics
  extend self

  DIGITS = ('0'..'9').to_a

  def solve(equation)
    puzzle = Puzzle.new(equation)
    solution = {} of Char => Char
    solve(puzzle.columns, puzzle.words.map(&.[0]), solution)
    solution.map { |k, v| [k.to_s, v.to_i] }.to_h
  end

  # Solves individual columns from right to left (recursively),
  # potentially decreasing the problem space for subsequent columns.
  # This should provide slightly better performance than
  # brute-force, particularly for problems with few addends.
  #
  # A better performing algorithm would use properties of
  # the problem to increase contraints further (e.g. multiple
  # occurances of a given letter in addends or in addend and sum, etc).
  private def solve(columns, firsts, solution, remainder = 0)
    return true if columns.empty?
    column = columns.first # grab the first column (from right to left)
    digits = DIGITS.select { |d| !solution.has_value?(d) }
    unsolved = column.uniq.select { |c| !solution.has_key?(c) }

    # make a backup copy of the current partial
    # so that we can restore it when backtracking
    placeholder = solution.dup

    digits.each_permutation(unsolved.size, true) do |p|
      solution.merge!(unsolved.zip(p).to_h)
      next if solution.any? { |k, v| firsts.includes?(k) && v == '0' }
      carry, total = column.divmod(solution, remainder)
      return true if total == column.total(solution) && \
                        solve(columns[1..-1], firsts, solution, carry)
    # backtrack
    solution.clear
    solution.merge!(placeholder)
    end

    false
  end

  private struct Column
    @addends : Array(Char?)
    @total : Char?

    def initialize(@chars : Array(Char?))
      @addends = @chars[0..-2]
      @total = @chars.last
    end

    def divmod(map, remainder)
      (@addends.compact.map { |a| map[a].to_i }.sum + remainder).divmod(10)
    end

    def uniq
      @chars.compact.uniq
    end

    def total(map)
      map[@total].to_i
    end
  end

  private struct Puzzle
    getter columns
    getter firsts : Array(Char)

    def initialize(@equation : String)
      @columns = [] of Column
      reversed = words.map(&.reverse.chars)
      while !reversed.all?(&.compact.empty?)
        @columns << Column.new(reversed.map(&.shift?))
      end

      @firsts = words.map(&.[0]).uniq
    end

    def words
      @equation.scan(/[A-Z]+/).map(&.[0]).compact
    end
  end
end
