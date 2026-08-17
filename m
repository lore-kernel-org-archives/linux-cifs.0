Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C513B4417
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968942; cv=none; b=hjgYvrjghDODWdbyF9xU6J3XJB4bLXuO/LgtOgkrgjCMiZtJHNDpnHBuSDx5jfG885u2pSJ2I86sqv4dXFFPwlq0VYyr/luoCJHE/JaIL9MOBcqvGd2BgSirAFYGxxrlpTo0+qC3viADQben9WlbzM2J0I8yw2qS6zWDdHZw+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968942; c=relaxed/simple;
	bh=7bl//IvHUHGUw8RuX2KD6EQjomE1bEMPhbXFj+IgDxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=knxx7Mt9Oug0EBW2NMmKLtWybsueJjLjMOyAxBhK8S3a/x+0dvzXhH1k1+Tn7F83Bz5kv+mQKK4jdV3nIVJ4aK31Z21TZatS1jdCAC0Ct3gcNBP7nHZhAgcBVfMgAAdV2SVLQyr03nd/gtKH+Zgx0to4mkG8WtcUE4dLMpiewpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5LlxIf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5LlxIf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E001F000E9;
	Mon, 17 Aug 2026 12:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968941;
	bh=2luKUdNeAOG/JPMFuanilqlgkQ3gvB8NbjHpzCE7ZJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5LlxIf3Ikpzx9QFaSJsukls3QkFfkoGUW7MB1e8kctmAoWy8QuluoQXo4hb2qvgs
	 xMDYYN0qQNMdAtRHEjiGf3fkccWIX312pqXQxmQaca2fDFmdffdAhrHjt7Y+FVRXDf
	 lP9ZTFrl1pnbACIW7p53EmEwkocW+NVc52FZyjdl6ZL/5vBPYxTZG2KO7GO1D39cKZ
	 H0yMUKhwzZY+4o1RBm9Os8X1tPLrhcfoGF/SXkXIxwZDaslds6URm7/l2C8YbbDmck
	 E1jV19QSuWY7WBm2MsTAhqAPGsmS4i/Dg7sT7Usw/HXbJeXafzYli9xlMyBXV95YRZ
	 Ttaphn2J0MSHQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add per-share SMB3 encryption enforcement
Date: Mon, 17 Aug 2026 21:15:16 +0900
Message-Id: <20260817121524.8812-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a share flag for requiring SMB3 encryption on an individual share.

Advertise SMB2_SHAREFLAG_ENCRYPT_DATA in TREE_CONNECT responses and
reject both unencrypted TREE_CONNECT attempts and plaintext requests for
shares carrying the flag.

Keep BIT(19) reserved for the existing ksmbd-tools WIDE_LINKS flag and
use BIT(20) for the new netlink ABI flag.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/smb2pdu.h           |  3 ++-
 fs/smb/server/ksmbd_netlink.h     |  2 ++
 fs/smb/server/mgmt/share_config.c |  1 +
 fs/smb/server/server.c            | 11 +++++++++++
 fs/smb/server/smb2pdu.c           | 22 ++++++++++++++++++----
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c1414a1ffe30..d9650aff0d3c 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -370,7 +370,8 @@ struct smb2_tree_connect_req {
 #define SMB2_SHAREFLAG_FORCE_LEVELII_OPLOCK		0x00001000
 #define SMB2_SHAREFLAG_ENABLE_HASH_V1			0x00002000
 #define SMB2_SHAREFLAG_ENABLE_HASH_V2			0x00004000
-#define SHI1005_FLAGS_ENCRYPT_DATA			0x00008000
+#define SMB2_SHAREFLAG_ENCRYPT_DATA			0x00008000
+#define SHI1005_FLAGS_ENCRYPT_DATA			SMB2_SHAREFLAG_ENCRYPT_DATA
 #define SMB2_SHAREFLAG_IDENTITY_REMOTING		0x00040000 /* 3.1.1 */
 #define SMB2_SHAREFLAG_COMPRESS_DATA			0x00100000 /* 3.1.1 */
 #define SMB2_SHAREFLAG_ISOLATED_TRANSPORT		0x00200000
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index af1e760453d9..2673522c76bc 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -381,6 +381,8 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY	BIT(16)
 #define KSMBD_SHARE_FLAG_HIDE_UNREADABLE		BIT(17)
 #define KSMBD_SHARE_FLAG_TIME_MACHINE			BIT(18)
+/* Keep BIT(19) reserved for the existing ksmbd-tools WIDE_LINKS flag. */
+#define KSMBD_SHARE_FLAG_ENCRYPT_DATA			BIT(20)
 
 /*
  * Tree connect request flags.
diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 53d6f71dd871..9edb2fe08812 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -47,6 +47,7 @@ static const struct ksmbd_const_name ksmbd_share_flag_names[] = {
 	{KSMBD_SHARE_FLAG_UPDATE, "update"},
 	{KSMBD_SHARE_FLAG_CROSSMNT, "crossmnt"},
 	{KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY, "continuous-availability"},
+	{KSMBD_SHARE_FLAG_ENCRYPT_DATA, "encrypt-data"},
 };
 
 static int proc_show_shares(struct seq_file *m, void *v)
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index d619d1f22601..7881fc7bb8cd 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -24,6 +24,8 @@
 #include "auth.h"
 #include "stats.h"
 #include "compress.h"
+#include "mgmt/share_config.h"
+#include "mgmt/tree_connect.h"
 
 int ksmbd_debug_types;
 
@@ -236,6 +238,15 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 							STATUS_NETWORK_NAME_DELETED);
 					goto send;
 				}
+
+				if (work->tcon &&
+				    test_share_config_flag(work->tcon->share_conf,
+							   KSMBD_SHARE_FLAG_ENCRYPT_DATA) &&
+				    !work->encrypted) {
+					conn->ops->set_rsp_status(work,
+								  STATUS_ACCESS_DENIED);
+					goto send;
+				}
 			}
 		}
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bcf4e8e1ca22..aa662adaf63d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2636,12 +2636,22 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		    name, treename);
 
 	status = ksmbd_tree_conn_connect(work, name);
-	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
+	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
-	else
+		share = status.tree_conn->share_conf;
+
+		/* A share that requires encryption needs a negotiated SMB3 cipher. */
+		if (test_share_config_flag(share, KSMBD_SHARE_FLAG_ENCRYPT_DATA) &&
+		    !smb3_encryption_negotiated(conn)) {
+			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
+			status.tree_conn = NULL;
+			share = NULL;
+			status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+			goto out_err1;
+		}
+	} else
 		goto out_err1;
 
-	share = status.tree_conn->share_conf;
 	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC share path request\n");
 		rsp->ShareType = SMB2_SHARE_TYPE_PIPE;
@@ -2687,9 +2697,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	    conn->compress_algorithm != SMB3_COMPRESS_NONE)
 		rsp->ShareFlags |= cpu_to_le32(SMB2_SHAREFLAG_COMPRESS_DATA);
 	if (share && test_share_config_flag(share,
-					  KSMBD_SHARE_FLAG_HIDE_UNREADABLE))
+					    KSMBD_SHARE_FLAG_HIDE_UNREADABLE))
 		rsp->ShareFlags |=
 			cpu_to_le32(SMB2_SHAREFLAG_ACCESS_BASED_DIRECTORY_ENUM);
+	if (share && test_share_config_flag(share,
+					    KSMBD_SHARE_FLAG_ENCRYPT_DATA))
+		rsp->ShareFlags |=
+			cpu_to_le32(SMB2_SHAREFLAG_ENCRYPT_DATA);
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc) {
-- 
2.25.1

