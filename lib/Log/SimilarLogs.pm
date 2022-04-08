package Log::SimilarLogs;

use strict;
use warnings;

# 相似度阈值，大于此相似度的日志才能通过相似度测试
use constant THRESHOLD_SIMIMLARITY => 0.9;

# 最大能记录的日志条数
use constant MAX_LOGS => 100;

sub new {
    my $class = shift;
    my $self = {
        # 总共的日志条数
        total_logs => 0,

        # 具体的日志记录
        logs => [
            # {
            #     log_content => '',
            #     full_log => '',
            # },
        ],
    };

    bless $self, $class;
}

sub test {
    my ($self, $log_content, $full_log) = @_;
    die 'invalid parameters' unless defined($log_content) && defined($full_log);

    foreach my $alog (@{$self->{logs}}) {
        print "$alog->{log_content}\n";
    }
}

sub add {
    my ($self, $log_content, $full_log) = @_;
    die 'invalid parameters' unless defined($log_content) && defined($full_log);

    if ($self->{total_logs}++ >= MAX_LOGS) {
        return;
    }

    push @{$self->{logs}}, {
        log_content => $log_content,
        full_log => $full_log,
    };

    return;
}

1;
