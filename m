Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC281C61DA4
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 02:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjAaClB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjAaClA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 21:41:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8A21973
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 18:40:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 5so13683194plo.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 18:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=alDr8rnuCdi5UnNlDrRyh+KO4l3lmqdwsUiDHxjRReQ=;
        b=oEXi8wHoUktKmI2sc94o06ppFw5nran23Th+8v7ax2OM+x+0k2Zp2IdQICC9xdWg/B
         nIZBwEYj8h1E6/9ezOas2DcYAg8xv8K/Rn2/yJGB7L+WdAvIL0RbepDl4SFd2m1yrUqq
         os0+09i9UcvmWNRpLvQJk8LdNGIWOW3whXxU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alDr8rnuCdi5UnNlDrRyh+KO4l3lmqdwsUiDHxjRReQ=;
        b=soGQFhqoOycKQHMKKPz7JXHnmcIOXleoeMEdvwaE5sjYGYy8bg2/WIYk+rJfkAqBAw
         cfZxuJZpxdJ+MtA0nLDuAhI2YhY7lRJCfsr0iciemCngDWvqQgOlGwEJEFASLd6Js9Hb
         5VOI7pM8oe0Ae50wUZKykmKzUSZhiVD7HTcAwMrQ9ZP1NugK/XtLqOEzGvFhSS6pJmf8
         cXuCDiVUTKPHfp8GyszKKXZhj9AtZCTzdnSzxSluqvUic92UfMYfCi3BwRnGMbqAJUMq
         lSp1YsOk0b+q7fpb1Ja4zwRw/1Qo3e+jepI2bi7J6ps7Gmit8PGzlNxkaN+fIbRrY1pJ
         2bNQ==
X-Gm-Message-State: AO0yUKVPyowbbWcnkl1P2CbpeqBbWEvm9JtZqWe18mCwC8JP96HbJ6T1
        wOS2gjju5DGvY6FeEdSqRTjVbg==
X-Google-Smtp-Source: AK7set8KEiRNB4VK5ujMQHqAkva5XQPwI7xJP2sI9JcJ39lI8c2XRJiSLWH/d+PHXTKmQp7rsnmsKA==
X-Received: by 2002:a17:902:e2c5:b0:196:86ce:ab6b with SMTP id l5-20020a170902e2c500b0019686ceab6bmr4266853plc.3.1675132858898;
        Mon, 30 Jan 2023 18:40:58 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id ik7-20020a170902ab0700b00194ab9a4fecsm8435934plb.138.2023.01.30.18.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 18:40:58 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:40:54 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ksmbd: fix typo, syncronous->synchronous
Message-ID: <Y9h/tt7Au7EUUqZU@google.com>
References: <20230115103209.146002-1-set_pte_at@outlook.com>
 <TYCP286MB2323A6AB80B9EFE1CAB86003CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB2323A6AB80B9EFE1CAB86003CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/01/15 18:32), Dawei Li wrote:
> 
> syncronous->synchronous
> 
> Signed-off-by: Dawei Li <set_pte_at@outlook.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

