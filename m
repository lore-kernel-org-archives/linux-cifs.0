From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 06/53] CIFS: Add missing unicode handling routines
 needed by smb2
Date: Thu, 12 Jan 2012 13:42:23 -0500
Message-ID: <20120112134223.1250b0b9@dantu.rdu.redhat.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-7-git-send-email-piastry@etersoft.ru>
	<CADT32eJ7FMkQZiy4LjeEG3axvt99N7jFEod7-u2js1MnhVkc7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ7FMkQZiy4LjeEG3axvt99N7jFEod7-u2js1MnhVkc7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 12 Jan 2012 11:22:35 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Oct 28, 2011 at 2:54 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
> > From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >
> > Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > ---
> > =A0fs/cifs/cifs_unicode.c | =A0 61 ++++++++++++++++++++++++++++++++=
++++++++++++++++
> > =A0fs/cifs/cifs_unicode.h | =A0 =A07 +++++
> > =A02 files changed, 68 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> > index 1b2e180..7f09423 100644
> > --- a/fs/cifs/cifs_unicode.c
> > +++ b/fs/cifs/cifs_unicode.c
> > @@ -330,3 +330,64 @@ ctoUCS_out:
> > =A0 =A0 =A0 =A0return i;
> > =A0}
> >
> > +#ifdef CONFIG_CIFS_SMB2
> > +/*
> > + * smb2_local_to_ucs2_bytes - how long will a string be after conv=
ersion?
> > + * @from - pointer to input string
> > + * @maxbytes - don't go past this many bytes of input string
> > + * @codepage - source codepage
> > + *
> > + * Walk a string and return the number of bytes that the string wi=
ll
> > + * be after being converted to the given charset, not including an=
y null
> > + * termination required. Don't walk past maxbytes in the source bu=
ffer.
> > + */
> > +
> > +int
> > +smb2_local_to_ucs2_bytes(const char *from, int len,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_=
table *codepage)
> > +{
> > + =A0 =A0 =A0 int charlen;
> > + =A0 =A0 =A0 int i;
> > + =A0 =A0 =A0 wchar_t wchar_to;
> > +
> > + =A0 =A0 =A0 if (from =3D=3D NULL)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > + =A0 =A0 =A0 for (i =3D 0; len && *from; i++, from +=3D charlen, l=
en -=3D charlen) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from, =
len, &wchar_to);
>=20
> Why call function char2uni?  It either returns 1 or EINVAL.
> If it returns EINVAL, charlen is set to 1.  So either way charlen
> will always be 1.
> So why not just call strlen(from) to determine the length of the stri=
ng?
>=20

I thought char2uni returned the width of the character. That's not
necessarily going to be 1 in all cases.

> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Failed conversion defaults to a qu=
estion mark */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 return 2 * i; /* UCS characters are two bytes */
> > +}
> > +
> > +/*
> > + * smb2_strndup_to_ucs - copy a string to wire format from the loc=
al codepage
> > + * @src - source string
> > + * @maxlen - don't walk past this many bytes in the source string
> > + * @ucslen - the length of the allocated string in bytes (includin=
g null)
> > + * @codepage - source codepage
> > + *
> > + * Take a string convert it from the local codepage to UCS2 and
> > + * put it in a new buffer. Returns a pointer to the new string or =
NULL on
> > + * error.
> > + */
> > +__le16 *
> > +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_le=
n,
> > + =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
> > +{
> > + =A0 =A0 =A0 int len;
> > + =A0 =A0 =A0 __le16 *dst;
> > +
> > + =A0 =A0 =A0 len =3D smb2_local_to_ucs2_bytes(src, maxlen, codepag=
e);
> > + =A0 =A0 =A0 len +=3D 2; /* NULL */
> > + =A0 =A0 =A0 dst =3D kmalloc(len, GFP_KERNEL);
> > + =A0 =A0 =A0 if (!dst) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *ucs_len =3D 0;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 cifs_strtoUCS(dst, src, maxlen, codepage);
> > + =A0 =A0 =A0 *ucs_len =3D len;
> > + =A0 =A0 =A0 return dst;
> > +}
> > +#endif /* CONFIG_CIFS_SMB2 */
> > diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> > index 6d02fd5..e00f677 100644
> > --- a/fs/cifs/cifs_unicode.h
> > +++ b/fs/cifs/cifs_unicode.h
> > @@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
> >
> > =A0#endif
> >
> > +#ifdef CONFIG_CIFS_SMB2
> > +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const struct nls_table *codepage);
> > +extern __le16 *smb2_strndup_to_ucs(const char *src, const int maxl=
en,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
int *ucs_len, const struct nls_table *cp);
> > +#endif /* CONFIG_CIFS_SMB2 */
> > +
> > =A0#endif /* _CIFS_UNICODE_H */
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
