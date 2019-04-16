Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEACC10F13
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 23:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA49720656
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 23:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfDPXeN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 19:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbfDPXeN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Apr 2019 19:34:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B7183199363;
        Tue, 16 Apr 2019 23:34:12 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA40E60C61;
        Tue, 16 Apr 2019 23:34:04 +0000 (UTC)
Date:   Tue, 16 Apr 2019 19:34:03 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Boaz Harrosh <openosd@gmail.com>
Cc:     Boaz Harrosh <boaz@plexistor.com>,
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
Message-ID: <20190416233402.GC22465@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
 <20190416195735.GE21526@redhat.com>
 <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 16 Apr 2019 23:34:12 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Apr 17, 2019 at 01:09:22AM +0300, Boaz Harrosh wrote:
> On 16/04/19 22:57, Jerome Glisse wrote:
> <>
> > 
> > A very long thread on this:
> > 
> > https://lkml.org/lkml/2018/12/3/1128
> > 
> > especialy all the reply to this first one
> > 
> > There is also:
> > 
> > https://lkml.org/lkml/2019/3/26/1395
> > https://lwn.net/Articles/753027/
> > 
> 
> OK I have re-read this patchset and a little bit of the threads above (not all)
> 
> As I understand the long term plan is to keep two separate ref-counts one
> for GUP-ref and one for the regular page-state/ownership ref.
> Currently looking at page-ref we do not know if we have a GUP currently held.
> With the new plan we can (Still not sure what's the full plan with this new info)
> 
> But if you make it such as the first GUP-ref also takes a page_ref and the
> last GUp-dec also does put_page. Then the all of these becomes a matter of
> matching every call to get_user_pages or iov_iter_get_pages() with a new
> put_user_pages or iov_iter_put_pages().

So sorry forgot to answer that part. So idea is to do:
    GUP() {
        ...
-       page_ref_inc(page);
+       page_ref_add(page, GUP_BIAS);
        ...
    }

with GUP_BIAS = 1024 or something big but not too big to avoid risk of
overflow by GUP. Then put_user_page() just ref_sub instead of ref_dec
the same amount.

We can have false GUP positive if a page is map so many time or reference
so many time that its refcount reach the GUP_BIAS value but considering
such page as GUPed should not be too harmful (not more harmful than what
we do with GUPed page).

So we want to call put_user_page() for GUPed page and only GUPed page so
that we keep the reference count properly balance.

Cheers,
Jérôme
