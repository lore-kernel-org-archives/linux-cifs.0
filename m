Return-Path: <SRS0=5yhP=XV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D659BC352AA
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 16:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC19222CC
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 16:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=pensando.io header.i=@pensando.io header.b="y3h5OT0U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfIZQaD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Sep 2019 12:30:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40749 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfIZQaC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Sep 2019 12:30:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so1528497pll.7
        for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2019 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iUBOjyHfuR7bXfhhUiHsxfKRvIQzrO86xTAr8Ifre0Q=;
        b=y3h5OT0UmQqXJi0n0rBvqkcTo+13EdxQBhESuHKUhhUdt4HIIcVQewbszw7316Jbj3
         B26hOzlkXv8XsgeN5pGs7wsfUu35kRVDjdfbd80Cz2QkLIg0M3MsvsJVJdd9QD5RXeiy
         6UEhQ9sxyZ6zQojKZM8g8YSAiU0HmfS6EeGLmm2G3M5zDUXby8glVotg/+s3ve95UAlT
         DAQ0U/ntgxEnEPfGxe+68Qz99D7tUdj8cjDtGb+44i81+8OKBcckxrd+3wvZeL0MsCVS
         GUydrXVlNXeNeT9yD3EB7dKB2lMU1zF3uY6+lKZ9hv2ld2NLoMT31L6wdQwnvoc03z5L
         JHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iUBOjyHfuR7bXfhhUiHsxfKRvIQzrO86xTAr8Ifre0Q=;
        b=U13z2R/VCqjs+J2k3uFDhnNbcqGt2hrI/JQFaaZCWPJljHQB+0seV2bssspjgp30CO
         tVO/y5PY1U8C2QZ7GLPOckAM+4V86zn/GjVvy2LYDWjd9cAoVF0szlhdlEx9pgRCYnJR
         q2B8J+6vmkB6fV5kFh9rJbb5RCOZnc5gtFYCzFxQ0jBhpcpzF2bxwjc7sPdKeCK+8Igk
         vtgWM3ogp5QqbJxiR+YKy4NSNwPEM0bxvahlCqQtoHvtPxQsPAb0wS0bmWzM9TNy9BFZ
         P1Cei8DAafzFD6cQ6f92JG1eAZ9Ov+Jb3KJtKO3NFSjIMCiG5QGC4fqMCWC4oiQwRZ5v
         OTGw==
X-Gm-Message-State: APjAAAVD3w6fKCj8OCDFTMUDRhfXg7bw7eJEVWMzcIKZ9rAJE3njvyA4
        nG46XFtsxiVAGNDTNT8ZvghAqw==
X-Google-Smtp-Source: APXvYqzWSovEndvhpUlPPG2KWsLiHc/5J0wB0jU8KW7kk3lkOzlRWdHFYbFHIpUg2H8EkpfjsR5P5g==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr4822043plo.152.1569515400373;
        Thu, 26 Sep 2019 09:30:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e127sm3547209pfe.37.2019.09.26.09.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 09:29:59 -0700 (PDT)
Subject: Re: [PATCH 1/3] docs: fix some broken references
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        corbet@lwn.net
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pensando Drivers <drivers@pensando.io>,
        Steve French <sfrench@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-riscv@lists.infradead.org
References: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <81dc41d5-606a-7638-1d11-4fe53e9c2a7f@pensando.io>
Date:   Thu, 26 Sep 2019 09:29:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/24/19 6:01 AM, Mauro Carvalho Chehab wrote:
> There are a number of documentation files that got moved or
> renamed. update their references.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

>   drivers/net/ethernet/pensando/ionic/ionic_if.h            | 4 ++--

Acked-by: Shannon Nelson <snelson@pensando.io>

