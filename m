Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2023CC3DA7C
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 02:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiL2C3Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Dec 2022 21:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiL2C3M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Dec 2022 21:29:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F041812084
        for <linux-cifs@vger.kernel.org>; Wed, 28 Dec 2022 18:29:11 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9so926260pll.9
        for <linux-cifs@vger.kernel.org>; Wed, 28 Dec 2022 18:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W2hf5CbYXCFQBcGt2m+dp8tLwBISDFTVA7vD9NfSqAA=;
        b=M7giVCbF43STi477aZF25AQQZ1fTpFXXtJFlPN2G5OMeubAcibZRMF0YH4yEGvGHVF
         C4AQkTxS+vDgj5F5enKojtYDYqHUNbO2+qPUKJiREGpaG29zBbH6+T1qndmwHYyy0avb
         QFIggTno4PWiieAP9csHAkUIQx5uhA7/lWhL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2hf5CbYXCFQBcGt2m+dp8tLwBISDFTVA7vD9NfSqAA=;
        b=YzCXGy5QoCGtpjjdrZ/DJisjeThK7mNs24l+Gf71Vq/6NSxwcGkxfdylqOa9r53efW
         IdPovjoAWXbboRGZbC/NWK4a4lfAszUVrcU7ar5IJ3JD07uEppjSuCJWfpg1US7Oi7VD
         ZvIv2tqSYjmDC77sE+N2EgZVUKVKrKkYvZG2ZUq5OQFcB6M5RkoFXyB07f4Ws+9nAYU7
         yy0czKsE5mCX6xM3T/K0DqG/vByWAVDZzmBTmisSmOjcsQ4zF8Tv41eJoBo9JUxLsLSe
         BVYKaNsaXlRRVCPpTwyWd4nBJmGXIU/u1XXhyOkL3rXtX+dSrQaQuMij4DwK+4UUzBjI
         seqw==
X-Gm-Message-State: AFqh2kol36Avsw6c6+JIBSd1T4NkDYwypMlinWkz2Ad7B0DPg+ehIeeG
        PK9Ao1euwyXKGY+Lv77dbilQwg5vEq8BYm50
X-Google-Smtp-Source: AMrXdXvpfU55xQLInH9yk6pxvFPDMkSgVAfsvIpFXoAIgajHG3GNkXWuzyXM4kqvZZyBmWvCyhBl7g==
X-Received: by 2002:a17:90a:64c9:b0:226:2f1c:f167 with SMTP id i9-20020a17090a64c900b002262f1cf167mr1226033pjm.15.1672280951501;
        Wed, 28 Dec 2022 18:29:11 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id ml4-20020a17090b360400b00225ab429953sm11709989pjb.6.2022.12.28.18.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 18:29:11 -0800 (PST)
Date:   Thu, 29 Dec 2022 11:29:06 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: add max connections parameter
Message-ID: <Y6z7cjj+OkkVYFYR@google.com>
References: <20221227145954.9663-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227145954.9663-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/12/27 23:59), Namjae Jeon wrote:
[..]
>  	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
>  	if (kernel_getpeername(client_sk, csin) < 0) {
> @@ -239,6 +243,17 @@ static int ksmbd_kthread_fn(void *p)
>  			continue;
>  		}
>  
> +		if (server_conf.max_connections) {
> +			if (atomic_read(&active_num_conn) >= server_conf.max_connections) {
> +				pr_info("Limit the maximum number of connections(%u)\n",
> +						atomic_read(&active_num_conn));
> +				sock_release(client_sk);
> +				continue;
> +			}
> +
> +			atomic_inc(&active_num_conn);
> +		}

This has to be one atomic op:

	if (atomic_inc_return() >= max_connections) {
		atomic_dec
		sock_release
		continue
	}

Otherwise it's racy and it's possible to have more active
connections than the limit.

I'd also note that pr_info() is risky there, it would be safer
to use rate-limited printk().
