function BenchTable(result::BenchmarkResult)
    
    data = [BenchRow(m) for m in result.methods]
    pretty_table(data)

end