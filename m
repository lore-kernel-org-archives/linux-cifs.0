Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47038C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 06:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23D4A61184
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 06:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhHYGRj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 02:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbhHYGRi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Aug 2021 02:17:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75021C061757
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 23:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=brkNA7B0TcNB+4hqEYpxJyn8wrndaQ5FC5DOKttYnRg=; b=uGG9j94EskLi6ZmOq321l/mJdC
        ETklhM9N6+t51ch4TKQ72Zz/HFgwuXxr6ems4AJbXclTkG04bel05F+hvaAk+HPr6vhYoARD/i8jF
        vnUfvo2GikmVK564kGhI4wwj3bdwlh6YM7VsX7Kw6MdjLwxQOaCDrGumizMbnSZp+3Tnr5gWZtzbD
        LccyaMM9vK1cZLlY1GaV4+BuRh9QdxY9XJB8MkamMwEJTOhcHma+YD9bgTwCrdPAUO6Eegm7Lqcuh
        v6tp2PJtybtOsRZV196yDpiVeC3zI/9ZXYUYTtiju+lotmmnPtVjJH1QCI9SCuHsEYFZ75PxqwUND
        Icy6FyMg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mImCd-00BxIt-2P; Wed, 25 Aug 2021 06:16:23 +0000
Date:   Wed, 25 Aug 2021 07:15:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: cifs_md4 convert to SPDX identifier
Message-ID: <YSXgH2KobLW0JEjP@infradead.org>
References: <CAH2r5mu-QRnkdaB=nNVY2Q3Dhb5vgnk4n0XnMADMWkEGbtchFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mu-QRnkdaB=nNVY2Q3Dhb5vgnk4n0XnMADMWkEGbtchFw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 24, 2021 at 12:15:05PM -0500, Steve French wrote:
> - *   fs/smb2/smb2maperror.c
> + *   fs/cifs/smb2maperror.c


>  /*
> + * fs/cifs_common/cifs_md4.c
> + *

This is a good reminder on why putting the file name into the top of
file comment is stupid.  Just don't do it.

