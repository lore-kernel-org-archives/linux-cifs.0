Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF34FC433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Apr 2021 23:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8116D613B7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Apr 2021 23:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhDWXwP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhDWXwO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Apr 2021 19:52:14 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74F0C061574
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 16:51:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a13so3600338ljp.2
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 16:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tc3bu2BiI8PLLreP/CtdwDchsn8MOLWO2mH1ju6l2Ng=;
        b=Zzok+ZhzRFEGpMQaWWZ8JQal+2KWxheswp/YQM3dEcZ3YvRY60p19rklv5geTXiM1K
         yTUCJA60WIM0qjyIpASr6AmZEXpFqzCoklToK29WRCNVqFNbCVSpFlZ85f6AmiKbPZFd
         9hYHL0r4NXIdEdhVADm7dqK60+Spof2mDUOlpkNWwTPZRZHX9YPri0WeTO/I0hHK9qCq
         3EO3fDNVnCevuq60ptrMEdS52M/V8eiLDDjj6QqQF9aqI62bKEun4O4vSk18QaZ91ywC
         fOZiTXoYWFmEGog4r33+7xxp6YxBlArSwPiA5D2HvVRwrkGq4v0VB6RlFht/zxnCXKoK
         clKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tc3bu2BiI8PLLreP/CtdwDchsn8MOLWO2mH1ju6l2Ng=;
        b=MKO1B30JYsolVa3wSwCZomu/f8JNeqa4KWHqqTGY2BhEnUYEQ0BLwfKdmosq/NcPH8
         lHvYTeRwyipc1/Dqt+K1tUugENLnEPEfQC5C+m/wf6BlHGy9D4rgwYNNxVVBZaIEh7S2
         w2w8dDRRmBaINE2RVDsEwrDSl2XX1zY9y0OXLpiy80p+BFk2ORTp2xIuvkHzxV0DcdMt
         edj9RyjJqkrsYpN+L4nD78gsTIi3wyb+LTKbbDedd8AG22HR7GJ7hjyCWq2R+gDKp62u
         hAF73BKmzPvj6WSU1ad4A5jbOs5EmjGUCpj2/eV1h3eM/ty/UGxM/EyBK+l9YAJ42WWr
         q37A==
X-Gm-Message-State: AOAM533ftGuFbizjaahP6Gz0wTRnbwQgSu5U3FOZP6Qs1WAPM8aruknM
        g3JpnJ94qU80VP3VopimhtYqqPnMuP1owlmg2kDx6hU2
X-Google-Smtp-Source: ABdhPJxPkwlfmX4BzG8YtYWSMzwMSfzRpSPLPfmkzXhoULyS1aJsHAlJHyRGHOtzCbBLC0fpIMBuklAVN6O4b9+7ckM=
X-Received: by 2002:a2e:a78b:: with SMTP id c11mr4465831ljf.6.1619221894254;
 Fri, 23 Apr 2021 16:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210422221403.13617-1-ddiss@suse.de> <8735vi54nw.fsf@cjr.nz>
In-Reply-To: <8735vi54nw.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Apr 2021 18:51:23 -0500
Message-ID: <CAH2r5mvg-2zaVsYnw-_iBSPXsbQekACJz+CYEviuNM3CjZJGXQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix leak in cifs_smb3_do_mount() ctx
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     David Disseldorp <ddiss@suse.de>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and kicking off (buildbot) testing
run with it now

On Thu, Apr 22, 2021 at 5:36 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> David Disseldorp <ddiss@suse.de> writes:
>
> > cifs_smb3_do_mount() calls smb3_fs_context_dup() and then
> > cifs_setup_volume_info(). The latter's subsequent smb3_parse_devname()
> > call overwrites the cifs_sb->ctx->UNC string already dup'ed by
> > smb3_fs_context_dup(), resulting in a leak. E.g.
> >
> > unreferenced object 0xffff888002980420 (size 32):
> >   comm "mount", pid 160, jiffies 4294892541 (age 30.416s)
> >   hex dump (first 32 bytes):
> >     5c 5c 31 39 32 2e 31 36 38 2e 31 37 34 2e 31 30  \\192.168.174.10
> >     34 5c 72 61 70 69 64 6f 2d 73 68 61 72 65 00 00  4\rapido-share..
> >   backtrace:
> >     [<00000000069e12f6>] kstrdup+0x28/0x50
> >     [<00000000b61f4032>] smb3_fs_context_dup+0x127/0x1d0 [cifs]
> >     [<00000000c6e3e3bf>] cifs_smb3_do_mount+0x77/0x660 [cifs]
> >     [<0000000063467a6b>] smb3_get_tree+0xdf/0x220 [cifs]
> >     [<00000000716f731e>] vfs_get_tree+0x1b/0x90
> >     [<00000000491d3892>] path_mount+0x62a/0x910
> >     [<0000000046b2e774>] do_mount+0x50/0x70
> >     [<00000000ca7b64dd>] __x64_sys_mount+0x81/0xd0
> >     [<00000000b5122496>] do_syscall_64+0x33/0x40
> >     [<000000002dd397af>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > This change is a bandaid until the cifs_setup_volume_info() TODO and
> > error handling issues are resolved.
> >
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >  fs/cifs/cifsfs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
