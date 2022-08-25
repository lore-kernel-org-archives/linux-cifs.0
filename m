Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6781CC28D13
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiHYEWR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHYEWQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:22:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89796AA08
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:22:15 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h22so26943397ejk.4
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9HeDrjmbWdnII3cWGG8U9ULiqrX7ssZQCBySmE/G2A4=;
        b=ktNxg3meGpX3TZuzUhZ1BCa7xcS7jl7QrHLqIrugOfvzlxon4+SuksS4tXxe9RZI+S
         NpuxcaRMKahl2d7QH3qLIBHe8kv1A5oNw/n3xI/+U4LwKS7A9V3AMtrgYPAh8THQR5TK
         sXpnHCixxJZq4nSOfuJzW3dcM/sRNrqhmHGfaI2zfD7fAHpvKVDFz69k9Y65/TJmf6U4
         /GQP/el9CxCUAszJgwZhh5IVHcyTK9gRo3AXtEjSvDIFDAnW9jht5Ykm4WHfZyxISmWf
         7LocJnb1XOHW4y7UpLbXMJwmyVfdOqpJKguSGr2aOHpI4jTqwhDNqS4pLqTxhnXhvdYz
         uvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9HeDrjmbWdnII3cWGG8U9ULiqrX7ssZQCBySmE/G2A4=;
        b=0xIFyIdvdwh8awfK7J1fSCyHdFe7UCrntfEKekR+oaAMFWgC0uh01XmGPtuiQ3EK+l
         j+1UrhZKttirIKmW2Ja/6Nhp7slTY29oQ+lnPwFydo4eaMzD+xfSbci/3KCCdD4qMtR5
         DFnEcuavTulXMdkdZ9WHT2Ijn9FyCnM7iRfbnNi70eE53tNvb7mEk0ZF9zjQ79LNlJIC
         AaCK72b1XRxjExB3dzn7qU/9n2nOMZK3tdRa85l2HUd0oSk8wRFvR+4YO5hgz43+9poH
         GujPjpbnjctepMLSpfweYlP8PPYjSBXKg+Kgr1eSNJTAmzaUGIMkz0OLXZZc+z1i7ucY
         pNxw==
X-Gm-Message-State: ACgBeo2kkjmLL/u4syhK31g1SvqotjV/L7BeQ1P26ASvpNLumx5x06YK
        NSITfN2JjYG9G2+WxrSikq8USpZDhcYikCf/6N0=
X-Google-Smtp-Source: AA6agR584cqGmPeZ5y3dUufLI8gngU+L/W+zeCa9G0HcQN5ZsXksE5NMT5tV7OTW1GrNu0NeUlmJ5VsY7/rCobw6XwM=
X-Received: by 2002:a17:907:97d2:b0:730:657f:bef5 with SMTP id
 js18-20020a17090797d200b00730657fbef5mr1216891ejc.757.1661401334506; Wed, 24
 Aug 2022 21:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220824002756.3659568-1-lsahlber@redhat.com> <20220824002756.3659568-3-lsahlber@redhat.com>
 <6be102e7-4e4d-a4da-6afd-54dbdfc10cae@talpey.com>
In-Reply-To: <6be102e7-4e4d-a4da-6afd-54dbdfc10cae@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Aug 2022 14:22:01 +1000
Message-ID: <CAN05THTMszYOqtajFo8-Huo5KmPJGYuYpPotCB2+5_u-hHMd0Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] cifs: cifs: handlecache, only track the dentry for
 the root handle
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 24 Aug 2022 at 23:35, Tom Talpey <tom@talpey.com> wrote:
>
> On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/cached_dir.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > index c2f5b71a3c9f..77880470c7ea 100644
> > --- a/fs/cifs/cached_dir.c
> > +++ b/fs/cifs/cached_dir.c
> > @@ -47,11 +47,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       if (cifs_sb->root == NULL)
> >               return -ENOENT;
> >
> > +     if (!strlen(path))
> > +             dentry = cifs_sb->root;
>
> Wouldn't it be safer and more efficient to simply test
> "if (path[0] == 0)"?

Thanks!

Right. I have changed it like so.

>
> But, why would a non-null path ever be passed, if it
> always fails? Seems like a pointless call in the first
> place.
>
> > +
> >       if (strlen(path))
>
> Simply "else"? No need to recompute strlen.

Done.
It was done this way because shortly later in the patch series some of
these checks go away
once we add the capability to cache more than just the root directory.


> Tom.
>
> >               return -ENOENT;
> >
> > -     dentry = cifs_sb->root;
> > -
> >       cfid = &tcon->cfids->cfid;
> >       mutex_lock(&cfid->fid_mutex);
> >       if (cfid->is_valid) {
> > @@ -177,7 +178,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       cfid->tcon = tcon;
> >       cfid->is_valid = true;
> >       cfid->dentry = dentry;
> > -     dget(dentry);
> > +     if (dentry)
> > +             dget(dentry);
> >       kref_init(&cfid->refcount);
> >
> >       /* BB TBD check to see if oplock level check can be removed below */
