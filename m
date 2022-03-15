Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF06C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 04:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344752AbiCOEfK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Mar 2022 00:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239466AbiCOEfJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Mar 2022 00:35:09 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F33527E
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 21:33:58 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id s29so9495888lfb.13
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 21:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4peSpXK2mmvCJvbN2k3BvzkqWMrTyTAdaRBSS6B8ZmU=;
        b=gJkkKRXFtbqf9b+A/ootv7FqYr2qMGYMEZ2jDXTZI3JEeTjpYMK7DOhiJ2ldpoIuHv
         Nk/jWyHiE/fTPQGZKzEaMSQd0PSIxTC/kYbu/7OfPLwqz9y48VNV4vgFUiVw1rZBdHyA
         Le/OqpNfbd/2rtalSqiiR3MpqmJ3UvbtTQ/618wCeqJBGWLlCg+y3N9BinUbt86sP9iT
         1F39OrleIFFUa6ZJ7c1zzbNYoR1qm2l3104Ot+L9qLPAUHuBozOxasgB9jKSw2U3Sfc6
         pI/KZnlYSvGbc524wL72yb32jzHZyIxzBSXHFT2959B+kj+mHE+w/ba7jaKt8WmQV2JE
         1SIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4peSpXK2mmvCJvbN2k3BvzkqWMrTyTAdaRBSS6B8ZmU=;
        b=gT3vgLjP+OIwdbZNaYQt9+w07OYN33rSNQYWfOTD5ctjk93SicJUVCzI7Oh/FgDF6n
         Xz8J5lb6GxZDKCUuBQZVQ8jvxbQjjB0hPVAhud4/IovSBXUwi2wEUiIj/+xCp1DjAWnn
         W353Z4OuAxTal9HIveQiHzkHEmIoiJF/Nsm+z9BJPyJoPMLNR0tvUwd9KsI9nJbn9tPx
         rPh4wQy/bFz4BC1WeTeRSNjKUYtmF3IDbRU86LNHkfURwSmROwxD8VDP2EbjoHB/5Njv
         vB8awVNpV13gGvbU02ZxyniPb50EcUSFUsBukOtVeR5I7HerakDPYc4njol3t4gHB9YM
         JLMQ==
X-Gm-Message-State: AOAM532E8MMbtSvLlIKFZJ6ExwmzeWtKevM40h5PtQv7SgPerE4wMbP3
        Waw5eGe3EelfdMmUSHEYlqxFPgeoqlF6qz3NbxGWp5ksFCw=
X-Google-Smtp-Source: ABdhPJxVbUMmgEWI4Gt0geMnf+wRCldWJSLEVW1hkQtncqCtA9AwawKgwaHu673JMi7CP0TTl5InexSha5NGO+M8SZc=
X-Received: by 2002:a05:6512:b19:b0:446:f1c6:81bd with SMTP id
 w25-20020a0565120b1900b00446f1c681bdmr15506644lfu.320.1647318836293; Mon, 14
 Mar 2022 21:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220315041745.625517-1-lsahlber@redhat.com>
In-Reply-To: <20220315041745.625517-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 14 Mar 2022 23:33:45 -0500
Message-ID: <CAH2r5mv_Oi=jQpnQRHYOweJoyH8VT8DCfW9YUkze-qvDZbx1GQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix KASAN warning in parse_server_interfaces()
 during mount
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6-git for-next pending testing

On Mon, Mar 14, 2022 at 11:17 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> In parse_server_interfaces() we hold a spinlock across a parsing look that
> calls kmalloc(). Use GFP_ATOMIC for this kmalloc since we can not sleep
> while holding a spinlock.
>
> KASAN warning for this bug looks as:
> [ 2638.506227] BUG: sleeping function called from invalid context at include/li\
> nux/sched/mm.h:256
> [ 2638.506360] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3633, nam\
> e: mount.cifs
> [ 2638.506446] preempt_count: 1, expected: 0
> [ 2638.506486] CPU: 0 PID: 3633 Comm: mount.cifs Tainted: G        W  OE     5.\
> 17.0-rc7-00006-g4eb628dd74df #135
> [ 2638.506490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-\
> 1.fc33 04/01/2014
> [ 2638.506493] Call Trace:
> [ 2638.506495]  <TASK>
> [ 2638.506497]  dump_stack_lvl+0x34/0x44
> [ 2638.506505]  __might_resched.cold+0x13f/0x172
> [ 2638.506509]  ? _raw_spin_lock+0x81/0xe0
> [ 2638.506514]  ? parse_server_interfaces+0x3fe/0xc17 [cifs]
> [ 2638.506610]  kmem_cache_alloc_trace+0x261/0x2f0
> [ 2638.506616]  parse_server_interfaces+0x3fe/0xc17 [cifs]
> [ 2638.506685]  ? kref_put.isra.0+0x42/0x42 [cifs]
> [ 2638.506754]  smb3_qfs_tcon.cold+0x28/0x2d [cifs]
> [ 2638.506821]  ? open_cached_dir+0x1080/0x1080 [cifs]
> [ 2638.506884]  ? io_schedule_timeout+0x1a0/0x1a0
> [ 2638.506888]  ? _raw_spin_lock+0x81/0xe0
> [ 2638.506892]  ? _raw_write_lock_irq+0xd0/0xd0
> [ 2638.506896]  ? __raw_callee_save___native_queued_spin_unlock+0x11/0x1e
> [ 2638.506901]  ? _raw_spin_lock+0x81/0xe0
> [ 2638.506904]  ? cifs_get_tcon+0xea3/0x1bc0 [cifs]
> [ 2638.506959]  mount_get_conns+0x366/0xf60 [cifs]
> [ 2638.507012]  cifs_mount+0xcc/0xe90 [cifs]
> [ 2638.507068]  ? __irq_work_queue_local+0x67/0xa0
> [ 2638.507073]  ? follow_dfs_link+0x810/0x810 [cifs]
> [ 2638.507125]  ? _raw_spin_lock+0x81/0xe0
> [ 2638.507130]  cifs_smb3_do_mount+0x259/0x5f0 [cifs]
> [ 2638.507180]  ? cifs_sb_deactive+0x60/0x60 [cifs]
> [ 2638.507231]  ? mutex_lock+0x9f/0xf0
> [ 2638.507234]  ? __mutex_lock_slowpath+0x10/0x10
> [ 2638.507238]  ? smb3_fs_context_parse_monolithic+0x10b/0x2e0 [cifs]
> [ 2638.507309]  ? smb3_init_fs_context+0x1b6/0x8f0 [cifs]
> [ 2638.507388]  smb3_get_tree+0x77/0xf0 [cifs]
> [ 2638.507450]  vfs_get_tree+0x84/0x2b0
> [ 2638.507455]  do_new_mount+0x21e/0x480
> [ 2638.507460]  ? do_add_mount+0x370/0x370
> [ 2638.507464]  ? security_capable+0x56/0x90
> [ 2638.507469]  path_mount+0x2ad/0x1660
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index e04c3045c4d6..0ecd6e1832a1 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -569,7 +569,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>
>                 /* no match. insert the entry in the list */
>                 info = kmalloc(sizeof(struct cifs_server_iface),
> -                              GFP_KERNEL);
> +                              GFP_ATOMIC);
>                 if (!info) {
>                         rc = -ENOMEM;
>                         spin_unlock(&ses->iface_lock);
> --
> 2.30.2
>


-- 
Thanks,

Steve
