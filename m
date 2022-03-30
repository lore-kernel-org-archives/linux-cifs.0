Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019A2C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 09:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiC3JH1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 05:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiC3JH1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 05:07:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2532519B04D
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 02:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=07TkouHc+t2HS8fmOR9DiOrSaZxQLPZJ4Axe1IUSNuA=; b=mkkCBNzA/Q/Djo9R9W7UcJwQbh
        rv3ErH462egHbmTid5tdTkP2fsLxnLEG2XlPr/Vud1XcbLJ7koQLhLCJ27vmLWYI/QoHpCA9x8uvZ
        U1k4qYmypZ2qM8M32NBbOqKuIwK6bxMJpFcCp6bqGapQFUkFMXR48NvDaPTraMIExQziA/RoB7Tbq
        /uDNwzbcouMGa0mQJXP9kWZMmDFX9lqH4GRG2hM85B0G0qXSHyvgYV8o3RVOKAsswEqvG7//N9Q0Q
        fRseO2AmZH45YcX2uHkI0mq9NR7pddgXMxtOXm5wlu72OIRWusDkkPwMMbN90e3sICgn6czb7WxMr
        kf9Pn8tw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZUGp-00EuqU-9d; Wed, 30 Mar 2022 09:05:39 +0000
Date:   Wed, 30 Mar 2022 02:05:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Subject: Re: Regarding to how ksmbd handles sector size request from windows
 cllient
Message-ID: <YkQdYwyBKl5hxJHu@infradead.org>
References: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 30, 2022 at 04:53:32PM +0900, Namjae Jeon wrote:
> I have received a report that the problem occurs when mounting an iso
> file through windows client on ksmbd & zfs share.

ZFS violates the kernels licene.  Please tell the reported to go away
as this is completely unsupported.
