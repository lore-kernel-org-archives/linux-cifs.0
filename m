Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F899C32751
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 21:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21DA921773
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564608467;
	bh=7eXmTgsfYzdQB/da8h/btuCwwBwTnk2EjWb/KNrq6mU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=emDUQKJCxCO7SVmcNTOEBQHF8j8kapyvyLCZ+9wLxapPt9zCR04zS6NYn2rabrBNz
	 VxD+euN10qtVfYdAJjPFpqqlDvOLJk+zt6tD9/B2yzA9mEOVDxHctBodYx2f4QXJAX
	 q60i6kQdZf0tw3joESwPGe4Kgy76RGbwe7htggRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfGaV1q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 17:27:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfGaV1q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Jul 2019 17:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ojbkQD1a7MQMcAHB0nbk0TNEefbMHs3972JP2NcjJME=; b=g83i6fG6pLz5k+ubFSnN8EkA5
        UONDm7X0pnk+aEXdmFccZHoiA/MwLcT3bciBvO1P/EPjm9w8DWxTy97HZrc+BdRKb+EgxEQ2sotEY
        MsEte0kaui9SJBYnpz2cVbQjTQfjElvMKIWI6V5wqmkV+8dU6kjbQ/91+vlvuSzIz08B81Pm1tR53
        Hvm/XYnYMcHDHQYcvFC6f8pqy/unIZORk47M8Lmo1dFfIdsORd+7CHhf8lrV4waeQjIwLfl27lujE
        JiRPbITNDfNg+OgMhYM3B51EPP6j7Bw+mnUM0iyfG5dpLSulcXgKe3UHGtWtHkzcxSQw4+I3NKq51
        irVg2nqrA==;
Received: from [191.33.152.89] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hsw8I-0001T3-HP; Wed, 31 Jul 2019 21:27:38 +0000
Date:   Wed, 31 Jul 2019 18:27:29 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        samba-technical@lists.samba.org, devicetree@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Jonathan Cameron <jic23@kernel.org>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Steve French <sfrench@samba.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-cifs@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-spi@vger.kernel.org
Subject: Re: [PATCH 0/6] ReST conversion patches not applied yet
Message-ID: <20190731182729.01c98cd3@coco.lan>
In-Reply-To: <20190731203712.GJ4369@sirena.org.uk>
References: <cover.1564603513.git.mchehab+samsung@kernel.org>
        <20190731141734.1fa9ce64@lwn.net>
        <20190731202007.GI4369@sirena.org.uk>
        <20190731172613.32d65ad8@coco.lan>
        <20190731203712.GJ4369@sirena.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Em Wed, 31 Jul 2019 21:37:12 +0100
Mark Brown <broonie@kernel.org> escreveu:

> On Wed, Jul 31, 2019 at 05:26:13PM -0300, Mauro Carvalho Chehab wrote:
> > Mark Brown <broonie@kernel.org> escreveu:  
> 
> > > There were outstanding questions about where it was going to get moved
> > > to but if I read the diff correctly it looks like it didn't actually get
> > > moved in the end?  
> 
> > Yeah, it doesn't have the move. My understanding from our discussions
> > is that we didn't reach a conclusion.  
> 
> Yes, that was my understanding too which was why I was surprised to see
> this going in.  This is OK then, I'd have acked it.
> 
> > In any case, I can send a separate patch with the move part once
> > we reach an agreement about what's the best way to proceed (or you
> > can do it directly, if you prefer so).  
> 
> I'm not likely to do anything without someone sending patches, I'm not
> clear on the utility of the move with the current division of the
> manuals.

Same here: I do see value on having docs focused on their audience.

Yet, I'm not so sure how worth is to break some subsystem documentation 
into books, as, on some cases, this would mean huge efforts.

I'd prefer to see the big picture first, finishing the conversion and
then looking at the resulting docs.

Meanwhile, if someone needs something that it is at the wrong book, he
can just use some search tool to seek what he needs, no matter on
what book the relevant information is stored.

> I don't know if it makes sense to have an embedded developer's
> manual as well?

Yeah, that's a good question. 

Jon is planning todo a documentation track at LPC. One of the things
that should be discussed, IMO, is how we'll organize the books.

I suspect that, once we finish the conversion of the remaining ~300
files to ReST, the next logical step is to check what are the gaps
and have a list of pending tasks.

Thanks,
Mauro
