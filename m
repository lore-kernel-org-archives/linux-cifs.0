Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A18C54EAA
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 04:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjA3EMv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Jan 2023 23:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjA3EMu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Jan 2023 23:12:50 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6821ABC6
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 20:12:48 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so12381386pjq.1
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 20:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ai70ynQmCHXhGl2C/AE4lN4+5TUlub5Z+/Q3Eyemse4=;
        b=i3+w2XqNNzaBzntpiVcuDr8dAlQke9XjcAW2RnuGmfaoXHKLxvowTikkTvICoQZ824
         FxWRvH652KRdla2lBngZSWcDEEy/rzU9IWdwReUfdPZIZf3WzNQVWJ8j9/WgKJ/E4qaN
         IDNhaVMCGR9IhqyZIfZ8uJWAF9zuY6EWVxTb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ai70ynQmCHXhGl2C/AE4lN4+5TUlub5Z+/Q3Eyemse4=;
        b=j8ZE9KWtP9P3tYfvRU4DQWvrSnVpFCNuz8W2iahl63GWIkSCCRSvNAiD76NNZuohUL
         hezko9s+kJOwnxhFXlcBb+Bcyg361WijujfZ3Fi5u6KalC0uw2pmXs69iCsbdnTgJAJB
         XiUqRVTrMJuTtrUcbhdkQzGMfMD3eKH2Vsfp/NzSyfvThnC+Erdb3jyfUhTuv+6ihGBP
         8RtsNujtOLuakW7qrsMZr1KFLu0MEFdcHX9810R9kcnZBci1Kbee3+jhJdx28MJhHWYK
         sQ66QzoR8IInh0gnopUVpIGiDLsR9uJ1XI9glpfbdTgzWUpQsFAkFWRKMdq/AZSeWI6y
         6svw==
X-Gm-Message-State: AO0yUKXiSLsgfK2E32soINFVxoJZlGniFEgV4ZfLTAQI1NpwBQEX84KM
        kCN0UPHokjGLq7tRWz3lV6uwqA==
X-Google-Smtp-Source: AK7set9i+Oe5EGkqpto77EHJj+INInYkWSOxgKI2rligM3yEbDNQ/vyd2tqfzqlyTisQFNv9vQginQ==
X-Received: by 2002:a17:902:e811:b0:196:893e:cbdb with SMTP id u17-20020a170902e81100b00196893ecbdbmr1758696plg.6.1675051968331;
        Sun, 29 Jan 2023 20:12:48 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id jf14-20020a170903268e00b0019605a51d50sm6605846plb.61.2023.01.29.20.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 20:12:47 -0800 (PST)
Date:   Mon, 30 Jan 2023 13:12:43 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ksmbd: replace rwlock with rcu for concurrenct
 access on conn list
Message-ID: <Y9dDu4WnDbHV/VhH@google.com>
References: <20230115103209.146002-1-set_pte_at@outlook.com>
 <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/01/15 18:32), Dawei Li wrote:
> Currently, racing protection on conn list is implemented as rwlock,
> improve it by rcu primitive for its better performance.

Why is this a problem and what proves that this patch improves/solves
it? Numbers/benchmarks/analysis?
