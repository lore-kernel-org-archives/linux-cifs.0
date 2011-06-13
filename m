From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: show sec= option in /proc/mounts
Date: Mon, 13 Jun 2011 11:12:09 -0500
Message-ID: <BANLkTi=o1yGNG3j0C18oJqAC6r+SUh8L8w@mail.gmail.com>
References: <1307980241-2265-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307980241-2265-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

seems reasonable to display this.

Merged.

On Mon, Jun 13, 2011 at 10:50 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 33 +++++++++++++++++++++++++++++++++
> =A01 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 989442d..e9def99 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -352,6 +352,37 @@ cifs_show_address(struct seq_file *s, struct TCP=
_Server_Info *server)
> =A0 =A0 =A0 =A0}
> =A0}
>
> +static void
> +cifs_show_security(struct seq_file *s, struct TCP_Server_Info *serve=
r)
> +{
> + =A0 =A0 =A0 seq_printf(s, ",sec=3D");
> +
> + =A0 =A0 =A0 switch (server->secType) {
> + =A0 =A0 =A0 case LANMAN:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "lanman");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case NTLMv2:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "ntlmv2");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case NTLM:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "ntlm");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case Kerberos:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "krb5");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case RawNTLMSSP:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "ntlmssp");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* shouldn't ever happen */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "unknown");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE=
_SIGN_ENABLED))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, "i");
> +}
> +
> =A0/*
> =A0* cifs_show_options() is for displaying mount options in /proc/mou=
nts.
> =A0* Not all settable options are displayed but most of the important
> @@ -365,6 +396,8 @@ cifs_show_options(struct seq_file *s, struct vfsm=
ount *m)
> =A0 =A0 =A0 =A0struct sockaddr *srcaddr;
> =A0 =A0 =A0 =A0srcaddr =3D (struct sockaddr *)&tcon->ses->server->src=
addr;
>
> + =A0 =A0 =A0 cifs_show_security(s, tcon->ses->server);
> +
> =A0 =A0 =A0 =A0seq_printf(s, ",unc=3D%s", tcon->treeName);
>
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> --
> 1.7.5.2
>
>



--=20
Thanks,

Steve
