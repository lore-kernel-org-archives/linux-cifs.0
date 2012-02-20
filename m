From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: clean up call to cifs_dfs_release_automount_timer()
Date: Mon, 20 Feb 2012 05:23:54 -0600
Message-ID: <CADT32e+RiGwF9shDbVVuXed=ES4CUHCA=gYbi7TK+kJ6PV-sXg@mail.gmail.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
	<1329489104-7823-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 17, 2012 at 8:31 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Take the #ifdef junk out of the code, and turn it into a noop macro
> when CONFIG_CIFS_DFS_UPCALL isn't defined.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A02 --
> =A0fs/cifs/cifsproto.h | =A0 =A06 ++++++
> =A02 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b1fd382..f5fa651 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1182,9 +1182,7 @@ exit_cifs(void)
> =A0 =A0 =A0 =A0cFYI(DBG2, "exit_cifs");
> =A0 =A0 =A0 =A0cifs_proc_clean();
> =A0 =A0 =A0 =A0cifs_fscache_unregister();
> -#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0 =A0 =A0 =A0cifs_dfs_release_automount_timer();
> -#endif
> =A0#ifdef CONFIG_CIFS_ACL
> =A0 =A0 =A0 =A0cifs_destroy_idmaptrees();
> =A0 =A0 =A0 =A0exit_cifs_idmap();
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 6f4e243..121b949 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -168,7 +168,13 @@ extern struct smb_vol *cifs_get_volume_info(char=
 *mount_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0const char *devname);
> =A0extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
> =A0extern void cifs_umount(struct cifs_sb_info *);
> +
> +#if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
> =A0extern void cifs_dfs_release_automount_timer(void);
> +#else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
> +#define cifs_dfs_release_automount_timer() =A0 =A0 do { } while(0)
> +#endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
> +
> =A0void cifs_proc_init(void);
> =A0void cifs_proc_clean(void);
>
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
