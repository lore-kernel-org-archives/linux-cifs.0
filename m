From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v2 4/4] CIFS: Migrate to shared superblock model
Date: Tue, 24 May 2011 07:22:50 -0400
Message-ID: <20110524072250.7337d434@corrin.poochiereds.net>
References: <1304589314-1147-1-git-send-email-piastry@etersoft.ru>
	<1304589314-1147-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304589314-1147-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  5 May 2011 13:55:14 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add cifs_match_super to use in sget to share superblock between mounts
> that have the same //server/sharename, credentials and mount options.
> It helps us to improve performance on work with future SMB2.1 leases.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |   18 ++++++++++-
>  fs/cifs/cifsglob.h |    5 +++
>  fs/cifs/connect.c  |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 112 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 446b5c2..ba0b7ae 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -644,6 +644,7 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	struct super_block *sb;
>  	struct cifs_sb_info *cifs_sb;
>  	struct smb_vol *volume_info;
> +	struct cifs_mnt_data mnt_data;
>  	struct dentry *root;
>  	char *copied_data = NULL;
>  
> @@ -661,13 +662,21 @@ cifs_do_mount(struct file_system_type *fs_type,
>  
>  	cifs_setup_cifs_sb(volume_info, cifs_sb);
>  
> -	sb = sget(fs_type, NULL, set_anon_super, NULL);
> +	mnt_data.vol = volume_info;
> +	mnt_data.cifs_sb = cifs_sb;
> +
> +	sb = sget(fs_type, cifs_match_super, set_anon_super, &mnt_data);
>  	if (IS_ERR(sb)) {
>  		kfree(cifs_sb);
>  		root = ERR_CAST(sb);
>  		goto out;
>  	}
>  
> +	if (sb->s_fs_info) {
> +		cFYI(1, "Use existing superblock");
> +		goto out_shared;
> +	}
> +
>  	sb->s_flags = flags;
>  
>  	/*
> @@ -700,6 +709,13 @@ out:
>  	cifs_cleanup_volume_info(&volume_info);
>  	return root;
>  
> +out_shared:
> +	root = cifs_get_root(volume_info, sb);
> +	if (root)
> +		cFYI(1, "dentry root is: %p", root);
> +	cifs_cleanup_volume_info(&volume_info);
> +	return root;
> +
>  err_out:
>  	kfree(cifs_sb);
>  	deactivate_locked_super(sb);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 7ad7d69..55901b0 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -211,6 +211,11 @@ struct smb_vol {
>  	struct nls_table *local_nls;
>  };
>  
> +struct cifs_mnt_data {
> +	struct cifs_sb_info *cifs_sb;
> +	struct smb_vol *vol;
> +};
> +
>  struct TCP_Server_Info {
>  	struct list_head tcp_ses_list;
>  	struct list_head smb_ses_list;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1cacfaa..1d39dcf 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2135,6 +2135,96 @@ cifs_put_tlink(struct tcon_link *tlink)
>  	return;
>  }
>  
> +static inline struct tcon_link *
> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
> +
> +static const u32 ACTUAL_MOUNT_FLAGS = CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID |
> +	CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CIFS_MOUNT_NO_XATTR |
> +	CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL | CIFS_MOUNT_NO_BRL |
> +	CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_MOUNT_OVERR_GID |
> +	CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC |
> +	CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS_MOUNT_MULTIUSER |
> +	CIFS_MOUNT_STRICT_IO;
> +
> +static int
> +compare_mount_options(struct cifs_sb_info *old, struct cifs_sb_info *new)
> +{
> +	if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=
> +	    (new->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
> +		return 0;
> +
> +	if (old->rsize != new->rsize || old->wsize != new->wsize)
> +		return 0;
> +
		^^^^^^^^^^
The rsize and wsize are negotiated -- you can't know what this is until
you talk to the server. Doesn't this check always fail?

The wsize at least is never negotiated up. We only ever negotiate down,
so what may be best is to see whether the wsize was actually specified
in the mount options and if it's smaller than the existing one. If it
is then don't match.

I plan to fix the rsize negotiation in a similar fashion once I do a
readpages overhaul.

> +	if (old->mnt_uid != new->mnt_uid || old->mnt_gid != new->mnt_gid)
> +		return 0;
> +
> +	if (old->mnt_file_mode != new->mnt_file_mode ||
> +	    old->mnt_dir_mode != new->mnt_dir_mode)
> +		return 0;
> +
> +	if (strcmp(old->local_nls->charset, new->local_nls->charset))
> +		return 0;
> +
> +	if (old->actimeo != new->actimeo)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +int
> +cifs_match_super(struct super_block *sb, void *data)
> +{
> +	struct cifs_mnt_data *mnt_data = (struct cifs_mnt_data *)data;
> +	struct smb_vol *volume_info;
> +	struct cifs_sb_info *cifs_sb, *new_cifs_sb;
> +	struct TCP_Server_Info *tcp_srv;
> +	struct cifsSesInfo *ses;
> +	struct cifsTconInfo *tcon;
> +	struct tcon_link *tlink;
> +	struct sockaddr_storage addr;
> +	int rc = 0;
> +
> +	memset(&addr, 0, sizeof(struct sockaddr_storage));
> +
> +	spin_lock(&cifs_tcp_ses_lock);
> +	cifs_sb = CIFS_SB(sb);
> +	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
> +	if (IS_ERR(tlink)) {
> +		spin_unlock(&cifs_tcp_ses_lock);
> +		return rc;
> +	}
> +	tcon = tlink_tcon(tlink);
> +	ses = tcon->ses;
> +	tcp_srv = ses->server;
> +
> +	volume_info = mnt_data->vol;
> +	new_cifs_sb = mnt_data->cifs_sb;
> +
> +	if (!volume_info->UNCip || !volume_info->UNC)
> +		goto out;
> +
> +	rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
> +				volume_info->UNCip,
> +				strlen(volume_info->UNCip),
> +				volume_info->port);
> +	if (!rc)
> +		goto out;
> +
> +	if (!match_server(tcp_srv, (struct sockaddr *)&addr, volume_info) ||
> +	    !match_session(ses, volume_info) ||
> +	    !match_tcon(tcon, volume_info->UNC)) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	rc = compare_mount_options(cifs_sb, new_cifs_sb);
> +out:
> +	cifs_put_tlink(tlink);
> +	spin_unlock(&cifs_tcp_ses_lock);
> +	return rc;
> +}
> +
>  int
>  get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
>  	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,


Other than the problem with the rsize/wsize, this looks ok. I don't see
that as a show-stopper either, so I suggest we merge this and let Pavel
fix that after the merge window closes.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
