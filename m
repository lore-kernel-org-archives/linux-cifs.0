Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAD1C10F13
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 19:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71B320868
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 19:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfDPTtr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfDPTtr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Apr 2019 15:49:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6551308339E;
        Tue, 16 Apr 2019 19:49:45 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8618360141;
        Tue, 16 Apr 2019 19:49:38 +0000 (UTC)
Date:   Tue, 16 Apr 2019 15:49:36 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
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
        Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Message-ID: <20190416194936.GD21526@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 16 Apr 2019 19:49:46 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 16, 2019 at 12:12:27PM -0700, Dan Williams wrote:
> On Tue, Apr 16, 2019 at 11:59 AM Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> >
> > On Tue, Apr 16, 2019 at 09:35:04PM +0300, Boaz Harrosh wrote:
> > > On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> > > > From: Jérôme Glisse <jglisse@redhat.com>
> > > >
> > > > This patchset depends on various small fixes [1] and also on patchset
> > > > which introduce put_user_page*() [2] and thus is 5.3 material as those
> > > > pre-requisite will get in 5.2 at best. Nonetheless i am posting it now
> > > > so that it can get review and comments on how and what should be done
> > > > to test things.
> > > >
> > > > For various reasons [2] [3] we want to track page reference through GUP
> > > > differently than "regular" page reference. Thus we need to keep track
> > > > of how we got a page within the block and fs layer. To do so this patch-
> > > > set change the bio_bvec struct to store a pfn and flags instead of a
> > > > direct pointer to a page. This way we can flag page that are coming from
> > > > GUP.
> > > >
> > > > This patchset is divided as follow:
> > > >     - First part of the patchset is just small cleanup i believe they
> > > >       can go in as his assuming people are ok with them.
> > >
> > >
> > > >     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
> > > >       done in multi-step, first we replace all direct dereference of
> > > >       the field by call to inline helper, then we introduce macro for
> > > >       bio_bvec that are initialized on the stack. Finaly we change the
> > > >       bv_page field to bv_pfn.
> > >
> > > Why do we need a bv_pfn. Why not just use the lowest bit of the page-ptr
> > > as a flag (pointer always aligned to 64 bytes in our case).
> > >
> > > So yes we need an inline helper for reference of the page but is it not clearer
> > > that we assume a page* and not any kind of pfn ?
> > > It will not be the first place using low bits of a pointer for flags.
> > >
> > > That said. Why we need it at all? I mean why not have it as a bio flag. If it exist
> > > at all that a user has a GUP and none-GUP pages to IO at the same request he/she
> > > can just submit them as two separate BIOs (chained at the block layer).
> > >
> > > Many users just submit one page bios and let elevator merge them any way.
> >
> > Let's please not add additional flags and weirdness to struct bio - "if this
> > flag is set interpret one way, if not interpret another" - or eventually bios
> > will be as bad as skbuffs. I would much prefer just changing bv_page to bv_pfn.
> 
> This all reminds of the failed attempt to teach the block layer to
> operate without pages:
> 
> https://lore.kernel.org/lkml/20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> >
> > Question though - why do we need a flag for whether a page is a GUP page or not?
> > Couldn't the needed information just be determined by what range the pfn is not
> > (i.e. whether or not it has a struct page associated with it)?
> 
> That amounts to a pfn_valid() check which is a bit heavier than if we
> can store a flag in the bv_pfn entry directly.
> 
> I'd say create a new PFN_* flag, and make bv_pfn a 'pfn_t' rather than
> an 'unsigned long'.
> 
> That said, I'm still in favor of Jan's proposal to just make the
> bv_page semantics uniform. Otherwise we're complicating this core
> infrastructure for some yet to be implemented GPU memory management
> capabilities with yet to be determined value. Circle back when that
> value is clear, but in the meantime fix the GUP bug.

This has nothing to do with GPU, what make you think so ? Here i am
trying to solve GUP and to keep the value of knowing wether a page
has been GUP or not. I argue that if we bias every page in every bio
then we loose that information and thus the value.

I gave the page protection mechanisms as an example that would be
impacted but it is not the only one. Knowing if a page has been GUP
can be useful for memory reclaimation, compaction, NUMA balancing,
...

Also page that are going through a bio in one thread might be under
some other fs specific operation in another thread which would be
block by GUP but do not need to be block by I/O (ie fs can either
wait on the I/O or knows that it is safe to proceed even if the page
is under I/O).

Hence i believe that by making every page look the same we do loose
valuable information. More over the complexity of making all the
page in bio have a reference count bias is much bigger than the
changes needed to keep track of wether the page did came from GUP
or not.

Cheers,
Jérôme
