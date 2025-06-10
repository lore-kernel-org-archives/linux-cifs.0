Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A4C28B50C
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 10:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749549856; cv=none; b=tZeG17x6S4FJcJn2lE/VGHYjCMUQMpblhvs9xd48k852EHuxRm9hVqksliMSP3YsQTQn7Vvm6W6ViGO3HvTfrR2GGGK/gYqupz7QYdmQqHbSoKjQSJu6pd6bVd4rzXvGVy5506TmGyg+lgvtpAITG15Qlpg+fTUtbPMyd5BIUk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749549856; c=relaxed/simple;
	bh=27CXEgFPcLX2zEE6Iugyh7BtruL8sHO9pVzZJThMvCw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=odTcG+eIOmzI2aJEU7/7qi/m9qZBMmW9plKHsidCI/A7WY6PdXA3/MsTRm/J5QxUMRTac38JxEbAwwpPXwHNzvCrrHTp3zM2wVS1RnuWKVQlCdyFOzPjqk2tdJ6rsNwN50SrYzxqORB8Pvlc8IlPapTMmRBuFLIyUi0mDEJ/kFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2363e973db1so346555ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 03:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749549853; x=1750154653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nEOD07NBLos6gOufP6TE7lKsogwEBj93N+O7WO/7lfw=;
        b=obh67BdZR4LloTOSxcQnL04KSVr7JIF/r8UGk6iqmBhCRpsN0BT+42vIUIf08iyS8Z
         kiNNA3tdQ+yWrxQR/wXO1PZnkZvI7jCPB3bdmYnwAwLYsApaQRJXAxC0MsTV8UB2Vd59
         x6wvkjzqkLaHwhqrT8TWNCqEEMLGQ63hCTiHkMRgLtBW5zSKr6YrWFWVG+CUdQPBOmpo
         1sHDYReXlIESCJldr4xAQ2qHcX2zRStSrwThQwXgpsD5YM47V+nAIeE97s2R47fNWIFZ
         OFtlQ0JCI9up0o2n9k7bCyLZ6ZwxcysXhKigr3eQifqn8YynRbKRSAl6yAKCp+z4pYc4
         uDnQ==
X-Gm-Message-State: AOJu0YwhMMr/GezFOh+bgkjbdzZ4vJe8EMgxU8PU/tY5hbfZ+0yuZxx1
	A9oWBaukZwI5hK7bwuhhxgMdwnLRyBO622bCp3EDhKyV/n7KuoRYoeiB3Vw3mhJy
X-Gm-Gg: ASbGncudm5YgISJrbfW3yonD8x3b7jCxt+8uSTJubeWE/bohMolr2byUj3ZNp3QCZOX
	CGzThsZw+xBZM+4MO7zoOAj1OcBbrTXxD+b0fBedVcdK6E1wKXvmqAlX4ktJ9fpcSG2FMs8L8Mb
	TLz31YHszDvDVr6lFtroQ1Kme6w3Oxs5Zu20VAwf7tBvOVka9oYb8E9B5FbBXzk1fKqQp6FdbbR
	zxPvb1tkGypKecTBrb5cazWGWu9QVeAHAwmrMcF4H3uZjYwguCNQRf3GJTMcI6TBz3c5VoyrSc9
	j/aey0FGwswAeDzEZgeWd64QVt0rp7mJVRLJIcJUbLHR7WQ/xol290vppWRpyklCiwwTwLMcCR3
	P
X-Google-Smtp-Source: AGHT+IFBBhf9R3UzZ+9EanknUgbBTpw7CJDD6h68tpQ/picA8Yy/HWE5l7ku19UgskHM7V3W7pEJmQ==
X-Received: by 2002:a17:903:3ba5:b0:236:10b1:50cb with SMTP id d9443c01a7336-23635c7725dmr40016255ad.26.1749549853455;
        Tue, 10 Jun 2025 03:04:13 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603092ee2sm68068045ad.82.2025.06.10.03.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 03:04:12 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add free_transport ops in ksmbd connection
Date: Tue, 10 Jun 2025 19:04:05 +0900
Message-Id: <20250610100405.9367-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_transport function for tcp connection can be called from smbdirect.
It will cause kernel oops. This patch add free_transport ops in ksmbd
connection, and add each free_transports for tcp and smbdirect.

Fixes: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c     |  2 +-
 fs/smb/server/connection.h     |  1 +
 fs/smb/server/transport_rdma.c | 10 ++++++++--
 fs/smb/server/transport_tcp.c  |  3 ++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 83764c230e9d..3f04a2977ba8 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -40,7 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	if (atomic_dec_and_test(&conn->refcnt)) {
-		ksmbd_free_transport(conn->transport);
+		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
 }
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 6efed923bd68..dd3e0e3f7bf0 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -133,6 +133,7 @@ struct ksmbd_transport_ops {
 			  void *buf, unsigned int len,
 			  struct smb2_buffer_desc_v1 *desc,
 			  unsigned int desc_len);
+	void (*free_transport)(struct ksmbd_transport *kt);
 };
 
 struct ksmbd_transport {
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4998df04ab95..64a428a06ace 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -159,7 +159,8 @@ struct smb_direct_transport {
 };
 
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
-
+#define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
+				struct smb_direct_transport, transport))
 enum {
 	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
 	SMB_DIRECT_MSG_DATA_TRANSFER
@@ -410,6 +411,11 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	return NULL;
 }
 
+static void smb_direct_free_transport(struct ksmbd_transport *kt)
+{
+	kfree(SMBD_TRANS(kt));
+}
+
 static void free_transport(struct smb_direct_transport *t)
 {
 	struct smb_direct_recvmsg *recvmsg;
@@ -455,7 +461,6 @@ static void free_transport(struct smb_direct_transport *t)
 
 	smb_direct_destroy_pools(t);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
-	kfree(t);
 }
 
 static struct smb_direct_sendmsg
@@ -2281,4 +2286,5 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.read		= smb_direct_read,
 	.rdma_read	= smb_direct_rdma_read,
 	.rdma_write	= smb_direct_rdma_write,
+	.free_transport = smb_direct_free_transport,
 };
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index abedf510899a..4e9f98db9ff4 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -93,7 +93,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	return t;
 }
 
-void ksmbd_free_transport(struct ksmbd_transport *kt)
+static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 {
 	struct tcp_transport *t = TCP_TRANS(kt);
 
@@ -656,4 +656,5 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.25.1

