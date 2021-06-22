Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68FAC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9B76100A
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhFVGOt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 02:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVGOt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 02:14:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F83C061574
        for <linux-cifs@vger.kernel.org>; Mon, 21 Jun 2021 23:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=t/Au4udF/NIUMLJYfPsvVAUiyOmLij+ySjylhAbV2AE=; b=eNjxFXVhndKknutySQTOIOgsPo
        SvhC5PW9AOOgndp8jr87rNYS1GJOXa19aJiLtoa1PQusor2GNyWvtYxRjkEU2qKLPU+cOnsgIEn9h
        ZxWe8WE/lhYt+T8XMo/E9h+YBwMDBDhEkMkBjJJJ0kYewDYsJUnS1EWyxG3MbjHEgnKwGG3AFyxXv
        Jb3gZ+blK4euD+A/UhCnc0vO2Q3ZXT261cjJie9Z3dJxkB6eNUouV1s3RIfphgwcfWIhfbrE7AcRN
        7D8aX4lHqKHb/pVDb5Vd3uWaIAgP0/35oPXMuhJ1AGST8hSjeh5elmjXb0IZE4+5ejTRjlijTfWiK
        fgcjFJBg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvZdq-00Dx66-S5; Tue, 22 Jun 2021 06:12:18 +0000
Date:   Tue, 22 Jun 2021 07:12:10 +0100
From:   'Christoph Hellwig' <hch@infradead.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     linux-cifsd-devel@lists.sourceforge.net, linux-cifs@vger.kernel.org
Subject: ksmbd mailing list
Message-ID: <YNF/OpvdMLbIDZiZ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is there a good reason to have a ksmbd-specific list instead of pooling
all the smb3 knowledge on a single list, similar to how nfs development
works?
