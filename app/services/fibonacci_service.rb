class FibonacciService
  def self.calculate(n)
    return n if n <= 1

    a, b = 0, 1
    (n - 1).times do
      a, b = b, a + b
    end
    b
  end
end
