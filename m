Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65C0C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jul 2022 12:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiGMMpo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jul 2022 08:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGMMpn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jul 2022 08:45:43 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133E9224
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 05:45:43 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so3416639pjf.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 05:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpkFk2A0JupXkUQ8jyjLNw/SKTwXtKyzBaXXjEhndxc=;
        b=tflpdEi3+cic79ZfJJKyx1UXsECL2wUMqKR7XspHwvky7kyU7JTFrV6VpJ5NyME7Xs
         h/dJFdWjMZEmc8xnHZ5DQM2V1s5XAq+nw5MxijAxJ7SS9Ew4pOPcXEhdFVk61Snwp/VN
         Owz0H2gAxaykTcW4EGO0oR2CnOO2pFlyF15SQzvtRh5QwZDpBR7jpqVF9MAL/XHL0ZH6
         x32XoBlqasSM0U3SHkDlfNH53g0n0TL+ObcPRVZqfLRIwPHO4O8VC0aGlKUhtv2s5dBw
         m1SaodV1z92tUNnFIrmLvqL/CHiDFws9du2224+tA3CbdHP3gSis4dNPF3XRlSKBVDeT
         9uoA==
X-Gm-Message-State: AJIora8pOuYTdoEczhryy/3aXgGcbuMX0Us6NuljXCRC9g+fbVuzTjhT
        mB1T4zMpTJ5BCyrzKJpmuEt7StvI4hIs1g==
X-Google-Smtp-Source: AGRyM1u7utt5b3VV4ogkm+Ub4SGgj59neOYOo0nGrQT3hUi6hvEv8PYdPUR4Q9qAJX7uIW8cQcU3YQ==
X-Received: by 2002:a17:902:cccf:b0:168:e13c:5cd9 with SMTP id z15-20020a170902cccf00b00168e13c5cd9mr3015833ple.53.1657716342205;
        Wed, 13 Jul 2022 05:45:42 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i21-20020a056a00225500b0051b8e7765edsm8763252pfu.67.2022.07.13.05.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:45:41 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: remove unused ksmbd_share_configs_cleanup function
Date:   Wed, 13 Jul 2022 21:45:12 +0900
Message-Id: <20220713124512.6251-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

remove unused ksmbd_share_configs_cleanup function.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/share_config.c | 14 --------------
 fs/ksmbd/mgmt/share_config.h |  2 --
 2 files changed, 16 deletions(-)

diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index cb72d30f5b71..70655af93b44 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -222,17 +222,3 @@ bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 	}
 	return false;
 }
-
-void ksmbd_share_configs_cleanup(void)
-{
-	struct ksmbd_share_config *share;
-	struct hlist_node *tmp;
-	int i;
-
-	down_write(&shares_table_lock);
-	hash_for_each_safe(shares_table, i, tmp, share, hlist) {
-		hash_del(&share->hlist);
-		kill_share(share);
-	}
-	up_write(&shares_table_lock);
-}
diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
index 953befc94e84..28bf3511763f 100644
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -76,6 +76,4 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
 struct ksmbd_share_config *ksmbd_share_config_get(char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
-void ksmbd_share_configs_cleanup(void);
-
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
-- 
2.25.1

