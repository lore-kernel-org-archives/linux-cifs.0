Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563A7EB64D9
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 05:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjGGFbo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 01:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGGFbo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 01:31:44 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCC9171D
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jul 2023 22:31:42 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b63e5f94f1so18399261fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jul 2023 22:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688707900; x=1691299900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8lEGmP5DZSmJs5FD8hM8Weq3ts5IYRO/CxxlJInrSX0=;
        b=cjmMBeZqScUIh3JnI+zE6lC0FyMhytkGkFIcKWb31Bfh/lV6KhfmYMecQGm9JUfaOj
         ROKxcHCwEtCHXCGGBOvAeo7fWdGfwzwbqf389ocTFmqmIEPe7146wK2yCcoILclMBrj9
         HmWwJsyFxsTcsr41s8lCyzq29UT0b/wZ2/G+89QeP4JLWi+FyTxwdJjDgc5JaG113H/v
         RnWIq3tF0zacIGObfJ6BculQF1GLo0pxEbibWp3V0ANWPNI2zuI5F7JPv2TvF+DGEnas
         6qiF2P6nJfoU5h0cWlJjp8//v4C/SEdhnq+cDxaidFzl4J9KZHJnmxb1f2gDl1xtWqNi
         HO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688707900; x=1691299900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8lEGmP5DZSmJs5FD8hM8Weq3ts5IYRO/CxxlJInrSX0=;
        b=JJufP0hVif1Si7x+sUwWT8YROBQhA5Ia9zao15F9JqUK4Mb/AovsUFq5b6PjO2bPxH
         d+K2rwJI8hJdwoWv277GaLa1aLWmYVvCdmzVqoZHB41HoatLMhMfD8u5q+FZ/TC2MiQv
         lj4AI7GvvbwUhPjg1hL5q+hbEHboH06lU538bBHLDxyTXNIbcDI9dGCIF9QwRuTPdbC7
         /hm846QlRyZH3/lq61lZSDjPYnaBxtbS6RcDIoEe6C5EKImwzSWjoYWgoDStXeJFU+8L
         hMq1n7dbCJ5F7LGqLdMa2DsdDvKL2tc9eS6PmGUSwIs3Kq+tlIELG60FlUpzk9q0+dPq
         cyPw==
X-Gm-Message-State: ABy/qLbodKnAzPSkZT95IKxreVddbK8LcGtEk8H+689GwEYoWTJNlZzh
        61Rr7Yx9LyMl7M10Jx9kdifed/pMITCNAoWullc=
X-Google-Smtp-Source: APBJJlEYlzbdCjW7Zo9gmQ1eiPEvMWorukytGN2ej0kHkH4fgDpLy4KBEfptr8u9F6P8esptR3t9/OotLnBZ5nxtMgc=
X-Received: by 2002:a2e:95d4:0:b0:2b6:da61:d5b9 with SMTP id
 y20-20020a2e95d4000000b002b6da61d5b9mr1545538ljh.14.1688707900148; Thu, 06
 Jul 2023 22:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com> <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
In-Reply-To: <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 7 Jul 2023 11:01:28 +0530
Message-ID: <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jul 6, 2023 at 8:51=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> updated to fix two checkpatch warnings (see attached) and tentatively
> merged into for-next pending review/testing
>
>
> On Wed, Jul 5, 2023 at 9:32=E2=80=AFPM Ronnie Sahlberg <lsahlber@redhat.c=
om> wrote:
> >
> > and drop cached directories after 30 seconds
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/smb/client/cached_dir.c | 67 ++++++++++++++++++++++++++++++++++++++
> >  fs/smb/client/cached_dir.h |  1 +
> >  2 files changed, 68 insertions(+)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index bfc964b36c72..f567eea0a456 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -568,6 +568,53 @@ static void free_cached_dir(struct cached_fid *cfi=
d)
> >         kfree(cfid);
> >  }
> >
> > +static int
> > +cifs_cfids_laundromat_thread(void *p)
> > +{
> > +       struct cached_fids *cfids =3D p;
> > +       struct cached_fid *cfid, *q;
> > +       struct list_head entry;
> > +
> > +       while (!kthread_should_stop()) {
> > +               ssleep(1);
> > +               INIT_LIST_HEAD(&entry);
> > +               if (kthread_should_stop())
> > +                       return 0;
> > +               spin_lock(&cfids->cfid_list_lock);
> > +               list_for_each_entry_safe(cfid, q, &cfids->entries, entr=
y) {
> > +                       if (jiffies > cfid->time + HZ * 30) {
> > +                               list_del(&cfid->entry);
> > +                               list_add(&cfid->entry, &entry);
> > +                               cfids->num_entries--;
> > +                       }
> > +               }
> > +               spin_unlock(&cfids->cfid_list_lock);
> > +
> > +               list_for_each_entry_safe(cfid, q, &entry, entry) {
> > +                       cfid->on_list =3D false;
> > +                       list_del(&cfid->entry);
> > +                       /*
> > +                        * Cancel, and wait for the work to finish in
> > +                        * case we are racing with it.
> > +                        */
> > +                       cancel_work_sync(&cfid->lease_break);
> > +                       if (cfid->has_lease) {
> > +                               /*
> > +                                * We lease has not yet been cancelled =
from
> > +                                * the server so we need to drop the re=
ference.
> > +                                */
> > +                               spin_lock(&cfids->cfid_list_lock);
> > +                               cfid->has_lease =3D false;
> > +                               spin_unlock(&cfids->cfid_list_lock);
> > +                               kref_put(&cfid->refcount, smb2_close_ca=
ched_fid);
> > +                       }
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +
> >  struct cached_fids *init_cached_dirs(void)
> >  {
> >         struct cached_fids *cfids;
> > @@ -577,6 +624,20 @@ struct cached_fids *init_cached_dirs(void)
> >                 return NULL;
> >         spin_lock_init(&cfids->cfid_list_lock);
> >         INIT_LIST_HEAD(&cfids->entries);
> > +
> > +       /*
> > +        * since we're in a cifs function already, we know that
> > +        * this will succeed. No need for try_module_get().
> > +        */
> > +       __module_get(THIS_MODULE);
> > +       cfids->laundromat =3D kthread_run(cifs_cfids_laundromat_thread,
> > +                                 cfids, "cifsd-cfid-laundromat");
> > +       if (IS_ERR(cfids->laundromat)) {
> > +               cifs_dbg(VFS, "Failed to start cfids laundromat thread.=
\n");
> > +               kfree(cfids);
> > +               module_put(THIS_MODULE);
> > +               return NULL;
> > +       }
> >         return cfids;
> >  }
> >
> > @@ -589,6 +650,12 @@ void free_cached_dirs(struct cached_fids *cfids)
> >         struct cached_fid *cfid, *q;
> >         LIST_HEAD(entry);
> >
> > +       if (cfids->laundromat) {
> > +               kthread_stop(cfids->laundromat);
> > +               cfids->laundromat =3D NULL;
> > +               module_put(THIS_MODULE);
> > +       }
> > +
> >         spin_lock(&cfids->cfid_list_lock);
> >         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >                 cfid->on_list =3D false;
> > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > index 2f4e764c9ca9..facc9b154d00 100644
> > --- a/fs/smb/client/cached_dir.h
> > +++ b/fs/smb/client/cached_dir.h
> > @@ -57,6 +57,7 @@ struct cached_fids {
> >         spinlock_t cfid_list_lock;
> >         int num_entries;
> >         struct list_head entries;
> > +       struct task_struct *laundromat;
> >  };
> >
> >  extern struct cached_fids *init_cached_dirs(void);
> > --
> > 2.35.3
> >
>
>
> --
> Thanks,
>
> Steve

Hi Ronnie,

Why do we need this?
We only cache dirents if we have the parent directory lease. As long
as we have the lease, why can't we continue to cache these?

--=20
Regards,
Shyam
