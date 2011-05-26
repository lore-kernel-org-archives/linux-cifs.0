From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v5 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 14:38:52 -0400
Message-ID: <20110526143852.56a1f122@tlielax.poochiereds.net>
References: <1306427331-9887-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306427331-9887-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 May 2011 20:28:51 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add cifs_match_super to use in sget to share superblock between mounts
> that have the same //server/sharename, credentials and mount options.
> It helps us to improve performance on work with future SMB2.1 leases.
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |   19 +++++++++-
>  fs/cifs/cifsglob.h |   19 ++++++++++
>  fs/cifs/connect.c  |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 135 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 46fdd55..360fe2e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -630,6 +630,7 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	struct super_block *sb;
>  	struct cifs_sb_info *cifs_sb;
>  	struct smb_vol *volume_info;
> +	struct cifs_mnt_data mnt_data;
>  	struct dentry *root;
>  
>  	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
> @@ -646,12 +647,21 @@ cifs_do_mount(struct file_system_type *fs_type,
>  
>  	cifs_setup_cifs_sb(volume_info, cifs_sb);
>  
> -	sb = sget(fs_type, NULL, set_anon_super, NULL);
> +	mnt_data.vol = volume_info;
> +	mnt_data.cifs_sb = cifs_sb;
> +	mnt_data.flags = flags;
> +
> +	sb = sget(fs_type, cifs_match_super, set_anon_super, &mnt_data);
>  	if (IS_ERR(sb)) {
>  		root = ERR_CAST(sb);
>  		goto out_cifs_sb;
>  	}
>  
> +	if (sb->s_fs_info) {
> +		cFYI(1, "Use existing superblock");
> +		goto out_shared;
> +	}
> +
>  	/*
>  	 * Copy mount params for use in submounts. Better to do
>  	 * the copy here and deal with the error before cleanup gets
> @@ -680,9 +690,16 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	root = cifs_get_root(volume_info, sb);
>  	if (root == NULL)
>  		goto out_super;
> +
>  	cFYI(1, "dentry root is: %p", root);
>  	goto out;
>  
> +out_shared:
> +	root = cifs_get_root(volume_info, sb);
> +	if (root)
> +		cFYI(1, "dentry root is: %p", root);
> +	goto out;
> +
>  out_super:
>  	kfree(cifs_sb->mountdata);
>  	deactivate_locked_super(sb);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f57387a..7f90488 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -210,6 +210,25 @@ struct smb_vol {
>  	struct nls_table *local_nls;
>  };
>  
> +#define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID | \
> +			 CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | \
> +			 CIFS_MOUNT_NO_XATTR | CIFS_MOUNT_MAP_SPECIAL_CHR | \
> +			 CIFS_MOUNT_UNX_EMUL | CIFS_MOUNT_NO_BRL | \
> +			 CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | \
> +			 CIFS_MOUNT_OVERR_GID | CIFS_MOUNT_DYNPERM | \
> +			 CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC | \
> +			 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
> +			 CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO)
> +
> +#define CIFS_MS_MASK (MS_RDONLY | MS_MANDLOCK | MS_NOEXEC | MS_NOSUID | \
> +		      MS_NODEV | MS_SYNCHRONOUS)
> +
> +struct cifs_mnt_data {
> +	struct cifs_sb_info *cifs_sb;
> +	struct smb_vol *vol;
> +	int flags;
> +};
> +
>  struct TCP_Server_Info {
>  	struct list_head tcp_ses_list;
>  	struct list_head smb_ses_list;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4f34519..12408de 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2146,6 +2146,96 @@ cifs_put_tlink(struct tcon_link *tlink)
>  	return;
>  }
>  
> +static inline struct tcon_link *
> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
> +
> +static int
> +compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
> +{
> +	struct cifs_sb_info *old = CIFS_SB(sb);
> +	struct cifs_sb_info *new = mnt_data->cifs_sb;
> +
> +	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
> +		return 0;
> +
> +	if ((old->mnt_cifs_flags & CIFS_MOUNT_MASK) !=
> +	    (new->mnt_cifs_flags & CIFS_MOUNT_MASK))
> +		return 0;
> +
> +	if (old->rsize != new->rsize)
> +		return 0;
> +
> +	if (new->wsize && new->wsize < old->wsize)
> +		return 0;

Might be nice to have a comment here explaining why we check it this
way. That can be added later though.

> +
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
> +	struct cifs_sb_info *cifs_sb;
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
> +	rc = compare_mount_options(sb, mnt_data);
> +out:
> +	cifs_put_tlink(tlink);
> +	spin_unlock(&cifs_tcp_ses_lock);
> +	return rc;
> +}
> +
>  int
>  get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
>  	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
> @@ -2571,6 +2661,14 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  		/* Windows ME may prefer this */
>  		cFYI(1, "readsize set to minimum: 2048");
>  	}
> +
> +	/*
> +	 * Temporally set wsize for matching superblock. If we end up using
		^^^
	   nit: Temporarily

> +	 * new sb then cifs_negotiate_wsize will later negotiate it downward
> +	 * if needed.
> +	 */
> +	cifs_sb->wsize = pvolume_info->wsize;
> +
>  	cifs_sb->mnt_uid = pvolume_info->linux_uid;
>  	cifs_sb->mnt_gid = pvolume_info->linux_gid;
>  	cifs_sb->mnt_file_mode = pvolume_info->file_mode;

Other than the minor nits above, this looks fine:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
