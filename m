From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix cifsConvertToUCS() for the mapchars case
Date: Mon, 16 May 2011 06:49:37 -0400
Message-ID: <20110516064937.7f276d85@corrin.poochiereds.net>
References: <1305257555-20656-1-git-send-email-metze@samba.org>
	<1305257555-20656-2-git-send-email-metze@samba.org>
	<20110513201705.7fe75309@tlielax.poochiereds.net>
	<BANLkTikmaFFF3sj_GGcPXru+=ALXMvmudg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikmaFFF3sj_GGcPXru+=ALXMvmudg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 15 May 2011 20:38:24 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Probably too late for 2.6.39 for a patch to a non-default mount optio=
n
> (but I agree that it should go to stable).  Thoughts?
>=20

You're proposing to fix it in 2.6.38-stable, but leave it broken in
2.6.39? That doesn't make much sense to me...

> Jeff's suggestion below makes sense.
>=20
> On Fri, May 13, 2011 at 7:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 13 May 2011 05:32:35 +0200
> > Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >
> >> Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
> >> (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
> >> in just one commit (moving the function and changing it without te=
sting).
> >>
> >> put_unaligned_le16(temp, &target[j]); is never called for any code=
point
> >> the goes via the 'default' switch statement. As a result we put
> >> just zero (or maybe uninitialized) bytes into the target buffer,
> >>
> >> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifs_unicode.c | =C2=A0 20 ++++++++++----------
> >> =C2=A01 files changed, 10 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> >> index fc0fd4f..b1ff0bd 100644
> >> --- a/fs/cifs/cifs_unicode.c
> >> +++ b/fs/cifs/cifs_unicode.c
> >> @@ -276,6 +276,7 @@ cifsConvertToUCS(__le16 *target, const char *s=
ource, int maxlen,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return cifs_strto=
UCS(target, source, PATH_MAX, cp);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0, j =3D 0; i < maxlen; j++) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 charlen =3D 1;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 src_char =3D sour=
ce[i];
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (src_char)=
 {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 0:
> >> @@ -315,18 +316,17 @@ cifsConvertToUCS(__le16 *target, const char =
*source, int maxlen,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp =3D 0x003f;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 charlen =3D 1;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 len_remaining -=3D charlen;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /*
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* character may take more than one byte in the source
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* string, but will take exactly two bytes in the
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* target string
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*/
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 i +=3D charlen;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* character may =
take more than one byte in the source
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* string, but wi=
ll take exactly two bytes in the
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* target string
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_unaligned_le1=
6(temp, &target[j]);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++; /* move to next c=
har in source string */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len_remaining--;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* move to next char i=
n source string */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i +=3D charlen;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len_remaining -=3D cha=
rlen;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0ctoUCS_out:
> >
> > Oof. Yeah, I broke it alright -- good catch...
> >
> > This patch probably won't apply to the current head of the tree,
> > however. Rather than have a special patch for 2.6.38 and .39, what =
may
> > be best is to go ahead and push 581ade4d in Steve's master branch t=
o
> > stable, and then apply something like this untested patch on top of=
 it.
> >
> > I'll plan to test it out when I get a chance, but I think that's
> > probably the best approach.
> >
> > Thoughts?
> >
> > -----------------[snip]--------------------
> >
> > cifs: fix cifsConvertToUCS() for the mapchars case
> >
> > As Metze pointed out, commit 84cdf74e broke mapchars case:
> >
> > =C2=A0 =C2=A0Commit "cifs: fix unaligned accesses in cifsConvertToU=
CS"
> > =C2=A0 =C2=A0(84cdf74e8096a10dd6acbb870dd404b92f07a756) does multip=
le steps
> > =C2=A0 =C2=A0in just one commit (moving the function and changing i=
t without
> > =C2=A0 =C2=A0testing).
> >
> > =C2=A0 =C2=A0put_unaligned_le16(temp, &target[j]); is never called =
for any
> > =C2=A0 =C2=A0codepoint the goes via the 'default' switch statement.=
 As a result
> > =C2=A0 =C2=A0we put just zero (or maybe uninitialized) bytes into t=
he target
> > =C2=A0 =C2=A0buffer.
> >
> > His proposed patch looks correct, but doesn't apply to the current =
head
> > of the tree. This patch should also fix it.
> >
> > Reported-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifs_unicode.c | =C2=A0 14 ++++++--------
> > =C2=A01 files changed, 6 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> > index 23d43cd..1b2e180 100644
> > --- a/fs/cifs/cifs_unicode.c
> > +++ b/fs/cifs/cifs_unicode.c
> > @@ -277,6 +277,7 @@ cifsConvertToUCS(__le16 *target, const char *so=
urce, int srclen,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0, j =3D 0; i < srclen; j++) =
{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0src_char =3D=
 source[i];
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 charlen =3D 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (src_=
char) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 0:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0put_unaligned(0, &target[j]);
> > @@ -316,16 +317,13 @@ cifsConvertToUCS(__le16 *target, const char *=
source, int srclen,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dst_char =3D cpu_to_le16(0x00=
3f);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0charlen =3D 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /*
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* character may take more than one byte in the source
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* string, but will take exactly two bytes in the
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* target string
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*/
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 i +=3D charlen;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* characte=
r may take more than one byte in the source string,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* but will=
 take exactly two bytes in the target string
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i +=3D charlen;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_unaligne=
d(dst_char, &target[j]);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++; /* move to =
next char in source string */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0ctoUCS_out:
> > --
> > 1.7.4.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
