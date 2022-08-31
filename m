Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D3ECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 01:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiHaBKo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHaBKn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 21:10:43 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AD4474CA
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:10:42 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id b81so6093759vkf.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cS+u8wM8X+KkHu3y2ov18YuMRqpPIfxhbPZH3C3apWI=;
        b=dqJp90F44wax6JG/XQSgKYZDbQozvJx2A/wo1cnevs2vcQE4EDruKICmoftOTBVAod
         T+7jAFdfkoQMjb3KYfuT3Iu77duiVYI4wPEl69iZioVSwiqXw0txzG4dP1lqQAxPQHfZ
         AVdt84XkSWRR+NmV560NwqnwxsGtGNYcUQRlI1F12thgUb/bwbRyWl3eql+P/6zWVY3P
         +kMhhZJ2mfFBmOTDJl8CHt9oZDTYbXvXni1NmVpOakyJNk77E3qFp7P9zZns11GTa2P6
         nhoJyU7O6NY33B26yfCvb//DF5TIFcYAMP3mvsc+U6lDnf8s/e3sEcEWr1vQpj/tnKfc
         eK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cS+u8wM8X+KkHu3y2ov18YuMRqpPIfxhbPZH3C3apWI=;
        b=JGdugda7gLC3UY/RECRUDKVjv/GKaFsGqa8zLcHFwWQc+KPFSu2xZins3WC8rSOWYH
         5DdmW0sYkxfMGsK7reiia4/KS+/laJW+CGfAJSK8vgKIWc19WUrdTwVS1oJjH2ztfnqP
         8ie/EwHxEwec6Wsy9acM7na4jGcJ2/a+mR2A0lK+gATJEBP9XuXV3bxdr6n4lEymMidO
         yrySTAHEOjUvLk+xNlZJ1nO76y9iSNbYjd3rsGNmIBw47meqCePGRHaIS0gZbuvMtBS9
         ZiGWiq+ZJzcF46cOkB7sNoKmKjD5Wxn9anZEHCVha6f1O6SwDEeFBWFZjMf82PofaZgG
         Ca6A==
X-Gm-Message-State: ACgBeo2iZObUgU/oCsk4CGrYUH6iEQ7qNaYmHrUjmTs7E9wevdh9qo4F
        YgyGgVh1Yn4Rcepr5AC49phbr8jqxIn0Rb1Z5mvGf3CqM7E=
X-Google-Smtp-Source: AA6agR7SWxUNyAw9YHqDIGJ0wjyp+JNyLQ/gGbhZnuPtz4iTVMRXSeqnvnjIVRj4uTa9+VC9XWytspiTPSWwqrzQjmI=
X-Received: by 2002:a1f:51c2:0:b0:37c:f131:e749 with SMTP id
 f185-20020a1f51c2000000b0037cf131e749mr5745740vkb.38.1661908241463; Tue, 30
 Aug 2022 18:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220830225151.26201-1-ematsumiya@suse.de> <CAN05THThEdPdn4UVici+vM13m9FRbTaSCmxdC2SMUxaENqfqmw@mail.gmail.com>
 <CAH2r5mt6sKsNAhXN5HQL_=M3gn2XA+6MQ195FJbNivVR95=zAQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt6sKsNAhXN5HQL_=M3gn2XA+6MQ195FJbNivVR95=zAQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 30 Aug 2022 20:10:30 -0500
Message-ID: <CAH2r5mtWf-V2ShO_yWmVmr1vPDf2FyHSi=3hOqfa6gv12Gqw-A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix small mempool leak in SMB2_negotiate()
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and added cc:stable

On Tue, Aug 30, 2022 at 8:06 PM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next
>
> On Tue, Aug 30, 2022 at 8:05 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > LGTM
> > reviewed-by me
> >
> > On Wed, 31 Aug 2022 at 08:51, Enzo Matsumiya <ematsumiya@suse.de> wrote:
> > >
> > > In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
> > > the request is sent, the checks would return -EIO when they should be
> > > rather setting rc = -EIO and jumping to neg_exit to free the response
> > > buffer from mempool.
> > >
> > > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > > ---
> > >  fs/cifs/smb2pdu.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > index 128e44e57528..6352ab32c7e7 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -965,16 +965,17 @@ SMB2_negotiate(const unsigned int xid,
> > >         } else if (rc != 0)
> > >                 goto neg_exit;
> > >
> > > +       rc = -EIO;
> > >         if (strcmp(server->vals->version_string,
> > >                    SMB3ANY_VERSION_STRING) == 0) {
> > >                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
> > >                         cifs_server_dbg(VFS,
> > >                                 "SMB2 dialect returned but not requested\n");
> > > -                       return -EIO;
> > > +                       goto neg_exit;
> > >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
> > >                         cifs_server_dbg(VFS,
> > >                                 "SMB2.1 dialect returned but not requested\n");
> > > -                       return -EIO;
> > > +                       goto neg_exit;
> > >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
> > >                         /* ops set to 3.0 by default for default so update */
> > >                         server->ops = &smb311_operations;
> > > @@ -985,7 +986,7 @@ SMB2_negotiate(const unsigned int xid,
> > >                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
> > >                         cifs_server_dbg(VFS,
> > >                                 "SMB2 dialect returned but not requested\n");
> > > -                       return -EIO;
> > > +                       goto neg_exit;
> > >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
> > >                         /* ops set to 3.0 by default for default so update */
> > >                         server->ops = &smb21_operations;
> > > @@ -999,7 +1000,7 @@ SMB2_negotiate(const unsigned int xid,
> > >                 /* if requested single dialect ensure returned dialect matched */
> > >                 cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
> > >                                 le16_to_cpu(rsp->DialectRevision));
> > > -               return -EIO;
> > > +               goto neg_exit;
> > >         }
> > >
> > >         cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
> > > @@ -1017,9 +1018,10 @@ SMB2_negotiate(const unsigned int xid,
> > >         else {
> > >                 cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
> > >                                 le16_to_cpu(rsp->DialectRevision));
> > > -               rc = -EIO;
> > >                 goto neg_exit;
> > >         }
> > > +
> > > +       rc = 0;
> > >         server->dialect = le16_to_cpu(rsp->DialectRevision);
> > >
> > >         /*
> > > --
> > > 2.35.3
> > >
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
