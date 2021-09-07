Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC42C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 00:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B5156109D
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 00:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhIGAIE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 20:08:04 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:33388 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhIGAIE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 20:08:04 -0400
Received: by mail-pl1-f172.google.com with SMTP id k17so4736881pls.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 17:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YqMMJda9qb6COQ2LaFWW0/7YOU0oNAAOQUR8W5KKL1c=;
        b=HLu2v7kEQbABqlwjZN9Tqv6TbMnf97oIXoryGabTzL7qQX6eDDFts8Xmphhn3PmtVN
         X5TzWENV+0SoLMPFE97q0S+w/ODjpnwmzESEp82GS0SdrU4FdIvG8qMkTBW3uJqxRe33
         UT/OECBBg/Re8CqIYlh6eKutkm1TACpELSMCeXI3BDb3KM8cCy1FBzuBfckgzI+NDV8W
         ARR6Vz315ukO4sg/bGVEjVrRGhwQ0tLWetuTG1u+EKCKGb4yk9r32nHLtKaBpkoJcgVV
         h2wgDiuRVmQP5O8g6MkrdH2VA5c6ZsU5tYSCg9IlShmk+SNIoUVKGzfuU56359tG2Jqu
         ZyxA==
X-Gm-Message-State: AOAM530FTq4VZ++kASxb0Jcxlqr/n2UXlHBdrwFCHzExi8unjb4VAars
        BK0dWigJmm9SfgxMBRsM+xBntcA/TrfAiw==
X-Google-Smtp-Source: ABdhPJzxQ9mGX2KJGQQcLJuQ/Mle3s2i/hhB8eqguGX7FFGlqC6UbHGUTDCJbU2rwV2DSl0gsc+/iw==
X-Received: by 2002:a17:90a:4316:: with SMTP id q22mr1532526pjg.151.1630973218803;
        Mon, 06 Sep 2021 17:06:58 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id cq8sm438029pjb.31.2021.09.06.17.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 17:06:58 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: fix control flow issues in sid_to_id()
Date:   Tue,  7 Sep 2021 09:06:26 +0900
Message-Id: <20210907000626.14385-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907000626.14385-1-linkinjeon@kernel.org>
References: <20210907000626.14385-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Addresses-Coverity reported Control flow issues in sid_to_id()
/fs/ksmbd/smbacl.c: 277 in sid_to_id()
271
272	if (sidtype == SIDOWNER) {
273		kuid_t uid;
274		uid_t id;
275
276		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
>>>	CID 1506810:  Control flow issues  (NO_EFFECT)
>>>	This greater-than-or-equal-to-zero comparison of an unsigned value
>>>	is always true. "id >= 0U".
277		if (id >= 0) {
278			/*
279			 * Translate raw sid into kuid in the server's user
280			 * namespace.
281			 */
282			uid = make_kuid(&init_user_ns, id);

Addresses-Coverity: ("Control flow issues")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smbacl.c | 48 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 16da99a9963c..0a95cdec8c80 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -274,38 +274,34 @@ static int sid_to_id(struct user_namespace *user_ns,
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id >= 0) {
-			/*
-			 * Translate raw sid into kuid in the server's user
-			 * namespace.
-			 */
-			uid = make_kuid(&init_user_ns, id);
-
-			/* If this is an idmapped mount, apply the idmapping. */
-			uid = kuid_from_mnt(user_ns, uid);
-			if (uid_valid(uid)) {
-				fattr->cf_uid = uid;
-				rc = 0;
-			}
+		/*
+		 * Translate raw sid into kuid in the server's user
+		 * namespace.
+		 */
+		uid = make_kuid(&init_user_ns, id);
+
+		/* If this is an idmapped mount, apply the idmapping. */
+		uid = kuid_from_mnt(user_ns, uid);
+		if (uid_valid(uid)) {
+			fattr->cf_uid = uid;
+			rc = 0;
 		}
 	} else {
 		kgid_t gid;
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id >= 0) {
-			/*
-			 * Translate raw sid into kgid in the server's user
-			 * namespace.
-			 */
-			gid = make_kgid(&init_user_ns, id);
-
-			/* If this is an idmapped mount, apply the idmapping. */
-			gid = kgid_from_mnt(user_ns, gid);
-			if (gid_valid(gid)) {
-				fattr->cf_gid = gid;
-				rc = 0;
-			}
+		/*
+		 * Translate raw sid into kgid in the server's user
+		 * namespace.
+		 */
+		gid = make_kgid(&init_user_ns, id);
+
+		/* If this is an idmapped mount, apply the idmapping. */
+		gid = kgid_from_mnt(user_ns, gid);
+		if (gid_valid(gid)) {
+			fattr->cf_gid = gid;
+			rc = 0;
 		}
 	}
 
-- 
2.25.1

