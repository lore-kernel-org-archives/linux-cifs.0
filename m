Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197EAC282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D192184B
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="mNXBi6fQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbfDQVxt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:53:49 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38762 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387449AbfDQVxk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 17:53:40 -0400
Received: by mail-oi1-f194.google.com with SMTP id a6so21104oie.5
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 14:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bmWs4cfcbPpVqJOif+pRxG1XcZMU7gy3yov8rwtSMcA=;
        b=mNXBi6fQESbyNgWoPJY7N13rwrd4xj6HYS5Lh3w1uIDtpX1jEKuq/1CY0sXLMgffyd
         8fZ6OewqjPjD5p1dwCTsSN1W1JI3+mAdGAgxxXw75SBC6d+ViIpSkPHWX5e5RJagZjvQ
         yjyjDElcbDvHNl9O5W+P579YMN+Hj4U+LrEN+x8Tx6zusmLLB4Z4jJcmnJV1+UsdIb3F
         1jz7zS/16yvMO624WsnVUtKXz4hREDASy23Mdu0AVjgHo/MQiqVzCTWgdALrvHGuAXsn
         Ga4vq1ZdMjyFyMjjBa4qxfrflIh+TF3ZFVeRDTP9cYV0z9LNe75WG0zQVSvJDsu+rJAK
         ZpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bmWs4cfcbPpVqJOif+pRxG1XcZMU7gy3yov8rwtSMcA=;
        b=TTpVgIPWU157wT4Z1GGaWeqR/2UGb3GzNO1zXmjHiwt4vSkQ+BrqMMtk/egGY9F6ba
         fQtRy2jLZlrYMw8ZIeiAuqhyOJcAsYlobRG4MBYb1rEvsXN6TTgG5vyOOXpOKj4aEAwK
         sE8c9L2+zjszpSeG5yKKDVQhs1Vej73+V+dJO9fSFmmaBdacBRRPnacXA9TxpvEldjYa
         SAKQNJ2VCI3ttjVcdux6AmsM/QxHCt7ndIB/NoadvTCfuOBlvuYZ/pJBLoeVUNDjG+Gc
         ZHzqj9ufmoXfrcH8D7/OxShwsV+fh9w1OXbcKs+3GhdXiPswnJlk9msw7HlPHJm+qdHI
         84iQ==
X-Gm-Message-State: APjAAAXzmRFhKpSPkw6shYG9mVootKSmBfPewczrhkfznlb1jpOhhB8H
        +K9Xv3oxGGn6YPfzUcZWG3SYLzfQHhqtm7xuU8BcbA==
X-Google-Smtp-Source: APXvYqyIfM8qxAG0J70YozmGmBKyUMmNKkQ53mBEzGEECW5CLl3/GymyVafAOCfvYgHDugLDiei1oDZqZT6jsakABBE=
X-Received: by 2002:aca:e64f:: with SMTP id d76mr587154oih.105.1555538019809;
 Wed, 17 Apr 2019 14:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190411210834.4105-1-jglisse@redhat.com> <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel> <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <20190416194936.GD21526@redhat.com>
In-Reply-To: <20190416194936.GD21526@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 17 Apr 2019 14:53:28 -0700
Message-ID: <CAPcyv4i-YHH+dH8za1i1aMcHzQXfovVSrRFp_nfa-KYN-XhAvw@mail.gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        v9fs-developer@lists.sourceforge.net, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Ernesto_A=2E_Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 16, 2019 at 12:50 PM Jerome Glisse <jglisse@redhat.com> wrote:
>
> On Tue, Apr 16, 2019 at 12:12:27PM -0700, Dan Williams wrote:
> > On Tue, Apr 16, 2019 at 11:59 AM Kent Overstreet
> > <kent.overstreet@gmail.com> wrote:
> > >
> > > On Tue, Apr 16, 2019 at 09:35:04PM +0300, Boaz Harrosh wrote:
> > > > On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> > > > > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > >
> > > > > This patchset depends on various small fixes [1] and also on patc=
hset
> > > > > which introduce put_user_page*() [2] and thus is 5.3 material as =
those
> > > > > pre-requisite will get in 5.2 at best. Nonetheless i am posting i=
t now
> > > > > so that it can get review and comments on how and what should be =
done
> > > > > to test things.
> > > > >
> > > > > For various reasons [2] [3] we want to track page reference throu=
gh GUP
> > > > > differently than "regular" page reference. Thus we need to keep t=
rack
> > > > > of how we got a page within the block and fs layer. To do so this=
 patch-
> > > > > set change the bio_bvec struct to store a pfn and flags instead o=
f a
> > > > > direct pointer to a page. This way we can flag page that are comi=
ng from
> > > > > GUP.
> > > > >
> > > > > This patchset is divided as follow:
> > > > >     - First part of the patchset is just small cleanup i believe =
they
> > > > >       can go in as his assuming people are ok with them.
> > > >
> > > >
> > > > >     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn thi=
s is
> > > > >       done in multi-step, first we replace all direct dereference=
 of
> > > > >       the field by call to inline helper, then we introduce macro=
 for
> > > > >       bio_bvec that are initialized on the stack. Finaly we chang=
e the
> > > > >       bv_page field to bv_pfn.
> > > >
> > > > Why do we need a bv_pfn. Why not just use the lowest bit of the pag=
e-ptr
> > > > as a flag (pointer always aligned to 64 bytes in our case).
> > > >
> > > > So yes we need an inline helper for reference of the page but is it=
 not clearer
> > > > that we assume a page* and not any kind of pfn ?
> > > > It will not be the first place using low bits of a pointer for flag=
s.
> > > >
> > > > That said. Why we need it at all? I mean why not have it as a bio f=
lag. If it exist
> > > > at all that a user has a GUP and none-GUP pages to IO at the same r=
equest he/she
> > > > can just submit them as two separate BIOs (chained at the block lay=
er).
> > > >
> > > > Many users just submit one page bios and let elevator merge them an=
y way.
> > >
> > > Let's please not add additional flags and weirdness to struct bio - "=
if this
> > > flag is set interpret one way, if not interpret another" - or eventua=
lly bios
> > > will be as bad as skbuffs. I would much prefer just changing bv_page =
to bv_pfn.
> >
> > This all reminds of the failed attempt to teach the block layer to
> > operate without pages:
> >
> > https://lore.kernel.org/lkml/20150316201640.33102.33761.stgit@dwillia2-=
desk3.amr.corp.intel.com/
> >
> > >
> > > Question though - why do we need a flag for whether a page is a GUP p=
age or not?
> > > Couldn't the needed information just be determined by what range the =
pfn is not
> > > (i.e. whether or not it has a struct page associated with it)?
> >
> > That amounts to a pfn_valid() check which is a bit heavier than if we
> > can store a flag in the bv_pfn entry directly.
> >
> > I'd say create a new PFN_* flag, and make bv_pfn a 'pfn_t' rather than
> > an 'unsigned long'.
> >
> > That said, I'm still in favor of Jan's proposal to just make the
> > bv_page semantics uniform. Otherwise we're complicating this core
> > infrastructure for some yet to be implemented GPU memory management
> > capabilities with yet to be determined value. Circle back when that
> > value is clear, but in the meantime fix the GUP bug.
>
> This has nothing to do with GPU, what make you think so ? Here i am
> trying to solve GUP and to keep the value of knowing wether a page
> has been GUP or not. I argue that if we bias every page in every bio
> then we loose that information and thus the value.
>
> I gave the page protection mechanisms as an example that would be
> impacted but it is not the only one. Knowing if a page has been GUP
> can be useful for memory reclaimation, compaction, NUMA balancing,

Right, this is what I was reacting to in your pushback to Jan's
proposal. You're claiming value for not doing the simple thing for
some future "may be useful in these contexts". To my knowledge those
things are not broken today. You're asking for the complexity to be
carried today for some future benefit, and I'm asking for the
simplicity to be maintained as much as possible today and let the
value of future changes stand on their own to push for more complexity
later.

Effectively don't use this bug fix to push complexity for a future
agenda where the value has yet to be quantified.
