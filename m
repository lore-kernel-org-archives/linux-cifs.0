Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C2C370D5C;
	Tue,  8 Sep 2026 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883832; cv=none; b=d88b0Y20RUYmh/g9re+VcVgRsIRnU2ldfPdWVS0uwPvQ4KQjZoEM3O1sWgJktcWy9mTydyCObSSAuYRyWZs1Johe7o6cEwz//Lte/CzbE4Hbbyh7nDxVu5xmelo/h2/0eprH4Fj0Bn53LNyeEgIHTPw8gBSvL3hH2jdiIHM8D4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883832; c=relaxed/simple;
	bh=qi0fPEoLCVRhJkRBR3YgyHaEzlXYTHRy4gFr4uN8wDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PfJwoeLZWcSVyvBKas0T+VOeBwfEPJOX3WUPoGuzmEDLEkFuhGvHuUWZOAGI8DEW0OD7iPL/lhPHajsDq2QckqfvW45oQF2Lpgolt195YgWvfZa07e/kO2418WuV4QOHdFwwhqywD6mVOtKtd2IoGK0qlqk1cg4azfSRMsu8cMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=qz6naq4q; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="qz6naq4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788883829; x=1820419829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gT07//8pi39YPhU0M4JtMqjh04qHJg7gHrltbOItvAQ=;
  b=qz6naq4q4qD1+nD5PSjPPk2R/Qpubx+FldLh1ws/khHgXnTrTjJIPvoY
   m8vGstj4UjP0PO/p6XvdvZrklIXnxm979iiCkiXW2/2R3hvc3uz2qOY4s
   TXtwR0kjZ9zRaF2xTYzgbt5labwq/gBZq57EDCoiAb7YsytqXn6jsD4oP
   7ksYTke7p9O6hjUvDz4a7EmQJPr4POsDHt+jN/41U577Dtx68NLuhjBTI
   95zbS21Cu6Opf99aKAWZIIShmBpm2jVO3rZWR+xFMyTVE1A8WeH7WgUUw
   Cl90waqChQH74HEUHOB7RYlhtCY1+2Pev1yYBTc8ihGxRIUNgFU2XImlp
   A==;
X-CSE-ConnectionGUID: 3/LM5Fo4SNGjlW+DEopXWg==
X-CSE-MsgGUID: vfJckooeS3eWXjmphxaS/A==
X-IronPort-AV: E=Sophos;i="6.25,269,1779148800"; 
   d="scan'208";a="28166370"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 16:10:26 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:14095]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.196:2525] with esmtp (Farcaster)
 id 91eceba1-e4e6-4cfd-8ee7-59b2d65e8063; Tue, 8 Sep 2026 16:10:26 +0000 (UTC)
X-Farcaster-Flow-ID: 91eceba1-e4e6-4cfd-8ee7-59b2d65e8063
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 8 Sep 2026 16:10:26 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 8 Sep 2026 16:10:25 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <linux-cifs@vger.kernel.org>
CC: <linkinjeon@kernel.org>, <pc@manguebit.com>, <stable@vger.kernel.org>,
	Bjoern Doebel <doebel@amazon.de>
Subject: [PATCH v3 2/2] smb: client: fail DACL rewrite when the new DACL exceeds 64K
Date: Tue, 8 Sep 2026 16:10:01 +0000
Message-ID: <20260908161001.2603610-3-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260908161001.2603610-1-doebel@amazon.de>
References: <20260904125844.1803343-1-doebel@amazon.de>
 <20260908161001.2603610-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

replace_sids_and_copy_aces() and set_chmod_dacl() accumulate the size of
the DACL they build in a u16. That accumulator can wrap.

validate_dacl() caps num_aces at (dacl_size - sizeof(struct smb_acl)) /
20, i.e. 3276 for a maximally sized DACL, while each rewritten ACE can
grow to sizeof(struct smb_ace) (76 bytes) once its SID is replaced with
one carrying SID_MAX_SUB_AUTHORITIES sub-authorities. The worst case is
therefore sizeof(struct smb_acl) + 3276 * 76 = 248984 bytes, far beyond
what a u16 can hold. A wraparound is reached with 863 ACEs.

After the wraparound, ndacl_ptr->size becomes meaningless and the offset
will point anywhere in the ACE array. As a result, we will see
corruption of the DACL, which then gets sent to the server. This is not
an out-of-bounds write as the allocation now covers the worst-case
expansion, so writes will always go into the buffer.

Adjust the code to use a u32 internally and return -EOVERFLOW in the
overflow case. The operation must be refused, because a DACL can only
hold 2^16-1 bytes on the wire and larger DACLs cannot be represented.

set_chmod_dacl() carries the same pattern and is fixed the same way. It
only wraps once the source DACL comes within roughly 380 bytes of the
64K ceiling, but the failure mode is identical.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>

---
v3:
- New patch, following Namjae Jeon's review question on v2 about whether
  replace_sids_and_copy_aces() has a similar overflow
---
 fs/smb/client/cifsacl.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 2d785a3039585..7c3c06cd5db3a 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1081,13 +1081,13 @@ unsigned int setup_special_user_owner_ACE(struct smb_ace *pntace)
 static void populate_new_aces(char *nacl_base,
 		struct smb_sid *pownersid,
 		struct smb_sid *pgrpsid,
-		__u64 *pnmode, u16 *pnum_aces, u16 *pnsize,
+		__u64 *pnmode, u16 *pnum_aces, u32 *pnsize,
 		bool modefromsid,
 		bool posix)
 {
 	__u64 nmode;
 	u16 num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	__u64 user_mode;
 	__u64 group_mode;
 	__u64 other_mode;
@@ -1186,17 +1186,17 @@ static void populate_new_aces(char *nacl_base,
 	*pnsize = nsize;
 }
 
-static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
-		struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
-		int *aclflag)
+static int replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
+				      struct smb_sid *pownersid, struct smb_sid *pgrpsid,
+				      struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
+				      int *aclflag, u16 *pnsize)
 {
 	int i;
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u16 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u16 ace_size = 0;
@@ -1225,9 +1225,12 @@ static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *p
 
 		size += le16_to_cpu(pntace->size);
 		nsize += ace_size;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 	}
 
-	return nsize;
+	*pnsize = nsize;
+	return 0;
 }
 
 static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
@@ -1239,7 +1242,7 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u16 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u16 num_aces = 0;
@@ -1290,6 +1293,8 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 
 		nsize += cifs_copy_ace(pnntace, pntace, NULL);
 		num_aces++;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 
 next_ace:
 		size += le16_to_cpu(pntace->size);
@@ -1306,6 +1311,10 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	}
 
 finalize_dacl:
+	/* The DACL size field is 16-bit on the wire, see MS-DTYP 2.4.5 */
+	if (nsize > U16_MAX)
+		return -EOVERFLOW;
+
 	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(nsize);
 
@@ -1451,6 +1460,8 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 
 		rc = set_chmod_dacl(dacl_ptr, ndacl_ptr, owner_sid_ptr, group_sid_ptr,
 				    pnmode, mode_from_sid, posix);
+		if (rc)
+			return rc;
 
 		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
 		/* copy the non-dacl portion of secdesc */
@@ -1526,10 +1537,12 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 
 		if (dacloffset) {
 			/* Replace ACEs for old owner with new one */
-			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
-					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr,
-					aclflag);
+			rc = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
+							owner_sid_ptr, group_sid_ptr,
+							nowner_sid_ptr, ngroup_sid_ptr,
+							aclflag, &size);
+			if (rc)
+				goto chown_chgrp_exit;
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 
-- 
2.50.1

