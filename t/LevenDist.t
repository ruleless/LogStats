use strict;
use warnings;
use Test::More;

use Log::LevenDist qw(leven_dist similarity_of_str);

is(leven_dist('this is a simple string', 'this is a simple string'), 0);

# addition
is(leven_dist('is a simple string', 'this is a simple string'), 5);

# deletion
is(leven_dist('this is a simple string', 'is a simple string'), 5);

# replacement
is(leven_dist('this is a simple string', 'that is a simple string'), 2);

done_testing;
