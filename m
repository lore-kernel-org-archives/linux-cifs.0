Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95837EEC0
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555623; cv=none; b=EsrTA2SsXTrXYmNdI9Du9tprZZO2lIVN32CTVWuHH4wbgqzAWiqQ1nKECTp7iLvTNCyCWrYrPCJ2lXjxu5QFDmPm2jlLpP4eSbO5nbK9kCGveE1zz0/dafFBGpqazfMDblDYV1/Q2uTt+FTacLun64rINNR9PQACkVJAJ55NjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555623; c=relaxed/simple;
	bh=7JlRvOY1ZYQ79xpYjKxdAMPpoGLKCsZUM8GsHE3Jh74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukmJ5Qumue1tS3G5M3nxiq8H7ZNqklxHD+BXkblbw+BXvXJcevO21wb61TozcZKD3i1tPcN2X0xtSSfXT0sxWhHw5v9lOBI334X0f4Yg1RBBaUxNDjlf1/lcYBMhQ9WlHcz7CnkeSAofByF1TXNR0rLSaDZwArT/aMF3YfiyrKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1pFmhH+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1pFmhH+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c59f740cso9264225e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555620; x=1784160420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+borDs7tecqctzCmc0vk8N+N3n+8jkKtKfsHFQVDjM=;
        b=E1pFmhH+cU1I1BWuehdAhxp8ECsQE+IXSlsk65Hf8sXcrSf0+Bui7jNh4BwA+CSRiO
         M9nwsc5E0JUCKA58wpxj+ZUbU4w0qDzmHBSnGY3IUBctAnXL9nLcEFm+XC2gHkFejdAW
         MWkCZNQL2Sm/a4wmqq3h5b7pbsegQ8y2k69pdctZlxOEr3neCVJ9oX5rLcgQ6qeLgoA+
         DknBPJlqfWtzqq7+sRqlX+DzuDdfpJk2kLQvNhV8yH+8axDPPH4/O3fscK7O9Ein7oH5
         jrGTaDn4cBZLCqPlmD86Cg42z1x3vEWmLwJPDVaJkd+Bx7Yfz7tfD13nqXqmJz/2k65z
         MFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555620; x=1784160420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+borDs7tecqctzCmc0vk8N+N3n+8jkKtKfsHFQVDjM=;
        b=HMc0oeiW21CaDpAKOW4Ik+i5UPfrqEx1GEcpOhdAF38r+7F37TN4Qz2By5uE9OsPaN
         zcEZKLqsbhOLPvC3zHAZt5/V+Mn7+niNWvJ/RuGfHUjpTfPSR38B/8ZvtECnalouWYsS
         rok8fuPSteecwADzO9shuwDHtiKIVpWZGOFmJp3L0ajQjwQMCx+hCey7EPU//FZZtFqp
         XrIC8q582PFlhSNjvrAKzVbh91j032N6O+VD0++luITFihlX4jlxH/nvahmyTttiAtd9
         8vzfYv795HSd4InjcXOR58oPBKk33z1eZNOWNeUkSIn9FYl4avtu+41NFzgVBZ3MgPfe
         Jxng==
X-Forwarded-Encrypted: i=1; AHgh+Rrl2WRFlq/DAm4bY5US4vGzI7b4l4xlL6HDFFSdgleWaDzLnzJIuxyCm9O+AW47cYec/eLUIskypBYn@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxyixm1uJ80AOnO5tCJx+s3GdmLOl5XxJXCQFjGYuOkcX7A5Xx
	b3DnErhvMfkDqCDkCwX4J0CHkrBJE9IgZeLA03biwSn5y1tyDr+VWBbaKOXbGsIw
X-Gm-Gg: AfdE7cnOwx0ZXtEPAR0Zbt0J9t+ztEmYiMOt1oZmddeAafttAZ+j+LqZCX1gEr6gaCd
	+u5X2PKHeQQfB5zYlorWphHUIVMvnx2o9Zj2VBwaVeEBsOZzaztxGnSmsNNWx0qgPRmk4J6soLY
	6FUAlq6i+fIuFHeEn/Tu8zzaSeQTGme+Mpb1LM4J6jLwJpOUOTio3TyeH8sYuJ+RmsGjJCZJF31
	uPDQzRIOWunOpno9dar96lPcxuc60c5d+wOinXY6ii1MjSs0QNsFuFXjtom9Enn5Pt9PktLL9rO
	jKm4b8qEZgXlVjJGJeifTWcvTntk3xjG3ij2cyv9bJMj+mEA09v/+JcGcgGC4wPWzBu7Cek8gAH
	zf3mTJ0fk5kosXiCxlFdjRgtn5kq4iWtdyPr6efRyHlzsU2Mlz6M55PBYv+gSVQQF3TzFPQrDai
	+8mPll/6PDvmIPde24NUt1rcJDQtGsrzGtCHI=
X-Received: by 2002:a05:600c:e558:10b0:493:e57e:7aa5 with SMTP id 5b1f17b1804b1-493e68c6e63mr30104795e9.22.1783555619880;
        Wed, 08 Jul 2026 17:06:59 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.06.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:59 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/6] ksmbd: add Apple AAPL kAAPL_SERVER_QUERY create context support
Date: Thu,  9 Jul 2026 02:06:07 +0200
Message-ID: <20260709000618.66534-2-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000618.66534-1-g.blivet@me.com>
References: <20260709000618.66534-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

macOS clients (Finder, and specifically Time Machine's backupd) send
an "AAPL" SMB2 create context on CREATE to negotiate Apple-specific
server capabilities (server_caps/vol_caps/model string). Without a
response to this context, macOS Time Machine over SMB does not work
at all.

Add the AAPL create context structs (create_aapl_rsp,
aapl_server_query_req) and create_aapl_rsp_buf(), which builds the
kAAPL_SERVER_QUERY response mirroring the layout observed from macOS's
own smbd, including the model string workaround: omitting the model
string when the client requested it causes smbfs.kext to enter a
broken disconnect path requiring a full macOS reboot to recover from.
Command codes and bitmap values reuse the existing SMB2_CRTCTX_AAPL_*
constants in fs/smb/common/smb2pdu.h.

Wire format confirmed against Apple's published SMBClient kernel
source (apple-oss-distributions/SMBClient, smb_smb_2.c) -- every field
here and every SMB2_CRTCTX_AAPL_* constant matches exactly.

Hook the request parsing and response into smb2_open()'s existing
create-context handling, following the same DataOffset+DataLength
bounds-checking convention already used by every other context parser
in this file. The AAPL model string is configurable via the existing
netlink startup path (server_conf.aapl_model, default "Xserve").

This is scoped to shares with the new KSMBD_SHARE_FLAG_TIME_MACHINE
flag only, not enabled globally -- Apple's AAPL extension is
undocumented, so containing its blast radius to shares that explicitly
opt in limits risk to ordinary SMB shares.

conn->aapl_readdir_attr is set here when the client also advertises
READDIR_ATTR support, but the actual inline-FinderInfo wire format
(the feature that flag gates) is not implemented yet -- follow-up
commit.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Cross-checked wire format against Apple's published
SMBClient kernel source (apple-oss-distributions/SMBClient,
smb_smb_2.c) -- confirmed every field and constant matches; no
functional change.

 fs/smb/common/smbglob.h       |  1 +
 fs/smb/server/connection.h    |  1 +
 fs/smb/server/ksmbd_netlink.h |  4 +-
 fs/smb/server/oplock.c        | 77 +++++++++++++++++++++++++++++++++++
 fs/smb/server/oplock.h        |  1 +
 fs/smb/server/server.h        |  2 +
 fs/smb/server/smb2ops.c       |  4 ++
 fs/smb/server/smb2pdu.c       | 56 ++++++++++++++++++++++++-
 fs/smb/server/smb2pdu.h       | 60 +++++++++++++++++++++++++++
 fs/smb/server/transport_ipc.c |  9 ++++
 10 files changed, 213 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index 4e33d91cd..d9c7e6e7a 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -39,6 +39,7 @@ struct smb_version_values {
 	size_t		create_mxac_size;
 	size_t		create_disk_id_size;
 	size_t		create_posix_size;
+	size_t		create_aapl_size;
 };
 
 static inline unsigned int get_rfc1002_len(void *buf)
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 04621cb11..fe64dd24b 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -124,6 +124,7 @@ struct ksmbd_conn {
 	bool				binding;
 	atomic_t			refcnt;
 	bool				is_aapl;
+	bool				aapl_readdir_attr; /* READDIR_ATTR negotiated */
 	struct work_struct		release_work;
 };
 
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index c9e1b0b68..1ea0a367b 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -113,7 +113,8 @@ struct ksmbd_startup_request {
 	__u32	max_connections;	/* Number of maximum simultaneous connections */
 	__s8	bind_interfaces_only;
 	__u32	max_ip_connections;	/* Number of maximum connection per ip address */
-	__s8	reserved[499];		/* Reserved room */
+	__s8	aapl_model[32];		/* AAPL model string for Finder icon, e.g. "Xserve" */
+	__s8	reserved[467];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 } __packed;
@@ -378,6 +379,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_CROSSMNT			BIT(15)
 #define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY	BIT(16)
 #define KSMBD_SHARE_FLAG_HIDE_UNREADABLE		BIT(17)
+#define KSMBD_SHARE_FLAG_TIME_MACHINE			BIT(18)
 
 /*
  * Tree connect request flags.
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 3c55ae5d6..693db52cd 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -16,6 +16,7 @@
 #include "mgmt/user_session.h"
 #include "mgmt/share_config.h"
 #include "mgmt/tree_connect.h"
+#include "server.h"
 
 static LIST_HEAD(lease_table_list);
 static DEFINE_RWLOCK(lease_list_lock);
@@ -2136,6 +2137,82 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);
 }
 
+/**
+ * create_aapl_rsp_buf() - build Apple AAPL kAAPL_SERVER_QUERY response
+ * @cc:         buffer to write the create context into (AAPL_RSP_MAX_SIZE bytes)
+ * @vol_caps:   volume capability flags (SMB2_CRTCTX_AAPL_* volume bits)
+ * @req_bitmap: the client's request bitmap, echoed back in reply_bitmap
+ *
+ * Response format follows the layout observed from macOS's own smbd, and
+ * matches the client-side parsing in Apple's published SMBClient kernel
+ * source (apple-oss-distributions/SMBClient, smb_smb_2.c, kAAPL_SERVER_QUERY
+ * case): reply_bitmap, then server_caps/vol_caps/model-info fields present
+ * only when their reply_bitmap bit is set:
+ *   reply_bitmap = req_bitmap masked to the fields we support
+ *   server_caps  = AAPL_SERVER_CAPS_KSMBD when requested
+ *   vol_caps     = caller-supplied
+ *   model string = server_conf.aapl_model (default "Xserve") in UTF-16LE,
+ *                  when SMB2_CRTCTX_AAPL_MODEL_INFO requested
+ *
+ * Sending reply_bitmap with MODEL_INFO set but no model string causes
+ * smbfs.kext to enter a broken disconnect path requiring a macOS reboot.
+ */
+void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap)
+{
+	struct create_aapl_rsp *buf;
+	u64 reply_bitmap;
+	u32 data_len;
+
+	buf = (struct create_aapl_rsp *)cc;
+	memset(buf, 0, AAPL_RSP_MAX_SIZE);
+
+	reply_bitmap = req_bitmap & (SMB2_CRTCTX_AAPL_SERVER_CAPS |
+				     SMB2_CRTCTX_AAPL_VOLUME_CAPS |
+				     SMB2_CRTCTX_AAPL_MODEL_INFO);
+
+	/* base data: cmd(4)+reserved(4)+reply_bitmap(8)+server_caps(8)+vol_caps(8) */
+	data_len = 32;
+	if (reply_bitmap & SMB2_CRTCTX_AAPL_MODEL_INFO)
+		data_len += 4 + 4 + AAPL_MODEL_UTF16_BYTES; /* pad2+model_bytes+string */
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof(struct create_aapl_rsp, cmd));
+	buf->ccontext.DataLength = cpu_to_le32(data_len);
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof(struct create_aapl_rsp, Name));
+	buf->ccontext.NameLength = cpu_to_le16(SMB2_CREATE_AAPL_LEN);
+	buf->Name[0] = 'A';
+	buf->Name[1] = 'A';
+	buf->Name[2] = 'P';
+	buf->Name[3] = 'L';
+
+	buf->cmd = cpu_to_le32(SMB2_CRTCTX_AAPL_SERVER_QUERY);
+	buf->reply_bitmap = cpu_to_le64(reply_bitmap);
+	buf->server_caps = (reply_bitmap & SMB2_CRTCTX_AAPL_SERVER_CAPS) ?
+			   cpu_to_le64(AAPL_SERVER_CAPS_KSMBD) : 0;
+	buf->vol_caps = (reply_bitmap & SMB2_CRTCTX_AAPL_VOLUME_CAPS) ?
+			cpu_to_le64(vol_caps) : 0;
+
+	if (reply_bitmap & SMB2_CRTCTX_AAPL_MODEL_INFO) {
+		__le32 *p = (__le32 *)((u8 *)buf + sizeof(*buf));
+		__le16 *model_str = (__le16 *)(p + 2);
+		const char *src = server_conf.aapl_model[0] ?
+				  server_conf.aapl_model : "Xserve";
+		int i, model_bytes = 0;
+
+		/* Convert ASCII model string to UTF-16LE in-place */
+		for (i = 0; src[i] && i < AAPL_MODEL_MAX_CHARS; i++) {
+			model_str[i] = cpu_to_le16((unsigned char)src[i]);
+			model_bytes += 2;
+		}
+
+		p[0] = 0; /* pad2 */
+		p[1] = cpu_to_le32(model_bytes);
+
+		/* Update DataLength to reflect actual model string size */
+		buf->ccontext.DataLength =
+			cpu_to_le32(data_len - AAPL_MODEL_UTF16_BYTES + model_bytes);
+	}
+}
+
 /*
  * Find lease object(opinfo) for given lease key/fid from lease
  * break/file close path.
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 3f581d22b..f7f6afcc5 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -125,6 +125,7 @@ void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp);
 void create_mxac_rsp_buf(char *cc, int maximal_access);
 void create_disk_id_rsp_buf(char *cc, __u64 file_id, __u64 vol_id);
 void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
+void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
diff --git a/fs/smb/server/server.h b/fs/smb/server/server.h
index b8a7317be..4d4d268b5 100644
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -48,6 +48,8 @@ struct ksmbd_server_config {
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 	struct task_struct	*dh_task;
 	bool			bind_interfaces_only;
+	/* AAPL model string for Finder icon, e.g. "Xserve" */
+	char			aapl_model[32];
 };
 
 extern struct ksmbd_server_config server_conf;
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index c9a32ee09..97938150d 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -37,6 +37,7 @@ static struct smb_version_values smb21_server_values = {
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
+	.create_aapl_size = AAPL_RSP_MAX_SIZE,
 };
 
 static struct smb_version_values smb30_server_values = {
@@ -64,6 +65,7 @@ static struct smb_version_values smb30_server_values = {
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
+	.create_aapl_size = AAPL_RSP_MAX_SIZE,
 };
 
 static struct smb_version_values smb302_server_values = {
@@ -91,6 +93,7 @@ static struct smb_version_values smb302_server_values = {
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
+	.create_aapl_size = AAPL_RSP_MAX_SIZE,
 };
 
 static struct smb_version_values smb311_server_values = {
@@ -118,6 +121,7 @@ static struct smb_version_values smb311_server_values = {
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
+	.create_aapl_size = AAPL_RSP_MAX_SIZE,
 };
 
 static struct smb_version_ops smb2_0_server_ops = {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 81f4af614..9c70e97d8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3358,6 +3358,8 @@ int smb2_open(struct ksmbd_work *work)
 	int rc = 0;
 	int contxt_cnt = 0, query_disk_id = 0;
 	bool maximal_access_ctxt = false, posix_ctxt = false;
+	bool aapl_ctxt = false;
+	__u64 aapl_req_bitmap = 0, aapl_client_caps = 0;
 	int s_type = 0;
 	int next_off = 0;
 	char *name = NULL;
@@ -4122,7 +4124,32 @@ int smb2_open(struct ksmbd_work *work)
 			query_disk_id = 1;
 		}
 
-		if (conn->is_aapl == false) {
+		if (test_share_config_flag(share, KSMBD_SHARE_FLAG_TIME_MACHINE)) {
+			context = smb2_find_context_vals(req, SMB2_CREATE_AAPL, 4);
+			if (IS_ERR(context)) {
+				rc = PTR_ERR(context);
+				goto err_out1;
+			} else if (context) {
+				struct aapl_server_query_req *aapl_req;
+
+				if (le32_to_cpu(context->DataLength) <
+				    sizeof(struct aapl_server_query_req)) {
+					rc = -EINVAL;
+					goto err_out1;
+				}
+
+				aapl_req = (struct aapl_server_query_req *)
+					((char *)context +
+					 le16_to_cpu(context->DataOffset));
+				if (le32_to_cpu(aapl_req->cmd) ==
+				    SMB2_CRTCTX_AAPL_SERVER_QUERY) {
+					conn->is_aapl = true;
+					aapl_ctxt = true;
+					aapl_req_bitmap = le64_to_cpu(aapl_req->req_bitmap);
+					aapl_client_caps = le64_to_cpu(aapl_req->client_caps);
+				}
+			}
+		} else if (conn->is_aapl == false) {
 			context = smb2_find_context_vals(req, SMB2_CREATE_AAPL, 4);
 			if (IS_ERR(context)) {
 				rc = PTR_ERR(context);
@@ -4329,6 +4356,10 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (posix_ctxt) {
+		struct create_context *posix_ccontext;
+
+		posix_ccontext = (struct create_context *)(rsp->Buffer +
+				le32_to_cpu(rsp->CreateContextsLength));
 		contxt_cnt++;
 		create_posix_rsp_buf(rsp->Buffer +
 				le32_to_cpu(rsp->CreateContextsLength),
@@ -4338,6 +4369,29 @@ int smb2_open(struct ksmbd_work *work)
 		iov_len += conn->vals->create_posix_size;
 		if (next_ptr)
 			*next_ptr = cpu_to_le32(next_off);
+		next_ptr = &posix_ccontext->Next;
+		next_off = conn->vals->create_posix_size;
+	}
+
+	/*
+	 * AAPL create context response: see smb2pdu.h for the capability
+	 * rationale. Scoped to TIME_MACHINE shares only.
+	 */
+	if (aapl_ctxt) {
+		if (aapl_client_caps & SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR)
+			conn->aapl_readdir_attr = true;
+
+		contxt_cnt++;
+		create_aapl_rsp_buf(rsp->Buffer +
+				le32_to_cpu(rsp->CreateContextsLength),
+				SMB2_CRTCTX_AAPL_FULL_SYNC,
+				aapl_req_bitmap);
+		le32_add_cpu(&rsp->CreateContextsLength,
+			     conn->vals->create_aapl_size);
+		iov_len += conn->vals->create_aapl_size;
+		if (next_ptr)
+			*next_ptr = cpu_to_le32(next_off);
+		/* AAPL is last; next_ptr need not be updated */
 	}
 
 	if (contxt_cnt > 0) {
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 70b1f630e..740358a2b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -66,6 +66,66 @@ struct preauth_integrity_info {
 /* Apple Defined Contexts */
 #define SMB2_CREATE_AAPL		"AAPL"
 
+/*
+ * Apple AAPL SMB2 extension -- kAAPL_SERVER_QUERY create context.
+ *
+ * Command code and bitmap values are the existing
+ * SMB2_CRTCTX_AAPL_* constants in fs/smb/common/smb2pdu.h (see Samba's
+ * libcli/smb/smb2_create_ctx.h, cited there).
+ *
+ * Omitting the model string when reply_bitmap includes
+ * SMB2_CRTCTX_AAPL_MODEL_INFO causes smbfs.kext to enter a broken
+ * disconnect path requiring a reboot.
+ *
+ * Layout: ccontext(16) + Name[4] + Pad[4] + cmd(4) + reserved(4) +
+ *         reply_bitmap(8) + server_caps(8) + vol_caps(8)
+ * When MODEL_INFO requested, appended: pad2(4) + model_bytes(4) + UTF-16LE
+ */
+#define SMB2_CREATE_AAPL_LEN	4
+
+/*
+ * Server capability flags (server_caps field) -- SMB2_CRTCTX_AAPL_UNIX_BASED:
+ * prevents macOS Windows-compat mode (question-mark icons).
+ * SMB2_CRTCTX_AAPL_SUPPORTS_OSX_COPYFILE: enables server-side file copy via
+ * FSCTL_SRV_COPYCHUNK. SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR: inline
+ * FinderInfo per FIND entry, set when client also advertises the bit;
+ * format: EaSize=max_access, ShortName[0..7]=rfork_size,
+ * ShortName[8..23]=FinderInfo(16B), Reserved2=unix_mode.
+ */
+#define AAPL_SERVER_CAPS_KSMBD	(SMB2_CRTCTX_AAPL_UNIX_BASED | \
+				 SMB2_CRTCTX_AAPL_SUPPORTS_OSX_COPYFILE | \
+				 SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR)
+
+/* Model string: up to 31 ASCII chars */
+#define AAPL_MODEL_MAX_CHARS	31
+#define AAPL_MODEL_UTF16_BYTES	(AAPL_MODEL_MAX_CHARS * 2)
+
+/*
+ * Max AAPL response: header(24) + base data(32) + pad2(4) + model_bytes(4)
+ * + model(62), 8-byte aligned: ALIGN(126, 8) = 128 bytes.
+ */
+#define AAPL_RSP_MAX_SIZE	128
+
+/* AAPL server query request (client->server) */
+struct aapl_server_query_req {
+	__le32 cmd;
+	__le32 reserved;
+	__le64 req_bitmap;
+	__le64 client_caps;
+} __packed;
+
+struct create_aapl_rsp {
+	struct create_context_hdr ccontext;
+	__u8   Name[4];
+	__u8   Pad[4];
+	__le32 cmd;
+	__le32 reserved;
+	__le64 reply_bitmap;
+	__le64 server_caps;
+	__le64 vol_caps;
+	/* when MODEL_INFO requested: __le32 pad2; __le32 model_bytes; __le16 model[] */
+} __packed;
+
 #define DURABLE_HANDLE_MAX_TIMEOUT	300000
 
 struct create_alloc_size_req {
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 0c581b962..bd58d3d0b 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -322,6 +322,15 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		goto out;
 	}
 	server_conf.share_fake_fscaps = req->share_fake_fscaps;
+
+	/* AAPL model string for Finder icon */
+	if (req->aapl_model[0])
+		strscpy(server_conf.aapl_model, req->aapl_model,
+			sizeof(server_conf.aapl_model));
+	else
+		strscpy(server_conf.aapl_model, "Xserve",
+			sizeof(server_conf.aapl_model));
+
 	ksmbd_init_domain(req->sub_auth);
 
 	if (req->smb2_max_read)

base-commit: 545c40084bb831530033265b654290ff7be5b090
-- 
2.43.0

