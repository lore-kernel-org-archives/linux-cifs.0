Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588AEC433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 11:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2107361263
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 11:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhDZLzw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 07:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbhDZLzv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Apr 2021 07:55:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BC4C061574
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 04:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v+Aoe47SRpt7ZNhdB+pix8NWKLj8lrXqaL+hUh9fI00=; b=IZeHAPkC9/5BDu5Bd7eEpT22rc
        EGjTYomACU1srmVcRc5i5J/qYKIBXfvhvXVtLiIFb3r3sRJZpO3ToIblKkXteprqrx2fAru0tM8pY
        cz8wsxglsKps3Ox7qPSbu7hyswSExdwIf2JiYrfsLX6MuSHOp9ITYiSadF3nbtg8iYZTIgKAc3ci3
        7dksMPAun97FmQPEfmZJglKRDN7gulWrRLoch9+H1CKqwt2VB8b3MC7o6xw9VXmrJ++zI35PvHtn1
        NolimAgTq+Abge4DK05NiXP5gIM+htnuxJRQcb8hC4V6WokMVjsxLflkRMNeJ4voMu6dFxgqsMnDR
        roxpJcNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lazpJ-005ZPZ-PJ; Mon, 26 Apr 2021 11:55:00 +0000
Date:   Mon, 26 Apr 2021 12:54:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
Message-ID: <20210426115457.GJ235567@casper.infradead.org>
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org>
 <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Apr 26, 2021 at 10:22:27AM +0530, Shyam Prasad N wrote:
> Agree with this. Was experimenting on the similar lines on Friday.
> Does show good improvements with sequential workload.
> For random read/write workload, the user can use the default value.

For a random access workload, Linux's readahead shouldn't kick in.
Do you see a slowdown when using this patch with a random I/O workload?

