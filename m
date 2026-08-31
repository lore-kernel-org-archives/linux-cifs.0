Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7D14A64EB;
	Mon, 31 Aug 2026 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183885; cv=none; b=GitE14Z+m203aG+UnmivFVb6pycEkrQWI1+W1/YyqatMfVlopaRy8szQxTGgsYxn2dmqwx0ruDVOH1QIVGHt4WCyzVbkJX3Leicw4lLUoaBo6yFE47BfevzE5VTYCb9ImtABboI89cxjbxI6JmdaCRKDulvMeijH+V2dDofz8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183885; c=relaxed/simple;
	bh=YUZugaAsWqx6aa6CcJAXfugAXTo46g+3sjtXYned2E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ov3rft7FapZj38RiUyyc6AxSLDz6CXsroxNANHItW6bJaG6MMjvLZ2YxnamwlPCusXe/qIQqzdRczwrvYents8g61k5emeYi5HxCT5lZMNclrbExuTiMAEUeACr7aF1KJZ4thBgEhhSPd9Reux8Q5EHHIrG27sg3iEUr9mwAgnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nv4YvQjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nv4YvQjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3971F00ADB;
	Mon, 31 Aug 2026 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183883;
	bh=Hju5wkNW5wtBAdP5g5EuihPdZez0HyquzrgTkqB/bAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nv4YvQjDG1ks6qhtsgqGSpJrwNUrW4QCcQOtW0ES17AbtMXxjx5JavenkoD7VGJL8
	 P9DJlR/KAyv1USnjVPI7jWzC2Bbmy7Qs5xSOfBYlm3cMohxfGTLwrW3XA1xTbwojoF
	 Ee0zOVNwb/tzIpU0S7aW7dTi06JX7isav6iY3nGC4Jb1VW2Y0wlGvC6Qu7pNXukhJx
	 Hwo+mjWMuSn7bC9xQ0KfMOzJ92DhRZI3+ysE1cZw32MPQGgaVW4/65oDm7Ce/xxo3D
	 g30Nk/ZiSi7igaYee8Xorw5gewp+w3uQ3avFVfF/ijKheDsi8cQUKsdftdiU8yWIP4
	 ngqSh8EKjbPww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: validate SMB2 lease create contexts
Date: Mon, 31 Aug 2026 09:26:28 -0400
Message-ID: <20260831133314.4125787-360-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b69be2c58615950ee7353b61a21acdf8508c0cbb ]

Validate SMB2 lease context lengths, requested lease state bits, and v2
flags before using the context. Return errors via ERR_PTR so CREATE can
distinguish a missing lease context from a malformed one.

Also ignore lease v2 contexts for SMB 2.1, where they are not valid.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log --grep` searches finished. They confirm the
commit **is not in this tree**:

- `--grep="validate SMB2 lease"` — no matches
- `--grep="lease create context"` — only `bb05367a66a99` (“set v2 lease
  version on lease upgrade”), not the validation patch

That lines up with the earlier analysis: the buggy `parse_lease_state()`
code is present in **6.18.44**, and the fix exists only on Namjae Jeon’s
ksmbd fork (`e9d6231`), not in kernel.org git here.

**Verdict remains YES** for backport to this tree.

 fs/smb/server/oplock.c  | 33 ++++++++++++++++++++++++++++-----
 fs/smb/server/smb2pdu.c | 24 +++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index d7ba8a01f2c68..c12b2b2857667 100644
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
@@ -1531,12 +1546,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	struct lease_ctx_info *lreq;
 
 	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
-	if (IS_ERR_OR_NULL(cc))
+	if (IS_ERR(cc))
+		return ERR_CAST(cc);
+	if (!cc)
 		return NULL;
 
 	lreq = kzalloc(sizeof(struct lease_ctx_info), KSMBD_DEFAULT_GFP);
 	if (!lreq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
@@ -1550,11 +1567,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
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
@@ -1565,12 +1585,15 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
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
index b16e1c156ee5f..1921a87e20855 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3005,6 +3005,17 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -3036,8 +3047,19 @@ int smb2_open(struct ksmbd_work *work)
 
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
2.53.0

