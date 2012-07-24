From: =?iso-8859-1?q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: reinstate sec=ntlmv2 mount option
Date: Tue, 24 Jul 2012 04:35:59 +0200
Message-ID: <201207240436.00213.linux@kukkukk.com>
References: <1343090057-32700-1-git-send-email-jlayton@redhat.com> <CAH2r5mt=ZcO7pPodj++oNRkNrnZum=FBAE0RxoyyWVSsi2KqFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt=ZcO7pPodj++oNRkNrnZum=FBAE0RxoyyWVSsi2KqFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am Dienstag, 24. Juli 2012, 03:47:30 schrieb Steve French:
> probably could alias this (sec=3Dntlmv2) in mount.cifs as well if we
> need a fast fix without kernel update.
>=20
> On Mon, Jul 23, 2012 at 7:34 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > sec=3Dntlmv2 as a mount option got dropped in the mount option over=
haul.
> >=20
> > Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.4+
> > Reported-by: G=FCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >=20
> >  fs/cifs/connect.c |    9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index e8c3e6b..a675b7f 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -238,8 +238,8 @@ static const match_table_t cifs_mount_option_to=
kens =3D
> > {
> >=20
> >  enum {
> > =20
> >         Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
> >         Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
> >=20
> > -       Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2i,
> > -       Opt_sec_nontlm, Opt_sec_lanman,
> > +       Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2,
> > +       Opt_sec_ntlmv2i, Opt_sec_lanman,
> >=20
> >         Opt_sec_none,
> >        =20
> >         Opt_sec_err
> >=20
> > @@ -253,8 +253,9 @@ static const match_table_t cifs_secflavor_token=
s =3D {
> >=20
> >         { Opt_sec_ntlmssp, "ntlmssp" },
> >         { Opt_ntlm, "ntlm" },
> >         { Opt_sec_ntlmi, "ntlmi" },
> >=20
> > +       { Opt_sec_ntlmv2, "nontlm" },
> > +       { Opt_sec_ntlmv2, "ntlmv2" },
> >=20
> >         { Opt_sec_ntlmv2i, "ntlmv2i" },
> >=20
> > -       { Opt_sec_nontlm, "nontlm" },
> >=20
> >         { Opt_sec_lanman, "lanman" },
> >         { Opt_sec_none, "none" },
> >=20
> > @@ -1167,7 +1168,7 @@ static int cifs_parse_security_flavors(char *=
value,
> >=20
> >         case Opt_sec_ntlmi:
> >                 vol->secFlg |=3D CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SI=
GN;
> >                 break;
> >=20
> > -       case Opt_sec_nontlm:
> >=20
> > +       case Opt_sec_ntlmv2:
> >                 vol->secFlg |=3D CIFSSEC_MAY_NTLMV2;
> >                 break;
> >        =20
> >         case Opt_sec_ntlmv2i:
> > --
> > 1.7.10.4

on IRC Jeff already mentioned "sec=3Dnontlm" as a current workaround.
The complaining user (not being able to use sec=3Dntlmv2) reported
success using that workaround (obviously).

So i think, mount.cifs should never ever been overloaded with
another alias.

Cheers, G=FCnter

Btw - how is the "man" page updated at
   http://www.samba.org/samba/docs/man/manpages-3/mount.cifs.8.html
seems to be not uptodate
