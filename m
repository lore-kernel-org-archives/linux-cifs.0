From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] cifs: fix unaligned accesses in cifsConvertToUCS
Date: Wed, 19 Jan 2011 10:02:49 -0600
Message-ID: <AANLkTimRVxgs3rtqNhhMvgOJ3iUWH=MqjXYhWpPrQSww@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-6-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-6-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Move cifsConvertToUCS to cifs_unicode.c where all of the other unicod=
e
> related functions live. Have it store mapped characters in 'temp' and
> then use put_unaligned_le16 to copy it to the target buffer. Also fix
> the comments to match kernel coding style.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_unicode.c | =A0 76 ++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0fs/cifs/misc.c =A0 =A0 =A0 =A0 | =A0 71 --------------------------=
------------------
> =A02 files changed, 76 insertions(+), 71 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 8134443..6a5090d 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -257,3 +257,79 @@ cifs_strndup_from_ucs(const char *src, const int=
 maxlen, const bool is_unicode,
> =A0 =A0 =A0 =A0return dst;
> =A0}
>
> +/*
> + * Convert 16 bit Unicode pathname to wire format from string in cur=
rent code
> + * page. Conversion may involve remapping up the six characters that=
 are
> + * only legal in POSIX-like OS (if they are present in the string). =
Path
> + * names are little endian 16 bit Unicode on the wire
> + */
> +int
> +cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *cp, int mapC=
hars)
> +{
> + =A0 =A0 =A0 int i, j, charlen;
> + =A0 =A0 =A0 int len_remaining =3D maxlen;
> + =A0 =A0 =A0 char src_char;
> + =A0 =A0 =A0 __u16 temp;
> +
> + =A0 =A0 =A0 if (!mapChars)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_strtoUCS(target, source, PA=
TH_MAX, cp);
> +
> + =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < maxlen; j++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_char =3D source[i];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (src_char) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(0, &=
target[j]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ctoUCS_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ':':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_COLON;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '*':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_ASTERIK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '?':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_QUESTION;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '<':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_LESSTHAN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '>':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_GRTRTHAN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '|':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D UNI_PIPE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: We can not handle remapping=
 backslash (UNI_SLASH)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* until all the calls to build_path_=
from_dentry are modified,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* as they use backslash as separator=
=2E
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D cp->char2un=
i(source+i, len_remaining,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &temp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if no match, use q=
uestion mark, which at least in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* some cases serves =
as wild card
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D=
 0x003f;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen=
 =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining -=3D char=
len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* character may take=
 more than one byte in the source
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* string, but will t=
ake exactly two bytes in the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* target string
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D charlen;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(temp, &target[j]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++; /* move to next char in source str=
ing */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining--;
> + =A0 =A0 =A0 }
> +
> +ctoUCS_out:
> + =A0 =A0 =A0 return i;
> +}
> +
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index c1f2a51..2036757 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -626,77 +626,6 @@ dump_smb(struct smb_hdr *smb_buf, int smb_buf_le=
ngth)
> =A0 =A0 =A0 =A0return;
> =A0}
>
> -/* Convert 16 bit Unicode pathname to wire format from string in cur=
rent code
> - =A0 page. =A0Conversion may involve remapping up the seven characte=
rs that are
> - =A0 only legal in POSIX-like OS (if they are present in the string)=
=2E Path
> - =A0 names are little endian 16 bit Unicode on the wire */
> -int
> -cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *cp, int mapC=
hars)
> -{
> - =A0 =A0 =A0 int i, j, charlen;
> - =A0 =A0 =A0 int len_remaining =3D maxlen;
> - =A0 =A0 =A0 char src_char;
> - =A0 =A0 =A0 __u16 temp;
> -
> - =A0 =A0 =A0 if (!mapChars)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_strtoUCS(target, source, PA=
TH_MAX, cp);
> -
> - =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < maxlen; j++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_char =3D source[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (src_char) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ct=
oUCS_out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ':':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_COLON);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '*':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_ASTERIK);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '?':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_QUESTION);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '<':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_LESSTHAN);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '>':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_GRTRTHAN);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case '|':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_PIPE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB We can not handle=
 remapping slash until
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0all the calls to=
 build_path_from_dentry
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0are modified, as=
 they use slash as separator BB */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case '\\':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target[=
j] =3D cpu_to_le16(UNI_SLASH);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;*=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen=
 =3D cp->char2uni(source+i,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 len_remaining, &temp);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if n=
o match, use question mark, which
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 at leas=
t in some cases servers as wild card */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cha=
rlen < 1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 target[j] =3D cpu_to_le16(0x003f);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 charlen =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 target[j] =3D cpu_to_le16(temp);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_rem=
aining -=3D charlen;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* char=
acter may take more than one byte in the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
the source string, but will take exactly two
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
bytes in the target string */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D =
charlen;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++; /* move to next char in source str=
ing */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining--;
> - =A0 =A0 =A0 }
> -
> -ctoUCS_out:
> - =A0 =A0 =A0 return i;
> -}
> -
> =A0void
> =A0cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
> =A0{
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct.
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
