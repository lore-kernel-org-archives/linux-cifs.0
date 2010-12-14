From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/13] cifs: don't fail writepages on -EAGAIN errors
Date: Tue, 14 Dec 2010 07:18:20 -0500
Message-ID: <20101214071820.2aa4936b@tlielax.poochiereds.net>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-2-git-send-email-jlayton@redhat.com>
	<4D07383A.6000400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D07383A.6000400-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 14:56:18 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 12/10/2010 09:14 PM, Jeff Layton wrote:
> > If CIFSSMBWrite2 returns -EAGAIN, then the error should be considered
> > temporary. CIFS should retry the write instead of setting an error on
> > the mapping and returning.
> > 
> > For WB_SYNC_ALL, just retry the write immediately.
> > 
> > In the WB_SYNC_NONE case, call redirty_page_for_writeback on all of the
> > pages that didn't get written out and then move on.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/file.c |   23 +++++++++++------------
> >  1 files changed, 11 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index fe16f6d..8e57370 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1430,6 +1430,7 @@ retry:
> >  				break;
> >  		}
> >  		if (n_iov) {
> > +retry_write:
> >  			open_file = find_writable_file(CIFS_I(mapping->host),
> >  							false);
> >  			if (!open_file) {
> > @@ -1445,22 +1446,20 @@ retry:
> >  				cifs_update_eof(cifsi, offset, bytes_written);
> >  			}
> >  
> > -			if (rc || bytes_written < bytes_to_write) {
> > -				cERROR(1, "Write2 ret %d, wrote %d",
> > -					  rc, bytes_written);
> > -				mapping_set_error(mapping, rc);
> > -			} else {
> > +			/* retry on data-integrity flush */
> > +			if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
> > +				goto retry_write;
> > +
> > +			if (!rc)
> >  				cifs_stats_bytes_written(tcon, bytes_written);
> > -			}
> > +			else if (rc != -EAGAIN)
> > +				mapping_set_error(mapping, rc);
> >  
> >  			for (i = 0; i < n_iov; i++) {
> >  				page = pvec.pages[first + i];
> > -				/* Should we also set page error on
> > -				success rc but too little data written? */
> > -				/* BB investigate retry logic on temporary
> > -				server crash cases and how recovery works
> > -				when page marked as error */
> > -				if (rc)
> > +				if (rc == -EAGAIN)
> > +					redirty_page_for_writepage(wbc, page);
> > +				else if (rc != 0)
> >  					SetPageError(page);
> >  				kunmap(page);
> >  				unlock_page(page);
> 
> Documentation/filesystems/Locking suggests that rc should be set to 0
> after redirtying?
> 
> 

Ahh good catch. I'll fix it.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
