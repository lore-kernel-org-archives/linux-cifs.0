From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: add new cifsiod_wq workqueue
Date: Mon, 20 Feb 2012 05:24:49 -0600
Message-ID: <CADT32eKfB++aKpC0McgsUg+NdNDy15HWz0X1ecYqqWTzz1BFpA@mail.gmail.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
	<1329489104-7823-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 17, 2012 at 8:31 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> ...and convert existing cifs users of system_nrt_wq to use that inste=
ad.
>
> Also, make it freezable, and set WQ_MEM_RECLAIM since we use it to
> deal with write reply handling.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 13 ++++++++++++-
> =A0fs/cifs/cifsglob.h | =A0 =A01 +
> =A0fs/cifs/cifssmb.c =A0| =A0 =A04 ++--
> =A0fs/cifs/connect.c =A0| =A0 =A08 ++++----
> =A0fs/cifs/misc.c =A0 =A0 | =A0 =A02 +-
> =A05 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index a848082..8193c92 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -90,6 +90,8 @@ extern mempool_t *cifs_sm_req_poolp;
> =A0extern mempool_t *cifs_req_poolp;
> =A0extern mempool_t *cifs_mid_poolp;
>
> +struct workqueue_struct =A0 =A0 =A0 =A0*cifsiod_wq;
> +
> =A0static int
> =A0cifs_read_super(struct super_block *sb)
> =A0{
> @@ -1121,9 +1123,15 @@ init_cifs(void)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "cifs_max_pending set to max o=
f 256");
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 cifsiod_wq =3D alloc_workqueue("cifsiod", WQ_FREEZABLE|=
WQ_MEM_RECLAIM, 0);
> + =A0 =A0 =A0 if (!cifsiod_wq) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_clean_proc;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0rc =3D cifs_fscache_register();
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_clean_proc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_destroy_wq;
>
> =A0 =A0 =A0 =A0rc =3D cifs_init_inodecache();
> =A0 =A0 =A0 =A0if (rc)
> @@ -1171,6 +1179,8 @@ out_destroy_inodecache:
> =A0 =A0 =A0 =A0cifs_destroy_inodecache();
> =A0out_unreg_fscache:
> =A0 =A0 =A0 =A0cifs_fscache_unregister();
> +out_destroy_wq:
> + =A0 =A0 =A0 destroy_workqueue(cifsiod_wq);
> =A0out_clean_proc:
> =A0 =A0 =A0 =A0cifs_proc_clean();
> =A0 =A0 =A0 =A0return rc;
> @@ -1193,6 +1203,7 @@ exit_cifs(void)
> =A0 =A0 =A0 =A0cifs_destroy_mids();
> =A0 =A0 =A0 =A0cifs_destroy_inodecache();
> =A0 =A0 =A0 =A0cifs_fscache_unregister();
> + =A0 =A0 =A0 destroy_workqueue(cifsiod_wq);
> =A0 =A0 =A0 =A0cifs_proc_clean();
> =A0}
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 76e7d8b..5d0c4b6 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1027,5 +1027,6 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
> =A0void cifs_oplock_break(struct work_struct *work);
>
> =A0extern const struct slow_work_ops cifs_oplock_break_ops;
> +extern struct workqueue_struct *cifsiod_wq;
>
> =A0#endif /* _CIFS_GLOB_H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 8b7794c..4fb1643 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1667,7 +1667,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata->result =3D -EIO;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 queue_work(system_nrt_wq, &rdata->work);
> + =A0 =A0 =A0 queue_work(cifsiod_wq, &rdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> =A0 =A0 =A0 =A0atomic_dec(&server->inFlight);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> @@ -2108,7 +2108,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 queue_work(system_nrt_wq, &wdata->work);
> + =A0 =A0 =A0 queue_work(cifsiod_wq, &wdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> =A0 =A0 =A0 =A0atomic_dec(&tcon->ses->server->inFlight);
> =A0 =A0 =A0 =A0wake_up(&tcon->ses->server->request_q);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 602f77c..fff5e5d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -334,7 +334,7 @@ cifs_echo_request(struct work_struct *work)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->hostname);
>
> =A0requeue_echo:
> - =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &server->echo, SMB_EC=
HO_INTERVAL);
> + =A0 =A0 =A0 queue_delayed_work(cifsiod_wq, &server->echo, SMB_ECHO_=
INTERVAL);
> =A0}
>
> =A0static bool
> @@ -1974,7 +1974,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0cifs_fscache_get_client_cookie(tcp_ses);
>
> =A0 =A0 =A0 =A0/* queue echo request delayed work */
> - =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_E=
CHO_INTERVAL);
> + =A0 =A0 =A0 queue_delayed_work(cifsiod_wq, &tcp_ses->echo, SMB_ECHO=
_INTERVAL);
>
> =A0 =A0 =A0 =A0return tcp_ses;
>
> @@ -3539,7 +3539,7 @@ remote_path_check:
> =A0 =A0 =A0 =A0tlink_rb_insert(&cifs_sb->tlink_tree, tlink);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_sb->tlink_tree_lock);
>
> - =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlink=
s,
> + =A0 =A0 =A0 queue_delayed_work(cifsiod_wq, &cifs_sb->prune_tlinks,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TLINK_=
IDLE_EXPIRE);
>
> =A0mount_fail_check:
> @@ -4091,6 +4091,6 @@ cifs_prune_tlinks(struct work_struct *work)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_sb->tlink_tree_lock);
>
> - =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlink=
s,
> + =A0 =A0 =A0 queue_delayed_work(cifsiod_wq, &cifs_sb->prune_tlinks,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TLINK_=
IDLE_EXPIRE);
> =A0}
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 703ef5c..bd215f2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -584,7 +584,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_s=
et_oplock_level(pCifsInode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0pSMB->OplockLevel ? OPLOCK_READ : 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_w=
ork(system_nrt_wq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_w=
ork(cifsiod_wq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 &netfile->oplock_break);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netfil=
e->oplock_break_cancelled =3D false;
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
