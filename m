Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05851C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Nov 2022 09:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKOJBf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKOJBe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Nov 2022 04:01:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FC21CFFF;
        Tue, 15 Nov 2022 01:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GwRoKnnlLMQISMQgHm91gHwpOySYBhQYwBeETruLTI4=; b=xl4EvsrepI1dn0YDfz56Ppl6Sk
        JFbZsbL2FobPD4ktM5s9hKh1EkMpDY33KFb41j/i7GRK96bzqT1idYCIaVQqD/RajiYdCzr3fkupH
        xoZNVV4MIYSBar1khx8WNcZg1nnx0Kf81e01PDJCX+S9JKjFAoSRC7wOZenKiBux1NQZK5AZYFWHV
        UnrHE4G4+2YaDmbi5WhlV2ftJa2N7Df7FvYXIEePaYoL9axR94sgsNhkE6iShvMezvxVJA/SDjAKM
        34D38bQHDBVDwiO/7bE1GlWtyRoczJoOF3zSmPKmQVvNWShd85PGSgRxE7+L6I9iDP6DePvoNcuWc
        3ytJugHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ourot-00971G-Nh; Tue, 15 Nov 2022 09:01:27 +0000
Date:   Tue, 15 Nov 2022 01:01:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] ksmbd: use F_SETLK when unlocking a file
Message-ID: <Y3NVZ6e7Hnddsdl6@infradead.org>
References: <20221111131153.27075-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111131153.27075-1-jlayton@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Nov 11, 2022 at 08:11:53AM -0500, Jeff Layton wrote:
> ksmbd seems to be trying to use a cmd value of 0 when unlocking a file.
> That activity requires a type of F_UNLCK with a cmd of F_SETLK. For
> local POSIX locking, it doesn't matter much since vfs_lock_file ignores
> @cmd, but filesystems that define their own ->lock operation expect to
> see it set sanely.

Btw, I really wonder if we should split vfs_lock_file into separate
calls for locking vs unlocking.  The current interface seems very
confusing.
