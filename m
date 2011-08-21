From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: --enable-cifsidmap [default=no]
Date: Sun, 21 Aug 2011 16:20:54 -0500
Message-ID: <CADT32eKZX76FfX_6NduO8XXwBq0hoA2av5BrtOTAqC413HnStg@mail.gmail.com>
References: <20110821.174050.349078853015387924.pipping@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110821.174050.349078853015387924.pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 21, 2011 at 10:40 AM, Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org> w=
rote:
> Hello,
>
> configure.ac from cifs-utils 5.0 contains
>
> =A0AC_ARG_ENABLE(cifsidmap,
> =A0 =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifsidmap],
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[Create cifs.idmap=
 binary @<:@default=3Dno@:>@])],
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D$enableval,
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D"maybe")
>

I think this is correct instead of outright no.  If you do not specify
either --enable-cifsidmap or --disable-idmap, by default the
option is enabled and dependent things are built provided
needed headers and libraries are installed, if they are not,
enable_cifsidmap becomes "no" and so does
CONFIG_CIFSIDMAP become false.

If you changed it to enable_cifsidmap=3D"no", by default it is
nothing related gets built even if you requisite headers and
libraries installed.

> From my understanding, this should either be
>
> =A0AC_ARG_ENABLE(cifsidmap,
> =A0 =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifsidmap],
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[Create cifs.idmap=
 binary @<:@default=3Dno@:>@])],
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D$enableval,
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D"no")
>
> or
>
> =A0AC_ARG_ENABLE(cifsidmap,
> =A0 =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifsidmap],
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[Create cifs.idmap=
 binary @<:@default=3Dyes@:>@])],
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D$enableval,
> =A0 =A0 =A0 =A0 =A0enable_cifsidmap=3D"maybe")
>
>
> Best regards,
>
> Elias Pipping
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
