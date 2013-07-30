From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Do not rely on hardcoded path to systemd-ask-password.
Date: Tue, 30 Jul 2013 06:35:14 -0400
Message-ID: <20130730063514.2e85550c@corrin.poochiereds.net>
References: <1375171226-13515-1-git-send-email-mgorny@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWljaGHFgiBHw7Nybnk=?= <mgorny-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375171226-13515-1-git-send-email-mgorny-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Jul 2013 10:00:26 +0200
Micha=C5=82 G=C3=B3rny <mgorny-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:

> Relying on hardcoded /bin/systemd-ask-password path breaks systemd th=
at
> install systemd-ask-password in /usr/bin. Since both paths are suppos=
ed
> to be in ${PATH} and popen() passes the command to shell, just pass
> 'systemd-ask-password' and let the shell find it.
>=20
> Fixes: https://bugzilla.samba.org/show_bug.cgi?id=3D10054
> Signed-off-by: Micha=C5=82 G=C3=B3rny <mgorny-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
> ---
>  mount.cifs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/mount.cifs.c b/mount.cifs.c
> index e76beee..7206dcb 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1626,7 +1626,7 @@ drop_child_privs(void)
>  }
> =20
>  /*
> - * If systemd is running and /bin/systemd-ask-password --
> + * If systemd is running and systemd-ask-password --
>   * is available, then use that else fallback on getpass(..)
>   *
>   * Returns: @input or NULL on error
> @@ -1649,7 +1649,7 @@ get_password(const char *prompt, char *input, i=
nt capacity)
>  		FILE *ask_pass_fp =3D NULL;
> =20
>  		cmd =3D ret =3D NULL;
> -		if (asprintf(&cmd, "/bin/systemd-ask-password \"%s\"", prompt) >=3D=
 0) {
> +		if (asprintf(&cmd, "systemd-ask-password \"%s\"", prompt) >=3D 0) =
{
>  			ask_pass_fp =3D popen (cmd, "re");
>  			free (cmd);
>  		}

Looks good, thanks. Will apply in a few days assuming no one objects.
I'll probably also throw in a comment mentioning that this relies on th=
e
binary being in $PATH.

It might also be nice to consider adding an autoconf switch to set
this, but I think that relying on $PATH is probably reasonable in most
cases.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
