Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2B5C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jan 2021 22:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941A122E03
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jan 2021 22:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbhAEW0n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbhAEW0m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jan 2021 17:26:42 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D413C061574;
        Tue,  5 Jan 2021 14:26:02 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id 7so978585qtp.1;
        Tue, 05 Jan 2021 14:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=juELTIvRTW/b337nrNxecDrCQElvIPPbt17rQzuvz4Y=;
        b=GWOTgxfTuwVusuw6FiZSg4Lg14sGKM28Wa5zwlqPf0jkJ/qh3SnmrsaYAYKAOzat3J
         DyNe9gobWbe7Uyya1GgTAqbUvv/MnUfbytb0+Jv8QA0lgucsCY5DRgiFzwJAoB9W82dm
         qQoizwtdGpUNtuI5zyW4/mC8O1Oj/+hqpZVnV1kijtwq2ehmPOXsGKN62+5zixBqcgoo
         CoLMvbJkrLtMYqftrc1TmronQLD9An8u9svRo6B1hqWa+ZDtuFDSmM0CwmJVq6MdmjJn
         TQoJqdqhfvwemWYmN+0uqfG2gq4aYaiCNoP6JTRlVwKU3haHxVvx3rGKkFPFjY2LN4tz
         W0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=juELTIvRTW/b337nrNxecDrCQElvIPPbt17rQzuvz4Y=;
        b=iSDHt+Sz+IVCGb3ug+m5hbJ/jQ9AfgQguv6XxkACPeXleVQbtdYBJJhEpdpXvAdpd3
         9MYmMdfAP1avEMKRICk/WeECqWhYRYdB5L8CqEnY3fbRRHmP0laVo55afVbOI+YEorMe
         FTEOBEewt4rVOqSeg4cmyHAsFSA6tEg5vKAlMST069giHsk+88MPGTsmbFxek0vZ9677
         15SQW1Gkwf89XHrpBUmy/MzOJqJaut26z5l81J5Zc+s9HPUBqvZ1ioAECFThoZvJAjuC
         oo3kdx8QdK8MBe7nblHIpHDiDWVnzoDehkwt8ui/s7VH5cq7vjhjbQs+pQnzQhsserIh
         ek0A==
X-Gm-Message-State: AOAM5300bKobX1SeufJmnJ5qGSZixvmUJlWrMHF/tuE1QX41o9TEcn+I
        9YBB2pEfdYgH4QjiqN89Vmo=
X-Google-Smtp-Source: ABdhPJzSHzxWG2wWCzL2MHtNEIci/KhpgKohC9VkZGWo+zE3s9cxhDKpa0mREieHj0kKOedz18nthA==
X-Received: by 2002:aed:2b45:: with SMTP id p63mr1582005qtd.111.1609885561863;
        Tue, 05 Jan 2021 14:26:01 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id n4sm330015qtl.22.2021.01.05.14.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 14:26:00 -0800 (PST)
Date:   Tue, 5 Jan 2021 15:25:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     trix@redhat.com
Cc:     sfrench@samba.org, ndesaulniers@google.com, aaptel@suse.com,
        palcantara@suse.de, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] cifs: check pointer before freeing
Message-ID: <20210105222559.GA4118247@ubuntu-m3-large-x86>
References: <20210105202126.2879650-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105202126.2879650-1-trix@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jan 05, 2021 at 12:21:26PM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports this problem
> 
> dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
>   (18446744073709551614), which is not memory allocated by malloc()
>         kfree(vi);
>         ^~~~~~~~~
> 
> In dfs_cache_del_vol() the volume info pointer 'vi' being freed
> is the return of a call to find_vol().  The large constant address
> is find_vol() returning an error.
> 
> Add an error check to dfs_cache_del_vol() similar to the one done
> in dfs_cache_update_vol().
> 
> Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  fs/cifs/dfs_cache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 6ad6ba5f6ebe..0fdb0de7ff86 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -1260,7 +1260,8 @@ void dfs_cache_del_vol(const char *fullpath)
>  	vi = find_vol(fullpath);
>  	spin_unlock(&vol_list_lock);
>  
> -	kref_put(&vi->refcnt, vol_release);
> +	if (!IS_ERR(vi))
> +		kref_put(&vi->refcnt, vol_release);
>  }
>  
>  /**
> -- 
> 2.27.0
> 
