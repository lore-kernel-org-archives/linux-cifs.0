Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EF81D5147
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911828; cv=pass; b=dq0xPzPYoObeQx4njiyjnheiJXzpYIMlO4n4qHSyFQRSB6obBI/n0RJs7nmlbxXLk63FbpCwcquAnm6KQ1aZGSQeNFtim2B2aekVBSwSslMeJibAZSUpF1V0K3LqiFYZKOz3VdcS/jxY4BlMFyWGk+FhPAtEsy0h4os4B4/DAGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911828; c=relaxed/simple;
	bh=fwy8SFjE03b5N5fcFLxuHW9vSUD2EAz3aRbJUkFkztY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WyW2BGgtvOv3n/19PFKMqGTEkrxnr0U7s0wuLzP25VcbetRhkk/T6SR8pByw73f7pyOeDilbq8ckqIuJ759twYcqss0TF0yeZa97+uhwJ9XOjtHxHo4lxYKTUEGKty/ff8DwIG3dERNZ0T+i+hwQqasWzopsvDDYzWDKRIbmreM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDruCzko; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDruCzko"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-896fa834290so28882956d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 07:57:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770911826; cv=none;
        d=google.com; s=arc-20240605;
        b=Y5tlHHyACEh/r+zrZSNoNSGdxm+A+IApgN/JG7LX1xPUDikwC6aQlnu5I24E98B8Si
         234R9qozHUj66R4NCemCbZZ7cULfqL9ClIVGBteQvg19MlBp3/hARoDIpN9aBthojaAl
         1joGR4ji+k+izCamCWVZv2nL7k4mLJOCmmhTyq/Y1v1mHNsr55lGssc9b7wrcTMsGhpf
         EhKwAmaWe4H1SE5cHDNoCwMBo01HD0YHrE0CrBUj2kAdaxarqJWGkFgiqcY8VVOJxp+6
         zJXNweEJn42imzvDE37w002uVb9ssW/7XLm6umSIxRfEfcBDTQ+ILFvffNzpiPL7MgoU
         NVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xmekMrM3MOEBNGfY5x6syHyn13QKfLTdKTGlxJ8gInc=;
        fh=oJhn9M90g1ibqZbWt47z0y93rfGVEACHcjWpNwdJguc=;
        b=FU+UwjD9Z1D0LAyUy7azbqiA7RjwtO86r5M1N4ICyFhhv+cXyHmgOWkCMHdZr1WH/4
         OrkcaOkLoaGvhpnHCk8W+TmC29URcSi99TelVYJ3QvFbNJpVbQGarxO8weXEE+O/jwqr
         1rMbMBKHA2xAvhdxbeAXw3/PHddcnIPZNVfRlxN/m2l+T1y/xOk7FqJp4qsCss0/lDLO
         1eXxxOHPh12bRxfdR6PLR4gdBopf3n7z/8GMFY5hdw0ZKOvXLJhddxorsETStRuGOXbI
         7Y0D8EJ312MOzBa7t5tE9CdqVwUDM3c/cmet2nsERmMG6PHKr1dxv41VLQFhC6Fh5an6
         9E/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770911826; x=1771516626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmekMrM3MOEBNGfY5x6syHyn13QKfLTdKTGlxJ8gInc=;
        b=BDruCzkoVa+wMoEfZ4FazKscVa9Yi6cdDw7LJNBarf6peFQcQKVvDOFrGrsEYsu2d8
         NWBuWf2F04b0YG53AjV9NJXg9AbfmoDC7TPKBaorDix7L7/CWFMgIjrC9wKnSqJ70B5K
         HE44MCNyb9ekqoDZpNxvbyj9inxEkil6KQSlB+A5hEPuNMm2aGpLEWg9QIroLpDR+NJA
         WnhOXUhCbcSPFoqCYa82LWmlfpOLGkH3WNmFIcqVmZRr3hWokOCUjZhqrgA4XChZb1mX
         pBneEmb45g+piKRyWyijJkzofwP+coVz+PBG4laJiujH2xFsrk85aBFX2aTVlfqsLpje
         J30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911826; x=1771516626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xmekMrM3MOEBNGfY5x6syHyn13QKfLTdKTGlxJ8gInc=;
        b=Z6oDZhbQcFZzApp52Vpwk754VGfPGVvtHmk4NqnFtkwu2vR0NgYO3VR+27ttUvDLGm
         Dbdih7VndlkNrxwAIgxhBo7hfNKFlt67MZdIrLgsTYMwOC2dsqCvyYxZL4QavgWeP/Zj
         ubvRwAMqULgCMj/adJgQUw9hmooQpve44P5lFan5iSRB4b0q57cEXMnrC9YbgI5Ff2va
         iKkXpmeSKBCOdlpU+yhFaYlSH6eyKTRcjS+NmhswzcMCy2WSC8t0PrUIiPMkXchdt5NO
         A5GimmBeedhZwhuGLAEbIs5bhkkM6t4lSdmf7s/Ww4riqeR1nfQ/okmDwYwuD+oFrGD0
         u3GQ==
X-Gm-Message-State: AOJu0YxEMC7EMCisrcx7a4c1mA7ZEaoXzUPX1+vA1EZKNh1w8kVGDwRB
	1zniDonB+uTWRS6SNnzZLVCqDPBFL/RVA6Iz7A+NohkF1l+5awwkrMgEDIlsaCQTp0qNcFsmrTT
	68If85HQvhaNyVLP9qLyDMBF+0z0R+0o=
X-Gm-Gg: AZuq6aInQKbt51BnLQWEfzP2fZ9yg4U1eW8y0AujztaF1kAcxS2rOQlT15eRW3TIjeb
	HJ+yBwP861dDqdIop0P8unBUZ+FG+VmxevlemIr4hlZTpZvMojQ0adHj101OEnf/tHOL48kON+3
	5/n0pRTHq9UFldgIRo2y30h42NTNDB+t1iFN9xh+i/RGYSc5yUhZDka14QQgVW6IcpUweAnY81y
	XaPprhglKlntLNXRCluag+0/2J8S5vepOwUJFyEgJMCe/QuB11YqxseCIPJVD2wXb/8QWZ+rCxB
	rXLZuiFYa2XzVJ0VRJyVox+D8C5KgTkCmdtObQuIlkleFzQ6fLquHX/M8lh2db02dY+j2aPYAq5
	BG2Xj/mp1deqyfpE/LdY6z31JMdLlLL4xtMarmAbFeRjC0w4Ds+DBxciSzyGKGCE=
X-Received: by 2002:a05:6214:5281:b0:894:7716:48dd with SMTP id
 6a1803df08f44-89728ed6601mr41942896d6.29.1770911826185; Thu, 12 Feb 2026
 07:57:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131184656.972897-1-sprasad@microsoft.com>
In-Reply-To: <20260131184656.972897-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 09:56:53 -0600
X-Gm-Features: AZwV_QjWbdUzKD348xNqF25IMofynJGpPOyAM5-WU-EmBnFs5kbTP2oOv8dk_Ik
Message-ID: <CAH2r5mtS84r=_s0tJEWNhaFY3tg+sCSS9GwtVE_pCgQF_wnz7A@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch will need to be rebased for 7.0-rc, it doesn't apply

Also let me know if any additional review/test feedback on it

On Sat, Jan 31, 2026 at 12:47=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today whenever we deal with a file, in addition to holding
> a reference on the dentry, we also get a reference on the
> superblock. This happens in two cases:
> 1. when a new cinode is allocated
> 2. when an oplock break is being processed
>
> This code change allows these code paths to use a ref on the
> dentry (and hence the inode). That way, umount is
> ensured to clean up SMB client resources when it's the last
> ref on the superblock (For ex: when same objects are shared).
>
> The code change also moves the call to close all the files in
> deferred close list to the umount code path.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c    |  4 ++--
>  fs/smb/client/cifsproto.h |  2 ++
>  fs/smb/client/connect.c   |  2 ++
>  fs/smb/client/file.c      | 11 -----------
>  fs/smb/client/misc.c      | 36 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 42 insertions(+), 13 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index a3dc7cb1ab541..277dabd982cbd 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -331,10 +331,11 @@ static void cifs_kill_sb(struct super_block *sb)
>
>         /*
>          * We need to release all dentries for the cached directories
> -        * before we kill the sb.
> +        * and close all deferred file handles before we kill the sb.
>          */
>         if (cifs_sb->root) {
>                 close_all_cached_dirs(cifs_sb);
> +               cifs_close_all_deferred_files_sb(cifs_sb);
>
>                 /* finally release root dentry */
>                 dput(cifs_sb->root);
> @@ -865,7 +866,6 @@ static void cifs_umount_begin(struct super_block *sb)
>         spin_unlock(&tcon->tc_lock);
>         spin_unlock(&cifs_tcp_ses_lock);
>
> -       cifs_close_all_deferred_files(tcon);
>         /* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiti=
ng */
>         /* cancel_notify_requests(tcon); */
>         if (tcon->ses && tcon->ses->server) {
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index f8c0615d4ee42..5feaeac16b0c5 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -302,6 +302,8 @@ extern void cifs_close_deferred_file(struct cifsInode=
Info *cifs_inode);
>
>  extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
>
> +extern void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_s=
b);
> +
>  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
>                                            struct dentry *dentry);
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ce620503e9f70..31745ef692390 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4149,6 +4149,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
>         if (cifs_sb->master_tlink) {
>                 tcon =3D cifs_sb->master_tlink->tl_tcon;
>                 if (tcon) {
> +                       cifs_close_all_deferred_files(tcon);
>                         spin_lock(&tcon->sb_list_lock);
>                         list_del_init(&cifs_sb->tcon_sb_link);
>                         spin_unlock(&tcon->sb_list_lock);
> @@ -4163,6 +4164,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
>                 rb_erase(node, root);
>
>                 spin_unlock(&cifs_sb->tlink_tree_lock);
> +               cifs_close_all_deferred_files(tlink->tl_tcon);
>                 cifs_put_tlink(tlink);
>                 spin_lock(&cifs_sb->tlink_tree_lock);
>         }
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 7ff5cc9c5c5b7..0b80b11a9864d 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -712,8 +712,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fi=
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
> @@ -768,7 +766,6 @@ static void cifsFileInfo_put_final(struct cifsFileInf=
o *cifs_file)
>         struct inode *inode =3D d_inode(cifs_file->dentry);
>         struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
>         struct cifsLockInfo *li, *tmp;
> -       struct super_block *sb =3D inode->i_sb;
>
>         /*
>          * Delete any outstanding lock records. We'll lose them when the =
file
> @@ -786,7 +783,6 @@ static void cifsFileInfo_put_final(struct cifsFileInf=
o *cifs_file)
>
>         cifs_put_tlink(cifs_file->tlink);
>         dput(cifs_file->dentry);
> -       cifs_sb_deactive(sb);
>         kfree(cifs_file->symlink_target);
>         kfree(cifs_file);
>  }
> @@ -3163,12 +3159,6 @@ void cifs_oplock_break(struct work_struct *work)
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
> @@ -3241,7 +3231,6 @@ void cifs_oplock_break(struct work_struct *work)
>         cifs_put_tlink(tlink);
>  out:
>         cifs_done_oplock_break(cinode);
> -       cifs_sb_deactive(sb);
>  }
>
>  static int cifs_swap_activate(struct swap_info_struct *sis,
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 9529fa385938e..dfeb1faff8568 100644
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
> @@ -171,6 +176,7 @@ tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_r=
ef_trace trace)
>         }
>         trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
>         free_cached_dirs(tcon->cfids);
> +
>         atomic_dec(&tconInfoAllocCount);
>         kfree(tcon->nativeFileSystem);
>         kfree_sensitive(tcon->password);
> @@ -840,6 +846,36 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon=
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
> +               tmp_list =3D kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
> +               if (tmp_list =3D=3D NULL)
> +                       break;
> +               tmp_list->tcon =3D tcon;
> +               list_add_tail(&tmp_list->entry, &tcon_head);
> +       }
> +       spin_unlock(&cifs_sb->tlink_tree_lock);
> +
> +       list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
> +               cifs_close_all_deferred_files(tmp_list->tcon);
> +               list_del(&tmp_list->entry);
> +               kfree(tmp_list);
> +       }
> +}
> +
>  void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
>                                            struct dentry *dentry)
>  {
> --
> 2.43.0
>


--=20
Thanks,

Steve
