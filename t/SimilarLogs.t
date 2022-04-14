use warnings;
use strict;

use Test::More;

BEGIN { use_ok('Log::SimilarLogs') };

sub test_and_add {
    my ($similar_logs, $log_content, $full_log) = @_;

    if (!$similar_logs->test($log_content, $full_log)) {
        return 0;
    }

    $similar_logs->add($log_content, $full_log);
    return 1;
}

my $similar_logs = Log::SimilarLogs->new;

ok($similar_logs->empty);

ok(test_and_add(
    $similar_logs,
    'start worker processes',
    '2020/03/26 13:00:11 [notice] 24496#0: start worker processes'));

ok(test_and_add(
    $similar_logs,
    'start worker process 24497',
    '2020/03/26 13:00:11 [notice] 24496#0: start worker process 24497'));

ok(test_and_add(
    $similar_logs,
    'start worker process 24498',
    '2020/03/26 13:00:11 [notice] 24496#0: start worker process 24498'));

is($similar_logs->get_log_count, 3);

done_testing;
