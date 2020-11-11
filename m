Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E00BC55ABD
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Nov 2020 00:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A2E21741
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Nov 2020 00:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MX3IgQHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgKKAw5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKAw4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Nov 2020 19:52:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F8EC0613D1;
        Tue, 10 Nov 2020 16:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hfu97T970DVwvlZSJ6RCHHF+99Fjt/3W7Xb/APU+Mp0=; b=MX3IgQHpb7NbNMSXoH+xE4ou9/
        T+PC42kDsyKG2ztYxeJcwCsL6cOLnFKDFeAWS7oZ39H3pAOebxhMZxs5neUwQibPsqlFelF66cBB6
        WMKWTfnLAFFaL3cstBbFO0r6wPHrvSdmO+c1O7+92YuC1YTduUmjP+mEjtGQDNTLWpBYwDm8DhZP5
        xRWrNKrDgHce0cQbmOB5gLS13GXQYZtH59DPCKXNnAAYPZKj2TZyQs7h+QOXWIt+s9TMbSuQwOF15
        b0So2qvDB+agDZRrDSUZDFqS/yCt6jZlaikdyFErbp7HpS676E6c4iEOUZ/EcQr1mdt3gUiqQ7/cg
        ybFmHFNw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kceNa-00005f-Ck; Wed, 11 Nov 2020 00:52:54 +0000
Date:   Wed, 11 Nov 2020 00:52:54 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cifs: convert to add_to_page_cache()
Message-ID: <20201111005254.GQ17076@casper.infradead.org>
References: <20201021195745.3420101-1-kent.overstreet@gmail.com>
 <20201021195745.3420101-2-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021195745.3420101-2-kent.overstreet@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 21, 2020 at 03:57:44PM -0400, Kent Overstreet wrote:
> This is just open coding add_to_page_cache(), and the next patch will
> delete add_to_page_cache_locked().
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
