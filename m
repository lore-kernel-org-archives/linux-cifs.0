Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95B2ECAAD4
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 01:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiHaBGU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiHaBGO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 21:06:14 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A9C8C03E
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:13 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id x66so6089702vkb.8
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=LDSkgeacpN4dtsx7JzMPIecvgqzUJC94IuAKqCZ2IzM=;
        b=HldIzS5tqEhpxugVpbBe0CCFD1VJzsrf4cRrCjU9OgM9gHNilvwG8YkC5Csy0Fas5P
         9e48AAvPoBWiyzm+0T5tVChBQKrZzO5UHZf4QPBfCABX2kDypbzcDe1kRRHhOLoajS0n
         unLyK1R/MCNQB8ish+he6mCfu7FMKo0O3/nq2CkT8nHG/v4X1i6M2uKVCzC1/2IZyd4c
         v5fQOUY+MYt1Z9U85nIHrQTxTIkHJTuW3n5AX3pcIXhLNP/BBzyTnxMqCqgRvo7nISQR
         Pug2d87WS/aHtNcXdZt8QCZOS8kSTEfb/y1aIJfFHvOBAwmCLjr938H0RrMt6f5ho/gn
         R09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LDSkgeacpN4dtsx7JzMPIecvgqzUJC94IuAKqCZ2IzM=;
        b=jtxBktDj8kY5g7qPELzvS0rERqd5sq+zt6h28PQ4p8No4gf51ECdFLnMrL6L6O5Dsn
         vCIEUcOEWq98NLIiBlAL+AnE4qyFUbiU1OXoDTxmUSBFa/AQGYUIgMSAjpMbR3bhqL/H
         iH3EQF0B9hWIRN1lDOzp0l8Fq51EzIvJBmbYI8sEWmVvVQj99cjussvQi+7AaDXQ1V0L
         +vlCsOtaR1Thu0xuRHZo5gETMas3p+qwR97Ne8j5zLxUYdxEhPYQT8ngdiO/tLfOFdjE
         9C3P2pJfyJhNAGUFYUrnbnIbpNwTD+600b+IatV/2lD5IzBiQyYnEj0hxKxAoco7aI04
         zCrw==
X-Gm-Message-State: ACgBeo3Wh78330x0e8pBvQNy0JFbz11uDZX2JKJepv19Y+MBVol3dlnb
        e+j/ym6gsEApauUVjUzfNSuaDPGCIeKG7a7JZn0=
X-Google-Smtp-Source: AA6agR4uAhJ+log1u3hUXkkLRNvI5VeYtg+oC/zNJllcferdP5wpys/fExhD57ABwD10f1loGiyr179KkxvHee20dlQ=
X-Received: by 2002:a1f:51c2:0:b0:37c:f131:e749 with SMTP id
 f185-20020a1f51c2000000b0037cf131e749mr5742513vkb.38.1661907972384; Tue, 30
 Aug 2022 18:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220830225151.26201-1-ematsumiya@suse.de> <CAN05THThEdPdn4UVici+vM13m9FRbTaSCmxdC2SMUxaENqfqmw@mail.gmail.com>
In-Reply-To: <CAN05THThEdPdn4UVici+vM13m9FRbTaSCmxdC2SMUxaENqfqmw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 30 Aug 2022 20:06:01 -0500
Message-ID: <CAH2r5mt6sKsNAhXN5HQL_=M3gn2XA+6MQ195FJbNivVR95=zAQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix small mempool leak in SMB2_negotiate()
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Aug 30, 2022 at 8:05 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> LGTM
> reviewed-by me
>
> On Wed, 31 Aug 2022 at 08:51, Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
> > the request is sent, the checks would return -EIO when they should be
> > rather setting rc = -EIO and jumping to neg_exit to free the response
> > buffer from mempool.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/smb2pdu.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 128e44e57528..6352ab32c7e7 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -965,16 +965,17 @@ SMB2_negotiate(const unsigned int xid,
> >         } else if (rc != 0)
> >                 goto neg_exit;
> >
> > +       rc = -EIO;
> >         if (strcmp(server->vals->version_string,
> >                    SMB3ANY_VERSION_STRING) == 0) {
> >                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
> >                         cifs_server_dbg(VFS,
> >                                 "SMB2 dialect returned but not requested\n");
> > -                       return -EIO;
> > +                       goto neg_exit;
> >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
> >                         cifs_server_dbg(VFS,
> >                                 "SMB2.1 dialect returned but not requested\n");
> > -                       return -EIO;
> > +                       goto neg_exit;
> >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
> >                         /* ops set to 3.0 by default for default so update */
> >                         server->ops = &smb311_operations;
> > @@ -985,7 +986,7 @@ SMB2_negotiate(const unsigned int xid,
> >                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
> >                         cifs_server_dbg(VFS,
> >                                 "SMB2 dialect returned but not requested\n");
> > -                       return -EIO;
> > +                       goto neg_exit;
> >                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
> >                         /* ops set to 3.0 by default for default so update */
> >                         server->ops = &smb21_operations;
> > @@ -999,7 +1000,7 @@ SMB2_negotiate(const unsigned int xid,
> >                 /* if requested single dialect ensure returned dialect matched */
> >                 cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
> >                                 le16_to_cpu(rsp->DialectRevision));
> > -               return -EIO;
> > +               goto neg_exit;
> >         }
> >
> >         cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
> > @@ -1017,9 +1018,10 @@ SMB2_negotiate(const unsigned int xid,
> >         else {
> >                 cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
> >                                 le16_to_cpu(rsp->DialectRevision));
> > -               rc = -EIO;
> >                 goto neg_exit;
> >         }
> > +
> > +       rc = 0;
> >         server->dialect = le16_to_cpu(rsp->DialectRevision);
> >
> >         /*
> > --
> > 2.35.3
> >



-- 
Thanks,

Steve
