Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32DEC32774
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiHYEja (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiHYEj1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:39:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB2D9DFA8
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:39:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bj12so20216067ejb.13
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8SCE35vbwTrRijrG104aTmaPv5mt8SOxLrOXZ7B14x4=;
        b=lHXiQlfpnUh+mSM40/C2vaMeAiNWys3EF/01EZKeyL/HFKGjQqpQwlmxh6ZQO5tE5y
         6gl4eFfrbDOYrbj8wnj982zZTd/LB0U0+DqA8bc/hzLH1HnkH6P54KXvflGmeWfbfDfq
         aqdfym7K5Ggrvs2IzjdBdWQI1hIq5ZIMMcDQYyQZ8+AXWNLoFIYrD2HHD42SNrfZLlh3
         X1z/3qlVk/HEdmz/YZMYZOIARL7odauadx+YT7vrkyNdA1W9M4X0E20HD9TxU8fdXAsl
         LOWC0nBL7oXeoSdNY3wmnlQ7meV1+pLmAyQ35zYsuDN/n0kX5bgo54dUT2TPm36uxV/B
         OKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8SCE35vbwTrRijrG104aTmaPv5mt8SOxLrOXZ7B14x4=;
        b=2bNnLuqCrV4q4JudNh6j910b3jRQLrA9/3UHwmhlW57HJZ1NrmWWusAqD9AO79FPWr
         ZxY9RaZsBE+rc0aDsEOwLPMzyZNgTTC8ivA7k1lF6mV360pxTprkLlA2BJKS8ugNeTny
         cPjhWMYjSakPx9nrDTZZCwNu2BaWc0/ZRYmqNoUAo9T6ehdGRk8hytin2GuviXjSNgEI
         LERrJz3shIye21rx74amV9/4MMJteaKQxx3N3cCHPmnmX3E79q/Gy28FbXwgLb1zq2I3
         8kq1KQnW+vKNexhOCxULwoZVbQF1rhdA6rOsiStoxm1A+QDId7MA9NgZ5bPhSzFBUxjq
         MGuw==
X-Gm-Message-State: ACgBeo2Mw/+ubUb5pb8L1g7k6Y5JouCOr1qdGDpbhQNQMJpPUnDWZmhl
        +CzPhDmRPZmSTlEyB+gQwnl1XeWtGSGOXuLmyIGWeQ2y
X-Google-Smtp-Source: AA6agR7pwwzTWTUU/Fn2gu0DmOxfcuFxHiY9kuzr23bspOTlOqkTvbj7eT+iXjrEqdK8xF06gGdcbwzDypo07C2T2Sg=
X-Received: by 2002:a17:907:1611:b0:73d:6d23:5787 with SMTP id
 hb17-20020a170907161100b0073d6d235787mr1242066ejc.231.1661402359246; Wed, 24
 Aug 2022 21:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220824002756.3659568-1-lsahlber@redhat.com> <20220824002756.3659568-7-lsahlber@redhat.com>
 <2cc221b2-6292-ffe0-5f47-5dfd9dacc95a@talpey.com>
In-Reply-To: <2cc221b2-6292-ffe0-5f47-5dfd9dacc95a@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Aug 2022 14:39:06 +1000
Message-ID: <CAN05THQ9Dev9s44M_XfmxOr3HZxuC_L-FWC5pOa-qxnOeVfxDQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] cifs: do not cache leased directories for longer than
 30 seconds
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 24 Aug 2022 at 23:58, Tom Talpey <tom@talpey.com> wrote:
>
> On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/cached_dir.c | 32 ++++++++++++++++++++++++++++++--
> >   fs/cifs/cached_dir.h |  2 ++
> >   2 files changed, 32 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > index f4d7700827b3..1c4a409bcb67 100644
> > --- a/fs/cifs/cached_dir.c
> > +++ b/fs/cifs/cached_dir.c
> > @@ -14,6 +14,7 @@
> >
> >   static struct cached_fid *init_cached_dir(const char *path);
> >   static void free_cached_dir(struct cached_fid *cfid);
> > +static void smb2_cached_lease_timeout(struct work_struct *work);
> >
> >   /*
> >    * Locking and reference count for cached directory handles:
> > @@ -321,6 +322,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       cfid->tcon = tcon;
> >       cfid->time = jiffies;
> >       cfid->is_open = true;
> > +     queue_delayed_work(cifsiod_wq, &cfid->lease_timeout, HZ * 30);
>
> Wouldn't it be more efficient to implement a laundromat? There
> will be MAX_CACHED_FIDS of these delayed workers, and the
> timing does not need to be precise (right?).

I was thinking that first but thought it would be easier to just use
delayed events on the pre-existing
work-queue. However, having two potentially racing work items turned
out to be as complex as
just having a separate thread for the tcon.
I will drop this patch for now and re-do it with a laundromat instead.
It will be more efficient
and I think it will make the logic a bit simpler too.

>
> Is it worth considering making HZ*30 into a tunable?

Maybe. I can add that when I re-spin this patch.
Recinding leases is super hard to get right. Recind them too quickly
and you miss out on potential performance.
Recind them too late and you hurt performance, at least for other clients.

Right now the caching is binary. It is either enabled, or fully disabled.
I would like to have timeouts like this to be auto-adjusted by the
module itself, because setting it "correctly"
or "optimally" will probably be super hard, to impossible, for the
average sysadmin.
Heck, I don't think I could even set a parameter like this correctly.
And that is even not taking into account that workloads change
dynamically over time so any fixed value will only
be "correct" for some/part of the time anyway. Sometimes these changes
occur over just a few minutes/hours so a fixed value is impossible to
come up with.

I think it would be possible to have this to be automatically and
dynamically adjusted.
I want to measure things like "how often do we re-open a directory
while holding a lease",   "how often is the lease broken by the
server"
and try to keep the first as high as possible while also have the
second as low, or zero.
And have this adjust automatically at runtime.

>
> Tom.
>
> > +     cfid->has_timeout = true;
> >       cfid->has_lease = true;
> >
> >   oshr_free:
> > @@ -447,6 +450,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> >               list_add(&cfid->entry, &entry);
> >               cfids->num_entries--;
> >               cfid->is_open = false;
> > +             cfid->has_timeout = false;
> >               /* To prevent race with smb2_cached_lease_break() */
> >               kref_get(&cfid->refcount);
> >       }
> > @@ -455,6 +459,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> >       list_for_each_entry_safe(cfid, q, &entry, entry) {
> >               cfid->on_list = false;
> >               list_del(&cfid->entry);
> > +             cancel_delayed_work_sync(&cfid->lease_timeout);
> >               cancel_work_sync(&cfid->lease_break);
> >               if (cfid->has_lease) {
> >                       /*
> > @@ -477,12 +482,34 @@ smb2_cached_lease_break(struct work_struct *work)
> >       struct cached_fid *cfid = container_of(work,
> >                               struct cached_fid, lease_break);
> >
> > +     cancel_delayed_work_sync(&cfid->lease_timeout);
> >       spin_lock(&cfid->cfids->cfid_list_lock);
> > +     if (!cfid->has_lease) {
> > +             spin_unlock(&cfid->cfids->cfid_list_lock);
> > +             return;
> > +     }
> >       cfid->has_lease = false;
> >       spin_unlock(&cfid->cfids->cfid_list_lock);
> >       kref_put(&cfid->refcount, smb2_close_cached_fid);
> >   }
> >
> > +static void
> > +smb2_cached_lease_timeout(struct work_struct *work)
> > +{
> > +     struct cached_fid *cfid = container_of(work,
> > +                             struct cached_fid, lease_timeout.work);
> > +
> > +     spin_lock(&cfid->cfids->cfid_list_lock);
> > +     if (!cfid->has_timeout || !cfid->on_list) {
> > +             spin_unlock(&cfid->cfids->cfid_list_lock);
> > +             return;
> > +     }
> > +     cfid->has_timeout = false;
> > +     spin_unlock(&cfid->cfids->cfid_list_lock);
> > +
> > +     queue_work(cifsiod_wq, &cfid->lease_break);
> > +}
> > +
> >   int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> >   {
> >       struct cached_fids *cfids = tcon->cfids;
> > @@ -506,9 +533,9 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> >                       cfid->on_list = false;
> >                       cfids->num_entries--;
> >
> > -                     queue_work(cifsiod_wq,
> > -                                &cfid->lease_break);
> > +                     cfid->has_timeout = false;
> >                       spin_unlock(&cfids->cfid_list_lock);
> > +                     queue_work(cifsiod_wq, &cfid->lease_break);
> >                       return true;
> >               }
> >       }
> > @@ -530,6 +557,7 @@ static struct cached_fid *init_cached_dir(const char *path)
> >       }
> >
> >       INIT_WORK(&cfid->lease_break, smb2_cached_lease_break);
> > +     INIT_DELAYED_WORK(&cfid->lease_timeout, smb2_cached_lease_timeout);
> >       INIT_LIST_HEAD(&cfid->entry);
> >       INIT_LIST_HEAD(&cfid->dirents.entries);
> >       mutex_init(&cfid->dirents.de_mutex);
> > diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> > index e536304ca2ce..813cd30f7ca3 100644
> > --- a/fs/cifs/cached_dir.h
> > +++ b/fs/cifs/cached_dir.h
> > @@ -35,6 +35,7 @@ struct cached_fid {
> >       struct cached_fids *cfids;
> >       const char *path;
> >       bool has_lease:1;
> > +     bool has_timeout:1;
> >       bool is_open:1;
> >       bool on_list:1;
> >       bool file_all_info_is_valid:1;
> > @@ -45,6 +46,7 @@ struct cached_fid {
> >       struct cifs_tcon *tcon;
> >       struct dentry *dentry;
> >       struct work_struct lease_break;
> > +     struct delayed_work lease_timeout;
> >       struct smb2_file_all_info file_all_info;
> >       struct cached_dirents dirents;
> >   };
