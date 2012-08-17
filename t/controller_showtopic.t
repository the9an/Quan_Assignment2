use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Forum';
use Forum::Controller::showtopic;

ok( request('/showtopic')->is_success, 'Request should succeed' );
done_testing();
