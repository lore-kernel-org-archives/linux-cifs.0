Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9C71EB195
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093625; cv=none; b=DzLkEdXxFHnrPdq0pFWMfgopZ72o5315SySRd9RAjsKtdp9AT5IO+jKvYpxycoDJvNug8PfksrhfmhPbb3hE+L8BYxRxcUISke+eT2APcgzTJAiKI1bL1HaqV5f0Z7NU7Wv3qaAwzTL8V7pee211FcZ1Xzy+RgR+zC1pIJQH2DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093625; c=relaxed/simple;
	bh=laoHhbXtp8ekeJce7WFBpGairpJ85Yw/DAC6oBvkaX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODQtAFMBJd4p1ww5NiFrmC7MK+CQ3dx2jLpSshbU+HS9mamuLdYUOrmWF8w5/ulXCRbgYL1aF4dYxZMxgYi4ixoMq8ASadC3+oPEEehqDihYyys8WmkD+ADUOoK2Uv3K6zA8kw/5ZLq+ShbcShu1Y0ekMR2k8cPU19CetqfBQ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FQRK04/q; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FQRK04/q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8Z83ugxk7/w7Jyf289f1HPC96gEJXNLJ0SamXqFnBx0=; b=FQRK04/q+iYFSbSCTb4IJELCmX
	GHPvLSGrigiF3o5aaXcm14VrmsLy/4WHEkQoQ2ZYUQl+PgTwguoflI6RZ4FGT4AzFg+hJdnXN4P95
	3NltXXNUOEZzm5dBWuvaf5lZn+HljW2HF3kVeNjymJ56lHgtV5yiBEkFHv3+IJjE/Ub8J+ycppdWL
	R8knfDtKTMjE9G4lZrJwPCvE+joGl3e1q6o2iz55eMoNIeVht5mNKFDIs8zU8bqLMo84TFa3zL9+W
	gubPsuCTWonLPyyfNp8U2jUyKsSlwhZVoKDhHL41idxxEkAFCqkx7hTxKfVjNuFtU9UvmDW8h65tG
	Rq7yq+CwHWnepLf7pUQZOU6+Hv1wTm+0tECQq/EHadFAaTRDPx3WYTkYRv6qtaDCrfp/GxSxh6OlI
	FW+4EdktJvpjYQb1xoIa1HuS65FswE0f7Du88DLki/IMCSgdpROMKcfx/folXSicORMCSTF9GAMqz
	9IQK+V0+uJl2oFRkUKv5i9Ut;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKq-00Fd36-2K;
	Tue, 25 Nov 2025 18:00:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 036/145] smb: smbdirect: define SMBDIRECT_MIN_{RECEIVE,FRAGMENTED}_SIZE
Date: Tue, 25 Nov 2025 18:54:42 +0100
Message-ID: <9f64e2053560db29c126f771c55dcebc0efcc330.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are specified in MS-SMBD...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_pdu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbdirect/smbdirect_pdu.h
index ae9fdb05ce23..7693ba337873 100644
--- a/fs/smb/common/smbdirect/smbdirect_pdu.h
+++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
@@ -8,6 +8,10 @@
 
 #define SMBDIRECT_V1 0x0100
 
+/* SMBD minimum receive size and fragmented sized defined in [MS-SMBD] */
+#define SMBDIRECT_MIN_RECEIVE_SIZE		128
+#define SMBDIRECT_MIN_FRAGMENTED_SIZE		131072
+
 /* SMBD negotiation request packet [MS-SMBD] 2.2.1 */
 struct smbdirect_negotiate_req {
 	__le16 min_version;
-- 
2.43.0

