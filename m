Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B08C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 13:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15CCE61923
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 13:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCVN5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 09:57:50 -0400
Received: from verein.lst.de ([213.95.11.211]:55847 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCVN5Z (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Mar 2021 09:57:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9A71868BEB; Mon, 22 Mar 2021 14:57:18 +0100 (CET)
Date:   Mon, 22 Mar 2021 14:57:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net, smfrench@gmail.com,
        hyc.lee@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        hch@infradead.org, ronniesahlberg@gmail.com,
        aurelien.aptel@gmail.com, aaptel@suse.com, sandeen@sandeen.net,
        dan.carpenter@oracle.com, colin.king@canonical.com,
        rdunlap@infradead.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 3/5] cifsd: add file operations
Message-ID: <20210322135718.GA28451@lst.de>
References: <20210322051344.1706-1-namjae.jeon@samsung.com> <CGME20210322052207epcas1p3f0a5bdfd2c994a849a67b465479d0721@epcas1p3.samsung.com> <20210322051344.1706-4-namjae.jeon@samsung.com> <20210322081512.GI1719932@casper.infradead.org> <YFhdWeedjQQgJdbi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFhdWeedjQQgJdbi@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 22, 2021 at 06:03:21PM +0900, Sergey Senozhatsky wrote:
> On (21/03/22 08:15), Matthew Wilcox wrote:
> > 
> > What's the scenario for which your allocator performs better than slub
> > 
> 
> IIRC request and reply buffers can be up to 4M in size. So this stuff
> just allocates a number of fat buffers and keeps them around so that
> it doesn't have to vmalloc(4M) for every request and every response.

Do we have any data suggesting it is faster than vmalloc?
