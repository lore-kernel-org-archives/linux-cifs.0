Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0E83A1A2C;
	Wed,  7 Jan 2026 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801212; cv=none; b=MZbuUoEjdKdY25aLHQn+ZfHIbOXm8WjIkvZLALtbsvKhgooeu2exMwMfXrEk71d56jVJtEyDttlDkgEAQtuP0EsA2uS4ANdVIjp3NSpc3y4k6ZbhJvP+yhUbucmwTl+/dsgghF12dMxa/R5U6DV5gNy5sE3Arm5FTaverQV/6WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801212; c=relaxed/simple;
	bh=7lFgq7zHXS0MDWQPU7zaspeLRHzzrG6BnP2YKILo3AE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EuzKfV0TOILOO6ZC0QZXq/DQel3gqR6rVJp2rl24oUBiP0TZ2xCTMQpQHfP0TdJZlhq5C1LiOGkg/6w2/GKzjmpXHjFFQZCzdWIbPmcMp7Bqe/Ja667ySlN3V4INC/xigCXZPx/LHEFSGInaEXQpU35UAxl6H60oyRNfkDlxhnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vLMsLSMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vLMsLSMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7006C4CEF1;
	Wed,  7 Jan 2026 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801211;
	bh=7lFgq7zHXS0MDWQPU7zaspeLRHzzrG6BnP2YKILo3AE=;
	h=From:To:Cc:Subject:Date:From;
	b=vLMsLSMfwYcRBqpEoQEte73cNd4+bQSyo4Ym90e4+R44vc8ncFJawJvao+qzcQ7DQ
	 VgD2VVQAC/ZX1raSeXADLMttJjwElIY89kePhRbgXJubDuNgcq23n+mwk5BiwR9WwW
	 uBi576iWFj/Er5nUNHHOJ89NvbOJqN77lZ2PrK88FUQo5o2g/S0zGYKmOcBg44pj2H
	 jvGuHSV9BOH/NvVwOpzDZIEX6zYyhH4vpbxpeZZedWvV3RtE0S7ZGVg45mCTYdMhmL
	 puTAh5rKbnZHrOqmQ5DCWwGO4jxll1FciGRPRgdrsPmKSXEpMP4DjFoSMf+BrHGidd
	 gFCHVISjGMn7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()
Date: Wed,  7 Jan 2026 10:53:03 -0500
Message-ID: <20260107155329.4063936-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 7c28f8eef5ac5312794d8a52918076dcd787e53b ]

When ksmbd_iov_pin_rsp() fails, we should call ksmbd_session_rpc_close().

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. CLASSIFICATION

**Bug Type:** Resource leak
- This is clearly a **bug fix**, not a feature addition
- When `ksmbd_iov_pin_rsp()` fails after `ksmbd_session_rpc_open()`
  succeeds, the RPC session is never closed
- Resources leaked include:
  - The `ksmbd_session_rpc` structure memory
  - The IPC ID allocated via `ksmbd_ipc_id_alloc()`
  - Entry remains in the session's `rpc_handle_list` xarray

### 4. SCOPE AND RISK ASSESSMENT

**Size:** Very small - 4 lines of actual code change
- Line 1: `int id;` → `int id = -1;` (initialization to enable cleanup
  check)
- Lines 2-3: Added `if (id >= 0) ksmbd_session_rpc_close(work->sess,
  id);` in error path

**Risk:** Very low
- Only affects the error path when `ksmbd_iov_pin_rsp()` fails
- Standard cleanup pattern already used elsewhere in the codebase
- Cannot affect normal (successful) operation

**Subsystem:** ksmbd (kernel SMB server)
- Mature component, been in mainline since Linux 5.15
- Has an active maintainer (Namjae Jeon)

### 5. USER IMPACT

- **Who is affected:** Users running ksmbd as their SMB server
- **Trigger condition:** Any time `ksmbd_iov_pin_rsp()` fails after
  opening an RPC pipe
- **Severity:** Medium - resource leaks accumulate over time, can lead
  to system degradation or resource exhaustion under sustained error
  conditions
- **Real-world likelihood:** Moderate - `ksmbd_iov_pin_rsp()` can fail
  with -ENOMEM under memory pressure

### 6. STABILITY INDICATORS

- **Acked-by:** Namjae Jeon (ksmbd maintainer)
- **Signed-off-by:** Steve French (SMB/CIFS maintainer)
- The fix follows the existing pattern in the codebase (similar cleanup
  is done for `name` in the same error path)

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- Uses `ksmbd_session_rpc_close()` which exists in all kernel versions
  with ksmbd (5.15+)
- The affected code (`create_smb2_pipe()` and `ksmbd_iov_pin_rsp()`)
  exists in stable trees

---

## Conclusion

This commit fixes a clear resource leak in the ksmbd SMB server. When
the final step of creating an SMB pipe (`ksmbd_iov_pin_rsp()`) fails,
the previously opened RPC session was never cleaned up, causing memory
and ID leaks.

**Why it should be backported:**
1. **Fixes a real bug** - Resource leaks are a well-known category of
   bugs that accumulate over time
2. **Obviously correct** - Standard error path cleanup pattern, mirrors
   how `name` is freed in the same path
3. **Small and surgical** - Only 4 lines changed, localized to one
   function
4. **Low risk** - Only affects error path, cannot break normal operation
5. **Maintainer acknowledgment** - Acked by ksmbd maintainer
6. **Affects stable trees** - ksmbd has been in-kernel since 5.15,
   stable users can hit this bug

**Concerns:** None significant. The fix is trivial and follows
established patterns.

**YES**

 fs/smb/server/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a94cda0927d..e052dcb9a14c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2291,7 +2291,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
 	struct smb2_create_rsp *rsp;
 	struct smb2_create_req *req;
-	int id;
+	int id = -1;
 	int err;
 	char *name;
 
@@ -2348,6 +2348,9 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 		break;
 	}
 
+	if (id >= 0)
+		ksmbd_session_rpc_close(work->sess, id);
+
 	if (!IS_ERR(name))
 		kfree(name);
 
-- 
2.51.0

