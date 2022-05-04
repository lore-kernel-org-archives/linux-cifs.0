Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EAEC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 01:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiEDBsJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 21:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiEDBsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 21:48:09 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CE628E3D
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 18:44:33 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id h10so125405ybc.4
        for <linux-cifs@vger.kernel.org>; Tue, 03 May 2022 18:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9EVMIlQwh4xBkzBQyFXhj70Xf9sRW3wT/frdEId3Ojc=;
        b=d4sniXll+teUsF3R01C3WPOPHjrhFhruYSAIM5x1Uxo+99GMtyTSJs0WwYtq1ylyo8
         Yw1zP5Tz8HAchc61rE0C+Heu4LkYzrVBA2EqWGRnOCJH5zeArGEojkJmnKOim18TAO/e
         63DNn1T7ibH0EOZm9r5UVtHlaOYnByW1c1ap+BGF3b6K27KxuI6wNPLMOOESirnKOkQI
         Yks2+5V96Wn1OIr6bCOZ1878kulQt6Q1u6llFiZb1pzQzZV83vjRG0FQR2D2myEDz+AN
         KVnCGygZibZ9RFSQjcy1vRGf7SeCdh/+3xUx0BZ6oVfjUeAAgRyUzdcaDJFnjRtwlrKA
         FxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9EVMIlQwh4xBkzBQyFXhj70Xf9sRW3wT/frdEId3Ojc=;
        b=5tlQPLszjWwqY/lgT4vy8BxRUufEgwXOtkfZlLmHYFIPkB9PVM6FFw1HCjn5wIcgXC
         XvOinGeAYX4Uc8Ka6nf9I36jNDkdEAFLlD1Xnk2WMqRUUU89YH8D7ntiH/xq56IG2EjT
         s0PqA3XW50OuIoEy/8MA6+N9J8UcV1Bx9fuLbE0pxyZaH2Qu6yYWN9YBEXB5U9EKFt73
         wOnM2VMqFdEGcXGeboVFHZzFkl3fbjJmxPbgvtxS7rmz11p0P4qqIqPVeti9iAA2xaMq
         93/fNmuvuG5xvIi0pA9aoMdnPEpNL2Od5UqVXomhH77nf55yLN3x4cNrPBxthuWq0ucA
         /XyQ==
X-Gm-Message-State: AOAM5303R4ISdRtBBVUdoDW2cgMGPZoCDK1NdWINCY9/OjXftaekaD4p
        me6Mg3UQW5Jy0iTPz9EKdPGDpOXo+GBPyNdIFiqKu6id
X-Google-Smtp-Source: ABdhPJyULIR1Adaq4qgyDqkm+Qc4D2RZOUs/zyjMFs1uD0tksbfjqbImKbiQNX/d0mAN5dobzIljur7WNmKbC3yNOdU=
X-Received: by 2002:a05:6902:84:b0:63d:4a3d:eb5 with SMTP id
 h4-20020a056902008400b0063d4a3d0eb5mr15853364ybs.145.1651628673037; Tue, 03
 May 2022 18:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220503070959.2276616-1-lsahlber@redhat.com> <20220503070959.2276616-2-lsahlber@redhat.com>
 <87bkwe2mtf.fsf@cjr.nz>
In-Reply-To: <87bkwe2mtf.fsf@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 4 May 2022 11:44:21 +1000
Message-ID: <CAN05THQ3r5sY9Ro3-Rf4Td+ucXSJhj+bBEoa7XBVOAXQoPWzRQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good idea,   will resend. Thanks.

On Wed, 4 May 2022 at 11:08, Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Ronnie,
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 1929e80c09ee..8b3fbe6b3580 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -840,9 +840,112 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
> >       return rc;
> >  }
> >
> > +static bool emit_cached_dirents(struct cached_dirents *cde,
> > +                             struct dir_context *ctx)
> > +{
> > +     struct list_head *tmp;
> > +     struct cached_dirent *dirent;
> > +     int rc;
> > +
> > +     list_for_each(tmp, &cde->entries) {
> > +             dirent = list_entry(tmp, struct cached_dirent, entry);
>
> What about list_for_each_entry()?
>
> > +static void add_cached_dirent(struct cached_dirents *cde,
> > +                           struct dir_context *ctx,
> > +                           const char *name, int namelen,
> > +                           struct cifs_fattr *fattr)
> > +{
> > +     struct cached_dirent *de;
> > +
> > +     if (cde->ctx != ctx)
> > +             return;
> > +     if (cde->is_valid || cde->is_failed)
> > +             return;
> > +     if (ctx->pos != cde->pos) {
> > +             cde->is_failed = 1;
> > +             return;
> > +     }
> > +     de = kzalloc(sizeof(*de), GFP_ATOMIC);
> > +     if (de == NULL) {
> > +             cde->is_failed = 1;
> > +             return;
> > +     }
> > +     de->name = kzalloc(namelen + 1, GFP_ATOMIC);
> > +     if (de->name == NULL) {
> > +             kfree(de);
> > +             cde->is_failed = 1;
> > +             return;
> > +     }
> > +     memcpy(de->name, name, namelen);
>
> Replace the above kzalloc() & memcpy() with kstrndup()?
>
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index d6aaeff4a30a..10170266f44b 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -699,6 +699,8 @@ smb2_close_cached_fid(struct kref *ref)
> >  {
> >       struct cached_fid *cfid = container_of(ref, struct cached_fid,
> >                                              refcount);
> > +     struct list_head *pos, *q;
> > +     struct cached_dirent *dirent;
> >
> >       if (cfid->is_valid) {
> >               cifs_dbg(FYI, "clear cached root file handle\n");
> > @@ -718,6 +720,21 @@ smb2_close_cached_fid(struct kref *ref)
> >               dput(cfid->dentry);
> >               cfid->dentry = NULL;
> >       }
> > +     /*
> > +      * Delete all cached dirent names
> > +      */
> > +     mutex_lock(&cfid->dirents.de_mutex);
> > +     list_for_each_safe(pos, q, &cfid->dirents.entries) {
> > +             dirent = list_entry(pos, struct cached_dirent, entry);
>
> list_for_each_entry_safe()?
>
> Nice job!  Looks good to me,
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
