Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4191171D2;
	Sun,  8 Jun 2025 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387345; cv=none; b=rfiv51DLZgu7ts8oMaZuVJrYyM3E8JsCi9srCQPv+Qf9wpywScTGj5CkVxtpP7O52a49lhg9IDnp5Wm9dP8a3Ahkr8dnjM8KDPXsQqCtoSnixghZ6tJ9R8S7jy3QU1KGZDMVnjnpVTsC81sHfUM8qTkmAwz9IBC+9bFAzhi6RJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387345; c=relaxed/simple;
	bh=Nm0SR63hGTWOJ+B2MikhCpn8b7FIl0+dd/Zt0asFPpk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PxTArdfbznR+t2d+0cejWQVnibzDKMf8w3rIq9AnbREj4f5zUvaQZmM4Z41Yi7/h7Px9cnZ6OrZ5N/hEg7PZQ1s6IDhMz5HfRk1aJ2pSyOLrzXpB1lvIH479WbYptgejrjW+aCrJAzTudfiRJJ3YeeonAPrbNm24Ux69PsrvbPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHPRivjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHPRivjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A41C4CEEE;
	Sun,  8 Jun 2025 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387345;
	bh=Nm0SR63hGTWOJ+B2MikhCpn8b7FIl0+dd/Zt0asFPpk=;
	h=From:To:Cc:Subject:Date:From;
	b=VHPRivjoY8FNKqzB7ouMEAm6PLr356BABM5ipyGtDGliRpNrTrnVqecGzOM9vpPLt
	 u8CvMsctpJTvOI1hV02lliA99CFqvrfvQHP9zwlUTf4a9RbBY+zazwM0wXwixZ2HeG
	 74QESWgvj0v4HjFgr2tLUz17Ng/pPWEH9OQwbtU212LuYzp+UvS7BB/U9fjM06TnJI
	 z34b1poRz75UDJ8+pLKdNu6X/Yi/Uo6voqyYCkph2Nb0jaTgW/77DS0TJ5xGFzBiZF
	 sD37S37JC8vZLq1/iO/mBFY37uA1JwQ9raa+3Wpwx/Yqalb8e/ZufExeDqctOcIv47
	 PlPSMKWbfuiDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Philipp Kerling <pkerling@casix.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 1/5] ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension
Date: Sun,  8 Jun 2025 08:55:39 -0400
Message-Id: <20250608125543.934436-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit dc3e0f17f74558e8a2fce00608855f050de10230 ]

If client send SMB2_CREATE_POSIX_CONTEXT to ksmbd, Allow a filename
to contain special characters.

Reported-by: Philipp Kerling <pkerling@casix.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of both the commit message and code changes,
examining the Linux kernel repository context:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Nature of the Change

This is a **legitimate bug fix** that addresses a functional issue where
SMB3.1.1 POSIX extension clients cannot create files with characters
that are valid in POSIX filesystems but blocked by ksmbd's Windows-
centric filename validation.

## Code Analysis

### Key Changes:
1. **Early POSIX context detection** (lines 2906-2925): The code now
   checks for SMB2_CREATE_POSIX_CONTEXT early in the function
2. **Conditional validation bypass**: The critical change at lines
   3161-3164 where `ksmbd_validate_filename(name)` is only called when
   `posix_ctxt == false`
3. **Structural improvement**: Moving POSIX context parsing before
   filename validation, which is the logical order

### What Gets Bypassed:
The `ksmbd_validate_filename()` function normally blocks characters like
`"`, `<`, `>`, `|`, `?`, `*`, and control characters. For POSIX
extensions, these restrictions are inappropriate since POSIX filesystems
can safely handle most of these characters.

## Security Assessment

### Low Security Risk:
1. **Limited Scope**: Only affects clients explicitly using SMB3.1.1
   POSIX extensions (`tcon->posix_extensions` must be enabled)
2. **VFS Protection**: Linux VFS layer provides underlying security
   validation
3. **No Path Traversal**: Higher-level path validation still prevents
   `../` sequences
4. **Standards Compliance**: Aligns with Microsoft's SMB3.1.1 POSIX
   extension specification

### Justification for the Change:
- **User Report**: Philipp Kerling reported this as a functional issue
- **Interoperability**: Essential for proper POSIX-aware SMB client
  functionality
- **Standards Adherence**: SMB3.1.1 POSIX extensions are designed to
  allow POSIX filename semantics

## Comparison with Similar Commits

This follows the pattern of other backported ksmbd commits:
- **Similar to Commit #4**: Another filename validation fix that was
  backported (moving leading slash check)
- **Similar scope**: Limited, well-contained change to specific
  subsystem
- **Bug fix nature**: Addresses functional issue rather than adding new
  features

## Stable Tree Criteria Compliance

✅ **Fixes important bug**: Enables legitimate POSIX client functionality
✅ **Small and contained**: Changes only affect POSIX extension code path
✅ **Minimal regression risk**: Protected by existing VFS validation
✅ **Clear side effects**: Well-understood behavior change
✅ **No architectural changes**: Simple conditional logic modification

## Recommendation

This commit represents a **low-risk bug fix** that enables proper
SMB3.1.1 POSIX extension functionality without introducing significant
security vulnerabilities. The change is well-scoped, addresses a
legitimate user issue, and maintains appropriate security boundaries
through existing VFS-level protections.

 fs/smb/server/smb2pdu.c | 53 +++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9b1ba4aedbce7..c591255335058 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2685,7 +2685,7 @@ int smb2_open(struct ksmbd_work *work)
 	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
 	int rc = 0;
 	int contxt_cnt = 0, query_disk_id = 0;
-	int maximal_access_ctxt = 0, posix_ctxt = 0;
+	bool maximal_access_ctxt = false, posix_ctxt = false;
 	int s_type = 0;
 	int next_off = 0;
 	char *name = NULL;
@@ -2712,6 +2712,27 @@ int smb2_open(struct ksmbd_work *work)
 		return create_smb2_pipe(work);
 	}
 
+	if (req->CreateContextsOffset && tcon->posix_extensions) {
+		context = smb2_find_context_vals(req, SMB2_CREATE_TAG_POSIX, 16);
+		if (IS_ERR(context)) {
+			rc = PTR_ERR(context);
+			goto err_out2;
+		} else if (context) {
+			struct create_posix *posix = (struct create_posix *)context;
+
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_posix) - 4) {
+				rc = -EINVAL;
+				goto err_out2;
+			}
+			ksmbd_debug(SMB, "get posix context\n");
+
+			posix_mode = le32_to_cpu(posix->Mode);
+			posix_ctxt = true;
+		}
+	}
+
 	if (req->NameLength) {
 		if ((req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
 		    *(char *)req->Buffer == '\\') {
@@ -2743,9 +2764,11 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 		}
 
-		rc = ksmbd_validate_filename(name);
-		if (rc < 0)
-			goto err_out2;
+		if (posix_ctxt == false) {
+			rc = ksmbd_validate_filename(name);
+			if (rc < 0)
+				goto err_out2;
+		}
 
 		if (ksmbd_share_veto_filename(share, name)) {
 			rc = -ENOENT;
@@ -2860,28 +2883,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = -EBADF;
 			goto err_out2;
 		}
-
-		if (tcon->posix_extensions) {
-			context = smb2_find_context_vals(req,
-							 SMB2_CREATE_TAG_POSIX, 16);
-			if (IS_ERR(context)) {
-				rc = PTR_ERR(context);
-				goto err_out2;
-			} else if (context) {
-				struct create_posix *posix =
-					(struct create_posix *)context;
-				if (le16_to_cpu(context->DataOffset) +
-				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix) - 4) {
-					rc = -EINVAL;
-					goto err_out2;
-				}
-				ksmbd_debug(SMB, "get posix context\n");
-
-				posix_mode = le32_to_cpu(posix->Mode);
-				posix_ctxt = 1;
-			}
-		}
 	}
 
 	if (ksmbd_override_fsids(work)) {
-- 
2.39.5

