Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29252EB64D9
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 05:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGGFuh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 01:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjGGFuf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 01:50:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFAD1BC9
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jul 2023 22:50:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-98e39784a85so505377366b.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jul 2023 22:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688709032; x=1691301032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWuoqq81Hs9WW02IDnOPKUQ4tNU7V+kgY0Uj3d7a/wI=;
        b=YMhpNBpC9HRFk67YXDBpcvNh91raLfgbQO28eb9xovrUUCwfbx4tuQdELdeMkNuLhJ
         cD4XZXIGOGj+zAQAyPOYCGSXE1cVNRaBZHt8vbayVxuoDglRd4Op380N+H9rk44nzZWq
         pw9G33BDeJZ/kGtAcd97Fh2YKHYksjVqIpPqqMdlqaLThN6S4FX+mvVnC3satyELT+vu
         1WfiP0Y1+J59XxJUzRiikie4ZL47bJUvV/sjsNF6n6lFCTiGjOCgaYY3BeAHrJdFzHM0
         xc7VL8yY4IW/YmzCCoMoOfEVefCVvbkufeoITdGXKL4Dz7STbDe0pSF0EOFyBsF2OrCb
         Idbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688709032; x=1691301032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWuoqq81Hs9WW02IDnOPKUQ4tNU7V+kgY0Uj3d7a/wI=;
        b=i0COvNV/wjeo3Cj8A/+QLPqg2JLmTyNV2e5UYzU++n7fDqyxu6FQnQjlKYyWrtT9+r
         mFvz4SKZ0N11k7e9etEAaIKFkEY8hVOy+gjna95HQziAQp0VFe7jDFhqmJK/szzqXGvC
         HppTD7xOPc7V9p2fPbYLiipWYPVJIiQrJvmtiApLt1aMNYoH3NUq0IDBuaO3m/VF//Qq
         WybSunL7CqA0m4MU/iC+K3XwssmFtCVMmfIB+wbxfm21rBxSyGm3tsL4wps97teFBUU7
         OfHbycsBbVchPrmzyxbr+Wwtw+9ONc4ie/m7G3faOrbaGnwoct3DY49uBaSVt/0Dbda5
         6EiQ==
X-Gm-Message-State: ABy/qLbRNIMZhFTdbFtB97virogrPL4SpvrV5ztMJIYHE7qqCvizyjxo
        cBLK0WeQgkmZyfxCoW6w5NobUlqffewwWo8TUMeC4uFe
X-Google-Smtp-Source: APBJJlHh1Wmc62PuCnWuXIZzG3nak6RyQFRcUg8vC93S+1q/WTvQ9uPmjKFnoXwgHiSVtfbR+rFvPwo5rc6sVXo3bCs=
X-Received: by 2002:a17:906:4fc7:b0:98d:f2c9:a1eb with SMTP id
 i7-20020a1709064fc700b0098df2c9a1ebmr6924361ejw.24.1688709031635; Thu, 06 Jul
 2023 22:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com> <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
 <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com>
In-Reply-To: <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 7 Jul 2023 15:50:18 +1000
Message-ID: <CAN05THSjxZ=_L-Ho8tffz9xRfc8R8kCWf-_GtYUe=yFNEC2bhw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can only cache a limited amount of entries.
We need to force entries to be dropped from the cache at regular
intervals to make room for potential new entries/different
directories.

Access patterns change over time and what is the "hot" directory will
also change over time so we need to drop entries to make sure that
when some directory becomes hot there will be decent chance that it
will be able to become cached.

If a directory becomes "cold" we no longer want it to take up entries
in our cache.

regards
ronnie sahlberg


On Fri, 7 Jul 2023 at 15:37, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Thu, Jul 6, 2023 at 8:51=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
> >
> > updated to fix two checkpatch warnings (see attached) and tentatively
> > merged into for-next pending review/testing
> >
> >
> > On Wed, Jul 5, 2023 at 9:32=E2=80=AFPM Ronnie Sahlberg <lsahlber@redhat=
.com> wrote:
> > >
> > > and drop cached directories after 30 seconds
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/smb/client/cached_dir.c | 67 ++++++++++++++++++++++++++++++++++++=
++
> > >  fs/smb/client/cached_dir.h |  1 +
> > >  2 files changed, 68 insertions(+)
> > >
> > > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > > index bfc964b36c72..f567eea0a456 100644
> > > --- a/fs/smb/client/cached_dir.c
> > > +++ b/fs/smb/client/cached_dir.c
> > > @@ -568,6 +568,53 @@ static void free_cached_dir(struct cached_fid *c=
fid)
> > >         kfree(cfid);
> > >  }
> > >
> > > +static int
> > > +cifs_cfids_laundromat_thread(void *p)
> > > +{
> > > +       struct cached_fids *cfids =3D p;
> > > +       struct cached_fid *cfid, *q;
> > > +       struct list_head entry;
> > > +
> > > +       while (!kthread_should_stop()) {
> > > +               ssleep(1);
> > > +               INIT_LIST_HEAD(&entry);
> > > +               if (kthread_should_stop())
> > > +                       return 0;
> > > +               spin_lock(&cfids->cfid_list_lock);
> > > +               list_for_each_entry_safe(cfid, q, &cfids->entries, en=
try) {
> > > +                       if (jiffies > cfid->time + HZ * 30) {
> > > +                               list_del(&cfid->entry);
> > > +                               list_add(&cfid->entry, &entry);
> > > +                               cfids->num_entries--;
> > > +                       }
> > > +               }
> > > +               spin_unlock(&cfids->cfid_list_lock);
> > > +
> > > +               list_for_each_entry_safe(cfid, q, &entry, entry) {
> > > +                       cfid->on_list =3D false;
> > > +                       list_del(&cfid->entry);
> > > +                       /*
> > > +                        * Cancel, and wait for the work to finish in
> > > +                        * case we are racing with it.
> > > +                        */
> > > +                       cancel_work_sync(&cfid->lease_break);
> > > +                       if (cfid->has_lease) {
> > > +                               /*
> > > +                                * We lease has not yet been cancelle=
d from
> > > +                                * the server so we need to drop the =
reference.
> > > +                                */
> > > +                               spin_lock(&cfids->cfid_list_lock);
> > > +                               cfid->has_lease =3D false;
> > > +                               spin_unlock(&cfids->cfid_list_lock);
> > > +                               kref_put(&cfid->refcount, smb2_close_=
cached_fid);
> > > +                       }
> > > +               }
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +
> > >  struct cached_fids *init_cached_dirs(void)
> > >  {
> > >         struct cached_fids *cfids;
> > > @@ -577,6 +624,20 @@ struct cached_fids *init_cached_dirs(void)
> > >                 return NULL;
> > >         spin_lock_init(&cfids->cfid_list_lock);
> > >         INIT_LIST_HEAD(&cfids->entries);
> > > +
> > > +       /*
> > > +        * since we're in a cifs function already, we know that
> > > +        * this will succeed. No need for try_module_get().
> > > +        */
> > > +       __module_get(THIS_MODULE);
> > > +       cfids->laundromat =3D kthread_run(cifs_cfids_laundromat_threa=
d,
> > > +                                 cfids, "cifsd-cfid-laundromat");
> > > +       if (IS_ERR(cfids->laundromat)) {
> > > +               cifs_dbg(VFS, "Failed to start cfids laundromat threa=
d.\n");
> > > +               kfree(cfids);
> > > +               module_put(THIS_MODULE);
> > > +               return NULL;
> > > +       }
> > >         return cfids;
> > >  }
> > >
> > > @@ -589,6 +650,12 @@ void free_cached_dirs(struct cached_fids *cfids)
> > >         struct cached_fid *cfid, *q;
> > >         LIST_HEAD(entry);
> > >
> > > +       if (cfids->laundromat) {
> > > +               kthread_stop(cfids->laundromat);
> > > +               cfids->laundromat =3D NULL;
> > > +               module_put(THIS_MODULE);
> > > +       }
> > > +
> > >         spin_lock(&cfids->cfid_list_lock);
> > >         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> > >                 cfid->on_list =3D false;
> > > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > > index 2f4e764c9ca9..facc9b154d00 100644
> > > --- a/fs/smb/client/cached_dir.h
> > > +++ b/fs/smb/client/cached_dir.h
> > > @@ -57,6 +57,7 @@ struct cached_fids {
> > >         spinlock_t cfid_list_lock;
> > >         int num_entries;
> > >         struct list_head entries;
> > > +       struct task_struct *laundromat;
> > >  };
> > >
> > >  extern struct cached_fids *init_cached_dirs(void);
> > > --
> > > 2.35.3
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Ronnie,
>
> Why do we need this?
> We only cache dirents if we have the parent directory lease. As long
> as we have the lease, why can't we continue to cache these?
>
> --
> Regards,
> Shyam
