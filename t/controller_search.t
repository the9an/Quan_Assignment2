use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Forum';
use Forum::Controller::search;

ok( request('/search')->is_success, 'Request should succeed' );
done_testing();
