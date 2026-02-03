use v5.42;
use strictures 2;
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing note ok subtest );
use Test2::Tools::Exception qw( lives );
use UUID                    qw( uuid4 );

use GL::Types ();

subtest 'valid' => sub {
  ok(
    lives {
      GL::Org->new(id => uuid4, meta => GL::Meta->new, name => uuid4);
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

done_testing;

__END__
