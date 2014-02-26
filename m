From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: connect: added option krb5mi which may allow
 package signing
Date: Wed, 26 Feb 2014 12:26:34 -0800
Message-ID: <20140226122634.1190167e@corrin.poochiereds.net>
References: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 26 Feb 2014 14:46:47 +0100
"Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org> wrote:

> Solves an issue with dfs where servers using package signing are
> mixed with servers which don't use package signing.
> 
> Signed-off-by: Lorenz Bucher <lorenz.bucher-Mmb7MZpHnFY@public.gmane.org>
> ---
>  fs/cifs/connect.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 56c152d..9d06dd8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         if (!value || !*value) {
>                                 cERROR(1, "no security value specified");
>                                 continue;
> +                       } else if (strnicmp(value, "krb5mi", 6) == 0) {
> +                               vol->secFlg |= CIFSSEC_MAY_KRB5 | 
> +                                       CIFSSEC_MAY_SIGN;
>                         } else if (strnicmp(value, "krb5i", 5) == 0) {
>                                 vol->secFlg |= CIFSSEC_MAY_KRB5 |
>                                         CIFSSEC_MUST_SIGN;

This looks like it applies to a really old kernel. I think that problem
was what commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 was intended
to fix.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
