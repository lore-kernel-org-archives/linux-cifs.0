Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF92C4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 04:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8263061289
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 04:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFWEz0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWEz0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 00:55:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F6FC061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 21:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mknZCAHCAT+pSWNZyA9zsy6uWIo9tIVMMyprO3/Imd8=; b=eg2shKvwHWLyo6AqOnqiqnDC5l
        R6aF1T6xMCGoWQoWO4cwAIKB3dECh7DwpFOiWt5NX5rtiaoKHOVSuEpy3uRlhCfobRlKwJS0l8khm
        wr3d0vEk3icxtJ1KzTUA7BLdH2SgkqVRxMO0pVhGyR6iN9H1Mcq+SgbXoHK2QCr+hIGUkhJnwk9Eu
        ZtjM7VSn80PAn28unUXaxw7NBzpCd1VA2UP6FKiKV4WAW7jN+AWaGSeujfQOKO+f3Ju96cAObqA+s
        1fs+JR8x+zZxKnVqX7D4sa6V5zidgUfPXzF13pQ0dFszMB46Rg8rZlwpGoub9FmJj427HAJcNStoR
        TzmjBeyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvusS-00F352-6k; Wed, 23 Jun 2021 04:52:41 +0000
Date:   Wed, 23 Jun 2021 05:52:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Aur??lien Aptel <aurelien.aptel@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: ksmbd mailing list
Message-ID: <YNK+GKA0aXoxhgdF@infradead.org>
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
 <YNF/OpvdMLbIDZiZ@infradead.org>
 <013001d76734$0cf3bee0$26db3ca0$@samsung.com>
 <87mtriqj6v.fsf@suse.com>
 <006501d767d9$361eeec0$a25ccc40$@samsung.com>
 <CAH2r5msB8Y8qn+DFV=3g=K791p1ssFJh=+yNOC4bG8iW3K07tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msB8Y8qn+DFV=3g=K791p1ssFJh=+yNOC4bG8iW3K07tw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 22, 2021 at 09:52:33PM -0500, Steve French wrote:
> We should probably put a few lines in the cifsd and cifs client wiki
> pages on samba.org and also in the kernel documentation directory for
> each that notes that emails with patches should have a prefix that
> indicates whether server or client or utils (e.g. [cifsd] or [ksmbd]
> if you prefer, [cifs] for the client and [cifs-utils] for the tools)

The normal kernel patch prefixes would be:

cifs:

and

ksmbd:
