Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C0B27E7F0
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362460; cv=none; b=lsSkSLnqJhm5xSIOu9MVn63SwGqjUDLbol2Ug6IkpWesACrXRl3rkz/zRH1va4YOhOPMfCpOhdF/V0Q2+xTZGLYDwfHMP5V6ATVi/EfNRKmSqaSMehEX/eIn0q9NldtOPambnOIalJtdOwXOtZQxk8dYHzBZLvChZKmWVsJmDAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362460; c=relaxed/simple;
	bh=QCw/r0EWNAzTRNODoeoYIYRhfFAKt4B28dggmrWM0jw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IzEt9FB1i1k7plCukBoOwcitSMfmD9mGiNvKTKzQ4Q7+I1l2KcAoo0QSOU9tULBcQxCMOUfwddxBlkCoJhHAxaVBoafp8lhbqZ1PYc6W5wSx0EIiTnQdlJ0Uhyqn2VYHYvM6sfu13ZHOW3inC6670ntaIl/8e1vNGh/uDy+6CgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dD5XvBUG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dD5XvBUG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=A0sz/wSnL8vgyujCYLdDA/1o5BvZVWKBoa64HwMHLU4=; b=dD5XvBUGM2WEJC/gRgFF6sN/n4
	S5+RjB6GQ8akFIAdCWUMR87ZXaIHGxO61GjYD7NL3eGRkLc0MXok++fnSRApHKhTKEVf+OguIr2ts
	OaPsDeNmApKN0rDpxipqYVG8OoLyRU9jiDFIaQzJEa4EC2dZ5TDrBbiLzLU1YPDx9Vze3/A9wy3wF
	uTBIKup/nJkmIW7GQ3GrhcFr1F7EOZvUv+r0prOhCvbM991aLbViRvSB/s+IEybIYT0Ol0vBKy/kH
	wTGH0rXg/QEJNJC/IcbkGdhlBzvsA4fn4UXzt7PnlY7Amh1LGnlF8TdLu+MpzmL58c4v5aUiogtxP
	5mEK0NEDlIU+sc0nWl9f+B2Oyq9mtjTOYwObUXKpp5+sulAqc3YOfxzZbFcLnfsEjrZ4zv9W09dtF
	9l2fLqKl9BvXWfAxnhGqtEcofvroetNIbjoxbvvmMSzV1FghCXGhH9GNMa1ATlsZPRm3au1fKkOGm
	DpPFbiP5J5vBpg4XI7932eqX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJwwP-007Vm3-27;
	Tue, 27 May 2025 16:14:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH 3/5] smb: common: add smb_direct_buffer_descriptor_v1
Date: Tue, 27 May 2025 18:13:00 +0200
Message-Id: <fce4c4a11f8ed8f44637c1f0b1585bb2dad4c5f4.1748362221.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748362221.git.metze@samba.org>
References: <cover.1748362221.git.metze@samba.org>
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
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smb_direct/smb_direct_pdu.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/common/smb_direct/smb_direct_pdu.h b/fs/smb/common/smb_direct/smb_direct_pdu.h
index ab73cd8f807a..9a0b1762b828 100644
--- a/fs/smb/common/smb_direct/smb_direct_pdu.h
+++ b/fs/smb/common/smb_direct/smb_direct_pdu.h
@@ -48,4 +48,11 @@ struct smb_direct_data_transfer {
 	__u8 buffer[];
 } __packed;
 
+/* SMB DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
+struct smb_direct_buffer_descriptor_v1 {
+	__le64 offset;
+	__le32 token;
+	__le32 length;
+} __packed;
+
 #endif /* __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_PDU_H__ */
-- 
2.34.1

