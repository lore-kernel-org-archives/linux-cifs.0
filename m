Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7202C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 03:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiDUD7B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 23:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiDUD7B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 23:59:01 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA350BCB9
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:56:12 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h27so6190471lfj.13
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21IGjJiAYpqWwSOQejZUCRdxMz4SkyswJ9e9AVhjvJM=;
        b=PDqwyhsqE8ccMqh4JLgBDJK2auhsyJMqCaavivbVnDJVzpoXNGKoiZM8vsAZuq65Ju
         g7q2KsRsz7IKbKMwalLqr5Q56dLPgqHnjruXhcWyaiLIWbyefZCgaB4/V8HCpiZIjuz9
         8+O2sWzwVZdJe1kDeeEOm81kjJrxw+EQ50eVvDF0py6Rnyam3AXxBNtcPRT0Nw/+gdKe
         wqNySd/E1rp5S6cNq5yAyFoSPdWxf0zD+xjJ5DKp7DSGMTTBBUtJ08s/FklJKKCZBcyI
         y93Q9CroTdvDLfJPzM4ISoJCvQ0YSOl5Ps2yLa/oQfEp0B8e57DpQlFeEZn/H5kBvI42
         /vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21IGjJiAYpqWwSOQejZUCRdxMz4SkyswJ9e9AVhjvJM=;
        b=AN5MYpSMJQdoqOTlOVUtRVYfdX6EYFtmTCZpAzmxyZY+7F0MayhgbGja+AV46/I3CK
         SeIHDLGNB78fZAblznMCA6Sg4hxEp8GO+5R0dt5yR1Gjwl0ZcIviFlJkFaM5Yfa5m9y2
         rPZvXJ8GkS1u5v6XAZxfqM3A2zrJSMHbYZppV7orLf+F+Haez5kB2mUzlBo9PJL7d+UA
         jpFynPDLoksbcE+5qiCxfh1XceC01Cfnq6lpBvpH0JJmjkxPiQspUAbDHNrlVmGQ5KPb
         KU2/FzriwyKX8nqiZs0s0dmbymACxcpRs9P4Ptiporc9+ksGB4wJYFZu2mbrvXxfQ5vT
         IkdQ==
X-Gm-Message-State: AOAM532ftQRL8Gi9SuqJoN31OlXCGwR6a/UfGpxB4DxWRl8v4SpwMwAz
        Q67Xw2l2BJJa8kujWrrJ0SjdPqD0RuIpDr0e9adu1YcJ
X-Google-Smtp-Source: ABdhPJyP7OH0gRBRrQjebzrKaO7VoL8TXgZybbyJhB4qDNuvqHz/RUtz/Wnbuekd3SSpp+kM1OdfLXO72UWCefygcoI=
X-Received: by 2002:a05:6512:280e:b0:471:a355:72c3 with SMTP id
 cf14-20020a056512280e00b00471a35572c3mr9546064lfb.234.1650513370618; Wed, 20
 Apr 2022 20:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220421000546.5129-1-pc@cjr.nz> <CAGvGhF6DSORkrWc0hL53zRikJCwc0vaYJHMReWbiDcCPCmA3mQ@mail.gmail.com>
In-Reply-To: <CAGvGhF6DSORkrWc0hL53zRikJCwc0vaYJHMReWbiDcCPCmA3mQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Apr 2022 22:55:58 -0500
Message-ID: <CAH2r5mvC3UkDRLu9ZVe=gq05WnZ22BtB1ywhLwdgVp0Q_1asjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: fix NULL ptr dereference in refresh_mounts()
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added CC:Stable and Reviewed-by and pushed to cifs-2.6.git for-next
pending testing

On Wed, Apr 20, 2022 at 9:38 PM Leif Sahlberg <lsahlber@redhat.com> wrote:
>
> Looks good.   Reviewed-by me
>
>
> On Thu, Apr 21, 2022 at 10:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Either mount(2) or automount might not have server->origin_fullpath
> > set yet while refresh_cache_worker() is attempting to refresh DFS
> > referrals.  Add missing NULL check and locking around it.
> >
> > This fixes bellow crash:
> >
> > [ 1070.276835] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
> > [ 1070.277676] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > [ 1070.278219] CPU: 1 PID: 8506 Comm: kworker/u8:1 Not tainted 5.18.0-rc3 #10
> > [ 1070.278701] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
> > [ 1070.279495] Workqueue: cifs-dfscache refresh_cache_worker [cifs]
> > [ 1070.280044] RIP: 0010:strcasecmp+0x34/0x150
> > [ 1070.280359] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
> > [ 1070.281729] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
> > [ 1070.282114] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> > [ 1070.282691] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [ 1070.283273] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
> > [ 1070.283857] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
> > [ 1070.284436] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
> > [ 1070.284990] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
> > [ 1070.285625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1070.286100] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
> > [ 1070.286683] Call Trace:
> > [ 1070.286890]  <TASK>
> > [ 1070.287070]  refresh_cache_worker+0x895/0xd20 [cifs]
> > [ 1070.287475]  ? __refresh_tcon.isra.0+0xfb0/0xfb0 [cifs]
> > [ 1070.287905]  ? __lock_acquire+0xcd1/0x6960
> > [ 1070.288247]  ? is_dynamic_key+0x1a0/0x1a0
> > [ 1070.288591]  ? lockdep_hardirqs_on_prepare+0x410/0x410
> > [ 1070.289012]  ? lock_downgrade+0x6f0/0x6f0
> > [ 1070.289318]  process_one_work+0x7bd/0x12d0
> > [ 1070.289637]  ? worker_thread+0x160/0xec0
> > [ 1070.289970]  ? pwq_dec_nr_in_flight+0x230/0x230
> > [ 1070.290318]  ? _raw_spin_lock_irq+0x5e/0x90
> > [ 1070.290619]  worker_thread+0x5ac/0xec0
> > [ 1070.290891]  ? process_one_work+0x12d0/0x12d0
> > [ 1070.291199]  kthread+0x2a5/0x350
> > [ 1070.291430]  ? kthread_complete_and_exit+0x20/0x20
> > [ 1070.291770]  ret_from_fork+0x22/0x30
> > [ 1070.292050]  </TASK>
> > [ 1070.292223] Modules linked in: bpfilter cifs cifs_arc4 cifs_md4
> > [ 1070.292765] ---[ end trace 0000000000000000 ]---
> > [ 1070.293108] RIP: 0010:strcasecmp+0x34/0x150
> > [ 1070.293471] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
> > [ 1070.297718] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
> > [ 1070.298622] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> > [ 1070.299428] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [ 1070.300296] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
> > [ 1070.301204] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
> > [ 1070.301932] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
> > [ 1070.302645] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
> > [ 1070.303462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1070.304131] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
> > [ 1070.305004] Kernel panic - not syncing: Fatal exception
> > [ 1070.305711] Kernel Offset: disabled
> > [ 1070.305971] ---[ end Kernel panic - not syncing: Fatal exception ]---
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > ---
> >  fs/cifs/connect.c   |  2 ++
> >  fs/cifs/dfs_cache.c | 19 ++++++++++++-------
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 902e8c6c0f9c..2c24d433061a 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3675,9 +3675,11 @@ static void setup_server_referral_paths(struct mount_ctx *mnt_ctx)
> >  {
> >         struct TCP_Server_Info *server = mnt_ctx->server;
> >
> > +       mutex_lock(&server->refpath_lock);
> >         server->origin_fullpath = mnt_ctx->origin_fullpath;
> >         server->leaf_fullpath = mnt_ctx->leaf_fullpath;
> >         server->current_fullpath = mnt_ctx->leaf_fullpath;
> > +       mutex_unlock(&server->refpath_lock);
> >         mnt_ctx->origin_fullpath = mnt_ctx->leaf_fullpath = NULL;
> >  }
> >
> > diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> > index 30e040da4f09..956f8e5cf3e7 100644
> > --- a/fs/cifs/dfs_cache.c
> > +++ b/fs/cifs/dfs_cache.c
> > @@ -1422,12 +1422,14 @@ static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool
> >         struct TCP_Server_Info *server = tcon->ses->server;
> >
> >         mutex_lock(&server->refpath_lock);
> > -       if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
> > -               __refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
> > +       if (server->origin_fullpath) {
> > +               if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
> > +                                                       server->origin_fullpath))
> > +                       __refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
> > +               __refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
> > +       }
> >         mutex_unlock(&server->refpath_lock);
> >
> > -       __refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
> > -
> >         return 0;
> >  }
> >
> > @@ -1530,11 +1532,14 @@ static void refresh_mounts(struct cifs_ses **sessions)
> >                 list_del_init(&tcon->ulist);
> >
> >                 mutex_lock(&server->refpath_lock);
> > -               if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
> > -                       __refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
> > +               if (server->origin_fullpath) {
> > +                       if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
> > +                                                               server->origin_fullpath))
> > +                               __refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
> > +                       __refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
> > +               }
> >                 mutex_unlock(&server->refpath_lock);
> >
> > -               __refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
> >                 cifs_put_tcon(tcon);
> >         }
> >  }
> > --
> > 2.35.3
> >
>


-- 
Thanks,

Steve
