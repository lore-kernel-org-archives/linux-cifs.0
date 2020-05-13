Return-Path: <SRS0=OaSP=63=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CA1C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 21:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12EE420693
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 21:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icmt5b5f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEMVEV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 May 2020 17:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgEMVEV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 May 2020 17:04:21 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079C4C061A0C
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 14:04:21 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a10so426611ybc.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 14:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhBOWZJZhi6BzHGCJe4WE+DSQcpgXYF25xmDUG+jtzo=;
        b=icmt5b5fL37fSJNa6ktXUmYxWKRXBgqK+XBS+tJ8SYvaGYE8whB8Th8Ojs0I5GqGFV
         1JEbHv/x5ieLQjQiXSvvcOCANb+oe1+L8WOo9Ho/eia2m2fBdCPtM/8pDelMdsESC6hp
         A14w73D9w4//x+FOQfGJdrZHE/soXfUIipUnZUsEKl29ar8m95q6+aNBoHpI5I+roZ9E
         q5MozIEbh6bu4dQG+rTNdRtFyJBkaA030BDCpjtQsVg3I7qvvtn467l0D7xqaeMsQh6G
         2Jr4LLGZRFUBD4C8HGuAuCa6Zj8+TZ75RMK2/B6fvtp/5tpbQixS8KGWDoriMOFilwmQ
         S2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhBOWZJZhi6BzHGCJe4WE+DSQcpgXYF25xmDUG+jtzo=;
        b=p03TuIdg9jLR570VB3KW9sXmvD4Lbphs3iFuO23+s5DhcmXl5wjpnjqpuEN1mH4P5+
         v65dmMsec7hopmNiyv7MVtGOu/hcG9BQ55p4Yr7ZiAR9JF+A/5pPfQcCYc3N6Zex/DrC
         cOvrg1VqZM9E4jmw3NeE0a6kY0p70kVhkh23EqUsdcBoAJ6ZmgLWUXxdYscczF/0Wabo
         RL9O9066nZSoWzEY9DXabX5LcZ1hAXhqu4SInUgSQLcLD8ysLpDWGL1nU3285x6of3zi
         827JcELzfzvjxFEAH4m54vWSiFNlqnaDI+IQMI0b5n9g0jRvj0e6cVHIcwQeU9Op6iGY
         jldg==
X-Gm-Message-State: AOAM5314Q3bELTiUt3EeI+gjydOhrGiDio/aN1pW5cQA4rRaPHS6O9j/
        uiytlTQBH2Kn+6F+h2LKwV8Yzlo9ij/skbR7w2TXuDkytFQ=
X-Google-Smtp-Source: ABdhPJyr/Epig9jPRKnTAvPZmEsGnR39hwCA9aG35Mw8eu1DR/WNwmRU390HY8e84X1lPqpUAiz8gyGn52jLM7IjXgM=
X-Received: by 2002:a25:b94:: with SMTP id 142mr1829309ybl.14.1589403860120;
 Wed, 13 May 2020 14:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200513115330.5187-1-adam@forsedomani.com> <CAH2r5ms14KKspfjv7rc_vkWGMantAxoTE7p0bi66NmMzcex+tg@mail.gmail.com>
In-Reply-To: <CAH2r5ms14KKspfjv7rc_vkWGMantAxoTE7p0bi66NmMzcex+tg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 May 2020 16:04:08 -0500
Message-ID: <CAH2r5mtWeqZjHroapXKiN7XxYnt4XjxWuhaPSzRwNcVgrP6g+g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix leaked reference on requeued write
To:     Adam McCoy <adam@forsedomani.com>, Jeff Layton <jlayton@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Part of this makes sense Pavel reminded me:
      in cifs_writepages() we don't need to reference wdata because we
are leaving the function. in cifs_write_from_iter() we put all wdatas
in the list and that's why we need an extra reference there


On Wed, May 13, 2020 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
>
> Shyam and Pavel noticed things which didn't make sense
>
> e.g. in cifs_writepages weare putting the reference unconditionally
> but in cifs_write_from_iter we are doing the same thing.   So how was
> this working before - should have resulted in a reference leak and
> direct i/o shouldn't have had a chance to complete??
>
> and wouldn't there be an underrun if a retryable error with your patch
> with it getting called twice?
>
> Jeff,
> Any thoughts on this?
>
>
>
> On Wed, May 13, 2020 at 6:55 AM Adam McCoy <adam@forsedomani.com> wrote:
> >
> > Failed async writes that are requeued may not clean up a refcount
> > on the file, which can result in a leaked open. This scenario arises
> > very reliably when using persistent handles and a reconnect occurs
> > while writing.
> >
> > cifs_writev_requeue only releases the reference if the write fails
> > (rc != 0). The server->ops->async_writev operation will take its own
> > reference, so the initial reference can always be released.
> >
> > Signed-off-by: Adam McCoy <adam@forsedomani.com>
> > ---
> >  fs/cifs/cifssmb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 182b864b3075..5014a82391ff 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -2152,8 +2152,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
> >                         }
> >                 }
> >
> > +               kref_put(&wdata2->refcount, cifs_writedata_release);
> >                 if (rc) {
> > -                       kref_put(&wdata2->refcount, cifs_writedata_release);
> >                         if (is_retryable_error(rc))
> >                                 continue;
> >                         i += nr_pages;
> > --
> > 2.17.1
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
