From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Make cifs_fsync work with strict cache mode
 (try #2)
Date: Sun, 28 Nov 2010 06:52:26 -0500
Message-ID: <20101128065226.7e504362@tlielax.poochiereds.net>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-5-git-send-email-piastryyy@gmail.com>
	<20101128064219.7ca2274c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101128064219.7ca2274c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 28 Nov 2010 06:42:19 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Sun, 28 Nov 2010 11:12:50 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Remove filemap_write_and_wait call because it is previously called from
> > vfs_sync_range and invalidate inode if we don't have at least Level II
> > oplock and strcit cache mode switched on.
> > 
> 
> I think you mean vfs_fsync_range?
> 
> > Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  fs/cifs/file.c |   14 +++++++-------
> >  1 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index f853bf0..22d0421 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1595,20 +1595,20 @@ int cifs_fsync(struct file *file, int datasync)
> >  	struct cifsTconInfo *tcon;
> >  	struct cifsFileInfo *smbfile = file->private_data;
> >  	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> >  
> >  	xid = GetXid();
> >  
> >  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
> >  		file->f_path.dentry->d_name.name, datasync);
> >  
> > -	rc = filemap_write_and_wait(inode->i_mapping);
> > -	if (rc == 0) {
> > -		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> > +	if (!CIFS_I(inode)->clientCanCacheRead &&
> > +	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
> > +		invalidate_remote_inode(inode);
> >  
> > -		tcon = tlink_tcon(smbfile->tlink);
> > -		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> > -			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> > -	}
> > +	tcon = tlink_tcon(smbfile->tlink);
> > +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> > +		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> >  
> >  	FreeXid(xid);
> >  	return rc;
> 
> 
> Looks reasonable. I like the fact that we're pulling out the
> unnecessary filemap_write_and_wait here.
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Actually...I must withdraw this Reviewed-by until I understand how this
is expected to mesh with fscache.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
