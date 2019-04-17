Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C98C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83014217FA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733049AbfDQVTz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfDQVTz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Apr 2019 17:19:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7062D307EAA0;
        Wed, 17 Apr 2019 21:19:53 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 830616014E;
        Wed, 17 Apr 2019 21:19:45 +0000 (UTC)
Date:   Wed, 17 Apr 2019 17:19:43 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Boaz Harrosh <boaz@plexistor.com>
Cc:     Boaz Harrosh <openosd@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
        Dominique Martinet <asmadeus@codewreck.org>,
        v9fs-developer@lists.sourceforge.net, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org,
        Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Message-ID: <20190417211943.GA24523@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
 <20190416195735.GE21526@redhat.com>
 <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
 <20190416231655.GB22465@redhat.com>
 <fa00a2ff-3664-3165-7af8-9d9c53238245@plexistor.com>
 <20190417020345.GB3330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190417020345.GB3330@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 17 Apr 2019 21:19:54 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 16, 2019 at 10:03:45PM -0400, Jerome Glisse wrote:
> On Wed, Apr 17, 2019 at 04:11:03AM +0300, Boaz Harrosh wrote:
> > On 17/04/19 02:16, Jerome Glisse wrote:
> > > On Wed, Apr 17, 2019 at 01:09:22AM +0300, Boaz Harrosh wrote:
> > >> On 16/04/19 22:57, Jerome Glisse wrote:

[...]

> > >>
> > >> BTW: Are you aware of the users of iov_iter_get_pages_alloc() Do they need fixing too?
> > > 
> > > Yeah and that patchset should address those already, i do not think
> > > i missed any.
> > > 
> > 
> > I could not find a patch for nfs/direct.c where a put_page is called
> > to balance the iov_iter_get_pages_alloc(). Which takes care of for example of
> > the blocklayout.c pages state
> > 
> > So I think the deep Audit needs to be for iov_iter_get_pages and get_user_pages
> > and the balancing of that. And the all of bio_alloc and bio_add_page should stay
> > agnostic to any pege-refs taking/putting
> 
> Will try to get started on that and see if i hit any roadblock. I will
> report once i get my feet wet, or at least before i drown ;)

So far it does not look too bad:

https://cgit.freedesktop.org/~glisse/linux/log/?h=gup-bio-v2

they are few things that will be harder to fit in like splice
and pipe that are populated from GUP.

Cheers,
Jérôme
