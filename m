From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/6] cifs: Add support for mounting Windows 2008 DFS
 shares
Date: Thu, 7 Apr 2011 09:33:43 -0400
Message-ID: <20110407093343.0d53a273@tlielax.poochiereds.net>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
	<1302100005-1848-2-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-2-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Apr 2011 16:26:41 +0200
Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> Windows 2008 CIFS servers do not always return PATH_NOT_COVERED when
> attempting to access a DFS share.  Therefore, when checking for remote
> shares, unconditionally ask for a DFS referral for the UNC (w/out prepath)
> before continuing with previous behavior of attempting to access the UNC +
> prepath and checking for PATH_NOT_COVERED.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31092
> 
> Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
> ---
>  fs/cifs/connect.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c89d871..4873bac 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2934,6 +2934,24 @@ try_mount_again:
>  			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
>  
>  remote_path_check:
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +	/*
> +	 * Perform an unconditional check for whether there are DFS
> +	 * referrals for this path without prefix, to provide support
> +	 * for DFS referrals from w2k8 servers which don't seem to respond
> +	 * with PATH_NOT_COVERED to requests that include the prefix.
> +	 * Chase the referral if found, otherwise continue normally.
> +	 */
> +	if (referral_walks_count == 0) {
> +		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
> +						cifs_sb, &mount_data, false);
> +		if (!refrc) {
> +			referral_walks_count++;
> +			goto try_mount_again;
> +		}
> +	}
> +#endif
> +
>  	/* check if a whole path (including prepath) is not remote */
>  	if (!rc && tcon) {
>  		/* build_path_to_root works only when we have a valid tcon */

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
