From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix memory over bound bug in cifs_parse_mount_options
Date: Thu, 21 Apr 2011 12:25:13 -0500
Message-ID: <BANLkTi=LZyzTE8HSim-G5fbHJNwT=5jAvw@mail.gmail.com>
References: <1302804056-22865-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302804056-22865-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into for-next in cifs-2.6.git

On Thu, Apr 14, 2011 at 1:00 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> While password processing we can get out of options array bound if
> the next character after array is delimiter. The patch adds a check
> if we reach the end.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A05 +++--
> =A01 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index db9d55b..4bc862a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -807,8 +807,7 @@ static int
> =A0cifs_parse_mount_options(char *options, const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_vol *vol)
> =A0{
> - =A0 =A0 =A0 char *value;
> - =A0 =A0 =A0 char *data;
> + =A0 =A0 =A0 char *value, *data, *end;
> =A0 =A0 =A0 =A0unsigned int =A0temp_len, i, j;
> =A0 =A0 =A0 =A0char separator[2];
> =A0 =A0 =A0 =A0short int override_uid =3D -1;
> @@ -851,6 +850,7 @@ cifs_parse_mount_options(char *options, const cha=
r *devname,
> =A0 =A0 =A0 =A0if (!options)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>
> + =A0 =A0 =A0 end =3D options + strlen(options);
> =A0 =A0 =A0 =A0if (strncmp(options, "sep=3D", 4) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (options[4] !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0separator[0] =3D optio=
ns[4];
> @@ -916,6 +916,7 @@ cifs_parse_mount_options(char *options, const cha=
r *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the only illegal chara=
cter in a password is null */
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((value[temp_len] =3D=
=3D 0) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (value + temp_l=
en < end) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(value[temp_le=
n+1] =3D=3D separator[0])) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* rei=
nsert comma */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0value[=
temp_len] =3D separator[0];
> --
> 1.7.1
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
