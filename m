Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0928C1E49F
	for <linux-cifs@vger.kernel.org>; Mon,  5 Aug 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722863414; cv=none; b=isPl+jsoymZwwK8u2CeyxPBN49xndEWXQfKAnYp5QsEARZYQLZ04cLp7xBxh8ieT0m0iJ+UiclmTet2G9GbsA6W/bsydCtzsrbBP4nJ3s4nVyvDNl8z01zLnk110Ey08hbcTtCqWjZTR46TMJnW9EaIqSC42h61apfUgHvRqFV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722863414; c=relaxed/simple;
	bh=IyD4Ut1oPYGv44aKG0/fJs87/3IIhOGwMXHwKAmGtM4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SafDruThqCEUldos8P7aBmmjPgKHNQdVkr22mYd0dfEG+4/pgOMXszBaf4TSncm0vBcDzyizmkieYv8G531DwFGfXTTMuohzWNUnZAIniYCGt8gwuZRjYP884NsBUU2a9ke1iRBrXtkQ8sK4BpZjwPnq9hkY0hyst3caqRBayI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7106cf5771bso2814251b3a.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Aug 2024 06:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722863412; x=1723468212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BM7oSSpCSFl9vUdJ7Xv8CQw6+Luou8nX2D6egQpH5tI=;
        b=bWS8N6l86kfJIHtktAe3czWhUYcrgbci28rgWv3T5UgDmSPzboCvKhIPun7vwk27Ec
         7zm+r9JoN7JrpAP/RT3GcpJHZvWiR/9eVOgnJmoaXM94nrB+O0VfEIwnS1PAicfqYebQ
         f3oLEVDKH489h6pBIfBEbKZqmjnNbI1N9OEwO7ywRf8jEsfxMNco3yBuC7PGq/zrhRgA
         hrkjr3C91MoT4u3NSEVQZUiawWzIuOA137UzQK+dDL2Q54ccJmUCzJDGXPiG00HLM86c
         +GDAdspO99h675J4YyxjFwxGAL1QezUVLB3KjP3Hbzv0MpoB9K1MTcrHrOAn7O76v6Li
         8AYA==
X-Gm-Message-State: AOJu0YwWMlcjzLhSEcDi4zYZNL4fD2CRiUgYvgbBKQdGBq0SIsN6Sn7X
	eOy88LpwxIZT74ilqgJ6+4W/FZPCXk09Cwddzfnvm+/g27K5ew6xssmqhw==
X-Google-Smtp-Source: AGHT+IG1i1GyU/DBLm6K0Tcyq/mQEfywaCSXAWXB06ZFBWzdyZ0kCUgSjCASxE43yKJS4pjSuEXtSg==
X-Received: by 2002:a05:6a20:4329:b0:1c3:b210:404c with SMTP id adf61e73a8af0-1c699411696mr13030140637.0.1722863411913;
        Mon, 05 Aug 2024 06:10:11 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec01098sm5362730b3a.40.2024.08.05.06.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 06:10:11 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>
Subject: [PATCH 1/2] ksmbd: override fsids for share path check
Date: Mon,  5 Aug 2024 22:08:49 +0900
Message-Id: <20240805130850.3776-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for share
path check.

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 15 ++++++++++++---
 fs/smb/server/mgmt/share_config.h |  4 +++-
 fs/smb/server/mgmt/tree_connect.c |  9 +++++----
 fs/smb/server/mgmt/tree_connect.h |  4 ++--
 fs/smb/server/smb2pdu.c           |  2 +-
 fs/smb/server/smb_common.c        |  9 +++++++--
 fs/smb/server/smb_common.h        |  2 ++
 7 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index e0a6b758094f..d8d03070ae44 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -15,6 +15,7 @@
 #include "share_config.h"
 #include "user_config.h"
 #include "user_session.h"
+#include "../connection.h"
 #include "../transport_ipc.h"
 #include "../misc.h"
 
@@ -120,12 +121,13 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	return 0;
 }
 
-static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
+static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 						       const char *name)
 {
 	struct ksmbd_share_config_response *resp;
 	struct ksmbd_share_config *share = NULL;
 	struct ksmbd_share_config *lookup;
+	struct unicode_map *um = work->conn->um;
 	int ret;
 
 	resp = ksmbd_ipc_share_config_request(name);
@@ -181,7 +183,14 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 				      KSMBD_SHARE_CONFIG_VETO_LIST(resp),
 				      resp->veto_list_sz);
 		if (!ret && share->path) {
+			if (__ksmbd_override_fsids(work, share)) {
+				kill_share(share);
+				share = NULL;
+				goto out;
+			}
+
 			ret = kern_path(share->path, 0, &share->vfs_path);
+			ksmbd_revert_fsids(work);
 			if (ret) {
 				ksmbd_debug(SMB, "failed to access '%s'\n",
 					    share->path);
@@ -214,7 +223,7 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 	return share;
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
+struct ksmbd_share_config *ksmbd_share_config_get(struct ksmbd_work *work,
 						  const char *name)
 {
 	struct ksmbd_share_config *share;
@@ -227,7 +236,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
 
 	if (share)
 		return share;
-	return share_config_request(um, name);
+	return share_config_request(work, name);
 }
 
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index 5f591751b923..d4ac2dd4de20 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -11,6 +11,8 @@
 #include <linux/path.h>
 #include <linux/unicode.h>
 
+struct ksmbd_work;
+
 struct ksmbd_share_config {
 	char			*name;
 	char			*path;
@@ -68,7 +70,7 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
 	__ksmbd_share_config_put(share);
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
+struct ksmbd_share_config *ksmbd_share_config_get(struct ksmbd_work *work,
 						  const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index d2c81a8a11dd..94a52a75014a 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -16,17 +16,18 @@
 #include "user_session.h"
 
 struct ksmbd_tree_conn_status
-ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			const char *share_name)
+ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 {
 	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
 	struct ksmbd_share_config *sc;
 	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct sockaddr *peer_addr;
+	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	int ret;
 
-	sc = ksmbd_share_config_get(conn->um, share_name);
+	sc = ksmbd_share_config_get(work, share_name);
 	if (!sc)
 		return status;
 
@@ -61,7 +62,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		struct ksmbd_share_config *new_sc;
 
 		ksmbd_share_config_del(sc);
-		new_sc = ksmbd_share_config_get(conn->um, share_name);
+		new_sc = ksmbd_share_config_get(work, share_name);
 		if (!new_sc) {
 			pr_err("Failed to update stale share config\n");
 			status.ret = -ESTALE;
diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index 6377a70b811c..a42cdd051041 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -13,6 +13,7 @@
 struct ksmbd_share_config;
 struct ksmbd_user;
 struct ksmbd_conn;
+struct ksmbd_work;
 
 enum {
 	TREE_NEW = 0,
@@ -50,8 +51,7 @@ static inline int test_tree_conn_flag(struct ksmbd_tree_connect *tree_conn,
 struct ksmbd_session;
 
 struct ksmbd_tree_conn_status
-ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			const char *share_name);
+ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name);
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon);
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 37a39ab4ee65..54154d36ea2f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1955,7 +1955,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "tree connect request for tree %s treename %s\n",
 		    name, treename);
 
-	status = ksmbd_tree_conn_connect(conn, sess, name);
+	status = ksmbd_tree_conn_connect(work, name);
 	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
 	else
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 474dadf6b7b8..13818ecb6e1b 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -732,10 +732,10 @@ bool is_asterisk(char *p)
 	return p && p[0] == '*';
 }
 
-int ksmbd_override_fsids(struct ksmbd_work *work)
+int __ksmbd_override_fsids(struct ksmbd_work *work,
+		struct ksmbd_share_config *share)
 {
 	struct ksmbd_session *sess = work->sess;
-	struct ksmbd_share_config *share = work->tcon->share_conf;
 	struct cred *cred;
 	struct group_info *gi;
 	unsigned int uid;
@@ -775,6 +775,11 @@ int ksmbd_override_fsids(struct ksmbd_work *work)
 	return 0;
 }
 
+int ksmbd_override_fsids(struct ksmbd_work *work)
+{
+	return __ksmbd_override_fsids(work, work->tcon->share_conf);
+}
+
 void ksmbd_revert_fsids(struct ksmbd_work *work)
 {
 	const struct cred *cred;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index f1092519c0c2..4a3148b0167f 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -447,6 +447,8 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn,
 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command);
 
 int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp);
+int __ksmbd_override_fsids(struct ksmbd_work *work,
+			   struct ksmbd_share_config *share);
 int ksmbd_override_fsids(struct ksmbd_work *work);
 void ksmbd_revert_fsids(struct ksmbd_work *work);
 
-- 
2.25.1

