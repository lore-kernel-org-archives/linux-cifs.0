Return-Path: <SRS0=K6R1=ZX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B281C432C0
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Dec 2019 05:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41AA82082E
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Dec 2019 05:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiwlJHEg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfLAF14 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 1 Dec 2019 00:27:56 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32999 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfLAF14 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 1 Dec 2019 00:27:56 -0500
Received: by mail-io1-f66.google.com with SMTP id j13so36669053ioe.0
        for <linux-cifs@vger.kernel.org>; Sat, 30 Nov 2019 21:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3O7HMbr1UX3ziAnKga4C+V97oRtYF/zaCgug2f1Hdg4=;
        b=WiwlJHEgRSGGDI8lVaVP/o1Wl21CdrixnpJIX7rGED2psbvcXpSTH74S/80NPyCkog
         4KpZ0Z2Rio6osw2EmHo83AYnUO/cGbx52Zp0ZUMw16rhcnuEDr21gu9AQalvsb2VO+gs
         cEscLDXvx3h9EPd+zAnXq3Aw4kKJWRYetTcWFAWfPCbNvIOFUF8MKyMcFqFKnMkHbqjm
         U9SDYsVdxloxb9KVFiPFZmxTMvbZ8WA87nPR0rd1tfZ77ES9M7LG3UuI8e2/evLEP904
         6ynpcv25T7m+g5su+hoJtMzRjFgx72kXXD82Atden+ZQtocayG23v37AWY+gqfgVuiQZ
         7SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3O7HMbr1UX3ziAnKga4C+V97oRtYF/zaCgug2f1Hdg4=;
        b=hqW8fO7vM85rjLcya0AICU2cNT1hesVLi2ZlfnSfiZQTHYG+gvd2kOrUne04r3FyQ1
         3EAk7988Ae1NYIM1WoEBSPuR4p/yN/zrrz1BDH7zNU6hE8i6ZYuqFzKYBkdqmxa+2HJV
         Ye2JHiXEYR0xQyNl41tQK/Q2kJLLBg+aS00E7JT0iKI9Fu79ZCh3hR63D+oh923EZewA
         tp0ERv3NyNL11E3dbdoNf8Ux5qRSIdih6UXjQF4VkxGsiSVoX/nQQxIXLXprbKSNGFrx
         Tdn7D3zYopGQpAJtiZukfo83MssLdOiZYwIMyJgr+r4/XJPRBHUhcmVsc9CdtnmpfzGb
         wzcw==
X-Gm-Message-State: APjAAAXFKP4X343xV3d7enZ+uyj+uR3PRU9eIM/64Hy51rxgnJ8JxC6k
        ipdOvn8yAS+Kl3RPI6mXhEShgaRipTJjOouiL5T3Nw==
X-Google-Smtp-Source: APXvYqwpDAyirrt2P349+8YMmbC12a2rbRIUEf+/Koi2bQe0XEI6th2lcQzE3LYSVG0IJKO5Kj/sMmKwHk8T8FWHGIs=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr48279984iom.5.1575178075697;
 Sat, 30 Nov 2019 21:27:55 -0800 (PST)
MIME-Version: 1.0
References: <20191128001839.5926-1-pshilov@microsoft.com>
In-Reply-To: <20191128001839.5926-1-pshilov@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 Nov 2019 23:27:44 -0600
Message-ID: <CAH2r5muERm5rgs5tW3TA0zv89qbwqMRtmCSMLEtBP0dAa2YNww@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

On Wed, Nov 27, 2019 at 6:18 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Currently when the client creates a cifsFileInfo structure for
> a newly opened file, it allocates a list of byte-range locks
> with a pointer to the new cfile and attaches this list to the
> inode's lock list. The latter happens before initializing all
> other fields, e.g. cfile->tlink. Thus a partially initialized
> cifsFileInfo structure becomes available to other threads that
> walk through the inode's lock list. One example of such a thread
> may be an oplock break worker thread that tries to push all
> cached byte-range locks. This causes NULL-pointer dereference
> in smb2_push_mandatory_locks() when accessing cfile->tlink:
>
> [598428.945633] BUG: kernel NULL pointer dereference, address: 0000000000000038
> ...
> [598428.945749] Workqueue: cifsoplockd cifs_oplock_break [cifs]
> [598428.945793] RIP: 0010:smb2_push_mandatory_locks+0xd6/0x5a0 [cifs]
> ...
> [598428.945834] Call Trace:
> [598428.945870]  ? cifs_revalidate_mapping+0x45/0x90 [cifs]
> [598428.945901]  cifs_oplock_break+0x13d/0x450 [cifs]
> [598428.945909]  process_one_work+0x1db/0x380
> [598428.945914]  worker_thread+0x4d/0x400
> [598428.945921]  kthread+0x104/0x140
> [598428.945925]  ? process_one_work+0x380/0x380
> [598428.945931]  ? kthread_park+0x80/0x80
> [598428.945937]  ret_from_fork+0x35/0x40
>
> Fix this by reordering initialization steps of the cifsFileInfo
> structure: initialize all the fields first and then add the new
> byte-range lock list to the inode's lock list.
>
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/file.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 520fbe4d42b9..069635ec9d94 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -313,9 +313,6 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>         INIT_LIST_HEAD(&fdlocks->locks);
>         fdlocks->cfile = cfile;
>         cfile->llist = fdlocks;
> -       cifs_down_write(&cinode->lock_sem);
> -       list_add(&fdlocks->llist, &cinode->llist);
> -       up_write(&cinode->lock_sem);
>
>         cfile->count = 1;
>         cfile->pid = current->tgid;
> @@ -339,6 +336,10 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>                 oplock = 0;
>         }
>
> +       cifs_down_write(&cinode->lock_sem);
> +       list_add(&fdlocks->llist, &cinode->llist);
> +       up_write(&cinode->lock_sem);
> +
>         spin_lock(&tcon->open_file_lock);
>         if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
>                 oplock = fid->pending_open->oplock;
> --
> 2.17.1
>


-- 
Thanks,

Steve
