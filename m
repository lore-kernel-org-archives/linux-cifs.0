From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-3.4-rc5 bug report
Date: Tue, 8 May 2012 17:22:31 -0500
Message-ID: <CAH2r5mv1tPSk2=FUxEzpgUrQnMEiO1G+b6EdiOY58n++xv6W2w@mail.gmail.com>
References: <BLU154-W21EFFE6169578ACDF457C39C130@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BLU154-W21EFFE6169578ACDF457C39C130-MsuGFMq8XAE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=46ix from Dan is now merged into cifs-2.6.git

On Mon, May 7, 2012 at 11:55 AM, David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org> w=
rote:
> Hello there,
>
> I just compiled the Linux kernel linux-3.4-rc5, with
> the extra flag -Wlogical-op.
>
> The compiler said
>
> fs/cifs/cifsfs.c:702:2: warning: logical =91or=92 of collectively exh=
austive
> tests is always true [-Wlogical-op]
>
> The source code is
>
> =A0=A0=A0 if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
>
> It might be the case that
>
> =A0=A0=A0 if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
>
> was intended.
>
> Regards
>
> David Binderman
>



--=20
Thanks,

Steve
