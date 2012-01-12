From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH v2 06/53] CIFS: Add missing unicode handling routines
 needed by smb2
Date: Thu, 12 Jan 2012 13:58:50 -0600
Message-ID: <CADT32eKc=Xq5G1cE+pye6h1dN6sjry+b7V0ze7CTMJXC8JCtwA@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-7-git-send-email-piastry@etersoft.ru>
	<CADT32eJ7FMkQZiy4LjeEG3axvt99N7jFEod7-u2js1MnhVkc7Q@mail.gmail.com>
	<20120112134223.1250b0b9@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry@etersoft.ru>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Steve French <sfrench@us.ibm.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120112134223.1250b0b9@dantu.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jan 12, 2012 at 12:42 PM, Jeff Layton <jlayton@samba.org> wrote=
:
> On Thu, 12 Jan 2012 11:22:35 -0600
> Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:
>
>> On Fri, Oct 28, 2011 at 2:54 PM, Pavel Shilovsky <piastry@etersoft.r=
u> wrote:
>> > From: Steve French <sfrench@us.ibm.com>
>> >
>> > Signed-off-by: Steve French <sfrench@us.ibm.com>
>> > Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> > ---
>> > =A0fs/cifs/cifs_unicode.c | =A0 61 +++++++++++++++++++++++++++++++=
+++++++++++++++++
>> > =A0fs/cifs/cifs_unicode.h | =A0 =A07 +++++
>> > =A02 files changed, 68 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> > index 1b2e180..7f09423 100644
>> > --- a/fs/cifs/cifs_unicode.c
>> > +++ b/fs/cifs/cifs_unicode.c
>> > @@ -330,3 +330,64 @@ ctoUCS_out:
>> > =A0 =A0 =A0 =A0return i;
>> > =A0}
>> >
>> > +#ifdef CONFIG_CIFS_SMB2
>> > +/*
>> > + * smb2_local_to_ucs2_bytes - how long will a string be after con=
version?
>> > + * @from - pointer to input string
>> > + * @maxbytes - don't go past this many bytes of input string
>> > + * @codepage - source codepage
>> > + *
>> > + * Walk a string and return the number of bytes that the string w=
ill
>> > + * be after being converted to the given charset, not including a=
ny null
>> > + * termination required. Don't walk past maxbytes in the source b=
uffer.
>> > + */
>> > +
>> > +int
>> > +smb2_local_to_ucs2_bytes(const char *from, int len,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls=
_table *codepage)
>> > +{
>> > + =A0 =A0 =A0 int charlen;
>> > + =A0 =A0 =A0 int i;
>> > + =A0 =A0 =A0 wchar_t wchar_to;
>> > +
>> > + =A0 =A0 =A0 if (from =3D=3D NULL)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > + =A0 =A0 =A0 for (i =3D 0; len && *from; i++, from +=3D charlen, =
len -=3D charlen) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from,=
 len, &wchar_to);
>>
>> Why call function char2uni? =A0It either returns 1 or EINVAL.
>> If it returns EINVAL, charlen is set to 1. =A0So either way charlen
>> will always be 1.
>> So why not just call strlen(from) to determine the length of the str=
ing?
>>
>
> I thought char2uni returned the width of the character. That's not
> necessarily going to be 1 in all cases.
>

It is very confusing.   Does width of the character means width of the
unicode character?  If so, should not it be the same for all unicode
characters?  Or by width of the character, is it meant the width of
the encoding of a unicode character?  If so, I do not see anywhere
in fs/nls direcotry any char2uni function returning width of a
utf16 encoding of a unicode character corrosponding to a character
within the native codepath


>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Failed conversion defaults to a q=
uestion mark */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 return 2 * i; /* UCS characters are two bytes */
>> > +}
>> > +
>> > +/*
>> > + * smb2_strndup_to_ucs - copy a string to wire format from the lo=
cal codepage
>> > + * @src - source string
>> > + * @maxlen - don't walk past this many bytes in the source string
>> > + * @ucslen - the length of the allocated string in bytes (includi=
ng null)
>> > + * @codepage - source codepage
>> > + *
>> > + * Take a string convert it from the local codepage to UCS2 and
>> > + * put it in a new buffer. Returns a pointer to the new string or=
 NULL on
>> > + * error.
>> > + */
>> > +__le16 *
>> > +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_l=
en,
>> > + =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
>> > +{
>> > + =A0 =A0 =A0 int len;
>> > + =A0 =A0 =A0 __le16 *dst;
>> > +
>> > + =A0 =A0 =A0 len =3D smb2_local_to_ucs2_bytes(src, maxlen, codepa=
ge);
>> > + =A0 =A0 =A0 len +=3D 2; /* NULL */
>> > + =A0 =A0 =A0 dst =3D kmalloc(len, GFP_KERNEL);
>> > + =A0 =A0 =A0 if (!dst) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *ucs_len =3D 0;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 cifs_strtoUCS(dst, src, maxlen, codepage);
>> > + =A0 =A0 =A0 *ucs_len =3D len;
>> > + =A0 =A0 =A0 return dst;
>> > +}
>> > +#endif /* CONFIG_CIFS_SMB2 */
>> > diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
>> > index 6d02fd5..e00f677 100644
>> > --- a/fs/cifs/cifs_unicode.h
>> > +++ b/fs/cifs/cifs_unicode.h
>> > @@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
>> >
>> > =A0#endif
>> >
>> > +#ifdef CONFIG_CIFS_SMB2
>> > +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 const struct nls_table *codepage);
>> > +extern __le16 *smb2_strndup_to_ucs(const char *src, const int max=
len,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0int *ucs_len, const struct nls_table *cp);
>> > +#endif /* CONFIG_CIFS_SMB2 */
>> > +
>> > =A0#endif /* _CIFS_UNICODE_H */
>> > --
>> > 1.7.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> Jeff Layton <jlayton@samba.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
