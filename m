From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: demote DFS referral lookup errors to cFYI
Date: Sun, 31 Jul 2011 17:24:26 -0500
Message-ID: <CAH2r5mu5A7iifd8m_+kqFz79Niq9=Lk_DY-2J5PtB=stkF8wPg@mail.gmail.com>
References: <1308776756-16030-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308776756-16030-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we can not distinguish between error 126 (ENOKEY) meaning
"not found since the hostname doesn't exist" and "your configuration
is broken (you don't have a dns upcall module setup)"
we do need a way to warn the user on the latter - but that requires
changes to dns_query or the keyctl it invokes.

I opened kernel buzilla 40392 to track this - although I don't know
the easiest/best way to fix this.

In any case - cifs shouldn't be logging this (as Jeff noted) - we need
the warning (once)
below cifs in dns_query (e.g.) so I have merged Jeff's patch to demote
the cERROR
to cFYI for this common case.

On Wed, Jun 22, 2011 at 4:05 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Now that we call into this routine on every mount, anyone who doesn't
> have the upcall configured will get multiple printks about failed loo=
kups.
>
> Reported-and-Tested-by: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua0QJLXQMEiss@public.gmane.org=
utwente.nl>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_dfs_ref.c | =A0 =A05 +++--
> =A0fs/cifs/dns_resolve.c =A0| =A0 =A04 ++--
> =A02 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 8d8f28c..6873bb6 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -141,10 +141,11 @@ char *cifs_compose_mount_options(const char *sb=
_mountdata,
>
> =A0 =A0 =A0 =A0rc =3D dns_resolve_server_name_to_ip(*devname, &srvIP)=
;
> =A0 =A0 =A0 =A0if (rc < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Failed to resolve server=
 part of %s to IP: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, *devname,=
 rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Failed to resolve server p=
art of %s to IP: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, *devname, rc)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto compose_mount_options_err;
> =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0/* md_len =3D strlen(...) + 12 for 'sep+prefixpath=3D'
> =A0 =A0 =A0 =A0 * assuming that we have 'unc=3D' and 'ip=3D' in
> =A0 =A0 =A0 =A0 * the original sb_mountdata
> diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> index 548f062..1d2d91d 100644
> --- a/fs/cifs/dns_resolve.c
> +++ b/fs/cifs/dns_resolve.c
> @@ -79,8 +79,8 @@ dns_resolve_server_name_to_ip(const char *unc, char=
 **ip_addr)
> =A0 =A0 =A0 =A0/* Perform the upcall */
> =A0 =A0 =A0 =A0rc =3D dns_query(NULL, hostname, len, NULL, ip_addr, N=
ULL);
> =A0 =A0 =A0 =A0if (rc < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: unable to resolve: %*.*s=
",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, len, len, host=
name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: unable to resolve: %*.*s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, len, len, hos=
tname);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s: resolved: %*.*s to %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, len, len, hostname,=
 *ip_addr);
> --
> 1.7.5.4
>
>



--=20
Thanks,

Steve
