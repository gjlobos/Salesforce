global class RickAndMortyLocationScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        RickAndMortyLocationBatch batch = new RickAndMortyLocationBatch();
        Database.executeBatch(batch, 10);  
    }
    
    // Static method to schedule the batch
    public static void scheduleBatch() {
        String cronExp = '0 0 9,19 ? * MON,WED *'; // 9 AM and 7 PM on Mondays and Wednesdays
        RickAndMortyLocationScheduler sched = new RickAndMortyLocationScheduler();
        System.schedule('RickAndMortyLocationScheduler', cronExp, sched);
    }
}