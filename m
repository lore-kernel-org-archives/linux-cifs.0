Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92FFC25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 01:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiHLB07 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiHLB06 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 21:26:58 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D27E5587
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:26:57 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id v128so19962155vsb.10
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YOLi6MB9/rpHn4ika/1lHfdTv/HWj8Aa4PLqVy45Qnk=;
        b=Sy5UPgoSKkV2+E0AeHn5EDYCYQIxuPP6d+sk0mDZcZXmZUCPnEeoxbtMZnNlECisyn
         15YO3QD1gP2B2kjc3mKPpkitMS/X+uHDpT0cebAUQBeq55Py5r8KazoEvsKH4mo9nMWZ
         YDzdAjcVTOkNRxvB2hfo+r6VUtDEkE6eF4TrsRyQK1pHnxAxcxRi5CN+dIzBNcqC+1Un
         krKHxB4O3smBXEO3a2oZOnBnH1ILWQk2NahgHPysYS3xgO+pveyvMETCwu/C6JEtUOA6
         zKlGZFKJZAqS/yhJNFjvM8YQ15++7aIIgew5va9zcGJ2Y1+nM8oC12ge47OwvrgDwz3i
         n/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YOLi6MB9/rpHn4ika/1lHfdTv/HWj8Aa4PLqVy45Qnk=;
        b=xR4RqKnrmGao8J7pYmEBZK0GivpgLWtC7lOQ9jT/rqpna4Bq/jdvezqvdIXw1Qdk1b
         g2TDVAT9GRNiE/PMAL/0bMzvM8MUGRY7GJmBsiQjRKtSLL1cD3ugTgd11sp1AwNnNdi4
         Bs8vCMN+tNZ1st/U/IS61FCn7SnQwwzn73YHH+dzvb+hR5CxpHSDsJRLBUMfAPxZsFFa
         3rnye7Mcx7f8/mA58C38I7cIJwCsqxAPw5ySm+3wzL4bXCIAGY01Rx2WalapOqhi3+oa
         Zieyu4UpAwbANCNsBTGr8ZTPK4gaOWFsAVBhdqaQZpOWuEf7Jc7hqyzPnvrNMgg6W3OG
         zEBA==
X-Gm-Message-State: ACgBeo2rSXhlulPpvfG9JbAkzBtgCqMp1J3cinJ+Ni192gqLH22kwqgD
        AUTFS385RkoUxfZjVjsoFoAAYJoKwGg7KIPwPae5wtdwkVg=
X-Google-Smtp-Source: AA6agR7Mydx6sd/M/xOLuvO64iZpEafGf0iJ2b+N+TNkpzuOVXvZ4X/UpYp0CWe94QnYAvW513HOQ4MoNhy323ZDy1w=
X-Received: by 2002:a67:ce90:0:b0:388:4905:1533 with SMTP id
 c16-20020a67ce90000000b0038849051533mr891360vse.17.1660267616602; Thu, 11 Aug
 2022 18:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-6-lsahlber@redhat.com>
 <87leruudal.fsf@cjr.nz> <CAH2r5mvCuJM5z5nzfXW6Mkqgo4CWxoORUhsNT4ZtrjS=tVSJxg@mail.gmail.com>
 <CAH2r5mtXaJB02+zBZ3M2U75YKs308oZmcpgDMod5hbPt9MwCDw@mail.gmail.com>
In-Reply-To: <CAH2r5mtXaJB02+zBZ3M2U75YKs308oZmcpgDMod5hbPt9MwCDw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 20:26:45 -0500
Message-ID: <CAH2r5mtEVXfhMva-5pz4GmjC0OTNoSVo0Pgr0n8S=kZFWBGj1Q@mail.gmail.com>
Subject: Re: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from is_path_accessible
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

forgot to mention the obvious - the way to tell that this would be
helpful is simply looking at "/proc/fs/cifs/Stats" to see number of
opens vs. other operations.   Can also see pretty easily from simple
trace commands ("trace-cmd record -e smb3_open* smb3_close*") etc

On Thu, Aug 11, 2022 at 7:57 PM Steve French <smfrench@gmail.com> wrote:
>
> updated patch attached
>
>
> On Thu, Aug 11, 2022 at 7:56 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Tentatively merged this patch (after rebasing it and fixing a minor
> > checkpatch problem).  Added Paulo's RB
> >
> > Skipped adding patch 4 though (cifs: Make tcon contain a wrapper
> > structure cached_fids instead of cached_fid) - let me know if problem
> > skipping that patch in the short term
> >
> > On Thu, Aug 11, 2022 at 8:20 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > >
> > > > cfids will soon keep a list of cached fids so we should not access this
> > > > directly from outside of cached_dir.c
> > > >
> > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > ---
> > > >  fs/cifs/cached_dir.c | 10 ++++++----
> > > >  fs/cifs/cached_dir.h |  2 +-
> > > >  fs/cifs/readdir.c    |  4 ++--
> > > >  fs/cifs/smb2inode.c  |  2 +-
> > > >  fs/cifs/smb2ops.c    | 18 ++++++++++++++----
> > > >  5 files changed, 24 insertions(+), 12 deletions(-)
> > >
> > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
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
