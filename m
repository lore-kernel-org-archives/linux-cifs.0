Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6343C10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 14:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 690D9206BB
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 14:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbMyisRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfJCOVK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 10:21:10 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34098 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfJCOVJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 10:21:09 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so5983818ion.1
        for <linux-cifs@vger.kernel.org>; Thu, 03 Oct 2019 07:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJdSNFZn8iYUpsh4Y3qgB13Fw8gWi5t2FchnMeSMATs=;
        b=CbMyisRyZcoavhVRE0/7goEH88hTLjtQvaMdjsHsOaTrsGmdTWgPPVGRk0LaRtet9i
         bC7Yyf2PRZDz+N+Hp7H5o96ytcnmzBcRL0U2wCfOCFaUWwJvakNJlgTj4cwZPO14eb79
         xXotkywEo4FfKksepvUZK55Z/DEJtN0Hpz4/3/OfUf4awlMf3F7byp58UrxSQdI8Rlqi
         jJBA+RHc7QP3DAnS6Gy0u0qYKw4rO9VFYoBrZ2sTW+q+N1UgRa4VRjRa5sl1W/Am9dfv
         a1+B9z2cOuVm4tcSSOJJqffr4JU1iCap49HVN4F7L5dEwp9IPDS8mL2yh9bvWRwd/ZyX
         qWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJdSNFZn8iYUpsh4Y3qgB13Fw8gWi5t2FchnMeSMATs=;
        b=iSJ8GZyrJUMekw74GWelWdNswYZ/hdGVuWtl32ErjXXfLVn9Yd1LqaOHM7HGByLSUF
         VTESKcuAwuQpqh6PhK1g03mSPG9+6CUlJhK0scqnZDHGe+t0DJ9SGuZo2rGeHpJ/zOQC
         PeZADwb+dYm9OheUZxmWUCYXzQNzdCxh2WrZOjxrNMUVHDqrbzSG6UYkWQ8516juBoQz
         tSepTTnwDJf98MkHK473znmlVU/mGkvMMqmgIMu2xS1W7+GsApTT0IaloA+u5aRzZA8x
         UzZk9DpmKk1HMAaSWCD56hU9b7EjzPEDzAu8ED3QqZEAArqK0b+E0EBJKMenx4DvoeXR
         G6tA==
X-Gm-Message-State: APjAAAX8I/BgIK8N9ONHZ4LrVTJI7q/SRcAjaxZ+64wBNISNgnxrsK6t
        WVMEYw6afc9MhKt02+Kds3+jufhQtopzARnlVSo=
X-Google-Smtp-Source: APXvYqyOx9BR4Ob3wqIF6ZhmBiX31jlVkjyfNo4kuPDEmF1V0FJaglRK2NKE+T908tsmymnCePeJK+ySnQUtH+lpiZQ=
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr1665983iof.272.1570112468593;
 Thu, 03 Oct 2019 07:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20191003051627.19835-1-lsahlber@redhat.com>
In-Reply-To: <20191003051627.19835-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Oct 2019 09:20:56 -0500
Message-ID: <CAH2r5ms+SkmGhPW7zQ3u1e-0VeJWEiAfCxYfyEJJ+aHT1eq4Tw@mail.gmail.com>
Subject: Re: [PATCH] cifs: use cifsInodeInfo->open_file_lock while iterating
 to avoid a panic
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

opinions on stable?   The patch it refers to was cc:stable 487317c99477

On Thu, Oct 3, 2019 at 12:16 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> From: Dave Wysochanski <dwysocha@redhat.com>
>
> Commit 487317c99477 ("cifs: add spinlock for the openFileList to
> cifsInodeInfo") added cifsInodeInfo->open_file_lock spin_lock to protect
> the openFileList, but missed a few places where cifs_inode->openFileList
> was enumerated.  Change these remaining tcon->open_file_lock to
> cifsInodeInfo->open_file_lock to avoid panic in is_size_safe_to_change.
>
> [17313.245641] RIP: 0010:is_size_safe_to_change+0x57/0xb0 [cifs]
> [17313.245645] Code: 68 40 48 89 ef e8 19 67 b7 f1 48 8b 43 40 48 8d 4b 40 48 8d 50 f0 48 39 c1 75 0f eb 47 48 8b 42 10 48 8d 50 f0 48 39 c1 74 3a <8b> 80 88 00 00 00 83 c0 01 a8 02 74 e6 48 89 ef c6 07 00 0f 1f 40
> [17313.245649] RSP: 0018:ffff94ae1baefa30 EFLAGS: 00010202
> [17313.245654] RAX: dead000000000100 RBX: ffff88dc72243300 RCX: ffff88dc72243340
> [17313.245657] RDX: dead0000000000f0 RSI: 00000000098f7940 RDI: ffff88dd3102f040
> [17313.245659] RBP: ffff88dd3102f040 R08: 0000000000000000 R09: ffff94ae1baefc40
> [17313.245661] R10: ffffcdc8bb1c4e80 R11: ffffcdc8b50adb08 R12: 00000000098f7940
> [17313.245663] R13: ffff88dc72243300 R14: ffff88dbc8f19600 R15: ffff88dc72243428
> [17313.245667] FS:  00007fb145485700(0000) GS:ffff88dd3e000000(0000) knlGS:0000000000000000
> [17313.245670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [17313.245672] CR2: 0000026bb46c6000 CR3: 0000004edb110003 CR4: 00000000007606e0
> [17313.245753] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [17313.245756] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [17313.245759] PKRU: 55555554
> [17313.245761] Call Trace:
> [17313.245803]  cifs_fattr_to_inode+0x16b/0x580 [cifs]
> [17313.245838]  cifs_get_inode_info+0x35c/0xa60 [cifs]
> [17313.245852]  ? kmem_cache_alloc_trace+0x151/0x1d0
> [17313.245885]  cifs_open+0x38f/0x990 [cifs]
> [17313.245921]  ? cifs_revalidate_dentry_attr+0x3e/0x350 [cifs]
> [17313.245953]  ? cifsFileInfo_get+0x30/0x30 [cifs]
> [17313.245960]  ? do_dentry_open+0x132/0x330
> [17313.245963]  do_dentry_open+0x132/0x330
> [17313.245969]  path_openat+0x573/0x14d0
> [17313.245974]  do_filp_open+0x93/0x100
> [17313.245979]  ? __check_object_size+0xa3/0x181
> [17313.245986]  ? audit_alloc_name+0x7e/0xd0
> [17313.245992]  do_sys_open+0x184/0x220
> [17313.245999]  do_syscall_64+0x5b/0x1b0
>
> Fixes: 487317c99477 ("cifs: add spinlock for the openFileList to cifsInodeInfo")
>
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4b95700c507c..3758237bf951 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1840,13 +1840,12 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>  {
>         struct cifsFileInfo *open_file = NULL;
>         struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
> -       struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>
>         /* only filter by fsuid on multiuser mounts */
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
>                 fsuid_only = false;
>
> -       spin_lock(&tcon->open_file_lock);
> +       spin_lock(&cifs_inode->open_file_lock);
>         /* we could simply get the first_list_entry since write-only entries
>            are always at the end of the list but since the first entry might
>            have a close pending, we go through the whole list */
> @@ -1858,7 +1857,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>                                 /* found a good file */
>                                 /* lock it so it will not be closed on us */
>                                 cifsFileInfo_get(open_file);
> -                               spin_unlock(&tcon->open_file_lock);
> +                               spin_unlock(&cifs_inode->open_file_lock);
>                                 return open_file;
>                         } /* else might as well continue, and look for
>                              another, or simply have the caller reopen it
> @@ -1866,7 +1865,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>                 } else /* write only file */
>                         break; /* write only files are last so must be done */
>         }
> -       spin_unlock(&tcon->open_file_lock);
> +       spin_unlock(&cifs_inode->open_file_lock);
>         return NULL;
>  }
>
> @@ -1877,7 +1876,6 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
>  {
>         struct cifsFileInfo *open_file, *inv_file = NULL;
>         struct cifs_sb_info *cifs_sb;
> -       struct cifs_tcon *tcon;
>         bool any_available = false;
>         int rc = -EBADF;
>         unsigned int refind = 0;
> @@ -1897,16 +1895,15 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
>         }
>
>         cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
> -       tcon = cifs_sb_master_tcon(cifs_sb);
>
>         /* only filter by fsuid on multiuser mounts */
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
>                 fsuid_only = false;
>
> -       spin_lock(&tcon->open_file_lock);
> +       spin_lock(&cifs_inode->open_file_lock);
>  refind_writable:
>         if (refind > MAX_REOPEN_ATT) {
> -               spin_unlock(&tcon->open_file_lock);
> +               spin_unlock(&cifs_inode->open_file_lock);
>                 return rc;
>         }
>         list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
> @@ -1918,7 +1915,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
>                         if (!open_file->invalidHandle) {
>                                 /* found a good writable file */
>                                 cifsFileInfo_get(open_file);
> -                               spin_unlock(&tcon->open_file_lock);
> +                               spin_unlock(&cifs_inode->open_file_lock);
>                                 *ret_file = open_file;
>                                 return 0;
>                         } else {
> @@ -1938,7 +1935,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
>                 cifsFileInfo_get(inv_file);
>         }
>
> -       spin_unlock(&tcon->open_file_lock);
> +       spin_unlock(&cifs_inode->open_file_lock);
>
>         if (inv_file) {
>                 rc = cifs_reopen_file(inv_file, false);
> @@ -1953,7 +1950,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
>                 cifsFileInfo_put(inv_file);
>                 ++refind;
>                 inv_file = NULL;
> -               spin_lock(&tcon->open_file_lock);
> +               spin_lock(&cifs_inode->open_file_lock);
>                 goto refind_writable;
>         }
>
> @@ -4461,17 +4458,15 @@ static int cifs_readpage(struct file *file, struct page *page)
>  static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
>  {
>         struct cifsFileInfo *open_file;
> -       struct cifs_tcon *tcon =
> -               cifs_sb_master_tcon(CIFS_SB(cifs_inode->vfs_inode.i_sb));
>
> -       spin_lock(&tcon->open_file_lock);
> +       spin_lock(&cifs_inode->open_file_lock);
>         list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
>                 if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
> -                       spin_unlock(&tcon->open_file_lock);
> +                       spin_unlock(&cifs_inode->open_file_lock);
>                         return 1;
>                 }
>         }
> -       spin_unlock(&tcon->open_file_lock);
> +       spin_unlock(&cifs_inode->open_file_lock);
>         return 0;
>  }
>
> --
> 2.13.6
>


-- 
Thanks,

Steve
