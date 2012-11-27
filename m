From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix writeback race with file that is growing
Date: Tue, 27 Nov 2012 06:04:32 -0500
Message-ID: <20121127060432.410f0dfc@tlielax.poochiereds.net>
References: <1353945484-27415-1-git-send-email-jlayton@redhat.com>
	<50B46641.70402@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ungifted01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B46641.70402-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Nov 2012 12:35:37 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 11/26/2012 09:28 PM, Jeff Layton wrote:
> > Commit eddb079deb4 created a regression in the writepages codepath.
> > Previously, whenever it needed to check the size of the file, it did so
> > by consulting the inode->i_size field directly. With that patch, the
> > i_size was fetched once on entry into the writepages code and that value
> > was used henceforth.
> > 
> > If the file is changing size though (for instance, if someone is writing
> > to it or has truncated it), then that value is likely to be wrong. This
> > can lead to data corruption. Pages past the EOF at the time that the
> > writepages call was issued may be silently dropped and ignored because
> > cifs_writepages wrongly assumes that the file must have been truncated
> > in the interim.
> > 
> > Fix cifs_writepages to properly fetch the size from the inode->i_size
> > field instead to properly account for this possibility.
> > 
> > Reported-and-Tested-by: Maxim Britov <ungifted01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/file.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index edb25b4..70b6f4c 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1794,7 +1794,6 @@ static int cifs_writepages(struct address_space *mapping,
> >  	struct TCP_Server_Info *server;
> >  	struct page *page;
> >  	int rc = 0;
> > -	loff_t isize = i_size_read(mapping->host);
> >  
> >  	/*
> >  	 * If wsize is smaller than the page cache size, default to writing
> > @@ -1899,7 +1898,7 @@ retry:
> >  			 */
> >  			set_page_writeback(page);
> >  
> > -			if (page_offset(page) >= isize) {
> > +			if (page_offset(page) >= i_size_read(mapping->host)) {
> >  				done = true;
> >  				unlock_page(page);
> >  				end_page_writeback(page);
> > @@ -1932,7 +1931,8 @@ retry:
> >  		wdata->offset = page_offset(wdata->pages[0]);
> >  		wdata->pagesz = PAGE_CACHE_SIZE;
> >  		wdata->tailsz =
> > -			min(isize - page_offset(wdata->pages[nr_pages - 1]),
> > +			min(i_size_read(mapping->host) -
> > +			    page_offset(wdata->pages[nr_pages - 1]),
> >  			    (loff_t)PAGE_CACHE_SIZE);
> 
> Good catch. Looks correct to me. Wondering whether we would need a
> similar fix in cifs_write_begin() where we get the i_size and then
> immediately do check whether the page lies beyond EOF?
> 
> 

Thanks, I should also mention that this was reported here:

    https://bugzilla.kernel.org/show_bug.cgi?id=50991

Regarding cifs_write_begin, I don't think so. The code does not sleep
between the point where the i_size is fetched and then later used. If
there is a race window there, it's very small.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
