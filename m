Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3301A283FCB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154609; cv=none; b=IadBVJHTwwxTD96Y6asKzmZK/H5ce7YeAu75R0/xSDg81kBOvzgPBcUa9g6h6X9uRlTn83W4MoZaITDzjMbi0Bg3YXl/lRcYTK/pHFoRTBO7Ur3RaDGsQY9MGaRBcuW5i6/hW1TPyXs+CI/Ypvdu1exbrDrUHB0AcAVDM7C2RBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154609; c=relaxed/simple;
	bh=QI0dWSfzxMrzOcRDMEmjjy/sDG3vIU9QCdgPluVgItA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpLc/hOnew5EEVRoLsSTRvXJK+FJWaA8AvtAjZP5nh+IHNQbIzwr7MKtr0PMpdBj0Amtr1ElEwqjsl+D+xe43hkzPukdeFhzeJYeZDYmGzgbxkTa2d8d6AKJaRAH72uk8jhx3gPSzYKwrfPGdayMhsNBqqSK+CAMahdy6TkYGJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PeBuhJ/a; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PeBuhJ/a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=e2QtsBQivXyb9VR8yXdGyIyFQL8dQvU+87VcXRmP61Y=; b=PeBuhJ/av4P8/IJYyJGt8gzly5
	t43WO25ZoInx7TmofVXm/qf/w3KyabiF+5DWsqO8Qb3fO5MRbAMjENDpigIL11SaNX54iHwGf8dL/
	58qIY5/6OY3/mIMhdBJW8lIX/IWQywhxLiIsX9awTw8OJ2UK61nC+olpuRSKx+6f8FUIoq1QCKUYP
	Bsf6cLhm5Mfz27vjm1ATI8v0IfQ3fsvK6WFZZU6SydIU+o8U5GpJOA2Dihfhn5ik1qpiTqrpgMRWM
	NFqJ/4d+0lLd4BvIwxS2NZVInf/8WrUO59BpxcsGelME8fW6T3bjDBaSssACVbJs3hFG8mNdQletE
	/roYX2eZl2SEvniUyUK7AyLlg/d1ek86TOI+4hiaHdzTqJpPk/OCw1tk/6/01tKvMOYoTs7MnYuiX
	bTA/HFaBHV1FVHp03b0LABZu/7zDzqxmUagoIyVlPX2GsDaiQM0sJAGYjiDv5xMDjqj7P753BLRyH
	5IhM0+OQDlvH4lyWK5VZAt53;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2A-000jSq-0U;
	Mon, 25 Aug 2025 20:43:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 008/142] smb: smbdirect: introduce struct smbdirect_rw_io
Date: Mon, 25 Aug 2025 22:39:29 +0200
Message-ID: <b1cff4d04be83c9ac89f97612ade9e1c39f12272.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by the server in order to manage
RDMA reads and writes.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 001193799e16..ff7b9f20b1ac 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -6,6 +6,8 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
 #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
 
+#include <rdma/rw.h>
+
 enum smbdirect_socket_status {
 	SMBDIRECT_SOCKET_CREATED,
 	SMBDIRECT_SOCKET_CONNECTING,
@@ -240,4 +242,18 @@ struct smbdirect_recv_io {
 	u8 packet[];
 };
 
+struct smbdirect_rw_io {
+	struct smbdirect_socket *socket;
+	struct ib_cqe cqe;
+
+	struct list_head list;
+
+	int error;
+	struct completion *completion;
+
+	struct rdma_rw_ctx rdma_ctx;
+	struct sg_table sgt;
+	struct scatterlist sg_list[];
+};
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

