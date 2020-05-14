Return-Path: <SRS0=e0WW=64=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47178C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 14 May 2020 01:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00311205ED
	for <linux-cifs@archiver.kernel.org>; Thu, 14 May 2020 01:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=forsedomani.com header.i=@forsedomani.com header.b="wlfJilTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgENBR4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 May 2020 21:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENBR4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 May 2020 21:17:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21974C061A0C
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 18:17:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so541084pgb.7
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 18:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forsedomani.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ftLT5A1twImI5rVswX07Q3QxS6QqTwr8upHDbQudbVw=;
        b=wlfJilTj44bAp2DDKONTtBXJop6cD/KcTlN5sROEBq9+PHEYzRi6ISoLN0/uTgSiDL
         XQChHEAC9+TU2SN+Ky7z8/LlOkWOFtezqGkEdDIAznTfDR490xKVQH29EQTPvNMStdE5
         kyeRDcWX5CUmjYTWKOkmB5+IRwlZxNG51AKNZiTTwvhDxCi7tjkUbzKxADEqs2qnjNRa
         dYxQYWfNs/OMGuJKZzJoxMyjvTZz19t/fi4FLIIlkPqZzSz77nazWW7ZGkOVAGdwmYiI
         1YnKWw5vNegqLzqhR55W08RbSq1VS1JG8vxtQ/ip0EhmbKqj7STguHb29WJ37LE7N7T8
         Pn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ftLT5A1twImI5rVswX07Q3QxS6QqTwr8upHDbQudbVw=;
        b=aOkrpdwAlcfw1AxjXliCGnEmURr2IVPj3JpChWun6fiRgyqY3+Jf2x1CRxRYfG9t8F
         pfQjLekNNUKdELWo/4SZJm0SCAyMhUoZivXZrTmzxSoVvcKffzloJqhD9/tAiJDpmCeb
         ntsdzBOeRFyYBoRv/l6tqfOBgDk/Q55nyTjdRxG4tHWa4ZUSzQG4Ons1U1oSHsUXNjmT
         iEPTUhTp+aUpp+MGF7hUoNUV3B7Ag5jub37Mt9kp9PaLfHkgewR7rkAMykTiWy81TjDV
         bJWjsUmc/yaA9w88pN5NulbK5+sJtaLP9wspkthpVNu1VLYaPysIxjY7anIUu4OhEwcW
         oCSg==
X-Gm-Message-State: AOAM532DKiPBG8I6xJcFsYjtItqT6EAvIIb3FPg12smJ80UkhgXrCwkh
        Om6ml9edhDP1/wgyALdVRGd4Ow==
X-Google-Smtp-Source: ABdhPJxLTkUPpUSEt3RRyrIG2Bs5xWffqVXOnR4K+6BykU1sxkOlPfsm/+CNHJNSYDWLEc5JcSFO/Q==
X-Received: by 2002:a62:ed02:: with SMTP id u2mr2051957pfh.60.1589419075501;
        Wed, 13 May 2020 18:17:55 -0700 (PDT)
Received: from bionicboi (ppp118-209-213-103.bras2.mel11.internode.on.net. [118.209.213.103])
        by smtp.gmail.com with ESMTPSA id p189sm690679pfp.135.2020.05.13.18.17.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2020 18:17:54 -0700 (PDT)
Date:   Thu, 14 May 2020 01:17:48 +0000
From:   Adam McCoy <adam@forsedomani.com>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: fix leaked reference on requeued write
Message-ID: <20200514011748.GB5964@bionicboi>
References: <20200513115330.5187-1-adam@forsedomani.com>
 <CAH2r5ms14KKspfjv7rc_vkWGMantAxoTE7p0bi66NmMzcex+tg@mail.gmail.com>
 <CAH2r5mtWeqZjHroapXKiN7XxYnt4XjxWuhaPSzRwNcVgrP6g+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtWeqZjHroapXKiN7XxYnt4XjxWuhaPSzRwNcVgrP6g+g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Part of this makes sense Pavel reminded me:
>       in cifs_writepages() we don't need to reference wdata because we
> are leaving the function. in cifs_write_from_iter() we put all wdatas
> in the list and that's why we need an extra reference there

Yes, this looks right. cifs_writev_requeue() seems to work like
cifs_writepages() in that the wdata2 reference disappears when the loop
exits. If the loop iterates a new struct is created each time.

> and wouldn't there be an underrun if a retryable error with your patch
> with it getting called twice?

There shouldn't be any difference if there is any kind of write error
(rc != 0), since the put call is just moving. The only difference
should be that the put call will happen if the write succeeds.

On Wed, May 13, 2020 at 04:04:08PM -0500, Steve French wrote:
> Part of this makes sense Pavel reminded me:
>       in cifs_writepages() we don't need to reference wdata because we
> are leaving the function. in cifs_write_from_iter() we put all wdatas
> in the list and that's why we need an extra reference there
> 
> 
> On Wed, May 13, 2020 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Shyam and Pavel noticed things which didn't make sense
> >
> > e.g. in cifs_writepages weare putting the reference unconditionally
> > but in cifs_write_from_iter we are doing the same thing.   So how was
> > this working before - should have resulted in a reference leak and
> > direct i/o shouldn't have had a chance to complete??
> >
> > and wouldn't there be an underrun if a retryable error with your patch
> > with it getting called twice?
> >
> > Jeff,
> > Any thoughts on this?
> >
> >
> >
> > On Wed, May 13, 2020 at 6:55 AM Adam McCoy <adam@forsedomani.com> wrote:
> > >
> > > Failed async writes that are requeued may not clean up a refcount
> > > on the file, which can result in a leaked open. This scenario arises
> > > very reliably when using persistent handles and a reconnect occurs
> > > while writing.
> > >
> > > cifs_writev_requeue only releases the reference if the write fails
> > > (rc != 0). The server->ops->async_writev operation will take its own
> > > reference, so the initial reference can always be released.
> > >
> > > Signed-off-by: Adam McCoy <adam@forsedomani.com>
> > > ---
> > >  fs/cifs/cifssmb.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > > index 182b864b3075..5014a82391ff 100644
> > > --- a/fs/cifs/cifssmb.c
> > > +++ b/fs/cifs/cifssmb.c
> > > @@ -2152,8 +2152,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
> > >                         }
> > >                 }
> > >
> > > +               kref_put(&wdata2->refcount, cifs_writedata_release);
> > >                 if (rc) {
> > > -                       kref_put(&wdata2->refcount, cifs_writedata_release);
> > >                         if (is_retryable_error(rc))
> > >                                 continue;
> > >                         i += nr_pages;
> > > --
> > > 2.17.1
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
> Thanks,
> 
> Steve
