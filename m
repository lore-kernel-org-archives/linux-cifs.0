Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E8A351C2C
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772655487; cv=pass; b=pFXAeTh4Vdstuib73dctHclKhDTZ/+0xkLNFHyJsQgevR7eTYQtJkfcBpRVGRplxXK/Qp96UGm3MpVz3c0EOtQGUwzCh3RmBUEDvaJ78Hc+PIWurpqTFvs2J66BAH2En9DmBBiorusxc/w5wygZUy5kA7pOk3mUMtxrsZ4hFHnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772655487; c=relaxed/simple;
	bh=X+iFFo+ejPRSbjGHSDnGyZTWBKwX4CEt3gumhiJnxws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RXlxIiqiNBlCchXFYe2hY8jcAZ7Jp6QNWyDMDC+E/LCRaV3cQQNWYLm1k3JCuniFkHZMOdDWJaedcDoK+zvT3cmhVei36tPUIeKHOaDmF25zGKEdgCzdwUQs0JjEk90MjSSe4ib7er5Dy9CYswiU7ePiwMrUhctZpoHLV6OYKKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5f9959C; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5f9959C"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89a15b9a556so20063696d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 12:18:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772655485; cv=none;
        d=google.com; s=arc-20240605;
        b=RNHShwK5/ouo+G4ebAncQpZrary9zuYC491upXkY09XUpW+ymXyi1p44OHyDU0YV6u
         UjXe8kNsXhdlD0lgheXWZsmWiGnvqPBPhN6rmf0GxueEIIY+zRW6eTIfAnduutm5bFUJ
         mJq+fXZMkZ6eGknLH5i6DDOoI34DzQkjh5Hi0zDnLTyjDICaOFc4GmmAKJBaunk+QHKJ
         oQMe/4koJ8XsUfgFmDkvL2ZzWjBx3+ZvcILjavBZEUpBUYgQciZhLWfYWhgQ5BxONL1r
         pcX5vvCrpRCfUycZHffd8zEzOyPxqG/srU0wmHOFXnON8/OY0bZ0T8lO88UCEFhINtM/
         2acA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EsfqB/Unked7GAS+ynxb74vvDt5c8106ZB+ARQ8juE8=;
        fh=AhxD/KCvX7nhBOIGqueAzChr6nCyWRjQHNvLM8U+8w8=;
        b=AJJNA0uc3TW60yt4efEPbRA9LBVrhhLqeCjhc6+SPd1xfX5diLlrrOe0FCP+j3mZSi
         clYl1wJviYMWehH4AiVVIRYFkXxuJCxpKGYCKirqRATfz31k6dOvjxwMoYRLvZwx0Faq
         ugAG6V3b+b5KHZUB/bDMbXjb+j1+JKM+YXMJBQzvVsxocY+ILpDP37S1OznUf9Kjqjug
         D23xaF4npX44ZboMsHvjQs0koZe86lWeyX9qyttSledO9KbYOD/JOnvOmiFZpsN7fvjV
         DGVdY6aDL5ERRj1NhAxw/Qa5XOQZnDwZlA04z9KCWOXVRJJXg5DEfBviNQJdxwjhQXAp
         L5nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772655485; x=1773260285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsfqB/Unked7GAS+ynxb74vvDt5c8106ZB+ARQ8juE8=;
        b=b5f9959CDdr+nlI6EhwTvaya28saExUxYp/vd5JbMcRpqViDFEZ4fl6rvKtwaROSKa
         valRS62EJXjjTCYHgLuM/y68OmWGQIKgqYUnm5D0HJ18vcUzJ1RWZhLylNZzQm+2RI6G
         sIC7pjQM5JD6GJEeUiKkpCD7+A/ED2GbQN2FEdKbfQH9z6PC+7i8eKDXYkX6lvxhIHNS
         GQ3LOShJllpA+WSwWXrto4x6LCkGIYUrNdfddEIPDgM0Cqk9xkhqwFJHOyciWZ8jQ+k1
         vyosxRvPK+BfT1dgHWcxttGtnHYBl4SdYBVrFHZ2K1v7zi2/RX8O/mujOqZaLRvPibmN
         qn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772655485; x=1773260285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EsfqB/Unked7GAS+ynxb74vvDt5c8106ZB+ARQ8juE8=;
        b=RyA4oWAkckvt5CtycbZO6jkTW603yG17V82hPf8CjRhzMMJWNfdTgxT/35FmbOOB/g
         a/01UsrhHos+qqxz1En5sTBDKomRWq0KRxjQzV51By0K4KOd7UcocTy4ntVWqay4nAbF
         Xq0ZswYv31ame5AUh2rb1S/k6kFDb+P0e9y4ajG5eNaLKxheyRxM9XNL5YZiOHfLa85j
         c2tAVYupDiuzBwSEYRxy3rsn2xs1Ej3tAspqaCXGB61x8iAP62YXPnSRjVfiYkdQKroq
         T53fTd6dpeDhZyYTC0nV/6hw4Ypd32dO2UjtuWuLlA4k0xC+mZ5qwyIINMwrY7DOk2hh
         wDww==
X-Gm-Message-State: AOJu0YxsqiY9d1gK5SUO8C6sWP/Bqw/RgJwP2cz4lp99XgPC3TsqC/kI
	ZTABK05pRNPtAkpGyAgrdf8HimeiWEBKu2t3ia7iy5CPm0KD/YpboVLlB8T8IMJRCwpVD0lMkTV
	I6DD2i9P8FfS+S+IKypa48Y+xouvMy1E=
X-Gm-Gg: ATEYQzwN2Rst5hLmPBJa5XC1LUM5RiIxQJfks6vFViAZy2yrENnNqev+eOf0JrQu2mt
	FiJAkx5oZg5Mz2dFoGlxoi/92poaFsHh+UetsovptHCpBqplrfRCTOwKN6eIj4q/rHNnIvBkQIf
	sYIlx8sq6fmc4xBL/c5mP9dZ28KpL6KN4VGhBKmoUZjYP6YvhF142Nuk8TStNJZ5AUfv+8+E1A9
	X3J8wxA3u0bxDwmu72mCtHERe0iuu3c2ypBvuvQXhZ73L1tc1wCmzw8P06wNeGsgmeyQnkefA+R
	rQmYO0Wpmb30cVfCZYOsnLs8Ea8vV93BjX7iT6s2LHO5qoL8DnNbl4J0P9eb773eshuYBPRYt21
	FdEZebSZQVdKyytONuEfbW8EinsGyBSow8Z7oovzXBNiU3p32F8x0ceE/MCJPDkKanc4dWt7k1y
	qFeU/lYvDtZ2nV6OC6vN6DCG7dRbP4pKk=
X-Received: by 2002:a05:6214:b61:b0:89a:e15:46fb with SMTP id
 6a1803df08f44-89a19d3ac6emr42086136d6.66.1772655484898; Wed, 04 Mar 2026
 12:18:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304124629.1616108-1-sprasad@microsoft.com>
In-Reply-To: <20260304124629.1616108-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 4 Mar 2026 14:17:52 -0600
X-Gm-Features: AaiRm50imQUdwjoxGxgA7xB14I6-dF5o2toFh1i0wq6WKK2Qd6Nx46fT4vxKQyc
Message-ID: <CAH2r5msx0CQqwBYQ5opG5m2yX+YtBniuvFkOTbQNCzm7ok=PkA@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more review and testing

On Wed, Mar 4, 2026 at 6:46=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today whenever we deal with a file, in addition to holding
> a reference on the dentry, we also get a reference on the
> superblock. This happens in two cases:
> 1. when a new cinode is allocated
> 2. when an oplock break is being processed
>
> The reasoning for holding the superblock ref was to make sure
> that when umount happens, if there are users of inodes and
> dentries, it does not try to clean them up and wait for the
> last ref to superblock to be dropped by last of such users.
>
> But the side effect of doing that is that umount silently drops
> a ref on the superblock and we could have deferred closes and
> lease breaks still holding these refs.
>
> Ideally, we should ensure that all of these users of inodes and
> dentries are cleaned up at the time of umount, which is what this
> code is doing.
>
> This code change allows these code paths to use a ref on the
> dentry (and hence the inode). That way, umount is
> ensured to clean up SMB client resources when it's the last
> ref on the superblock (For ex: when same objects are shared).
>
> The code change also moves the call to close all the files in
> deferred close list to the umount code path. It also waits for
> oplock_break workers to be flushed before calling
> kill_anon_super (which eventually frees up those objects).
>
> Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cifsF=
ileInfo objects are gone")
> Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_brea=
k")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c    |  7 +++++--
>  fs/smb/client/cifsproto.h |  1 +
>  fs/smb/client/file.c      | 11 ----------
>  fs/smb/client/misc.c      | 42 +++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/trace.h     |  2 ++
>  5 files changed, 50 insertions(+), 13 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 99b04234a08e6..fcc56481d6cf2 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -330,10 +330,14 @@ static void cifs_kill_sb(struct super_block *sb)
>
>         /*
>          * We need to release all dentries for the cached directories
> -        * before we kill the sb.
> +        * and close all deferred file handles before we kill the sb.
>          */
>         if (cifs_sb->root) {
>                 close_all_cached_dirs(cifs_sb);
> +               cifs_close_all_deferred_files_sb(cifs_sb);
> +
> +               /* Wait for all pending oplock breaks to complete */
> +               flush_workqueue(cifsoplockd_wq);
>
>                 /* finally release root dentry */
>                 dput(cifs_sb->root);
> @@ -864,7 +868,6 @@ static void cifs_umount_begin(struct super_block *sb)
>         spin_unlock(&tcon->tc_lock);
>         spin_unlock(&cifs_tcp_ses_lock);
>
> -       cifs_close_all_deferred_files(tcon);
>         /* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiti=
ng */
>         /* cancel_notify_requests(tcon); */
>         if (tcon->ses && tcon->ses->server) {
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 96d6b5325aa33..800a7e418c326 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -261,6 +261,7 @@ void cifs_close_deferred_file(struct cifsInodeInfo *c=
ifs_inode);
>
>  void cifs_close_all_deferred_files(struct cifs_tcon *tcon);
>
> +void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb);
>  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
>                                            struct dentry *dentry);
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 18f31d4eb98de..fb4f9aafe1386 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -711,8 +711,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fi=
d *fid, struct file *file,
>         mutex_init(&cfile->fh_mutex);
>         spin_lock_init(&cfile->file_info_lock);
>
> -       cifs_sb_active(inode->i_sb);
> -
>         /*
>          * If the server returned a read oplock and we have mandatory brl=
ocks,
>          * set oplock level to None.
> @@ -767,7 +765,6 @@ static void cifsFileInfo_put_final(struct cifsFileInf=
o *cifs_file)
>         struct inode *inode =3D d_inode(cifs_file->dentry);
>         struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
>         struct cifsLockInfo *li, *tmp;
> -       struct super_block *sb =3D inode->i_sb;
>
>         /*
>          * Delete any outstanding lock records. We'll lose them when the =
file
> @@ -785,7 +782,6 @@ static void cifsFileInfo_put_final(struct cifsFileInf=
o *cifs_file)
>
>         cifs_put_tlink(cifs_file->tlink);
>         dput(cifs_file->dentry);
> -       cifs_sb_deactive(sb);
>         kfree(cifs_file->symlink_target);
>         kfree(cifs_file);
>  }
> @@ -3165,12 +3161,6 @@ void cifs_oplock_break(struct work_struct *work)
>         __u64 persistent_fid, volatile_fid;
>         __u16 net_fid;
>
> -       /*
> -        * Hold a reference to the superblock to prevent it and its inode=
s from
> -        * being freed while we are accessing cinode. Otherwise, _cifsFil=
eInfo_put()
> -        * may release the last reference to the sb and trigger inode evi=
ction.
> -        */
> -       cifs_sb_active(sb);
>         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>                         TASK_UNINTERRUPTIBLE);
>
> @@ -3255,7 +3245,6 @@ void cifs_oplock_break(struct work_struct *work)
>         cifs_put_tlink(tlink);
>  out:
>         cifs_done_oplock_break(cinode);
> -       cifs_sb_deactive(sb);
>  }
>
>  static int cifs_swap_activate(struct swap_info_struct *sis,
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 22cde46309fe0..318533210648d 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -28,6 +28,11 @@
>  #include "fs_context.h"
>  #include "cached_dir.h"
>
> +struct tcon_list {
> +       struct list_head entry;
> +       struct cifs_tcon *tcon;
> +};
> +
>  /* The xid serves as a useful identifier for each incoming vfs request,
>     in a similar way to the mid which is useful to track each sent smb,
>     and CurrentXid can also provide a running counter (although it
> @@ -550,6 +555,43 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon=
)
>         }
>  }
>
> +void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb)
> +{
> +       struct rb_root *root =3D &cifs_sb->tlink_tree;
> +       struct rb_node *node;
> +       struct cifs_tcon *tcon;
> +       struct tcon_link *tlink;
> +       struct tcon_list *tmp_list, *q;
> +       LIST_HEAD(tcon_head);
> +
> +       spin_lock(&cifs_sb->tlink_tree_lock);
> +       for (node =3D rb_first(root); node; node =3D rb_next(node)) {
> +               tlink =3D rb_entry(node, struct tcon_link, tl_rbnode);
> +               tcon =3D tlink_tcon(tlink);
> +               if (IS_ERR(tcon))
> +                       continue;
> +               tmp_list =3D kmalloc_obj(struct tcon_list, GFP_ATOMIC);
> +               if (tmp_list =3D=3D NULL)
> +                       break;
> +               tmp_list->tcon =3D tcon;
> +               /* Take a reference on tcon to prevent it from being free=
d */
> +               spin_lock(&tcon->tc_lock);
> +               ++tcon->tc_count;
> +               trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
> +                                   netfs_trace_tcon_ref_get_close_defer_=
files);
> +               spin_unlock(&tcon->tc_lock);
> +               list_add_tail(&tmp_list->entry, &tcon_head);
> +       }
> +       spin_unlock(&cifs_sb->tlink_tree_lock);
> +
> +       list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
> +               cifs_close_all_deferred_files(tmp_list->tcon);
> +               list_del(&tmp_list->entry);
> +               cifs_put_tcon(tmp_list->tcon, netfs_trace_tcon_ref_put_cl=
ose_defer_files);
> +               kfree(tmp_list);
> +       }
> +}
> +
>  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
>                                            struct dentry *dentry)
>  {
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 9228f95cae2bd..acfbb63086ea2 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -176,6 +176,7 @@
>         EM(netfs_trace_tcon_ref_get_cached_laundromat,  "GET Ch-Lau") \
>         EM(netfs_trace_tcon_ref_get_cached_lease_break, "GET Ch-Lea") \
>         EM(netfs_trace_tcon_ref_get_cancelled_close,    "GET Cn-Cls") \
> +       EM(netfs_trace_tcon_ref_get_close_defer_files,  "GET Cl-Def") \
>         EM(netfs_trace_tcon_ref_get_dfs_refer,          "GET DfsRef") \
>         EM(netfs_trace_tcon_ref_get_find,               "GET Find  ") \
>         EM(netfs_trace_tcon_ref_get_find_sess_tcon,     "GET FndSes") \
> @@ -187,6 +188,7 @@
>         EM(netfs_trace_tcon_ref_put_cancelled_close,    "PUT Cn-Cls") \
>         EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
>         EM(netfs_trace_tcon_ref_put_cancelled_mid,      "PUT Cn-Mid") \
> +       EM(netfs_trace_tcon_ref_put_close_defer_files,  "PUT Cl-Def") \
>         EM(netfs_trace_tcon_ref_put_mnt_ctx,            "PUT MntCtx") \
>         EM(netfs_trace_tcon_ref_put_dfs_refer,          "PUT DfsRfr") \
>         EM(netfs_trace_tcon_ref_put_reconnect_server,   "PUT Reconn") \
> --
> 2.43.0
>


--=20
Thanks,

Steve
