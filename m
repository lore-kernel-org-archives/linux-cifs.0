Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0291F19A;
	Thu,  2 Oct 2025 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419040; cv=none; b=I8AM9K4Tql5BTOyliLtagKkGWnCmDSS98gt7ceEXEiYc832aVt5V9KwtqP+wJdqmRnkP+7iSnHeXLzOuwpTe/TiQRJqV38Vz0A1Px008am9cWB1xf4Ze1XpHM4tJp7hV1IY8rskLhccpkf6aoSndTJZUalLHBr8frZNM5i6wcfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419040; c=relaxed/simple;
	bh=4vSFaHksPoveorcIzumc87wmcMLbePGI8eiqDs2/E+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzIdhXEkSqVFsgNsYyVg1yXr4C0DNsH8J56a4xtOSQ83sEW1A+IBCrh/OGBf5HYVIhlT2WxA8C2jegrUuNsEYv+wgPFB9Ms6unEXzf2+ZdBMq/K6y0Bf0LiFTJHDU1p/WUq0X4n7Y4P6DZ7kTHaFZLaoS9uQm+KHxrRoa/0oe2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKXFCQl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKXFCQl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB7C4CEF4;
	Thu,  2 Oct 2025 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419039;
	bh=4vSFaHksPoveorcIzumc87wmcMLbePGI8eiqDs2/E+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKXFCQl1AHPXptzW/QFnbOfWk9uumjdAwACKr3P4MBVvezukTT/GpWcVtEfePiCLp
	 A5GcspoQ1dWIf421VqTQ6c251Fjelova+mlY1YB29fefxYOG+4N++KGDzy9eBLa0Vj
	 U+/z7kDzoEzTjbxGadRb5hpaZBGmoHhuohamreCw0WNc/Nq2V5rj0nLsabhF93+P3X
	 BowcKVVjKvDvRN47Ei4lDCRWnXjuwVXkNQJIQkz621QWAScV6gXOqrcweKQjkEY9x+
	 YndwJmAy6VmOh39YxcReqFGJM82/niHD6f3RUVPyXpp/OMs3hqoOxJhb5sBvOzPSQM
	 +GNGBFkKAIzyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.1] smb: server: let smb_direct_flush_send_list() invalidate a remote key first
Date: Thu,  2 Oct 2025 11:29:57 -0400
Message-ID: <20251002153025.2209281-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 1b53426334c3c942db47e0959a2527a4f815af50 ]

If we want to invalidate a remote key we should do that as soon as
possible, so do it in the first send work request.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## **BACKPORT RECOMMENDATION: YES**

## **Detailed Analysis**

### **1. Nature of the Change**

This commit fixes a **timing bug** in RDMA remote key invalidation
within the SMB server's (ksmbd) transport layer.

**Code Flow Analysis:**

The function `smb_direct_flush_send_list()` is called in two contexts:
- **Line 987**: Called with `is_last=false` from
  `wait_for_send_credits()` when credits run low during data
  transmission
- **Line 1341**: Called with `is_last=true` at the end of
  `smb_direct_writev()` to finalize the send operation

**Old Behavior (BUGGY):**
```c
if (is_last && send_ctx->need_invalidate_rkey) {
    last->wr.opcode = IB_WR_SEND_WITH_INV;
    last->wr.ex.invalidate_rkey = send_ctx->remote_key;
}
```
- Remote key invalidation ONLY occurred when BOTH `is_last=true` AND
  `need_invalidate_rkey=true`
- After successful flush (lines 944-946), the send context was
  reinitialized WITH THE SAME VALUES, preserving
  `need_invalidate_rkey=true`
- This meant intermediate flushes (with `is_last=false`) would NOT
  invalidate the key
- The remote key remained valid across multiple work requests until the
  final flush

**New Behavior (FIXED):**
```c
if (send_ctx->need_invalidate_rkey) {
    first->wr.opcode = IB_WR_SEND_WITH_INV;
    first->wr.ex.invalidate_rkey = send_ctx->remote_key;
    send_ctx->need_invalidate_rkey = false;  // Clear immediately
    send_ctx->remote_key = 0;
}
```
- Remote key invalidation occurs on the FIRST flush where
  `need_invalidate_rkey=true`, regardless of `is_last`
- Uses the FIRST work request instead of the LAST
- Immediately clears the flags to prevent duplicate invalidation
- The key is invalidated as soon as possible

### **2. Why This Is a Bug**

**RDMA Remote Key Context:**
In RDMA/SMB Direct, remote keys grant the remote side access to local
memory regions. The `IB_WR_SEND_WITH_INV` operation combines sending
data with invalidating a remote key, which is critical for:
- **Security**: Preventing unauthorized memory access after data
  transfer completes
- **Resource management**: Freeing up RDMA resources promptly
- **Protocol correctness**: SMB Direct spec requires timely invalidation

**The Problem Scenario:**
1. `smb_direct_writev()` is called with `need_invalidate=true` for a
   large transfer
2. During the while loop (line 1243), `wait_for_send_credits()` triggers
   an intermediate flush with `is_last=false`
3. **Bug**: Remote key is NOT invalidated despite
   `need_invalidate_rkey=true`
4. Work requests are posted with the remote key still valid
5. More data is sent, eventually reaching the final flush with
   `is_last=true`
6. **Bug**: Only NOW is the remote key finally invalidated

**Impact:** The remote key remains valid longer than necessary,
potentially allowing the client to access memory that should already be
inaccessible. This violates the principle of least privilege and could
cause resource leaks or protocol violations.

### **3. Historical Context**

A related fix was made in 2022 (commit 2fd5dcb1c8ef):
```
"ksmbd: smbd: fix missing client's memory region invalidation"
"if errors occur while processing a SMB2 READ/WRITE request,
ksmbd sends a response with IB_WR_SEND. So a client could
use memory regions already in use."
```

This shows that improper remote key invalidation is a known correctness
and security issue in ksmbd's RDMA implementation. The current commit
addresses a different aspect of the same problem - timing rather than
omission.

### **4. Commit Metadata**

- **Author**: Stefan Metzmacher (Samba team, prolific contributor to SMB
  server code)
- **Date**: September 8, 2025 (authored), September 28, 2025 (committed)
- **Acked-by**: Namjae Jeon (ksmbd maintainer)
- **Signed-off-by**: Steve French (SMB/CIFS maintainer)
- **File changed**: fs/smb/server/transport_rdma.c (+7, -4 lines)

### **5. Risk Assessment**

**Low Risk:**
- **Scope**: Change is confined to a single function
  (`smb_direct_flush_send_list()`)
- **Size**: Very small (11 line diff)
- **Logic**: Simple and clear - moves invalidation from last to first WR
  and removes `is_last` dependency
- **Testing**: Acked by maintainer, part of active development by Samba
  team

**Benefits:**
- Fixes correctness bug in RDMA key invalidation timing
- Improves security by invalidating keys promptly
- Aligns with SMB Direct protocol best practices
- Prevents potential resource leaks

### **6. Backport Suitability Analysis**

**✓ Fixes a bug affecting users**: Yes - users of ksmbd with RDMA/SMB
Direct
**✓ Small and contained**: Yes - 11 lines, single function
**✓ No architectural changes**: Yes - only changes when/how invalidation
happens
**✓ Minimal regression risk**: Yes - logic is straightforward
**✓ Clear correctness improvement**: Yes - invalidates keys ASAP as
intended
**✓ Maintainer approved**: Yes - Acked by Namjae Jeon

### **7. Subsystem Assessment**

- **Subsystem**: SMB server (ksmbd) RDMA transport
- **Criticality**: Medium - affects RDMA deployments, which are less
  common than TCP but important for high-performance scenarios
- **User impact**: Users with ksmbd RDMA configurations could experience
  protocol violations or delayed key invalidation

---

## **Conclusion**

**YES**, this commit should be backported to stable kernel trees.

This is a clear **bug fix** that corrects the timing of RDMA remote key
invalidation in the SMB server's RDMA transport code (lines 918-956 in
transport_rdma.c). The old code delayed invalidation until the final
flush with `is_last=true`, but the new code correctly invalidates on the
first flush, ensuring keys are invalidated "as soon as possible" as
stated in the commit message. This is both a correctness fix (protocol
behavior) and a security improvement (reduces window of key validity).
The change is small, well-contained, and has minimal regression risk.

 fs/smb/server/transport_rdma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 74dfb6496095d..b539e0421ca00 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -932,12 +932,15 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 			       struct smb_direct_sendmsg,
 			       list);
 
+	if (send_ctx->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = send_ctx->remote_key;
+		send_ctx->need_invalidate_rkey = false;
+		send_ctx->remote_key = 0;
+	}
+
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
-	if (is_last && send_ctx->need_invalidate_rkey) {
-		last->wr.opcode = IB_WR_SEND_WITH_INV;
-		last->wr.ex.invalidate_rkey = send_ctx->remote_key;
-	}
 
 	ret = smb_direct_post_send(t, &first->wr);
 	if (!ret) {
-- 
2.51.0

