Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD245C05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 05:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBQFrR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 00:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQFrR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 00:47:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C782498B6
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:47:15 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id eg30so8198edb.7
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XB7h+cmZtvYgAba2kFYYNfPzL/JUxgaBKXdnhmUiumQ=;
        b=bAb38fAhP4mhGMKOH0qlW9w7L2Q0wDPOTt+Cl07Q4/RFwfhtljLSnueKnQDTwX6+SE
         ESbfV5kClJP3Y+wc0xR7KVIUejRF4IwJOBLgxkc2Yap/GnI12IBQGBWc4RIi9rp/bxmZ
         91eIwC7gcSiihjSWmTXMDfLoMp9kE2ki3AKzRzhzdV/MrCB7PP6hOdY1Ck/9z+XJ5oJK
         cl/NKtFFYaPXb0vBGzZADh/4IgR04/APmM9IzHADsORKj2rXysFz3osF8+AvaZfBKZio
         U0PtYdMLIDtxPuBq3am51XUFBe5hz8h/g4bftAcso950/SO/JeNx3yFkZMvZbqmc/BzJ
         BKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XB7h+cmZtvYgAba2kFYYNfPzL/JUxgaBKXdnhmUiumQ=;
        b=8IprZrK+4FT50l7Fs9xbqVc11+NMkknr9fjEfe8fBtrk3eIEq9brkFTyhEXEo9SDvM
         bvIzju/mVAkUhUqryeyCyh8v/LS+aJaW4Q+KOf0+LLb23Um9FzBBGAGJ+3Qe3nl4tQZm
         zU2IJIAbkQvFZtsMYCV3uJVMf99TFl88ohaltFFa74yBx9d5J9jpljwNskqu4k9Tng6r
         z3poA8KynCdYblKbwRYrww6j2cv3jN1fnhKsvO7rlA5c3Gl0bM6Rj02UkoeWjH3gPjPY
         3c7WZnFBred+TALi30kPyeVovy+D+uk57OEJnjCExQCc7rHctHGM04BgDbiHqfHKvSmU
         cUqg==
X-Gm-Message-State: AO0yUKWOz4LkO0NV/v1tY/GYUgWrvNijFarp4RRkCJYVJI9dXM6XcECd
        7Uoiv0VqdsexNFmedxptIc7wGtZDYs+2h3rIFaY=
X-Google-Smtp-Source: AK7set/f4WvLtADHl3rZq4RHSEHDLDuPOgxQqcwz01p4spdLfNJWj0nU5R74BLqzbGEDSmqKc0SyjkJ/DfDdHGJ+ZNY=
X-Received: by 2002:a50:f697:0:b0:4ac:c838:5b4 with SMTP id
 d23-20020a50f697000000b004acc83805b4mr262151edn.8.1676612833628; Thu, 16 Feb
 2023 21:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20230217033501.2591185-1-lsahlber@redhat.com> <20230217033501.2591185-2-lsahlber@redhat.com>
 <CAH2r5mv54i_ASAGPpfw2bC0wqUZ=P47vRmK2NWt=t5b69KJA+A@mail.gmail.com>
In-Reply-To: <CAH2r5mv54i_ASAGPpfw2bC0wqUZ=P47vRmK2NWt=t5b69KJA+A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 17 Feb 2023 15:47:01 +1000
Message-ID: <CAN05THTXsk3v6Uk65y3ryJPjurpRnfuhk0e5=90Hypd6canu2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: return a single-use cfid if we did not get a lease
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

At a later time we can make additional changes so that we ALWAYS
return a single-use cfid to all callers IFF we could SMB2_open() the
file for the cfid.
Right now any concurrent opens on a cfid for a path that does not have
cfid->has_lease will return NULL and have the application retry a
normal SMB2_open.

We can change this further to also return single-use cfids for
concurrent use and this would have the benefit that we can avoid
having to do the
"try getting a cfid if it fails try a normal smb2_open conditional" in
the callers.
It would simplify the code in the callers.  It is not an urgent
cleanup but something we should do in the future.


On Fri, 17 Feb 2023 at 15:41, Steve French <smfrench@gmail.com> wrote:
>
> Added Reviewed-by Bharath and merged into cifs-2.6.git for-next
>
> On Thu, Feb 16, 2023 at 9:35 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > If we did not get a lease we can still return a single use cfid to the caller.
> > The cfid will not have has_lease set and will thus not be shared with any
> > other concurrent users and will be freed immediately when the caller
> > drops the handle.
> >
> > This avoids extra roundtrips for servers that do not support directory leases
> > where they would first fail to get a cfid with a lease and then fallback
> > to try a normal SMB2_open()
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cached_dir.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > index 6672f1a0acd7..27ae908e4903 100644
> > --- a/fs/cifs/cached_dir.c
> > +++ b/fs/cifs/cached_dir.c
> > @@ -14,6 +14,7 @@
> >
> >  static struct cached_fid *init_cached_dir(const char *path);
> >  static void free_cached_dir(struct cached_fid *cfid);
> > +static void smb2_close_cached_fid(struct kref *ref);
> >
> >  static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
> >                                                     const char *path,
> > @@ -220,6 +221,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >                 }
> >                 goto oshr_free;
> >         }
> > +       cfid->tcon = tcon;
> >         cfid->is_open = true;
> >
> >         o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> > @@ -232,7 +234,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >         if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
> >                 goto oshr_free;
> >
> > -
> >         smb2_parse_contexts(server, o_rsp,
> >                             &oparms.fid->epoch,
> >                             oparms.fid->lease_key, &oplock,
> > @@ -259,7 +260,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >                 }
> >         }
> >         cfid->dentry = dentry;
> > -       cfid->tcon = tcon;
> >         cfid->time = jiffies;
> >         cfid->has_lease = true;
> >
> > @@ -270,7 +270,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> >         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> >         spin_lock(&cfids->cfid_list_lock);
> > -       if (!cfid->has_lease) {
> > +       if (rc && !cfid->has_lease) {
> >                 if (cfid->on_list) {
> >                         list_del(&cfid->entry);
> >                         cfid->on_list = false;
> > @@ -279,6 +279,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >                 rc = -ENOENT;
> >         }
> >         spin_unlock(&cfids->cfid_list_lock);
> > +       if (!rc && !cfid->has_lease) {
> > +               /*
> > +                * We are guaranteed to have two references at this point.
> > +                * One for the caller and one for a potential lease.
> > +                * Release the Lease-ref so that the directory will be closed
> > +                * when the caller closes the cached handle.
> > +                */
> > +               kref_put(&cfid->refcount, smb2_close_cached_fid);
> > +       }
> >         if (rc) {
> >                 if (cfid->is_open)
> >                         SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> > @@ -339,6 +348,7 @@ smb2_close_cached_fid(struct kref *ref)
> >         if (cfid->is_open) {
> >                 SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> >                            cfid->fid.volatile_fid);
> > +               atomic_dec(&cfid->tcon->num_remote_opens);
> >         }
> >
> >         free_cached_dir(cfid);
> > --
> > 2.35.3
> >
>
>
> --
> Thanks,
>
> Steve
