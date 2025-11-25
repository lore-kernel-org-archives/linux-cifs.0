Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7802832A3CA
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093704; cv=none; b=cVdaHmpFbtM/DREmakANRBQ+d+wj2wOaeSCVHWogNdc7lq7NZdmVNoUY5t+BRVt4GZ03YdzABJ7MiWcHA/4Y6MUbUr2c0hdSTOWJocuT0XQrk0uwxY2dC9BNBcSx4PkhvS7Lr7Vfu2yy+xmH49XtoSst1HG848oeKFJ1TlH1aeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093704; c=relaxed/simple;
	bh=+zSrR88nKmFL/vrrHtch/wlE3B9qLzJ7uiPFnCQc34E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDNX5penyTyD8tpGA1zUTa7057oQWiFGA52beelzIrF3EuUI+1teRo/k0PI2exUWmo39TMELCQG4hqVdG//r24IrWmuetGo+mt0oPfRRS67wuXuMqTwT3szrmNe/XI8koOnH5M81yFDHtSB0oGfZvYd6i7TjM0fmuqfJ8fy4HlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QLQc2RbV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QLQc2RbV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=C+RrOWhyUMD4cWd8o/MVGl/xQ5DVKPMgqQ3I61Bhjko=; b=QLQc2RbVlr5mvle4Egh4eHSt8M
	S+if4MTiTmmEeTr1BjJopp++uDOZYsuvq5MAz4yTGPsEI0lkRc9cmVT3fLSiEYJDRFoFsFjmu0pxp
	mC2KaJBW1uttglXIU+PQ8dq4DDk0VgSontOWZtEVKIhluJ3oe79jGo2aOephmqOK04mn3C0xTQzv0
	vbG7+dkFmCC3UKHG5+9+InuCevhLcPPMBhdBUHyex7WclRgSY8brjRFounjJ9qkGSo9qZF2Dh5ISo
	NUyIV7TfwO3WeDzyZ+BZ0bf5uZLLpu8lGcjo9SwtIh7UyuBCb/OLrTKYCJNKsWMXQKuLY7Zd8j3co
	k7ZfQKupeKo4QVtqpfWrbsuaYj4ZrWp/Jt7i25Hak886XZT4wKS6XowOuYrXMrh87fXP5xIlHch6g
	fnG33URri6cJwQ2J5Q8G/cUolVsqQsvdKkbcyScsO2Tl1Stm51hOvPBw9sEXRgCOuV3sLRF8FZaZu
	RcFJSDHCzFgcsNXNwemgxsG0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxM6-00FdF9-21;
	Tue, 25 Nov 2025 18:01:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 047/145] smb: smbdirect: introduce smbdirect_mr_io_fill_buffer_descriptor()
Date: Tue, 25 Nov 2025 18:54:53 +0100
Message-ID: <fae71391832f804ad7f5b00b4adce11cd7f011ec.1764091285.git.metze@samba.org>
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

This will be used by the client instead of dereferencing
struct smbdirect_mr_io internals.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_mr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index 35dc2a6c9b89..3c2f653f70e8 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -452,6 +452,24 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		mutex_unlock(&mr->mutex);
 	return NULL;
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+						   struct smbdirect_buffer_descriptor_v1 *v1)
+{
+	mutex_lock(&mr->mutex);
+	if (mr->state == SMBDIRECT_MR_REGISTERED) {
+		v1->offset = cpu_to_le64(mr->mr->iova);
+		v1->token = cpu_to_le32(mr->mr->rkey);
+		v1->length = cpu_to_le32(mr->mr->length);
+	} else {
+		v1->offset = cpu_to_le64(U64_MAX);
+		v1->token = cpu_to_le32(U32_MAX);
+		v1->length = cpu_to_le32(U32_MAX);
+	}
+	mutex_unlock(&mr->mutex);
+}
+
 /*
  * Deregister a MR after I/O is done
  * This function may wait if remote invalidation is not used
-- 
2.43.0

