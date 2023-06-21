Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785A4EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 21:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjFUV1h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjFUV1d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 17:27:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D8E19B9
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 14:27:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-666ecf9a0ceso3455214b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 14:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687382849; x=1689974849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6XMJ/c0tXaMsLQ5pmA6s+F2ev1ZjVyFaNvWpRZRfpo=;
        b=WL5g94mpCAHGN8aYkBCYLfpDwX7L+CRtCjMtLOysVeHsdAIJrTEresjjphdof1hgbT
         2XytLFiTaE3V+YAH+aztL836LGzNt2quPxfUw5lqqsgiFOmTHF8vvEhmatFqinE+7ZSL
         7z5JzsOfgeApl+oKm8f+2peFxXeJbLzYYhtyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687382849; x=1689974849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6XMJ/c0tXaMsLQ5pmA6s+F2ev1ZjVyFaNvWpRZRfpo=;
        b=FYdlUYfqBx5W00V6haGHC+IV7bHAZCBaCgyl+8KEkXwybN0vD0hQrS1EVv6XbG0ajt
         YMyNhoQWCyGy0BHiv9cbYSwQHDc+ByMMjY7bh/of+CmWm3qFcG8ZRaTWBFsArwk2E8Zs
         he/uhCHnfNM/EZQdCIH1PS6/5C9shFxQXujccXA59OpfY9BiXTH2DCAeyA/wCNQMm1s/
         0hdRvoEp91gMVHmCtROqvESj73MNA9S7tUNOSGzJA4ol4bISY2UlGMygrsIkMtC+iPMV
         gk4ImEgcsmSbRFO6HPvXlZemDpVT89zmzXUckqeN/hwxGvrnu44RMLuXXlXZNeuC70vP
         QDfQ==
X-Gm-Message-State: AC+VfDxHq9aqPBKxSMv+X6Ybl6AbpNPYDJ0ZUxLlQtPPDkJvL5iFt1Uz
        L+1Prlm+J5FOh3dDLOC0xOFGvw==
X-Google-Smtp-Source: ACHHUZ68Q2VWIHG82voT+EKyIL5GNKKVS/+sbMJ/2g3xUhaAv1QL0fCk/waB6HV290TGrrV2cWfG3A==
X-Received: by 2002:a05:6a20:54a6:b0:122:2c01:9bd2 with SMTP id i38-20020a056a2054a600b001222c019bd2mr7754893pzk.37.1687382849346;
        Wed, 21 Jun 2023 14:27:29 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 9-20020aa79149000000b00666e883757fsm3293063pfi.123.2023.06.21.14.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 14:27:28 -0700 (PDT)
Date:   Wed, 21 Jun 2023 14:27:28 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] smb: Replace one-element array with flexible-array
 member
Message-ID: <202306211427.B789D305A5@keescook>
References: <ZJNnynWOoTp6uTwF@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJNnynWOoTp6uTwF@work>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jun 21, 2023 at 03:12:42PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct smb_negotiate_req.
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/317
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
