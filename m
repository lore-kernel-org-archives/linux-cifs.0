Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F50CC41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFAC520870
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsRJmjkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgJFFXm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJFFXm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:23:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206ABC0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 22:23:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y20so11655979iod.5
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 22:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ictI7puhW+o6f5WAZnCOjSXDAGXXINPPJgiQp1QOtlY=;
        b=JsRJmjkctzCexkFTWoqrGSPy5WHV9zHGw1ZeOZqrsMd2Xqw2RWRhMUgbqlWckw9EVX
         /OkGslE99wLERDHAisV3kq/zEZoSO03jTjkkfZG92t2Va8W8ZbePMCTw+z1Awy62BcA9
         6KIxEK71kWPV4G7pdLcgZxhcYSWG6dSgzxxOs6fUlpMbnskElYxSKjPi/0ba7/TUD0kN
         0JKoLj2U9NON84PiEQBqAwWa5AOuHV05yqJjUbxQ0Ffw6NzjG4HpihWYk7GgR0+sGd+9
         x8OrMFGd+83yPRaMvlhQpfV0/53eMqPALszwNSnG1hoWCoAGrwMAU31wEnuDkWURTtBu
         auFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ictI7puhW+o6f5WAZnCOjSXDAGXXINPPJgiQp1QOtlY=;
        b=KNi/HaW/Y1RqH2FipRl0DFjj0I5eg6N0rq0B+zQ4/PKl0eBX2W5vHjPOMen2W5il6e
         etRlL2FfoRNhSLRB12FjOaWleGTmUm8AgfdocleXM5L2eBxoZnEheXhm+yFdyCOPOqt7
         E1gsHaL6rmbzTkIQOpxPKy4qBrEjVf0/MbHtzbZCs+/FngnwEaT1Iu2gcCS4EFtIPGQx
         jWcDNFJg8e1HBwmQZO5KW+xTWAoZk0Kfdn1Bamnf0XrCL4UE0QPoEfIlwc9W6CGBn1Ef
         yYPxBoRPRYjCQsWg3bZ/+XPYVN1zYkkrFTxmPc0g7sxcZh3jhTDwZB/+IPYagUxv9XfR
         UosA==
X-Gm-Message-State: AOAM530jcIgO1wFNJDyeb4k4wvcJ56c+7RJXRVgIrFZiu07wfCYtArX1
        oDlXg5v6qFSxK2opEw42H1LFCLzkilQMR1YNNdU=
X-Google-Smtp-Source: ABdhPJz1v2p759Akk6pZfuLyZESHL1RAmuF4elJcCnqGrWJTQFacPY6TT28GECK5sA9mEu5Un3kc64eorBMledrhUwg=
X-Received: by 2002:a5e:8347:: with SMTP id y7mr228033iom.1.1601961821493;
 Mon, 05 Oct 2020 22:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201006022623.21026-1-lsahlber@redhat.com> <CAH2r5mtGS0pX0nvzAk6hgrfocHzxUQLiidBi8WzU4a5FQ5v6CQ@mail.gmail.com>
 <CANT5p=rpvB=PrCB143eJh0Y7wsE-KRqei981uz_Nq+A4hFJhSg@mail.gmail.com>
In-Reply-To: <CANT5p=rpvB=PrCB143eJh0Y7wsE-KRqei981uz_Nq+A4hFJhSg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 6 Oct 2020 15:23:30 +1000
Message-ID: <CAN05THRPh31kM8y4U24tKak6ebk_O=nR6MQTPhZ6ZE53cW5+Gw@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 6, 2020 at 3:06 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Question: What causes cifs_setattr_* to return -EINTR?
> Does an infinite reattempt make sense here? Or should we give up after
> N attempts?

Good question. Probably.
I think you are right we might need to limit the retries.

One  case could be where we never receive a response from the server
and userspace
wants to CTRL-C the thread.  It might mean we have to do N CTRL-C to
end the process but N is better than infinite CTRL-C :-)

I will resend with a limit on retries.

Thanks!

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
