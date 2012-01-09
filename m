From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils: make fails if keyutils isn't installed
Date: Mon, 9 Jan 2012 12:32:20 -0600
Message-ID: <CADT32eLQbOB_TCWwKMgjkwiV0aA8upZsZQpsOaoUMEH6va_t_A@mail.gmail.com>
References: <20120109160015.GB16818@pervalidus>
	<20120109124038.581218c9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=
	<fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120109124038.581218c9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/1/9 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Mon, 9 Jan 2012 14:00:15 -0200
> Fr=E9d=E9ric L. W. Meunier =A0<fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org> wrote:
>
>> I moved from cifs-utils 5.0 to 5.2. I didn't have keyutils installed=
 and
>> the compilation failed because configure checks for its presence, bu=
t
>> doesn't abort if it's missing, and make tries to link to it.
>>
>> ...
>> checking keyutils.h usability... no
>> checking keyutils.h presence... no
>> checking for keyutils.h... no
>> configure: WARNING: keyutils.h not found, consider installing
>> keyutils-libs-devel. Disabling cifs.upcall.
>> configure: WARNING: keyutils.h not found, consider installing
>> keyutils-libs-devel. Disabling cifs.idmap.
>> ...
>>
>> Makefile.in:
>>
>> @CONFIG_CIFSACL_TRUE@getcifsacl_LDADD =3D -lkeyutils $(WINB_LDADD)
>> @CONFIG_CIFSACL_TRUE@setcifsacl_LDADD =3D -lkeyutils $(WINB_LDADD)
>>
>> Apparently, getcifsacl and setcifsacl don't use keyutils at all, but
>> cifs-utils links to it ?
>
> Good catch. Does this patch fix it?
>
> ----------------------[snip]--------------------
>
> [PATCH] get/setcifsacl: don't link in -lkeyutils
>
> These binaries don't use keys API at all. There's no need to link in
> the keys library.
>
> Reported-by: Fr=E9d=E9ric L. W. Meunier =A0<fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0Makefile.am | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index cb20442..038cd0e 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -55,12 +55,12 @@ endif
> =A0if CONFIG_CIFSACL
> =A0bin_PROGRAMS +=3D getcifsacl
> =A0getcifsacl_SOURCES =3D getcifsacl.c
> -getcifsacl_LDADD =3D -lkeyutils $(WINB_LDADD)
> +getcifsacl_LDADD =3D $(WINB_LDADD)
> =A0man_MANS +=3D getcifsacl.1
>
> =A0bin_PROGRAMS +=3D setcifsacl
> =A0setcifsacl_SOURCES =3D setcifsacl.c
> -setcifsacl_LDADD =3D -lkeyutils $(WINB_LDADD)
> +setcifsacl_LDADD =3D $(WINB_LDADD)
> =A0man_MANS +=3D setcifsacl.1
>
> =A0endif
> --
> 1.7.7.4
>

Should have never listed keyutils library on the link line in
the first place.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
