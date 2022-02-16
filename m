Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623D4C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Feb 2022 00:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245116AbiBPAl6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:41:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243144AbiBPAl6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Feb 2022 19:41:58 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE6B66231
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 16:41:46 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id d23so739428lfv.13
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 16:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxk8yyNcdl26G6srX4v7R0/AhiT0SLP0YCNLJG+5OcM=;
        b=Y1MUR2qw4gu3NFB35NZks/74PJJkjOTBmvsYHdzvXvIU7vkdlNQ2gx/Cxi6BQG5JpA
         Khl/c6GcTD/GqHJi7RFULtFxrSEPbOdajHklns3VGL4ynVvXy8O4YlWnZFRJWxSRK9tU
         gFtxAksbtgsnrbVrFhF9EOX1ksgGuo2HBb9NUGG2uvsRRJj8wR6co2+cjfgE07DlNmRd
         eLuKcIHktQncl6o+SE31GSXyTkpDqzuV8gKoZF/0P3mSeJp/GccUUBlVOE+BVmJkuMIp
         MW3rKgzsv7sB/rpen/a+iEEhrVHaO4qSuuaj0SHC8Qq9PVSYJDFUS5w/9J5qaW8zKKFx
         t54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxk8yyNcdl26G6srX4v7R0/AhiT0SLP0YCNLJG+5OcM=;
        b=h2Lcmb3IQdw4Jn56+yJfj6Y1iE3lNABEwpKI8yhLbTHkykgXPDOiJ1Nk+YZeawJdvW
         3zBjina0A/ejSwrAwUe846AB5okgQguwPRNRQueUxyfD0ubRJfO+7+8ZaH/OdocsfEq+
         iQUQ0tg9slQEntezwVFzYO9EoFrRPL8YvJnDvYQfn7B0ofSLPP71+WbZkeK9T5zI3kBE
         WDP8OsD9WuPtac0tpxcpFVKWg6lx9Lb7vl3P8rGp2tkseOKI4hOY0nmTi3tmUVG0WBfk
         ZZygE0TNqkzv7TlK38b7HxwutWKst1Cw+IkRsapTOhPhlnXxORn74g0pShdHb3kbkzuJ
         4D4w==
X-Gm-Message-State: AOAM5324WGwhLBnGX+lsPv8NntKRLGSOoqI8ChVQROd+hzEx6DKcio2V
        BfG8heieYKcM2Kd1higvKyVVMP1c2PIZC+8nFI8=
X-Google-Smtp-Source: ABdhPJxR3dNoGa4NfuxkjSNhTt1P7snGPwncF8JQhxPX5z0B7QuTXPfDMFvYmxCCucuzoO0qUExk6FrhEquMZqls+8c=
X-Received: by 2002:ac2:4156:0:b0:443:1591:c2be with SMTP id
 c22-20020ac24156000000b004431591c2bemr272514lfi.234.1644972105089; Tue, 15
 Feb 2022 16:41:45 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
 <87leyckkzo.fsf@cjr.nz> <CAH2r5muC7Bg5WQf1UcWd0LaPg+NVxQ5y_nz7p19U_SvVh9qJHQ@mail.gmail.com>
In-Reply-To: <CAH2r5muC7Bg5WQf1UcWd0LaPg+NVxQ5y_nz7p19U_SvVh9qJHQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Feb 2022 18:41:33 -0600
Message-ID: <CAH2r5msU0Bjp+CsKb4VQ5yEaPoOh6+e40hdvBOY1Hs-FUGe4iQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: use a different reconnect helper for non-cifsd threads
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like it passed multichannel buildbot tests with the patch

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/180

On Tue, Feb 15, 2022 at 1:37 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated and tentatively merged into cifs-2.6.git for-next and added acked-by
>
> Shyam,
> Let me know if any additional changes you see or feedback.
>
> On Tue, Feb 15, 2022 at 1:06 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Hi Shyam,
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > My patch last week was not sufficient to fix some of the buildbot
> > > failures we saw recently.
> > > Please review and use the following patch for new buildbot runs.
> > >
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch
> >
> > Patch looks good, however you missed these:
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 053cb449eb16..2e00cd58a8b5 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -4416,7 +4416,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
> >          */
> >         if (rc && server->current_fullpath != server->origin_fullpath) {
> >                 server->current_fullpath = server->origin_fullpath;
> > -               cifs_reconnect(tcon->ses->server, true);
> > +               cifs_signal_cifsd_for_reconnect(server, true);
> >         }
> >
> >         dfs_cache_free_tgts(tl);
> > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> > index ebe236b9d9f5..235aa1b395eb 100644
> > --- a/fs/cifs/netmisc.c
> > +++ b/fs/cifs/netmisc.c
> > @@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
> >                 if (class == ERRSRV && code == ERRbaduid) {
> >                         cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
> >                                 code);
> > -                       cifs_reconnect(mid->server, false);
> > +                       cifs_signal_cifsd_for_reconnect(mid->server, false);
> >                 }
> >         }
> >
> > With that, feel free to add:
> >
> > Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
