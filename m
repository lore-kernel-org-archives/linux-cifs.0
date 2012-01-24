From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifscreds: build it by default
Date: Tue, 24 Jan 2012 12:01:45 -0600
Message-ID: <CADT32e+kb7sQg0bdyP1w2NeNT_qzg3BA4DPgLJ_f2aTRNk5wPw@mail.gmail.com>
References: <1327412079-5818-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327412079-5818-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 24, 2012 at 7:34 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> ...but either error out or disable it if keyutils.h isn't present.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0configure.ac | =A0 18 +++++++++++++-----
> =A01 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index 8476f94..ebea5c1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -18,9 +18,9 @@ AC_ARG_ENABLE(cifsupcall,
>
> =A0AC_ARG_ENABLE(cifscreds,
> =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifscreds],
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifscreds utili=
ty @<:@default=3Dno@:>@])],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifscreds utili=
ty @<:@default=3Dyes@:>@])],
> =A0 =A0 =A0 =A0enable_cifscreds=3D$enableval,
> - =A0 =A0 =A0 enable_cifscreds=3D"no")
> + =A0 =A0 =A0 enable_cifscreds=3D"maybe")
>
> =A0AC_ARG_ENABLE(cifsidmap,
> =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifsidmap],
> @@ -152,8 +152,16 @@ fi
> =A0# checks for wbclient.h and libwbclient.so library
> =A0AC_TEST_WBCHL
>
> -if test $enable_cifscreds =3D "yes"; then
> - =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutil=
s.h not found, consider installing keyutils-libs-devel.])])
> +if test $enable_cifscreds !=3D "no"; then
> + =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 $enable_cifscreds =3D "yes"; then
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([keyutils.h not found, consider installing keyuti=
ls-libs-devel.])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_WARN([keyutils.h not found, consider installing keyutil=
s-libs-devel. Disabling cifscreds.])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 enable_cifscreds=3D"no"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
> =A0fi
>
>
> @@ -175,7 +183,7 @@ fi
> =A0LIBS=3D$cu_saved_libs
>
> =A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" !=3D =
"no"])
> -AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D "yes"=
])
> +AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" !=3D "no"=
])
> =A0AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D "n=
o"])
> =A0AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" !=3D "no"])
>
> --
> 1.7.7.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
