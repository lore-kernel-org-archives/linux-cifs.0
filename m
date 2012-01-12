From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH v2 06/53] CIFS: Add missing unicode handling routines
 needed by smb2
Date: Thu, 12 Jan 2012 14:47:31 +0400
Message-ID: <CAKywueRSu2buLFysfaX1EsaWcoj5dctB1j4vA28jPrMuCLn6Zg@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-7-git-send-email-piastry@etersoft.ru>
	<CADT32e+W2Q-sVeKtxLVwLUTdxAJsRtr5CG=QVgMqR2_QL1aYKw@mail.gmail.com>
	<CAKywueQNRCdUHxDS9aLDrbiEw4CF5p31VReMXEVRcd9ALqW4UQ@mail.gmail.com>
	<20111230074208.561b8fdb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
	Steve French <sfrench@us.ibm.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111230074208.561b8fdb@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/12/30 Jeff Layton <jlayton@redhat.com>:
> On Thu, 29 Dec 2011 19:01:24 +0400
> Pavel Shilovsky <piastry@etersoft.ru> wrote:
>
>> 2011/11/1 Shirish Pargaonkar <shirishpargaonkar@gmail.com>:
>> > On Fri, Oct 28, 2011 at 2:54 PM, Pavel Shilovsky <piastry@etersoft=
=2Eru> wrote:
>> >> From: Steve French <sfrench@us.ibm.com>
>> >>
>> >> Signed-off-by: Steve French <sfrench@us.ibm.com>
>> >> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> >> ---
>> >> =A0fs/cifs/cifs_unicode.c | =A0 61 ++++++++++++++++++++++++++++++=
++++++++++++++++++
>> >> =A0fs/cifs/cifs_unicode.h | =A0 =A07 +++++
>> >> =A02 files changed, 68 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> >> index 1b2e180..7f09423 100644
>> >> --- a/fs/cifs/cifs_unicode.c
>> >> +++ b/fs/cifs/cifs_unicode.c
>> >> @@ -330,3 +330,64 @@ ctoUCS_out:
>> >> =A0 =A0 =A0 =A0return i;
>> >> =A0}
>> >>
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> +/*
>> >> + * smb2_local_to_ucs2_bytes - how long will a string be after co=
nversion?
>> >> + * @from - pointer to input string
>> >> + * @maxbytes - don't go past this many bytes of input string
>> >> + * @codepage - source codepage
>> >> + *
>> >> + * Walk a string and return the number of bytes that the string =
will
>> >> + * be after being converted to the given charset, not including =
any null
>> >> + * termination required. Don't walk past maxbytes in the source =
buffer.
>> >> + */
>> >> +
>> >> +int
>> >> +smb2_local_to_ucs2_bytes(const char *from, int len,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nl=
s_table *codepage)
>> >> +{
>> >> + =A0 =A0 =A0 int charlen;
>> >> + =A0 =A0 =A0 int i;
>> >> + =A0 =A0 =A0 wchar_t wchar_to;
>> >> +
>> >> + =A0 =A0 =A0 if (from =3D=3D NULL)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> Are there really cases where you'll pass in a NULL pointer here?

Good catch, thanks!
>
>> >> + =A0 =A0 =A0 for (i =3D 0; len && *from; i++, from +=3D charlen,=
 len -=3D charlen) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from=
, len, &wchar_to);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0This may result in an unaligned
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0access. You should use
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0put_unaligned to place this
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0in the string.

We only count the length of new unicode string here - so, don't need
to put it somewhere.

>
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Failed conversion defaults to a =
question mark */
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
>> >> + =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 return 2 * i; /* UCS characters are two bytes */
>> >> +}
>> >> +
>> >> +/*
>> >> + * smb2_strndup_to_ucs - copy a string to wire format from the l=
ocal codepage
>> >> + * @src - source string
>> >> + * @maxlen - don't walk past this many bytes in the source strin=
g
>> >> + * @ucslen - the length of the allocated string in bytes (includ=
ing null)
>> >> + * @codepage - source codepage
>> >> + *
>> >> + * Take a string convert it from the local codepage to UCS2 and
>> >> + * put it in a new buffer. Returns a pointer to the new string o=
r NULL on
>> >> + * error.
>> >> + */
>> >> +__le16 *
>> >> +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_=
len,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
>> >> +{
>> >> + =A0 =A0 =A0 int len;
>> >> + =A0 =A0 =A0 __le16 *dst;
>> >> +
>> >> + =A0 =A0 =A0 len =3D smb2_local_to_ucs2_bytes(src, maxlen, codep=
age);
>> >> + =A0 =A0 =A0 len +=3D 2; /* NULL */
>> >> + =A0 =A0 =A0 dst =3D kmalloc(len, GFP_KERNEL);
>> >> + =A0 =A0 =A0 if (!dst) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *ucs_len =3D 0;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> >> + =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 cifs_strtoUCS(dst, src, maxlen, codepage);
>> >> + =A0 =A0 =A0 *ucs_len =3D len;
>> >> + =A0 =A0 =A0 return dst;
>> >> +}
>> >> +#endif /* CONFIG_CIFS_SMB2 */
>> >> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
>> >> index 6d02fd5..e00f677 100644
>> >> --- a/fs/cifs/cifs_unicode.h
>> >> +++ b/fs/cifs/cifs_unicode.h
>> >> @@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
>> >>
>> >> =A0#endif
>> >>
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 const struct nls_table *codepage);
>> >> +extern __le16 *smb2_strndup_to_ucs(const char *src, const int ma=
xlen,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0int *ucs_len, const struct nls_table *cp);
>> >> +#endif /* CONFIG_CIFS_SMB2 */
>> >> +
>> >> =A0#endif /* _CIFS_UNICODE_H */
>> >> --
>> >> 1.7.1
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-c=
ifs" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> > Should these functions be renamed to *utf16* instead of *ucs*
>> > to reflect the unicode encoding used in cifs/smb2 protocol?
>>
>> Seems no problem to rename it.
>>
>> Jeff, Steve, thoughts? If no objections - I will rename *ucs* to *ut=
f16*.
>>
> Yeah, now that I look over the NLS code, it does seem to be convertin=
g
> to UTF16 and not to UCS2. You should probably rename the existing *uc=
s*
> functions in cifs_unicode.c as well.
>
> Also, we should probably settle on a prefix for these that makes sens=
e.
> These are only currently used by smb2 code, but they aren't truly
> smb2-specific. I'd name them cifs_* myself, but maybe something more
> neutral makes sense?
>

I think, cifs_* will be ok.

--=20
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
