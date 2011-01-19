From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: clean up unaligned accesses in cifs_unicode.c
Date: Wed, 19 Jan 2011 09:58:45 -0600
Message-ID: <AANLkTikZYP39UEVGt1Tn1PdYE9RnoBEhOjV+qWfd3oRm@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Make sure we use get/put_unaligned routines when accessing wide
> character strings.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_unicode.c | =A0 49 ++++++++++++++++++++++++++--------=
-------------
> =A01 files changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 430f510..8134443 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -44,10 +44,14 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
> =A0 =A0 =A0 =A0int charlen, outlen =3D 0;
> =A0 =A0 =A0 =A0int maxwords =3D maxbytes / 2;
> =A0 =A0 =A0 =A0char tmp[NLS_MAX_CHARSET_SIZE];
> + =A0 =A0 =A0 __u16 ftmp;
>
> - =A0 =A0 =A0 for (i =3D 0; i < maxwords && from[i]; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->uni2char(le16_to_=
cpu(from[i]), tmp,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0NLS_MAX_CHARSET_SIZE);
> + =A0 =A0 =A0 for (i =3D 0; i < maxwords; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ftmp =3D get_unaligned_le16(&from[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftmp =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->uni2char(ftmp, tm=
p, NLS_MAX_CHARSET_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (charlen > 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0outlen +=3D charlen;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> @@ -60,7 +64,7 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
> =A0/*
> =A0* cifs_mapchar - convert a little-endian char to proper char in co=
depage

I think this wording is now incorrect since src_char is not le anymore.

> =A0* @target - where converted character should be copied
> - * @src_char - 2 byte little-endian source character
> + * @src_char - 2 byte host-endian source character
> =A0* @cp - codepage to which character should be converted
> =A0* @mapchar - should character be mapped according to mapchars moun=
t option?
> =A0*
> @@ -69,7 +73,7 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
> =A0* enough to hold the result of the conversion (at least NLS_MAX_CH=
ARSET_SIZE).
> =A0*/
> =A0static int
> -cifs_mapchar(char *target, const __le16 src_char, const struct nls_t=
able *cp,
> +cifs_mapchar(char *target, const __u16 src_char, const struct nls_ta=
ble *cp,
> =A0 =A0 =A0 =A0 =A0 =A0 bool mapchar)
> =A0{
> =A0 =A0 =A0 =A0int len =3D 1;
> @@ -82,7 +86,7 @@ cifs_mapchar(char *target, const __le16 src_char, c=
onst struct nls_table *cp,
> =A0 =A0 =A0 =A0 * =A0 =A0 build_path_from_dentry are modified, as the=
y use slash as
> =A0 =A0 =A0 =A0 * =A0 =A0 separator.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 switch (le16_to_cpu(src_char)) {
> + =A0 =A0 =A0 switch (src_char) {
> =A0 =A0 =A0 =A0case UNI_COLON:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*target =3D ':';
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> @@ -109,8 +113,7 @@ out:
> =A0 =A0 =A0 =A0return len;
>
> =A0cp_convert:
> - =A0 =A0 =A0 len =3D cp->uni2char(le16_to_cpu(src_char), target,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NLS_MAX_CHARSET_=
SIZE);
> + =A0 =A0 =A0 len =3D cp->uni2char(src_char, target, NLS_MAX_CHARSET_=
SIZE);
> =A0 =A0 =A0 =A0if (len <=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*target =3D '?';
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D 1;
> @@ -149,6 +152,7 @@ cifs_from_ucs2(char *to, const __le16 *from, int =
tolen, int fromlen,
> =A0 =A0 =A0 =A0int nullsize =3D nls_nullsize(codepage);
> =A0 =A0 =A0 =A0int fromwords =3D fromlen / 2;
> =A0 =A0 =A0 =A0char tmp[NLS_MAX_CHARSET_SIZE];
> + =A0 =A0 =A0 __u16 ftmp;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * because the chars can be of varying widths, we need=
 to take care
> @@ -158,19 +162,23 @@ cifs_from_ucs2(char *to, const __le16 *from, in=
t tolen, int fromlen,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0safelen =3D tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
>
> - =A0 =A0 =A0 for (i =3D 0; i < fromwords && from[i]; i++) {
> + =A0 =A0 =A0 for (i =3D 0; i < fromwords; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ftmp =3D get_unaligned_le16(&from[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftmp =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +

Can the contents of from[i] be 0 so ftmp is 0 but we did
not want to break out until fromwords?

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * check to see if converting this cha=
racter might make the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * conversion bleed into the null term=
inator
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (outlen >=3D safelen) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cifs_mapcha=
r(tmp, from[i], codepage, mapchar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cifs_mapcha=
r(tmp, ftmp, codepage, mapchar);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((outlen + charlen)=
 > (tolen - nullsize))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* put converted char into 'to' buffer=
 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cifs_mapchar(&to[outlen], f=
rom[i], codepage, mapchar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cifs_mapchar(&to[outlen], f=
tmp, codepage, mapchar);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0outlen +=3D charlen;
> =A0 =A0 =A0 =A0}
>
> @@ -193,24 +201,21 @@ cifs_strtoUCS(__le16 *to, const char *from, int=
 len,
> =A0{
> =A0 =A0 =A0 =A0int charlen;
> =A0 =A0 =A0 =A0int i;
> - =A0 =A0 =A0 wchar_t *wchar_to =3D (wchar_t *)to; /* needed to quiet=
 sparse */
> + =A0 =A0 =A0 wchar_t wchar_to; /* needed to quiet sparse */
>
> =A0 =A0 =A0 =A0for (i =3D 0; len && *from; i++, from +=3D charlen, le=
n -=3D charlen) {
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* works for 2.4.0 kernel or later */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from, le=
n, &wchar_to[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from, le=
n, &wchar_to);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (charlen < 1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "strtoUCS: ch=
ar2uni of %d returned %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int)*f=
rom, charlen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "strtoUCS: ch=
ar2uni of 0x%x returned %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *from, =
charlen);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* A question mark */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to[i] =3D cpu_to_le16(0=
x003f);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wchar_to =3D 0x003f;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0charlen =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to[i] =3D cpu_to_le16(w=
char_to[i]);
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(wchar_to, &to[i]);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 to[i] =3D 0;
> + =A0 =A0 =A0 put_unaligned_le16(0, &to[i]);
> =A0 =A0 =A0 =A0return i;
> =A0}
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
