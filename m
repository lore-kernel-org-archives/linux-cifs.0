From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] automake: add -Werror to CFLAGS
Date: Mon, 16 Apr 2012 16:33:46 -0500
Message-ID: <CAH2r5mu5h+QWq8a3jjE6HBZUYvyYW_a74vPgg0nOqhRgzwU+HA@mail.gmail.com>
References: <1334600010-27430-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334600010-27430-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good idea - thx

On Mon, Apr 16, 2012 at 1:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> With the recent patch to fix the warnings in asn1.c, cifs-utils now
> builds without any warnings. Ban them henceforth by adding -Werror fo=
r
> builds.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0Makefile.am | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 17ad8e1..d95142a 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,4 +1,4 @@
> -AM_CFLAGS =3D -Wall -Wextra
> +AM_CFLAGS =3D -Wall -Wextra -Werror
> =A0ACLOCAL_AMFLAGS =3D -I aclocal
>
> =A0root_sbindir =3D $(ROOTSBINDIR)
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
