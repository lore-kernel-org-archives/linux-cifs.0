From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: stuff the fl_owner into "pid" field in the lock
 request
Date: Wed, 25 May 2016 12:04:11 +0100
Message-ID: <1464174251.13286.1.camel@redhat.com>
References: <1464085664-4391-1-git-send-email-jeff.layton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464085664-4391-1-git-send-email-jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-05-24 at 06:27 -0400, Jeff Layton wrote:
> Right now, we send the tgid cross the wire. What we really want to
> send
> though is a hashed fl_owner_t since samba treats this field as a
> generic
> lockowner.
>=20
> It turns out that because we enforce and release locks locally before
> they are ever sent to the server, this patch makes no difference in
> behavior. Still, setting OFD locks on the server using the process
> pid seems wrong, so I think this patch still makes sense.
>=20
> Signed-off-by: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
> =C2=A0fs/cifs/cifsfs.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A03 +++
> =C2=A0fs/cifs/cifsglob.h |=C2=A0=C2=A01 +
> =C2=A0fs/cifs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 14 +++++++++++---
> =C2=A03 files changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 08fa36e5b2bc..1ef5b8aee878 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -87,6 +87,7 @@ extern mempool_t *cifs_req_poolp;
> =C2=A0extern mempool_t *cifs_mid_poolp;
> =C2=A0
> =C2=A0struct workqueue_struct	*cifsiod_wq;
> +__u32 cifs_lock_secret;
> =C2=A0
> =C2=A0/*
> =C2=A0 * Bumps refcount for cifs super block.
> @@ -1271,6 +1272,8 @@ init_cifs(void)
> =C2=A0	spin_lock_init(&cifs_file_list_lock);
> =C2=A0	spin_lock_init(&GlobalMid_Lock);
> =C2=A0
> +	get_random_bytes(&cifs_lock_secret,
> sizeof(cifs_lock_secret));
> +
> =C2=A0	if (cifs_max_pending < 2) {
> =C2=A0		cifs_max_pending =3D 2;
> =C2=A0		cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index bba106cdc43c..8f1d8c1e72be 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1619,6 +1619,7 @@ void cifs_oplock_break(struct work_struct
> *work);
> =C2=A0
> =C2=A0extern const struct slow_work_ops cifs_oplock_break_ops;
> =C2=A0extern struct workqueue_struct *cifsiod_wq;
> +extern __u32 cifs_lock_secret;
> =C2=A0
> =C2=A0extern mempool_t *cifs_mid_poolp;
> =C2=A0
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9793ae0bcaa2..d4890b6dc22d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1112,6 +1112,12 @@ cifs_push_mandatory_locks(struct cifsFileInfo
> *cfile)
> =C2=A0	return rc;
> =C2=A0}
> =C2=A0
> +static __u32
> +hash_lockowner(fl_owner_t owner)
> +{
> +	return cifs_lock_secret ^ hash32_ptr((const void *)owner);
> +}
> +
> =C2=A0struct lock_to_push {
> =C2=A0	struct list_head llist;
> =C2=A0	__u64 offset;
> @@ -1178,7 +1184,7 @@ cifs_push_posix_locks(struct cifsFileInfo
> *cfile)
> =C2=A0		else
> =C2=A0			type =3D CIFS_WRLCK;
> =C2=A0		lck =3D list_entry(el, struct lock_to_push, llist);
> -		lck->pid =3D flock->fl_pid;
> +		lck->pid =3D hash_lockowner(flock->fl_owner);
> =C2=A0		lck->netfid =3D cfile->fid.netfid;
> =C2=A0		lck->length =3D length;
> =C2=A0		lck->type =3D type;
> @@ -1305,7 +1311,8 @@ cifs_getlk(struct file *file, struct file_lock
> *flock, __u32 type,
> =C2=A0			posix_lock_type =3D CIFS_RDLCK;
> =C2=A0		else
> =C2=A0			posix_lock_type =3D CIFS_WRLCK;
> -		rc =3D CIFSSMBPosixLock(xid, tcon, netfid, current-
> >tgid,
> +		rc =3D CIFSSMBPosixLock(xid, tcon, netfid,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hash_lockowner(flock-
> >fl_owner),
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0flock->fl_start, length=
,
> flock,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0posix_lock_type, wait_f=
lag);
> =C2=A0		return rc;
> @@ -1505,7 +1512,8 @@ cifs_setlk(struct file *file, struct file_lock
> *flock, __u32 type,
> =C2=A0			posix_lock_type =3D CIFS_UNLCK;
> =C2=A0
> =C2=A0		rc =3D CIFSSMBPosixLock(xid, tcon, cfile->fid.netfid,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0current->tgid, flock-
> >fl_start, length,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hash_lockowner(flock-
> >fl_owner),
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0flock->fl_start, length,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NULL, posix_lock_type,
> wait_flag);
> =C2=A0		goto out;
> =C2=A0	}
