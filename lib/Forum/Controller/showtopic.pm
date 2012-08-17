package Forum::Controller::showtopic;
use Moose;
use namespace::autoclean;
use POSIX;
use Data::Page;
use DateTime;
use DateTime::Duration;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Forum::Controller::showtopic - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $topic_id = $c->request->parameters->{topic_id};
    my $page = $c->request->param('page');
    $page = 1 if($page !~ /^\d+$/);
    #Get all thread with topic id 
    #Make a list of topics page, where threads with latest posts are shown first.
    my $threads_rs = $c->model('ForumDB::Thread')->search({topic_id => $topic_id},{order_by => { -desc => 'last_post_time' }, rows => 10, page => $page,});
    @{$c->stash->{'threads'}} = $threads_rs->all();
   # my $diff  = time() - str2time($threads_rs->next->last_post_time);
    #my $thu = strftime "%a %b %e %H:%M:%S %Y", time();

    my $pager = $threads_rs->pager;
    $pager->entries_per_page(10);
    $c->stash->{pager} = $pager;
    $c->stash(topicid => $c->request->parameters->{topic_id}, template => 'threads.html');
}

sub create_thread :Local :Args(0) 
{
    my ( $self, $c ) = @_;
    $c->stash(topicid => $c->req->params->{topic_id}, template => 'postnewthread.html');
}

sub post_new_thread :Local :Args(0) 
{
    my ( $self, $c ) = @_;
    #get current user_id via user_name
    my $user_rs = $c->model('ForumDB::User')->search({user_name => $c->req->params->{loggedinuser}});
    #Upload image
    my $image_path;
    if ( my $upload = $c->request->upload('upload_image') ) {
        my $filename = $upload->filename;
        my $target   = $c->config->{upload_abs}."/$filename";
        my $file_uri = $c->config->{upload_dir}."/$filename";
        $image_path = $file_uri;      
        unless ($upload->link_to( $target) || $upload->copy_to($target)) {
                 die ("Failed to copy '$filename' to '$target': $!");    
        }
    }
    my $topic_id = $c->req->params->{topic_id};
    #insert to databasee
    if ($c->req->params->{post_body}){
        my $today = DateTime->now();
        my $threads_rs = $c->model('ForumDB::Thread');
        my $newthread = eval { $threads_rs->create({
		    thread_content => thread_filter_content ($c->req->params->{thread_body}),
		    topic_id => $topic_id, 
            topic_owner => $user_rs->next->user_id,    
            thread_title =>  thread_filter_content ($c->req->params->{thread_title}),
            thread_created_date => $today,
            last_post_time => $today,
            thread_image => $image_path,
	    }) };
    }
    $c->res->redirect("../showtopic?topic_id=".$topic_id);
}

sub thread_filter_content {
	my $body = $_[0];
	$body =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;	
	return $body;
}

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
