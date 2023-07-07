Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0569CC0015E
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 06:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjGGGh3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 02:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjGGGh2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 02:37:28 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8854D1FF5
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jul 2023 23:37:21 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4faaaa476a9so2389928e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jul 2023 23:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688711839; x=1691303839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bxm4xbyz2rHpaAArM3cxa4pbfdkRcORcE/eHuycLH9g=;
        b=kY5+weHHHI4zuBxYeX1+XfMs5RlRtqGcy/gJI3dgu4X7GtX+s86iaAUZIzDgvGQnzO
         72jBx7OoFLhaqTVyzkno3F+Apub0KDVBo+2SIX/Dhz7jTajQXhtK8eFbMP3ABzRRtF+J
         3nfySkeXmARUV7sqkRnYzimu/qH1h91i5XHC7OaW9bPFqu/ZDeRWNGMv5/q3CiRLEvuY
         FVXdcerkVgyD1L1uP9YtA0um2G2T/yy3Hq0nyLut97HGxed4KXA3aWR/5rViZtJEPvww
         hBrhEarJfegZj+nAxrol9ImWKE+mvhn3p9tYXqCLeXt9mDH+ye77hwWSeMWWIJVAg+KW
         exvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688711839; x=1691303839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bxm4xbyz2rHpaAArM3cxa4pbfdkRcORcE/eHuycLH9g=;
        b=KgmPupocMHUt6FJEMuG4lqjFj9HmLMNF2WD9x98FUj2Igwak/FCj+UY6qk5jXeilbd
         RQXSMtGT+nOlxYIddlbOtYzCWh8UVSLJiXnyJSpbs6EVV8V6/r8sRWin9J2iIdaGd5nh
         /qg+GYNDLQsa40WyqQyGbb89+Xnnfy/4QpQ4hojYcA7i2W903bJvTFr9mCnPXa24rVqU
         e2wAWYd4UY74M1rQyvXLr2/ijDUaYALK2nMx39cMysxKgLx9jGdWNEFnQRiOmSADLxJd
         ayOQDf6uPqGBsglKllk8e4ebK4NDvU1jCuOPsr+27WbhX3zb7jcB3RndbAh5gpNBVCJs
         LKvg==
X-Gm-Message-State: ABy/qLbQt53sq8xhClpoDqr3sC1gqF90g2WaAA7Oh+cKFK2vL7pj3+Kq
        dBqkrBEwwxbTS6ig5ZcBhthjUPdvnne9XGcM310UFhVJI4i9zQ==
X-Google-Smtp-Source: APBJJlGKtTrOnkd14oRIehbecPKXf91cmysA14y985rF1eXQaKu19yjIxCZYtERjrbNvY59b1quAiWpkE4yJhBbufpM=
X-Received: by 2002:a19:5e51:0:b0:4fb:7618:bac7 with SMTP id
 z17-20020a195e51000000b004fb7618bac7mr2855012lfi.64.1688711839059; Thu, 06
 Jul 2023 23:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com> <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
 <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com> <CAN05THSjxZ=_L-Ho8tffz9xRfc8R8kCWf-_GtYUe=yFNEC2bhw@mail.gmail.com>
In-Reply-To: <CAN05THSjxZ=_L-Ho8tffz9xRfc8R8kCWf-_GtYUe=yFNEC2bhw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 7 Jul 2023 12:07:07 +0530
Message-ID: <CANT5p=qxZjxpqx49BO7G-8=se2_5gEPyLOi_W-sUDm0p7VhbEQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 7, 2023 at 11:20=E2=80=AFAM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> We can only cache a limited amount of entries.
> We need to force entries to be dropped from the cache at regular
> intervals to make room for potential new entries/different
> directories.
>
> Access patterns change over time and what is the "hot" directory will
> also change over time so we need to drop entries to make sure that
> when some directory becomes hot there will be decent chance that it
> will be able to become cached.
>
> If a directory becomes "cold" we no longer want it to take up entries
> in our cache.
>

Makes sense.

However, the value of MAX_CACHED_FIDS to 16 seems very restrictive.
And as Steve suggested, 30s expiry seems very aggressive.
I think we can increase both.

Also, I was wondering how do we handle cleanup of cfids when VFS
decides to free the inode (maybe due to memory crunch?).

Regards,
Shyam

> regards
> ronnie sahlberg
>
>
> On Fri, 7 Jul 2023 at 15:37, Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
> >
> > On Thu, Jul 6, 2023 at 8:51=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> > >
> > > updated to fix two checkpatch warnings (see attached) and tentatively
> > > merged into for-next pending review/testing
> > >
> > >
> > > On Wed, Jul 5, 2023 at 9:32=E2=80=AFPM Ronnie Sahlberg <lsahlber@redh=
at.com> wrote:
> > > >
> > > > and drop cached directories after 30 seconds
> > > >
> > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > ---
> > > >  fs/smb/client/cached_dir.c | 67 ++++++++++++++++++++++++++++++++++=
++++
> > > >  fs/smb/client/cached_dir.h |  1 +
> > > >  2 files changed, 68 insertions(+)
> > > >
> > > > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.=
c
> > > > index bfc964b36c72..f567eea0a456 100644
> > > > --- a/fs/smb/client/cached_dir.c
> > > > +++ b/fs/smb/client/cached_dir.c
> > > > @@ -568,6 +568,53 @@ static void free_cached_dir(struct cached_fid =
*cfid)
> > > >         kfree(cfid);
> > > >  }
> > > >
> > > > +static int
> > > > +cifs_cfids_laundromat_thread(void *p)
> > > > +{
> > > > +       struct cached_fids *cfids =3D p;
> > > > +       struct cached_fid *cfid, *q;
> > > > +       struct list_head entry;
> > > > +
> > > > +       while (!kthread_should_stop()) {
> > > > +               ssleep(1);
> > > > +               INIT_LIST_HEAD(&entry);
> > > > +               if (kthread_should_stop())
> > > > +                       return 0;
> > > > +               spin_lock(&cfids->cfid_list_lock);
> > > > +               list_for_each_entry_safe(cfid, q, &cfids->entries, =
entry) {
> > > > +                       if (jiffies > cfid->time + HZ * 30) {
> > > > +                               list_del(&cfid->entry);
> > > > +                               list_add(&cfid->entry, &entry);
> > > > +                               cfids->num_entries--;
> > > > +                       }
> > > > +               }
> > > > +               spin_unlock(&cfids->cfid_list_lock);
> > > > +
> > > > +               list_for_each_entry_safe(cfid, q, &entry, entry) {
> > > > +                       cfid->on_list =3D false;
> > > > +                       list_del(&cfid->entry);
> > > > +                       /*
> > > > +                        * Cancel, and wait for the work to finish =
in
> > > > +                        * case we are racing with it.
> > > > +                        */
> > > > +                       cancel_work_sync(&cfid->lease_break);
> > > > +                       if (cfid->has_lease) {
> > > > +                               /*
> > > > +                                * We lease has not yet been cancel=
led from
> > > > +                                * the server so we need to drop th=
e reference.
> > > > +                                */
> > > > +                               spin_lock(&cfids->cfid_list_lock);
> > > > +                               cfid->has_lease =3D false;
> > > > +                               spin_unlock(&cfids->cfid_list_lock)=
;
> > > > +                               kref_put(&cfid->refcount, smb2_clos=
e_cached_fid);
> > > > +                       }
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +
> > > >  struct cached_fids *init_cached_dirs(void)
> > > >  {
> > > >         struct cached_fids *cfids;
> > > > @@ -577,6 +624,20 @@ struct cached_fids *init_cached_dirs(void)
> > > >                 return NULL;
> > > >         spin_lock_init(&cfids->cfid_list_lock);
> > > >         INIT_LIST_HEAD(&cfids->entries);
> > > > +
> > > > +       /*
> > > > +        * since we're in a cifs function already, we know that
> > > > +        * this will succeed. No need for try_module_get().
> > > > +        */
> > > > +       __module_get(THIS_MODULE);
> > > > +       cfids->laundromat =3D kthread_run(cifs_cfids_laundromat_thr=
ead,
> > > > +                                 cfids, "cifsd-cfid-laundromat");
> > > > +       if (IS_ERR(cfids->laundromat)) {
> > > > +               cifs_dbg(VFS, "Failed to start cfids laundromat thr=
ead.\n");
> > > > +               kfree(cfids);
> > > > +               module_put(THIS_MODULE);
> > > > +               return NULL;
> > > > +       }
> > > >         return cfids;
> > > >  }
> > > >
> > > > @@ -589,6 +650,12 @@ void free_cached_dirs(struct cached_fids *cfid=
s)
> > > >         struct cached_fid *cfid, *q;
> > > >         LIST_HEAD(entry);
> > > >
> > > > +       if (cfids->laundromat) {
> > > > +               kthread_stop(cfids->laundromat);
> > > > +               cfids->laundromat =3D NULL;
> > > > +               module_put(THIS_MODULE);
> > > > +       }
> > > > +
> > > >         spin_lock(&cfids->cfid_list_lock);
> > > >         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> > > >                 cfid->on_list =3D false;
> > > > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.=
h
> > > > index 2f4e764c9ca9..facc9b154d00 100644
> > > > --- a/fs/smb/client/cached_dir.h
> > > > +++ b/fs/smb/client/cached_dir.h
> > > > @@ -57,6 +57,7 @@ struct cached_fids {
> > > >         spinlock_t cfid_list_lock;
> > > >         int num_entries;
> > > >         struct list_head entries;
> > > > +       struct task_struct *laundromat;
> > > >  };
> > > >
> > > >  extern struct cached_fids *init_cached_dirs(void);
> > > > --
> > > > 2.35.3
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Hi Ronnie,
> >
> > Why do we need this?
> > We only cache dirents if we have the parent directory lease. As long
> > as we have the lease, why can't we continue to cache these?
> >
> > --
> > Regards,
> > Shyam



--=20
Regards,
Shyam
