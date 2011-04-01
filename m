From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] Simplify handling of submount options in
 cifs_mount.
Date: Fri, 1 Apr 2011 09:27:17 -0400
Message-ID: <20110401092717.03b42cfe@tlielax.poochiereds.net>
References: <20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRd-0005jh-0Z@seldlx2151.corpusers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1Q5dRd-0005jh-0Z-qxVOCJPMiwB8kxaRHGevo2mlIyY1fjA7@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Mar 2011 12:19:29 +0200
Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> With CONFIG_DFS_UPCALL enabled, maintain the submount options in
> cifs_sb->mountdata, simplifying the code just a bit as well as making
> corner-case allocation problems less likely.
> ---
>  fs/cifs/connect.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7d1d0e9..d8e300e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2756,9 +2756,9 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
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
> @@ -2766,7 +2766,7 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
>  static int
>  expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
>  		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
> -		    char **mount_data, int check_prefix)
> +		    int check_prefix)
>  {
>  	int rc;
>  	unsigned int num_referrals = 0;
> @@ -2794,11 +2794,14 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
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
> @@ -2821,6 +2824,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	int referral_walks_count = 0;
>  try_mount_again:
> +	mount_data = cifs_sb->mountdata;
>  

	^^^^
With this, the mount_data_global parm to cifs_mount is vestigial. I
think you can remove that and just plan to pass in the options via
cifs_sb->mountdata.

>  	/* cleanup activities if we're chasing a referral */
>  	if (referral_walks_count) {
> @@ -2954,7 +2958,7 @@ remote_path_check:
>  	 */
>  	if (referral_walks_count == 0) {
>  		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
> -						cifs_sb, &mount_data, false);
> +						cifs_sb, false);
>  		if (!refrc) {
>  			referral_walks_count++;
>  			goto try_mount_again;
> @@ -2996,17 +3000,13 @@ remote_path_check:
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
> @@ -3040,8 +3040,6 @@ remote_path_check:
>  mount_fail_check:
>  	/* on error free sesinfo and tcon struct if needed */
>  	if (rc) {
> -		if (mount_data != mount_data_global)
> -			kfree(mount_data);
>  		/* If find_unc succeeded then rc == 0 so we can not end */
>  		/* up accidently freeing someone elses tcon struct */
>  		if (tcon)

Other than the above nit...nice cleanup.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
