Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAFDC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 04:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiCaEUg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiCaEUR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 00:20:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E6B177093
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 21:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NaBCapPU+N17sII1/uTMhIQJn5i88arYpX6k/gBI8XI=; b=LDCEY2YD43wt4Yz0MHVbpXkHQm
        Akvu2c1Nig842WKPCUUWZiEvRZChzGjjJC0vAKEAgOW3V3bynj6K1Eh1QUc0UicROU7VBRPxTykKK
        JESYznZwQXUzZ78JOVq2zQJbe4HRtC4dvzks1kFhNVQFLRE+rcHThun+8PYFUPk7tpUV2yeSRWjC1
        HOVAlontuQ/8gm1E9Lz3AvMVqVZNhTwv7zFRbciRCnYYhCjnGXptAsFynk4LOQ44nLv8vocbm4yzL
        QF06QwVnnfu9LXuu8GMoog48EOnTNtsSYEg+dJxuSqg6tZcELqC0KaC1V3b/zTdT4KCFBOg2F8SB0
        hjpETKzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZm5J-000aXG-QP; Thu, 31 Mar 2022 04:06:57 +0000
Date:   Wed, 30 Mar 2022 21:06:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: Regarding to how ksmbd handles sector size request from windows
 cllient
Message-ID: <YkUo4eLuQ8d4k2cF@infradead.org>
References: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
 <63afe0cd-7151-45e6-a7c2-2eb9212d721b@talpey.com>
 <CAKYAXd-G-NnN+1Ex2JcRJ_PDADV3PbyfRQ=qsoQ6TDq=RdHmvQ@mail.gmail.com>
 <84c7d6a4-f3e8-420e-828c-5852e21f1b08@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c7d6a4-f3e8-420e-828c-5852e21f1b08@talpey.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Leave is as-is.  128kb is not a valid sector size in Linux to start
with.  That is what people get for using weird out of tree crap.
