Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DE2C41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10F9208B6
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkZe8zCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgJFFGK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgJFFGK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:06:10 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A801C0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 22:06:10 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 67so8095227ybt.6
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 22:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmjgs+LGEBmIE/Lr7FWW7nzS4TWr05irSuQw5/AcBH8=;
        b=TkZe8zCoDEZK8hBg1HRPq6jEgWgRsvPBtsBWG5rROkXJp5O9mN2K9n7dgXwZlvBVS0
         Kthsk/HxEWb6109rfKBzTfmahTSDJWNITzQK4nSXIDZ8Nbw7N93ieRn2XwemfZLPrrY6
         Pa0sJbRnA5IU+i+jOQgiK4Ri1j1sKG+DTuRsOXBxYwphB+0z8tyvykuHNyNpM/HDOiax
         4zt2VnQrIDgAXt5XIhhOTdtal2SH6ei0excwNd4ufvUZb2mNP3ONTkow1/GvQ15V65AZ
         ouHoONIMq0zT/6jkhxY4d+BUjtf8k2cWh99ss4H+iZtH7CNMJdmDTfPeXQd5s22ba3VM
         HuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmjgs+LGEBmIE/Lr7FWW7nzS4TWr05irSuQw5/AcBH8=;
        b=ZYELMs1vNnfpo2SgAlFpQgLNZxHjFGn6OJ3vkkhOP4bbjRGoy57amY4Td1CpVIqA3x
         8Pd0FObV7DhK7qFm4VZVdpo0sKth79oXHS3ikMBv5/1fSZXAbjcTJ8CUJYpwHNSpM50b
         JBg7NMJ+EpleFpra5d2CSI2jPENwOst5L6PALwg/Nkt4fCIHq5idTT5cV2kJDfuYSwA0
         z6Xg2OiRf1psHxam70ZvkKSunOyYAZEPikWVTFZ8yEJen3RDDD9NwkIzORtH6wg/SpwA
         3IzMpoEKZLkpTlsAtQW9oduq7SoV6Ku9l+wWb5njXQtBsMbqEET/WFMShLnrE9fSFogS
         gCXA==
X-Gm-Message-State: AOAM531rvObjOtNm/jkgM51wvmeNI2fAq6B1F2S6VbpROmjD21p6gM40
        /eJHgO760BOC9rNMRMhkNpkTXRJCvTCAN7KXAyk=
X-Google-Smtp-Source: ABdhPJznRD8usbQWZE16zMBOBJVBV0g3Sdpb9qkUan2fDnDG7PC55ifWbJgAS9TTjsCNPnydMBvFXG65Au00zv78Q/A=
X-Received: by 2002:a25:ad16:: with SMTP id y22mr4043308ybi.331.1601960769217;
 Mon, 05 Oct 2020 22:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201006022623.21026-1-lsahlber@redhat.com> <CAH2r5mtGS0pX0nvzAk6hgrfocHzxUQLiidBi8WzU4a5FQ5v6CQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtGS0pX0nvzAk6hgrfocHzxUQLiidBi8WzU4a5FQ5v6CQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 6 Oct 2020 10:36:02 +0530
Message-ID: <CANT5p=rpvB=PrCB143eJh0Y7wsE-KRqei981uz_Nq+A4hFJhSg@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Question: What causes cifs_setattr_* to return -EINTR?
Does an infinite reattempt make sense here? Or should we give up after
N attempts?
Also, should we cifsFYI log before we re-attempt?

Regards,
Shyam

On Tue, Oct 6, 2020 at 10:03 AM Steve French <smfrench@gmail.com> wrote:
>
> tentatively merged into cifs-2.6.git for-next
>
> On Mon, Oct 5, 2020 at 9:26 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > RHBZ: 1848178
> >
> > Some calls that set attributes, like utimensat(), are not supposed to return
> > -EINTR and thus do not have handlers for this in glibc which causes us
> > to leak -EINTR to the applications which are also unprepared to handle it.
> >
> > For example tar will break if utimensat() return -EINTR and abort unpacking
> > the archive. Other applications may break too.
> >
> > To handle this we add checks, and retry, for -EINTR in cifs_setattr()
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/inode.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 3989d08396ac..74ed12f2c8aa 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2879,13 +2879,17 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
> >  {
> >         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
> >         struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
> > +       int rc;
> >
> > -       if (pTcon->unix_ext)
> > -               return cifs_setattr_unix(direntry, attrs);
> > -
> > -       return cifs_setattr_nounix(direntry, attrs);
> > +       do {
> > +               if (pTcon->unix_ext)
> > +                       rc = cifs_setattr_unix(direntry, attrs);
> > +               else
> > +                       rc = cifs_setattr_nounix(direntry, attrs);
> > +       } while (rc == -EINTR);
> >
> >         /* BB: add cifs_setattr_legacy for really old servers */
> > +       return rc;
> >  }
> >
> >  #if 0
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve



-- 
-Shyam
