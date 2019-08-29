Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F7CC3A59F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 04:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 884D82341B
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 04:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTpepsNJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbfH2EJt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 00:09:49 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:34717 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfH2EJs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 00:09:48 -0400
Received: by mail-io1-f51.google.com with SMTP id s21so4202420ioa.1;
        Wed, 28 Aug 2019 21:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YU1YHjbF48DNiDGJ/sscFH+VTiFvXEQv14JcR6j+IMU=;
        b=bTpepsNJjZwXWh3JW5H4Ce7efx57U0QBAypMjHr2aJhmxYvbZ4l9uUtc6UMlNwMCVJ
         rLlM8Vuv3UZLoMQqhxPfSciTslDnYspvytfvb/vz8K2fmL1kCztbZVNCT5neQNLSfNkp
         qWBHRHtafx3W65LeuqM2KbWB2E3HPtZsAI/KMVTjkBAIPdQN7XKEbIKijAU6vjg9Fuaf
         bp0Pn17+wxMtNr9KWvB+NPLxdLh1yE9mQhv4Mb2tA8gukZv0oRe5fsDjlDKE4B8fJ/bJ
         XqKYm9LeOOGfR66D2NLd8hFML4RtuW4fzzWLP6+mCHpTLLGaGIuz1+mGmeSk0/c85frc
         andQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YU1YHjbF48DNiDGJ/sscFH+VTiFvXEQv14JcR6j+IMU=;
        b=eLAWz4fngJKjXbzazP5gCM8VvF4EOgaYMVzeKIxzNq3Gmjy3DB9de0+MVvkbylZcZB
         IbzxcF9KkR/kv7QvWIE5wpzZjBffGk0jT2G0EZlS8c/AJ25SYjEdFYrUZadmbLTKv4gr
         W6D8zJBlJfcO4nYCDiRXqqgmYOz/ziPY7cqWvEjZmERlBcHCGWH8SRDto3E1FYXr6YHH
         gt+QkFBEvEYuqQQS12qD+HM3iK0kH6efe8ikmMWZ9Yoqowy/moNqvuquMpcF1mYpqlOc
         fh88KQhxtTgIFDfg2czYfrtzUDaHYcv2mzx8xENxhvIb7WkbQVhl6c3IaBd+UUaazVPT
         hp/g==
X-Gm-Message-State: APjAAAUoQN0OwQ3c9taNIq1aCuB8P7/pRey86aF+JXdrykNCeATsn+xV
        lH3JGR/zSYzBuByXp9V5D8hq//JvI+B6FteAGNaBTg==
X-Google-Smtp-Source: APXvYqwjBWoTXise9Yyur+0EvpWqlBurQEVkTw/X47GmfjP60IPzgICVqLLRTVW8GZeXgC76n+oVDlvxAVlDDLuFDis=
X-Received: by 2002:a5e:da48:: with SMTP id o8mr8716584iop.252.1567051787467;
 Wed, 28 Aug 2019 21:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190829000006.24187-1-colin.king@canonical.com> <CAH2r5mtSSwS7_E2WkS3Lsk02BEf_UwZ4H9oCEFTSf94U=4Cm9Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtSSwS7_E2WkS3Lsk02BEf_UwZ4H9oCEFTSf94U=4Cm9Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 29 Aug 2019 14:09:35 +1000
Message-ID: <CAN05THSTwX_a7hry4EpD86EEr7NaZ75XUhDKpr_Dgwqqt+rBuw@mail.gmail.com>
Subject: Re: [PATCH][cifs-next] cifs: ensure variable rc is initialized at the
 after_open label
To:     Steve French <smfrench@gmail.com>
Cc:     Colin King <colin.king@canonical.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 29, 2019 at 2:00 PM Steve French <smfrench@gmail.com> wrote:
>
> Merged into cifs-2.6.git for-next
>
> Ronnie,
> You ok with merging this as a distinct patch?

Sure thing.
Thanks for the fix Colin.


>
> On Wed, Aug 28, 2019 at 7:02 PM Colin King <colin.king@canonical.com> wrote:
> >
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > A previous fix added a jump to after_open which now leaves variable
> > rc in a uninitialized state. A couple of the cases in the following
> > switch statement do not set variable rc, hence the error check on rc
> > at the end of the switch statement is reading a garbage value in rc
> > for those specific cases. Fix this by initializing rc to zero before
> > the switch statement.
> >
> > Fixes: 955a9c5b39379 ("cifs: create a helper to find a writeable handle by path name")
> > Addresses-Coverity: ("Uninitialized scalar variable")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  fs/cifs/smb2inode.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > index 70342bcd89b4..939fc7b2234c 100644
> > --- a/fs/cifs/smb2inode.c
> > +++ b/fs/cifs/smb2inode.c
> > @@ -116,6 +116,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> >         smb2_set_next_command(tcon, &rqst[num_rqst]);
> >   after_open:
> >         num_rqst++;
> > +       rc = 0;
> >
> >         /* Operation */
> >         switch (command) {
> > --
> > 2.20.1
> >
>
>
> --
> Thanks,
>
> Steve
