Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808A7C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Dec 2021 16:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbhLVQEU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Dec 2021 11:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhLVQEU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Dec 2021 11:04:20 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4355AC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 08:04:20 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id kd9so2687597qvb.11
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 08:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YyF03xCIR7a/gHYcxi3+4aYjvLR9rTtlYrHDfuOd4wc=;
        b=Oy3ty0e50l1tlDMO8m+0uBiqF33LEZqf7o1VwjvX90GtEM8EvBaVxU/aUuUphADtPU
         DnLXjKLDjEQQ6UaV8JcL6hsEjynW4feEaG9NEs61DL8CSCRGNBSkAxDDFvZpvuG6AySf
         M8KrTM6dkFmwZUTbmxTIJdPXxudoee3ZWldnh6uBW9jeaTki8oGu0xTxe5FtfnKbkwxa
         LCPXX/AMqxS6Rvt+Lw397WxthHP6d406h2QaWetsPBtxMgtgJoO8psjPBdr/ZMkKFX6I
         /VY6oUbLqQpSBn+9Fgm5kzylDpg45p/CKUdReY+M/m8wLieHSJiyGQZfuDe2dztHomwG
         wghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YyF03xCIR7a/gHYcxi3+4aYjvLR9rTtlYrHDfuOd4wc=;
        b=pNBwKCtQRk9MjC28BxHR4TRYyAqj7gA/paxqIoTmgSSUPkNsSNgvu/R1mY9QyzHHlZ
         munpaCAmnFzFW7kk9QapGjc1ARIqnuWaB8CPlnfUln2YD0hq54T9H86AXBZAwCyxu3/i
         2GWsJVbeCIUMTxXU1vmcMGAqgz2sfgq9I11c5oRHPK26iRsK1BlI1cdT3nNLvJFH5yip
         q33TJqrl6Tkbbd9B+W2d0abiwd6EXZI64J1fYVs9wvBkJw/HAIZcNIVnnlebep3ZyJ+A
         qQ74S4pgfY7E8WVv8Gf3fSRsvNahxzHI333hMB4VUqvGMQewAv/HfzEq2YcN54wZw8Mm
         Bbfg==
X-Gm-Message-State: AOAM531iacRCYwsQfUf6P624SKNuZRIXbCFKv7mxSzf4bOk3/uwub/Wq
        3/HijAkCD8CUOY+TL3CUJ41p4LWJaBs=
X-Google-Smtp-Source: ABdhPJwoeI9ropVKd1eOwmXH2Z9hy3udLBhVkKBDRjl2MtBqYkz5utmiwdLLl02CNQdYYOkb5UUgNg==
X-Received: by 2002:a05:6214:e6e:: with SMTP id jz14mr2938132qvb.33.1640189059304;
        Wed, 22 Dec 2021 08:04:19 -0800 (PST)
Received: from pascal.home.bair.one (2603-7000-0d07-ad00-0000-0000-0000-081b.res6.spectrum.com. [2603:7000:d07:ad00::81b])
        by smtp.googlemail.com with ESMTPSA id d17sm1909361qtx.96.2021.12.22.08.04.18
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:04:19 -0800 (PST)
From:   Ryan Bair <ryandbair@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: fix workstation_name for multiuser mounts
Date:   Wed, 22 Dec 2021 11:04:04 -0500
Message-Id: <20211222160405.3174438-1-ryandbair@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Long time user, first time contributor. 
Please let me know if I need to be doing something different. 

Thanks,
-Ryan


