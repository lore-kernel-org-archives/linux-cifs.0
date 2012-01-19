From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Rename *UCS* functions to *UTF16*
Date: Wed, 18 Jan 2012 22:35:07 -0600
Message-ID: <CAH2r5mutu4wnuUv+fBnAXh6RBwQsztBUHKwuKdUMTZz7X-XqEA@mail.gmail.com>
References: <1326828718-15006-1-git-send-email-piastry@etersoft.ru>
	<20120118135839.3f47a0c6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118135839.3f47a0c6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

but had to fix up cifsencrypt.c since it didn't merge cleanly

On Wed, Jan 18, 2012 at 12:58 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Tue, 17 Jan 2012 23:31:58 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> to reflect the unicode encoding used by CIFS protocol.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_unicode.c | =A0 41 ++++++------
>> =A0fs/cifs/cifs_unicode.h | =A0 20 +++---
>> =A0fs/cifs/cifsencrypt.c =A0| =A0 12 ++--
>> =A0fs/cifs/cifssmb.c =A0 =A0 =A0| =A0162 +++++++++++++++++++++++++--=
---------------------
>> =A0fs/cifs/connect.c =A0 =A0 =A0| =A0 =A04 +-
>> =A0fs/cifs/readdir.c =A0 =A0 =A0| =A0 =A09 ++-
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0 | =A0 34 +++++-----
>> =A0fs/cifs/smbencrypt.c =A0 | =A0 =A02 +-
>> =A08 files changed, 146 insertions(+), 138 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> index 1b2e180..fbb9da9 100644
>> --- a/fs/cifs/cifs_unicode.c
>> +++ b/fs/cifs/cifs_unicode.c
>> @@ -27,17 +27,17 @@
>> =A0#include "cifs_debug.h"
>>
>> =A0/*
>> - * cifs_ucs2_bytes - how long will a string be after conversion?
>> - * @ucs - pointer to input string
>> + * cifs_utf16_bytes - how long will a string be after conversion?
>> + * @utf16 - pointer to input string
>> =A0 * @maxbytes - don't go past this many bytes of input string
>> =A0 * @codepage - destination codepage
>> =A0 *
>> - * Walk a ucs2le string and return the number of bytes that the str=
ing will
>> + * Walk a utf16le string and return the number of bytes that the st=
ring will
>> =A0 * be after being converted to the given charset, not including a=
ny null
>> =A0 * termination required. Don't walk past maxbytes in the source b=
uffer.
>> =A0 */
>> =A0int
>> -cifs_ucs2_bytes(const __le16 *from, int maxbytes,
>> +cifs_utf16_bytes(const __le16 *from, int maxbytes,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 int i;
>> @@ -122,7 +122,7 @@ cp_convert:
>> =A0}
>>
>> =A0/*
>> - * cifs_from_ucs2 - convert utf16le string to local charset
>> + * cifs_from_utf16 - convert utf16le string to local charset
>> =A0 * @to - destination buffer
>> =A0 * @from - source buffer
>> =A0 * @tolen - destination buffer size (in bytes)
>> @@ -130,7 +130,7 @@ cp_convert:
>> =A0 * @codepage - codepage to which characters should be converted
>> =A0 * @mapchar - should characters be remapped according to the mapc=
hars option?
>> =A0 *
>> - * Convert a little-endian ucs2le string (as sent by the server) to=
 a string
>> + * Convert a little-endian utf16le string (as sent by the server) t=
o a string
>> =A0 * in the provided codepage. The tolen and fromlen parameters are=
 to ensure
>> =A0 * that the code doesn't walk off of the end of the buffer (which=
 is always
>> =A0 * a danger if the alignment of the source buffer is off). The de=
stination
>> @@ -139,12 +139,12 @@ cp_convert:
>> =A0 * null terminator).
>> =A0 *
>> =A0 * Note that some windows versions actually send multiword UTF-16=
 characters
>> - * instead of straight UCS-2. The linux nls routines however aren't=
 able to
>> + * instead of straight UTF16-2. The linux nls routines however aren=
't able to
>> =A0 * deal with those characters properly. In the event that we get =
some of
>> =A0 * those characters, they won't be translated properly.
>> =A0 */
>> =A0int
>> -cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen=
,
>> +cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromle=
n,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage, boo=
l mapchar)
>> =A0{
>> =A0 =A0 =A0 int i, charlen, safelen;
>> @@ -190,13 +190,13 @@ cifs_from_ucs2(char *to, const __le16 *from, i=
nt tolen, int fromlen,
>> =A0}
>>
>> =A0/*
>> - * NAME: =A0 =A0 cifs_strtoUCS()
>> + * NAME: =A0 =A0 cifs_strtoUTF16()
>> =A0 *
>> =A0 * FUNCTION: Convert character string to unicode string
>> =A0 *
>> =A0 */
>> =A0int
>> -cifs_strtoUCS(__le16 *to, const char *from, int len,
>> +cifs_strtoUTF16(__le16 *to, const char *from, int len,
>> =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 int charlen;
>> @@ -206,7 +206,7 @@ cifs_strtoUCS(__le16 *to, const char *from, int =
len,
>> =A0 =A0 =A0 for (i =3D 0; len && *from; i++, from +=3D charlen, len =
-=3D charlen) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from, len=
, &wchar_to);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "strtoUCS: char2=
uni of 0x%x returned %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "strtoUTF16: cha=
r2uni of 0x%x returned %d",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *from, c=
harlen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* A question mark */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wchar_to =3D 0x003f;
>> @@ -220,7 +220,8 @@ cifs_strtoUCS(__le16 *to, const char *from, int =
len,
>> =A0}
>>
>> =A0/*
>> - * cifs_strndup_from_ucs - copy a string from wire format to the lo=
cal codepage
>> + * cifs_strndup_from_utf16 - copy a string from wire format to the =
local
>> + * codepage
>> =A0 * @src - source string
>> =A0 * @maxlen - don't walk past this many bytes in the source string
>> =A0 * @is_unicode - is this a unicode string?
>> @@ -231,19 +232,19 @@ cifs_strtoUCS(__le16 *to, const char *from, in=
t len,
>> =A0 * error.
>> =A0 */
>> =A0char *
>> -cifs_strndup_from_ucs(const char *src, const int maxlen, const bool=
 is_unicode,
>> - =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
>> +cifs_strndup_from_utf16(const char *src, const int maxlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const bool is_unicode, con=
st struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 int len;
>> =A0 =A0 =A0 char *dst;
>>
>> =A0 =A0 =A0 if (is_unicode) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_ucs2_bytes((__le16 *) src, ma=
xlen, codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_utf16_bytes((__le16 *) src, m=
axlen, codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len +=3D nls_nullsize(codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst =3D kmalloc(len, GFP_KERNEL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dst)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_ucs2(dst, (__le16 *) src, len, m=
axlen, codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_utf16(dst, (__le16 *) src, len, =
maxlen, codepage,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0false);
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strnlen(src, maxlen);
>> @@ -264,7 +265,7 @@ cifs_strndup_from_ucs(const char *src, const int=
 maxlen, const bool is_unicode,
>> =A0 * names are little endian 16 bit Unicode on the wire
>> =A0 */
>> =A0int
>> -cifsConvertToUCS(__le16 *target, const char *source, int srclen,
>> +cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *cp, int mapCh=
ars)
>> =A0{
>> =A0 =A0 =A0 int i, j, charlen;
>> @@ -273,7 +274,7 @@ cifsConvertToUCS(__le16 *target, const char *sou=
rce, int srclen,
>> =A0 =A0 =A0 wchar_t tmp;
>>
>> =A0 =A0 =A0 if (!mapChars)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return cifs_strtoUCS(target, source, PATH_=
MAX, cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return cifs_strtoUTF16(target, source, PAT=
H_MAX, cp);
>>
>> =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < srclen; j++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_char =3D source[i];
>> @@ -281,7 +282,7 @@ cifsConvertToUCS(__le16 *target, const char *sou=
rce, int srclen,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (src_char) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned(0, &target=
[j]);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ctoUCS_out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ctoUTF16_out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ':':
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le16=
(UNI_COLON);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> @@ -326,7 +327,7 @@ cifsConvertToUCS(__le16 *target, const char *sou=
rce, int srclen,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned(dst_char, &target[j]);
>> =A0 =A0 =A0 }
>>
>> -ctoUCS_out:
>> +ctoUTF16_out:
>> =A0 =A0 =A0 return i;
>> =A0}
>>
>> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
>> index 6d02fd5..a513a54 100644
>> --- a/fs/cifs/cifs_unicode.h
>> +++ b/fs/cifs/cifs_unicode.h
>> @@ -74,16 +74,16 @@ extern const struct UniCaseRange CifsUniLowerRan=
ge[];
>> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 /* UNIUPR_NOLOWER */
>>
>> =A0#ifdef __KERNEL__
>> -int cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fro=
mlen,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage, b=
ool mapchar);
>> -int cifs_ucs2_bytes(const __le16 *from, int maxbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *codepage);
>> -int cifs_strtoUCS(__le16 *, const char *, int, const struct nls_tab=
le *);
>> -char *cifs_strndup_from_ucs(const char *src, const int maxlen,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const bool is_unic=
ode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_t=
able *codepage);
>> -extern int cifsConvertToUCS(__le16 *target, const char *source, int=
 maxlen,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *cp=
, int mapChars);
>> +int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fr=
omlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *codepage, =
bool mapchar);
>> +int cifs_utf16_bytes(const __le16 *from, int maxbytes,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepag=
e);
>> +int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_t=
able *);
>> +char *cifs_strndup_from_utf16(const char *src, const int maxlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const bool is_=
unicode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct n=
ls_table *codepage);
>> +extern int cifsConvertToUTF16(__le16 *target, const char *source, i=
nt maxlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct n=
ls_table *cp, int mapChars);
>>
>> =A0#endif
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 5d9b9ac..f6ddd3d 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -327,7 +327,7 @@ build_avpair_blob(struct cifs_ses *ses, const st=
ruct nls_table *nls_cp)
>> =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAME)=
;
>> =A0 =A0 =A0 attrptr->length =3D cpu_to_le16(2 * dlen);
>> =A0 =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntl=
mssp2_name);
>> - =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen, nl=
s_cp);
>> + =A0 =A0 cifs_strtoUTF16((__le16 *)blobptr, ses->domainName, dlen, =
nls_cp);
>>
>> =A0 =A0 =A0 return 0;
>> =A0}
>> @@ -376,7 +376,7 @@ find_domain_name(struct cifs_ses *ses, const str=
uct nls_table *nls_cp)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 kmalloc(attrsize + 1, GFP_KERNEL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses=
->domainName)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_=
ucs2(ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_=
utf16(ses->domainName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 (__le16 *)blobptr, attrsize, attrsize,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 nls_cp, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> @@ -427,7 +427,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses=
, char *ntlmv2_hash,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> - =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->user_name, len,=
 nls_cp);
>> + =A0 =A0 len =3D cifs_strtoUTF16((__le16 *)user, ses->user_name, le=
n, nls_cp);
>> =A0 =A0 =A0 UniStrupr(user);
>>
>> =A0 =A0 =A0 rc =3D crypto_shash_update(&ses->server->secmech.sdeschm=
acmd5->shash,
>> @@ -448,8 +448,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses=
, char *ntlmv2_hash,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)domain, se=
s->domainName, len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUTF16((__le16 *)domain, =
ses->domainName, len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&ses->server->secmec=
h.sdeschmacmd5->shash,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 (char *)domain, 2 * len);
>> @@ -468,7 +468,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses=
, char *ntlmv2_hash,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)server, se=
s->serverName, len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUTF16((__le16 *)server, =
ses->serverName, len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&ses->server->secmec=
h.sdeschmacmd5->shash,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 6600aa2..8b7794c 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -821,8 +821,8 @@ PsxDelete:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { /* BB add path length overrun check */
>> @@ -893,8 +893,8 @@ DelFileRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
fileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->fileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB improve ch=
eck for buffer overruns BB */
>> @@ -938,8 +938,8 @@ RmDirRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUCS((__le16 *) p=
SMB->DirName, dirName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUTF16((__le16 *)=
 pSMB->DirName, dirName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB improve ch=
eck for buffer overruns BB */
>> @@ -981,8 +981,8 @@ MkDirRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUCS((__le16 *) p=
SMB->DirName, name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUTF16((__le16 *)=
 pSMB->DirName, name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB improve ch=
eck for buffer overruns BB */
>> @@ -1030,8 +1030,8 @@ PsxCreat:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -1197,8 +1197,8 @@ OldOpenRetry:
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D 1; =A0 =A0 =A0/* account for o=
ne byte pad to word boundary */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsConvertToUCS((__le16 *) (pSMB->=
fileName + 1),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi=
leName, PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsConvertToUTF16((__le16 *) (pSMB=
->fileName + 1),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 fileName, PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB improve ch=
eck for buffer overruns BB */
>> @@ -1304,8 +1304,8 @@ openRetry:
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D 1; =A0 =A0 =A0/* account for o=
ne byte pad to word boundary */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) (pSMB-=
>fileName + 1),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fileName, PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) (pSM=
B->fileName + 1),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0fileName, PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->NameLength =3D cpu_to_le16(name_le=
n);
>> @@ -2649,16 +2649,16 @@ renameRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
OldFileName, fromName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->OldFileName, fromName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len] =3D 0x04; =A0=
 =A0 /* pad */
>> =A0 =A0 =A0 /* protocol requires ASCII signature byte on Unicode str=
ing */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len + 1] =3D 0x00=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *)&pSMB->=
OldFileName[name_len + 2],
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
toName, PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *)&pSMB=
->OldFileName[name_len+2],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0toName, PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 +=3D 1 /* trailing null */ =A0=
+ 1 /* Signature word */ ;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 *=3D 2; /* convert to bytes */
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -2738,10 +2738,12 @@ int CIFSSMBRenameOpenFile(const int xid, str=
uct cifs_tcon *pTcon,
>> =A0 =A0 =A0 /* unicode only call */
>> =A0 =A0 =A0 if (target_name =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(dummy_string, "cifs%x", pSMB->hd=
r.Mid);
>> - =A0 =A0 =A0 =A0 =A0 =A0 len_of_str =3D cifsConvertToUCS((__le16 *)=
rename_info->target_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 len_of_str =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *)rename_info->target_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 dummy_string, 24, nls_codepage, remap);
>> =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 len_of_str =3D cifsConvertToUCS((__le16 *)=
rename_info->target_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 len_of_str =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *)rename_info->target_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 target_name, PATH_MAX, nls_codepage,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 remap);
>> =A0 =A0 =A0 }
>> @@ -2795,17 +2797,17 @@ copyRetry:
>> =A0 =A0 =A0 pSMB->Flags =3D cpu_to_le16(flags & COPY_TREE);
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUCS((__le16 *) p=
SMB->OldFileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 fromName, PATH_MAX, nls_codepage,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUTF16((__le16 *)=
 pSMB->OldFileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 fromName, PATH_MAX, nls_codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len] =3D 0x04; =A0=
 =A0 /* pad */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* protocol requires ASCII signature byt=
e on Unicode string */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len + 1] =3D 0x00=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *)&pSMB->=
OldFileName[name_len + 2],
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 toName, PA=
TH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *)&pSMB=
->OldFileName[name_len+2],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0toName, PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 +=3D 1 /* trailing null */ =A0=
+ 1 /* Signature word */ ;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 *=3D 2; /* convert to bytes */
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -2861,9 +2863,9 @@ createSymLinkRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *) pSMB->Fil=
eName, fromName, PATH_MAX
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fin=
d define for this maxpathcomponent */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , nls_=
codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUTF16((__le16 *) pSMB->F=
ileName, fromName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*=
 find define for this maxpathcomponent */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PA=
TH_MAX, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>>
>> @@ -2885,9 +2887,9 @@ createSymLinkRetry:
>> =A0 =A0 =A0 data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset;
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *) data_offs=
et, toName, PATH_MAX
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fin=
d define for this maxpathcomponent */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , nls_=
codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUTF16((__le16 *) data_of=
fset, toName, PATH_MAX
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*=
 find define for this maxpathcomponent */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , =
nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target++; =A0 =A0 =A0/* trailin=
g null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -2949,8 +2951,8 @@ createHardLinkRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUCS((__le16 *) p=
SMB->FileName, toName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D cifsConvertToUTF16((__le16 *)=
 pSMB->FileName, toName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>>
>> @@ -2972,8 +2974,8 @@ createHardLinkRetry:
>> =A0 =A0 =A0 data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset;
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) data_o=
ffset, fromName, PATH_MAX,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) data=
_offset, fromName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target++; =A0 =A0 =A0/* trailin=
g null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len_target *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -3042,8 +3044,8 @@ winCreateHardLinkRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
OldFileName, fromName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->OldFileName, fromName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>>
>> @@ -3051,8 +3053,8 @@ winCreateHardLinkRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len] =3D 0x04;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OldFileName[name_len + 1] =3D 0x00=
; /* pad */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *)&pSMB->=
OldFileName[name_len + 2],
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
toName, PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *)&pSMB=
->OldFileName[name_len+2],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0toName, PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 +=3D 1 /* trailing null */ =A0=
+ 1 /* Signature word */ ;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len2 *=3D 2; /* convert to bytes */
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -3108,8 +3110,8 @@ querySymLinkRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *) pSMB->Fil=
eName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PATH_M=
AX, nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUTF16((__le16 *)=
 pSMB->FileName, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PATH_MAX, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -3166,8 +3168,8 @@ querySymLinkRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_unico=
de =3D false;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB FIXME investigate =
remapping reserved chars here */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *symlinkinfo =3D cifs_strn=
dup_from_ucs(data_start, count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_unicode, nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *symlinkinfo =3D cifs_strn=
dup_from_utf16(data_start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 count, is_unicode, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!*symlinkinfo)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -3450,8 +3452,9 @@ queryAclRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *=
) pSMB->FileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *) pSMB->FileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0searchName, PATH_MAX, nls_codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->FileName[name_len] =3D 0;
>> @@ -3537,8 +3540,8 @@ setAclRetry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *=
) pSMB->FileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *) pSMB->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -3948,8 +3951,9 @@ QInfRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *=
) pSMB->FileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *) pSMB->FileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0searchName, PATH_MAX, nls_codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else {
>> @@ -4086,8 +4090,8 @@ QPathInfoRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -4255,8 +4259,8 @@ UnixQPathInfoRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PATH_M=
AX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -4344,8 +4348,8 @@ findFirstRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PATH_MA=
X, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We can not add the asterik earlier in=
 case
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 it got remapped to 0xF03A as if it were =
part of the
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 directory name instead of a wildcard */
>> @@ -4656,8 +4660,9 @@ GetInodeNumberRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *=
) pSMB->FileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *) pSMB->FileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0searchName, PATH_MAX, nls_codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -4794,9 +4799,9 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER=
_RSP *pSMBr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto par=
se_DFS_referrals_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *=
) tmp, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PATH_MAX, nls_codepage, remap);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node->path_consumed =3D ci=
fs_ucs2_bytes(tmp,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16=
 *) tmp, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node->path_consumed =3D ci=
fs_utf16_bytes(tmp,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 le16_to_cpu(pSMBr->PathConsumed),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(tmp);
>> @@ -4809,8 +4814,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER=
_RSP *pSMBr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy DfsPath */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D (char *)ref + le16_to_cpu(ref->=
DfsPathOffset);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_len =3D data_end - temp;
>> - =A0 =A0 =A0 =A0 =A0 =A0 node->path_name =3D cifs_strndup_from_ucs(=
temp, max_len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_unicode, nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 node->path_name =3D cifs_strndup_from_utf1=
6(temp, max_len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 is_unicode, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!node->path_name) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto parse_DFS_referrals=
_exit;
>> @@ -4819,8 +4824,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER=
_RSP *pSMBr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy link target UNC */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D (char *)ref + le16_to_cpu(ref->=
NetworkAddressOffset);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_len =3D data_end - temp;
>> - =A0 =A0 =A0 =A0 =A0 =A0 node->node_name =3D cifs_strndup_from_ucs(=
temp, max_len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_unicode, nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 node->node_name =3D cifs_strndup_from_utf1=
6(temp, max_len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 is_unicode, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!node->node_name)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 }
>> @@ -4873,8 +4878,9 @@ getDFSRetry:
>> =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.Flags2 |=3D SMBFLG2_UNICODE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
RequestFileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
searchName, PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->RequestFileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0searchName, PATH_MAX, nls_codepage,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -5506,8 +5512,8 @@ SetEOFRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -5796,8 +5802,8 @@ SetTimesRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -5877,8 +5883,8 @@ SetAttrLgcyRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ConvertToUCS((__le16 *) pS=
MB->fileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PATH_MAX, =
nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ConvertToUTF16((__le16 *) =
pSMB->fileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -6030,8 +6036,8 @@ setPermsRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -6123,8 +6129,8 @@ QAllEAsRetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, searchName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, searchName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> @@ -6301,8 +6307,8 @@ SetEARetry:
>>
>> =A0 =A0 =A0 if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUCS((__le16 *) pSMB->=
=46ileName, fileName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PATH_MAX, nls_codepage, remap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsConvertToUTF16((__le16 *) pSMB=
->FileName, fileName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PATH_MAX, nls_codepage, remap);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len++; =A0 =A0 /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name_len *=3D 2;
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0/* BB improve the check for buff=
er overruns BB */
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index f3670cf..2838195 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3478,7 +3478,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *se=
s,
>> =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer->Flags2 |=3D SMBFLG2_UNICODE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *) bcc_ptr, =
tree,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUTF16((__le16 *) bcc_ptr=
, tree,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 6 /* max utf8 char lengt=
h in bytes */ *
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (/* server len*/ + 256 /=
* share len */), nls_codepage);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D 2 * length; =A0/* convert n=
um 16 bit words to bytes */
>> @@ -3533,7 +3533,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *se=
s,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* mostly informational -- no need to fa=
il on error here */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(tcon->nativeFileSystem);
>> - =A0 =A0 =A0 =A0 =A0 =A0 tcon->nativeFileSystem =3D cifs_strndup_fr=
om_ucs(bcc_ptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->nativeFileSystem =3D cifs_strndup_fr=
om_utf16(bcc_ptr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_left, is_unicode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_codepage);
>>
>> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> index a090bbe..e2bbc68 100644
>> --- a/fs/cifs/readdir.c
>> +++ b/fs/cifs/readdir.c
>> @@ -647,10 +647,11 @@ static int cifs_filldir(char *find_entry, stru=
ct file *file, filldir_t filldir,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name.name =3D scratch_buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name.len =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_ucs2((char *)nam=
e.name, (__le16 *)de.name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0UNICODE_NAME_MAX,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0min(de.namelen, (size_t)max_len), nlt,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0cifs_sb->mnt_cifs_flags &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_utf16((char *)na=
me.name, (__le16 *)de.name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 UNICODE_NAME_MAX,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 min_t(size_t, de.namelen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 (size_t)max_len), nlt,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_sb->mnt_cifs_flags &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 name.len -=3D nls_nullsize(nlt);
>> =A0 =A0 =A0 } else {
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 4ec3ee9..d85efad 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -167,16 +167,16 @@ unicode_oslm_strings(char **pbcc_area, const s=
truct nls_table *nls_cp)
>> =A0 =A0 =A0 int bytes_ret =3D 0;
>>
>> =A0 =A0 =A0 /* Copy OS version */
>> - =A0 =A0 bytes_ret =3D cifs_strtoUCS((__le16 *)bcc_ptr, "Linux vers=
ion ", 32,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp=
);
>> + =A0 =A0 bytes_ret =3D cifs_strtoUTF16((__le16 *)bcc_ptr, "Linux ve=
rsion ", 32,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nl=
s_cp);
>> =A0 =A0 =A0 bcc_ptr +=3D 2 * bytes_ret;
>> - =A0 =A0 bytes_ret =3D cifs_strtoUCS((__le16 *) bcc_ptr, init_utsna=
me()->release,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32, nl=
s_cp);
>> + =A0 =A0 bytes_ret =3D cifs_strtoUTF16((__le16 *) bcc_ptr, init_uts=
name()->release,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32=
, nls_cp);
>> =A0 =A0 =A0 bcc_ptr +=3D 2 * bytes_ret;
>> =A0 =A0 =A0 bcc_ptr +=3D 2; /* trailing null */
>>
>> - =A0 =A0 bytes_ret =3D cifs_strtoUCS((__le16 *) bcc_ptr, CIFS_NETWO=
RK_OPSYS,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32, nl=
s_cp);
>> + =A0 =A0 bytes_ret =3D cifs_strtoUTF16((__le16 *) bcc_ptr, CIFS_NET=
WORK_OPSYS,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32=
, nls_cp);
>> =A0 =A0 =A0 bcc_ptr +=3D 2 * bytes_ret;
>> =A0 =A0 =A0 bcc_ptr +=3D 2; /* trailing null */
>>
>> @@ -197,8 +197,8 @@ static void unicode_domain_string(char **pbcc_ar=
ea, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(bcc_ptr+1) =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_ret =3D 0;
>> =A0 =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 bytes_ret =3D cifs_strtoUCS((__le16 *) bcc=
_ptr, ses->domainName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 256, nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bytes_ret =3D cifs_strtoUTF16((__le16 *) b=
cc_ptr, ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 256, nls_cp);
>> =A0 =A0 =A0 bcc_ptr +=3D 2 * bytes_ret;
>> =A0 =A0 =A0 bcc_ptr +=3D 2; =A0/* account for null terminator */
>>
>> @@ -226,8 +226,8 @@ static void unicode_ssetup_strings(char **pbcc_a=
rea, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(bcc_ptr+1) =3D 0;
>> =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 bytes_ret =3D cifs_strtoUCS((__le16 *) bcc=
_ptr, ses->user_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 MAX_USERNAME_SIZE, nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bytes_ret =3D cifs_strtoUTF16((__le16 *) b=
cc_ptr, ses->user_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 bcc_ptr +=3D 2 * bytes_ret;
>> =A0 =A0 =A0 bcc_ptr +=3D 2; /* account for null termination */
>> @@ -287,7 +287,7 @@ decode_unicode_ssetup(char **pbcc_area, int blef=
t, struct cifs_ses *ses,
>> =A0 =A0 =A0 cFYI(1, "bleft %d", bleft);
>>
>> =A0 =A0 =A0 kfree(ses->serverOS);
>> - =A0 =A0 ses->serverOS =3D cifs_strndup_from_ucs(data, bleft, true,=
 nls_cp);
>> + =A0 =A0 ses->serverOS =3D cifs_strndup_from_utf16(data, bleft, tru=
e, nls_cp);
>> =A0 =A0 =A0 cFYI(1, "serverOS=3D%s", ses->serverOS);
>> =A0 =A0 =A0 len =3D (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + =
2;
>> =A0 =A0 =A0 data +=3D len;
>> @@ -296,7 +296,7 @@ decode_unicode_ssetup(char **pbcc_area, int blef=
t, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>>
>> =A0 =A0 =A0 kfree(ses->serverNOS);
>> - =A0 =A0 ses->serverNOS =3D cifs_strndup_from_ucs(data, bleft, true=
, nls_cp);
>> + =A0 =A0 ses->serverNOS =3D cifs_strndup_from_utf16(data, bleft, tr=
ue, nls_cp);
>> =A0 =A0 =A0 cFYI(1, "serverNOS=3D%s", ses->serverNOS);
>> =A0 =A0 =A0 len =3D (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + =
2;
>> =A0 =A0 =A0 data +=3D len;
>> @@ -305,7 +305,7 @@ decode_unicode_ssetup(char **pbcc_area, int blef=
t, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>>
>> =A0 =A0 =A0 kfree(ses->serverDomain);
>> - =A0 =A0 ses->serverDomain =3D cifs_strndup_from_ucs(data, bleft, t=
rue, nls_cp);
>> + =A0 =A0 ses->serverDomain =3D cifs_strndup_from_utf16(data, bleft,=
 true, nls_cp);
>> =A0 =A0 =A0 cFYI(1, "serverDomain=3D%s", ses->serverDomain);
>>
>> =A0 =A0 =A0 return;
>> @@ -502,8 +502,8 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D 2;
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses->=
domainName,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MA=
X_USERNAME_SIZE, nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUTF16((__le16 *)tmp, ses=
->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to_l=
e16(len);
>> @@ -518,8 +518,8 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D 2;
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses->=
user_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MA=
X_USERNAME_SIZE, nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUTF16((__le16 *)tmp, ses=
->user_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_le1=
6(len);
>> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
>> index 80d8508..d5cd9aa 100644
>> --- a/fs/cifs/smbencrypt.c
>> +++ b/fs/cifs/smbencrypt.c
>> @@ -213,7 +213,7 @@ E_md4hash(const unsigned char *passwd, unsigned =
char *p16,
>>
>> =A0 =A0 =A0 /* Password cannot be longer than 128 characters */
>> =A0 =A0 =A0 if (passwd) /* Password must be converted to NT unicode =
*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS(wpwd, passwd, 128, c=
odepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUTF16(wpwd, passwd, 128,=
 codepage);
>> =A0 =A0 =A0 else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *wpwd =3D 0; /* Ensure string is null te=
rminated */
>
>
> Looks fine. Normally I don't go for this sort of deck chair
> rearrangement, but I guess it makes sense to rename all of this
> before the smb2 code hits the tree.
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
