package Log::SimilarLogs;

use strict;
use warnings;

use Log::LevenDist qw(similarity_of_str);

# 相似度阈值，大于此相似度的日志才能通过相似度测试
use constant THRESHOLD_SIMIMLARITY => 0.7;

# 最大能记录的日志条数
use constant MAX_LOGS => 100;

sub new {
    my $class = shift;
    my $self = {
        # 总共的日志条数
        log_count => 0,

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

sub get_log_count {
    my $self = shift;
    return $self->{log_count};
}

sub empty {
    my $self = shift;
    return $self->get_log_count == 0;
}

sub for_each {
    my ($self, $fn) = @_;
    die 'expect callback' unless ref($fn) == ref(sub {});

    foreach (@{$self->{logs}}) {
        my $continue_or_not = $fn->($_);
        last unless $continue_or_not;
    }
}

sub test {
    my ($self, $log_content) = @_;
    die 'invalid parameters' unless defined($log_content);

    if ($self->empty) {
        return 1;
    }

    foreach my $alog (@{$self->{logs}}) {
        my $similarity = similarity_of_str($log_content, $alog->{log_content});
        if ($similarity < THRESHOLD_SIMIMLARITY) {
            return 0; # 与集合中的某条不相似
        }
    }

    return 1;
}

sub add {
    my ($self, $log_content, $full_log) = @_;
    die 'invalid parameters' unless defined($log_content) && defined($full_log);

    if ($self->{log_count}++ >= MAX_LOGS) {
        return;
    }

    push @{$self->{logs}}, {
        log_content => $log_content,
        full_log => $full_log,
    };

    return;
}

1;
