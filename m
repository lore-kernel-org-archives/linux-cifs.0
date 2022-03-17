Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D03DC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 12:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiCQMSK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 08:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiCQMSI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 08:18:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0A21E0168
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 05:16:51 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id q5so6911047ljb.11
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 05:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QiT4tXozL7inkF9mrkZFc2uOtwCM3f3/v8ys6Tw4M/4=;
        b=TEkrX9t58V78kFFsrITXbk8mpVnm61MjLG0CeAD5oTWQFfuBMGIdw9A2Lw3TwPTKNN
         ZdBXZ0pBT72BOTTFPyvXNQLHDkFw2vPGDmYWlxmtRVlUDQe53C86CZ/AbNhdJo3oIf2M
         j5iN494F7Rj/CwZxDU0MbqkiIBYxqcX9og9riiWOZN6eVh7wHcOqZ9voCeQohhJiomwF
         Fro1zXprDuYmFDW9H1mt5yTBbQBxLNyQ8aMan7PPylMj5YWh/sT8MtikzNcVwUdCsip1
         bO5ld5kLq8QBhdacdkS73pSSOq/sr3ZuVIcko24zU+1zWgZrKJy43ykcGb7eMLw2Hg7C
         9x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QiT4tXozL7inkF9mrkZFc2uOtwCM3f3/v8ys6Tw4M/4=;
        b=NH/ijWg6LZbCHYEbBpRe3Z5bzQLgNESkLwM4WNCSKUJKGMLg5/3Bw8Zjsjw6jvK8YJ
         YHFoc/Y0OL2xxue6Am73/E+ZqS74vWAq4YnTr9Bw0x+5BFQl4M8XmUUtBYsfWUz5oopX
         jinJzl0LPA9kxQ1y2ea01g/LKWDMjD8OwxJQ35xkrNJ86/wHR3Fp5uikeEU21UH1Za6L
         d3Dd58ZezOoyJX5q5z67VGrqus3ecda9VTwaKS3Ulqm/FLjBnlPd6m7OXBDtvIyfMCn2
         dbX30FCwqRkeMCTw6xkHX2x6XNr2SemfqLq3q/zont4v4TPPT1SUdPK2GKwBsdFzxGDp
         PB6w==
X-Gm-Message-State: AOAM532K2h2tcaNgcFvck1mxQLNPWLs8WUaSUrEQ9/PXKSsJ2l4iZKNE
        nKS1eLWhcshafzjm+ks+3EXkSmZ/6NYbjYfOM65bsQvPnXZ9Bw==
X-Google-Smtp-Source: ABdhPJzqgvrQU7N7yOug1gg+/gbjsqNpaRG3OJigV3AmVC42f5eDwryiLR6spXBVN4ZQI6WDoYHfKmmWhFKWW3PDoqw=
X-Received: by 2002:a2e:b890:0:b0:249:1c55:741c with SMTP id
 r16-20020a2eb890000000b002491c55741cmr2767958ljp.193.1647519408949; Thu, 17
 Mar 2022 05:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
In-Reply-To: <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Thu, 17 Mar 2022 08:16:37 -0400
Message-ID: <CAFrh3J84iFWoKh01eVfR2mNaDaNMeD86bN-oAcJ=ND8t545fGw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI this patch did not fix mount after resume from suspend.

I still see "CIFS: VFS: cifs_tree_connect: could not find superblock:
-22" errors with the cifs mount unusable after resume.

Regards,

Satadru

On Wed, Mar 16, 2022 at 11:44 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
> >
> > cifssmb3: fix incorrect session setup check for multiuser mounts
>
> If it fixes multiuser then Acked-by me.
> We are so close to rc8 that we can not do intrusive changes,   so if
> it fixes it short term.
> For longer term, post rc8 we need to rewrite the statemaching completely
> and separate out "what happens in server->tcpStatus" as one statemachine and
> "what happens in server->status" as a separate one. Right now it is a mess.
>
>
> >
> > A recent change to how the SMB3 server (socket) and session status
> > is managed regressed multiuser mounts by changing the check
> > for whether session setup is needed to the socket (TCP_Server_info)
> > structure instead of the session struct (cifs_ses). Add additional
> > check in cifs_setup_sesion to fix this.
> >
> > Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> > Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/connect.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 053cb449eb16..d3020abfe404 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> > struct cifs_ses *ses,
> >
> >   /* only send once per connect */
> >   spin_lock(&cifs_tcp_ses_lock);
> > - if (server->tcpStatus != CifsNeedSessSetup) {
> > + if ((server->tcpStatus != CifsNeedSessSetup) &&
> > +     (ses->status == CifsGood)) {
> >   spin_unlock(&cifs_tcp_ses_lock);
> >   return 0;
> >   }
> >
> > --
> > Thanks,
> >
> > Steve
