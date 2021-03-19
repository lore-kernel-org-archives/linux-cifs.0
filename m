Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D6FC433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D3C61928
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCSPWO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCSPWG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 11:22:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AC4C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xuoVCk3geodiQ/EnuWOEnGT4IaoGRp7CHn1ypCeWDkQ=; b=hP+ClmFiFwB4i+YkyfaIein/OA
        BS5udMNnsS3wUgQJmMqxzm03k70skkXM8oGDZY55I51t5Onkgta5OH8KuyQR39MRJyLBF3/opCsJZ
        BG+RhaXvys2m3XxzdpssTaozGVNRFFytbP3ThAVneTLJGqN1wkXPYDK6/Dqe+ZE6Y/WWrY4mkCKcb
        5yWFEReo6sRpKPDC4uYxeo20qCZ+DrGmY6ofMT/GNJByWHpjCmUcIp10Vs667Az+/34WmiGAgL3LT
        B4/gA2VcxEPp5PIJE6v8wp9annbMNqdAWpmGVjdKXthIRj9Exm3iXW7IqvsKhqhJrwt/GX4crbEJU
        mi9qKQVQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lNGw2-004cRZ-KD; Fri, 19 Mar 2021 15:21:20 +0000
Date:   Fri, 19 Mar 2021 15:21:10 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [bug report] cifsd: introduce SMB3 kernel server
Message-ID: <20210319152110.GA1100251@infradead.org>
References: <YFNRsYSWw77UMxw1@mwanda>
 <20210319131232.GA1057389@infradead.org>
 <CAH2r5muai5cA7C+Afku-PjgHCm9Zh+SkEiU1jvybL4xi-bre8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muai5cA7C+Afku-PjgHCm9Zh+SkEiU1jvybL4xi-bre8g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Code that goes into linux-next needs to be posted to the relevant
lists, which in this case includes linux-fsdevel and linux-kernel.  No
backstory of conference and internal trees replaces that in any way.
