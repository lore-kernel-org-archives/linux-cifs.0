Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD266C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D53561450
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhEASwB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 May 2021 14:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhEASwA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 May 2021 14:52:00 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EBAC06174A
        for <linux-cifs@vger.kernel.org>; Sat,  1 May 2021 11:51:09 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a36so2042877ljq.8
        for <linux-cifs@vger.kernel.org>; Sat, 01 May 2021 11:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qmny8M+yTumM69Nd6gxEYTWzMSJy6QSPRt836W71y18=;
        b=bckgkaWuh1p1YXyR9ZtnYwoodCx128rGTSf6t3q9kYVIEcFs+yv7B7k9aDGo5V/d+j
         C7Er4asmSvEpEUnDwmLug8aL9yBZI2ryb5fdfUUIGdBnpldrot7m7V4obReJ4RUcXvgU
         d8F4Hhmi9VPECryVszU1v9j9eqYtICY6oNZGCxRlnMPmFtVJOS+Lv28ZPmS9poUKecTd
         YPn2tYU0E1WnU3xaTxcH9LiayksdRwdJx8SCXza+hpcrYitFY1rmFSQj8vDxjpGZS0Oo
         Gtcfin9ZClrEn0fKReagK3FTEI1k7+ig5WJhXg9s/JNCqxtKLW52cwX+3emLm5/OBl7r
         4pqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qmny8M+yTumM69Nd6gxEYTWzMSJy6QSPRt836W71y18=;
        b=Hs3X+7u/9q6MyXJhvd3gjlB+7l/ZVPkPBibtlktI1wgrngm/CAz+SAv81b8qt26GhY
         uS09MPu1EIDNMlmlfa50LCtsmdYeozuys0jWs0tAUplxIA0OQmPbAoIBfhfVRIM+i4Cp
         ihB4u0gNWn8EfezJCwXdeN3q99sz5OLcS709eya9cMqf9ntCGpcVGbiK4mH/rb1ZBTCt
         VnacO0OUaU+WC4jmZIt5UXNkzQIuDJEmVfKoqMsXMFQhiF0txlVlAHUeujx1ik+erfc+
         X9X/JNjFSJ+j+tR4hRwEFdhPnNyPjdCq3oTw1JtrQnCWJuaY9JAxDrJvKyGo1l3v7Wg9
         Lssg==
X-Gm-Message-State: AOAM532wOaPLagOzQ2Ut9u8QgWWJAYmO14M0KEtSfQkDza6bGqLM+WZ+
        /xvP+g/AALhMhJU3R+xDatDbZIkf3djjmfxEiZ8=
X-Google-Smtp-Source: ABdhPJyRgJDjpumsb16aEwRWLCA9LqYR8gVTSj6RyttllKr/g/kURnBBud4HdFbRUOqtSUD+yt6lAjnlQBwWh6ZTa5M=
X-Received: by 2002:a2e:9094:: with SMTP id l20mr7818331ljg.272.1619895068177;
 Sat, 01 May 2021 11:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org> <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
 <20210430115948.GL1847222@casper.infradead.org> <CAH2r5mtE2g=p_rKThrDR_4N6=zqaBiz_KpK+bPpw5Q+qeFuTjQ@mail.gmail.com>
 <20210501183502.GU1847222@casper.infradead.org> <CAH2r5msS8NR_FAZGs7NLZNMGUVZ6GfOKc_4Mn5iCLbSX7DAYMA@mail.gmail.com>
In-Reply-To: <CAH2r5msS8NR_FAZGs7NLZNMGUVZ6GfOKc_4Mn5iCLbSX7DAYMA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 May 2021 13:50:57 -0500
Message-ID: <CAH2r5ms7f_cZmM84eOqjrKwaBEFL_KRaFT-EO2=D3XYMKvfvzg@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Forgot to mention another obvious point ... the number of 'channels'
is dynamic for some filesystems.
For example clustered SMB3 servers can notify the clients
asynchronously when more 'channels'
are added (more network connections added - e.g. in cloud environments
or clustered high performance
server environments you can temporarily add more high performance
ethernet or RDMA adapters temporarily to the host)
so it is quite possible that the server can indicate to the client
that more network throughput is now available
(Windows takes advantage of this, and even polls to check for new
interfaces every 10 minutes, but the Linux client
does not yet - but it is something we will likely add soon).

On Sat, May 1, 2021 at 1:47 PM Steve French <smfrench@gmail.com> wrote:
>
> On Sat, May 1, 2021 at 1:35 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Apr 30, 2021 at 02:22:20PM -0500, Steve French wrote:
> > > On Fri, Apr 30, 2021 at 7:00 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> > > > > Although ideally, I feel that we (cifs.ko) should be able to read in
> > > > > larger granular "chunks" even for small reads, in expectation that
> > > > > surrounding offsets will be read soon.
> > > >
> > > > Why?  How is CIFS special and different from every other filesystem that
> > > > means you know what the access pattern of userspace is going to be better
> > > > than the generic VFS?
> > >
> > > In general small chunks are bad for network file systems since the 'cost' of
> > > sending a large read or write on the network (and in the call stack on
> > > the client
> > > and server, with various task switches etc) is not much more than a small one.
> > > This can be different on a local file system with less latency between request
> > > and response and fewer task switches involved on client and server.
> >
> > Block-based filesystems are often, but not always local.  For example,
> > we might be using nbd, iSCSI, FCoE or something similar to include
> > network latency between the filesystem and its storage.  Even without
> > those possibilities, a NAND SSD looks pretty similar.  Look at the
> > graphic titled "Idle Average Random Read Latency" on this page:
> >
> > https://www.intel.ca/content/www/ca/en/architecture-and-technology/optane-technology/balancing-bandwidth-and-latency-article-brief.html
> >
> > That seems to be showing 5us software latency for an SSD with 80us of
> > hardware latency.  That says to me we should have 16 outstanding reads
> > to a NAND SSD in order to keep the pipeline full.
> >
> > Conversely, a network filesystem might be talking to localhost,
> > and seeing much lower latency compared to going across the data
> > center, between data centres or across the Pacific.
> >
> > So, my point is that Linux's readahead is pretty poor.  Adding
> > hacks in for individual filesystems isn't a good route to fixing it,
> > and reading larger chunks has already passed the point of dimnishing
> > returns for many workloads.
> >
> > I laid it out in a bit more detail here:
> > https://lore.kernel.org/linux-fsdevel/20210224155121.GQ2858050@casper.infradead.org/
>
> Yes - those are good points.  Because the latencies vary the most for
> network/cluster filesystems which can vary by more than a million
> times greater (from localhost and RDMA (aka smbdirect) which can be
> very low latencies, to some cloud workloads which have longer
> latencies by high throughput, or to servers where the files are
> 'offline' (archived or in the cloud) where I have seen some examples
> where it could take minutes instead) - it is especially important for
> this in the long run to be better tunable.  In the short term, at
> least having some tuneables on the file system mount (like Ceph's
> "rapages") makes sense.
>
> Seems like there are three problems to solve:
> - the things your note mentions about how to get the core readahead
> code to ramp up a 'reasonable' number of I/Os are very important
> but also
> - how to let a filesystem signal the readahead code to slow down or
> allow partially fulfilling read ahead requests (in the SMB3 case this
> can be done when 'credits' on the connection (one 'credit' is needed
> for each 64K of I/O) are starting to get lower)
> - how to let a filesystem signal the readahead code to temporarily
> stop readahead (or max readahead at one i/o of size = readsize).  This
> could happen e.g. when the filesystem gets an "out of resources" error
> message from the server, or when reconnect is triggered
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
