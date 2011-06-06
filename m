From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] possible memory corruption in cifs_parse_mount_options()
Date: Mon, 6 Jun 2011 10:34:15 -0500
Message-ID: <BANLkTimusjUkvfkkkyH0MGwve8q+kpRYAQ@mail.gmail.com>
References: <4DEC82B8.7000701@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Vasily Averin <vvs-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DEC82B8.7000701-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged, after fixing patch corruption (line wrap due to emailer?)

On Mon, Jun 6, 2011 at 2:33 AM, Vasily Averin <vvs-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote=
:
> error path after mountdata check frees uninitialized mountdata_copy
>
> Signed-off-by: Vasily Averin <vvs-3ImXcnM4P+0@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6d88b82..dd5e33e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -784,7 +784,7 @@ cifs_parse_mount_options(const char *mountdata, c=
onst char
> *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_vol *vol)
> =A0{
> =A0 =A0 =A0 =A0char *value, *data, *end;
> - =A0 =A0 =A0 char *mountdata_copy, *options;
> + =A0 =A0 =A0 char *mountdata_copy =3D NULL, *options;
> =A0 =A0 =A0 =A0unsigned int =A0temp_len, i, j;
> =A0 =A0 =A0 =A0char separator[2];
> =A0 =A0 =A0 =A0short int override_uid =3D -1;
> --
> 1.7.4.1
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
