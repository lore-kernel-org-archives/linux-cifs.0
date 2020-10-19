Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D301C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 19:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A537A2225A
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 19:13:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="COoaVYOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgJSTM7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgJSTM7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 15:12:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7A8C0613CE;
        Mon, 19 Oct 2020 12:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dhiPMPxrdxLMtKESBch415t9aZTGng33BxwdSpI6DjE=; b=COoaVYOqc0OGZTLwwMR+072ji8
        vfvUco0sO57kAz1zsLntOEDb4Dwj7LbIj3WzJatK7Mdab54aADlpUXOvyiDIa70zd1MB6wn5Z1eAJ
        MyRmqqSB9QqzyAuQuZ4ru5ufZL1VnFd0EvRBgV/ZQSVM4llgykNgNuqYuu4GG1/xoonT3yHZ49g7G
        FMonMn+raZeZsY5HD/S1WjD0bSGTms7Gq0rBahqCJYmH8hO16tWWexxEnWtvBLJSdgIUbvrxvmi8r
        k7Bf4cfLPjsfYF0tCIdYRNcmGb/XmraO9XYWmDbbxACyLtACOF67k8K5Gq2V7y/uCXbOAOxOgtPCC
        8PBOnTkg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUaaX-00069i-Fe; Mon, 19 Oct 2020 19:12:57 +0000
Date:   Mon, 19 Oct 2020 20:12:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] fs: kill add_to_page_cache_locked()
Message-ID: <20201019191257.GU20115@casper.infradead.org>
References: <20201019185911.2909471-1-kent.overstreet@gmail.com>
 <20201019185911.2909471-2-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019185911.2909471-2-kent.overstreet@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 19, 2020 at 02:59:11PM -0400, Kent Overstreet wrote:
> @@ -885,29 +886,30 @@ static int __add_to_page_cache_locked(struct page *page,
>  	page->mapping = NULL;
>  	/* Leave page->index set: truncation relies upon it */
>  	put_page(page);
> +	__ClearPageLocked(page);
>  	return error;
>  }
> -ALLOW_ERROR_INJECTION(__add_to_page_cache_locked, ERRNO);

I think you're missing:

+ALLOW_ERROR_INJECTION(__add_to_page_cache, ERRNO);

I see this:
> +int add_to_page_cache(struct page *page, struct address_space *mapping,
> +		      pgoff_t offset, gfp_t gfp_mask)
>  {
> -	return __add_to_page_cache_locked(page, mapping, offset,
> -					  gfp_mask, NULL);
> +	return __add_to_page_cache(page, mapping, offset, gfp_mask, NULL);
>  }
> -EXPORT_SYMBOL(add_to_page_cache_locked);
> +EXPORT_SYMBOL(add_to_page_cache);
> +ALLOW_ERROR_INJECTION(add_to_page_cache, ERRNO);

but I think that's insufficient because most calls are to
add_to_page_cache_lru(), which doesn't have an error injection point.

By the way, that CIFS code is going to go away with the fscache rewrite.
