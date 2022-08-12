Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04850C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 01:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiHLBeb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiHLBeb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 21:34:31 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A290BF71
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:34:30 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id b4so7573587uaw.11
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=g2Fr/xqvyttWfnWR413lVKKmHv66Yo8Xjcy1Dt7z97w=;
        b=Rs1of1y2DhqAyavQKL6nDRizHiMrWSZS8fOqMcMOz2HmCEBwEJ0w/n2abj88FhJ8WI
         melWwsTS1cTzgkTlYtgPcG7tPVY4zFSaqHj3KxFfxvIMqEHmTndE8EE5RuO/vgQ6KvhC
         hjJfJOl8CyJg6Ls6iqa8huG/k+CUpTRqswpw8wl2uuYG1HHCy+mk1lvGEB2cB7EKgAS0
         mXlDSs1MqVBzrhJsgBEWVPAWj8lo06Ewp4chxprWRisgDj32HBExj6sHkplrO5PSTwpn
         1BRAhpIF1LrxL9Nfc5mXxMfgPJNpoLjsAlCjvopC4f6R4dUlukNZ4E5vZ5F/maAs5Ec7
         QCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=g2Fr/xqvyttWfnWR413lVKKmHv66Yo8Xjcy1Dt7z97w=;
        b=hqRy1KZ+imsiAUU4D6xz71Ismp/c29J1yTBG6jWTICMS0fnQZ74UI7m4cxAvt1unMY
         HsJfgjKPadgd9/r8Pk+77GTEb8aOgc4H1KDfyVIScuYmP6I/osUxQ+fEV4nIJjewfbg5
         hZP/Hctw8Jq3EOnj8u90F0J3StoB+u68OymcOiYnENT6mjHWyiXzbmp+61SWVDbXfPjr
         ZIFO1Weg18Yr7tV6Mtd0EUIN2Wfv/EgQaP/TWlHsyDjHxTOr6pPZe58yIbEIEAgTxjcb
         TSe/xoVqraJjoAyLvWGH0PFKJRJF85M22eYrjIbA6H3mpJbFsdV/n1nbiMmLpP1hj1UZ
         frdQ==
X-Gm-Message-State: ACgBeo0qPcg04HBSqQqyTky8nfgngxTyaHBvRMtbM0pxMZunsiJq2GfZ
        siJLWgVjSTxA6ZZ3eyt+5w6XdkPFeazk/PDAEf9KtOEbIsk=
X-Google-Smtp-Source: AA6agR6DtXOM6A9F+F+WihEn/+gve3SE5/R2GdP9IOloutvPfePZUfGO5c9AE6bFTeWlB1l83WvgUFATiAcIWek1BmI=
X-Received: by 2002:ab0:6894:0:b0:384:d360:14b7 with SMTP id
 t20-20020ab06894000000b00384d36014b7mr917179uar.84.1660268069268; Thu, 11 Aug
 2022 18:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-6-lsahlber@redhat.com>
 <87leruudal.fsf@cjr.nz> <CAH2r5mvCuJM5z5nzfXW6Mkqgo4CWxoORUhsNT4ZtrjS=tVSJxg@mail.gmail.com>
 <CAH2r5mtXaJB02+zBZ3M2U75YKs308oZmcpgDMod5hbPt9MwCDw@mail.gmail.com> <CAH2r5mtEVXfhMva-5pz4GmjC0OTNoSVo0Pgr0n8S=kZFWBGj1Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtEVXfhMva-5pz4GmjC0OTNoSVo0Pgr0n8S=kZFWBGj1Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 20:34:18 -0500
Message-ID: <CAH2r5mtq=QjOR1_zHDjZ7rgQYGUiRv6GaGcupSQFjxBPKK46GQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from is_path_accessible
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And one more obvious thing ... this also fixes the problem where safe
caching gets unintionally turned off (deferred close, handle leases)
by users who disable actimeo (which is unsafe metadata caching).  So
setting actimeo=0 which some workloads do to make sure no stale
mtime/filesize would end up unintentionally hurting safe handle
caching (deferred close).

This timer should be controlled separately than actimeo

On Thu, Aug 11, 2022 at 8:26 PM Steve French <smfrench@gmail.com> wrote:
>
> forgot to mention the obvious - the way to tell that this would be
> helpful is simply looking at "/proc/fs/cifs/Stats" to see number of
> opens vs. other operations.   Can also see pretty easily from simple
> trace commands ("trace-cmd record -e smb3_open* smb3_close*") etc
>
> On Thu, Aug 11, 2022 at 7:57 PM Steve French <smfrench@gmail.com> wrote:
> >
> > updated patch attached
> >
> >
> > On Thu, Aug 11, 2022 at 7:56 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Tentatively merged this patch (after rebasing it and fixing a minor
> > > checkpatch problem).  Added Paulo's RB
> > >
> > > Skipped adding patch 4 though (cifs: Make tcon contain a wrapper
> > > structure cached_fids instead of cached_fid) - let me know if problem
> > > skipping that patch in the short term
> > >
> > > On Thu, Aug 11, 2022 at 8:20 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >
> > > > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > > >
> > > > > cfids will soon keep a list of cached fids so we should not access this
> > > > > directly from outside of cached_dir.c
> > > > >
> > > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > > ---
> > > > >  fs/cifs/cached_dir.c | 10 ++++++----
> > > > >  fs/cifs/cached_dir.h |  2 +-
> > > > >  fs/cifs/readdir.c    |  4 ++--
> > > > >  fs/cifs/smb2inode.c  |  2 +-
> > > > >  fs/cifs/smb2ops.c    | 18 ++++++++++++++----
> > > > >  5 files changed, 24 insertions(+), 12 deletions(-)
> > > >
> > > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
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
