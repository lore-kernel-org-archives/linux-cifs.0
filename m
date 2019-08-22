Return-Path: <SRS0=yfix=WS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD30C3A5A1
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 22:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1859021655
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 22:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2Oi2D2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394173AbfHVWqX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:46:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37869 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394171AbfHVWqX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Aug 2019 18:46:23 -0400
Received: by mail-io1-f66.google.com with SMTP id q22so15593682iog.4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2019 15:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97giE2qTSf7Ll6aMfBGTim9Q2aKI/p1daYxAX6PB0Ho=;
        b=T2Oi2D2+05kcdbN3eWZRIX31o/co5SQDSObCg1E23MCgscYzbj7nQzrEldQmMc6Eex
         jTyBptkIXpS+7PEKsWmJNmDNDGlzJoYhN65ny4PFUOTFR1E9yDDgvLxrrSo2E8sv04ev
         MqWKpPF289OZk0UkyColesuQDr8IZZnz/6L9Tglw8rzQSibtekXV4wND7bnLd6ywACJF
         0se1vbZ5JEc1H1ex6aHcKGDMmz10gu8ixo4Ofs4lgLEh1AfrIxYZ8wuGfhzp0vMO4anw
         KTQsfjtOd08hKn8eGK8D2ragYk7bnuH54smRyfUtkE/HFeggC+hxpdZ2h78apNJWyLaW
         GM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97giE2qTSf7Ll6aMfBGTim9Q2aKI/p1daYxAX6PB0Ho=;
        b=C1BjJ7C/ip55krE+Ge/TCIbGayv7pPtsbnUnppUbUK6Wz3WtUJ6Fl64g871sw+ZCzt
         A6H0RS5TA6hNS2YXQpQhe84DT3bjg8mAwIZ7WhgeOKFpUtWGlY4pnSkIVglef+5LFagV
         fOEgH449dqs8QVXK6caevWUWiMF2s3syjrVr6ik3SyHPoPCuK4/GUwFSRcMgVZ1w7O7g
         pEdGgQRC/08oQmm6ZIchGXUoIb4iYTBqcNSk+eaBXXIXdoj9xMv3QWHsp0o7Wi3yqZxH
         5pF+Rd1h1xhdH8Tk0VsH1LGNiBWtm/tMAvDeLc93RJwfeVb4KaaHXEUvxz3DzGbkv+2M
         dP9Q==
X-Gm-Message-State: APjAAAWlGYXv6E34GksuB5zGUxsO+Ykxw3BhndqYBl0FqOVETYVNdWdj
        it0iAdufNo2w6hCnzy+JlJ4RJobC6LUXpzMWTgE=
X-Google-Smtp-Source: APXvYqzAy8rYnCA0SY03jGDLg/XVp9sl7XDNG8Xfb4Yz/SgbLyJQbnw6FVOdVcAlXIxv7yXdN7DTr+JTFo7zUZzR7dc=
X-Received: by 2002:a6b:5a12:: with SMTP id o18mr2688362iob.159.1566513982756;
 Thu, 22 Aug 2019 15:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
 <20190815174854.05661672@suse.de> <CAN05THThHLkSF=oVBezJQBsre7QoH6eS=SLbxo3Z=w8M+fa=RQ@mail.gmail.com>
 <CAN05THT3NF+eAd=H+gpmZQp0SWBQ0iFe32TT0VB5_rmibcN2Cw@mail.gmail.com>
 <20190819183151.15642e8f@suse.de> <20190820000348.440ee8ce@suse.de> <MWHPR2101MB07318FE687DAC9C78A54D1D3A0AB0@MWHPR2101MB0731.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR2101MB07318FE687DAC9C78A54D1D3A0AB0@MWHPR2101MB0731.namprd21.prod.outlook.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 23 Aug 2019 08:46:10 +1000
Message-ID: <CAN05THSu=z4RoenzSYZjTUqBpz86DfLSKaoX==uwwPKsDyBO2w@mail.gmail.com>
Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     David Disseldorp <ddiss@suse.de>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 21, 2019 at 3:47 AM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of David Disseldorp
> > Sent: Monday, August 19, 2019 6:04 PM
> > To: ronnie sahlberg <ronniesahlberg@gmail.com>
> > Cc: linux-cifs <linux-cifs@vger.kernel.org>
> > Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
> >
> > On Mon, 19 Aug 2019 18:31:51 +0200, David Disseldorp wrote:
> >
> > > Nothing stands out in the captures to me, but I'd be curious whether you
> > > see any differences in behaviour if you set write-through on open or
> > > explicitly FLUSH after the SET-SPARSE call.
> >
> > Hmm actually it looks like there's already a FLUSH shortly after the
> > mtime update following the SetInfo(EOF). One thing that does look a
> > little weird is the AllocationSize field before that FLUSH - in
> > seek_bad.cap.gz it's 2M, whereas it's ~6M in seek_good.cap.gz.
>
> Another oddity is that the FSCTL_SET_SPARSE comes *after* the 2MB
> write. It seems entirely possible that filesystem may have decided to
> allocate additional blocks during the write, in expectation of more
> writes. Since the EOF pointer is still 2MB, I believe the filesystem may
> be well within its rights there. In any event there may be a timing thing
> going on, because it's doing immediately:
>
> write 2MB
> fsctl SET_SPARSE
> setinfo EOF=4MB
> compound open+mtime+close (why a new handle for setting mtime btw?)

It is because internally in the kernel API setting this timestamps is
a path based call.
We could search for and see if there is a writeable open handle and
use that IF there is such handle but it would be more code and
complexity.

It was just easier to make it into a compound. It should be cheap
enough and have no ill effects.

> getinfo
> flush
> fsctl QUERY_ALLOCATED_RANGES
>
>
> The NTFS developers were kind of skeptical of the approach of looking
> at the block allocation counts to detect holes. The first example they
> mentioned was a small file, like 400 bytes, for which the entire content
> would fall into the MFT record. Such a file would show zero blocks
> allocated, regardless of sparseness.

Ok, fair enough.
So if the filesystem has heuristics that can cause it to allocate
extra blocks like that (not unreasonable)
then it just means that these xfstests make assumptions about the
filesystem that are just not guaranteed to be true
when used with cifs.

That is fair enough. It just means there is no bug. It is just that
the test tool is not compatible with ntfs.
I can live with that. I do run it against btrfs and there I get the
result to allow me to run this part of the test in
the regression testsuite. That is good enough for me.

Thanks
Ronnie Sahlberg

>
> Tom.
>
