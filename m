Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5173C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 11:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKJLmB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 06:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiKJLmA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 06:42:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD548716E8
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 03:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HZrgbKwq/Zv90fuyRQGa8KO1ffIc2cK2MUEJ6rWQ+Sk=; b=ACCb2RAqTLt2zjn9qwHc6INnrN
        oUe83br+N3BC7/eBR2Iv3pKUNafrieTf+9c5cDqIFF9gjVmRScGcgrVNTE+jPXM6i9FkREiPJXAmG
        L6Wb9s0L4xxe256dSKrVaLaEmud/7MUtMX5dh92wvcZQuNU21B4rb8wQXeXWXGXZmA673Dt5dCNRM
        mksw5m1MbkdXeYq+Ura9lWxOoUCLcfahgoyQzUCwyXV6crOejg2ZuKXbgNeucPfO/Ubw4wxm18ZtD
        I94+zy9ESc0/M14daQChYTWY30XzzvN4YEPr3L8Eiy70qimMwFr6uG8HKOCn3CN3HE1pZIofWOGE/
        1Xwe7Ldw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ot5w2-005RuC-Sa; Thu, 10 Nov 2022 11:41:30 +0000
Date:   Thu, 10 Nov 2022 03:41:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeremy Allison <jra@samba.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, vl@samba.org, metze@samba.org
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2zjaoiw0m/8b0t/@infradead.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer>
 <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
 <Y2vzinRPFEBZyACg@jeremy-acer>
 <Y2v1zQbnPoqg+0aj@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2v1zQbnPoqg+0aj@jeremy-acer>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 09, 2022 at 10:47:41AM -0800, Jeremy Allison via samba-technical wrote:
> So it *looks* like the copy_file_range() syscall will internally
> call the equivalent of FICLONERANGE if the underlying file
> system supports it.

Yes.  The separate clone interface exists for the cases where
applications only want to do the fast metadata only operation and
not fall back toan actual copy.  I'll leave it to people with more
SMB experience if and how that matters to the protocol.  For NFS
CLONE and COPY primitives exist on the wire with a similar distinction.
