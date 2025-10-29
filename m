Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48334B41E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744163; cv=none; b=PliT9SsWbFGobcVbT/egbz19xrjzrKO3GWJIRMTQKsgveZGln5rAvx/5hijAO7ZS2er9S0w366YxTAx8/PF6ouMkwTruya11JdMkjjhQZkTrerA7TqgGwWovvi8Q23VqSxnCNgfT88cIw2m07VPC9vPvDQLM3ZCusgqWsRjGFLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744163; c=relaxed/simple;
	bh=Gcx3rikqgyxGmdAj/HNZMFehBrqwHe8M4kfOXvQxzng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaddfEcLSn9koDRuS0vetIsy2Xk4QNkLV13GRVc6dN8MLDFf1DTudPh6NnWaOKeQ/ulYrki19iIj8Z/ENxzJkbhC3T4mXZCmLLcpDY7w6B6mv5Z8jWCaKqMNVfHwEAI9hzQnERW/O435Y37ULYJ4csNgpQFWbd1tXfSI+E7dAfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=thTlsYvx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="thTlsYvx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=p4FLya2lUbbWJJUMa9Dm75Mm1rxCNDAGhrXanJ7pNlQ=; b=thTlsYvx5Hl9JuEzrMwSAhln0k
	7TnZPz/u19Huw9tiRj92SeQBc74z3zqsUkurJiSAwQox3PWkA56P4O2pDSOvh3K/G0wkOP9y1xYqQ
	iVLZdKIhlM2arKXxYIT06AKwkfueFJnuyotwpV1145UZOfLDRiPSIjqs6aoBzDoMg3OguCp5fmw1d
	LCAXy489FHAjOzk2YfOeNF2rixNWeulDxVG8H/B1dm+1NAO1Xrx8bEP0nQuDZsM0wYdx/HTANuWpf
	vrL/Xcl2dOppFs9S/rQ3pm7wge8KB+fjfdzg7qN7QVNDcdYliDSGYnFmB9Q/ZnJQ7yjEhjOJPxNd+
	LgcfJQZsnlPV1w/ds5EJ5xTUGK5f9ILnump3iCmO8WPARMMNUp1HPa/YG0AlTQHNIKFy0f0NjdnWk
	lKXtMlTxTLIRm6WLeS+5CNjxTTZyNF0Tw6YEC1LnCJ7sPJ3yv1Zq1M1zDQaRPXOGvQymEoH4ztoX+
	jbqPqStLAb9MxWc5sCKtR7gr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68N-00BbES-1B;
	Wed, 29 Oct 2025 13:22:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 001/127] smb: smbdirect: let smbdirect.h include #include <linux/types.h>
Date: Wed, 29 Oct 2025 14:19:39 +0100
Message-ID: <fa8747cfebde4621fc47b8a8b218961b94120db2.1761742839.git.metze@samba.org>
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

This will make it easier to use.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index 05cc6a9d0ccd..821a34c4cc47 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -7,6 +7,8 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
 #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
 
+#include <linux/types.h>
+
 /* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
 struct smbdirect_buffer_descriptor_v1 {
 	__le64 offset;
-- 
2.43.0

