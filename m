Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD552F7F15;
	Sun, 20 Sep 2026 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789928116; cv=none; b=aCoyYXSYpUddC8F84L/MgvvNo92aVhl66gf19wmh7Z1ARKaJI7FrmljjFsCzqUtrOgqpg3sYYGMAaCwREpdLVHnBnS0ALWyt+sdR7trFr0BXIjz4TO6N7FZSdbfpFR2yNzjh4hjN53fy+iZL18b/5HE/VHdmTNifJn/I/pDdWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789928116; c=relaxed/simple;
	bh=0ecfBPpTdT4pWzaZEQM5xnS9BNKsBkGsfWOoHvCBiqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pzj/0E+p6JVnCsAx6g+sXMmjfWuUnjNqO+Ikgzw4FMsojxcvDWc4WyyCPrtcOzl89gEEIRgzolADB+xb9MTtqHn6eaD1KQsJ2sR8cSAkTIqprF3NmqScgIqaPJX32VPWjexNYMKzMMImO8VXUSaWxCWxliVTV4My+kPZPD855KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=QuS8QF41; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="QuS8QF41"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o+XBoGlMGszGwo5ad6ZhQjN7K3BEdC4fN2ak4+9DbTY=; b=QuS8QF41ngzRAxAvoAkkCJRC4x
	4YSAbKKW+Fc9WnIh5ZDnIuHXlJKdqbBt0f7DQoJjiqAaZcGErsAh9Q+tJPRbjePkLzXHy+iPDQlSt
	pLl3sAfdQcrjLZiXzQSHANFveBE/hjvZVk6WbwyLBUebSfnTrRbioW8VNhVog7YsIlJYC/z04Gq/s
	WMK6bX08dni3g2NUpSNk/ZYvfFZ1yJ65bDyb0UEGQ3TxZHxZGs3wA9mGmEO6k89h/vV4QwQmcbNtl
	s/Xc4l5EQg7SJLBcAJg6VdCM7OIhXfx4z4eEsVOujXEo+cBv2tGo++HvJPz2qHy+Ec3UGHZHnFvQI
	7DUTz+9Q==;
Received: from [151.115.150.205] (port=38752 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x8M4A-00000009NDh-1py5;
	Sun, 20 Sep 2026 20:15:06 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2] ksmbd: fix SMB2 CREATE response buffer overflow
Date: Sun, 20 Sep 2026 18:15:03 +0000
Message-ID: <20260920181503.2830435-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

smb2_allocate_rsp_buf() uses the MAX_CIFS_SMALL_BUFFER_SIZE
(448-byte) buffer for a single SMB2_CREATE response. That buffer also
holds a 4-byte length field, which only leaves 444 bytes for the SMB2
body.

The AAPL response made this buffer too small. After 8f1b796ff113, a
request with AAPL response contexts may need at least 456 bytes. In
the 456-byte case, create_aapl_rsp_buf() is appended last, clears 128
bytes, and writes 12 bytes past the allocation.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0
    Write of size 128 at addr ffff88800370954c by task kworker/0:0/9
    ...
    create_aapl_rsp_buf+0x31/0x6e0
    smb2_open+0x58f9/0xef10
    ...
    smb2_allocate_rsp_buf+0x19d/0x370
    ...
    The buggy address is located 332 bytes inside of
     allocated 448-byte region [ffff888003709400, ffff8880037095c0)

Reserve enough space for any fixed CREATE response KSMBD can build.
Store the required allocation size in the per-dialect values table.
This keeps the small buffer for other commands and avoids using the max
transaction buffer for every CREATE.

Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

---

Changes in v2:
- This version implements the maintainer suggestion to precompute the sizes
  for each SMB dialect.

v1: https://lore.kernel.org/all/20260919165828.2230488-2-Jeremy.Jean@oss.cyber.gouv.fr/

 fs/smb/common/smbglob.h |  1 +
 fs/smb/server/smb2ops.c | 33 +++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  6 +++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index d9c7e6e7af29..fdf840888062 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -40,6 +40,7 @@ struct smb_version_values {
 	size_t		create_disk_id_size;
 	size_t		create_posix_size;
 	size_t		create_aapl_size;
+	size_t		create_rsp_size;
 };
 
 static inline unsigned int get_rfc1002_len(void *buf)
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 4578291fb172..747276b171bd 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -13,6 +13,35 @@
 #include "server.h"
 #include "stats.h"
 
+/*
+ * work->response_sz includes the RFC1002 length field while smb_get_msg()
+ * skips over it. Durable v1 and v2 response contexts are mutually exclusive,
+ * and POSIX CREATE contexts are only negotiated for SMB3.1.1.
+ */
+#define SMB2_CREATE_RSP_SIZE(lease_size, durable_size)			\
+	(sizeof(__be32) + offsetof(struct smb2_create_rsp, Buffer) +	\
+	 (lease_size) + (durable_size) +				\
+	 sizeof(struct create_mxac_rsp) +				\
+	 sizeof(struct create_disk_id_rsp) +				\
+	 AAPL_RSP_MAX_SIZE)
+
+#define SMB21_CREATE_RSP_SIZE						\
+	SMB2_CREATE_RSP_SIZE(sizeof(struct create_lease),		\
+			     sizeof(struct create_durable_rsp))
+
+#define SMB3_CREATE_DURABLE_RSP_SIZE					\
+	((sizeof(struct create_durable_rsp) >				\
+	  sizeof(struct create_durable_rsp_v2)) ?			\
+	 sizeof(struct create_durable_rsp) :				\
+	 sizeof(struct create_durable_rsp_v2))
+
+#define SMB3_CREATE_RSP_SIZE						\
+	SMB2_CREATE_RSP_SIZE(sizeof(struct create_lease_v2),		\
+			     SMB3_CREATE_DURABLE_RSP_SIZE)
+
+#define SMB311_CREATE_RSP_SIZE						\
+	(SMB3_CREATE_RSP_SIZE + sizeof(struct create_posix_rsp))
+
 static struct smb_version_values smb21_server_values = {
 	.version_string = SMB21_VERSION_STRING,
 	.protocol_id = SMB21_PROT_ID,
@@ -38,6 +67,7 @@ static struct smb_version_values smb21_server_values = {
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB21_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb30_server_values = {
@@ -66,6 +96,7 @@ static struct smb_version_values smb30_server_values = {
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB3_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb302_server_values = {
@@ -94,6 +125,7 @@ static struct smb_version_values smb302_server_values = {
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB3_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb311_server_values = {
@@ -122,6 +154,7 @@ static struct smb_version_values smb311_server_values = {
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB311_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_ops smb2_0_server_ops = {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..15b1b3789d9f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -860,14 +860,18 @@ static void smb2_update_lock_sequence(struct ksmbd_work *work,
 int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 {
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+	struct smb_version_values *vals = work->conn->vals;
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
-	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
+	size_t large_sz = small_sz + vals->max_trans_size;
 	size_t sz = small_sz;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
 		sz = large_sz;
 
+	if (cmd == SMB2_CREATE_HE)
+		sz = max_t(size_t, sz, vals->create_rsp_size);
+
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
-- 
2.47.3
