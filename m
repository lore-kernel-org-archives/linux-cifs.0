From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Always update the dentry cache with fresh readdir()
 results
Date: Fri, 06 Jul 2012 09:31:07 +1000
Message-ID: <1341531067.22307.26.camel@obed>
References: <1341477507.22307.21.camel@obed>
	 <1341482567.22307.22.camel@obed>
	 <20120705072401.7eb1a7ee@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>,
	Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120705072401.7eb1a7ee-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-07-05 at 07:24 -0400, Jeff Layton wrote:
> On Thu, 05 Jul 2012 20:02:47 +1000
> Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > (CCing in the original reporter)
> > 
> > On Thu, 2012-07-05 at 18:38 +1000, Andrew Bartlett wrote:
> > > When we do a readdir() in CIFS, we are potentially efficiently
> > > collecting a great deal of current, catchable stat information.
> > > 
> > > It is important that we always keep the dentry cache current for two
> > > reasons:
> > >  - the information may have changed (within the actime timeout).
> > >  - if we still have a dentry cache value after that timeout, it is quite
> > > expensive (1xRTT per entry) to find out if it was still correct.
> > > 
> > > This hits folks who are using CIFS over a WAN very badly.  For example
> > > on an emulated 50ms delay I would have ls --color complete in .1
> > > seconds, and a second run take 4.5 seconds, as each stat() (for the
> > > colouring) would create a trans2 query_path_info query for each file,
> > > right after getting the same information in the trans2 find_first2.
> > > 
> > > This patch implements the simplest approach, I would welcome a
> > > correction on if there is a better approach than d_drop() and dput().
> > > 
> > > Tested on 3.4.4-3.cifsrevalidate.fc17.i686 with a 50ms WANem emulated
> > > WAN against Samba 4.0 beta3.
> > > 
> > > Thanks,
> > > 
> > > Andrew Bartlett
> > 
> 
> Nice work tracking that down and coding up the patch. While it's not
> incorrect to drop the dentry here, we can be a little more efficient
> here and just update the inode in place if the uniqueid didn't change.
> 
> Something like this (untested) patch should do it. Could you test this
> and let me know if it also helps?

Is it really safe to update so much without getting a lock over all the
updates?

/* populate an inode with info from a cifs_fattr struct */
void
cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
{
	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
	unsigned long oldtime = cifs_i->time;

	cifs_revalidate_cache(inode, fattr);

	inode->i_atime = fattr->cf_atime;
	inode->i_mtime = fattr->cf_mtime;
	inode->i_ctime = fattr->cf_ctime;
	inode->i_rdev = fattr->cf_rdev;
	set_nlink(inode, fattr->cf_nlink);
	inode->i_uid = fattr->cf_uid;
	inode->i_gid = fattr->cf_gid;

	/* if dynperm is set, don't clobber existing mode */
	if (inode->i_state & I_NEW ||
	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
		inode->i_mode = fattr->cf_mode;

	cifs_i->cifsAttrs = fattr->cf_cifsattrs;

	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
		cifs_i->time = 0;
	else
		cifs_i->time = jiffies;

	cFYI(1, "inode 0x%p old_time=%ld new_time=%ld", inode,
		 oldtime, cifs_i->time);

	cifs_i->delete_pending = fattr->cf_flags & CIFS_FATTR_DELETE_PENDING;

	cifs_i->server_eof = fattr->cf_eof;
	/*
	 * Can't safely change the file size here if the client is writing to
	 * it due to potential races.
	 */
	spin_lock(&inode->i_lock);
	if (is_size_safe_to_change(cifs_i, fattr->cf_eof)) {
		i_size_write(inode, fattr->cf_eof);

		/*
		 * i_blocks is not related to (i_size / i_blksize),
		 * but instead 512 byte (2**9) size is required for
		 * calculating num blocks.
		 */
		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
	}
	spin_unlock(&inode->i_lock);

	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
		inode->i_flags |= S_AUTOMOUNT;
	cifs_set_ops(inode);
}

That is, I think the spin_lock() needs to be moved to the top of
cifs_fattr_to_inode().  How is this safe for the current callers?

The equivalent code in NFS does this:

int nfs_refresh_inode(struct inode *inode, struct nfs_fattr *fattr)
{
	int status;

	if ((fattr->valid & NFS_ATTR_FATTR) == 0)
		return 0;
	spin_lock(&inode->i_lock);
	status = nfs_refresh_inode_locked(inode, fattr);
	spin_unlock(&inode->i_lock);

	return status;
}

In our case it will be more difficult, as cifs_fattr_to_inode() takes
the inode->i_lock (but only for some updates).

I agree that it is important to call cifs_fattr_to_inode, because it is
critical to call cifs_revalidate_cache(), to flush the fscache and to
flush any cached pages. 

Andrew Bartlett

> -------------------------[snip]--------------------------
> 
> cifs: always update the inode cache with the results from a FIND_*
> 
> When we get back a FIND_FIRST/NEXT result, we have some info about the
> dentry that we use to instantiate a new inode. We were ignoring and
> discarding that info when we had an existing dentry in the cache.
> 
> Fix this by updating the inode in place when we find an existing dentry
> and the uniqueid is the same.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # .31.x
> Reported-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Reported-by: Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
> Reported-by: Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/readdir.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 0a8224d..a4217f0 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -86,9 +86,12 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
>  
>  	dentry = d_lookup(parent, name);
>  	if (dentry) {
> -		/* FIXME: check for inode number changes? */
> -		if (dentry->d_inode != NULL)
> +		inode = dentry->d_inode;
> +		/* update inode in place if i_ino didn't change */
> +		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
> +			cifs_fattr_to_inode(inode, fattr);
>  			return dentry;
> +		}
>  		d_drop(dentry);
>  		dput(dentry);
>  	}

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
