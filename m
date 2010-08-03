From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: account for new creduid=0x%x parameter in spnego
	upcall string
Date: Tue, 3 Aug 2010 09:32:40 -0500
Message-ID: <AANLkTi=aKR9xwOL5cgATZW3h4r0gO3dr+nNG=a+6vtcM@mail.gmail.com>
References: <1280845241-12305-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280845241-12305-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

looks fine

On Tue, Aug 3, 2010 at 9:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The commit that added the creduid=3D0x%x parameter failed to increase=
 the
> buffer allocation to account for it.
>
> Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_spnego.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 6effccf..8704490 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -84,6 +84,9 @@ struct key_type cifs_spnego_key_type =3D {
> =A0/* strlen of ";uid=3D0x" */
> =A0#define UID_KEY_LEN =A0 =A0 =A0 =A0 =A0 =A07
>
> +/* strlen of ";creduid=3D0x" */
> +#define CREDUID_KEY_LEN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A011
> +
> =A0/* strlen of ";user=3D" */
> =A0#define USER_KEY_LEN =A0 =A0 =A0 =A0 =A0 6
>
> @@ -107,6 +110,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IP_KEY_LEN + INET6_ADDRSTRLEN +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_MECH_STR_LEN +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UID_KEY_LEN + (sizeof(uid_t) * 2)=
 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CREDUID_KEY_LEN + (sizeof(uid_t)=
 * 2) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 USER_KEY_LEN + strlen(sesInfo->us=
erName) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PID_KEY_LEN + (sizeof(pid_t) * 2)=
 + 1;
>
> --
> 1.7.2
>
>



--=20
Thanks,

Steve
