Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95318C48BE5
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7321361002
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFVGGW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 02:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFVGGU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 02:06:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D24C061756;
        Mon, 21 Jun 2021 23:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j2eA7WLKhCFkSyFyy6Tg3l5oRLsEM/iZVnCTeOMxT08=; b=VGU8yBGj5Ao21qvJLOqF90hnaF
        03IJI1/usWfhPRX9J4BubA24xWfQY0iD7efqx+H7jK3a/i7rsL0xlOLZubYCc3HP9thhfyyV38AeC
        wxOtF9e3anCYwARtiep0tRcUwtcxDzfNa8KPB132aiNdnNaxHX2rXBbuA3oTnrIU4OON2jk9enMUM
        Ncnqd+MtEuRnDpIsRdJhLcjxblRz+PPJ3ar3dDHIGVQXsDXkgY0wz006n2JODGF491IgWWI5j2UJt
        1BW0wAWg3GagZJG8yROnmQWFjjKFwyleAQM0cvDs7bVFgAvbcjGy550Wd8fuxg6ZGavQfZOEnE7TG
        GkMGspcg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvZVE-00Dwhn-B4; Tue, 22 Jun 2021 06:03:23 +0000
Date:   Tue, 22 Jun 2021 07:03:16 +0100
From:   'Christoph Hellwig' <hch@infradead.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'Christoph Hellwig' <hch@infradead.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/15] ksmbd: use ksmbd name instead of cifsd
Message-ID: <YNF9JB7PrSOpfWIP@infradead.org>
References: <20210618022645.27307-1-namjae.jeon@samsung.com>
 <CGME20210618023614epcas1p4f33df1322709076c65a63f5013f9c2cc@epcas1p4.samsung.com>
 <20210618022645.27307-14-namjae.jeon@samsung.com>
 <YNBKb2UJQ8D4JhcO@infradead.org>
 <009301d76677$8b52a6b0$a1f7f410$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009301d76677$8b52a6b0$a1f7f410$@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 21, 2021 at 05:29:25PM +0900, Namjae Jeon wrote:
> > On Fri, Jun 18, 2021 at 11:26:44AM +0900, Namjae Jeon wrote:
> > > Use ksmbd name instead of cifsd.
> > 
> > I think you probably want to move fs/cifsd to fs/ksmbd/ as well then.
> We had a lot of discussion about this and decided to leave the directory name as cifsd.
> Please see:
>    https://lkml.org/lkml/2021/4/6/1296

I can't really agree with that argument.  If we have a module that is
called ksmbd fs/ksmbd/ is the right place for it.  And having a
smb_common module used by ksmbd and cifs should not be too bad for those
who know just a little about the smb/cifs history.
