Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACF71865F3;
	Fri, 23 Aug 2024 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724421791; cv=none; b=d0uGkIfzcPchiEcGIKjJzSyWDjG3y3QSa/ORVg6nrs0ilEGAPBm63tenuNM83F1EEzpov33EGo+hAvn71cMP6wiW5Pv9VBpUOzNO7DOVubXIwVZpDEh2pqm9sHFdTSnVZKvPNnieV3XrZfWDXJS51GvwZ0PQ9LK1cykGJ6QDGjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724421791; c=relaxed/simple;
	bh=UBkZSWZSnW0WP+DA5yTbTapuBk70nzzE/W2b7RXKAQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZOFTqXBu6xLqA5bF+6ZCTCfdz0uBX03IFuajVvpfnDlEz72JCrfXCQzYRgbZXaQUm8yOciOpjFg6pgJUzhiyXId7nMC5YWIHvY212g7a/VV0Axrmuhc+u8Y4SSOpskQdwJbBuw97xZJ/6/RQ9q9kZVmSfherI+E4KWJdJC2a38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQJHmMZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQJHmMZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C5EC32786;
	Fri, 23 Aug 2024 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724421791;
	bh=UBkZSWZSnW0WP+DA5yTbTapuBk70nzzE/W2b7RXKAQE=;
	h=From:To:Cc:Subject:Date:From;
	b=RQJHmMZh5ugLS6Jc0XOziaUOTebzSVbkUG1SdGfU+oeVOFYgp9FtSrmamx49TPILv
	 taKyv8YJTdwIjYypmNC9dO8UiIRqpEoL+QNeFF+hj57Z3l7HqCCpMZSe2biXEn1egX
	 OeBTKA1gZMqhUT3UdTyPzqzyxqjywDlhgsds06GJAeV+QVXRcgaMqiHNYuCikqyJtJ
	 kvyYRJSWrUYB/l61WsLdC6ja3BAGzixNgd5132qn0nnxvVAwjbCdofzAa4X6sWOLEQ
	 C1ziqdxxE9YSBpco3Xbu/B18x+HLWexsPcYdJMVsQMZOMlsXbqcdQn8GYKjzoQJpbt
	 Oor3NenYCzvJw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	bonifaido@gmail.com,
	atteh.mailbox@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/20] ksmbd: override fsids for share path check
Date: Fri, 23 Aug 2024 10:02:15 -0400
Message-ID: <20240823140309.1974696-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.47
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a018c1b636e79b60149b41151ded7c2606d8606e ]

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for share
path check.

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index e0a6b758094fc..d8d03070ae44b 100644
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
index 5f591751b9236..d4ac2dd4de204 100644
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
index d2c81a8a11dda..94a52a75014a4 100644
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
index 6377a70b811c8..a42cdd0510411 100644
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
index 592a2cdfd0670..646c874d151a8 100644
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
index 474dadf6b7b8b..13818ecb6e1b2 100644
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
index f1092519c0c28..4a3148b0167f5 100644
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
2.43.0

