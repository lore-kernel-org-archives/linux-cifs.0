Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D497E7B5F1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 11:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242127AbjJDLSU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Oct 2023 07:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241788AbjJDLST (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Oct 2023 07:18:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2F3CE
        for <linux-cifs@vger.kernel.org>; Wed,  4 Oct 2023 04:18:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-690ce3c55f1so1538450b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Oct 2023 04:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696418295; x=1697023095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6l3qndQgjAQ9GYLCCkDS2hxfU+zYL6dvVH6cRrBzl1M=;
        b=HALjp8L/YCJTUMg7Ynl6Sd1++eHAH9XaMB4sqZRccAgmrPdZ7nb+KWATV4Ckq67Ybj
         gKWvWrKVL+hmSvSj9SEYAOs4S+aKmA0nTHcLwXhwU1N8MLTBBuFXv3SAFC2ve+EtC0Do
         ekKNno5BKpBF4Xu0YPczdLUMJEKbq4DLactL6PDn3jUlfB2c1OeF69JE+bqHYmL+OR0y
         PPb9DBc6m9ka/yJ3iEBkRsfpIZgrqyy5HfmNKYErB+4CxJX20vCsUxNhSpEB5tLm2k38
         tBf/8efNThxQzHnTOJU0DVI2w4CVNutHCY5ZxymGuM06TnDPJtHp6I3SpRMJnXnt+81+
         V/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696418295; x=1697023095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6l3qndQgjAQ9GYLCCkDS2hxfU+zYL6dvVH6cRrBzl1M=;
        b=E3oQTbncs9wlbscRGi526pVVbiUOAvvZMHqJZyiYNUODGIBqpgU1t1ui9qAyMYbRFm
         5J0BXnKFOGxsfsrVZyFBDjYWYcRstcRGpLs5uNxeSpRK9yP0H4+zc1nJSZz/yCbLEfkL
         77/o3WuHxbRjMMmHewmQl/XRjXVOHZbocF6KM5a3ANXgkTRsPLMWzUxQYY7poI2Z/mvD
         FvlY/KQ9W2C0Duf3xMpxOeFfScHkG9dt/0/uimCNyMVEDlNYsIMmEVjn5rE5uuSY5BeX
         oOU5UQbd0SlNMcm9LqDbgNkeA9fsppK3miWr5PBX/9e9cOehGMGx0ku42OoTmfgu18SO
         1jkQ==
X-Gm-Message-State: AOJu0Ywc51h7F2DerO0h2rcWt9jgVvLIJ4z795zFRXABRifGyxuHPoLi
        GY+8V1UV2J8EpqLvD/a7l7ZNjs16Jd6ZEg==
X-Google-Smtp-Source: AGHT+IF4srP9IyOLe4DZ7PE24JpI2qG8gVPuf34c7HYkvW4NJ/cJhkzty2KGOc86pRK5iRUmZxzU5A==
X-Received: by 2002:a05:6a20:8f1f:b0:13d:5b8e:db83 with SMTP id b31-20020a056a208f1f00b0013d5b8edb83mr2388170pzk.9.1696418294937;
        Wed, 04 Oct 2023 04:18:14 -0700 (PDT)
Received: from met-Virtual-Machine.. ([131.107.8.95])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b001b8b45b177esm3373085plx.274.2023.10.04.04.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 04:18:14 -0700 (PDT)
From:   meetakshisetiyaoss@gmail.com
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        nspmangalore@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz
Cc:     Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH] cifs: Add client version details to NTLM authenticate message
Date:   Wed,  4 Oct 2023 07:17:55 -0400
Message-Id: <20231004111755.25338-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Meetakshi Setiya <msetiya@microsoft.com>

The NTLM authenticate message currently sets the NTLMSSP_NEGOTIATE_VERSION
flag but does not populate the VERSION structure. This commit fixes this
bug by ensuring that the flag is set and the version details are included
in the message.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/ntlmssp.h |  4 ++--
 fs/smb/client/sess.c    | 12 +++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/ntlmssp.h b/fs/smb/client/ntlmssp.h
index 2c5dde2ece58..875de43b72de 100644
--- a/fs/smb/client/ntlmssp.h
+++ b/fs/smb/client/ntlmssp.h
@@ -133,8 +133,8 @@ typedef struct _AUTHENTICATE_MESSAGE {
 	SECURITY_BUFFER WorkstationName;
 	SECURITY_BUFFER SessionKey;
 	__le32 NegotiateFlags;
-	/* SECURITY_BUFFER for version info not present since we
-	   do not set the version is present flag */
+	struct	ntlmssp_version Version;
+	/* SECURITY_BUFFER */
 	char UserString[];
 } __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 79f26c560edf..919ace2d13d4 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1060,10 +1060,16 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
 	sec_blob->MessageType = NtLmAuthenticate;
 
+	/* send version information in ntlmssp authenticate also */
 	flags = ses->ntlmssp->server_flags | NTLMSSP_REQUEST_TARGET |
-		NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
-	/* we only send version information in ntlmssp negotiate, so do not set this flag */
-	flags = flags & ~NTLMSSP_NEGOTIATE_VERSION;
+		NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_VERSION |
+		NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
+
+	sec_blob->Version.ProductMajorVersion = LINUX_VERSION_MAJOR;
+	sec_blob->Version.ProductMinorVersion = LINUX_VERSION_PATCHLEVEL;
+	sec_blob->Version.ProductBuild = cpu_to_le16(SMB3_PRODUCT_BUILD);
+	sec_blob->Version.NTLMRevisionCurrent = NTLMSSP_REVISION_W2K3;
+
 	tmp = *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
-- 
2.39.2

