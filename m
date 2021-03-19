Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFF2C433E6
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 04:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21D364F65
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 04:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhCSEpO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 00:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbhCSEok (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 00:44:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B76C06174A;
        Thu, 18 Mar 2021 21:44:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso4231140pjb.4;
        Thu, 18 Mar 2021 21:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CzYMrkedvRYKjm01yoSToiKKWU0Vae22GM3ZPKsL+ww=;
        b=Gw6bg8n6rBtkN82XX4temekjqWvy0OEGZGBzaB1Zl/BIG6QaiUgpDGZlWpi34RnrLG
         SesyE4hKDWX/+YeU+YYUEkfdwkEZkm+kwgaeg0Fg8ya4nHZntHdBAmnFkBqqcMveqjF3
         YLlHFPQ60S5XXB6Gux9Kv/o+2OHaC/G4cHBNCQMf1itgV6yq/i1YpNy+GySBAjgP0n+l
         5B33PYAUQiNoFXYy9GDSuIpPDHeBjwZXWxqUI1sV5NegBc8gS+cXAUG30vAjl1UqwnJ1
         ZuCo23P8JoDErW4tRcGeZ8n9v5q8+YYm38egAzVMyTitJ+igt5sXLEQ0VPtn+U+QVVbS
         HEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CzYMrkedvRYKjm01yoSToiKKWU0Vae22GM3ZPKsL+ww=;
        b=dQiBAbyfhK02/cqCjOueNwDsngujxYdzg5lYoUOu3FpTISaEm2M8MbDF3pqW3lr/Y1
         fvjd/4ORaN9U35GwJ0xkGtm5mWa2tmtxQY8Z1m4wJCHXeIxTb129equmNRVGYj3aK9qn
         /aup/MW0JT260n4d6iOOMWSodXn3tRVNOC2SECUYsGDpkoutkXCLMxVFV+iPw4o4MViu
         bhVWujpa8cmNUWnLhoZJ00OWDP6xu6uCZhf8uwVaVTrk0W4tFB55byJSZFfs247dbSlr
         qVAjVSRDPS8rHl30ka1K4rRyj6V5N/rzmpKPAleze6GWczjuDEpTkrIQIXbLEH2hkXYZ
         6m4Q==
X-Gm-Message-State: AOAM5305sjtfRkTF2wbtjGrpiokASah75ueuqI7WAqj6ZY9EGWSz7VR5
        rPuHP7FUpl7gN0ydOxme0GE=
X-Google-Smtp-Source: ABdhPJyzib0mgu6hQDEymrwlUaX78/a0EgfEwdb7aR4oqaVvBriyFZaU/c1Oz4D0xe86refNIKg2gg==
X-Received: by 2002:a17:90a:1049:: with SMTP id y9mr7782237pjd.173.1616129080316;
        Thu, 18 Mar 2021 21:44:40 -0700 (PDT)
Received: from jagdpanzerIV.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id 27sm3663116pgq.51.2021.03.18.21.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:44:39 -0700 (PDT)
Date:   Fri, 19 Mar 2021 13:44:34 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cifsd: fix a precedence bug in parse_dacl()
Message-ID: <YFQsMmq9rI/eKJtZ@jagdpanzerIV.localdomain>
References: <YFNRPcVUXZ3EiEXN@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNRPcVUXZ3EiEXN@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/03/18 16:10), Dan Carpenter wrote:
> 
> The shift has higher precedence than mask so this doesn't work as
> intended.
> 
> Fixes: ef24dca82789 ("cifsd: add support for ACLs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks.

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
