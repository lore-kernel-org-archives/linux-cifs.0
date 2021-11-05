Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269A5C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA8F610FD
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhKEPw3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:52:29 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:55804
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhKEPw3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 11:52:29 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0A62040031
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636127389;
        bh=O16OdHn+GTs4ijs6PH3u89m4wmvvKfK54fa2lozmRZs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Tov4Dk9t5DlxZtni3IrDW5LxkQmo0DZG7hd0da2Pw+KlyS4OLfuIjLYt1+CVhpJXQ
         EinNKwubR2eEIZGmIGAId76G+iNjF9IWm7qVLe57Ms6NhOV/VwG68HL6sfn3vpb5R8
         4vGLloNRon5J81VIJ1zXsg1A95myTYuq6TrKELnAttMJlitU82VoA/z+v2Mg++KA+Z
         /A/UPkn3x1WI1XbuDTm+u/hkVeimh0gP81fpLdFVh55N/SaOypcwjxAx+DLScF4s+S
         /Td8SY9I6BgjiCdCGAcl/cusOpTcBRJLUkPvD7Q5HqO4do8nKWtt7DEiCdrQ9ttmUj
         9uNKpKQsq2LOg==
Received: by mail-wm1-f69.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so3423156wmg.9
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 08:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O16OdHn+GTs4ijs6PH3u89m4wmvvKfK54fa2lozmRZs=;
        b=V42aOxMbCD/wfIVOersuXucJtdEziKfvyAYcHoSaFyeZ2JZhpA82YgnFOVCDtG4pBE
         0TXV2w+Nehh25m6zWk7WpK2JZOHhdyV+17iYGoXeKaeCg9EMr453AMVN7sgEQeqoK+e4
         SvXolvZT4Sn5L59BGk9GMbWNALn3YvDMDHqwfwsFPXRbTU6qxVTcXJZ++tukuglaGQRY
         sleX/7QmWCD0mv6FbpqzSSx4ShoFmV0Yk7KY50/YWcDCGXPHlfGlMWxKlOLAFNn28slY
         ixGkblIH0oL1M8A0T6hbHLeO5o2vbdRa+B30/veAiO5hIEoSOP/xK+ohwoqdKoSUXFyu
         YMnw==
X-Gm-Message-State: AOAM532aKBfEf3qYJa3VFsDPuytvDJWpjrlbZap31X+AM2pNIosVy9Bz
        TY5uzZKQRv69QOTMBbjSk1eZKp61PdUlcV/9UuTqFHKzKluSIATjVCViiXYcR6MVs8jLUtosQNx
        xVg0NKZCwkHvK247GN0s7ivNki/JLhhGLZBV7LbM=
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr51023036wrq.221.1636127388422;
        Fri, 05 Nov 2021 08:49:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY603x0zr+Chuyb1t2ADL8WGsBiGEq/MpdSLq2l9mjdNq6e20HunukFRMlsP5KMMQo9T/EOQ==
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr51023001wrq.221.1636127388217;
        Fri, 05 Nov 2021 08:49:48 -0700 (PDT)
Received: from localhost.localdomain (lfbn-lyo-1-470-249.w2-7.abo.wanadoo.fr. [2.7.60.249])
        by smtp.gmail.com with ESMTPSA id o25sm8150426wms.17.2021.11.05.08.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:49:47 -0700 (PDT)
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
To:     Steve French <sfrench@samba.org>, Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jeff Layton <jlayton@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-power@fi.rohmeurope.com
Cc:     Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH 6/7] include: mfd: Remove leftovers from bd70528 watchdog
Date:   Fri,  5 Nov 2021 16:43:33 +0100
Message-Id: <20211105154334.1841927-7-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
References: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This driver was removed so remove all references to it.

Fixes: 52a5502507bc ("watchdog: bd70528 drop bd70528 support")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
---
 include/linux/mfd/rohm-bd70528.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/mfd/rohm-bd70528.h b/include/linux/mfd/rohm-bd70528.h
index 4a5966475a35..297a4a84fff5 100644
--- a/include/linux/mfd/rohm-bd70528.h
+++ b/include/linux/mfd/rohm-bd70528.h
@@ -362,28 +362,4 @@ enum {
 #define BD70528_MASK_BUCK_RAMP 0x10
 #define BD70528_SIFT_BUCK_RAMP 4
 
-#if IS_ENABLED(CONFIG_BD70528_WATCHDOG)
-
-int bd70528_wdt_set(struct rohm_regmap_dev *data, int enable, int *old_state);
-void bd70528_wdt_lock(struct rohm_regmap_dev *data);
-void bd70528_wdt_unlock(struct rohm_regmap_dev *data);
-
-#else /* CONFIG_BD70528_WATCHDOG */
-
-static inline int bd70528_wdt_set(struct rohm_regmap_dev *data, int enable,
-				  int *old_state)
-{
-	return 0;
-}
-
-static inline void bd70528_wdt_lock(struct rohm_regmap_dev *data)
-{
-}
-
-static inline void bd70528_wdt_unlock(struct rohm_regmap_dev *data)
-{
-}
-
-#endif /* CONFIG_BD70528_WATCHDOG */
-
 #endif /* __LINUX_MFD_BD70528_H__ */
-- 
2.32.0

