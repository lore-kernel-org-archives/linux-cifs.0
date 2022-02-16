Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6B9C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Feb 2022 03:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiBPDDR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:03:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343986AbiBPDDQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Feb 2022 22:03:16 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487EB67367
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 19:03:04 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id e5so1219366lfr.9
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 19:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4zIDcEbJv0lgHng5Snjnmqu4LPErDSbdbQjDNjfkfA=;
        b=g6j6LU1UgLAgOypjQj1Z0mJU4wKYYcWI9nmqx9GWHoy4mJ6FVzHkMdEXxFzvQVX9i7
         ZZLPpUVQFsSuV+3ESlwzznOEU2BnFRfHSpFgZCSSoVUbrm5NifLGGa2Bc3l1vsmMCTOH
         gXtPsjjzjOdLYkrwcXefRM1ZEyAdIpmAEByQNd1mLYodD1OjDJ4cIsp9QrCRiHjTRmmZ
         LUsZLV1En2r5ThMPa9VEIyuSjogHLM049zg72i0VdZbUCr7NBiVT9fCijcygmJ4fCJKl
         i6aGtEyrACRV6BZCq3x+6YGu1/8bb1wlky0ktwPP+WluTnI5nNgmG4bXbscEAWbXLGuP
         hMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4zIDcEbJv0lgHng5Snjnmqu4LPErDSbdbQjDNjfkfA=;
        b=DfUWRZcEO1aIA5px/7kqJ2hZvFI/NCI9mYJg0h4yGvu5p1NWsQtGq9hzY7KDbyzZ9u
         yKMROMQfucRyCB8AjBXY6ohZ8F4FbLbPhjcXGgGiXHpaNulnP25o6AU1GISmSOBD9rhE
         dyD9XFXAdIZCeDaU6+cSR2o6j2+3GiES2g3q2Yb6rt7LpbJFpRunqDghhA7k3MC0YZl2
         pAeMHWYusq6gRHaI6PsMXqdY9vb68KotVym6APpIdWJpW9oMOU+SzjiX3k+/exlXffMo
         eWKHBl3Rna0ysBu4GOT5KtPYxc/cck/K5vlru5rSEpLEjCN8ElRLx2idtWt3luKhAQym
         hyyA==
X-Gm-Message-State: AOAM533AeIk2jEO56FB5iMptkkEeXnds8FOH9Cz71oWtRhAk8fDNJUkS
        d+H34F1vF6OOaylMxcjtG+ZqZXHSLDAQrg+y6I5Qjph3xtn7Zw==
X-Google-Smtp-Source: ABdhPJx25f7FQgwTJe18koWuQSRjxqZtZ2srqVXfpsZzViCdfJzeqZsNcmwnwND5TLzKM6biMUglINzhYVRQAcUh8Ug=
X-Received: by 2002:a05:6512:2347:b0:443:76b8:82e0 with SMTP id
 p7-20020a056512234700b0044376b882e0mr479614lfu.601.1644980582477; Tue, 15 Feb
 2022 19:03:02 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
 <87leyckkzo.fsf@cjr.nz> <CAH2r5muC7Bg5WQf1UcWd0LaPg+NVxQ5y_nz7p19U_SvVh9qJHQ@mail.gmail.com>
 <CAH2r5msU0Bjp+CsKb4VQ5yEaPoOh6+e40hdvBOY1Hs-FUGe4iQ@mail.gmail.com> <CANT5p=qHHCTT0EaQDiYediXNo5ATi1j_gZGhTW6+zyC5m6zY5g@mail.gmail.com>
In-Reply-To: <CANT5p=qHHCTT0EaQDiYediXNo5ATi1j_gZGhTW6+zyC5m6zY5g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Feb 2022 21:02:51 -0600
Message-ID: <CAH2r5mtQZwi=f+q7YZTay4qkf46h2ppMwB6eScPXAEVK8+1nWA@mail.gmail.com>
Subject: Re: [PATCH] cifs: use a different reconnect helper for non-cifsd threads
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - Running cifs-testing group on it now.  Will run DFS tests next

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/903

$ git log --oneline v5.17-rc4..
5279203f772d (HEAD -> for-next, origin/for-next) cifs: use a different
reconnect helper for non-cifsd threads
0c6f4ebf8835 cifs: modefromsids must add an ACE for authenticated users
3d6cc9898efd cifs: fix double free race when mount fails in cifs_get_root()
26d3dadebbcb cifs: do not use uninitialized data in the owner/group sid
dd5a927e4118 cifs: fix set of group SID via NTSD xattrs
9405b5f8b20c smb3: fix snapshot mount option

On Tue, Feb 15, 2022 at 7:51 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Thanks for the review and update, Paulo.
>
> Steve, please run the DFS tests in buildbot as well.
>
> On Wed, 16 Feb, 2022, 06:11 Steve French, <smfrench@gmail.com> wrote:
>>
>> Looks like it passed multichannel buildbot tests with the patch
>>
>> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/180
>>
>> On Tue, Feb 15, 2022 at 1:37 PM Steve French <smfrench@gmail.com> wrote:
>> >
>> > Updated and tentatively merged into cifs-2.6.git for-next and added acked-by
>> >
>> > Shyam,
>> > Let me know if any additional changes you see or feedback.
>> >
>> > On Tue, Feb 15, 2022 at 1:06 PM Paulo Alcantara <pc@cjr.nz> wrote:
>> > >
>> > > Hi Shyam,
>> > >
>> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
>> > >
>> > > > My patch last week was not sufficient to fix some of the buildbot
>> > > > failures we saw recently.
>> > > > Please review and use the following patch for new buildbot runs.
>> > > >
>> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch
>> > >
>> > > Patch looks good, however you missed these:
>> > >
>> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > > index 053cb449eb16..2e00cd58a8b5 100644
>> > > --- a/fs/cifs/connect.c
>> > > +++ b/fs/cifs/connect.c
>> > > @@ -4416,7 +4416,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
>> > >          */
>> > >         if (rc && server->current_fullpath != server->origin_fullpath) {
>> > >                 server->current_fullpath = server->origin_fullpath;
>> > > -               cifs_reconnect(tcon->ses->server, true);
>> > > +               cifs_signal_cifsd_for_reconnect(server, true);
>> > >         }
>> > >
>> > >         dfs_cache_free_tgts(tl);
>> > > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
>> > > index ebe236b9d9f5..235aa1b395eb 100644
>> > > --- a/fs/cifs/netmisc.c
>> > > +++ b/fs/cifs/netmisc.c
>> > > @@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
>> > >                 if (class == ERRSRV && code == ERRbaduid) {
>> > >                         cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
>> > >                                 code);
>> > > -                       cifs_reconnect(mid->server, false);
>> > > +                       cifs_signal_cifsd_for_reconnect(mid->server, false);
>> > >                 }
>> > >         }
>> > >
>> > > With that, feel free to add:
>> > >
>> > > Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve



-- 
Thanks,

Steve
