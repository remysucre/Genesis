import Profiling

main = do
    buildProj "gcSimulator"
    stats <- benchmark "gcSimulator" 1
    print stats
