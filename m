Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D03C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 09:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E524561879
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 09:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCVJjr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhCVJjS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 05:39:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C92C061756
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 02:39:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so8211695pjb.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 02:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cpOWRN/4tL9oLaXq9iknOFh2ybCUMd8z1EKrJlSz62o=;
        b=DQ5GI3qdfmcvLNSLSWXpKEmxmGmX50tIccaoBdVV9uPs1IUnMYPzV3LULg2dBAtxbF
         jKaB5VSkYd+IWtEu8bIkq3iKMexodzanq5uZQzrNPFPXCfRjuwNkdGP/9Bm3OAtrxmOu
         5611l83YTBZoFlgRtKvk64mPW3dpXXKZcs6t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cpOWRN/4tL9oLaXq9iknOFh2ybCUMd8z1EKrJlSz62o=;
        b=uiglIYRKigTgBI43eD90jNnd9jnAxQe8JhOUrlec7Ty6VzE3QijZ0YpxxyuX2UjCmF
         7MVrjksVAh3Mb+4bRlcghjg6mvdv9KLi4u8tnj/EtnzWrxdaGg/ZXJglBBCzpOHneWn/
         UmV6ERmz2NdNFDofmsblOcW1QcZ1hQKBptyvoxXktSJwYXc+OSZ3dykRsxTV8zqGK5WO
         H0ZiVL3bnZNSbU0zY340iqZ6qiXj1TtWB5OZ67qpCZcqCU9/SVhl76Cxt6t8ARJKEhtm
         taLYtV0PgvSqqLi1dWKhlliM0xedSAliNAj3qoXzvgSkjxVJp4LdkG16z+kouPQOB0Fi
         fXWw==
X-Gm-Message-State: AOAM533zA+XRw4h2XLoaynwyOlmdQBL1KoRBnaAVA2wTtSuH/WTRiZyc
        XPn4BK/xU3o/1ARhHs3Jbjc9uLMfAKCTuw==
X-Google-Smtp-Source: ABdhPJyRSmdZMU065hZ+r4l3nuxkNSmeaXQDMmFCComRK/Tao9GNyhyEdLVprQNtI8wj0vMq9WLZRQ==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr12706266pju.35.1616405957184;
        Mon, 22 Mar 2021 02:39:17 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:b1b5:270:5df6:6d6e])
        by smtp.gmail.com with ESMTPSA id y19sm14253219pfo.0.2021.03.22.02.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:39:16 -0700 (PDT)
Date:   Mon, 22 Mar 2021 18:39:09 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net, smfrench@gmail.com,
        senozhatsky@chromium.org, hyc.lee@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, hch@infradead.org,
        ronniesahlberg@gmail.com, aurelien.aptel@gmail.com,
        aaptel@suse.com, sandeen@sandeen.net, colin.king@canonical.com,
        rdunlap@infradead.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 3/5] cifsd: add file operations
Message-ID: <YFhlvedSTrxT3ogj@google.com>
References: <20210322051344.1706-1-namjae.jeon@samsung.com>
 <CGME20210322052207epcas1p3f0a5bdfd2c994a849a67b465479d0721@epcas1p3.samsung.com>
 <20210322051344.1706-4-namjae.jeon@samsung.com>
 <20210322070447.GE1667@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322070447.GE1667@kadam>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/03/22 10:04), Dan Carpenter wrote:
> 
> On Mon, Mar 22, 2021 at 02:13:42PM +0900, Namjae Jeon wrote:
> > +void *ksmbd_alloc(size_t size)
> > +{
> > +	return kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
> 
> 
> This patch adds a bunch of wrappers around kvmalloc().  Don't do that.

Agreed. This was not cleaned up properly. The initial implementation
of that function (IIRC... it was sometime in 2018) basically contained
kvmalloc() implementation, because back in the days Samsung used kernel
version that simply didn't have kvmalloc() ( < KERNEL_VERSION(5, 0, 0))
