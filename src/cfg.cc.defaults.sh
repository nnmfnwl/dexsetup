# dexsetup try to reserve 1 CPU cores for other system resources
cc_cpu_cores_reserve=1
# even if CPU has only 1 CPU core which supposed to be all reserved by above variable, it creates 2 jobs because minimal is 2
cc_cpu_jobs_min=2
