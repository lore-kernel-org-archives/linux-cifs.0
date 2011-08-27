From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix the conflict between rwpidforward and rw mount options
Date: Sat, 27 Aug 2011 20:21:12 +0400
Message-ID: <CAKywueS=S9KY5bh4=_z0ZsmjdAsAfkPtLhtS6jchKAVowncWFA@mail.gmail.com>
References: <1314461920-6116-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314461920-6116-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/27 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Both these options are started with "rw" - that's why the first one
> isn't switched on even if it is specified. Fix this by adding a lengt=
h
> check for "rw" option check.
>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 633c246..f4af4cc 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1298,7 +1298,7 @@ cifs_parse_mount_options(const char *mountdata,=
 const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ignore */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "guest", 5) =
=3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ignore */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "rw", 2) =3D=3D=
 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "rw", 2) =3D=3D=
 0 && strlen(data) =3D=3D 2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ignore */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "ro", 2) =3D=
=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ignore */
> @@ -1401,7 +1401,7 @@ cifs_parse_mount_options(const char *mountdata,=
 const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->server_ino =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "noserverino=
", 9) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->server_ino =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "rwpidforward=
", 4) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "rwpidforward=
", 12) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->rwpidforward =3D =
1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "cifsacl", 7=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->cifs_acl =3D 1;
> --
> 1.7.1
>
>

Sorry for the spam - forgot to change the patch version.

--=20
Best regards,
Pavel Shilovsky.
