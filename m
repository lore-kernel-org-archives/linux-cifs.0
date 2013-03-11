From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: delay super block destruction until all
 cifsFileInfo objects are gone
Date: Mon, 11 Mar 2013 07:41:07 -0400
Message-ID: <20130311074107.5aa6374d@tlielax.poochiereds.net>
References: <20130308153002.GC1511@mguzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
To: Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130308153002.GC1511-v5fTkemuj/HkZJWtSm8s3NvLeJWuRmrY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 8 Mar 2013 16:30:03 +0100
Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> cifsFileInfo objects hold references to dentries and it is possible that
> these will still be around in workqueues when VFS decides to kill super
> block during unmount.
> 

FWIW, this doesn't even need to be sitting in a workqueue when it comes
to readahead. We may have sprayed out a bunch of readahead requests and
are simply waiting on the replies. We hold a reference to the dentry at
that point, but not one to the vfsmount, so a umount can get started
before those replies come in.

That's almost certainly the problem that Ben hit...

> This results in panics like this one:
> BUG: Dentry ffff88001f5e76c0{i=66b4a,n=1M-2} still in use (1) [unmount of cifs cifs]
> ------------[ cut here ]------------
> kernel BUG at fs/dcache.c:943!
> [..]
> Process umount (pid: 1781, threadinfo ffff88003d6e8000, task ffff880035eeaec0)
> [..]
> Call Trace:
>  [<ffffffff811b44f3>] shrink_dcache_for_umount+0x33/0x60
>  [<ffffffff8119f7fc>] generic_shutdown_super+0x2c/0xe0
>  [<ffffffff8119f946>] kill_anon_super+0x16/0x30
>  [<ffffffffa036623a>] cifs_kill_sb+0x1a/0x30 [cifs]
>  [<ffffffff8119fcc7>] deactivate_locked_super+0x57/0x80
>  [<ffffffff811a085e>] deactivate_super+0x4e/0x70
>  [<ffffffff811bb417>] mntput_no_expire+0xd7/0x130
>  [<ffffffff811bc30c>] sys_umount+0x9c/0x3c0
>  [<ffffffff81657c19>] system_call_fastpath+0x16/0x1b
> 
> Fix this by making each cifsFileInfo object hold a reference to cifs
> super block, which implicitly keeps VFS super block around as well.
> 
> Signed-off-by: Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-and-Tested-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c | 24 ++++++++++++++++++++++++
>  fs/cifs/cifsfs.h |  4 ++++
>  fs/cifs/file.c   |  6 +++++-
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1a052c0..054b90b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -91,6 +91,30 @@ struct workqueue_struct	*cifsiod_wq;
>  __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
>  #endif
>  
> +/*
> + * Bumps refcount for cifs super block.
> + * Note that it should be only called if a referece to VFS super block is
> + * already held, e.g. in open-type syscalls context. Otherwise it can race with
> + * atomic_dec_and_test in deactivate_locked_super.
> + */
> +void
> +cifs_sb_active(struct super_block *sb)
> +{
> +	struct cifs_sb_info *server = CIFS_SB(sb);
> +
> +	if (atomic_inc_return(&server->active) == 1)
> +		atomic_inc(&sb->s_active);
> +}
> +
> +void
> +cifs_sb_deactive(struct super_block *sb)
> +{
> +	struct cifs_sb_info *server = CIFS_SB(sb);
> +
> +	if (atomic_dec_and_test(&server->active))
> +		deactivate_super(sb);
> +}
> +
>  static int
>  cifs_read_super(struct super_block *sb)
>  {
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 7163419..0e32c34 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -41,6 +41,10 @@ extern struct file_system_type cifs_fs_type;
>  extern const struct address_space_operations cifs_addr_ops;
>  extern const struct address_space_operations cifs_addr_ops_smallbuf;
>  
> +/* Functions related to super block operations */
> +extern void cifs_sb_active(struct super_block *sb);
> +extern void cifs_sb_deactive(struct super_block *sb);
> +
>  /* Functions related to inodes */
>  extern const struct inode_operations cifs_dir_inode_ops;
>  extern struct inode *cifs_root_iget(struct super_block *);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8c0d855..7a0dd99 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -300,6 +300,8 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>  	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
>  	mutex_init(&cfile->fh_mutex);
>  
> +	cifs_sb_active(inode->i_sb);
> +
>  	/*
>  	 * If the server returned a read oplock and we have mandatory brlocks,
>  	 * set oplock level to None.
> @@ -349,7 +351,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
>  	struct TCP_Server_Info *server = tcon->ses->server;
>  	struct cifsInodeInfo *cifsi = CIFS_I(inode);
> -	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> +	struct super_block *sb = inode->i_sb;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct cifsLockInfo *li, *tmp;
>  	struct cifs_fid fid;
>  	struct cifs_pending_open open;
> @@ -414,6 +417,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  
>  	cifs_put_tlink(cifs_file->tlink);
>  	dput(cifs_file->dentry);
> +	cifs_sb_deactive(sb);
>  	kfree(cifs_file);
>  }
>  

Nice work. Steve, I think this ought to go into 3.9, and is probably a
stable candidate as well.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
