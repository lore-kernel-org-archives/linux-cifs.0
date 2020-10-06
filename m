Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B21C41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7A4208B6
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7FdIn7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJFFJg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFFJg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:09:36 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE570C0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 22:09:35 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id v60so8076734ybi.10
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 22:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWIPH4Ee1yHg+nqKnrVgHEto5B2lP3uAj/DaMHNdjdc=;
        b=U7FdIn7zMxKhTz/d33U1w8UGRXUe/oXNRudcBiaV+Ju71JxfkStUzpps7xMblVfxjq
         MfLXHeBP97g9FJahwxp4KATqJVGrFiTQakyO5bSZyjuuas0juJk00LhIWuzkXKgd7DMw
         KwWOVyMQKeaWA0lw0vQizodjp7kuyrlgFIcDiiVZr46NWeSPhom9v4mHUiSi9q25EB/9
         LMe5rdx2kaIjsIh3eKQlOqtVtCiNqcXIAuGAnmZmfSB5hXjjTdiDVPRghcJSi6qCBzsR
         Mbf4sXGRzO8T0PXW5K0Cl7Uqt2efVrV79KBirVn1mpT00KPypZgrfnERP7Z9rfCPqq5N
         pE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWIPH4Ee1yHg+nqKnrVgHEto5B2lP3uAj/DaMHNdjdc=;
        b=U/SNmeakD3GjAgKoVFA5YQzlrrCC7m1tT+2FzK20MZF1wNvbfH1aSKBd62iZ5VuXjz
         V6E89FdPz1HjFBqEuRTHzEj3XCSdSdoIosd8JCQX5RkVnaoc7lkOT3olaU+bRvepFHWh
         AeFSfjEAw9Rh4VUw8AD+Ms0AcPOe51KJZk6Em8qb3wt3QCFcRR5J6qxWgzK1bLAFuteB
         j/uYanfotWHMiXCS7/rySQd3igsTv/Ew4XHuLbcqOW+cghZbU6EhvMLm0lmLxl25bfU+
         zwfkx1CsRC+o4BAeSnp1uS2S1eEfkG+g4ni4KfTxlIxeKETFjMuz9e+ehkNNKjqu6qjw
         mVTw==
X-Gm-Message-State: AOAM533qCmKdh24+VFZuPyrbmzvzsxsLe2sYyBPf37nT2IEoUANmfmzd
        DPZYqpaiet4kgDJaeFfj+lvYyeT+CEi3D0p8BmJIX7bHm5c=
X-Google-Smtp-Source: ABdhPJxQ20FJ4DBs+jj8sSvjuQq3KyBsA5JcEtSJ3j6KcpqS1BD1zrIid2+savODsdtueMSNm8prccucTmKe82VNHzw=
X-Received: by 2002:a25:cbd1:: with SMTP id b200mr4841391ybg.293.1601960973346;
 Mon, 05 Oct 2020 22:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201006022623.21026-1-lsahlber@redhat.com> <CAH2r5mtGS0pX0nvzAk6hgrfocHzxUQLiidBi8WzU4a5FQ5v6CQ@mail.gmail.com>
 <CANT5p=rpvB=PrCB143eJh0Y7wsE-KRqei981uz_Nq+A4hFJhSg@mail.gmail.com>
In-Reply-To: <CANT5p=rpvB=PrCB143eJh0Y7wsE-KRqei981uz_Nq+A4hFJhSg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 6 Oct 2020 10:39:26 +0530
Message-ID: <CANT5p=rUoL0DYrePmL3Wv_uztHjJA90HqDx_Y2obvcUVhhU0UA@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ignore my second question. I got the answer in your description.

On Tue, Oct 6, 2020 at 10:36 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Question: What causes cifs_setattr_* to return -EINTR?
> Does an infinite reattempt make sense here? Or should we give up after
> N attempts?
> Also, should we cifsFYI log before we re-attempt?
>
> Regards,
> Shyam
>
> On Tue, Oct 6, 2020 at 10:03 AM Steve French <smfrench@gmail.com> wrote:
> >
> > tentatively merged into cifs-2.6.git for-next
> >
> > On Mon, Oct 5, 2020 at 9:26 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > > RHBZ: 1848178
> > >
> > > Some calls that set attributes, like utimensat(), are not supposed to return
> > > -EINTR and thus do not have handlers for this in glibc which causes us
> > > to leak -EINTR to the applications which are also unprepared to handle it.
> > >
> > > For example tar will break if utimensat() return -EINTR and abort unpacking
> > > the archive. Other applications may break too.
> > >
> > > To handle this we add checks, and retry, for -EINTR in cifs_setattr()
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/inode.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > > index 3989d08396ac..74ed12f2c8aa 100644
> > > --- a/fs/cifs/inode.c
> > > +++ b/fs/cifs/inode.c
> > > @@ -2879,13 +2879,17 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
> > >  {
> > >         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
> > >         struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
> > > +       int rc;
> > >
> > > -       if (pTcon->unix_ext)
> > > -               return cifs_setattr_unix(direntry, attrs);
> > > -
> > > -       return cifs_setattr_nounix(direntry, attrs);
> > > +       do {
> > > +               if (pTcon->unix_ext)
> > > +                       rc = cifs_setattr_unix(direntry, attrs);
> > > +               else
> > > +                       rc = cifs_setattr_nounix(direntry, attrs);
> > > +       } while (rc == -EINTR);
> > >
> > >         /* BB: add cifs_setattr_legacy for really old servers */
> > > +       return rc;
> > >  }
> > >
> > >  #if 0
> > > --
> > > 2.13.6
> > >
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
> -Shyam



-- 
-Shyam
