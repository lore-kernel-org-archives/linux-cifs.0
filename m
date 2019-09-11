Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CD2C49ED6
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 22:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12D282054F
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 22:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+RHfXDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfIKWKY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 18:10:24 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:37860 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfIKWKY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 18:10:24 -0400
Received: by mail-io1-f43.google.com with SMTP id r4so49631814iop.4
        for <linux-cifs@vger.kernel.org>; Wed, 11 Sep 2019 15:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q46aE/jeshmPIfccUYvjXvNYiPgfqK0C1osltS4PXPs=;
        b=N+RHfXDx3QIe4rkPYLrEeMULm8P8TsfcNTkVG3maKeIbBv4WToR0m+NBJhH4VKycmI
         FYEdkZbndNkWsoUPoJD942Qk8uNifYJK1wPH2ZxCRGknEKzSG2pnf1wFEQz/P2qbGLql
         wqJeWpb8CZClYkenG9ba5m0akkExr5SqxhaGMJmNDKJ/wg3XYQsJxZUuEA+aF5Ag8Xg7
         8DubWQFhNdoPavuNJw3s7tfwRQFkiyl2tZLfQbE8tTCHukEbxJeQ2v2eDt/9HfUYHSCg
         AAmEGbXwdATJ8d9xt5FXzzBqbSuZeR1RhyQkmrEbKlKQvlz+Bl1CUGX7kQxdd6deNYwT
         pZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q46aE/jeshmPIfccUYvjXvNYiPgfqK0C1osltS4PXPs=;
        b=HwhpaYq8Xsrqq+ql50ySHkXAOcEkNLdDhPnk1AzcLL2dGnThyrKkCq3Q/ikN6Ask4w
         yClJmRK5lhHp53EFhqCNoLDgZ0zOrdJSPss8qfydFFD75cnt6KTfa0cdJNuPR5fbqfUm
         oEpjuu1kh42kZWtQ2VoU7H1Gyp8HSsFPHUmuNyZbozIzhezY61DdEHAX/ETEhzwOVywW
         jhtAm8g90b4vcUyGCRjRARiaSaHCkHzX+6Ohvia7kpOGoMdXXQJdn/pMPT7vkek8PN2P
         6VycjRxmAmTym9KMj9DC/Augi4dK00dBHlLuOPKRncK1jUQyiaTHJQ4CPKaYBYXCrU7o
         CiTQ==
X-Gm-Message-State: APjAAAW3UpMhyl42t3d1qmOP2JZVqUDEKsvYaEq49QjmVCJznxE+QKHt
        E8RdA9wt1ruAkReI40+u/0hGtvh+9Zm4siZ8GgPZ7g==
X-Google-Smtp-Source: APXvYqyDHP6JzieJWRtElIKQkAMcsW9Lzebh0EHdpBH7Z6d3WGDnnJsGsxGCzC+m1jwfbdpWFaTyopG5c7e37bQNpf4=
X-Received: by 2002:a6b:b4c7:: with SMTP id d190mr75054iof.209.1568239822016;
 Wed, 11 Sep 2019 15:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
 <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com> <CAKywueR6Z1QbkbA3RxXrBEZOvHxECnAGV1ko+DnLgTusv2tEhA@mail.gmail.com>
In-Reply-To: <CAKywueR6Z1QbkbA3RxXrBEZOvHxECnAGV1ko+DnLgTusv2tEhA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 12 Sep 2019 08:10:10 +1000
Message-ID: <CAN05THSBw-6WMJK8Sb_nXevrCceqkjuYRumF1pjqPoeg90aMtg@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 12, 2019 at 3:08 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> can this error code be returned on any operation?

Not sure.
I think it is only returned by TreeConnect and possibly also
SessionSetup, but not sure.


> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 22:26, ron=
nie sahlberg <ronniesahlberg@gmail.com>:
> >
> > Looks good.
> >
> >
> > We also need to handle the case where the share is deleted but is
> > never added back.
> >
> > On Wed, Sep 11, 2019 at 3:15 PM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > When a share is deleted, returning EIO is confusing and no useful
> > > information is logged.  Improve the handling of this case by
> > > at least logging a better error for this (and also mapping the error
> > > differently to EREMCHG).  See e.g. the new messages that would be log=
ged:
> > >
> > > [55243.639530] server share \\192.168.1.219\scratch deleted
> > > [55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME:
> > > \\192.168.1.219\scratch
> > >
> > > In addition for the case where a share is deleted and then recreated
> > > with the same name, have now fixed that so it works. This is sometime=
s
> > > done for example, because the admin had to move a share to a differen=
t,
> > > bigger local drive when a share is running low on space.
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
