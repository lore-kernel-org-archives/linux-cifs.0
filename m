From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate
 all three permissions user, group, and other
Date: Tue, 4 Jan 2011 14:11:30 -0500
Message-ID: <20110104141130.2cec2a74@tlielax.poochiereds.net>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291669006-12102-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Dec 2010 14:56:46 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> If a DACL has entries for ACEs for SID Everyone and Authenticated Users,
> factor in mask in respective entries during calculation of permissions
> for all three, user, group, and other.
> 
> http://technet.microsoft.com/en-us/library/bb463216.aspx
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index c6ebea0..a520091 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -43,9 +43,12 @@ static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
>  ;
>  
>  
> -/* security id for everyone */
> +/* security id for everyone/world system group */
>  static const struct cifs_sid sid_everyone = {
>  	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> +/* security id for Authenticated Users system group */
> +static const struct cifs_sid sid_authusers = {
> +	1, 1, {0, 0, 0, 0, 0, 5}, {11} };
>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
>  
> @@ -367,7 +370,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
>  	if (num_aces  > 0) {
>  		umode_t user_mask = S_IRWXU;
>  		umode_t group_mask = S_IRWXG;
> -		umode_t other_mask = S_IRWXO;
> +		umode_t other_mask = S_IRWXU | S_IRWXG | S_IRWXO;
>  
>  		ppace = kmalloc(num_aces * sizeof(struct cifs_ace *),
>  				GFP_KERNEL);
> @@ -392,6 +395,12 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
>  						     ppace[i]->type,
>  						     &fattr->cf_mode,
>  						     &other_mask);
> +			if (compare_sids(&(ppace[i]->sid), &sid_authusers))
> +				access_flags_to_mode(ppace[i]->access_req,
> +						     ppace[i]->type,
> +						     &fattr->cf_mode,
> +						     &other_mask);
> +
>  
>  /*			memcpy((void *)(&(cifscred->aces[i])),
>  				(void *)ppace[i],

This looks like a harmless change...

    Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I have real doubts however about the owner/group parts of the cifsacl
scheme. It sets the user and group mode bits without setting the user
and group owners to meaningful values. So, those permissions have no
basis in reality.

That's especially scary since cifs uses these for permissions
enforcement by default, so that's a box of chocolates (no telling what
you'll get).
