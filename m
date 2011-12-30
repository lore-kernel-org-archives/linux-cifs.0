From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 06/53] CIFS: Add missing unicode handling routines
 needed by smb2
Date: Fri, 30 Dec 2011 07:42:08 -0500
Message-ID: <20111230074208.561b8fdb@tlielax.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-7-git-send-email-piastry@etersoft.ru>
	<CADT32e+W2Q-sVeKtxLVwLUTdxAJsRtr5CG=QVgMqR2_QL1aYKw@mail.gmail.com>
	<CAKywueQNRCdUHxDS9aLDrbiEw4CF5p31VReMXEVRcd9ALqW4UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
	Steve French <sfrench@us.ibm.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Pavel Shilovsky <piastry@etersoft.ru>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKywueQNRCdUHxDS9aLDrbiEw4CF5p31VReMXEVRcd9ALqW4UQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 29 Dec 2011 19:01:24 +0400
Pavel Shilovsky <piastry@etersoft.ru> wrote:

> 2011/11/1 Shirish Pargaonkar <shirishpargaonkar@gmail.com>:
> > On Fri, Oct 28, 2011 at 2:54 PM, Pavel Shilovsky <piastry@etersoft.=
ru> wrote:
> >> From: Steve French <sfrench@us.ibm.com>
> >>
> >> Signed-off-by: Steve French <sfrench@us.ibm.com>
> >> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
> >> ---
> >> =C2=A0fs/cifs/cifs_unicode.c | =C2=A0 61 +++++++++++++++++++++++++=
+++++++++++++++++++++++
> >> =C2=A0fs/cifs/cifs_unicode.h | =C2=A0 =C2=A07 +++++
> >> =C2=A02 files changed, 68 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> >> index 1b2e180..7f09423 100644
> >> --- a/fs/cifs/cifs_unicode.c
> >> +++ b/fs/cifs/cifs_unicode.c
> >> @@ -330,3 +330,64 @@ ctoUCS_out:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0return i;
> >> =C2=A0}
> >>
> >> +#ifdef CONFIG_CIFS_SMB2
> >> +/*
> >> + * smb2_local_to_ucs2_bytes - how long will a string be after con=
version?
> >> + * @from - pointer to input string
> >> + * @maxbytes - don't go past this many bytes of input string
> >> + * @codepage - source codepage
> >> + *
> >> + * Walk a string and return the number of bytes that the string w=
ill
> >> + * be after being converted to the given charset, not including a=
ny null
> >> + * termination required. Don't walk past maxbytes in the source b=
uffer.
> >> + */
> >> +
> >> +int
> >> +smb2_local_to_ucs2_bytes(const char *from, int len,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 const struct nls_table *codepage)
> >> +{
> >> + =C2=A0 =C2=A0 =C2=A0 int charlen;
> >> + =C2=A0 =C2=A0 =C2=A0 int i;
> >> + =C2=A0 =C2=A0 =C2=A0 wchar_t wchar_to;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 if (from =3D=3D NULL)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;

		^^^^^^^^
Are there really cases where you'll pass in a NULL pointer here?

> >> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; len && *from; i++, from +=3D =
charlen, len -=3D charlen) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 charlen =3D cod=
epage->char2uni(from, len, &wchar_to);
								^^^^
						This may result	in an unaligned
						access. You should use
						put_unaligned to place this
						in the string.

> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Failed conve=
rsion defaults to a question mark */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (charlen < 1=
)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 charlen =3D 1;
> >> + =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 return 2 * i; /* UCS characters are two byt=
es */
> >> +}
> >> +
> >> +/*
> >> + * smb2_strndup_to_ucs - copy a string to wire format from the lo=
cal codepage
> >> + * @src - source string
> >> + * @maxlen - don't walk past this many bytes in the source string
> >> + * @ucslen - the length of the allocated string in bytes (includi=
ng null)
> >> + * @codepage - source codepage
> >> + *
> >> + * Take a string convert it from the local codepage to UCS2 and
> >> + * put it in a new buffer. Returns a pointer to the new string or=
 NULL on
> >> + * error.
> >> + */
> >> +__le16 *
> >> +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_l=
en,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nls_table =
*codepage)
> >> +{
> >> + =C2=A0 =C2=A0 =C2=A0 int len;
> >> + =C2=A0 =C2=A0 =C2=A0 __le16 *dst;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 len =3D smb2_local_to_ucs2_bytes(src, maxle=
n, codepage);
> >> + =C2=A0 =C2=A0 =C2=A0 len +=3D 2; /* NULL */
> >> + =C2=A0 =C2=A0 =C2=A0 dst =3D kmalloc(len, GFP_KERNEL);
> >> + =C2=A0 =C2=A0 =C2=A0 if (!dst) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ucs_len =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> + =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 cifs_strtoUCS(dst, src, maxlen, codepage);
> >> + =C2=A0 =C2=A0 =C2=A0 *ucs_len =3D len;
> >> + =C2=A0 =C2=A0 =C2=A0 return dst;
> >> +}
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> >> index 6d02fd5..e00f677 100644
> >> --- a/fs/cifs/cifs_unicode.h
> >> +++ b/fs/cifs/cifs_unicode.h
> >> @@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
> >>
> >> =C2=A0#endif
> >>
> >> +#ifdef CONFIG_CIFS_SMB2
> >> +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct nls_t=
able *codepage);
> >> +extern __le16 *smb2_strndup_to_ucs(const char *src, const int max=
len,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *ucs_len, const=
 struct nls_table *cp);
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> +
> >> =C2=A0#endif /* _CIFS_UNICODE_H */
> >> --
> >> 1.7.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >>
> >
> > Should these functions be renamed to *utf16* instead of *ucs*
> > to reflect the unicode encoding used in cifs/smb2 protocol?
>=20
> Seems no problem to rename it.
>=20
> Jeff, Steve, thoughts? If no objections - I will rename *ucs* to *utf=
16*.
>=20
Yeah, now that I look over the NLS code, it does seem to be converting
to UTF16 and not to UCS2. You should probably rename the existing *ucs*
functions in cifs_unicode.c as well.

Also, we should probably settle on a prefix for these that makes sense.
These are only currently used by smb2 code, but they aren't truly
smb2-specific. I'd name them cifs_* myself, but maybe something more
neutral makes sense?

--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
