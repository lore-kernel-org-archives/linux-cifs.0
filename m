Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8938472
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555627; cv=none; b=bgoVC3cvTtHkffr0sjr/kOnjEiD9yhVVfDOGBlY8mYORVZwENeLaOT/ZXqaLwq55gd4b4Kgj66AWaSRG42ZdptTJ3pWWa7SoahsSrgVj67kehe8Uz3X1Jhz8iT4RfRo45NA0hxoPUctSNoRVn6ptVMMOzJQXykkHB4+yU7eV5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555627; c=relaxed/simple;
	bh=/Cyr8M6lOMhCFznblSUTljXHBCt9WpI42mMvsktnbnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsqGsP9wQtOklCUumIymrgj8q7ytNOwmzlNJnaE3fCw4GrKyADqow/URTvQ5XnDuEzAPfnEY+2I1hg66qF+/EnzQzoHJL54RNNRjiQTtTym39Tf0NWMB68yRh0z+JsmYGwndmRXnCBp1StWU830Ta6M5NEEZBq8zdls6sBMX6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rw6IoPQ8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rw6IoPQ8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c19bad03so11823685e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555624; x=1784160424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBnlL3Ibq++fctdjEBzrbegpHYJpJL3b2Bfj4itViaU=;
        b=Rw6IoPQ8PvHHWaf89U7u4nJUdIhtwWmk1RyNF0VZNhHd8xKK4igHSiri7xg7byOF6y
         n0xy75i4gDWWPHFAX2erSZu/mtfW+uVxY9d7uHYxqMrevblqGXkRJrK9NuMTyp25ZBV0
         J9EeJlGlvV9VAJodKSllhNQ6RmLdaS9dJeSRh6NO70ZqUl8/vUf7kEj8coeiKJTQBIfa
         IFwhcZKQGIbe6+KqS9SNBCVk60btRfGhP8AimuDgIlSCTAd6pFv0tIsHgSbBBtHUrpCf
         2JUZoRdeIEfp2ukCGbapTbMBAyS9l4xRgQ5f/tJydX8mn0WTpBhwfNCaOlB2Kq26b393
         6ujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555624; x=1784160424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBnlL3Ibq++fctdjEBzrbegpHYJpJL3b2Bfj4itViaU=;
        b=GTVlMTfBi3LjQmBoo1fcqJWTi8ih/NCDFSazZYTRW6iON7UJwZ9bUKgUm/3aM7q2uO
         CIoZ6Q2Ul38571X6gtHXyyAU1XAObomwrZbHwdxW7+J8rKmW0CEdAhzoUBdQSWpp7M6m
         hg9gdf/dkzVKxngLw8KoHxI4KdPAdkkMQ5JW+bO84F8l4Q/a/0Qn/PqzRX3kTf7PEAaQ
         cu1f9vyNB99vU2hXRGpTX3BQ+oZbqYtutptQZooyW4H+4Is0ydnZwxa0T1l96L7G4/KN
         uAcQUPTrd4hr72yKhIypkoapxlqtHf/jF2jEiyOevN2Lr6GVuW/6h9q2HwnpFcjXaOXp
         i9vw==
X-Forwarded-Encrypted: i=1; AHgh+RqJKJFLxckG658K69wRwumZSb1EoOQ0AFEmGl4VEuXMqnaHu+n6yvKi8Q24h72bjUegO5fIR86k2UxF@vger.kernel.org
X-Gm-Message-State: AOJu0YyOz8Bsyhiog/nvNe4LfOKFvVPFQVkagp4atRGExazl13gw/CdW
	DyzocBGbLDn8sThVHmNol6JW71PvDFzSh5+InD5jic9bQqaulK7lbYh5
X-Gm-Gg: AfdE7cmbMytAEzbJqEjuRMKZb4/mdsLfISG4tuUSHkHzIFXAyLiH0bRBtOzlm7ZtJUW
	9Q2vy3Q0zzV7ApYphLXqpNTvbUcCWL1YP8/49NKqQnVExQmHBR4cpuGKV5GWjoS2DbSWJtiGLei
	mZHmJ3Om3Wsqhi8ogvD9Dc/B9WfpCdk7yI8LBgwWj+2ciAsru221XZi0ahVS7GJKs44lRum0/Uq
	slyvWUkcoPFcZ65dMYtl3IMfQutaJoPjIGL89Lkva9bMicTKxq0K+MY6zg5L6XdJqvHwO3FmcYe
	/s4cRhTKDA1yp0SNpl0h2VwPst4Q60Ujbt0pXBvWEAvw+5JeCfcQQK/77zv8RV8rO4YZNzaAdgr
	/id4cOce/PZ4Q7AAypd/XfjgVejTzFqeJedB2St7DNoRR/HdQLinjSadN64JjOtoezr0tv+F007
	Nd186jwTf5x2k+1DLBc4VsJqkZvc9aWm3kmQY=
X-Received: by 2002:a05:600c:a55:b0:493:b163:42e8 with SMTP id 5b1f17b1804b1-493e685fedfmr47307055e9.21.1783555623997;
        Wed, 08 Jul 2026 17:07:03 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.07.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:07:03 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 6/6] ksmbd: add AAPL READDIR_ATTR V2 support
Date: Thu,  9 Jul 2026 02:06:12 +0200
Message-ID: <20260709000618.66534-7-g.blivet@me.com>
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

Extends the existing V1 inline-FinderInfo mechanism
(SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR) with the V2 variant:
byte-identical layout otherwise, confirmed against Apple's actual
SMBClient kernel source
(apple-oss-distributions/SMBClient/kernel/netsmb/smb_smb_2.c), except
the ShortNameLength+Reserved bytes (ignored outright by V1 clients)
become a single flags field that V2 clients actually interpret.

Negotiation: when a client's own client_caps requests V2
(SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2), advertise V2 instead of
V1 in the server's own server_caps reply -- they're mutually exclusive
on the wire, not both set together.

Wire format: the only currently-defined V2 flag,
AAPL_READDIR_ATTR_V2_NO_XATTR, signals that an item has no
xattrs/streams so the client can skip a separate query. Compute this
per-entry in ksmbd_vfs_fill_dentry_attrs() by checking for any xattr
under the XATTR_NAME_STREAM ("user.DosStream.") prefix -- a reliable,
distinct marker for genuine ADS/stream xattrs, unlike DOSATTRIB or ACL
xattrs which live under different prefixes, so this can't
false-positive into telling Finder a file has no extra data when it
actually does. Only computed when a V2 connection is active, to avoid
the extra listxattr() call otherwise.

V1's fixed ShortNameLength=24 convention (real macOS clients ignore
the value outright per the same client source, so it's cosmetic
parity with other real servers, not a functional requirement) is kept
V1-only rather than reused as a V2 base value -- V2 clients do
interpret this field, so it needs a clean 0-or-flag value, not a
leftover V1 constant that happens not to collide with the one defined
flag bit today.

Confirmed via live diagnostics that macOS actually negotiates and
uses V2 (client_caps bit 0x10 set) rather than falling back to V1 or
ignoring the capability.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
New for v2.

 fs/smb/common/smb2pdu.h    |  8 ++++++++
 fs/smb/server/connection.h |  1 +
 fs/smb/server/oplock.c     | 12 ++++++++++--
 fs/smb/server/oplock.h     |  3 ++-
 fs/smb/server/smb2pdu.c    | 33 +++++++++++++++++++++++++++++++--
 fs/smb/server/smb2pdu.h    | 16 ++++++++++++++++
 fs/smb/server/vfs.c        | 29 +++++++++++++++++++++++++++++
 fs/smb/server/vfs.h        |  1 +
 8 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 653cb3579..cc1edd833 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1261,6 +1261,14 @@ struct create_mxac_req {
 #define SMB2_CRTCTX_AAPL_SUPPORTS_OSX_COPYFILE  2
 #define SMB2_CRTCTX_AAPL_UNIX_BASED             4
 #define SMB2_CRTCTX_AAPL_SUPPORTS_NFS_ACE       8
+/*
+ * V2 extends the same inline-FinderInfo mechanism as
+ * SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR with an added flags field,
+ * confirmed byte-identical to V1 otherwise against Apple's actual
+ * SMBClient kernel source (apple-oss-distributions/SMBClient). Mutually
+ * exclusive with the V1 bit on the wire, not both set together.
+ */
+#define SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2 16
 
 /* "AAPL" Volume Capabilities bitmap */
 #define SMB2_CRTCTX_AAPL_SUPPORT_RESOLVE_ID 1
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index fe64dd24b..3ecfe4a7e 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -125,6 +125,7 @@ struct ksmbd_conn {
 	atomic_t			refcnt;
 	bool				is_aapl;
 	bool				aapl_readdir_attr; /* READDIR_ATTR negotiated */
+	bool				aapl_readdir_attr_v2; /* V2 specifically */
 	struct work_struct		release_work;
 };
 
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 693db52cd..f12f4e052 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -2156,11 +2156,15 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
  *
  * Sending reply_bitmap with MODEL_INFO set but no model string causes
  * smbfs.kext to enter a broken disconnect path requiring a macOS reboot.
+ * @readdir_attr_v2: advertise SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2
+ *                    instead of the V1 bit
  */
-void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap)
+void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap,
+			 bool readdir_attr_v2)
 {
 	struct create_aapl_rsp *buf;
 	u64 reply_bitmap;
+	u64 server_caps;
 	u32 data_len;
 
 	buf = (struct create_aapl_rsp *)cc;
@@ -2186,8 +2190,12 @@ void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap)
 
 	buf->cmd = cpu_to_le32(SMB2_CRTCTX_AAPL_SERVER_QUERY);
 	buf->reply_bitmap = cpu_to_le64(reply_bitmap);
+	server_caps = AAPL_SERVER_CAPS_KSMBD;
+	if (readdir_attr_v2)
+		server_caps = (server_caps & ~SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR) |
+			      SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2;
 	buf->server_caps = (reply_bitmap & SMB2_CRTCTX_AAPL_SERVER_CAPS) ?
-			   cpu_to_le64(AAPL_SERVER_CAPS_KSMBD) : 0;
+			   cpu_to_le64(server_caps) : 0;
 	buf->vol_caps = (reply_bitmap & SMB2_CRTCTX_AAPL_VOLUME_CAPS) ?
 			cpu_to_le64(vol_caps) : 0;
 
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index f7f6afcc5..aef296b21 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -125,7 +125,8 @@ void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp);
 void create_mxac_rsp_buf(char *cc, int maximal_access);
 void create_disk_id_rsp_buf(char *cc, __u64 file_id, __u64 vol_id);
 void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
-void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap);
+void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap,
+			 bool readdir_attr_v2);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 612f8c8ec..bfaa9909e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4404,12 +4404,23 @@ int smb2_open(struct ksmbd_work *work)
 	if (aapl_ctxt) {
 		if (aapl_client_caps & SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR)
 			conn->aapl_readdir_attr = true;
+		/*
+		 * V2 extends the same inline-FinderInfo mechanism (see
+		 * smb2pdu.h), so a V2-requesting client also gets
+		 * aapl_readdir_attr treatment -- the reply just advertises
+		 * the V2 bit instead of the V1 one (create_aapl_rsp_buf).
+		 */
+		if (aapl_client_caps & SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2) {
+			conn->aapl_readdir_attr = true;
+			conn->aapl_readdir_attr_v2 = true;
+		}
 
 		contxt_cnt++;
 		create_aapl_rsp_buf(rsp->Buffer +
 				le32_to_cpu(rsp->CreateContextsLength),
 				SMB2_CRTCTX_AAPL_FULL_SYNC,
-				aapl_req_bitmap);
+				aapl_req_bitmap,
+				conn->aapl_readdir_attr_v2);
 		le32_add_cpu(&rsp->CreateContextsLength,
 			     conn->vals->create_aapl_size);
 		iov_len += conn->vals->create_aapl_size;
@@ -4753,6 +4764,11 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 			 *                      the file extension for icon lookup)
 			 *   Reserved2        = Unix mode bits (uint16 LE)
 			 * Reparse-point tag is indicated via ExtFileAttributes, not EaSize.
+			 *
+			 * V2 (conn->aapl_readdir_attr_v2): ShortNameLength+Reserved
+			 * are read as a single flags field instead of being ignored
+			 * -- see smb2pdu.h for the wire-format confirmation and
+			 * AAPL_READDIR_ATTR_V2_NO_XATTR's meaning.
 			 */
 			__le32 reparse_tag =
 				smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4784,7 +4800,20 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 			 * it as a flags field that is interpreted; V1 doesn't.
 			 * Either value is safe here, so keep 24 for parity.
 			 */
-			fibdinfo->ShortNameLength = 24;
+			if (conn->aapl_readdir_attr_v2) {
+				/*
+				 * V2 repurposes this field as flags (see comment
+				 * above) -- 24 is a V1-only convention that real
+				 * macOS clients ignore outright, so don't reuse it
+				 * here as a base value for a field V2 clients
+				 * actually interpret.
+				 */
+				fibdinfo->ShortNameLength = 0;
+				if (!ksmbd_kstat->has_ads_stream)
+					fibdinfo->ShortNameLength = AAPL_READDIR_ATTR_V2_NO_XATTR;
+			} else {
+				fibdinfo->ShortNameLength = 24;
+			}
 			memset(fibdinfo->ShortName, 0, sizeof(fibdinfo->ShortName));
 			fibdinfo->Reserved2 = cpu_to_le16(ksmbd_kstat->kstat->mode & 0xffff);
 		} else {
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 740358a2b..737ee488f 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -96,6 +96,22 @@ struct preauth_integrity_info {
 				 SMB2_CRTCTX_AAPL_SUPPORTS_OSX_COPYFILE | \
 				 SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR)
 
+/*
+ * READDIR_ATTR_V2 (SMB2_CRTCTX_AAPL_SUPPORTS_READ_DIR_ATTR_V2, see
+ * fs/smb/common/smb2pdu.h) extends the same inline-FinderInfo mechanism
+ * above with a flags field, confirmed byte-identical to V1 otherwise
+ * against Apple's actual SMBClient kernel source
+ * (apple-oss-distributions/SMBClient). When the client's own client_caps
+ * requests V2, the server advertises V2 instead of V1 in its own
+ * server_caps reply; V1 and V2 are mutually exclusive on the wire, not
+ * both set together. The wire format's ShortNameLength+Reserved
+ * (ignored in V1) become a single flags field in V2 --
+ * AAPL_READDIR_ATTR_V2_NO_XATTR is the only flag bit currently defined,
+ * signaling the item has no xattrs/streams so the client can skip a
+ * separate query.
+ */
+#define AAPL_READDIR_ATTR_V2_NO_XATTR	0x01
+
 /* Model string: up to 31 ASCII chars */
 #define AAPL_MODEL_MAX_CHARS	31
 #define AAPL_MODEL_UTF16_BYTES	(AAPL_MODEL_MAX_CHARS * 2)
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 61d02322c..d00438d43 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1684,6 +1684,35 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 		}
 	}
 
+	/*
+	 * Only pay for this when it'll actually be used: AAPL
+	 * READDIR_ATTR_V2's flags field (AAPL_READDIR_ATTR_V2_NO_XATTR) is
+	 * the only consumer. XATTR_NAME_STREAM ("user.DosStream.") is a
+	 * reliable, distinct prefix for genuine ADS/stream xattrs -- unlike
+	 * DOSATTRIB or ACL xattrs, which live under different prefixes, so
+	 * this can't false-positive into telling Finder a file has no extra
+	 * data when it actually does.
+	 */
+	ksmbd_kstat->has_ads_stream = false;
+	if (work->conn->aapl_readdir_attr_v2) {
+		char *xattr_list = NULL, *name;
+		ssize_t xattr_list_len;
+
+		xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
+		if (xattr_list_len > 0) {
+			for (name = xattr_list;
+			     name - xattr_list < xattr_list_len;
+			     name += strlen(name) + 1) {
+				if (!strncmp(name, XATTR_NAME_STREAM,
+					     XATTR_NAME_STREAM_LEN)) {
+					ksmbd_kstat->has_ads_stream = true;
+					break;
+				}
+			}
+		}
+		kvfree(xattr_list);
+	}
+
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 8eab9392f..2e8f9f2d9 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -70,6 +70,7 @@ struct ksmbd_kstat {
 	struct kstat		*kstat;
 	unsigned long long	create_time;
 	__le32			file_attributes;
+	bool			has_ads_stream; /* AAPL READDIR_ATTR V2 xattr-presence flag */
 };
 
 int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
-- 
2.43.0

