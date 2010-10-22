From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/13] cifs: eliminate cifsInodeInfo->write_behind_rc
Date: Fri, 22 Oct 2010 14:20:09 -0400
Message-ID: <20101022142009.7e50632e@tlielax.poochiereds.net>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
	<1287171248-464-14-git-send-email-jlayton@redhat.com>
	<1287771090.18228.30.camel@shaggy-w500>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287771090.18228.30.camel@shaggy-w500>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Oct 2010 13:11:30 -0500
Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> On Fri, 2010-10-15 at 15:34 -0400, Jeff Layton wrote:
> > write_behind_rc is redundant and just adds complexity to the code. What
> > we really want to do instead is to use mapping_set_error to reset the
> > flags on the mapping when we find a writeback error and can't report it
> > to userspace yet.
> > 
> > For cifs_flush and cifs_fsync, we shouldn't reset the flags since errors
> > returned there do get reported to userspace.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> > ---
> >  fs/cifs/cifsfs.c   |    1 -
> >  fs/cifs/cifsglob.h |    1 -
> >  fs/cifs/file.c     |   34 ++++++++--------------------------
> >  fs/cifs/inode.c    |   15 +++++----------
> >  4 files changed, 13 insertions(+), 38 deletions(-)
> 
>   --- snip ---
> 
> > @@ -1639,10 +1632,8 @@ int cifs_fsync(struct file *file, int datasync)
> > 
> >  	rc = filemap_write_and_wait(inode->i_mapping);
> >  	if (rc == 0) {
> > -		rc = CIFS_I(inode)->write_behind_rc;
> > -		CIFS_I(inode)->write_behind_rc = 0;
> >  		tcon = tlink_tcon(smbfile->tlink);
> > -		if (!rc && tcon && smbfile &&
> > +		if (rc == 0 &&
> 
> The above is redundant now, isn't it?  We no longer set rc since the
> last test.
> 
> >  		   !(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> >  			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> >  	}
> 

Yeah, duh. Good catch.

Steve, should I respin that one?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
