* Beware that tests expect to use UTC date in the code
* test/controllers/iteration_3_test.rb#148-151 doesn't work at night, need to add `Timecop.travel Time.new(2022, 1, 1) + 18.hours`
* Debrief: 
  * Good iteration to introduce
    * strategy + factory pattern
    * open/close
  * But it's too long: once we went through 1 strategy / kind and book strategies I don't see what we're learning more.
    * Let's divide the number of rules by 2?
  * What I could design further:
    * extract IsbnRepository
    * apply option/nullable pattern for pricing strategies