Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49606C43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 19:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22C2F207E0
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 19:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfbUPctd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbfFJS77 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 14:59:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37240 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388544AbfFJS77 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 14:59:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so4990460pfa.4;
        Mon, 10 Jun 2019 11:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQ55caWuqwbU+De7XmQQt0fy2kYmg/0ZSaiCipjUZO4=;
        b=TfbUPctdvrXpzaf6iFgr4Y8X5ezm+GPXUs/nQV5c0gdSoF54TRbbdL6+FLLiGw+Ccg
         LU3GOQ3l5Xodoe+ve6waq/Oj44UOSrwAd96BHCJgwH02kz42X9YOm5+LFybfefIv4Tzr
         4jN1lt9Of+iEN9jUJnwoVOjXlHBJwx22kW1ZRUCOaWs5rgyYTvXyDMxr2BmETY1psB/w
         fcSfLjNL0UuUHrppiYwWTfQBTsMeLsFKhZeq/PwBErApbqmvbi8f6WVRMrVMmIxILhzG
         1Eonr+P/RYi/xSz7kgKNNhcNg0xR7d7bjJCtLBrE1JxwG2vH+ZMaq6+v3Q87xIb3NTe/
         FbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQ55caWuqwbU+De7XmQQt0fy2kYmg/0ZSaiCipjUZO4=;
        b=pG2g+cvlWmIXV7QkEcz7oHGslZNHE2lKtZY8m16yhvIWI+qLjeUzpZwreAbmb3SkpC
         tW9nkCKMOA+4Fh2yGeDZejJgHLo1BaKyXVoDoKhX+T3gavEnFazZajs+52/SoRVyMHL3
         m76/V7trYs//jngrVLMuh3kXg9GcuxvzxW9IJyepPKQjLvk2d1bmmU7QY+ZVuC8jbbj6
         97uqDteHj7WLpHil8cfSsPAjs4/uREnRvM9w4CalQt59AtJUvN1hzqalfmMitz+jiIIc
         7MJ/WHVxSjZdf/S5tWpDmV49Bes+5nw/JCAk2fcsdBg7bfwN/0AfokRdrGcSU68C5JSQ
         LnnA==
X-Gm-Message-State: APjAAAXbL3tYGaacs9MV6X7vFuttxW7rysHZMg+4c2cYJ0gjI89JH2My
        /9hMNOjk0f+dGw25PDZgudXptOcOq/bXqyFk74I=
X-Google-Smtp-Source: APXvYqyW6Wq5aUqkYx7Xup/MyqMXW6iLaHVppG+h6JXWLB6YME4J8ydml7M/q37fhsG3NqB7nJT5f+kZYacXM6rJh8A=
X-Received: by 2002:a62:7552:: with SMTP id q79mr56181991pfc.71.1560193198801;
 Mon, 10 Jun 2019 11:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
 <20190609115509.26260-8-ard.biesheuvel@linaro.org> <CAH2r5mvQmY8onx6y2Y1aJOuWP9AsK52EJ=cXiJ7hdYPWrLp6uA@mail.gmail.com>
 <20190610161736.GB63833@gmail.com> <CAH2r5mu+87PZEZTMKsaFKDg9Z4i4axB6g9BA8JW823dFKWmSuQ@mail.gmail.com>
 <CAKv+Gu8n2Vc5uE6Q0V+Hu8swB5Oxp9ViEQXTQqFqSHHKw7NGsQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu8n2Vc5uE6Q0V+Hu8swB5Oxp9ViEQXTQqFqSHHKw7NGsQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Jun 2019 13:59:47 -0500
Message-ID: <CAH2r5msYba_hMcA=Cu84YFOO+hL4ok7sL-FFEJge4Mk8fZsMTA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] fs: cifs: switch to RC4 library interface
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 10, 2019 at 1:02 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Mon, 10 Jun 2019 at 19:54, Steve French <smfrench@gmail.com> wrote:
> > Yes - when I tested the GCM code in cifs.ko last week (the two patches
> > are currently
> > in the cifs-2.6.git for-next branch and thus in linux-next and are
> > attached), I was astounded
> > at the improvement - encryption with GCM is now faster than signing,
<snip>
> I assume this was tested on high end x86 silicon? The CBCMAC path in
> CCM is strictly sequential, so on systems with deep pipelines, you
> lose a lot of speed there. For arm64, I implemented a CCM driver that
> does the encryption and authentication in parallel, which mitigates
> most of the performance hit, but even then, you will still be running
> with a underutilized pipeline (unless you are using low end silicon
> which only has a 2 cycle latency for AES instructions)

Was doing most of my testing on an i7-7820HQ 2.9GHz
(passmark score 9231)

> > Any other ideas how to improve the encryption or signing in the read
> > or write path
> > in cifs.ko would be appreciated.   We still are slower than Windows, probably in
> > part due to holding mutexes longer in sending the frame across the network
> > (including signing or encryption) which limits parallelism somewhat.
> >
>
> It all depends on whether crypto is still the bottleneck in this case.

Trying to wade through traces to see.  Unfortunately lots of different
configurations (especially varying network latency and network
copy offload) to experiment with.



-- 
Thanks,

Steve
