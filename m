From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Add idmap key and related data structures and
 functions (try #5)
Date: Tue, 15 Feb 2011 15:16:38 -0500
Message-ID: <20110215151638.62a96a14@tlielax.poochiereds.net>
References: <1297450136-31586-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297450136-31586-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 Feb 2011 12:48:56 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Define (global) data structures to store ids, uids and gids, to which a
> SID maps.  There are two separate trees, one for SID/uid and another one
> for SID/gid.
> 
> A new type of key, cifs_idmap_key_type, is used.
> 
> Keys are instantiated and searched using credential of the root by
> overriding and restoring the credentials of the caller requesting the key.
> Once a SID is mapped, it is stored along with the mapped id, in one
> of the rb trees and key is released.
> 
> Register a pruning function with the shrinker that prunes the rb trees
> when memory pressure warrants freeing up cache.  Just for now, it is
> more like cleaning entire cache than pruning.  The subsequent patch has
> this function defined.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c   |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsfs.c    |    7 +++
>  fs/cifs/cifsglob.h  |    5 ++
>  fs/cifs/cifsproto.h |    3 +
>  4 files changed, 153 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index beeebf1..388b34c 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -23,6 +23,10 @@
>  
>  #include <linux/fs.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/keyctl.h>
> +#include <linux/key-type.h>
> +#include <keys/user-type.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsacl.h"
> @@ -50,6 +54,140 @@ static const struct cifs_sid sid_authusers = {
>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
>  
> +static const struct cred *root_cred;
> +
> +/*
> + * Run idmap cache shrinker.
> + */
> +static int
> +cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
> +{
> +	/* Use a pruning scheme in a subsequent patch instead */
		^^^^
	maybe add the standard "FIXME:" prefix? to the comment above?

> +	cifs_destroy_idmaptrees();
> +	return 0;
> +}
> +

Aside from the trivial comment fix, this looks OK, I guess. Eventually
it would be good to have a more selective pruning scheme than just
dropping the entire idmap cache.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
