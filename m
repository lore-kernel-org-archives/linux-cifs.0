Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CDA1D12EE
	for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 07:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297321; cv=none; b=X3sDCDwNhqbyrGSp8hYTdA3GEK4w0Kvnpmz+2jCmCJBDT2dfIJhuW95qbakDxpqSKhHY/3NnkQuR/BlFPxEcomfM0RH/XNS5sGUNQ/QCdERMd0+XLLPU9FxR6pu7eC8exUKjKgKh6K7DHbrSAuwrYG+536+e25TFZzWBF90EF44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297321; c=relaxed/simple;
	bh=a4uDUCoNUAvrJ9dXUDnfJS3nTf1DTUlBsIzxbup3qlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1rG+XipD/sdoXe7W0cR22MNfVdb5HPlG8rVK7WaJDo6Od+F1BoBDR8DqAfKGfwp/c/QXryztZ9O5GJotYM5lxyoy4jH80r6XPJoJ+qxLlKRaT8Ox+6FMRxJXosNiuF4zxQM5X3+Wmz9KR2216wd2/X/eXat1Kn6/snWNaO7yZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+wRfB+B; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+wRfB+B"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c4226a5af8so1595799a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 00:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726297317; x=1726902117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6l7g0LdQah9o3EhzHA23MPWVKxJxaJ6FUilB71sXpwc=;
        b=I+wRfB+Bja8XHXjdZ2O4wm+hC1T/PocjS8a0leOCFejAw2LD63CdFkHTOp/c3lghhd
         ec4hSo99chaJFMOpD3TzdWisMkjEEu7VO09/SLLn7tfv1kOLJa7s+nU+l/wsGTcVMWxp
         lxrHIrbT0fohTz2tmm9dDFUQpv73eWaoDM2SHRHTLBt1JYYX4NBW67ZQGeja7v97OTPS
         SmcrCdYDuQNcD0Hw3T8/XXhhWTVG0ntAM7Gyw8nCfKaKN0A1ksiwSO/KcnHRGbmYVeWC
         xvhtw6/mJkVUSAL9rW5q9Cq2blYvCUtXTc3oeeoPKn6tG/HRDN3LpvMaKLqYsgBkzczj
         XM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726297317; x=1726902117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6l7g0LdQah9o3EhzHA23MPWVKxJxaJ6FUilB71sXpwc=;
        b=H36Rv3GF1S5Zh4Z9NYpY2kuEGs5x5XIBE2GC/BZqHVFCOH7+h6dRa+0M89bSnQ/s8k
         JkESD3r//OY9EHNeV0OzyWVk8OiWbvlKlSnlUeQT9GkP85cuzkN1xJCGlYmxfJ9J6f/L
         LIj2M5VjUg+PjJO8aDeZ3+Bi9F5GNwHy+ZPqKjVbBanHYPeOTX6X00SHHkA5sgIKbZ5y
         WiNT/zZGGeDEMngq9xmTyWn7lUc3qUt5vQgAD3YCMrE4JGYd+MNAjQxyD+wl8kL1jWPV
         dcApJpY7TAqYSOR5hw9fWrXEPt2D8MJL2nKfuOnbCKj7evpcoNw/XyB9vOG9qzCtV/kF
         a9Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWHTyGagCBw613B/hG8ld2AOYyKZwndVDBBq34d4xu/8MQX0Sv4XtY77/6oWi4j4bS3bHCg7AQlZZuk@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9mCvZfva3AHIolZZoeago9q0sGUWO4Rmh8PwuvK+bKhnZ6G0Q
	vb3xzDAh6fU3TvG0q7MNCTglAZotS8L3rcUEdd0/beJnwhW6d13y3eWRJHDXtAp3KeegjFwVRfN
	CewF47p/mzjrhBxkGgWx00PmRAlM=
X-Google-Smtp-Source: AGHT+IEE2saBGygWxDJ3U4apTV+do/bn/X9SwwTbX/oYmeNrknyvfLHSqrYm9iRxqVd9NnVm1UQZGIyATM9OYsfmC5Q=
X-Received: by 2002:aa7:c483:0:b0:5c2:4bd1:30c3 with SMTP id
 4fb4d7f45d1cf-5c413e4d024mr6471304a12.27.1726297317207; Sat, 14 Sep 2024
 00:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821065637.2294496-1-lihongbo22@huawei.com>
In-Reply-To: <20240821065637.2294496-1-lihongbo22@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Sep 2024 02:01:45 -0500
Message-ID: <CAH2r5mur8ahks54Mn6bHYQL9JkfphkioVF9AZwM7aUKgU6zu2A@mail.gmail.com>
Subject: Re: [PATCH -next] smb: use LIST_HEAD() to simplify code
To: Hongbo Li <lihongbo22@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending review/testing

On Wed, Aug 21, 2024 at 1:49=E2=80=AFAM Hongbo Li <lihongbo22@huawei.com> w=
rote:
>
> list_head can be initialized automatically with LIST_HEAD()
> instead of calling INIT_LIST_HEAD(). No functional impact.
>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/smb/client/connect.c  | 3 +--
>  fs/smb/client/file.c     | 7 ++-----
>  fs/smb/client/misc.c     | 9 +++------
>  fs/smb/client/smb2file.c | 4 +---
>  4 files changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index d2307162a2de..72092b53e889 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -997,11 +997,10 @@ clean_demultiplex_info(struct TCP_Server_Info *serv=
er)
>         }
>
>         if (!list_empty(&server->pending_mid_q)) {
> -               struct list_head dispose_list;
>                 struct mid_q_entry *mid_entry;
>                 struct list_head *tmp, *tmp2;
> +               LIST_HEAD(dispose_list);
>
> -               INIT_LIST_HEAD(&dispose_list);
>                 spin_lock(&server->mid_lock);
>                 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                         mid_entry =3D list_entry(tmp, struct mid_q_entry,=
 qhead);
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 1fc66bcf49eb..a5e6c7b63230 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1406,7 +1406,7 @@ void
>  cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
>  {
>         struct cifsFileInfo *open_file, *tmp;
> -       struct list_head tmp_list;
> +       LIST_HEAD(tmp_list);
>
>         if (!tcon->use_persistent || !tcon->need_reopen_files)
>                 return;
> @@ -1414,7 +1414,6 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tc=
on)
>         tcon->need_reopen_files =3D false;
>
>         cifs_dbg(FYI, "Reopen persistent handles\n");
> -       INIT_LIST_HEAD(&tmp_list);
>
>         /* list all files open on tree connection, reopen resilient handl=
es  */
>         spin_lock(&tcon->open_file_lock);
> @@ -2097,9 +2096,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struc=
t file_lock *flock,
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
>         struct cifsLockInfo *li, *tmp;
>         __u64 length =3D cifs_flock_len(flock);
> -       struct list_head tmp_llist;
> -
> -       INIT_LIST_HEAD(&tmp_llist);
> +       LIST_HEAD(tmp_llist);
>
>         /*
>          * Accessing maxBuf is racy with cifs_reconnect - need to store v=
alue
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index c6f11e6f9eb9..dab526191b07 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -751,12 +751,11 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs=
_inode)
>  {
>         struct cifsFileInfo *cfile =3D NULL;
>         struct file_list *tmp_list, *tmp_next_list;
> -       struct list_head file_head;
> +       LIST_HEAD(file_head);
>
>         if (cifs_inode =3D=3D NULL)
>                 return;
>
> -       INIT_LIST_HEAD(&file_head);
>         spin_lock(&cifs_inode->open_file_lock);
>         list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
> @@ -787,9 +786,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
>  {
>         struct cifsFileInfo *cfile;
>         struct file_list *tmp_list, *tmp_next_list;
> -       struct list_head file_head;
> +       LIST_HEAD(file_head);
>
> -       INIT_LIST_HEAD(&file_head);
>         spin_lock(&tcon->open_file_lock);
>         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
> @@ -819,11 +817,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_t=
con *tcon, const char *path)
>  {
>         struct cifsFileInfo *cfile;
>         struct file_list *tmp_list, *tmp_next_list;
> -       struct list_head file_head;
>         void *page;
>         const char *full_path;
> +       LIST_HEAD(file_head);
>
> -       INIT_LIST_HEAD(&file_head);
>         page =3D alloc_dentry_path();
>         spin_lock(&tcon->open_file_lock);
>         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index c23478ab1cf8..bc2b838eab6f 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -196,9 +196,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct =
file_lock *flock,
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
>         struct cifsLockInfo *li, *tmp;
>         __u64 length =3D 1 + flock->fl_end - flock->fl_start;
> -       struct list_head tmp_llist;
> -
> -       INIT_LIST_HEAD(&tmp_llist);
> +       LIST_HEAD(tmp_llist);
>
>         /*
>          * Accessing maxBuf is racy with cifs_reconnect - need to store v=
alue
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
