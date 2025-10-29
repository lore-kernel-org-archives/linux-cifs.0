Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45852D0602
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744416; cv=none; b=LKUbP5tZ8EMtWt/emjXCfS7SXNzqNSLLhJjuhh0nhVKcTFIVqhHLBtoL4KeSFTt39oIu+PvPMUl1oG2JYI6VEQZt+LYti5X4j1EKsYDe+X/wQPcdpEFCqtiaaFbH/FWl1NQ/FjGf0uUZIAW79TiiKZUdzYW1YD009FfVJ9Vp/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744416; c=relaxed/simple;
	bh=QDIg9bmv7uujXk3FUU0zEmpsI86cxZNWP6bH7fN2Hsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7s5MxmmlWHEMwBmcDNBEhFF1AHi9UzSpGhLYpl7R5g8Zb78pjGGWIvb+acvLyLKdGXrMK1AYiJxn8UacCiNQsYpFpoJfekBaaCZ9bHZOYNUVBGr9HgogTWZ8ODyCKknfjsZCDbiDmYQAjxUZ0LSHpJTI1cECCHxXY2yHAGWaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Aav841KC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Aav841KC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=kbWRn3NZtYG7kstJCa+SOMSM8xj3XMv/xo19iF3NNSI=; b=Aav841KCdoHf0SMhEWVCCTFbcv
	/FxxLeD+AauiRZynceVl9VMeW4TmVJ9LqYncpcr7p9Ya6paX/tKX27odbdvV/D8wEzt6+do9DrnTZ
	soASsL69sShbL5al1K72insopW7A642C8bK32vU2Y0ugRJVPUDZXL1CJ6vt40fYXM2nu1haz7Ivjg
	udyHwPvRlYZvHmnGYTv+DVK8ocXqYbh2kORdjWpuIBO7WEmCyfnpmadhCMo3IC8YS6L65FPkL6Rzz
	XVoa4uSoB4feu4CW7b72QrRzhwKqyay7APu9W42gZlaOki3Vrn8GS2L3xBklYD6mYkkpHw+VXdzFI
	9jLKQA64m3dwqG7U1GVLWZFOs7iUbc7n3FgMWyG3q/yWIwbiE9X5SP5CgKedsEPNGG/wgocVWkE6f
	gpRfYdtQ/X3R6PJbORc9wB9IjlBNfcNisyAhkpsdOWVYL46s639WJlccUZtkTYs6u1ltnh/8mX0mI
	xfYEuMWb1Y8QqC0QbtnJkwO0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6CR-00Bbqd-21;
	Wed, 29 Oct 2025 13:26:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 044/127] smb: smbdirect: introduce smbdirect_mr_io_fill_buffer_descriptor()
Date: Wed, 29 Oct 2025 14:20:22 +0100
Message-ID: <2818d5b62f38b73c009db4a7e2066e77bca0c7ff.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 fs/smb/common/smbdirect/smbdirect_mr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index 5fd6a853e656..bca58eee783b 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -453,6 +453,24 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		mutex_unlock(&mr->mutex);
 	return NULL;
 }
+
+__maybe_unused /* this is temporary while this file is included in orders */
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

