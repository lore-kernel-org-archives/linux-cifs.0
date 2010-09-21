From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the cifs tree
Date: Tue, 21 Sep 2010 01:17:43 -0500
Message-ID: <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5@mail.gmail.com>
References: <20100921161031.7745150e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100921161031.7745150e.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Alternatively - I could merge the trivially modified bkl cifs patch
into the cifs-2.6.git tree if that is easier

On Tue, Sep 21, 2010 at 1:10 AM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:
> Hi Arnd,
>
> Today's linux-next merge of the bkl-vfs tree got a conflict in
> fs/cifs/cifsfs.c between commit d090dbeacd3763845d83d5de4d85aad025a28=
677
> ("cifs: Allow binding to local IP address") from the cifs tree and co=
mmit
> b8f05b0b9ea89cfaf6759b1eb47fff683e7016a5 ("BKL: Remove BKL from CifsF=
S")
> from the bkl-vfs tree.
>
> Just context changes. =A0I fixed it up (see below) and can carry the =
fix as
> necessary.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr-3FnU+UHB4dPYtjvyW6yDsg@public.gmane.org=
=2Eorg.au
>
> diff --cc fs/cifs/cifsfs.c
> index 52e89ea,4e273f7..0000000
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@@ -35,8 -35,6 +35,7 @@@
> =A0#include <linux/delay.h>
> =A0#include <linux/kthread.h>
> =A0#include <linux/freezer.h>
> - #include <linux/smp_lock.h>
> =A0+#include <net/ipv6.h>
> =A0#include "cifsfs.h"
> =A0#include "cifspdu.h"
> =A0#define DECLARE_GLOBALS_HERE
>



--=20
Thanks,

Steve
