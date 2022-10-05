Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7987BC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 03:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJEDGp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 23:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEDGo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 23:06:44 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C9F67162
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 20:06:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l12so14325650pjh.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Oct 2022 20:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=q/zGlhb/6/D5Xkd4KCi7Y207Q24GuRcEqCbd/ccpKzo=;
        b=SKokA0th/dXHfDQS3nsb8z2Z2ppZDeuiQhw1p/wBd32fJemgyvsCAt3bgQrTsKKYqm
         sYvv8mev2CZGsmAPDpcwakRg7aVXj6WJcATx3M0Pj3y6yLACKmqpQ+31/GaGC+CA9SiP
         PihlLDYUcY3R+DZFe1vMFUA4jUZdXlBR6vW5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=q/zGlhb/6/D5Xkd4KCi7Y207Q24GuRcEqCbd/ccpKzo=;
        b=g463An6kETAWKTFSK4bS3qBvaQ5SLklgTFGjZHLF+uYqkrZi+AfWV4cn9TKGzrRqKq
         Wth0cHaqdtNnnaNxOBNkC3dqQ6vFkYn4jxHGJMMTKLNINXykAmyBHuUoZNK2uLn8VWdt
         1rdfFGCtirN2FE8/u+24Z3zF5Z+a8yJ9PWDC1dlsDsykegF1u83e+yIaMMK50GIiWG9T
         0S9XzWq93y+pUf/+A+CSpC441W64JikiwKSrXGthenONOOW/vXtZuCgBq9PCMO2YOJZm
         2wOBcDO9Ze/pVdo7wpRPOewEPz6qxnFIGwY83dxOVsUATnVjQUmTWhxCdkCopYsUyxmm
         Ho0A==
X-Gm-Message-State: ACrzQf0g/gx9VTkGAQRkE0ceTBr6r7t/lOuOwosM4xCQrv5ZCs1rzARe
        mn1rm8HZayhwi8AZzxGOGMAL1w==
X-Google-Smtp-Source: AMsMyM57nv7ccnMuOcGPE169V0innj8Ek7XT9d7ddkrET+x+x7ZIMJkEIJ4x3msMla3GdYi0FFvCeQ==
X-Received: by 2002:a17:902:e946:b0:179:d084:bbe1 with SMTP id b6-20020a170902e94600b00179d084bbe1mr30088816pll.97.1664939202905;
        Tue, 04 Oct 2022 20:06:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n18-20020a170902e55200b0017ca9f4d22fsm8991473plf.209.2022.10.04.20.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 20:06:42 -0700 (PDT)
Date:   Tue, 4 Oct 2022 20:06:41 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] cifs: Replace a couple of one-element arrays with
 flexible-array members
Message-ID: <202210042006.9A12D208@keescook>
References: <YzzjKyHDuFoQAVCu@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzzjKyHDuFoQAVCu@work>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 04, 2022 at 08:51:39PM -0500, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> member in structs negotiate_req and extended_response, and refactor the
> rest of the code, accordingly.
> 
> Also, make use of the DECLARE_FLEX_ARRAY() helper to declare flexible
> array member EncryptionKey in union u. This new helper allows for
> flexible-array members in unions.
> 
> Change pointer notation to proper array notation in a call to memcpy()
> where flexible-array member DialectsArray is being used as destination
> argument.
> 
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/229
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Looks good to me; thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
