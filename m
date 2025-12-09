Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3022260565
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242710; cv=none; b=L/cwa9bFDyK0ul6qUu9U3f8bjX3kaWaGQCKx7fE8HV5/iYZorZccKHiIHURwkYr4/06o2Gixbwt8Zmi5So42hcC4WpHUhV3b9ApulcIczgb4vN/Dk1ZLMV63mpx6X0n5voY6wlDVExwpukjbtRnhXCru/J7Y4tiaqHKUTQ88xh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242710; c=relaxed/simple;
	bh=2ua5iqWetEEbI5d3PquiHyKn7vk3jLhVmLbthFG29Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQOq5vhuhpRYWeC6Pp+aoxTuI4PzTQhOayAHdiYKkqhMLYovkpTSB2qBnaxq7r8sCod80KUMPD4uvsOq3Pc28MuQhIAxv8ZUKkxh/Jum4HDL44IQKq81MPM0bP15TPszc1m2w9U4W6jQj4XBy9u3O6FhmkR/nb+KlO1Syt0fFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2AiCHs7; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2AiCHs7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qcNPTzhYDchmM5ywIKdIWTrNCsGi+FD908aq+lueXTU=;
	b=O2AiCHs7GdsItPY9zAlnAe81oN9SXW8Esk/jYGo5mJXbum3sMW8V6FfLDOLZnrbVA5Qq9M
	HhYS1/x1U7mRC3w01wxvbewnR0k6tb15FwZBG8Pb5WdgMspmSVdjKkvasX07zVLup5cqkf
	AwrMRnTh8+cyAdemNkZrpMIY+w68wvs=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 01/13] smb: add documentation references for smb2 change notify definitions
Date: Tue,  9 Dec 2025 09:10:07 +0800
Message-ID: <20251209011020.3270989-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

To make it easier to locate the documentation during development.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 5 ++++-
 fs/smb/common/smb2pdu.h | 7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 49f35cb3cf2e..31c33e20b8ac 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1381,7 +1381,10 @@ typedef struct smb_com_transaction_change_notify_rsp {
 #define FILE_ACTION_REMOVED_STREAM	0x00000007
 #define FILE_ACTION_MODIFIED_STREAM	0x00000008
 
-/* response contains array of the following structures */
+/*
+ * response contains array of the following structures
+ * See MS-FSCC 2.7.1
+ */
 struct file_notify_information {
 	__le32 NextEntryOffset;
 	__le32 Action;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index f38c5739a9d2..7b954b607165 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1002,7 +1002,10 @@ struct smb2_set_info_rsp {
 #define FILE_NOTIFY_CHANGE_STREAM_SIZE		0x00000400
 #define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
 
-/* SMB2 Notify Action Flags */
+/*
+ * SMB2 Notify Action Flags
+ * See MS-FSCC 2.7.1
+ */
 #define FILE_ACTION_ADDED                       0x00000001
 #define FILE_ACTION_REMOVED                     0x00000002
 #define FILE_ACTION_MODIFIED                    0x00000003
@@ -1013,6 +1016,7 @@ struct smb2_set_info_rsp {
 #define FILE_ACTION_MODIFIED_STREAM             0x00000008
 #define FILE_ACTION_REMOVED_BY_DELETE           0x00000009
 
+/* See MS-SMB2 2.2.35 */
 struct smb2_change_notify_req {
 	struct smb2_hdr hdr;
 	__le16	StructureSize;
@@ -1024,6 +1028,7 @@ struct smb2_change_notify_req {
 	__u32	Reserved;
 } __packed;
 
+/* See MS-SMB2 2.2.36 */
 struct smb2_change_notify_rsp {
 	struct smb2_hdr hdr;
 	__le16	StructureSize;  /* Must be 9 */
-- 
2.43.0

