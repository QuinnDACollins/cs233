/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here 
	//First mask gets all the right counters for our algorithm
	unsigned left_counter_mask = 0xAAAAAAAA; // width 1
	//Second mask gets all the left counters for our algorithm
	unsigned right_counter_mask = 0x55555555; // width 1
	//Pulling the counters out of our input using our masks from above ^^^
	unsigned right_counters = input & right_counter_mask;
	unsigned left_counters = input & left_counter_mask;
	//in order to add the counters we have to line them up using bit shift to the right on the left ocunters
	left_counters = left_counters >> 1;

	input = left_counters + right_counters;
	
	right_counter_mask = 0x33333333; //width 2
	left_counter_mask = 0xCCCCCCCC; //width 2

	right_counters = input & right_counter_mask;
	left_counters = input & left_counter_mask;
	left_counters = left_counters >> 2;

	input = left_counters + right_counters;

	right_counter_mask = 0x0f0f0f0f;
	left_counter_mask = 0xf0f0f0f0;
	
	right_counters = input & right_counter_mask;
	left_counters = input & left_counter_mask;
	left_counters = left_counters>>4;

	input = left_counters + right_counters;

	right_counter_mask = 0x00ff00ff;
	left_counter_mask = 0xff00ff00;

	right_counters = input & right_counter_mask;
	left_counters = input & left_counter_mask;
	left_counters = left_counters>>8;

	input = left_counters + right_counters;

	right_counter_mask = 0x0000ffff;
	left_counter_mask = 0xffff0000;
	
	right_counters = input & right_counter_mask;
	left_counters = input & left_counter_mask;
	left_counters = left_counters>>16;

	input = left_counters + right_counters;
	return input;
}
