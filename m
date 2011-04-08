From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 4/6] cifs: Simplify handling of submount options in
 cifs_mount.
Date: Fri, 8 Apr 2011 09:50:54 -0400
Message-ID: <20110408095054.0c652941@corrin.poochiereds.net>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
	<1302100005-1848-4-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-4-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Apr 2011 16:26:43 +0200
Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> With CONFIG_DFS_UPCALL enabled, maintain the submount options in
> cifs_sb->mountdata, simplifying the code just a bit as well as making
> corner-case allocation problems less likely.
> 
> Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
> ---
>  fs/cifs/connect.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 259fc64..8d2529c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2785,9 +2785,9 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
>  /*
>   * Perform a dfs referral query for a share and (optionally) prefix
>   *
> - * If a referral is found, mount_data will be set to point at a newly
> - * allocated string containing updated options for the submount.
> - * Otherwise it will be left untouched.
> + * If a referral is found, cifs_sb->mountdata will be (re-)allocated
> + * to a string containing updated options for the submount.  Otherwise it
> + * will be left untouched.
>   *
>   * Returns the rc from get_dfs_path to the caller, which can be used to
>   * determine whether there were referrals.
> @@ -2795,7 +2795,7 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
>  static int
>  expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
>  		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
> -		    char **mount_data, int check_prefix)
> +		    int check_prefix)
>  {
>  	int rc;
>  	unsigned int num_referrals = 0;
> @@ -2823,11 +2823,14 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
>  		free_dfs_info_array(referrals, num_referrals);
>  		kfree(fake_devname);
>  
> +		if (cifs_sb->mountdata != NULL)
> +			kfree(cifs_sb->mountdata);
> +
>  		if (IS_ERR(mdata)) {
>  			rc = PTR_ERR(mdata);
>  			mdata = NULL;
>  		}
> -		*mount_data = mdata;
> +		cifs_sb->mountdata = mdata;
>  	}
>  	kfree(full_path);
>  	return rc;
> @@ -2850,6 +2853,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	int referral_walks_count = 0;
>  try_mount_again:
> +	mount_data = cifs_sb->mountdata;
>  
>  	/* cleanup activities if we're chasing a referral */
>  	if (referral_walks_count) {
> @@ -2983,7 +2987,7 @@ remote_path_check:
>  	 */
>  	if (referral_walks_count == 0) {
>  		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
> -						cifs_sb, &mount_data, false);
> +						cifs_sb, false);
>  		if (!refrc) {
>  			referral_walks_count++;
>  			goto try_mount_again;
> @@ -3025,17 +3029,13 @@ remote_path_check:
>  			convert_delimiter(cifs_sb->prepath,
>  					CIFS_DIR_SEP(cifs_sb));
>  
> -		if (mount_data != mount_data_global)
> -			kfree(mount_data);
> -
>  		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
> -					 &mount_data, true);
> +					 true);
>  
>  		if (!rc) {
>  			referral_walks_count++;
>  			goto try_mount_again;
>  		}
> -		mount_data = NULL;
>  		goto mount_fail_check;
>  #else /* No DFS support, return error on mount */
>  		rc = -EOPNOTSUPP;
> @@ -3069,8 +3069,6 @@ remote_path_check:
>  mount_fail_check:
>  	/* on error free sesinfo and tcon struct if needed */
>  	if (rc) {
> -		if (mount_data != mount_data_global)
> -			kfree(mount_data);
>  		/* If find_unc succeeded then rc == 0 so we can not end */
>  		/* up accidently freeing someone elses tcon struct */
>  		if (tcon)

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
