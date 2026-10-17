Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1538D35F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199069; cv=none; b=rxtcti8CTQbtyd4j90asduwdfmkrhRTN2S67fGkatcs4MIitc/P4mQIfRqiigKeS6ugBv3LTj84BEG7AuFnc5OUzLNQtiV95VlSUQhuEo5X9M1ppO+kA2RFK6uo8mfS1dx9RC1g6pF0ivvFUS4SpgHzQmog8AT9Vqfiz4fYUMgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199069; c=relaxed/simple;
	bh=gfn9XoDQU6dlO9hw2QAxX3C1XqCP1HNWXZ5t/0kmYUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l78PgfExNpfr2lBkVkvZnx5Ccs0hWkXIkJnxS3S1ZIoExfJH1mMctVYnOdO4ikpPLNegLlT+coArCUOCTNEzA8yWy5ig0HuHIcTYz4SmB9b8NhKMpRZNYB1HICF7FdsZJijLSSfm3ZvievE2Lj89R4b/m/MjPgipEzT5MjDOpz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5sZ1UJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5sZ1UJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD15C1F000C6;
	Sat, 17 Oct 2026 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199068;
	bh=a8GGfa5QDoLa98PUe9OhJ4s09fpX9fc0pLKGu+dO+o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5sZ1UJXYciOEB/GClVXylkxRg4j0vcA7OdXgTfXgBDpLZVKPVtgr1x0zbdCfDhh+
	 M5SSgNYEeTYjM8qBLAX2seySX0vfMzP7khcbCJ5kTzYQYOgd+vL58MDr4t4aiJ9IXn
	 Z1QaY0Xtsv+do/9lyNQCxsgytG9fn9Ronntm9i4CWS6JE5DoamZpqSuWg28CfITceq
	 T+gb6Ksui/lDwv0omy2+PXnherhgoaA4//SqI3F/ZsJyJTO1J4fc+hvm9aH1nfbdJU
	 vXU9qnxrEu44wKBy29/jzJ3S1Mx3G62rLxtohsZHbN/YpKQPEDL5lNAXDi1yTZqaGb
	 qFzOIXbGhXYMw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 13/22] ksmbd: validate POSIX create contexts
Date: Sat, 17 Oct 2026 10:03:35 +0900
Message-Id: <20261017010344.11478-13-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

POSIX create contexts are only examined when the tree has POSIX
extensions enabled, and IPC requests bypass this validation.

Examine POSIX contexts before selecting the IPC create path. Reject
duplicate contexts and require an SMB3.1.1 connection, a POSIX-enabled
tree and a non-IPC share for POSIX creates.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 14 +++++++++++---
 fs/smb/server/smb2pdu.c | 24 ++++++++++++++++++------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 5873bd349e08..a911ff70b29e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -2371,6 +2371,9 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag, i
 	struct create_context *cc;
 	unsigned int next = 0;
 	char *name;
+	struct create_context *found = NULL;
+	bool posix_tag = tag_len == POSIX_CTXT_DATA_LEN &&
+			 !memcmp(tag, SMB2_CREATE_TAG_POSIX, POSIX_CTXT_DATA_LEN);
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
 	unsigned int remain_len, name_off, name_len, value_off, value_len,
 		     cc_len;
@@ -2408,13 +2411,18 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag, i
 			return ERR_PTR(-EINVAL);
 
 		name = (char *)cc + name_off;
-		if (name_len == tag_len && !memcmp(name, tag, name_len))
-			return cc;
+		if (name_len == tag_len && !memcmp(name, tag, name_len)) {
+			if (!posix_tag)
+				return cc;
+			if (found)
+				return ERR_PTR(-EINVAL);
+			found = cc;
+		}
 
 		remain_len -= next;
 	} while (next != 0);
 
-	return NULL;
+	return found;
 }
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 17bd7413e137..a1e553ddde46 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4264,12 +4264,7 @@ int smb2_open(struct ksmbd_work *work)
 		return -EINVAL;
 	}
 
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
-		ksmbd_debug(SMB, "IPC pipe create request\n");
-		return create_smb2_pipe(work);
-	}
-
-	if (req->CreateContextsOffset && tcon->posix_extensions) {
+	if (req->CreateContextsOffset) {
 		context = smb2_find_context_vals(req, SMB2_CREATE_TAG_POSIX, 16);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
@@ -4277,6 +4272,19 @@ int smb2_open(struct ksmbd_work *work)
 		} else if (context) {
 			struct create_posix *posix = (struct create_posix *)context;
 
+			if (conn->dialect != SMB311_PROT_ID) {
+				rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+				rc = -ENOTTY;
+				goto err_out2;
+			}
+			if (!tcon->posix_extensions) {
+				rc = -EOPNOTSUPP;
+				goto err_out2;
+			}
+			if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
+				rc = -EOPNOTSUPP;
+				goto err_out2;
+			}
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
 			    sizeof(struct create_posix) - 4) {
@@ -4289,6 +4297,10 @@ int smb2_open(struct ksmbd_work *work)
 			posix_ctxt = true;
 		}
 	}
+	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
+		ksmbd_debug(SMB, "IPC pipe create request\n");
+		return create_smb2_pipe(work);
+	}
 
 	if (req->NameLength) {
 		name = smb2_get_name((char *)req + le16_to_cpu(req->NameOffset),
-- 
2.25.1

