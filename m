From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Change key name to cifs.idmap, misc. clean-up
Date: Mon, 16 May 2011 09:22:04 -0400
Message-ID: <20110516092204.10185f8b@corrin.poochiereds.net>
References: <1304667300-29158-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304667300-29158-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  6 May 2011 02:35:00 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Change idmap key name from cifs.cifs_idmap to cifs.idmap.
> Removed unused structure wksidarr and function match_sid().
> Handle errors correctly in function init_cifs().
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |   59 +----------------------------------------------------
>  fs/cifs/cifsacl.h |    1 -
>  fs/cifs/cifsfs.c  |    8 ++++--
>  3 files changed, 6 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index bfb5ba5..f3c6fb9 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -33,18 +33,6 @@
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
>  
> -
> -static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
> -	{{1, 0, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0} }, "null user"},
> -	{{1, 1, {0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0} }, "nobody"},
> -	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
> -	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
> -	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(544), 0, 0, 0} }, "root"},
> -	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(545), 0, 0, 0} }, "users"},
> -	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(546), 0, 0, 0} }, "guest"} }
> -;
> -
> -
>  /* security id for everyone/world system group */
>  static const struct cifs_sid sid_everyone = {
>  	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> @@ -131,7 +119,7 @@ cifs_idmap_key_destroy(struct key *key)
>  }
>  
>  struct key_type cifs_idmap_key_type = {
> -	.name        = "cifs.cifs_idmap",
> +	.name        = "cifs.idmap",
>  	.instantiate = cifs_idmap_key_instantiate,
>  	.destroy     = cifs_idmap_key_destroy,
>  	.describe    = user_describe,
> @@ -435,51 +423,6 @@ cifs_destroy_idmaptrees(void)
>  	spin_unlock(&sidgidlock);
>  }
>  
> -int match_sid(struct cifs_sid *ctsid)
> -{
> -	int i, j;
> -	int num_subauth, num_sat, num_saw;
> -	struct cifs_sid *cwsid;
> -
> -	if (!ctsid)
> -		return -1;
> -
> -	for (i = 0; i < NUM_WK_SIDS; ++i) {
> -		cwsid = &(wksidarr[i].cifssid);
> -
> -		/* compare the revision */
> -		if (ctsid->revision != cwsid->revision)
> -			continue;
> -
> -		/* compare all of the six auth values */
> -		for (j = 0; j < 6; ++j) {
> -			if (ctsid->authority[j] != cwsid->authority[j])
> -				break;
> -		}
> -		if (j < 6)
> -			continue; /* all of the auth values did not match */
> -
> -		/* compare all of the subauth values if any */
> -		num_sat = ctsid->num_subauth;
> -		num_saw = cwsid->num_subauth;
> -		num_subauth = num_sat < num_saw ? num_sat : num_saw;
> -		if (num_subauth) {
> -			for (j = 0; j < num_subauth; ++j) {
> -				if (ctsid->sub_auth[j] != cwsid->sub_auth[j])
> -					break;
> -			}
> -			if (j < num_subauth)
> -				continue; /* all sub_auth values do not match */
> -		}
> -
> -		cFYI(1, "matching sid: %s\n", wksidarr[i].sidname);
> -		return 0; /* sids compare/match */
> -	}
> -
> -	cFYI(1, "No matching sid");
> -	return -1;
> -}
> -
>  /* if the two SIDs (roughly equivalent to a UUID for a user or group) are
>     the same returns 1, if they do not match returns 0 */
>  int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index 757cf5a..5c902c7 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -98,7 +98,6 @@ extern struct key_type cifs_idmap_key_type;
>  extern const struct cred *root_cred;
>  #endif /* KERNEL */
>  
> -extern int match_sid(struct cifs_sid *);
>  extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
>  
>  #endif /* _CIFSACL_H */
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 2b8e47e..ed92c7d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1046,21 +1046,23 @@ init_cifs(void)
>  #ifdef CONFIG_CIFS_ACL
>  	rc = init_cifs_idmap();
>  	if (rc)
> -		goto out_destroy_request_bufs;
> +		goto out_register_key_type;
>  #endif /* CONFIG_CIFS_ACL */
>  
>  	rc = register_filesystem(&cifs_fs_type);
>  	if (rc)
> -		goto out_destroy_request_bufs;
> +		goto out_init_cifs_idmap;
>  
>  	return 0;
>  
> -out_destroy_request_bufs:
> +out_init_cifs_idmap:
>  #ifdef CONFIG_CIFS_ACL
>  	exit_cifs_idmap();
> +out_register_key_type:
>  #endif
>  #ifdef CONFIG_CIFS_UPCALL
>  	unregister_key_type(&cifs_spnego_key_type);
> +out_destroy_request_bufs:
>  #endif
>  	cifs_destroy_request_bufs();
>  out_destroy_mids:

Looks fine.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
