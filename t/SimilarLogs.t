use warnings;
use strict;

use Test::More;

BEGIN { use_ok('Log::SimilarLogs') };

my $similar_logs = Log::SimilarLogs->new;

$similar_logs->add('test', 'test');

done_testing;
