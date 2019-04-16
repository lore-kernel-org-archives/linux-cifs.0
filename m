Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB45C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 19:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 393CB2073F
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 19:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfDPT5w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbfDPT5u (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Apr 2019 15:57:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6EA7F74CE;
        Tue, 16 Apr 2019 19:57:49 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 883AF608C7;
        Tue, 16 Apr 2019 19:57:38 +0000 (UTC)
Date:   Tue, 16 Apr 2019 15:57:35 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Boaz Harrosh <boaz@plexistor.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
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
        Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
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
Message-ID: <20190416195735.GE21526@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 16 Apr 2019 19:57:50 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 16, 2019 at 10:28:40PM +0300, Boaz Harrosh wrote:
> On 16/04/19 22:12, Dan Williams wrote:
> > On Tue, Apr 16, 2019 at 11:59 AM Kent Overstreet
> > <kent.overstreet@gmail.com> wrote:
> <>
> > This all reminds of the failed attempt to teach the block layer to
> > operate without pages:
> > 
> > https://lore.kernel.org/lkml/20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com/
> > 
> 
> Exactly why I want to make sure it is just a [pointer | flag] and not any kind of pfn
> type. Let us please not go there again?
> 
> >>
> >> Question though - why do we need a flag for whether a page is a GUP page or not?
> >> Couldn't the needed information just be determined by what range the pfn is not
> >> (i.e. whether or not it has a struct page associated with it)?
> > 
> > That amounts to a pfn_valid() check which is a bit heavier than if we
> > can store a flag in the bv_pfn entry directly.
> > 
> > I'd say create a new PFN_* flag, and make bv_pfn a 'pfn_t' rather than
> > an 'unsigned long'.
> > 
> 
> No, please please not. This is not a pfn and not a pfn_t. It is a page-ptr
> and a flag that says where/how to put_page it. IE I did a GUP on this page
> please do a PUP on this page instead of regular put_page. So no where do I mean
> pfn or pfn_t in this code. Then why?
> 
> > That said, I'm still in favor of Jan's proposal to just make the
> > bv_page semantics uniform. Otherwise we're complicating this core
> > infrastructure for some yet to be implemented GPU memory management
> > capabilities with yet to be determined value. Circle back when that
> > value is clear, but in the meantime fix the GUP bug.
> > 
> 
> I agree there are simpler ways to solve the bugs at hand then
> to system wide separate get_user_page from get_page and force all put_user
> callers to remember what to do. Is there some Document explaining the
> all design of where this is going?
> 

A very long thread on this:

https://lkml.org/lkml/2018/12/3/1128

especialy all the reply to this first one

There is also:

https://lkml.org/lkml/2019/3/26/1395
https://lwn.net/Articles/753027/

Cheers,
Jérôme
