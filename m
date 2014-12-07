From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH cifs-utils] mtab.c: include <paths.h> for _PATH_MOUNTED
Date: Sun, 7 Dec 2014 08:20:51 -0500
Message-ID: <20141207082051.050a5147@synchrony.poochiereds.net>
References: <20141205221929.GA3671@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141205221929.GA3671@euler>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 5 Dec 2014 23:19:29 +0100
Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org> wrote:

> Signed-off-by: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
> ---
>  mtab.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mtab.c b/mtab.c
> index 7b365b3..a662a3c 100644
> --- a/mtab.c
> +++ b/mtab.c
> @@ -38,6 +38,7 @@
>  #include <mntent.h>
>  #include <stdlib.h>
>  #include <signal.h>
> +#include <paths.h>
>  #include "mount.h"
>  #include "config.h"
>  

Looks fine. I'll merge that in the next few days.

Thanks!
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
