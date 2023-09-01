Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C4ACA0FE5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 16:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjIAQWr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjIAQWq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 12:22:46 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACEEE7E
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 09:22:43 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2bd0a5a5abbso35932821fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 Sep 2023 09:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693585361; x=1694190161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6cTlE0HLHRi98ADLlawoHJ1tcLC21jdZt2JiCUf18Aw=;
        b=qq2bCDOsINKuUDidae9bFkV30ceY0c3g0la+rOs+Pj3+Q1NQ+gqIkvYtIp1AfuA6Iv
         A7gGQh03b6v0Kw1ahlGiCOT9fClv0yq7kHiEO+n3nAH4GJQ5FI4p5sM2pLDh9Z5wrP4Z
         uuZNvJZg6z1OJx6XzL3v9gwg/5mFIbVu4s96jr039VbFGMMG6hRTfaq67EXciKm3Y2FZ
         4TgDMVzt/DXCyNMrMflnX2MhIN1JyRXD9M1CnQdlmPzifkfKJ6RyBcY0dKndKXuZ5p9Z
         lArBUlPuAy5F/wSh+Ea1vHXAxbxKTBRqNbsA0ZXfkXDaHEk73eGiaOA7BD6Y5bENgGer
         wWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693585361; x=1694190161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cTlE0HLHRi98ADLlawoHJ1tcLC21jdZt2JiCUf18Aw=;
        b=Em1aSrYhrUH4TzFQHZTSyYmmnXDQotJEK4ud3pL69kj38Um+QCC6rvRDJbwxofH/nZ
         gvqEkOJ4g8CO87CXl9fguDheY8+XiLJ516uVOXwxLSFMmGErBqeJ9rePC5b33bKP9pwJ
         d+1gfRMbWExI1UnJer4JZBYMblRHGk0KQtaaQN5/8HCButEWxk86GeRco35RqbKd/vgM
         AGdpR3DCGMfDwTUxey4jMIDHgxrqyvqmTn3LUkXyS9MwflBTnHUW1CNo2mcVyqrf7Usg
         8od5ygMbHIFElAl3CRq3b5fkkZD7vruveVKehnqN/IUm3F8lsh2qAnNGfWlNtIfx9sVo
         fs3w==
X-Gm-Message-State: AOJu0YzrGMhNLhAmALzhGR+70/VNffdfql1GUs9+S4ual9q3xEbetPGB
        Ah1v/Fo32muNmFycLwKEtEN7uKO/7vdxM/injYc=
X-Google-Smtp-Source: AGHT+IG3XMHw5mfKd3Souh0JvNymKq4LheIZ+KwLc68UlHiz6VHrh6dli3mdWDmYk7gM5+hgsy2v1/44mVUzaS9lVcE=
X-Received: by 2002:a2e:3e15:0:b0:2bd:ddf:8aa6 with SMTP id
 l21-20020a2e3e15000000b002bd0ddf8aa6mr1972190lja.23.1693585361055; Fri, 01
 Sep 2023 09:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com> <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org>
In-Reply-To: <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Sep 2023 11:22:30 -0500
Message-ID: <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     Ralph Boehme <slow@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I lean toward eventually increasing the default to something more
similar to Windows (or at least 5 minutes) to improve some common
scenarios, but it looks like Windows sets it to 10 minutes based on
this link, but first want to make sure we are grabbing leases in all
of the obvious places (and not unnecessarily breaking leases - there
are a few places where we aren't sending the lease key and we also are
missing setting the parent lease key)

See "DirectoryCacheEntriesMax" iand "DormantDirectoryTimeout" in
LanmanWorkstation config.  The description
https://learn.microsoft.com/en-us/windows-server/administration/performance=
-tuning/role/file-server/is
of some of the related parms was a little vague but presumably
DirectoryCacheEntriesMax is the number of directories (16) that are
cached by default (ie number of directory leases that are held) and
DormantDirectoryTimeout (default 600 seconds) is how long they are
held.

On Fri, Sep 1, 2023 at 4:04=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote:
>
> Just wondering: how does a Windows client handle this? Does it use a
> timeout too? Which one? 60 seconds still seem rather short.
>
> -slow
>
> On 8/31/23 05:52, Steve French wrote:
> > updated patch with Barath's suggestion of renaming it from
> > /sys/module/cifs/parameters/max_dir_cache to
> > /sys/module/cifs/parameters/dir_cache_timeout and also changed it so
> > if set to zero we disable
> > directory entry caching.
> >
> > See attached.
> >
> > On Sun, Aug 27, 2023 at 12:12=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> >>
> >> Currently with directory leases we cache directory contents for a fixe=
d period
> >> of time (default 30 seconds) but for many workloads this is too short.=
  Allow
> >> configuring the maximum amount of time directory entries are cached wh=
en a
> >> directory lease is held on that directory (and set default timeout to
> >> 60 seconds).
> >> Add module load parm "max_dir_cache"
> >>
> >> For example to set the timeout to 10 minutes you would do:
> >>
> >>    echo 600 > /sys/module/cifs/parameters/max_dir_cache
> >>
> >> Signed-off-by: Steve French <stfrench@microsoft.com>
> >> ---
> >>   fs/smb/client/cached_dir.c |  2 +-
> >>   fs/smb/client/cifsfs.c     | 12 ++++++++++++
> >>   fs/smb/client/cifsglob.h   |  1 +
> >>   3 files changed, 14 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >> index 2d5e9a9d5b8b..e48a902efd52 100644
> >> --- a/fs/smb/client/cached_dir.c
> >> +++ b/fs/smb/client/cached_dir.c
> >> @@ -582,7 +582,7 @@ cifs_cfids_laundromat_thread(void *p)
> >>    return 0;
> >>    spin_lock(&cfids->cfid_list_lock);
> >>    list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >> - if (time_after(jiffies, cfid->time + HZ * 30)) {
> >> + if (time_after(jiffies, cfid->time + HZ * max_dir_cache)) {
> >>    list_del(&cfid->entry);
> >>    list_add(&cfid->entry, &entry);
> >>    cfids->num_entries--;
> >> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> >> index d49fd2bf71b0..7a89718d2a59 100644
> >> --- a/fs/smb/client/cifsfs.c
> >> +++ b/fs/smb/client/cifsfs.c
> >> @@ -117,6 +117,10 @@ module_param(cifs_max_pending, uint, 0444);
> >>   MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server =
for "
> >>       "CIFS/SMB1 dialect (N/A for SMB3) "
> >>       "Default: 32767 Range: 2 to 32767.");
> >> +unsigned int max_dir_cache =3D 60;
> >> +module_param(max_dir_cache, uint, 0644);
> >> +MODULE_PARM_DESC(max_dir_cache, "Number of seconds to cache directory
> >> contents for which we have a lease. Default: 60 "
> >> + "Range: 1 to 65000 seconds");
> >>   #ifdef CONFIG_CIFS_STATS2
> >>   unsigned int slow_rsp_threshold =3D 1;
> >>   module_param(slow_rsp_threshold, uint, 0644);
> >> @@ -1679,6 +1683,14 @@ init_cifs(void)
> >>    CIFS_MAX_REQ);
> >>    }
> >>
> >> + if (max_dir_cache < 1) {
> >> + max_dir_cache =3D 1;
> >> + cifs_dbg(VFS, "max_dir_cache timeout set to min of 1 second\n");
> >> + } else if (max_dir_cache > 65000) {
> >> + max_dir_cache =3D 65000;
> >> + cifs_dbg(VFS, "max_dir_cache timeout set to max of 65000 seconds\n")=
;
> >> + }
> >> +
> >>    cifsiod_wq =3D alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLA=
IM, 0);
> >>    if (!cifsiod_wq) {
> >>    rc =3D -ENOMEM;
> >> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> >> index 259e231f8b4f..7aeeaa260cce 100644
> >> --- a/fs/smb/client/cifsglob.h
> >> +++ b/fs/smb/client/cifsglob.h
> >> @@ -2016,6 +2016,7 @@ extern unsigned int CIFSMaxBufSize;  /* max size
> >> not including hdr */
> >>   extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf po=
ol */
> >>   extern unsigned int cifs_min_small;  /* min size of small buf pool *=
/
> >>   extern unsigned int cifs_max_pending; /* MAX requests at once to ser=
ver*/
> >> +extern unsigned int max_dir_cache; /* max time for directory lease
> >> caching of dir */
> >>   extern bool disable_legacy_dialects;  /* forbid vers=3D1.0 and vers=
=3D2.0 mounts */
> >>   extern atomic_t mid_count;
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
>


--=20
Thanks,

Steve
