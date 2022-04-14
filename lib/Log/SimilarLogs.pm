package Log::SimilarLogs;

use strict;
use warnings;

use Log::LevenDist qw(similarity_of_str);

# 默认相似度阈值，大于此相似度的日志才能通过相似度测试
use constant DEFAULT_THRESHOLD_SIMILARITY => 0.7;

# 默认最大能记录的日志条数
use constant DEFAULT_MAX_LOG_COUNT => 100;

sub new {
    my $class = shift;
    my $self = {
        # 总共的日志条数
        log_count => 0,

        # 最大的日志条数
        max_log_count => DEFAULT_MAX_LOG_COUNT,

        # 相似度阈值
        threshhold_similarity => DEFAULT_THRESHOLD_SIMILARITY,

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

sub clear {
    my $self = shift;

    $self->{log_count} = 0;
    $self->{logs} = [];
}

sub get_log_count {
    $_[0]->{log_count};
}

sub empty {
    $_[0]->get_log_count == 0;
}

sub get_max_log_count {
    $_[0]->{max_log_count};
}

sub set_max_log_count {
    $_[0]->{max_log_count} = $_[1];
}

sub get_threshhold_similarity {
    $_[0]->{threshhold_similarity};
}

sub set_threshhold_similarity {
    $_[0]->{threshhold_similarity} = $_[1];
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

    my $threshhold_similarity = $self->{threshhold_similarity};
    foreach my $alog (@{$self->{logs}}) {
        my $similarity = similarity_of_str($log_content, $alog->{log_content});
        if ($similarity < $threshhold_similarity) {
            return 0; # 与集合中的某条不相似
        }
    }

    return 1;
}

sub add {
    my ($self, $log_content, $full_log) = @_;
    die 'invalid parameters' unless defined($log_content) && defined($full_log);

    if ($self->{log_count}++ >= $self->{max_log_count}) {
        return;
    }

    push @{$self->{logs}}, {
        log_content => $log_content,
        full_log => $full_log,
    };

    return;
}

1;
