Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333CEC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Oct 2021 05:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A22A603E9
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Oct 2021 05:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhJIFvK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Oct 2021 01:51:10 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46919 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbhJIFvK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Oct 2021 01:51:10 -0400
Received: by mail-pf1-f170.google.com with SMTP id u7so9878004pfg.13
        for <linux-cifs@vger.kernel.org>; Fri, 08 Oct 2021 22:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ChRIvdSfJtqkQbuBbPLkDAP/BVjKZJkhh2LUlMaCLI=;
        b=roXRN8ht0PKtYv+ZTgDRNy0Vp3urWry6rK+OcNsXZvDoErAhe9ekZYj9rREd20k3XK
         jd06q/aqKlWjH4UB2A21l96XBCaNd6rS52T1wvI6uS8ofeISTeEwkHNYAispDpLeh9Ly
         dDZsQ/QkTcK5m1cuQCh48iDEqWwAH/8Lpg5v3ElOt7Hd1AKUTh7XgHIk0cBUBJy5frYD
         eR0mHMQOtiKroS6cvoLrI+P2G5POsuxCLJMqXJGm7fUlhathbZkw6c4LgVkY/+t4c5Qu
         zg4ZpUjSE8FOOxvgu1g545K6Lk/G3geiTBawi5/L+nIuFwjXtvsqZ2PcIyP7NuygN8cw
         0Bbg==
X-Gm-Message-State: AOAM5327nr4FlZBDr4zEuNJTaIVETXzhJ9hgfxZRJvtIrQNQ88aX+SAC
        93PslObFmLo94T7iGgkJwS6zzTLP4jsDSg==
X-Google-Smtp-Source: ABdhPJwTXNGmOJvqGqh5IeJlLxsafVgZS0Fqdmfxrd0QgSyEoSnZ/ffACWdya9uDyFlXBUBPf2GuNQ==
X-Received: by 2002:a63:1d13:: with SMTP id d19mr8169649pgd.383.1633758553433;
        Fri, 08 Oct 2021 22:49:13 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id u25sm947528pfh.132.2021.10.08.22.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 22:49:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: set a minimum character limit for password
Date:   Sat,  9 Oct 2021 14:49:03 +0900
Message-Id: <20211009054903.9788-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set minimum password length with 8 characters by default to protect
passwords vulnerable.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 adduser/user_admin.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/adduser/user_admin.c b/adduser/user_admin.c
index 4e85915..36b9ad2 100644
--- a/adduser/user_admin.c
+++ b/adduser/user_admin.c
@@ -119,6 +119,11 @@ again:
 		goto again;
 	}
 
+	if (len <= 7) {
+		pr_err("Minimum password length is 8 characters\n");
+		goto again;
+	}
+
 	*sz = len;
 	free(pswd2);
 	return pswd1;
-- 
2.25.1

