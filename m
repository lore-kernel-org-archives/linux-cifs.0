Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE8AC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A1E64F4D
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 04:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhCSEnB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 00:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhCSEm7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 00:42:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58563C06174A;
        Thu, 18 Mar 2021 21:42:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v23so2369449ple.9;
        Thu, 18 Mar 2021 21:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/fv8yF6cLog/DqO+5rcgAQEuQpvcChxvz0nfrBhbweI=;
        b=FjLloEkf36ItNVHL0teWzRJlzjtyV1nV+Q5MKt36JyTmEZDgCq8NbddCpDHsnRrDNI
         J9oPhEvptumDsd33wilZmayeEEm9cr2UrRgaLg5Q3bvtpRGaUL6CsMehnPWVh0fnOfx8
         PqbZYnfKk8QgnPieofJRWEZP73Vhp7MnUAvhrUq/Ay1ynGBZZscIInkZR3rpgUbTKtwc
         jzTJlL0bmsiNRpedLVXLYpvDHymtDaRayS7uZe6dZVCPP3sueObV3mW1REohwOGtcIRm
         yHTmvTP1j8mlNF+5S2FaYuYB87+l2FJ0s1fJRM1Tn4VCegzNh1fC4d2xii46LnFdQyp6
         5/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/fv8yF6cLog/DqO+5rcgAQEuQpvcChxvz0nfrBhbweI=;
        b=Ynk3ZdgYa/1EpMaNaPio7uVFuGn3Li4dWHCbUHnJjHwG5Ow5TXX/MWJ1uUSvb2+yAS
         QaPRF2Dpo+diKPJPJDqYpb1WnT5OGAinQaY6HVariowsPmXY8sc77MbTQRY+rQoqk8OB
         ptmIU8P4KPiAt4N/AaqFRxtDfp0bEsFpWQ2Bzp+caTxuO+3YMKs23mGYRgHEtpGIm+jW
         7GNQD/CAL5PdjRt+EEPEKhfuNEdqzNRBnoBoE4D5Loz/SwFV01DQ9PfUPDyOEiQe7oEF
         CMI8sbeWd7dX7lu2du3gRBAP1XnyUJ4ruHHhhrp8B8q/DR7WP0icf26dCBJdUnRLI2rG
         iKXQ==
X-Gm-Message-State: AOAM533mERoP/tCeg/ZhBp07lqGpqKZVeGrT/BynX4mUCSJYawQo1ufr
        VVXPooWiqKDFTMXMGpRX+Xk=
X-Google-Smtp-Source: ABdhPJy74QPxaC/t9lyxN6fdI/NSesaiphzxjjuh0AC+PcDhFJZFVPqdTzFF1LqCUcI4sMS6tdndew==
X-Received: by 2002:a17:90a:8408:: with SMTP id j8mr7866985pjn.1.1616128978740;
        Thu, 18 Mar 2021 21:42:58 -0700 (PDT)
Received: from jagdpanzerIV.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id i20sm3402071pgg.65.2021.03.18.21.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:42:57 -0700 (PDT)
Date:   Fri, 19 Mar 2021 13:42:52 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cifsd: Fix a use after free on error path
Message-ID: <YFQrzC0PA32D8Ar3@jagdpanzerIV.localdomain>
References: <YFNR1sVU2mIgxNma@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNR1sVU2mIgxNma@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/03/18 16:12), Dan Carpenter wrote:
> The ksmbd_free_work_struct() frees "work" so we need to swap the order
> of these two function calls to avoid a use after free.
> 
> Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks.

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
