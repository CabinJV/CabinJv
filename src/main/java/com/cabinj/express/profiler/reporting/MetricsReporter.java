package com.cabinj.express.profiler.reporting;

import com.cabinj.express.profiler.ServerProfiler;

/**
 * Interface for metrics reporting implementations
 */
public interface MetricsReporter {
    /**
     * Report metrics from the provided snapshot
     */
    void report(ServerProfiler.ProfilerSnapshot snapshot);
}