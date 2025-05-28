Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75F3234
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448152; cv=none; b=SC7LBsw+B85cA3ceSN+rGnvPk6yDDWHsbEV4kKzRyDRMWFqnP1qwGhv+j6XpqpFg7aY2k/a56qrCX7gB2sRo0TZRRsPPWvEaHvmsDpnAM5t4ghIhlLVFKD8caEVNOrEjNC36on69XOKS7FIng313NKip06KX5xWM73CAQnjaRS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448152; c=relaxed/simple;
	bh=8gesbX8MvwBs3Glz4F0hONKOqQNAXeevkVyRL60Nrzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sNDiKRxyR0xlelHPXK0IiraiV7JMkYNpsCjjEXSzbDyy6c1NAk1u+ArNwx5cebXgrag+7eR9oI4UuftZqry/XikGt1tcjr2zjiaivDqMmw1K9ShzB14gcbAp8LIYq/2i65qhFQIGYrJ4cI+Ri/L5zuw0AGuTzXjqGNJeZLp2UpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Wp770G36; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Wp770G36"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=z1fJ12rWt3TQejq1CmnFHtLiSd925QY4ykMI/MKfrjw=; b=Wp770G36lHHYEKtURZV50/XLmd
	TsVVH1Xoto5ajRXK+D5VBagex7hbxku7+ionQPovpk0bFXfrxr11i6GG7qMEtzqOLs4wKAHyM1KV4
	Xym+M2Y4ZEG3Pwcj5XlGT9JxD0jU8hzHMslTQlY23gePI7CQUv29zcWk6/huI2pMvGeEU0WbIremv
	ArvZ3+cFq4nU7KD5oSiwkHpSCX8qFfYuj2cTny6zp+l5ROJHHMmlPO1KKVF3/E3yyMW+aMGuRzxif
	Xct760EKN76r45awkQsfF7g3AnBJ9qj7T5IB7mvwkmLnPI8td/ALVh16RxhhrI76yh7XtmDbeg1i9
	ZxMwnbHo85TWPKgIFgkRHknGvcBDRUfqnlR4djImyvfNKV9ABfR2Oik9kvT1QbuTMsyyJRxQntKr5
	2itrSaEcDr8jFWa92DoCsM7mlIizGG5GpFJVXTfh9HJvzppqJYo4bvGAf26fT8BZ8l7KZ/4biVazM
	vDOfercPY5LM4GELGih3nl1d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJEZ-007hIg-03;
	Wed, 28 May 2025 16:02:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 04/12] smb: smbdirect: add smbdirect.h with public structures
Date: Wed, 28 May 2025 18:01:33 +0200
Message-Id: <87a6dc3d48366845b646651b80e9687dfc9c7236.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be used in client and server in the next commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
CC: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect.h

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
new file mode 100644
index 000000000000..eedbdf0d0433
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (C) 2018, LG Electronics.
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+
+/* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
+struct smbdirect_buffer_descriptor_v1 {
+	__le64 offset;
+	__le32 token;
+	__le32 length;
+} __packed;
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__ */
-- 
2.34.1

