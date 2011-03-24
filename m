From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fix Bug#31092: Unable to mount DFS filesystems from
 Windows 2008 servers
Date: Thu, 24 Mar 2011 08:58:54 -0400
Message-ID: <20110324085854.36f8c3ec@barsoom.rdu.redhat.com>
References: <20110321082927.8ECF830009@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110321082927.8ECF830009-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 18 Mar 2011 10:02:07 +0100
Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> Windows 2008 CIFS servers do not always return PATH_NOT_COVERED when
> attempting to access a DFS share.  Therefore, when checking for remote
> shares, unconditionally ask for a DFS referral for the UNC (w/out prepath)
> before continuing with previous behavior of attempting to access the UNC +
> prepath and checking for PATH_NOT_COVERED.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31092
> ---
>  fs/cifs/connect.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 50 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..e3a9fd7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2825,6 +2825,56 @@ try_mount_again:
>  			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
>  
>  remote_path_check:
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +	/*
> +	 * Perform an unconditional check for whether there are
> +	 * DFS referrals for this path (without prefix), to provide
> +	 * some limited support for domain DFS referrals on w2k8
> +	 */
> +	if (referral_walks_count == 0) {
> +		cFYI(1, "Getting referral for: %s", volume_info->UNC);
> +		rc = get_dfs_path(xid, pSesInfo , volume_info->UNC + 1,
> +			cifs_sb->local_nls, &num_referrals, &referrals,
> +			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +		if (!rc && num_referrals > 0) {
> +			char *fake_devname = NULL;
> +
> +			full_path = build_unc_path_to_root(volume_info,
> +							   cifs_sb);
> +			if (IS_ERR(full_path)) {
> +				rc = PTR_ERR(full_path);
> +				goto mount_fail_check;
> +			}
> +
> +			if (mount_data != mount_data_global)
> +				kfree(mount_data);
> +
> +			mount_data = cifs_compose_mount_options(
> +					cifs_sb->mountdata, full_path + 1,
> +					referrals, &fake_devname);
> +
> +			free_dfs_info_array(referrals, num_referrals);
> +			kfree(fake_devname);
> +
> +			if (IS_ERR(mount_data)) {
> +				rc = PTR_ERR(mount_data);
> +				mount_data = NULL;
> +				goto mount_fail_check;
> +			}
> +
> +			if (tcon)
> +				cifs_put_tcon(tcon);
> +			else if (pSesInfo)
> +				cifs_put_smb_ses(pSesInfo);
> +
> +			cleanup_volume_info(&volume_info);
> +			referral_walks_count++;
> +			FreeXid(xid);
> +			goto try_mount_again;
> +		}
> +	}
> +#endif
> +
>  	/* check if a whole path (including prepath) is not remote */
>  	if (!rc && cifs_sb->prepathlen && tcon) {
>  		/* build_path_to_root works only when we have a valid tcon */

		^^^^
Have you tested a kernel with commit 4388d8eb? Does it make any
difference in behavior here? If not, then might it be more reasonable
to consolidate some of this code?

Over the last year or two, we've been whittling down cifs_mount to a
smaller function by breaking out pieces of it into separate functions.
It would be good to couple this fix with a similar cleanup of the DFS
referral walking code if possible.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
