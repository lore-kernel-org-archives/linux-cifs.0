Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019C5EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 21:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjFUV3u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjFUV3q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 17:29:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D331BCB
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 14:29:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6687466137bso2473451b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 14:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687382985; x=1689974985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVtcBpBVguZA8qoqqhoUInWb/zY6DUWD1bjs2LWSb0I=;
        b=HVXsgsJ2YYMXYdInroPiqaqbGEH1WjW4jAMh+uUvV+Uw5eiEQ2T1cO3J24tu2UHtEC
         3/qMGW8RCfpt140xoltctrA2zl28kzVYi2S0Np2xPzOBl3Kj668sHAslYlppaiOa6Huv
         dIPfWyUQGWS0cdms7hGp/ovR66Ul7OKcNJqqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687382985; x=1689974985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVtcBpBVguZA8qoqqhoUInWb/zY6DUWD1bjs2LWSb0I=;
        b=UXBnxgpi2cPJOP5kdyKPhpIo5GiIC++7g+Y90RBF7yXMu/ePES4DvfyAzudJsSCFfh
         /pvlDueRFgwa5U0yXMXInCJD5t2NouEyRU/pv6F2mu/QkaKdhstH0q0rLZA/ol85guu6
         weavkABoKPlqv6zfd56iTZ+BgdGC0faQTC4kRbZcIayjoLWApqVmHbK7MSjq59b8HlyJ
         upzFwgb8z3/WRdj/40QnZwh40YiQIt8kT3mFS8IH9mpYzZvyN6FJboR8AgCufP7VRhIJ
         mNDMaRZLdCfHVyIKKGFQUA0wSQVgSo18m8EF0+uCzeJxDE8Ysfpxsh3DYEpKKQ/XleBh
         vN/A==
X-Gm-Message-State: AC+VfDx4BuG+m8fHwzu6JunmJn/Hs0s3SCa0ZYl/XB/UMcxbbLCJmDAg
        x7HVU/nf/nb58+jJVbydxK9sDw==
X-Google-Smtp-Source: ACHHUZ7FddK1YoVB0as/jTCHRhdsySjJdOFSovi73J3mIp/EqwtFEAHJ+xDMzv/2QuWePq2bUK2WCQ==
X-Received: by 2002:a05:6a00:2484:b0:666:ecf4:ed6d with SMTP id c4-20020a056a00248400b00666ecf4ed6dmr12103959pfv.18.1687382984779;
        Wed, 21 Jun 2023 14:29:44 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79145000000b006689ecd0ff4sm3061860pfi.208.2023.06.21.14.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 14:29:44 -0700 (PDT)
Date:   Wed, 21 Jun 2023 14:29:43 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] ksmbd: Use struct_size() helper in
 ksmbd_negotiate_smb_dialect()
Message-ID: <202306211429.DA43E8D39D@keescook>
References: <ZJNrsjDEfe0iwQ92@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJNrsjDEfe0iwQ92@work>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jun 21, 2023 at 03:29:22PM -0600, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
