Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05581C77B7E
	for <linux-cifs@archiver.kernel.org>; Mon, 29 May 2023 14:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjE2OIz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 May 2023 10:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjE2OIk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 May 2023 10:08:40 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920FFE5
        for <linux-cifs@vger.kernel.org>; Mon, 29 May 2023 07:07:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f6cbdf16d2so21188885e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 29 May 2023 07:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685369277; x=1687961277;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZRuxbIQGZYWZJn/VlECeE5ZkmojXONVWxC8O+82G+gs=;
        b=eAz8kWeAKYNiYtGuCWhmKwYLKYJpoiSYmKHaxgzw1xzmkl0QgnEQ9nTb4SUAPA1dbE
         fq/100m5uIW9RPaY5BTpsoi9H6vSamH96fadxLHsnUFRLy9e5w3uAD9wOWUzHv8UFDdv
         +TWDaXMoLMizud4zAQtvMo4jFvqc9LPLbflvQDWNy/WZtBKG+bDSNya7KBslRSxJ74/g
         /cItWe1z1uFTbZUzr5deSl1HjhSqLFAO4KtWbxdPF/jvzazNISTtuKQ9g/qxbO/xah3m
         BtnDN3NFvRiSUUXMva6c72aBWeeq3Srv87hK6a9ieuXCHCIPX+cSHaRRpEMLhUQMK5tL
         DWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685369277; x=1687961277;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRuxbIQGZYWZJn/VlECeE5ZkmojXONVWxC8O+82G+gs=;
        b=ZUHAE47zpuYrxx9Xh9IKYRkI0KhjdLA2GyqBAqedtSt7MX3mLiNsr8iewGhm8uA+SD
         fQIrkdqtEqBVM21C0aVZKMdJLzdMklREGPL5YfdBukm7ceOYkyVQ1rVwmLXS4u0eM1Cz
         ivjODeAuPpTl/IX5+qIef5Q+l4BGYA2nJzCA824hA1+soWgX/BDkkolk9RvBGB/w5BNw
         Fdvm9E5WkYR5+bKvn+BYqsYNnlbS2xyDoPEhumuAvgJRgII4/ibC3gi+LXW5oDqet+BN
         wM8xEn5KcynjQKJKfw/Jygyac44p+9LPIeHbtvGZzc0QlhFf7kUzsbUCcV5RIY9rDTZG
         o5Rg==
X-Gm-Message-State: AC+VfDx8UDgBSV7qzpomvMXpYwotB5lAVBfH/+eIgeyIq04CuJVTquhc
        guq+QhayIyB01JVdFTBA4GZjSUyOCvlJuVDhFog=
X-Google-Smtp-Source: ACHHUZ7dSeGOdwDW72dvZXgJiog430q4hr/TaYaboM4p6yqknV9vYGIZ8jYbCw/IUrL/mUCnoK1MEg==
X-Received: by 2002:a1c:4b19:0:b0:3f6:7da:21e2 with SMTP id y25-20020a1c4b19000000b003f607da21e2mr10745029wma.14.1685369276920;
        Mon, 29 May 2023 07:07:56 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c228a00b003f42461ac75sm17894826wmf.12.2023.05.29.07.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 07:07:54 -0700 (PDT)
Date:   Mon, 29 May 2023 17:07:50 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     linux-cifs@vger.kernel.org, pshilovsky@samba.org
Subject: [bug report] CIFS: Respect epoch value from create lease context v2
Message-ID: <5a93e934-303f-4375-9335-04b6d5bfd186@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[ This code is 10 years old now.  This is from an unreleased Smatch
  check.  We moved the files around recently so these showed up as new
  warnings and I was just curious what was going on. - dan ]

The patch 42873b0a282a: "CIFS: Respect epoch value from create lease
context v2" from Sep 5, 2013, leads to the following Smatch static
checker warning:

fs/smb/client/smb2ops.c:4106 smb3_set_oplock_level() warn: unsigned subtraction: 'epoch - cinode->epoch' use '!='
fs/smb/client/smb2ops.c:4115 smb3_set_oplock_level() warn: unsigned subtraction: 'epoch - cinode->epoch' use '!='
fs/smb/client/smb2ops.c:4119 smb3_set_oplock_level() warn: unsigned subtraction: 'epoch - cinode->epoch' use '!='

fs/smb/client/smb2ops.c
    4095 static void
    4096 smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
    4097                       unsigned int epoch, bool *purge_cache)
    4098 {
    4099         unsigned int old_oplock = cinode->oplock;
    4100 
    4101         smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
    4102 
    4103         if (purge_cache) {
    4104                 *purge_cache = false;
    4105                 if (old_oplock == CIFS_CACHE_READ_FLG) {
--> 4106                         if (cinode->oplock == CIFS_CACHE_READ_FLG &&
    4107                             (epoch - cinode->epoch > 0))

"epoch" is zero for a new file.  I guess for an existing file they
would be the modification time or something?  These values are unsigned
so this is the equivalent of:

	if (epoch != cinode->epoch)

Do we care about greater than less than or just not equal?

    4108                                 *purge_cache = true;
    4109                         else if (cinode->oplock == CIFS_CACHE_RH_FLG &&
    4110                                  (epoch - cinode->epoch > 1))
    4111                                 *purge_cache = true;
    4112                         else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
    4113                                  (epoch - cinode->epoch > 1))
    4114                                 *purge_cache = true;
    4115                         else if (cinode->oplock == 0 &&
    4116                                  (epoch - cinode->epoch > 0))

same

    4117                                 *purge_cache = true;
    4118                 } else if (old_oplock == CIFS_CACHE_RH_FLG) {
    4119                         if (cinode->oplock == CIFS_CACHE_RH_FLG &&
    4120                             (epoch - cinode->epoch > 0))

same

    4121                                 *purge_cache = true;
    4122                         else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
    4123                                  (epoch - cinode->epoch > 1))
    4124                                 *purge_cache = true;
    4125                 }
    4126                 cinode->epoch = epoch;
    4127         }
    4128 }

regards,
dan carpenter
