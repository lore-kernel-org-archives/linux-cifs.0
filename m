From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Remove data_blob.h include
Date: Thu, 16 Mar 2017 06:40:15 -0400
Message-ID: <1489660814.2650.1.camel@poochiereds.net>
References: <20170315202044.28670-1-pyromaniac@exherbo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Thomas Witt <pyromaniac-k5O9xmZG+kVAfugRpC6u6w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315202044.28670-1-pyromaniac-k5O9xmZG+kVAfugRpC6u6w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-03-15 at 20:20 +0000, Thomas Witt wrote:
> data_blob.h includes talloc.h from libtalloc, but that is only marked as
> a dependency for cifs.upcall. No symbols from that header are used by
> cifs.mount, so remove it to avoid the libtalloc dependency
> 
> Signed-off-by: Thomas Witt <pyromaniac-k5O9xmZG+kVAfugRpC6u6w@public.gmane.org>
> ---
>  mount.cifs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 13b71ef..2612feb 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -61,7 +61,6 @@
>  #include "mount.h"
>  #include "util.h"
>  #include "resolve_host.h"
> -#include "data_blob.h"
>  
>  #ifndef MS_MOVE 
>  #define MS_MOVE 8192 

Thanks! Yes, that was leftover from my first pass on cleaning up some of
the replace.h code.

Patch merged and should make 6.8.
-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
