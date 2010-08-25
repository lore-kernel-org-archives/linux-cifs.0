From: "Christopher K." <c.krooss-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: Automount causes zero-pointer dereference in 2.6.36-rc2
Date: Wed, 25 Aug 2010 14:15:36 +0200
Message-ID: <AANLkTikvPoXYe-G5A0k3huysRyqJ4wTkhKowR79BcvuD@mail.gmail.com>
References: <AANLkTi=yQzDDHnX8HFrqCe8yqWuVA8b24zfPk5yZeWZk@mail.gmail.com>
	<4C750575.80109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C750575.80109-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> (Cc-ing linux-cifs@vger-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org)
>
> Does the following patch fixes the problem for you? This patch has be=
en included
> in the cifs development git and should be available in the next -rc.
>
>
> Subject: [PATCH] cifs: check for NULL session password
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date: Mon, 23 Aug 2010 11:38:04 -0400
> To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> CC: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> It's possible for a cifsSesInfo struct to have a NULL password, so we
> need to check for that prior to running strncmp on it.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0fs/cifs/connect.c | =C2=A0 =C2=A01 +
> =C2=A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 18af707..ec0ea4a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1673,6 +1673,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *serve=
r, struct smb_vol *vol)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MAX_USERNAME_SI=
ZE))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (strlen(vol->username) !=3D 0 &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ses->password !=3D NULL &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(ses->password,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->password ?=
 vol->password : "",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MAX_PASSWORD_SI=
ZE))
>
>
>

This does indeed fix the issue. Makes perfect sense, the
session-password was empty.
Thanks a lot for your quick response!
