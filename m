From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix oops in session setup code for null user mounts
Date: Thu, 2 Feb 2012 17:02:43 -0600
Message-ID: <CAH2r5mupM-Jg-Go5-n7gY-0raNHCXYOZ_U4JjnX6s2WZGCVk_w@mail.gmail.com>
References: <1328218108-4668-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328218108-4668-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Thu, Feb 2, 2012 at 3:28 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> For null user mounts, do not invoke string length function
> during session setup.
>
>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Reported-and-Tested-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/sess.c | =A0 =A07 +++----
> =A01 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index eb76741..551d0c2 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -246,16 +246,15 @@ static void ascii_ssetup_strings(char **pbcc_ar=
ea, struct cifs_ses *ses,
> =A0 =A0 =A0 =A0/* copy user */
> =A0 =A0 =A0 =A0/* BB what about null user mounts - check that we do t=
his BB */
> =A0 =A0 =A0 =A0/* copy user */
> - =A0 =A0 =A0 if (ses->user_name !=3D NULL)
> + =A0 =A0 =A0 if (ses->user_name !=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strncpy(bcc_ptr, ses->user_name, MAX_U=
SERNAME_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D strnlen(ses->user_name, MA=
X_USERNAME_SIZE);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0/* else null user mount */
> -
> - =A0 =A0 =A0 bcc_ptr +=3D strnlen(ses->user_name, MAX_USERNAME_SIZE)=
;
> =A0 =A0 =A0 =A0*bcc_ptr =3D 0;
> =A0 =A0 =A0 =A0bcc_ptr++; /* account for null termination */
>
> =A0 =A0 =A0 =A0/* copy domain */
> -
> =A0 =A0 =A0 =A0if (ses->domainName !=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strncpy(bcc_ptr, ses->domainName, 256)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D strnlen(ses->domainName, =
256);
> --
> 1.6.0.2
>



--=20
Thanks,

Steve
