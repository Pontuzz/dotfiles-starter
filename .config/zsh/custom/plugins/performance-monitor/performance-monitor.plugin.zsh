# Performance Monitoring Plugin
# Track zsh startup performance and provide insights

# Enhanced zbench with detailed timing
function zbench () {
    local iterations=${1:-5}
    echo "Running $iterations zsh startup benchmarks..."
    echo "Time (real):"
    
    local total_time=0
    for i in {1..$iterations}; do
        local time_output=$(/usr/bin/time -f "%e" zsh -lic exit 2>&1)
        echo "  Run $i: ${time_output}s"
        total_time=$(echo "$total_time + $time_output" | bc -l)
    done
    
    local avg_time=$(echo "scale=3; $total_time / $iterations" | bc -l)
    echo "Average: ${avg_time}s"
    
    # Performance recommendations
    if (( $(echo "$avg_time > 2.0" | bc -l) )); then
        echo "⚠️  Slow startup detected (>2s). Consider:"
        echo "   - Removing unused plugins"
        echo "   - Using lazy loading for heavy tools"
        echo "   - Profiling with 'zprof'"
    elif (( $(echo "$avg_time > 1.0" | bc -l) )); then
        echo "⚡ Moderate startup time (1-2s). Room for improvement."
    else
        echo "🚀 Fast startup! (<1s)"
    fi
}

# Profile startup with zprof
zprof-startup() {
    echo "Profiling zsh startup with zprof..."
    zsh -ic 'zmodload zsh/zprof; source ~/.config/zsh/.zshrc; zprof | head -20'
}
