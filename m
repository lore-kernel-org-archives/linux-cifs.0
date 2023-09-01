Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52ACCCA0FE4
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 16:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjIAQcF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjIAQcF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 12:32:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE29110EB
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 09:32:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5230a22cfd1so2975335a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 Sep 2023 09:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693585919; x=1694190719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOo+djdRKa+BS1iDPeWkyNGDuy7twuwo/H2b3euhk4Q=;
        b=Y3dpEJytl0nGAWO5QExCca0TjBJgtWqX8YHWL8J3WinQuvg7As3t/9EzHerhg/ziam
         o3QfUxy0LohthnuzD5npJSvjERA40V21Fi87a2LCc2wD0ufS1G6ClEmyzxi9ioDlOQsp
         4bWfZgKEGytPN7t0Z3WVJjN1bXCcogWx5XMwoBCeKKWVhxg5lo+6+e6c1ie1uLJGzANQ
         /t2cefQD1B+oYp/L5peu3+3jcu7DkU2Ff0eZ1cPPhFNdOGc08JyW6ViMNYy97Mqi09fP
         ht6aGUklg9Wk4VoaD72yR4yu4lUl6W+TBFGhoVUje3N7oaWjLamknQS26PVTF/leRhKU
         uUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693585919; x=1694190719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOo+djdRKa+BS1iDPeWkyNGDuy7twuwo/H2b3euhk4Q=;
        b=DEEq05OomGkcM4Wf8AD/FPk4W4wNcuxMj5YpAIAG2lV9S1H1t8tpWA0fK6eF2kiuYF
         mpKqdgqOGI+dYgSBEBvumP+AHra5F5aRW9Wbkjn5zeptqLMRFqrNHEBOI55zfum3xuWR
         wzWzqw5xCztjLDleFXNTwjp3/qxXUD+hsk2Ee538Y7zd69R+0waIxQgkp+sipCEchnuT
         PHjlqLipeP5TMhqtxgqoh6qyW6AWPcfxOlHhRWm0/SFpxEzTrrroGDhjK+tpov6ffemp
         mULvFQEqEpqRhNoqcNFb9HECTFLkS6c9P9UwmpzqkADYVI9BHl91w65GWYWziHixlrGB
         zRjg==
X-Gm-Message-State: AOJu0Yya3zde98Sbd7rKX1MKeWkpCKL5fAawgYdmBHd1qm3t3yHln68c
        R2aiwMV6PL0ZHgfLVFqVkXV1kCn8d6NhCuDpxS/LGZKSNTo=
X-Google-Smtp-Source: AGHT+IHVAU3YMtvw8zsemRrqdblqKWS3ZLSfY5fLsNBMP5sZP4gCzDrAxpJmHOLLzKGmejqztoFHtow1yyiMzIlXJ4I=
X-Received: by 2002:aa7:d40b:0:b0:527:251e:1be7 with SMTP id
 z11-20020aa7d40b000000b00527251e1be7mr2456497edq.11.1693585919000; Fri, 01
 Sep 2023 09:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
 <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org> <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
In-Reply-To: <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 2 Sep 2023 02:31:47 +1000
Message-ID: <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     Steve French <smfrench@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Maybe just re-set the timestamp every time the cached directory is reopened=
,
that way a hot directory will remain in cache indefinitely but one
that is cold will
quickly time out and make space for something else to be chaced.

On Sat, 2 Sept 2023 at 02:22, Steve French <smfrench@gmail.com> wrote:
>
> I lean toward eventually increasing the default to something more
> similar to Windows (or at least 5 minutes) to improve some common
> scenarios, but it looks like Windows sets it to 10 minutes based on
> this link, but first want to make sure we are grabbing leases in all
> of the obvious places (and not unnecessarily breaking leases - there
> are a few places where we aren't sending the lease key and we also are
> missing setting the parent lease key)
>
> See "DirectoryCacheEntriesMax" iand "DormantDirectoryTimeout" in
> LanmanWorkstation config.  The description
> https://learn.microsoft.com/en-us/windows-server/administration/performan=
ce-tuning/role/file-server/is
> of some of the related parms was a little vague but presumably
> DirectoryCacheEntriesMax is the number of directories (16) that are
> cached by default (ie number of directory leases that are held) and
> DormantDirectoryTimeout (default 600 seconds) is how long they are
> held.
>
> On Fri, Sep 1, 2023 at 4:04=E2=80=AFAM Ralph Boehme <slow@samba.org> wrot=
e:
> >
> > Just wondering: how does a Windows client handle this? Does it use a
> > timeout too? Which one? 60 seconds still seem rather short.
> >
> > -slow
> >
> > On 8/31/23 05:52, Steve French wrote:
> > > updated patch with Barath's suggestion of renaming it from
> > > /sys/module/cifs/parameters/max_dir_cache to
> > > /sys/module/cifs/parameters/dir_cache_timeout and also changed it so
> > > if set to zero we disable
> > > directory entry caching.
> > >
> > > See attached.
> > >
> > > On Sun, Aug 27, 2023 at 12:12=E2=80=AFAM Steve French <smfrench@gmail=
.com> wrote:
> > >>
> > >> Currently with directory leases we cache directory contents for a fi=
xed period
> > >> of time (default 30 seconds) but for many workloads this is too shor=
t.  Allow
> > >> configuring the maximum amount of time directory entries are cached =
when a
> > >> directory lease is held on that directory (and set default timeout t=
o
> > >> 60 seconds).
> > >> Add module load parm "max_dir_cache"
> > >>
> > >> For example to set the timeout to 10 minutes you would do:
> > >>
> > >>    echo 600 > /sys/module/cifs/parameters/max_dir_cache
> > >>
> > >> Signed-off-by: Steve French <stfrench@microsoft.com>
> > >> ---
> > >>   fs/smb/client/cached_dir.c |  2 +-
> > >>   fs/smb/client/cifsfs.c     | 12 ++++++++++++
> > >>   fs/smb/client/cifsglob.h   |  1 +
> > >>   3 files changed, 14 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > >> index 2d5e9a9d5b8b..e48a902efd52 100644
> > >> --- a/fs/smb/client/cached_dir.c
> > >> +++ b/fs/smb/client/cached_dir.c
> > >> @@ -582,7 +582,7 @@ cifs_cfids_laundromat_thread(void *p)
> > >>    return 0;
> > >>    spin_lock(&cfids->cfid_list_lock);
> > >>    list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> > >> - if (time_after(jiffies, cfid->time + HZ * 30)) {
> > >> + if (time_after(jiffies, cfid->time + HZ * max_dir_cache)) {
> > >>    list_del(&cfid->entry);
> > >>    list_add(&cfid->entry, &entry);
> > >>    cfids->num_entries--;
> > >> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > >> index d49fd2bf71b0..7a89718d2a59 100644
> > >> --- a/fs/smb/client/cifsfs.c
> > >> +++ b/fs/smb/client/cifsfs.c
> > >> @@ -117,6 +117,10 @@ module_param(cifs_max_pending, uint, 0444);
> > >>   MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serve=
r for "
> > >>       "CIFS/SMB1 dialect (N/A for SMB3) "
> > >>       "Default: 32767 Range: 2 to 32767.");
> > >> +unsigned int max_dir_cache =3D 60;
> > >> +module_param(max_dir_cache, uint, 0644);
> > >> +MODULE_PARM_DESC(max_dir_cache, "Number of seconds to cache directo=
ry
> > >> contents for which we have a lease. Default: 60 "
> > >> + "Range: 1 to 65000 seconds");
> > >>   #ifdef CONFIG_CIFS_STATS2
> > >>   unsigned int slow_rsp_threshold =3D 1;
> > >>   module_param(slow_rsp_threshold, uint, 0644);
> > >> @@ -1679,6 +1683,14 @@ init_cifs(void)
> > >>    CIFS_MAX_REQ);
> > >>    }
> > >>
> > >> + if (max_dir_cache < 1) {
> > >> + max_dir_cache =3D 1;
> > >> + cifs_dbg(VFS, "max_dir_cache timeout set to min of 1 second\n");
> > >> + } else if (max_dir_cache > 65000) {
> > >> + max_dir_cache =3D 65000;
> > >> + cifs_dbg(VFS, "max_dir_cache timeout set to max of 65000 seconds\n=
");
> > >> + }
> > >> +
> > >>    cifsiod_wq =3D alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_REC=
LAIM, 0);
> > >>    if (!cifsiod_wq) {
> > >>    rc =3D -ENOMEM;
> > >> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > >> index 259e231f8b4f..7aeeaa260cce 100644
> > >> --- a/fs/smb/client/cifsglob.h
> > >> +++ b/fs/smb/client/cifsglob.h
> > >> @@ -2016,6 +2016,7 @@ extern unsigned int CIFSMaxBufSize;  /* max si=
ze
> > >> not including hdr */
> > >>   extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf =
pool */
> > >>   extern unsigned int cifs_min_small;  /* min size of small buf pool=
 */
> > >>   extern unsigned int cifs_max_pending; /* MAX requests at once to s=
erver*/
> > >> +extern unsigned int max_dir_cache; /* max time for directory lease
> > >> caching of dir */
> > >>   extern bool disable_legacy_dialects;  /* forbid vers=3D1.0 and ver=
s=3D2.0 mounts */
> > >>   extern atomic_t mid_count;
> > >>
> > >>
> > >> --
> > >> Thanks,
> > >>
> > >> Steve
> > >
> > >
> > >
> >
>
>
> --
> Thanks,
>
> Steve
