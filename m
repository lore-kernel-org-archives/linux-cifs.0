From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: remove unneeded variable initialization in cifs_reconnect_tcon
Date: Tue, 5 Apr 2011 12:06:59 -0500
Message-ID: <BANLkTin4Js462-nZcBcSYD6YO_1b9UEeRA@mail.gmail.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
	<1301607405-4379-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607405-4379-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is fine, but what about this alternative (initializing variables
can make code easier to read, and given dumb compiler warnings
sometimes better to leave in variable initialization ...):

stevef@stevef-laptop:~/cifs-2.6$ git diff -a
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 92e33d4..e4993a2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -117,7 +117,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb=
_command)
         * calling routine
         */
        if (!tcon)
-               return 0;
+               return rc;

        ses =3D tcon->ses;
        server =3D ses->server;


On Thu, Mar 31, 2011 at 4:36 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 1622978..4f5c6d0 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -106,7 +106,7 @@ static void mark_open_files_invalid(struct cifs_t=
con *pTcon)
> =A0static int
> =A0cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
> =A0{
> - =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 int rc;
> =A0 =A0 =A0 =A0struct cifs_ses *ses;
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server;
> =A0 =A0 =A0 =A0struct nls_table *nls_codepage;
> --
> 1.7.4
>
>



--=20
Thanks,

Steve
