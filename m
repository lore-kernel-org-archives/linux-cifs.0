Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6ABC77B7F
	for <linux-cifs@archiver.kernel.org>; Sun, 14 May 2023 03:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjENDwH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 May 2023 23:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjENDwG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 May 2023 23:52:06 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DB62109
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:52:04 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5304913530fso5095224a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684036324; x=1686628324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAfcVPMdO5gQp2ni4lOpX9SNGR4qmaMtdrQ0DsW1m1A=;
        b=M3RGJOKrIfn0NDO64HuqF8Pf+PFB/oNylX9jpPMthB0mF1E4WP8QpZ5PLnkFEdPTgx
         SqErEzaeNKjZM/N3sBX+KPoX7+pwwQeIcPvH/nUtZrxJ2a4tHUjUZb3WQQkBwLwOrKEh
         4Uwidzast655nllKSaYBhnG3Gu32qykmKLagp29N2Zg1f7JOmLqDRD2m0hZqOSOpAmvD
         B7EndaKqY14ILjVlF16jZhALGgwSVsr8vWLz/OGqA8wCXfJx+3V7HZSDocxFUqNfIJ8Z
         mePC9DLzRZ9cl+ktREyEZY1bgfKUDTBtNT8NBM1nea+VoqnuPQKvi4QB0bnn6iFhKipY
         WytA==
X-Gm-Message-State: AC+VfDwHvJTEGhUB0CX1KE8HUI6AQvB9iW+Ygrkj3NcWDNAj75R7WHiG
        cX0D0Qa+/8YZVx1IHLHJgRv3XBen7AA=
X-Google-Smtp-Source: ACHHUZ7HnoOiB+TCv0gD664p/dBTsE9UBqTpKiV6Uv4hTzYGhqcb/3nsG8/8FctNQcOuFm3bC8cGXA==
X-Received: by 2002:a05:6a20:728b:b0:ff:d437:13fb with SMTP id o11-20020a056a20728b00b000ffd43713fbmr32772625pzk.49.1684036324078;
        Sat, 13 May 2023 20:52:04 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79113000000b0063b79bae907sm9281837pfh.122.2023.05.13.20.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 20:52:03 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Coverity Scan <scan-admin@coverity.com>
Subject: [PATCH] ksmbd: fix uninitialized pointer read in smb2_create_link()
Date:   Sun, 14 May 2023 12:51:41 +0900
Message-Id: <20230514035142.7653-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230514035142.7653-1-linkinjeon@kernel.org>
References: <20230514035142.7653-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a case that file_present is true and path is uninitialized.
This patch change file_present is set to false by default and set to
true when patch is initialized.

Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 717bcd20545b..1632b2a1e516 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5506,7 +5506,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path;
-	bool file_present = true;
+	bool file_present = false;
 	int rc;
 
 	if (buf_len < (u64)sizeof(struct smb2_file_link_info) +
@@ -5539,8 +5539,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 	if (rc) {
 		if (rc != -ENOENT)
 			goto out;
-		file_present = false;
-	}
+	} else
+		file_present = true;
 
 	if (file_info->ReplaceIfExists) {
 		if (file_present) {
-- 
2.25.1

