Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B331C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 11:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKJLmt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 06:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKJLms (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 06:42:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0491E716FC
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 03:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jCNgCc7rWxVxBCQrymvbrTr8yI7N9FHw9/iPoRHZA2A=; b=Eyf5hKo8bpT1S0SaG+7aKuOgxg
        pO4cMp9tdtSf6dz9KBChgxdpsDVCtsiuUeP5yqs2OS22bG9WttFyvgNb6DUS/mUIxVIbz6352559+
        nO1BfIMN1polhhuUIaKVDPX3nXO8NTCqJp195voaWugEX207v8LmSnqSlCpKw7d+XV6oqiqOd59Dn
        bquwA7Kjs0RfWC3sO7rqd0mg78jf4UulBXvCaP9PopWS7QrEqpsr25s3rjT+mHSxGfpzAoAQPXpsf
        fhseWtAZmWDkvxfSPhkD0h/rj1CX8MAEKZ76OPd7NXUqFQqehF2uvTjK23QAJ6WHeI81mbCFpQwmG
        wXcqU6IQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ot5wy-005SWo-SC; Thu, 10 Nov 2022 11:42:28 +0000
Date:   Thu, 10 Nov 2022 03:42:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     David Disseldorp <ddiss@samba.org>
Cc:     Jeremy Allison via samba-technical 
        <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, metze@samba.org,
        Steve French <smfrench@gmail.com>, vl@samba.org,
        Jeremy Allison <jra@samba.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2zjpE6f6WLtkqiz@infradead.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer>
 <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
 <Y2vzinRPFEBZyACg@jeremy-acer>
 <Y2v1zQbnPoqg+0aj@jeremy-acer>
 <Y2v+au3rvWOUOr1t@jeremy-acer>
 <20221109233055.43b26632@echidna.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109233055.43b26632@echidna.suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 09, 2022 at 11:30:55PM +0100, David Disseldorp via samba-technical wrote:
> I think it's doable too :-). As indicated in my other mail, I think
> FICLONERANGE will need to be used for FSCTL_DUP_EXTENTS_TO_FILE instead
> of copy_file_range().
> I'm not sure how to best handle FILE_SUPPORTS_BLOCK_REFCOUNTING -
> ideally we'd set it for Btrfs and XFS(reflink=1) backed shares only.
> Another option might be to advertise FILE_SUPPORTS_BLOCK_REFCOUNTING and
> then propagate errors up to the client if FICLONERANGE fails for
> FSCTL_DUP_EXTENTS_TO_FILE. Client copy fallback would work, but the
> extra request overhead would be ugly.

We could probably add a bit to struct statx if that is helpful for
samba.
