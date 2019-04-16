Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2DBC10F0E
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 00:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FA62084B
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 00:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfDPAUJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Apr 2019 20:20:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33961 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbfDPAUJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 15 Apr 2019 20:20:09 -0400
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2019 20:20:07 EDT
Received: from dread.disaster.area (pa49-195-160-97.pa.nsw.optusnet.com.au [49.195.160.97])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6CF0A43B815;
        Tue, 16 Apr 2019 10:00:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hGBWQ-0001Bf-TP; Tue, 16 Apr 2019 10:00:22 +1000
Date:   Tue, 16 Apr 2019 10:00:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     jglisse@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org,
        Ernesto A =?iso-8859-1?Q?=2E_Fern=E1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Message-ID: <20190416000022.GA1454@dread.disaster.area>
References: <20190411210834.4105-1-jglisse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190411210834.4105-1-jglisse@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=EHa8gIBQe3daEtuMEU8ptg==:117 a=EHa8gIBQe3daEtuMEU8ptg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=oexKYjalfGEA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=8ER2NWrdpJKUM3wQwksA:9
        a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> This patchset depends on various small fixes [1] and also on patchset
> which introduce put_user_page*() [2] and thus is 5.3 material as those
> pre-requisite will get in 5.2 at best. Nonetheless i am posting it now
> so that it can get review and comments on how and what should be done
> to test things.
> 
> For various reasons [2] [3] we want to track page reference through GUP
> differently than "regular" page reference. Thus we need to keep track
> of how we got a page within the block and fs layer. To do so this patch-
> set change the bio_bvec struct to store a pfn and flags instead of a
> direct pointer to a page. This way we can flag page that are coming from
> GUP.
> 
> This patchset is divided as follow:
>     - First part of the patchset is just small cleanup i believe they
>       can go in as his assuming people are ok with them.
>     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
>       done in multi-step, first we replace all direct dereference of
>       the field by call to inline helper, then we introduce macro for
>       bio_bvec that are initialized on the stack. Finaly we change the
>       bv_page field to bv_pfn.
>     - Third part replace put_page(bv_page(bio_vec)) with a new helper
>       which will use put_user_page() when the page in the bio_vec is
>       coming from GUP.
>     - Fourth part update BIO to use bv_set_user_page() for page that
>       are coming from GUP this means updating bio_add_page*() to pass
>       down the origin of the page (GUP or not).
>     - Fith part convert few more places that directly use bvec_io or
>       BIO.
> 
> Note that after this patchset they are still places in the kernel where
> we should use put_user_page*(). The intention is to separate that task
> in chewable chunk (driver by driver, sub-system by sub-system).
> 
> 
> I have only lightly tested this patchset (branch [4]) on my desktop and
> have not seen anything obviously wrong but i might have miss something.
> What kind of test suite should i run to stress test the vfs/block layer
> around DIO and BIO ?

Such widespread changes need full correctness tests run on them. I'd
suggest fstests (auto group) be run on all the filesystems it
supports that are affected by the changes in the patchset. Given you
touched bio_add_page() here, that's probably all of them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
