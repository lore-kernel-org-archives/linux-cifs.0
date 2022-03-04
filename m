Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D0BC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 17:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbiCDRNA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Mar 2022 12:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiCDRM7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Mar 2022 12:12:59 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9F11CD9F4
        for <linux-cifs@vger.kernel.org>; Fri,  4 Mar 2022 09:12:11 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id m14so15279516lfu.4
        for <linux-cifs@vger.kernel.org>; Fri, 04 Mar 2022 09:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHW7mutHCkekekPtx2nWdk4aiFz7sC34O38seFW3hIQ=;
        b=Lz/spEKDEYzHrdHdnbA8d6u0fBL1GI8Z6k8tz3HbMxFCbhK/MmQylwn1hdFJHVHkPi
         ie7p3gM8AKY58B4O+Kd2voK7bacz5roBiESrj4nVloQmjMwugcLmJ4hXRezUlPLXsKFn
         zU721wgo6qPmsK3FmjgSHXAsvFmrBWcG0EjwDOu341aQwXrss2MRMpzApOgus57L3dCM
         Bz9RY/ru3Fb9mQsfwUR9e7BeOWPrf0hCRlG8bpDv7HUw7NMh1PQ2MeXF6KBqJTEKhpcG
         hcludW5MaE4AIPEIMNO7enEO4V0tj2j4faw6CystOOCg5tx76I4oP+PChr0BD9oGj6W1
         xRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHW7mutHCkekekPtx2nWdk4aiFz7sC34O38seFW3hIQ=;
        b=p1SHpPOPtQVFyrvel2XY+btDQbApjiDtxq1ty9FKU3tacpANFDLdII52eCYKTBaDUH
         9wFfluA632NvvyZn1OU298Zxh5F0nn6ftnuiC6Dqp6i5U8VD4+PQYwYemHlte5b2VDyr
         U0SgfgM03HV8GsAz41WlW4kCLU5zN9TmCQWoUmxr5VwyqdPKrLiHUitC+oGDpuTLS3Vy
         iXlUyJexS+4foEvlJn2PsWlQaPoUR6iG6wvr8lKgpGh5AKfhatx+tVmKpVOjS9gSqFeP
         DE602rz0Chjn+gICJFDEcolxrGNvqz6sHtfRdjwmqyOjHkGzdJ/YycRMfYuFvuvTZoeA
         GP0A==
X-Gm-Message-State: AOAM532EkcUVxTmQMxzM3CBscVmwEDrrpz3/4gKxzYLnvPkNXhkqQjXK
        UshQxzSS5eFn4xj6o4NvYUBVFrS6eGO6nXQ5awY=
X-Google-Smtp-Source: ABdhPJxBwASPS7CyTqN6Epc3/+DodWOnKo/GHtk06DWCd3FLA2nqDnzgKDoB5XdYHDGUyoWMqz1LmytgqpNKU16MYGs=
X-Received: by 2002:a05:6512:2315:b0:439:731f:a11e with SMTP id
 o21-20020a056512231500b00439731fa11emr26277899lfu.545.1646413926908; Fri, 04
 Mar 2022 09:12:06 -0800 (PST)
MIME-Version: 1.0
References: <20220304003149.299182-1-lsahlber@redhat.com> <87ee3h20am.fsf@cjr.nz>
In-Reply-To: <87ee3h20am.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 4 Mar 2022 11:11:55 -0600
Message-ID: <CAH2r5msPf85900KpdOxPOs-VLD1UK6Q0-XT4_PH2Ajqa7j86+g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix handlecache and multiuser
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added Acked-by and also added cc: Stable


On Fri, Mar 4, 2022 at 9:40 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > In multiuser each individual user has their own tcon structure for the
> > share and thus their own handle for a cached directory.
> > When we umount such a share we much make sure to release the pinned down dentry
> > for each such tcon and not just the master tcon.
> >
> > Otherwise we will get nasty warnings on umount that dentries are still in use:
> > [ 3459.590047] BUG: Dentry 00000000115c6f41{i=12000000019d95,n=/}  still in use\
> >  (2) [unmount of cifs cifs]
> > ...
> > [ 3459.590492] Call Trace:
> > [ 3459.590500]  d_walk+0x61/0x2a0
> > [ 3459.590518]  ? shrink_lock_dentry.part.0+0xe0/0xe0
> > [ 3459.590526]  shrink_dcache_for_umount+0x49/0x110
> > [ 3459.590535]  generic_shutdown_super+0x1a/0x110
> > [ 3459.590542]  kill_anon_super+0x14/0x30
> > [ 3459.590549]  cifs_kill_sb+0xf5/0x104 [cifs]
> > [ 3459.590773]  deactivate_locked_super+0x36/0xa0
> > [ 3459.590782]  cleanup_mnt+0x131/0x190
> > [ 3459.590789]  task_work_run+0x5c/0x90
> > [ 3459.590798]  exit_to_user_mode_loop+0x151/0x160
> > [ 3459.590809]  exit_to_user_mode_prepare+0x83/0xd0
> > [ 3459.590818]  syscall_exit_to_user_mode+0x12/0x30
> > [ 3459.590828]  do_syscall_64+0x48/0x90
> > [ 3459.590833]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
>
> Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
