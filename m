Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6938C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 05:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5AA20811
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 05:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lk4/Y71y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbfC1F1U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 01:27:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42259 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfC1F1T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Mar 2019 01:27:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id b74so11407714qkg.9
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 22:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftPIJftprKdfQUKJeUUgtNcdfH6EfIQiCVApi2b06vI=;
        b=lk4/Y71ysiEreZruEHIt8+eAbOll5N3bqjJe/qm64lsIvCpYC2ShpG8gMdPI402iO3
         /bDsFdI+vNeKox86TAhE6GEZVZ+waqp/7Skk5BdHU3mEnP7jm6dXaYNJECEliJoKnNYX
         fSB1Qv5ZovJXncO4/VkV8nDUjs6fjDvbH/dTPZmNlVDGvBV9gcPYvEnMDxki2p0eakvT
         BbGR3V4Ld5bHq/1Q1FTF5nT84RkMug+EatOVZaRAiBtWrm+dBUYiKxXkif8YZ1x+t6cu
         k7wYgmzAuighZ+YMx8pny6fo2JInnwCreOAUWTtov47XrXEYSuRqVZXixHG8HCGmPsYv
         Uc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftPIJftprKdfQUKJeUUgtNcdfH6EfIQiCVApi2b06vI=;
        b=JWRqIAGOT9ljSvE7gXoUOaYtgRxk7aKs5UUYDETD3rwqOXM0elwabfukVCDGlTDyCq
         DTba5ZuzThLtbSDM8ZlHJc6CfIzZE+0cL0URdIFD+iNeMjPDklrq7+eJsSk6x7+MHMu9
         F/ytN23w3RrdfgKlLSXFbdN0mNvKskYgexBhzXfBwyL5HzJ3kePaYGqVIfZ3BJ2l8470
         08Ayt8PQxBz76gDV/JgZRdRqs1buNXqRfS03aKRFcgVNKUuOoj49BP+gKQKUGzfqKEd9
         OIO3LRXa57zc2QxPmJwCZ/k7vMZYDzgkKmj93EFh4EAZ0Uv/hh2ocYFzF3kcTXOXNCtU
         Iyog==
X-Gm-Message-State: APjAAAWWSIHXDgFGRnZHV3f9sdlabm0nPIbYkjO/3aHUwmaAbK/NWS7T
        +fir793fHzvk3aYn0I6RGops+mBZe0t1MWb7Ylk=
X-Google-Smtp-Source: APXvYqwi18I4XKJgpIxaaflyCZ/OPBMLI2SBmGmwQewfswcpxRzlqOHop4Hw1abjCBu5LeBrXPsOp9cCuvvgi0imtG4=
X-Received: by 2002:a37:9fc6:: with SMTP id i189mr32863244qke.246.1553750838910;
 Wed, 27 Mar 2019 22:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190328012002.842-1-lsahlber@redhat.com> <CAH2r5mvCC95ve_VFGoE+4ckujA8eXcSGFj6qs+jzpeZVrJ-Gpg@mail.gmail.com>
In-Reply-To: <CAH2r5mvCC95ve_VFGoE+4ckujA8eXcSGFj6qs+jzpeZVrJ-Gpg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 28 Mar 2019 15:27:07 +1000
Message-ID: <CAN05THTubng_fpT=m7waayzVRz2sd9Utqt=5fNgwSBgm7n-zaA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix kref underflow in close_shroot()
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yeah, probably

On Thu, Mar 28, 2019 at 3:11 PM Steve French <smfrench@gmail.com> wrote:
>
> Should this be CC:stable?
>
> On Wed, Mar 27, 2019 at 8:21 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Fix a bug where we used to not initialize the cached fid structure at all
> > in open_shroot() if the open was successful but we did not get a lease.
> > This would leave the structure uninitialized and later when we close the handle
> > we would in close_shroot() try to kref_put() an uninitialized refcount.
> >
> > Fix this by always initializing this structure if the open was successful
> > but only do the extra get() if we got a lease.
> > This extra get() is only used to hold the structure until we get a lease
> > break from the server at which point we will kref_put() it during lease
> > processing.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 1022a3771e14..7cfafac255aa 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -717,20 +717,18 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
> >         oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
> >  #endif /* CIFS_DEBUG2 */
> >
> > -       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
> > -               oplock = smb2_parse_lease_state(server, o_rsp,
> > -                                               &oparms.fid->epoch,
> > -                                               oparms.fid->lease_key);
> > -       else
> > -               goto oshr_exit;
> > -
> > -
> >         memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> >         tcon->crfid.tcon = tcon;
> >         tcon->crfid.is_valid = true;
> >         kref_init(&tcon->crfid.refcount);
> > -       kref_get(&tcon->crfid.refcount);
> >
> > +       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> > +               kref_get(&tcon->crfid.refcount);
> > +               oplock = smb2_parse_lease_state(server, o_rsp,
> > +                                               &oparms.fid->epoch,
> > +                                               oparms.fid->lease_key);
> > +       } else
> > +               goto oshr_exit;
> >
> >         qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> >         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
