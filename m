Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383401D5CC6;
	Sun,  3 Aug 2025 21:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255942; cv=none; b=owh6zlbze4dgRUJTSoTmsfYuPULhp2LbDDKcsHTZ8lReUodxCfSgr+CKtsYed1gPl0etCoaVvu4cU/pQ7AgGE1QEgCVQ38t/Ugwlt2p2K0d8bzjlBnQTJ3VigNOykeXoqcGJeVhrm9f5mk11s4Pk38NK+w4OqgD1i14PsWKwwHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255942; c=relaxed/simple;
	bh=7sjZMEQKGAx0sRMw18dNziC3xa86QGlmck6KHfuHM0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jTk7SED87fO+diAkMmonw6q5vaRjR/aDwDFCNaUISER0PIWMBd3DoUlQcIDgEf36NOfnnATtlfbgZwPEuTy+z+Z1PFf/Hud3nI2tJg1dAobTQSee56CXjwFVF8A2jOLJc8O988pXC0tgkjoy9nsg0WLQEq5ntF93BbXgK4rDkew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atfg5Ish; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atfg5Ish"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B6DC4CEF8;
	Sun,  3 Aug 2025 21:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255941;
	bh=7sjZMEQKGAx0sRMw18dNziC3xa86QGlmck6KHfuHM0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atfg5Ish1ZCn7MKDRWgLhEcUQ1ucj6cLGAufaXrQ9v+mrQUg5D/t61KWypqgawod/
	 z/l0wlfhTcvlSEVDvPZCkimMFzpOWXsVsSST+6N+TeWbDR8Y9HDpta83mQVD5eMP6S
	 YxLJjZWWiWzRw+xcKqAaj5JjmQJt7mTFzrzaKCfyzxGsmUaXvQfO/p7qQFrUlBS/RD
	 BPnEsS7/HJJasViLI5aLMnzay4/oux34TJ3+KQPyhAdwCQXEhY0/NybthljSVyIMAj
	 6lff/+hJmvBVAQkDVJCgyFqzxMQyBVQ6sfSG3aloheh94TCReBGxYVdPg+sU9hbGZ1
	 e1K+R4/qmJbpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: NeilBrown <neil@brown.name>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 10/34] smb/server: avoid deadlock when linking with ReplaceIfExists
Date: Sun,  3 Aug 2025 17:18:12 -0400
Message-Id: <20250803211836.3546094-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211836.3546094-1-sashal@kernel.org>
References: <20250803211836.3546094-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

[ Upstream commit d5fc1400a34b4ea5e8f2ce296ea12bf8c8421694 ]

If smb2_create_link() is called with ReplaceIfExists set and the name
does exist then a deadlock will happen.

ksmbd_vfs_kern_path_locked() will return with success and the parent
directory will be locked.  ksmbd_vfs_remove_file() will then remove the
file.  ksmbd_vfs_link() will then be called while the parent is still
locked.  It will try to lock the same parent and will deadlock.

This patch moves the ksmbd_vfs_kern_path_unlock() call to *before*
ksmbd_vfs_link() and then simplifies the code, removing the file_present
flag variable.

Signed-off-by: NeilBrown <neil@brown.name>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Bug Analysis

This commit fixes a critical **deadlock** issue in the ksmbd (SMB
server) subsystem. The deadlock occurs in the `smb2_create_link()`
function when creating a hard link with the `ReplaceIfExists` flag set
and the target file already exists.

### Deadlock Sequence:

1. `ksmbd_vfs_kern_path_locked()` is called and locks the parent
   directory
2. If the file exists and `ReplaceIfExists` is true,
   `ksmbd_vfs_remove_file()` is called while the parent is still locked
3. `ksmbd_vfs_link()` is then called, which attempts to lock the same
   parent directory again
4. **Result: Deadlock** - the function tries to acquire a lock it
   already holds

### Fix Implementation:

The fix reorders the operations by:
- Moving the `ksmbd_vfs_kern_path_unlock()` call to execute **before**
  `ksmbd_vfs_link()`
- This ensures the parent directory is unlocked before attempting the
  link operation
- The code is also simplified by removing the `file_present` flag
  variable

## Backport Justification:

1. **Critical Bug**: This fixes a deadlock that can hang the kernel's
   SMB server functionality
2. **User Impact**: The deadlock can be triggered by normal SMB
   operations (creating hard links with replace), affecting file server
   availability
3. **Small and Contained**: The fix is minimal - just reordering
   function calls and simplifying logic
4. **No Architectural Changes**: This is a straightforward bug fix with
   no feature additions
5. **Low Risk**: The change only affects the specific error path in link
   creation
6. **Similar to Other Fixes**: The kernel has accepted similar deadlock
   fixes in ksmbd (e.g., commit 864fb5d37163 "ksmbd: fix possible
   deadlock in smb2_open")

## Code Quality:

The fix properly maintains the locking semantics while avoiding the
deadlock. The simplified code flow makes the logic clearer and less
error-prone.

This is exactly the type of bug fix that stable kernels should receive -
it fixes a real issue that affects users, has minimal risk of
regression, and improves system stability.

 fs/smb/server/smb2pdu.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f1c7ed1a6ca5..f46e9216106e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6025,7 +6025,6 @@ static int smb2_create_link(struct ksmbd_work *work,
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path, parent_path;
-	bool file_present = false;
 	int rc;
 
 	if (buf_len < (u64)sizeof(struct smb2_file_link_info) +
@@ -6058,11 +6057,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 	if (rc) {
 		if (rc != -ENOENT)
 			goto out;
-	} else
-		file_present = true;
-
-	if (file_info->ReplaceIfExists) {
-		if (file_present) {
+	} else {
+		if (file_info->ReplaceIfExists) {
 			rc = ksmbd_vfs_remove_file(work, &path);
 			if (rc) {
 				rc = -EINVAL;
@@ -6070,21 +6066,17 @@ static int smb2_create_link(struct ksmbd_work *work,
 					    link_name);
 				goto out;
 			}
-		}
-	} else {
-		if (file_present) {
+		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
 			goto out;
 		}
+		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 	}
-
 	rc = ksmbd_vfs_link(work, target_name, link_name);
 	if (rc)
 		rc = -EINVAL;
 out:
-	if (file_present)
-		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 
 	if (!IS_ERR(link_name))
 		kfree(link_name);
-- 
2.39.5

