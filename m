Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D83C264A90;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=DL47cUWyQVHOPejqo45nB/bis+WfeKYOIGdVYyBYwPsw928FqT5rk604mHmdza7Ybb1FMRntuL3ePPSBnJQ4hdxZlsxpfc3bc5ZKvIA0Y/FQwX99uwfoMm1JJ3ur7NQmG+D2VB5cXDHOA+8rM7okEpaQO7jxUBj8rvfa8NLrH9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=pjmshuuowk3VsHfdSRy9TJR/wkRXjxdcCJg5ne0gJxY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pF97BxTJEUNzNCn/t66Ypf3F22bFslmqmQQhzJM7nRUKoYCFB6I2VCUp9/oM+yoIFQ55hSwQQGq2kZZOnUmoJ2/CSQOIPLS8CSCJH8Qh/v7BldTlAB387NJhGfS2FMn5jcCK4MR7mGVPeFniwAni4QHARnu5bclMTguPBrTb5C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHRTlVg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHRTlVg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DCC4CEF5;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=pjmshuuowk3VsHfdSRy9TJR/wkRXjxdcCJg5ne0gJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHRTlVg6RbMsdGjLyMPFeGaHSsFQu4tqzS6VxSyDbhUzyYut53oq3zMemL5FUdmOz
	 XlCVMEG9Y2TUz1krMrxt2aOwlXoOUEGWf3/e7x0DVoSAcOAZ2oD1dE1C2kUwSylpOa
	 cTPwq9iVFdk98boHbtxFVTA9IWNbahwDMNs2JxUQlaTjfqbwug87BomaiZTcRuk5bC
	 Sh2mjZ3k7nVLf0nF2VOvHoGJEsUTxkg4UoEsoI81JDfZNY+AzwAXaFu1zqxMk63tQE
	 Jpb9J4/fb+JROdIgLhcUIvIPSeQXeSTBRxSegVD+gTJhwiysLJmDPClN0d9M2xGq0y
	 ynUKdAuDwIlDQ==
Received: by pali.im (Postfix)
	id 24DCC198B; Sun, 31 Aug 2025 14:36:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/35] cifs: Use NT_STATUS_DELETE_PENDING for filling fi.DeletePending in cifs_query_path_info()
Date: Sun, 31 Aug 2025 14:35:44 +0200
Message-Id: <20250831123602.14037-18-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function CIFSSMBQPathInfo() returns NT_STATUS_DELETE_PENDING status code
when the path is in the delete pending state. So use this information when
filling the fi.DeletePending member in cifs_query_path_info() function.

Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY".

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 6 ++++++
 fs/smb/client/smb1ops.c | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 6dabff82f6ae..2427752bc224 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -35,6 +35,7 @@
 #include "cifs_debug.h"
 #include "fscache.h"
 #include "smbdirect.h"
+#include "nterr.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
@@ -3902,6 +3903,11 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		/* Fill at least the DeletePending for -EBUSY error code */
+		if (rc == -EBUSY && data)
+			data->DeletePending =
+			  (pSMBr->hdr.Flags2 & SMBFLG2_ERR_STATUS) &&
+			  pSMBr->hdr.Status.CifsError == cpu_to_le32(NT_STATUS_DELETE_PENDING);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 176bc2a211bf..618470db6444 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -628,7 +628,11 @@ static int cifs_query_path_info(const unsigned int xid,
 				fi.EASize = di->EaSize;
 			}
 			fi.NumberOfLinks = cpu_to_le32(1);
-			fi.DeletePending = 0;
+			/*
+			 * Do not change fi.DeletePending as it is set by the above
+			 * CIFSSMBQPathInfo() call even on error. By default it is
+			 * initialized to zero (false).
+			 */
 			fi.Directory = !!(le32_to_cpu(fi.Attributes) & ATTR_DIRECTORY);
 			cifs_buf_release(search_info.ntwrk_buf_start);
 		} else if (!full_path[0]) {
-- 
2.20.1

