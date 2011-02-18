From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: fix handling of scopeid in resolve_host
Date: Thu, 17 Feb 2011 20:27:18 -0500
Message-ID: <20110217202718.6dd68d31@corrin.poochiereds.net>
References: <1297794670-4345-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297794670-4345-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Feb 2011 13:31:10 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> We get a pointer to the end of the address string (ipaddr), but the c=
all
> snprintf and pass in tmpbuf which is a pointer to the beginning of th=
e
> address string. If someone passes in an address with a scopeid then w=
e
> end up overwriting the entire address string.
>=20
> Reported-by: Bj=F6rn JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  resolve_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/resolve_host.c b/resolve_host.c
> index 7687503..69859a3 100644
> --- a/resolve_host.c
> +++ b/resolve_host.c
> @@ -71,7 +71,7 @@ int resolve_host(const char *host, char *addrstr)
>  			if (sin6->sin6_scope_id) {
>  				len =3D strnlen(tmpbuf, sizeof(tmpbuf));
>  				ipaddr =3D tmpbuf + len;
> -				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
> +				snprintf(ipaddr, sizeof(tmpbuf) - len, "%%%u",
>  					 sin6->sin6_scope_id);
>  			}
>  			break;

Merged, should make 4.9.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
