Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC32727E0
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 03:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772075971; cv=pass; b=daZe1724C+ua0Fb6fq1/momWcqwt53/XS69dKxQT+N0NUtjW+LD5KpNqhhNSfk5V2pvmB8kivp3piNp81FeeOtDOLs9fqf/462sqEhNPfQIQm2Njt9PIdkw03WzRI7GWN4YfFQyMbEfMi51ArCV90QPbPv8RBOMLzGSJ6538P/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772075971; c=relaxed/simple;
	bh=su1nnnQdoOX/97MzGBrjJr0Jtfg3nf6kY2uELFKZZoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fB2M8SOaEOVEqvApXPD/mKuDnd2KWmWEG18ku9KSfR0d+anrhtqELH/v+raLkyexCCWYWrEJqhFqaJIbLxgsZNukkeTfb8HFZa+d5pkE+bEeY0OdpzZP2YfEjMraIJOibv4KRvrccc+FLcOZYrQtN/GorjK8JpDkbPpf/ySzxI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PAusLyQ/; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PAusLyQ/"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65a43a512b0so538368a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 19:19:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772075968; cv=none;
        d=google.com; s=arc-20240605;
        b=La9dkVkg6b17sMwqgbBs0kvmMbg3nXaJqWRjx5omtB8XU0T1X2l2Quv22CQL9IMXPA
         9IgStVLUG7FoKuybVUZmjAv0F7YHSeBstb9cyoXiSXcW6nqB3xf6bsd7OPY0XH6c0Ky1
         Hr5yMzBn5WQqD6esAfT8guY992P1TckoboYjZQdwnpcQMBY3/P+SLeFcDGt5s2tJLQNI
         HeKdG4dN48DFg9Bi77cthI7c2Gb6vmvHyRCvkeNJizoceejngnkJkurVtQ9ykmyXAbXQ
         97b1RjDpgHDnc52GkyJqL9oQJJg1tPVqKNtBofBWkwMp4YQtHPgJ7E6q+znbrHGKcoKz
         dICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Zj+k0KRHT2sWsWDhCKA86IWndAUECaDFI9dkvdUkJk=;
        fh=ogAls8d3J45aSr3H5zrEPwHIV6qqfhnoD8TEGF2pbJE=;
        b=Gve60hptPEYITlh3aPm4SlcAAsA/IPge2QJ2cq9cc6Vzd4P3+jGWzQOR5/3uFrz9jB
         0ugpdqP2L1kXZOj2qMIP/Vua8W/jVu/kttCRU0wcl7et+ZmqNEx2FXCbD+GZajgfcfgu
         NJAqk3VebZkaU3/gxD4dKuw6f5pP+WdDrL3sIOr+/hkl4O7NNG0jylC6A1dcNjce4PIl
         bYCCmNNOklrylkn0wplJs6lyhGISU4/sbQFwzpLCgAR9LvlWBIFAcbp8ownI5CFi6dhk
         Vmu5R4qClRd5bhINCv1Jeh1blULmsMIYPD6OUYj+nC7JfN81gNYx55VxCk1oZjCcdk+J
         +glQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772075968; x=1772680768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Zj+k0KRHT2sWsWDhCKA86IWndAUECaDFI9dkvdUkJk=;
        b=PAusLyQ/nypEHG5pbDQK7RFd8hSqgNksRxItM22kGWimL2z7SX6TNJurzGe+GsX4sP
         /lAU2cZK9ElBFgqlLZiu1MW8vw7MzzK4tFfsevb3tRMc0uFuc8BJ3SitCnezxFLC33M1
         NDM/n/a0B3WCSbBZx1Y/xrRu/NDwrXsaDzAy2aZdtvQNr07E1xmENYxEqjyTFMedgwZw
         av5Ei73wKW+gypXDIcW9w2k7cZL0793v8tQWXCkBJyAgcDmg+eBlLbRhvMklXf4dEjCC
         AZ6saS0GXzqOb2cdg7hVyp/gbnXQDY1SnAVp80tB8heuZMFILdIp3rHiQSR1+i5Gxruv
         VLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772075968; x=1772680768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Zj+k0KRHT2sWsWDhCKA86IWndAUECaDFI9dkvdUkJk=;
        b=aYAIvaTVRfEl0CzvYxX5QsLNuPwjT70jyVjIW3laMrryBIfdY+j4EiZgB6LAokI0VU
         oozYZlEOEhjChJ36jGFByrYCPyhX0tQrWgF1Kloyz81bdD7Eg2qFHSgh6Zq8Aga9TM8A
         RDtKG48SzhXtKu05KRraFMmHWY7VC4p7+79tLzQqRv8plGqK666ciDbWo8BuP0kQ2srG
         tmC4D1e/MOyxd8+f15yYp+nWXaD4TOnUtBtXuOGfKJUH7eUC2tPVBKgT1RjwoXL3+l31
         zknksWZvtRp4UGKSl56avnNhWam56VCrReOAD2Rm2EVSLp85cnkFKzpBDy/igzZFt7Os
         CIJg==
X-Gm-Message-State: AOJu0YxgjNQSHO7DIP/sXrH/p6DIrFufzX2q//K8tlbt+mFs+/9hRR33
	qHTUYFhuFXqsKlLTZprYW7IPabLZ05M5X2PpFshNDXJOOBK9Vo7pnsSJ9imWKkf6LxUOUNKSXrw
	vqvqyJ7iT80sdjNNgmyU+GPlzGy+mhlg=
X-Gm-Gg: ATEYQzxmKBdGM2R2zjA0E5zHdHmquknPf4Jj76pyw9KwJUeLDT6goxmj3+DaxS95jGA
	ZbHO3/6pEMrEt30pb9HzwzkbvnITkTlKhtdc6YKqTK4Rxu3loloM+rGfUPcbyxlcBpibFN2W4bG
	Q/BIw+mO4rFY7ipTW6rY48pJ/0brYb15ambvAI4WoRBEey2XjWnIrC3TlLG/ZPcaw+50GGx2wDe
	408JlOTe5XsK4cyhVTOy/ovx7iO30TRxPR3Mlte90tDkK1Lspc+hb8fxxuExXvbt+YKFW2cDeLs
	OaiOGMSFGvh8Mbjk
X-Received: by 2002:a05:6402:27d2:b0:658:e811:b983 with SMTP id
 4fb4d7f45d1cf-65fb6a510cdmr273239a12.12.1772075968018; Wed, 25 Feb 2026
 19:19:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131184656.972897-1-sprasad@microsoft.com> <CAH2r5mtS84r=_s0tJEWNhaFY3tg+sCSS9GwtVE_pCgQF_wnz7A@mail.gmail.com>
In-Reply-To: <CAH2r5mtS84r=_s0tJEWNhaFY3tg+sCSS9GwtVE_pCgQF_wnz7A@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 26 Feb 2026 08:49:12 +0530
X-Gm-Features: AaiRm506D3JIADiIw4X3tdHmcwPmASKbsUSv51_EPLUpEytkmwAf2Pc5pA7l2F4
Message-ID: <CANT5p=ry-u8Tk9XQ4g7XvTvSPMHYQPQ9TQU61+8Q6HuC4h2FAw@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2026 at 9:27=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> This patch will need to be rebased for 7.0-rc, it doesn't apply
>
> Also let me know if any additional review/test feedback on it
>
> On Sat, Jan 31, 2026 at 12:47=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today whenever we deal with a file, in addition to holding
> > a reference on the dentry, we also get a reference on the
> > superblock. This happens in two cases:
> > 1. when a new cinode is allocated
> > 2. when an oplock break is being processed
> >
> > This code change allows these code paths to use a ref on the
> > dentry (and hence the inode). That way, umount is
> > ensured to clean up SMB client resources when it's the last
> > ref on the superblock (For ex: when same objects are shared).
> >
> > The code change also moves the call to close all the files in
> > deferred close list to the umount code path.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsfs.c    |  4 ++--
> >  fs/smb/client/cifsproto.h |  2 ++
> >  fs/smb/client/connect.c   |  2 ++
> >  fs/smb/client/file.c      | 11 -----------
> >  fs/smb/client/misc.c      | 36 ++++++++++++++++++++++++++++++++++++
> >  5 files changed, 42 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index a3dc7cb1ab541..277dabd982cbd 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -331,10 +331,11 @@ static void cifs_kill_sb(struct super_block *sb)
> >
> >         /*
> >          * We need to release all dentries for the cached directories
> > -        * before we kill the sb.
> > +        * and close all deferred file handles before we kill the sb.
> >          */
> >         if (cifs_sb->root) {
> >                 close_all_cached_dirs(cifs_sb);
> > +               cifs_close_all_deferred_files_sb(cifs_sb);
> >
> >                 /* finally release root dentry */
> >                 dput(cifs_sb->root);
> > @@ -865,7 +866,6 @@ static void cifs_umount_begin(struct super_block *s=
b)
> >         spin_unlock(&tcon->tc_lock);
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> > -       cifs_close_all_deferred_files(tcon);
> >         /* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exi=
ting */
> >         /* cancel_notify_requests(tcon); */
> >         if (tcon->ses && tcon->ses->server) {
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index f8c0615d4ee42..5feaeac16b0c5 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -302,6 +302,8 @@ extern void cifs_close_deferred_file(struct cifsIno=
deInfo *cifs_inode);
> >
> >  extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon)=
;
> >
> > +extern void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs=
_sb);
> > +
> >  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon=
,
> >                                            struct dentry *dentry);
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index ce620503e9f70..31745ef692390 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -4149,6 +4149,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
> >         if (cifs_sb->master_tlink) {
> >                 tcon =3D cifs_sb->master_tlink->tl_tcon;
> >                 if (tcon) {
> > +                       cifs_close_all_deferred_files(tcon);
> >                         spin_lock(&tcon->sb_list_lock);
> >                         list_del_init(&cifs_sb->tcon_sb_link);
> >                         spin_unlock(&tcon->sb_list_lock);
> > @@ -4163,6 +4164,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
> >                 rb_erase(node, root);
> >
> >                 spin_unlock(&cifs_sb->tlink_tree_lock);
> > +               cifs_close_all_deferred_files(tlink->tl_tcon);
> >                 cifs_put_tlink(tlink);
> >                 spin_lock(&cifs_sb->tlink_tree_lock);
> >         }
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index 7ff5cc9c5c5b7..0b80b11a9864d 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -712,8 +712,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_=
fid *fid, struct file *file,
> >         mutex_init(&cfile->fh_mutex);
> >         spin_lock_init(&cfile->file_info_lock);
> >
> > -       cifs_sb_active(inode->i_sb);
> > -
> >         /*
> >          * If the server returned a read oplock and we have mandatory b=
rlocks,
> >          * set oplock level to None.
> > @@ -768,7 +766,6 @@ static void cifsFileInfo_put_final(struct cifsFileI=
nfo *cifs_file)
> >         struct inode *inode =3D d_inode(cifs_file->dentry);
> >         struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> >         struct cifsLockInfo *li, *tmp;
> > -       struct super_block *sb =3D inode->i_sb;
> >
> >         /*
> >          * Delete any outstanding lock records. We'll lose them when th=
e file
> > @@ -786,7 +783,6 @@ static void cifsFileInfo_put_final(struct cifsFileI=
nfo *cifs_file)
> >
> >         cifs_put_tlink(cifs_file->tlink);
> >         dput(cifs_file->dentry);
> > -       cifs_sb_deactive(sb);
> >         kfree(cifs_file->symlink_target);
> >         kfree(cifs_file);
> >  }
> > @@ -3163,12 +3159,6 @@ void cifs_oplock_break(struct work_struct *work)
> >         __u64 persistent_fid, volatile_fid;
> >         __u16 net_fid;
> >
> > -       /*
> > -        * Hold a reference to the superblock to prevent it and its ino=
des from
> > -        * being freed while we are accessing cinode. Otherwise, _cifsF=
ileInfo_put()
> > -        * may release the last reference to the sb and trigger inode e=
viction.
> > -        */
> > -       cifs_sb_active(sb);
> >         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
> >                         TASK_UNINTERRUPTIBLE);
> >
> > @@ -3241,7 +3231,6 @@ void cifs_oplock_break(struct work_struct *work)
> >         cifs_put_tlink(tlink);
> >  out:
> >         cifs_done_oplock_break(cinode);
> > -       cifs_sb_deactive(sb);
> >  }
> >
> >  static int cifs_swap_activate(struct swap_info_struct *sis,
> > diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> > index 9529fa385938e..dfeb1faff8568 100644
> > --- a/fs/smb/client/misc.c
> > +++ b/fs/smb/client/misc.c
> > @@ -28,6 +28,11 @@
> >  #include "fs_context.h"
> >  #include "cached_dir.h"
> >
> > +struct tcon_list {
> > +       struct list_head entry;
> > +       struct cifs_tcon *tcon;
> > +};
> > +
> >  /* The xid serves as a useful identifier for each incoming vfs request=
,
> >     in a similar way to the mid which is useful to track each sent smb,
> >     and CurrentXid can also provide a running counter (although it
> > @@ -171,6 +176,7 @@ tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon=
_ref_trace trace)
> >         }
> >         trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
> >         free_cached_dirs(tcon->cfids);
> > +
> >         atomic_dec(&tconInfoAllocCount);
> >         kfree(tcon->nativeFileSystem);
> >         kfree_sensitive(tcon->password);
> > @@ -840,6 +846,36 @@ cifs_close_all_deferred_files(struct cifs_tcon *tc=
on)
> >         }
> >  }
> >
> > +void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb)
> > +{
> > +       struct rb_root *root =3D &cifs_sb->tlink_tree;
> > +       struct rb_node *node;
> > +       struct cifs_tcon *tcon;
> > +       struct tcon_link *tlink;
> > +       struct tcon_list *tmp_list, *q;
> > +       LIST_HEAD(tcon_head);
> > +
> > +       spin_lock(&cifs_sb->tlink_tree_lock);
> > +       for (node =3D rb_first(root); node; node =3D rb_next(node)) {
> > +               tlink =3D rb_entry(node, struct tcon_link, tl_rbnode);
> > +               tcon =3D tlink_tcon(tlink);
> > +               if (IS_ERR(tcon))
> > +                       continue;
> > +               tmp_list =3D kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
> > +               if (tmp_list =3D=3D NULL)
> > +                       break;
> > +               tmp_list->tcon =3D tcon;
> > +               list_add_tail(&tmp_list->entry, &tcon_head);
> > +       }
> > +       spin_unlock(&cifs_sb->tlink_tree_lock);
> > +
> > +       list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
> > +               cifs_close_all_deferred_files(tmp_list->tcon);
> > +               list_del(&tmp_list->entry);
> > +               kfree(tmp_list);
> > +       }
> > +}
> > +
> >  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
> >                                            struct dentry *dentry)
> >  {
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve

Please hold off on this. May need more work.

--=20
Regards,
Shyam
