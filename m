Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10926C10F13
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 18:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFF020663
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 18:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLqZ8YdU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfDPS73 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:59:29 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40193 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPS73 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Apr 2019 14:59:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id x12so24556000qts.7;
        Tue, 16 Apr 2019 11:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YoZC2zS+FKxTx2vZ6WUYzGTIw/BKXAXKrZCcTRkOJJA=;
        b=gLqZ8YdU8CYnMzLxfpFDacC87ooTEk73DcFgaAyDcdgVbxyKHsFwi2+ggawZbB/7TM
         dpZyeAsWX9jCV4MD7TbFjyDFXP5OwP6mUHvwB1FaC+bN7vXSybn4L0zwYbGoEErlscT6
         ljanAl4tUTfoZzQ6C35HQXUNCZhM2XhfBFqZs/qe4bBzlXM3nGVQ771ZMo8jxSEQBB2v
         l++fPuV1gGoAvgiNSGMqrzBFODpDhmuOr2oRjbIvZSDEeE4ZbclljvDzr9GM37q4vW4D
         BGtQMRahJvaQV2N7itA2lCZTC6jZGZGCJq+AkzuihVwhmjznf9+w+aZl/UCLUhFHxRAR
         Nmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YoZC2zS+FKxTx2vZ6WUYzGTIw/BKXAXKrZCcTRkOJJA=;
        b=Fa8c93wMjQJn0q4jPTKS2cHuDD8pwv8FZXpEZoV+aDBTG0kaW62sHyvRa5+1jzUjAB
         Srx3/JC/+mdqzgFmKJLBvaRCQFlZjIrwsJZFWLq/m2GNG/jlw1Q15dTKbqUHKHpf06Kb
         SnqhRjEsdpCvqxpYw+xRQvNFDhkOAPlNgP7jVUGqq78xZGEFkbG7fW01Om5ENJD6gAWL
         GSS2Ot6inNhpCn3AtYAoiYGwigKnZR45hhgbbNmJbFoVWl/fH2WRAp/6+WJuvw3V/mXq
         zP9z49j5NQvChNyu6jhFp5Pv6JEFZn7J/4IVlXs/no3deKyK0dlMaUCkEz0EZrAh9uv0
         LaoQ==
X-Gm-Message-State: APjAAAWfJDqcbe/GmXnf9e5wIC8X1OEjk4TudyJSB+EGJYhhZxG6LHr6
        IDdjpGzGvIWyRtdKkZeCyg==
X-Google-Smtp-Source: APXvYqxublQonxyx+I8vs0rpq0ZEM4UbxUDHjzYfX6Zn8fNoLKjtcF1mR7IcgcZaODuCRUyexgtbqw==
X-Received: by 2002:ac8:33dd:: with SMTP id d29mr66851553qtb.320.1555441166744;
        Tue, 16 Apr 2019 11:59:26 -0700 (PDT)
Received: from kmo-pixel (c-71-234-172-214.hsd1.vt.comcast.net. [71.234.172.214])
        by smtp.gmail.com with ESMTPSA id v8sm33898207qtc.69.2019.04.16.11.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 11:59:25 -0700 (PDT)
Date:   Tue, 16 Apr 2019 14:59:22 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Boaz Harrosh <boaz@plexistor.com>
Cc:     jglisse@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>,
        Jan Kara <jack@suse.cz>,
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
        linux-bcache@vger.kernel.org,
        Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Message-ID: <20190416185922.GA12818@kmo-pixel>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 16, 2019 at 09:35:04PM +0300, Boaz Harrosh wrote:
> On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > This patchset depends on various small fixes [1] and also on patchset
> > which introduce put_user_page*() [2] and thus is 5.3 material as those
> > pre-requisite will get in 5.2 at best. Nonetheless i am posting it now
> > so that it can get review and comments on how and what should be done
> > to test things.
> > 
> > For various reasons [2] [3] we want to track page reference through GUP
> > differently than "regular" page reference. Thus we need to keep track
> > of how we got a page within the block and fs layer. To do so this patch-
> > set change the bio_bvec struct to store a pfn and flags instead of a
> > direct pointer to a page. This way we can flag page that are coming from
> > GUP.
> > 
> > This patchset is divided as follow:
> >     - First part of the patchset is just small cleanup i believe they
> >       can go in as his assuming people are ok with them.
> 
> 
> >     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
> >       done in multi-step, first we replace all direct dereference of
> >       the field by call to inline helper, then we introduce macro for
> >       bio_bvec that are initialized on the stack. Finaly we change the
> >       bv_page field to bv_pfn.
> 
> Why do we need a bv_pfn. Why not just use the lowest bit of the page-ptr
> as a flag (pointer always aligned to 64 bytes in our case).
> 
> So yes we need an inline helper for reference of the page but is it not clearer
> that we assume a page* and not any kind of pfn ?
> It will not be the first place using low bits of a pointer for flags.
> 
> That said. Why we need it at all? I mean why not have it as a bio flag. If it exist
> at all that a user has a GUP and none-GUP pages to IO at the same request he/she
> can just submit them as two separate BIOs (chained at the block layer).
> 
> Many users just submit one page bios and let elevator merge them any way.

Let's please not add additional flags and weirdness to struct bio - "if this
flag is set interpret one way, if not interpret another" - or eventually bios
will be as bad as skbuffs. I would much prefer just changing bv_page to bv_pfn.

Question though - why do we need a flag for whether a page is a GUP page or not?
Couldn't the needed information just be determined by what range the pfn is not
(i.e. whether or not it has a struct page associated with it)?
