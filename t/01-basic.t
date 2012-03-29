use strict;
use warnings;

use Test::Tester;
use Bash::Completion::Plugin::Test;
use Test::Exception;
use Test::More;

throws_ok {
    Bash::Completion::Plugin::Test->new;
} qr/plugin parameter required/;

check_test(
    sub {
        my $tester = Bash::Completion::Plugin::Test->new(
            plugin => 'Bash::Completion::Plugins::TestPlugin',
        );

        $tester->check_completions('test-plugin ^',
            [qw/foo bar baz/], 'test all completions');
    },
    {
        ok   => 1,
        name => 'test all completions',
    },
    'test cursor after blank character',
);

check_test(
    sub {
        my $tester = Bash::Completion::Plugin::Test->new(
            plugin => 'Bash::Completion::Plugins::TestPlugin',
        );

        $tester->check_completions('test-plugin ^',
            [qw/foo baz/]);
    },
    {
        ok => 0,
    },
);

check_test(
    sub {
        my $tester = Bash::Completion::Plugin::Test->new(
            plugin => 'Bash::Completion::Plugins::TestPlugin',
        );

        $tester->check_completions('test-plugin f^',
            [qw/foo/]);
    },
    {
        ok => 1,
    },
);

done_testing;
