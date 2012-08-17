package Forum::Controller::showthread;
use Moose;
use namespace::autoclean;
use POSIX;
use Data::Page;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Forum::Controller::showthread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

my $g_thread_id;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $thread_id = $c->request->parameters->{thread_id};
    $g_thread_id = $c->request->parameters->{thread_id};
    my $threads_rs = $c->model('ForumDB::Thread')->search({thread_id => $thread_id});
    #Get all post with thread id 
    my $page = $c->request->param('page');
    $page = 1 if($page !~ /^\d+$/);
    my $posts_rs = $c->model('ForumDB::Post')->search({post_thread_id => $thread_id},{order_by => { -asc => 'post_created_date' }, rows => 5, page => $page,});
    @{$c->stash->{'posts'}} = $posts_rs->all();

    #pagging   
    my $pager = $posts_rs->pager;
    $pager->entries_per_page(5);
    $c->stash->{pager} = $pager;

    $c->stash(thread => $threads_rs->next, totalPost => $posts_rs->count, template => 'threadcontent.html');
}

sub thread_post :Local :Args(0) {
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
    #insert to databasee
    if ($c->req->params->{post_body}){
        my $posts_rs = $c->model('ForumDB::Post');
        my $newpost = eval { $posts_rs->create({
		    post_body => thread_filter_content ($c->req->params->{post_body}),
		    post_thread_id => $c->req->params->{threadid}, 
            post_owner => $user_rs->next->user_id,     
            post_image => $image_path,
	    }) };
        #update last_post_time in table thread
        my $posts = $posts_rs->search({post_thread_id => $c->req->params->{threadid}},{ order_by => { -desc => 'post_created_date' } });
        update_new_post($c, $posts->next->post_created_date, $c->req->params->{threadid});
    }
    if ( $c->req->params->{loggedinuser} eq 'guest'){
        $c->logout();
    }
    $c->res->redirect("../showthread?thread_id=".$c->req->params->{threadid});
}

sub update_new_post
{
    my($c, $post_time, $thread_id) = @_;
    my $thread_rs = $c->model('ForumDB::Thread')->update_or_create(
        {
            thread_id => $thread_id,
            last_post_time => $post_time,
        }
    );
}

sub delete_thread :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $thread_id = $c->req->params->{thread_id};
    #Delete all post of thread
    my $post_rs = $c->model('ForumDB::Post')->search( {post_thread_id => $thread_id} );
    $post_rs->delete();
    #delete thread
    my $thread_rs = $c->model('ForumDB::Thread')->search( {thread_id => $thread_id} );
    my $topic_id = $thread_rs->next->topic_id;
    $c->res->redirect("../showtopic?topic_id=".$topic_id);
    $thread_rs->delete();
}

sub delete_post :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $post_id = $c->req->params->{post_id};
    #Delete all post of thread
    my $post_rs = $c->model('ForumDB::Post')->search( {post_id => $post_id} );
    my $thread_id = $post_rs->next->post_thread_id;
    $c->res->redirect("../showthread?thread_id=".$thread_id);
    $post_rs->delete();  
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
