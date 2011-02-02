From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Add idmap key and related data structures and
 functions (try #4)
Date: Wed, 2 Feb 2011 08:31:07 -0500
Message-ID: <20110202083107.557499fb@corrin.poochiereds.net>
References: <1295994980-8718-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295994980-8718-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Jan 2011 16:36:20 -0600
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
> when memory pressure warrants freeing up cache.  The function is more like
> cleaning entire cache than pruning since it would be cleaner and easier
> to start over again (id mapping).  winbind is likely to have the
> mappings stored as well, thus not needing to send make calls to the
> domain controller.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c   |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsfs.c    |    7 +++
>  fs/cifs/cifsglob.h  |    5 ++
>  fs/cifs/cifsproto.h |    3 +
>  4 files changed, 151 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 1e7636b..b165496 100644
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
> @@ -50,6 +54,138 @@ static const struct cifs_sid sid_authusers = {
>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
>  
> +const struct cred *root_cred;
> +
> +/*
> + * Run idmap cache shrinker.
> + */
> +static int
> +cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
> +{
> +	cifs_destroy_idmaptrees();
> +	return 0;
> +}
> +

All or nothing? Is it really so difficult to implement some sort of LRU
scheme? Remember that this code is likely to be called quite
frequently if someone turns it on. It really is important to make this
very efficient.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
