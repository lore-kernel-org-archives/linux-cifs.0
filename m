From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Migrate to shared superblock model
Date: Sun, 10 Apr 2011 10:31:43 -0400
Message-ID: <20110410103143.7312409b@tlielax.poochiereds.net>
References: <1302429954-9927-1-git-send-email-piastry@etersoft.ru>
	<1302429954-9927-3-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302429954-9927-3-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 10 Apr 2011 14:05:54 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add cifs_match_super to use in sget to share superblock between mounts
> that have the same //server/sharename, credentials and mount options.
> It helps us to improve performance on work with future SMB2.1 leases.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c  |    6 ++-
>  fs/cifs/connect.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index c40c1f4..abc8436 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -577,14 +577,16 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	if (rc)
>  		return ERR_PTR(rc);
>  
> -	sb = sget(fs_type, NULL, set_anon_super, NULL);
> +	sb = sget(fs_type, cifs_match_super, set_anon_super, volume_info);
>  	if (IS_ERR(sb)) {
>  		cifs_cleanup_volume_info(&volume_info);
>  		return ERR_CAST(sb);
>  	}
>  
> -	if (sb->s_fs_info)
> +	if (sb->s_fs_info) {
> +		cFYI(1, "Use existing superblock");
>  		goto out;
> +	}
>  
>  	sb->s_flags = flags;
>  
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 53b79e7..7c98c36 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2193,6 +2193,99 @@ cifs_put_tlink(struct tcon_link *tlink)
>  	return;
>  }
>  
> +static void setup_cifs_sb(struct smb_vol *vol, struct cifs_sb_info *sb);
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
> +compare_mount_options(struct super_block *sb, struct smb_vol *vol)
> +{
> +	struct cifs_sb_info *old = CIFS_SB(sb), new;
> +
> +	setup_cifs_sb(vol, &new);
> +
> +	if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=
> +	    (new.mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
> +		return 0;
> +
> +	if (old->rsize != new.rsize || old->wsize != new.wsize)
> +		return 0;
> +
> +	if (old->mnt_uid != new.mnt_uid || old->mnt_gid != new.mnt_gid)
> +		return 0;
> +
> +	if (old->mnt_file_mode != new.mnt_file_mode ||
> +	    old->mnt_dir_mode != new.mnt_dir_mode)
> +		return 0;
> +
> +	if (old->prepathlen != new.prepathlen ||
> +	    strncmp(old->prepath, new.prepath, old->prepathlen))
> +		return 0;
> +

I don't think this is really what you want...

Suppose I mount the same share twice, but with 2 different prepaths.
For instance:

//server/share/foo

...and...

//server/share/foo/bar

...shouldn't the inodes for files/directories accessable via both
mounts be shared in that case?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
