From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: clean up ordering in exit_cifs
Date: Mon, 20 Feb 2012 05:24:19 -0600
Message-ID: <CADT32eJWj7Fp9p2vwgcMrtwC_A4dbphFZ-cMsARJ9d+v0cL3DA@mail.gmail.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
	<1329489104-7823-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 17, 2012 at 8:31 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> ...ensure that we undo things in the reverse order from the way they
> were done. In truth, the ordering doesn't matter for a lot of these,
> but it's still better to do it that way to be sure.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 10 +++++-----
> =A01 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f5fa651..a848082 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1180,8 +1180,7 @@ static void __exit
> =A0exit_cifs(void)
> =A0{
> =A0 =A0 =A0 =A0cFYI(DBG2, "exit_cifs");
> - =A0 =A0 =A0 cifs_proc_clean();
> - =A0 =A0 =A0 cifs_fscache_unregister();
> + =A0 =A0 =A0 unregister_filesystem(&cifs_fs_type);
> =A0 =A0 =A0 =A0cifs_dfs_release_automount_timer();
> =A0#ifdef CONFIG_CIFS_ACL
> =A0 =A0 =A0 =A0cifs_destroy_idmaptrees();
> @@ -1190,10 +1189,11 @@ exit_cifs(void)
> =A0#ifdef CONFIG_CIFS_UPCALL
> =A0 =A0 =A0 =A0unregister_key_type(&cifs_spnego_key_type);
> =A0#endif
> - =A0 =A0 =A0 unregister_filesystem(&cifs_fs_type);
> - =A0 =A0 =A0 cifs_destroy_inodecache();
> - =A0 =A0 =A0 cifs_destroy_mids();
> =A0 =A0 =A0 =A0cifs_destroy_request_bufs();
> + =A0 =A0 =A0 cifs_destroy_mids();
> + =A0 =A0 =A0 cifs_destroy_inodecache();
> + =A0 =A0 =A0 cifs_fscache_unregister();
> + =A0 =A0 =A0 cifs_proc_clean();
> =A0}
>
> =A0MODULE_AUTHOR("Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>");
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
