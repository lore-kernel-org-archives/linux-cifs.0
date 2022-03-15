Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B4FC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 03:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiCODuo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Mar 2022 23:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238429AbiCODun (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Mar 2022 23:50:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C11488B9
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 20:49:30 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w7so30762589lfd.6
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 20:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tlwze64iAf+fTuJdNCODFyrPE9BARRQB7Jc3sKpEbHM=;
        b=FFL7Fy44mel5dKuljA4CRjGUYpzqbxRM6SuRAAYqwB1u+2dRq57o7MMOVjmrdOEtsO
         Ahf0I/xRnELJxZFa8IRQy+MxW0pBy+EP4XNonlBwLazthoIDqjtCT+QCL7u0kMfD3gx/
         N2wrnCSOVkFyOEpqvpZdDBnQju/KZceyBfJNAkH4fgvcSUg1KWIiWtADlmP4zXW50OIU
         Wk2oGxlJFnlvktt364L59G9QFwgxb1HKX1It0FqWdovfvT5sxxVIadCiuTjAcVAwFyGj
         GtTLfB1VHlQAfsD/Q5mufp00J7xKr0asafxnd9eH8wBN4PZ4rsnApCb+qKXlrcOB3S3x
         rFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tlwze64iAf+fTuJdNCODFyrPE9BARRQB7Jc3sKpEbHM=;
        b=g0lcib85qwMTddox2hEbifqmlLfsrfAzN0gNe5UlVcP0urB0P5LE+QmfgBDbFkQRDb
         LdhSVNeXwqzFGeXJLLLfJVsKHvHHjSJmjUnv3V/RzX1VDIQAGOaP+YkXSQwNgCy+sYDT
         aR0cWm9zXeU4Vi9ziPfbvfUrGZVqGqOk1IlCL2YEL37elbNpYcEI77m2in4MAbLMauJk
         am7DtrD8YRgWSG2DWz3b95ZOWK5AtKW06GU2ILhKPWIgoJMGaisd7j3LiW3b5rW7jmq0
         1RW74TQ6znUvwoBRiJB6gV1PgMciICfb2CsOVpQiHlI36rPIAuecAFWyCRso95l+zETC
         zgPg==
X-Gm-Message-State: AOAM5305eY28GrJTJOZhkoUC3p7lzGu6rmBmOy3D+Af+3nd7BQ80/Kx/
        WVPm1cQbRSOTQ5pcxljliA3JOuJvOnxf55U9HXE=
X-Google-Smtp-Source: ABdhPJwuRR4/z82GpvSI6OM9NF6uFqSqUKU/VYuZoB2Vx3dL1t4te9hcrY98kWVDSWFm8FUcbrY7vpDHYi5RKFzDUyI=
X-Received: by 2002:a05:6512:3b11:b0:448:35d2:6092 with SMTP id
 f17-20020a0565123b1100b0044835d26092mr15974417lfv.234.1647316169061; Mon, 14
 Mar 2022 20:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220315034404.623539-1-lsahlber@redhat.com>
In-Reply-To: <20220315034404.623539-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 14 Mar 2022 22:49:18 -0500
Message-ID: <CAH2r5msq--3d01+rV0QQmyUWAmyOqChQdjomZhUtYaAyXAuMbQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: we do not need a spinlock around the tree access
 during umount
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Mar 14, 2022 at 10:44 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Remove the spinlock around the tree traversal as we are calling possibly
> sleeping functions.
> We do not need a spinlock here as there will be no modifications to this
> tree at this point.
>
> This prevents warnings like this to occur in dmesg:
> [  653.774996] BUG: sleeping function called from invalid context at kernel/loc\
> king/mutex.c:280
> [  653.775088] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1827, nam\
> e: umount
> [  653.775152] preempt_count: 1, expected: 0
> [  653.775191] CPU: 0 PID: 1827 Comm: umount Tainted: G        W  OE     5.17.0\
> -rc7-00006-g4eb628dd74df #135
> [  653.775195] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-\
> 1.fc33 04/01/2014
> [  653.775197] Call Trace:
> [  653.775199]  <TASK>
> [  653.775202]  dump_stack_lvl+0x34/0x44
> [  653.775209]  __might_resched.cold+0x13f/0x172
> [  653.775213]  mutex_lock+0x75/0xf0
> [  653.775217]  ? __mutex_lock_slowpath+0x10/0x10
> [  653.775220]  ? _raw_write_lock_irq+0xd0/0xd0
> [  653.775224]  ? dput+0x6b/0x360
> [  653.775228]  cifs_kill_sb+0xff/0x1d0 [cifs]
> [  653.775285]  deactivate_locked_super+0x85/0x130
> [  653.775289]  cleanup_mnt+0x32c/0x4d0
> [  653.775292]  ? path_umount+0x228/0x380
> [  653.775296]  task_work_run+0xd8/0x180
> [  653.775301]  exit_to_user_mode_loop+0x152/0x160
> [  653.775306]  exit_to_user_mode_prepare+0x89/0xd0
> [  653.775315]  syscall_exit_to_user_mode+0x12/0x30
> [  653.775322]  do_syscall_64+0x48/0x90
> [  653.775326]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 187af6e98b44e5d8f25e1d41a92db138eb54416f ("cifs: fix handlecache and multiuser")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 677c02aa8731..6e5246122ee2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -269,7 +269,6 @@ static void cifs_kill_sb(struct super_block *sb)
>                 dput(cifs_sb->root);
>                 cifs_sb->root = NULL;
>         }
> -       spin_lock(&cifs_sb->tlink_tree_lock);
>         node = rb_first(root);
>         while (node != NULL) {
>                 tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> @@ -283,7 +282,6 @@ static void cifs_kill_sb(struct super_block *sb)
>                 mutex_unlock(&cfid->fid_mutex);
>                 node = rb_next(node);
>         }
> -       spin_unlock(&cifs_sb->tlink_tree_lock);
>
>         kill_anon_super(sb);
>         cifs_umount(cifs_sb);
> --
> 2.30.2
>


-- 
Thanks,

Steve
