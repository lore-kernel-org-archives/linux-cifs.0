Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA69E2EC083
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792265; cv=none; b=lOrFzfYTjUJgcZ8wbxW5BRL+SK/jRfIlMwBkADF+I7XBVDHJ0+rRceafw5I3jxLeXULryOdtEwe8/bJc2jwhYVNIyOswu9nifDytwWnUd+IcDbUH3+1Mxm6wQTzZ1MTf5jXCaG3KraByKdy+2pXGpe9NkBwlLBc3Ie8KAKpMQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792265; c=relaxed/simple;
	bh=Eh/rbqGWSFm0fWgThIuEqtG90MGChnSfzXpitgjjNCo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WxaeP1RwX12o5dCk1+/QNcgeHVhXi78hxzrpuEW1vUYLbz0i3RMplNSFiIo/9eZNrSIBBfCDfHIvXfuOU+3DpP6/3w4uX5nzj8pdJs7e9E+EfIAzgats6De8Ut9hK+10TCUmNPTl7eQIJoY2IZ6yuUdc/QUpClTiYrQ6kVy9IB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8UaaSwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8UaaSwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F4B1F000E9;
	Thu, 18 Jun 2026 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792264;
	bh=sA42sC5YctujQbdtOZgBj1ote3Edq9KG8hb/o4ee6h8=;
	h=From:To:Cc:Subject:Date;
	b=b8UaaSwJ3O61QV7dyqFoZ3mW4aiYBVvHSI+0wJHtdWNFtr2+LfyCRXQ0nRM85AZdv
	 Q0VLKeKN8Ze24CxrT/H7hxd/Lr3XkVbZDrZFP4Mr1ni23pRgSgKTIUxUbBaM77KZen
	 JfLVeOT60LYkx69Vfm026zeTkn129sugMkUCH3cpzhxml8X2KaIPziiQyUMmeXLNab
	 cfCn/6rHWoROjZP4p7oEYRkH1jgOItKzQiy5/EedwFwpS2GFAGfULdWaVS4Bl5rPFm
	 A/Jtv0spuE9Jgj6+gz7qREVkfmrlRsRtiY6u7wrcY+sPTcHDgOI1QW2gKZlbhTSS4/
	 OBiL95zciS+8g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 01/14] ksmbd: validate SMB2 lease create contexts
Date: Thu, 18 Jun 2026 23:17:26 +0900
Message-Id: <20260618141739.9029-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate SMB2 lease context lengths, requested lease state bits, and v2
flags before using the context. Return errors via ERR_PTR so CREATE can
distinguish a missing lease context from a malformed one.

Also ignore lease v2 contexts for SMB 2.1, where they are not valid.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 33 ++++++++++++++++++++++++++++-----
 fs/smb/server/smb2pdu.c | 24 +++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 60e7e821c245..5c6c0550a477 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/err.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -19,6 +20,20 @@
 static LIST_HEAD(lease_table_list);
 static DEFINE_RWLOCK(lease_list_lock);
 
+#define SMB2_LEASE_STATE_MASK_LE	(SMB2_LEASE_READ_CACHING_LE | \
+					 SMB2_LEASE_HANDLE_CACHING_LE | \
+					 SMB2_LEASE_WRITE_CACHING_LE)
+
+static bool lease_state_valid(__le32 state)
+{
+	return !(state & ~SMB2_LEASE_STATE_MASK_LE);
+}
+
+static bool lease_v2_flags_valid(__le32 flags)
+{
+	return !(flags & ~SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE);
+}
+
 /**
  * alloc_opinfo() - allocate a new opinfo object for oplock info
  * @work:	smb work
@@ -1537,12 +1552,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	struct lease_ctx_info *lreq;
 
 	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
-	if (IS_ERR_OR_NULL(cc))
+	if (IS_ERR(cc))
+		return ERR_CAST(cc);
+	if (!cc)
 		return NULL;
 
 	lreq = kzalloc_obj(struct lease_ctx_info, KSMBD_DEFAULT_GFP);
 	if (!lreq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
@@ -1556,11 +1573,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
+		if (!lease_state_valid(lreq->req_state) ||
+		    !lease_v2_flags_valid(lreq->flags))
+			goto err_out;
 		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
 			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
 			       SMB2_LEASE_KEY_SIZE);
 		lreq->version = 2;
-	} else {
+	} else if (sizeof(struct lease_context) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease *lc = (struct create_lease *)cc;
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
@@ -1571,12 +1591,15 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->duration = lc->lcontext.LeaseDuration;
+		if (!lease_state_valid(lreq->req_state))
+			goto err_out;
 		lreq->version = 1;
-	}
+	} else
+		goto err_out;
 	return lreq;
 err_out:
 	kfree(lreq);
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 653f0410cfcb..85fafd602740 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3108,6 +3108,17 @@ int smb2_open(struct ksmbd_work *work)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
 	    req->CreateContextsOffset) {
 		lc = parse_lease_state(req);
+		if (IS_ERR(lc)) {
+			rc = PTR_ERR(lc);
+			lc = NULL;
+			goto err_out2;
+		}
+		if (lc && lc->version == 2 && conn->dialect < SMB30_PROT_ID) {
+			kfree(lc);
+			lc = NULL;
+			if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+				req_op_level = SMB2_OPLOCK_LEVEL_NONE;
+		}
 		rc = parse_durable_handle_context(work, req, lc, &dh_info);
 		if (rc) {
 			ksmbd_debug(SMB, "error parsing durable handle context\n");
@@ -3139,8 +3150,19 @@ int smb2_open(struct ksmbd_work *work)
 
 			goto reconnected_fp;
 		}
-	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
 		lc = parse_lease_state(req);
+		if (IS_ERR(lc)) {
+			rc = PTR_ERR(lc);
+			lc = NULL;
+			goto err_out2;
+		}
+		if (lc && lc->version == 2 && conn->dialect < SMB30_PROT_ID) {
+			kfree(lc);
+			lc = NULL;
+			req_op_level = SMB2_OPLOCK_LEVEL_NONE;
+		}
+	}
 
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
-- 
2.25.1

