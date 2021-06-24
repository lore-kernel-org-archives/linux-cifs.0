Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42EAC48BDF
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 05:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB1F6115A
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 05:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhFXF2i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Jun 2021 01:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhFXF2i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Jun 2021 01:28:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37C4C061574
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 22:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ecqxwoaia7M9eQgNDOgUOjBV4EQXfBlNjnZwAURgD6c=; b=sAgR2kv2GtxxFUDlyHlajEpUpv
        x/HnuDGIOsN4U8/jGIflr8GOTWVWv5qILVG06MGZQ/0gomYgFGyNFdrC7iuDmoJHEeUR2jHBAAXSN
        Oh09jubGnfPwSOHH60Y9NGgUTYbizOe1PQl2B21/d/V65RzfTKuiApg3pIQ0vKcEwNiLFuxcnGHdc
        D6nWTKm3czGR5g8RU5qi/F2SelCoIEBMzejFRzOT87zAtiUOuSgHzFN995UffN8uyqFVaspUWpCue
        3UlpyydTHPBvKAfcoE/r6JwDJTw+Mwa/vG1KdW6rCDvhVA+NdzQ4Gopcr3TsqRadb0fzt1Yry4sH1
        z5cbiUAA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwHs1-00GD3F-4K; Thu, 24 Jun 2021 05:25:47 +0000
Date:   Thu, 24 Jun 2021 06:25:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] ksmbd: move fs/cifsd to fs/ksmbd
Message-ID: <YNQXWd/Bwdmpd6Ih@infradead.org>
References: <CGME20210624010230epcas1p27cee803b261296294a069e8169a03c4a@epcas1p2.samsung.com>
 <20210624005211.26886-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624005211.26886-1-namjae.jeon@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 24, 2021 at 09:52:10AM +0900, Namjae Jeon wrote:
> Move fs/cifsd to fs/ksmbd and rename the remaining cifsd name to ksmbd.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
