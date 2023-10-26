Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE32CC25B6B
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Oct 2023 12:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjJZMVm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjJZMVk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Oct 2023 08:21:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FFAB9
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 05:21:37 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-307d58b3efbso557066f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 05:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1698322896; x=1698927696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IYKDgrAzD1gMVxECHKdB8cUz08FCSkNLHk2nBH8sV7A=;
        b=3WkFWjZgryKpQi+QRJNArd01aWoXAv5Qjpcah9wQfz5GExkOOnxoEnIK68sUYQieRS
         ynluJbf6glRkuqQxf3jy847TbsqaswQmiKjIwULGCO6GM88Qx5Ma3kT9D2C/LS2d/JSQ
         hsqnG4JjzyV9rMJr07rCvFtClpiuyqqobsK9k6nyg7DiXqvp2V4FRu30T+qJ78frzII2
         Ro4wLy90uTtDrkAIbJ36t5SlBEDES/7taW3CQ/aUMOr1gUpKgFB3rkupYIHC5S0FuQAZ
         mLMxY9u2odbuvzdbJ6NYn4115Fk3lc5xAegf/JIpBQZtlVpHJv6dfelQHC32lyn8YVZ1
         hwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698322896; x=1698927696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IYKDgrAzD1gMVxECHKdB8cUz08FCSkNLHk2nBH8sV7A=;
        b=xIO7p3CDhNHuH9C2o+sWVT91BQ9A45ff7y3szW4S9I42MGHGRBFQPXZ395Ai1DQzQT
         4nNhdbahWHpN1PkVPumRuJepynXO1NTGWQKYVLMWp+aNDBuuojxetsZfxeJtqVDBJ3Xb
         pX+10ptZg4fIE0nluPhdy3NxS4HROCAwX7D42At10Cf8y1gr+Rmobvaow/f3piknLtmq
         55daxj9sLfpaeNlJwL5SZ9dl9UcYiDVB7UYhOhChs9TPVhcNNg9iyagJlhWLEhMPIJ9X
         +v09Q+KU+ovKtVy4A9EBoa3DKf7+yD6eVp7psx4i3D2GcyEnCzOMMs7eQI1dIFDc7qR/
         LyQg==
X-Gm-Message-State: AOJu0Yy2kTJpQUarmElG8v5WHecRj+BNX9Um99eb+7iyeYPGzVD9r/K2
        T55ZsycgqNH6gmUZfBIeaLrtw2AcjYLNibFzXKc=
X-Google-Smtp-Source: AGHT+IHKNUC6PjI7fovH5rbGOL3DKJJ4YzhUNHohIWg/SM12I3uBuQSQQlJzycr0pGI9gjurO0Am+w==
X-Received: by 2002:a5d:5341:0:b0:320:1c7:fd30 with SMTP id t1-20020a5d5341000000b0032001c7fd30mr12839982wrv.17.1698322896071;
        Thu, 26 Oct 2023 05:21:36 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id o12-20020adfe80c000000b0032da49e18fasm14251669wrm.23.2023.10.26.05.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 05:21:35 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: add processed command debug log
Date:   Thu, 26 Oct 2023 14:21:08 +0200
Message-Id: <20231026122107.3755159-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Additional log to help identify what command is going to be
processed next.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 93262ca3f58a..d2b51177f0ca 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -39,6 +39,36 @@
 #include "mgmt/ksmbd_ida.h"
 #include "ndr.h"
 
+static const char *const smb2_cmd_str[] = {
+	[SMB2_NEGOTIATE_HE] = "SMB2_NEGOTIATE",
+	[SMB2_SESSION_SETUP_HE] = "SMB2_SESSION_SETUP",
+	[SMB2_LOGOFF_HE] = "SMB2_LOGOFF",
+	[SMB2_TREE_CONNECT_HE] = "SMB2_TREE_CONNECT",
+	[SMB2_TREE_DISCONNECT_HE] = "SMB2_TREE_DISCONNECT",
+	[SMB2_CREATE_HE] = "SMB2_CREATE",
+	[SMB2_CLOSE_HE] = "SMB2_CLOSE",
+	[SMB2_FLUSH_HE] = "SMB2_FLUSH",
+	[SMB2_READ_HE] = "SMB2_READ",
+	[SMB2_WRITE_HE] = "SMB2_WRITE",
+	[SMB2_LOCK_HE] = "SMB2_LOCK",
+	[SMB2_IOCTL_HE] = "SMB2_IOCTL",
+	[SMB2_CANCEL_HE] = "SMB2_CANCEL",
+	[SMB2_ECHO_HE] = "SMB2_ECHO",
+	[SMB2_QUERY_DIRECTORY_HE] = "SMB2_QUERY_DIRECTORY",
+	[SMB2_CHANGE_NOTIFY_HE] = "SMB2_CHANGE_NOTIFY",
+	[SMB2_QUERY_INFO_HE] = "SMB2_QUERY_INFO",
+	[SMB2_SET_INFO_HE] = "SMB2_SET_INFO",
+	[SMB2_OPLOCK_BREAK_HE] = "SMB2_OPLOCK_BREAK",
+};
+
+static const char *smb2_cmd_to_str(u16 cmd)
+{
+	if (cmd < ARRAY_SIZE(smb2_cmd_str))
+		return smb2_cmd_str[cmd];
+
+	return "unknown_cmd";
+}
+
 static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 {
 	if (work->next_smb2_rcv_hdr_off) {
@@ -568,6 +598,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	unsigned int cmd = le16_to_cpu(req_hdr->Command);
 	unsigned long long sess_id;
 
+	ksmbd_debug(SMB, "received command: %s\n",
+		    smb2_cmd_to_str(req_hdr->Command));
 	/*
 	 * SMB2_ECHO, SMB2_NEGOTIATE, SMB2_SESSION_SETUP command do not
 	 * require a session id, so no need to validate user session's for
-- 
2.34.1

