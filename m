From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: remove checks for ses->status == CifsExiting
Date: Mon, 7 Feb 2011 11:27:00 -0600
Message-ID: <AANLkTikzvO9+y6c0P4Q8jRm-1FHF0i_fBEBUgXJWe-F9@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<1297086876-19165-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297086876-19165-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> ses->status is never set to CifsExiting, so these checks are
> always false.
>
> Tested-by: JG <jg-9fI4heB6ewM@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A05 +----
> =A01 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 46c66ed..904aa47 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -136,9 +136,6 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, in=
t smb_command)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (ses->status =3D=3D CifsExiting)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> -
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Give demultiplex thread up to 10 seconds to reconne=
ct, should be
> =A0 =A0 =A0 =A0 * greater than cifs socket timeout which is 7 seconds
> @@ -156,7 +153,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, in=
t smb_command)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * retrying until process is killed or=
 server comes
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * back on-line
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!tcon->retry || ses->status =3D=3D =
CifsExiting) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!tcon->retry) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "gave up waiti=
ng on reconnect in smb_init");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EHOSTDOWN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.4
>
>



--=20
Thanks,

Steve
