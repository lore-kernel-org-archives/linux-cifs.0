From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: remove unneeded variable initialization in
 cifs_reconnect_tcon
Date: Tue, 5 Apr 2011 10:28:39 -0700
Message-ID: <20110405102839.7949d1ef@corrin.poochiereds.net>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
	<1301607405-4379-3-git-send-email-jlayton@redhat.com>
	<BANLkTin4Js462-nZcBcSYD6YO_1b9UEeRA@mail.gmail.com>
	<20110405101729.27657db0@corrin.poochiereds.net>
	<BANLkTi=pfFJKs3ZE1ogZrxpaJGf94RFxew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=pfFJKs3ZE1ogZrxpaJGf94RFxew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Apr 2011 12:20:52 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Apr 5, 2011 at 12:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Tue, 5 Apr 2011 12:06:59 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> This is fine, but what about this alternative (initializing variab=
les
> >> can make code easier to read, and given dumb compiler warnings
> >> sometimes better to leave in variable initialization ...):
> >>
> >> stevef@stevef-laptop:~/cifs-2.6$ git diff -a
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index 92e33d4..e4993a2 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -117,7 +117,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, in=
t smb_command)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* calling routine
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!tcon)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ses =3D tcon->ses;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 server =3D ses->server;
> >>
> >>
> >
> > So instead of eliminating a useless variable initialization, we ins=
tead
> > manufacture a use for it? That seems sort of counter-productive, no=
?
>=20
> since we do "return rc" later in the function, why wouldn't we do the
> same earlier
> in the function for consistency? With rc initialized it is a bit easi=
er to read.
>=20

In those places, we're returning rc because we called a function and
stored the return code from it in rc. You certainly could "return rc"
solely (and possibly use a "goto out" and have a single exit point for
the function). The above patch doesn't do that though, it only changes
the first spot where it does a "return 0".

If you want to make that change then you probably ought to change the
other places in the function for consistency. Again though, it seems
pointless to me. Leaving it unintialized may help the compiler catch
places where we "return rc" without setting it intentionally.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
