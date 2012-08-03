From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: locking around modifications to i_nlink
Date: Fri, 3 Aug 2012 07:00:29 -0400
Message-ID: <20120803070029.23ee1500@corrin.poochiereds.net>
References: <CAH2r5muYbJrPYXtnAikVt1Sf_O7bdGsH7qLs=vjJ_EALXJDeQg@mail.gmail.com>
	<20120727135745.75a95171@tlielax.poochiereds.net>
	<87B676B3-14E0-4BB9-AA3C-01A97DBA9F90@gmail.com>
	<CAH2r5mutUBecG+2_BzsCbioj1kJjgtsWQLv0Ji+hxk_wTV+rcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mutUBecG+2_BzsCbioj1kJjgtsWQLv0Ji+hxk_wTV+rcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 3 Aug 2012 01:04:36 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> How about this simple updated version of Pavel's patch - adds spinlock
> calls around the other places that nlink is touched in cifs, in one
> place simply moving an existing spin_lock a bit earlier to cover more
> of the update of the inode.
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 7354877..cb79c7e 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -124,10 +124,10 @@ cifs_fattr_to_inode(struct inode *inode, struct
> cifs_fattr *fattr)
>  {
>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> -	unsigned long oldtime = cifs_i->time;
> 
>  	cifs_revalidate_cache(inode, fattr);
> 
> +	spin_lock(&inode->i_lock);
>  	inode->i_atime = fattr->cf_atime;
>  	inode->i_mtime = fattr->cf_mtime;
>  	inode->i_ctime = fattr->cf_ctime;
> @@ -148,9 +148,6 @@ cifs_fattr_to_inode(struct inode *inode, struct
> cifs_fattr *fattr)
>  	else
>  		cifs_i->time = jiffies;
> 
> -	cFYI(1, "inode 0x%p old_time=%ld new_time=%ld", inode,
> -		 oldtime, cifs_i->time);
> -
>  	cifs_i->delete_pending = fattr->cf_flags & CIFS_FATTR_DELETE_PENDING;
> 
>  	cifs_i->server_eof = fattr->cf_eof;
> @@ -158,7 +155,6 @@ cifs_fattr_to_inode(struct inode *inode, struct
> cifs_fattr *fattr)
>  	 * Can't safely change the file size here if the client is writing to
>  	 * it due to potential races.
>  	 */
> -	spin_lock(&inode->i_lock);
>  	if (is_size_safe_to_change(cifs_i, fattr->cf_eof)) {
>  		i_size_write(inode, fattr->cf_eof);
> 
> @@ -859,12 +855,14 @@ struct inode *cifs_root_iget(struct super_block *sb)
> 
>  	if (rc && tcon->ipc) {
>  		cFYI(1, "ipc connection - fake read inode");
> +		spin_lock(&inode->i_lock);
>  		inode->i_mode |= S_IFDIR;
>  		set_nlink(inode, 2);
>  		inode->i_op = &cifs_ipc_inode_ops;
>  		inode->i_fop = &simple_dir_operations;
>  		inode->i_uid = cifs_sb->mnt_uid;
>  		inode->i_gid = cifs_sb->mnt_gid;
> +		spin_unlock(&inode->i_lock);
>  	} else if (rc) {
>  		iget_failed(inode);
>  		inode = ERR_PTR(rc);
> @@ -1110,6 +1108,15 @@ undo_setattr:
>  	goto out_close;
>  }
> 
> +/* copied from fs/nfs/dir.c with small changes */
> +static void
> +cifs_drop_nlink(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	if (inode->i_nlink > 0)
> +		drop_nlink(inode);
> +	spin_unlock(&inode->i_lock);
> +}
> 
>  /*
>   * If dentry->d_inode is null (usually meaning the cached dentry
> @@ -1166,13 +1173,13 @@ retry_std_delete:
>  psx_del_no_retry:
>  	if (!rc) {
>  		if (inode)
> -			drop_nlink(inode);
> +			cifs_drop_nlink(inode);
>  	} else if (rc == -ENOENT) {
>  		d_drop(dentry);
>  	} else if (rc == -ETXTBSY) {
>  		rc = cifs_rename_pending_delete(full_path, dentry, xid);
>  		if (rc == 0)
> -			drop_nlink(inode);
> +			cifs_drop_nlink(inode);
>  	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
>  		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
>  		if (attrs == NULL) {
> @@ -1241,9 +1248,10 @@ cifs_mkdir_qinfo(struct inode *inode, struct
> dentry *dentry, umode_t mode,
>  	 * setting nlink not necessary except in cases where we failed to get it
>  	 * from the server or was set bogus
>  	 */
> +	spin_lock(&dentry->d_inode->i_lock);
>  	if ((dentry->d_inode) && (dentry->d_inode->i_nlink < 2))
>  		set_nlink(dentry->d_inode, 2);
> -
> +	spin_unlock(&dentry->d_inode->i_lock);
>  	mode &= ~current_umask();
>  	/* must turn on setgid bit if parent dir has it */
>  	if (inode->i_mode & S_ISGID)
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 09e4b3a..e6ce3b1 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -433,7 +433,9 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
>  	if (old_file->d_inode) {
>  		cifsInode = CIFS_I(old_file->d_inode);
>  		if (rc == 0) {
> +			spin_lock(&old_file->d_inode->i_lock);
>  			inc_nlink(old_file->d_inode);
> +			spin_unlock(&old_file->d_inode->i_lock);
>  /* BB should we make this contingent on superblock flag NOATIME? */
>  /*			old_file->d_inode->i_ctime = CURRENT_TIME;*/
>  			/* parent dir timestamps will update from srv
> 

Looks like that will cover all of the i_nlink cases. I think there's
some further cleanup to do in this area though.

For instance, cifs_mkdir_qinfo does a bunch of updates to the inode
*after* connecting it to the dentry. It would probably be best to do
those before to ensure there are no races.

It might not also hurt to make it use cifs_fattr_to_inode instead of
mucking with the inode fields directly to ensure that all of the
locking is consistent.

Anyway...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
