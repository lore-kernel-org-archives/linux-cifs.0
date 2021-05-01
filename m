Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA136C433ED
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B711B613B4
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhEASsb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 May 2021 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhEASsa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 May 2021 14:48:30 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9060DC06174A
        for <linux-cifs@vger.kernel.org>; Sat,  1 May 2021 11:47:38 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n138so2072701lfa.3
        for <linux-cifs@vger.kernel.org>; Sat, 01 May 2021 11:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LRSEgu3Jp9i3JJqF8rPbTedvohMiQPmKdHMtrBhjmOw=;
        b=QdG4frL8d25UO3QZ4/5785KBs+fdFTjGy4LxAGoJUYCkc672EtbzcrPgIwFcERGEv6
         gEk2b8TGXz3uigVdZnx9aChllaNoxZ5alEpYT/u95SU+r8N94P7/d1lKzq/0kwMgHBX8
         siZT8x0T0keJApnEfPCIaEFnQoQH2KjSPQ/RWrm6C4zQ2OOD6T991xQJqkZKD8xmSku7
         6p3PkpRjYbJ0aht6WzeuIbpy9Se0unOmSVKRmzpgPV6ODeqN70g0KHWyFKC+Uqwpn5l1
         pIEiLcfK1P3v8t5+QyWK5T46NWPtCZ79sJDBYmwiUMmE66gGP+I7GcnLn0UXORXFIEHB
         KIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LRSEgu3Jp9i3JJqF8rPbTedvohMiQPmKdHMtrBhjmOw=;
        b=RqrRtDblpFCWPPPpybI/DY3D7tgz77Hbk4Er7dElhZMw4kOyynny0ktczNAh5LUZUy
         sHvu1jd3aWKiUEN78/pPS10qYUjXccVKYBqaOCPVQYRecSmq/qwm1ewQri/t4KrIHKRj
         uqnzLkvkm8P9+C5poo96d+9Pyc/YvjbXomANtr3zSOV4RVaphSRWNykCcKBRCROmrkw1
         pStyEQna3rjpCdQQNS20KBDogRc+kstAxENJQFJlA99KJZY/vWCLUsY99BJ4bC7yNfsn
         UbJ667T4DB1SMhg7H/qxNqmY7sgNecQzz3HuFIJCSWhml5bJjWAILd5G4EG676GXEQNR
         xXKw==
X-Gm-Message-State: AOAM532p3YA6gF5IqL+mS/3j1QDT+H+lNBQwXpFJHKltVVx3KsnAdkXB
        sMlEbZq1S9+zv6jZHqTaLIRERXqvnIHn+xfaM8A=
X-Google-Smtp-Source: ABdhPJw5NSFAOOrKFRQBAfYukN89ItfFVxiKt1kqDfehkQ7evF1ufsNBcI5uUEdyeTZk8dhKxjPegX6QiZF9PtUGhYw=
X-Received: by 2002:a19:f504:: with SMTP id j4mr7634469lfb.307.1619894856850;
 Sat, 01 May 2021 11:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org> <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
 <20210430115948.GL1847222@casper.infradead.org> <CAH2r5mtE2g=p_rKThrDR_4N6=zqaBiz_KpK+bPpw5Q+qeFuTjQ@mail.gmail.com>
 <20210501183502.GU1847222@casper.infradead.org>
In-Reply-To: <20210501183502.GU1847222@casper.infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 May 2021 13:47:25 -0500
Message-ID: <CAH2r5msS8NR_FAZGs7NLZNMGUVZ6GfOKc_4Mn5iCLbSX7DAYMA@mail.gmail.com>
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

On Sat, May 1, 2021 at 1:35 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Apr 30, 2021 at 02:22:20PM -0500, Steve French wrote:
> > On Fri, Apr 30, 2021 at 7:00 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> > > > Although ideally, I feel that we (cifs.ko) should be able to read in
> > > > larger granular "chunks" even for small reads, in expectation that
> > > > surrounding offsets will be read soon.
> > >
> > > Why?  How is CIFS special and different from every other filesystem that
> > > means you know what the access pattern of userspace is going to be better
> > > than the generic VFS?
> >
> > In general small chunks are bad for network file systems since the 'cost' of
> > sending a large read or write on the network (and in the call stack on
> > the client
> > and server, with various task switches etc) is not much more than a small one.
> > This can be different on a local file system with less latency between request
> > and response and fewer task switches involved on client and server.
>
> Block-based filesystems are often, but not always local.  For example,
> we might be using nbd, iSCSI, FCoE or something similar to include
> network latency between the filesystem and its storage.  Even without
> those possibilities, a NAND SSD looks pretty similar.  Look at the
> graphic titled "Idle Average Random Read Latency" on this page:
>
> https://www.intel.ca/content/www/ca/en/architecture-and-technology/optane-technology/balancing-bandwidth-and-latency-article-brief.html
>
> That seems to be showing 5us software latency for an SSD with 80us of
> hardware latency.  That says to me we should have 16 outstanding reads
> to a NAND SSD in order to keep the pipeline full.
>
> Conversely, a network filesystem might be talking to localhost,
> and seeing much lower latency compared to going across the data
> center, between data centres or across the Pacific.
>
> So, my point is that Linux's readahead is pretty poor.  Adding
> hacks in for individual filesystems isn't a good route to fixing it,
> and reading larger chunks has already passed the point of dimnishing
> returns for many workloads.
>
> I laid it out in a bit more detail here:
> https://lore.kernel.org/linux-fsdevel/20210224155121.GQ2858050@casper.infradead.org/

Yes - those are good points.  Because the latencies vary the most for
network/cluster filesystems which can vary by more than a million
times greater (from localhost and RDMA (aka smbdirect) which can be
very low latencies, to some cloud workloads which have longer
latencies by high throughput, or to servers where the files are
'offline' (archived or in the cloud) where I have seen some examples
where it could take minutes instead) - it is especially important for
this in the long run to be better tunable.  In the short term, at
least having some tuneables on the file system mount (like Ceph's
"rapages") makes sense.

Seems like there are three problems to solve:
- the things your note mentions about how to get the core readahead
code to ramp up a 'reasonable' number of I/Os are very important
but also
- how to let a filesystem signal the readahead code to slow down or
allow partially fulfilling read ahead requests (in the SMB3 case this
can be done when 'credits' on the connection (one 'credit' is needed
for each 64K of I/O) are starting to get lower)
- how to let a filesystem signal the readahead code to temporarily
stop readahead (or max readahead at one i/o of size = readsize).  This
could happen e.g. when the filesystem gets an "out of resources" error
message from the server, or when reconnect is triggered


-- 
Thanks,

Steve
