From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 06/53] CIFS: Add missing unicode handling routines
 needed by smb2
Date: Thu, 12 Jan 2012 15:48:14 -0500
Message-ID: <20120112154814.52a09175@tlielax.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-7-git-send-email-piastry@etersoft.ru>
	<CADT32eJ7FMkQZiy4LjeEG3axvt99N7jFEod7-u2js1MnhVkc7Q@mail.gmail.com>
	<20120112134223.1250b0b9@dantu.rdu.redhat.com>
	<CADT32eKc=Xq5G1cE+pye6h1dN6sjry+b7V0ze7CTMJXC8JCtwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKc=Xq5G1cE+pye6h1dN6sjry+b7V0ze7CTMJXC8JCtwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 12 Jan 2012 13:58:50 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jan 12, 2012 at 12:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Thu, 12 Jan 2012 11:22:35 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Oct 28, 2011 at 2:54 PM, Pavel Shilovsky <piastry@etersoft=
=2Eru> wrote:
> >> > From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> >
> >> > Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> > ---
> >> > =C2=A0fs/cifs/cifs_unicode.c | =C2=A0 61 +++++++++++++++++++++++=
+++++++++++++++++++++++++
> >> > =C2=A0fs/cifs/cifs_unicode.h | =C2=A0 =C2=A07 +++++
> >> > =C2=A02 files changed, 68 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> >> > index 1b2e180..7f09423 100644
> >> > --- a/fs/cifs/cifs_unicode.c
> >> > +++ b/fs/cifs/cifs_unicode.c
> >> > @@ -330,3 +330,64 @@ ctoUCS_out:
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return i;
> >> > =C2=A0}
> >> >
> >> > +#ifdef CONFIG_CIFS_SMB2
> >> > +/*
> >> > + * smb2_local_to_ucs2_bytes - how long will a string be after c=
onversion?
> >> > + * @from - pointer to input string
> >> > + * @maxbytes - don't go past this many bytes of input string
> >> > + * @codepage - source codepage
> >> > + *
> >> > + * Walk a string and return the number of bytes that the string=
 will
> >> > + * be after being converted to the given charset, not including=
 any null
> >> > + * termination required. Don't walk past maxbytes in the source=
 buffer.
> >> > + */
> >> > +
> >> > +int
> >> > +smb2_local_to_ucs2_bytes(const char *from, int len,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 const struct nls_table *codepage)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 int charlen;
> >> > + =C2=A0 =C2=A0 =C2=A0 int i;
> >> > + =C2=A0 =C2=A0 =C2=A0 wchar_t wchar_to;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (from =3D=3D NULL)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; len && *from; i++, from +=3D=
 charlen, len -=3D charlen) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 charlen =3D c=
odepage->char2uni(from, len, &wchar_to);
> >>
> >> Why call function char2uni? =C2=A0It either returns 1 or EINVAL.
> >> If it returns EINVAL, charlen is set to 1. =C2=A0So either way cha=
rlen
> >> will always be 1.
> >> So why not just call strlen(from) to determine the length of the s=
tring?
> >>
> >
> > I thought char2uni returned the width of the character. That's not
> > necessarily going to be 1 in all cases.
> >
>=20
> It is very confusing.   Does width of the character means width of th=
e
> unicode character?  If so, should not it be the same for all unicode
> characters?  Or by width of the character, is it meant the width of
> the encoding of a unicode character?  If so, I do not see anywhere
> in fs/nls direcotry any char2uni function returning width of a
> utf16 encoding of a unicode character corrosponding to a character
> within the native codepath
>=20
>=20

I meant the width of the original character. The result is always going
to be 2 bytes, but the original character can be up to 4 bytes long in
the case of UTF-8.

I think Pavel is quite correct to call char2uni this way in order to
determine the length of the resulting string.


> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Failed con=
version defaults to a question mark */
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (charlen <=
 1)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 charlen =3D 1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > + =C2=A0 =C2=A0 =C2=A0 return 2 * i; /* UCS characters are two b=
ytes */
> >> > +}
> >> > +
> >> > +/*
> >> > + * smb2_strndup_to_ucs - copy a string to wire format from the =
local codepage
> >> > + * @src - source string
> >> > + * @maxlen - don't walk past this many bytes in the source stri=
ng
> >> > + * @ucslen - the length of the allocated string in bytes (inclu=
ding null)
> >> > + * @codepage - source codepage
> >> > + *
> >> > + * Take a string convert it from the local codepage to UCS2 and
> >> > + * put it in a new buffer. Returns a pointer to the new string =
or NULL on
> >> > + * error.
> >> > + */
> >> > +__le16 *
> >> > +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs=
_len,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nls_tabl=
e *codepage)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 int len;
> >> > + =C2=A0 =C2=A0 =C2=A0 __le16 *dst;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 len =3D smb2_local_to_ucs2_bytes(src, max=
len, codepage);
> >> > + =C2=A0 =C2=A0 =C2=A0 len +=3D 2; /* NULL */
> >> > + =C2=A0 =C2=A0 =C2=A0 dst =3D kmalloc(len, GFP_KERNEL);
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!dst) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ucs_len =3D =
0;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > + =C2=A0 =C2=A0 =C2=A0 cifs_strtoUCS(dst, src, maxlen, codepage)=
;
> >> > + =C2=A0 =C2=A0 =C2=A0 *ucs_len =3D len;
> >> > + =C2=A0 =C2=A0 =C2=A0 return dst;
> >> > +}
> >> > +#endif /* CONFIG_CIFS_SMB2 */
> >> > diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> >> > index 6d02fd5..e00f677 100644
> >> > --- a/fs/cifs/cifs_unicode.h
> >> > +++ b/fs/cifs/cifs_unicode.h
> >> > @@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
> >> >
> >> > =C2=A0#endif
> >> >
> >> > +#ifdef CONFIG_CIFS_SMB2
> >> > +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct n=
ls_table *codepage);
> >> > +extern __le16 *smb2_strndup_to_ucs(const char *src, const int m=
axlen,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *ucs_len, c=
onst struct nls_table *cp);
> >> > +#endif /* CONFIG_CIFS_SMB2 */
> >> > +
> >> > =C2=A0#endif /* _CIFS_UNICODE_H */
> >> > --
> >> > 1.7.1
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
cifs" in
> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-in=
fo.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
