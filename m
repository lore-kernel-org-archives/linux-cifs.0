From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: unbreak TCP session reuse
Date: Tue, 19 Jul 2016 13:33:37 +0100
Message-ID: <1468931617.4942.17.camel@redhat.com>
References: <1468913145-23353-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468913145-23353-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-07-19 at 09:25 +0200, Rabin Vincent wrote:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>=20
> adfeb3e0 ("cifs: Make echo interval tunable") added a comparison of
> vol->echo_interval to server->echo_interval as a criterium to
> match_server(), but:
>=20
> =C2=A0(1) A default value is set for server->echo_interval but not fo=
r
> =C2=A0vol->echo_interval, meaning these can never match if the
> echo_interval
> =C2=A0option is not specified.
>=20
> =C2=A0(2) vol->echo_interval is in seconds but server->echo_interval =
is in
> =C2=A0jiffies, meaning these can never match even if the echo_interva=
l
> option
> =C2=A0is specified.
>=20
> This broke TCP session reuse since match_server() can never return 1.
> Fix it.
>=20
> Fixes: adfeb3e0 ("cifs: Make echo interval tunable")
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>

Nice catch

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
> =C2=A0fs/cifs/connect.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7d2b15c..eb24653 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1228,6 +1228,8 @@ cifs_parse_mount_options(const char *mountdata,
> const char *devname,
> =C2=A0	vol->ops =3D &smb1_operations;
> =C2=A0	vol->vals =3D &smb1_values;
> =C2=A0
> +	vol->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT;
> +
> =C2=A0	if (!mountdata)
> =C2=A0		goto cifs_parse_mount_err;
> =C2=A0
> @@ -2049,7 +2051,7 @@ static int match_server(struct TCP_Server_Info
> *server, struct smb_vol *vol)
> =C2=A0	if (!match_security(server, vol))
> =C2=A0		return 0;
> =C2=A0
> -	if (server->echo_interval !=3D vol->echo_interval)
> +	if (server->echo_interval !=3D vol->echo_interval * HZ)
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	return 1;
