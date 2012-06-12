From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: fix parsing of password mount option
Date: Tue, 12 Jun 2012 10:55:41 +0100
Message-ID: <1339494941.4565.5.camel@localhost>
References: <4FD69F4E.5030009@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FD69F4E.5030009-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2012-06-12 at 07:15 +0530, Suresh Jayaraman wrote:
> The double delimiter check that allows a comma in the password parsing code is
> unconditional. We set "tmp_end" to the end of the string and we continue to
> check for double delimiter. In the case where the password doesn't contain a
> comma we end up setting tmp_end to NULL and eventually setting "options" to
> "end". This results in the premature termination of the options string and hence
> the values of UNCip and UNC are being set to NULL. This results in mount failure
> with "Connecting to DFS root not implemented yet" error.
> 
> This error is usually not noticable as we have password as the last option in
> the superblock mountdata. But when we call expand_dfs_referral() from
> cifs_mount() and try to compose mount options for the submount, the resulting
> mountdata will be of the form 
> 
>    ",ver=1,user=foo,pass=bar,ip=x.x.x.x,unc=\\server\share"
> 
> and hence results in the above error. This bug has been seen with older NAS
> servers running Samba 3.0.24.
> 
> Fix this by moving the double delimiter check inside the conditional loop.
> 
> Changes since -v1
> 
>    - removed the wrong strlen() micro optimization.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   32 +++++++++++++++++---------------
>  1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 78db68a..5b38407 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1653,24 +1653,26 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			 * If yes, we have encountered a double deliminator
>  			 * reset the NULL character to the deliminator
>  			 */
> -			if (tmp_end < end && tmp_end[1] == delim)
> +			if (tmp_end < end && tmp_end[1] == delim) {
>  				tmp_end[0] = delim;
>  
> -			/* Keep iterating until we get to a single deliminator
> -			 * OR the end
> -			 */
> -			while ((tmp_end = strchr(tmp_end, delim)) != NULL &&
> -			       (tmp_end[1] == delim)) {
> -				tmp_end = (char *) &tmp_end[2];
> -			}
> +				/* Keep iterating until we get to a single
> +				 * deliminator OR the end
> +				 */
> +				while ((tmp_end = strchr(tmp_end, delim))
> +					!= NULL && (tmp_end[1] == delim)) {
> +						tmp_end = (char *) &tmp_end[2];
> +				}
>  
> -			/* Reset var options to point to next element */
> -			if (tmp_end) {
> -				tmp_end[0] = '\0';
> -				options = (char *) &tmp_end[1];
> -			} else
> -				/* Reached the end of the mount option string */
> -				options = end;
> +				/* Reset var options to point to next element */
> +				if (tmp_end) {
> +					tmp_end[0] = '\0';
> +					options = (char *) &tmp_end[1];
> +				} else
> +					/* Reached the end of the mount option
> +					 * string */
> +					options = end;
> +			}
>  
>  			/* Now build new password string */
>  			temp_len = strlen(value);

Another way would have been to leave the earlier optimisation in place
but simply reset temp_len within the if condition. This means the second
strlen was called only in case we had encountered a double delimiter in
the password.

In any case, this code is called only once at mount time and hence the
optimisation is not terribly important in this case.

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
