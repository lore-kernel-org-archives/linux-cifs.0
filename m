Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9306262819
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741730940; cv=none; b=hs/PUYhdO3KK7cSAnB/hsnjUxvx4G26jcKUbe0AiMKLTf5EGAQI2CtASAI8DVzejvaedw8Kz5w7FdDDlZ6U/z6XMIRlOGvpw29dW+cGv6B8I8Jc/aavFiBqwlB76SDyMXbkGTiH8fN7vFsn1EiiyThxteKCfn1f6+XrFINMBssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741730940; c=relaxed/simple;
	bh=rakMxmqssZ3zKMZQFwmchlhNOeoI/TZ7hWfF51/FCUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kbf9igpAGrkzPNpXAbie4FODuwL12wYfDVgzyQrwKrG9EsoaujbluLkru1HqDqGlJt55cGP7ghxGKv5953i8fOQsto0qCEp1p6cygBFn2YdzIpcXA1JOQ/NZdVAd0eD/8MT4k+Cco2Y58zRJ3HPEZSPiuDDI8Yp4FbtsxcYStDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QyGlrDbr; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QyGlrDbr"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30bd21f887aso53414831fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 15:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741730936; x=1742335736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AG/WnlTL0At8p/MMA4Vh3/X+iPAL7myiPF+91Q7JDgM=;
        b=QyGlrDbrlovy1qI6M7iOwnnqa4CxZ2VO69Ci2+0vTdwr0lDKcOczk6QfmKoPkpNyK6
         bjxnWvashoUNWoUzstTMNG6N0x5GUKXJtwMZkzBPShb1m+yxVCZ3P+DBy7W/RrMCY+gg
         QyjFUDL25n2IJEDJ+yY5gHAZprcVA2xE+5jYS1xg8IZUAazDskB7x9vVTSjvdkSZsz6q
         EdS/ov1qYzKKNvSHwvO8fSwzJyd5hyGoqeQGjfMi9KX6LKQ2Pz7+U2CsJKccrZkgk/k5
         Kf3HyBjNva10/EPs1xNLCSiaJVs10gUa/TvZIDUJ1nAYkCPk7Hh3P0wnK1erYzVis7Jv
         oUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741730936; x=1742335736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AG/WnlTL0At8p/MMA4Vh3/X+iPAL7myiPF+91Q7JDgM=;
        b=iEKY8vwII5AVIEoCBG6iEYHSIBbeYwRUSZC1J0uyMp0jdgx8wR6zWUlBuxVkmKigUL
         RFZhdSui1cMXjc+4d5vBkrnuTn4ORi+wHLlU9McE4b/3MwEqsYSCvAkYDOKZrtccxwxa
         FHpLwlG+KVWcsC0cZ96gRVMXtMxKXi1jHb4RQLr2+jEXr1uZ1xEKgVrzrBXaTyu0mJZS
         D89qwAQmfW9bWBEpGr9CuLqvyYp2XXTyhhnp2Zc6DhZJd/MW/pNE79jrVkQiH7SGAfmc
         tT15PrvyI9bM0DNJpSwEKvfipNsBC7bZiwN9IbiuE4zutAnPLihv2nGf0/a9RcoMusUy
         69WQ==
X-Gm-Message-State: AOJu0YwbHQxGsMCtzpiCagshFdKoRvHLx/S90xSdxnamGSQjPTjPe2Jk
	eaZax1npc5FQPugjJOyjsZtjndNqKILpLZHoSC2pdUT0Oupesihj3k5Y45qS9N4PL77+l2/gR1Y
	ZH2ts1IIQim5NFlRNMiJLImYEm78=
X-Gm-Gg: ASbGncuEq6M/MAgJ3EpxYZTvjabeNjsFTG2NMDFdbwb3zdU9/6nF014I+I4ZmwvlmuL
	iw8XwDjGQLLK1LfzugN3Oe5iWp499FNQpBjMTy7JZKhJYxHs1O98n7zgtosjf9HebsNjXs7a38g
	n6RybBAuGWz7ejZXe0ONAeqRbq9B69qSVl/1yKkr9XR4czyjX9PLMwydeBByeLBfkHqzw0MrU=
X-Google-Smtp-Source: AGHT+IHBN36Pg/orEN6OFYlUoNqpVA3U5mAazXVVkHrI1d6ZLqVviiCWx7m5ZCMImMKo9579J6grKaRlJ3IwcPNwsJI=
X-Received: by 2002:a05:6512:759:b0:549:66d8:a1d2 with SMTP id
 2adb3069b0e04-54990e5d95amr6114201e87.19.1741730935701; Tue, 11 Mar 2025
 15:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303143355.3821411-1-lilingfeng3@huawei.com>
In-Reply-To: <20250303143355.3821411-1-lilingfeng3@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 11 Mar 2025 17:08:44 -0500
X-Gm-Features: AQ5f1Jr4YeMPNWsdGVum4R091KBOTK-_19LW5dIIrXh8JU7ygcRAmlTS9O7LEyM
Message-ID: <CAH2r5mtYrSd6c3mwUd3yg0FZPemFmV_MpmDVNdFGF1sAiMQJXw@mail.gmail.com>
Subject: Re: [PATCH] nfs: Fix incorrect read-only status reporting in mountstats
To: Li Lingfeng <lilingfeng3@huawei.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you have a repro scenario example of this for cifs.ko? the
suggested change seems plausible, but wondering about how to recreate
the case you mention where "mounting may generate multiple
superblocks" (are there DFS examples that this would help?)

On Mon, Mar 3, 2025 at 8:18=E2=80=AFAM Li Lingfeng <lilingfeng3@huawei.com>=
 wrote:
>
> In the process of read-only mounting of NFS, only the first generated
> superblock carries the ro flag passed from the user space.
> However, NFS mounting may generate multiple superblocks, and the last
> generated superblock is the one actually used. This leads to a situation
> where the superblock of a read-only NFS file system may not have the ro
> flag. Therefore, using s_flags to determine whether an NFS file system is
> read-only is incorrect.
>
> Use mnt_flags instead of s_flags to decide whether the file system state
> displayed by the /proc/self/mountstats interface is read-only or not.
>
> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
> ---
>  fs/nfs/internal.h      |  2 +-
>  fs/nfs/super.c         | 12 ++++++------
>  fs/proc_namespace.c    |  2 +-
>  fs/smb/client/cifsfs.c |  2 +-
>  include/linux/fs.h     |  2 +-
>  5 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
> index fae2c7ae4acc..14076fc9b1e8 100644
> --- a/fs/nfs/internal.h
> +++ b/fs/nfs/internal.h
> @@ -565,7 +565,7 @@ int  nfs_statfs(struct dentry *, struct kstatfs *);
>  int  nfs_show_options(struct seq_file *, struct dentry *);
>  int  nfs_show_devname(struct seq_file *, struct dentry *);
>  int  nfs_show_path(struct seq_file *, struct dentry *);
> -int  nfs_show_stats(struct seq_file *, struct dentry *);
> +int  nfs_show_stats(struct seq_file *, struct vfsmount *);
>  int  nfs_reconfigure(struct fs_context *);
>
>  /* write.c */
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index aeb715b4a690..62dfba216f7f 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -662,10 +662,10 @@ EXPORT_SYMBOL_GPL(nfs_show_path);
>  /*
>   * Present statistical information for this VFS mountpoint
>   */
> -int nfs_show_stats(struct seq_file *m, struct dentry *root)
> +int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
>  {
>         int i, cpu;
> -       struct nfs_server *nfss =3D NFS_SB(root->d_sb);
> +       struct nfs_server *nfss =3D NFS_SB(mnt->mnt_sb);
>         struct rpc_auth *auth =3D nfss->client->cl_auth;
>         struct nfs_iostats totals =3D { };
>
> @@ -675,10 +675,10 @@ int nfs_show_stats(struct seq_file *m, struct dentr=
y *root)
>          * Display all mount option settings
>          */
>         seq_puts(m, "\n\topts:\t");
> -       seq_puts(m, sb_rdonly(root->d_sb) ? "ro" : "rw");
> -       seq_puts(m, root->d_sb->s_flags & SB_SYNCHRONOUS ? ",sync" : "");
> -       seq_puts(m, root->d_sb->s_flags & SB_NOATIME ? ",noatime" : "");
> -       seq_puts(m, root->d_sb->s_flags & SB_NODIRATIME ? ",nodiratime" :=
 "");
> +       seq_puts(m, (mnt->mnt_flags & MNT_READONLY) ? "ro" : "rw");
> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_SYNCHRONOUS ? ",sync" : "")=
;
> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_NOATIME ? ",noatime" : "");
> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_NODIRATIME ? ",nodiratime" =
: "");
>         nfs_show_mount_options(m, nfss, 1);
>
>         seq_printf(m, "\n\tage:\t%lu", (jiffies - nfss->mount_time) / HZ)=
;
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index e133b507ddf3..1310c655f33f 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -227,7 +227,7 @@ static int show_vfsstat(struct seq_file *m, struct vf=
smount *mnt)
>         /* optional statistics */
>         if (sb->s_op->show_stats) {
>                 seq_putc(m, ' ');
> -               err =3D sb->s_op->show_stats(m, mnt_path.dentry);
> +               err =3D sb->s_op->show_stats(m, mnt);
>         }
>
>         seq_putc(m, '\n');
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 6a3bd652d251..f3bf2c62e195 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -836,7 +836,7 @@ static int cifs_freeze(struct super_block *sb)
>  }
>
>  #ifdef CONFIG_CIFS_STATS2
> -static int cifs_show_stats(struct seq_file *s, struct dentry *root)
> +static int cifs_show_stats(struct seq_file *s, struct vfsmount *mnt)
>  {
>         /* BB FIXME */
>         return 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2788df98080f..94ad8bdb409b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2308,7 +2308,7 @@ struct super_operations {
>         int (*show_options)(struct seq_file *, struct dentry *);
>         int (*show_devname)(struct seq_file *, struct dentry *);
>         int (*show_path)(struct seq_file *, struct dentry *);
> -       int (*show_stats)(struct seq_file *, struct dentry *);
> +       int (*show_stats)(struct seq_file *, struct vfsmount *);
>  #ifdef CONFIG_QUOTA
>         ssize_t (*quota_read)(struct super_block *, int, char *, size_t, =
loff_t);
>         ssize_t (*quota_write)(struct super_block *, int, const char *, s=
ize_t, loff_t);
> --
> 2.31.1
>
>


--=20
Thanks,

Steve
