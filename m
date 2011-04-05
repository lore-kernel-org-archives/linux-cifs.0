From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: clean up various nits in unicode routines (try #2)
Date: Tue, 5 Apr 2011 14:11:01 -0500
Message-ID: <BANLkTincXBUZw2h4307yQFL_br9PzWB_Fw@mail.gmail.com>
References: <BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw@mail.gmail.com>
	<1302030157-5486-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302030157-5486-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Tue, Apr 5, 2011 at 2:02 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Minor revision to the original patch. Don't abuse the __le16 variable
> on the stack by casting it to wchar_t and handing it off to char2uni.
> Declare an actual wchar_t on the stack instead. This fixes a valid
> sparse warning.
>
> Fix the spelling of UNI_ASTERISK. Eliminate the unneeded len_remainin=
g
> variable in cifsConvertToUCS.
>
> Also, as David Howells points out. We were better off making
> cifsConvertToUCS *not* use put_unaligned_le16 since it means that we
> can't optimize the mapped characters at compile time. Switch them
> instead to use cpu_to_le16, and simply use put_unaligned to set them
> in the string.
>
> Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_unicode.c | =A0 35 +++++++++++++++++-----------------=
-
> =A0fs/cifs/cifs_unicode.h | =A0 =A02 +-
> =A02 files changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 9dd2682..d8e93b0 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -90,7 +90,7 @@ cifs_mapchar(char *target, const __u16 src_char, co=
nst struct nls_table *cp,
> =A0 =A0 =A0 =A0case UNI_COLON:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*target =3D ':';
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> - =A0 =A0 =A0 case UNI_ASTERIK:
> + =A0 =A0 =A0 case UNI_ASTERISK:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*target =3D '*';
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case UNI_QUESTION:
> @@ -264,40 +264,40 @@ cifs_strndup_from_ucs(const char *src, const in=
t maxlen, const bool is_unicode,
> =A0* names are little endian 16 bit Unicode on the wire
> =A0*/
> =A0int
> -cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
> +cifsConvertToUCS(__le16 *target, const char *source, int srclen,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *cp, int mapCh=
ars)
> =A0{
> =A0 =A0 =A0 =A0int i, j, charlen;
> - =A0 =A0 =A0 int len_remaining =3D maxlen;
> =A0 =A0 =A0 =A0char src_char;
> - =A0 =A0 =A0 __u16 temp;
> + =A0 =A0 =A0 __le16 dst_char;
> + =A0 =A0 =A0 wchar_t tmp;
>
> =A0 =A0 =A0 =A0if (!mapChars)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return cifs_strtoUCS(target, source, P=
ATH_MAX, cp);
>
> - =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < maxlen; j++) {
> + =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < srclen; j++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src_char =3D source[i];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (src_char) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 0:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(0, &=
target[j]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned(0, &targe=
t[j]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto ctoUCS_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ':':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_COLON;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_COLON);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case '*':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_ASTERIK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_ASTERISK);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case '?':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_QUESTION;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_QUESTION);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case '<':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_LESSTHAN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_LESSTHAN);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case '>':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_GRTRTHAN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_GRTRTHAN);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case '|':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_PIPE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(UNI_PIPE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * FIXME: We can not handle remapping =
backslash (UNI_SLASH)
> @@ -305,17 +305,17 @@ cifsConvertToUCS(__le16 *target, const char *so=
urce, int maxlen,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * as they use backslash as separator.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cp->char2un=
i(source+i, len_remaining,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &temp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cp->char2un=
i(source + i, srclen - i, &tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_char =3D cpu_to_le1=
6(tmp);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * if no match, use qu=
estion mark, which at least in
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * some cases serves a=
s wild card
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (charlen < 1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D=
 0x003f;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_cha=
r =3D cpu_to_le16(0x003f);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0charle=
n =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining -=3D char=
len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * character may take =
more than one byte in the source
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * string, but will ta=
ke exactly two bytes in the
> @@ -324,9 +324,8 @@ cifsConvertToUCS(__le16 *target, const char *sour=
ce, int maxlen,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i +=3D charlen;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(temp, &target[j]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned(dst_char, &target[j]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i++; /* move to next char in source st=
ring */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining--;
> =A0 =A0 =A0 =A0}
>
> =A0ctoUCS_out:
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index cc9628b..e00f677 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -44,7 +44,7 @@
> =A0* reserved symbols (along with \ and /), otherwise illegal to stor=
e
> =A0* in filenames in NTFS
> =A0*/
> -#define UNI_ASTERIK =A0 =A0 (__u16) ('*' + 0xF000)
> +#define UNI_ASTERISK =A0 =A0(__u16) ('*' + 0xF000)
> =A0#define UNI_QUESTION =A0 =A0(__u16) ('?' + 0xF000)
> =A0#define UNI_COLON =A0 =A0 =A0 (__u16) (':' + 0xF000)
> =A0#define UNI_GRTRTHAN =A0 =A0(__u16) ('>' + 0xF000)
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
