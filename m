From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (cifs
	tree related)
Date: Thu, 5 Aug 2010 21:35:50 -0500
Message-ID: <AANLkTimW1pwO468c2iHNvEdzt42b-O4PeAKUgqN_30Jk@mail.gmail.com>
References: <20100805135149.98b2001b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
	David Howells <dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100805135149.98b2001b.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The fix for the missing err.h include is merged.   Not sure why I did
not run into that on my Ubuntu test builds or Dave on his builds.

Have not heard any feedback about the init.h change that Ben suggested =
yet.

On Wed, Aug 4, 2010 at 10:51 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> Hi Steve,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:170: error: implicit declaration of functi=
on 'IS_ERR'
> net/dns_resolver/dns_key.c:171: error: implicit declaration of functi=
on 'PTR_ERR'
> net/dns_resolver/dns_query.c: In function 'dns_query':
> net/dns_resolver/dns_query.c:126: error: implicit declaration of func=
tion 'IS_ERR'
> net/dns_resolver/dns_query.c:127: error: implicit declaration of func=
tion 'PTR_ERR'
>
> Caused by commit bae8da144bd6254d1e9cec2a7d6da7cade84e00e ("DNS: Sepa=
rate
> out CIFS DNS Resolver code").
>
> See Rule 1 in Documentation/SubmitChecklist.
>
> I have added this patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 5 Aug 2010 13:49:29 +1000
> Subject: [PATCH] cifs: include linux/err.h for IS_ERR and PTR_ERR
>
> Fixes build errors:
>
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:170: error: implicit declaration of functi=
on 'IS_ERR'
> net/dns_resolver/dns_key.c:171: error: implicit declaration of functi=
on 'PTR_ERR'
> net/dns_resolver/dns_query.c: In function 'dns_query':
> net/dns_resolver/dns_query.c:126: error: implicit declaration of func=
tion 'IS_ERR'
> net/dns_resolver/dns_query.c:127: error: implicit declaration of func=
tion 'PTR_ERR'
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> =A0net/dns_resolver/dns_key.c =A0 | =A0 =A01 +
> =A0net/dns_resolver/dns_query.c | =A0 =A01 +
> =A02 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
> index 1b1b411..400a04d 100644
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@ -28,6 +28,7 @@
> =A0#include <linux/string.h>
> =A0#include <linux/kernel.h>
> =A0#include <linux/keyctl.h>
> +#include <linux/err.h>
> =A0#include <keys/dns_resolver-type.h>
> =A0#include <keys/user-type.h>
> =A0#include "internal.h"
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_quer=
y.c
> index 6c0cf31..b33e1f7 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -39,6 +39,7 @@
> =A0#include <linux/module.h>
> =A0#include <linux/slab.h>
> =A0#include <linux/dns_resolver.h>
> +#include <linux/err.h>
> =A0#include <keys/dns_resolver-type.h>
> =A0#include <keys/user-type.h>
>
> --
> 1.7.1
>
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug=
=2Eorg.au
> http://www.canb.auug.org.au/~sfr/
>



--=20
Thanks,

Steve
