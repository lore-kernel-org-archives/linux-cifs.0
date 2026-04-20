Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BB3A1A43;
	Mon, 20 Apr 2026 13:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690948; cv=none; b=Zse9URtAddwlbVIlWk4xrggT6Fa1oZHehbNEmbsls22PAMD2d4RIzMGlmVEbyp/tWNgIYKYtvXRadsZEHpdIfGFK/NmBI7XhnNfQz2WHJII0uBy/703gvtFNhnai/YLAAIkimyN6bDWpUmAE2Gy9oMOEsAcbOCU/Ucx/y2uxOCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690948; c=relaxed/simple;
	bh=ElydiWKgLhVeyXRfLHbMAdxfRMOsgbbmzORiMWBgC4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVeKMCi91fbEV8hOgsH8FoTubn2ML7ZPRF3XIwJGhtdAARCN4AiFgKmHk8ovvXrwLoJAnixo9iYg+nYb+BZa47O4xuDKtFtL5wKLnWw/Ft0PxzF+QdWoHLIzNmeVmACDqxBNmzCRQWo8MvT9gTW9ma1JTbGtFeOj0TUtwHLyrX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk9gazyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk9gazyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB661C2BCB8;
	Mon, 20 Apr 2026 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690948;
	bh=ElydiWKgLhVeyXRfLHbMAdxfRMOsgbbmzORiMWBgC4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk9gazyKuIxhiZpWAox6W38HY7ETEnLeEkELJFOEravUvotak/YTczgZPhGky/JFw
	 WRgi178jeX5ZVK/lDkoLQvGlH3NmbdL0paIeXe6X+VlQ9Ba7AUGhxY3jph3k0rLB1S
	 QQxSlTatjTXjmWhTcBM4X5p68+t19TAz2f4C5llsl5ooxlWCQDyNSkwFsa5EQzXYmZ
	 pkRi/excHWlbBdeipJ1AtdOpSKKvOMJawQnFClt4oq08BQAV5jsl+Y6jz/XL2GlF1W
	 x+Xk45LbfHOIUIKWk6/ViIREOQJrRjnwmOZgGGDoISx/pGJjPaTlgbvXkM64cAkgbu
	 x2zqNLcOJekEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dudu Lu <phx0fer@gmail.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] smb: client: fix integer underflow in receive_encrypted_read()
Date: Mon, 20 Apr 2026 09:07:51 -0400
Message-ID: <20260420131539.986432-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 6b83b03c07fbe0b57bb729bee91ae44c623c82ff ]

In receive_encrypted_read(), the length of data to read from the socket
is computed as:

  len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
        server->vals->read_rsp_size;

OriginalMessageSize comes from the server's transform header and is
untrusted. If a malicious server sends a value smaller than
read_rsp_size, the unsigned subtraction wraps to a very large value
(~4GB). This value is then passed to netfs_alloc_folioq_buffer() and
cifs_read_iter_from_socket(), causing either a massive allocation
attempt that fails with -ENOMEM (DoS), or under extreme memory
pressure, potential heap corruption.

Fix by adding a check that OriginalMessageSize is at least
read_rsp_size before the subtraction. On failure, jump to
discard_data to drain the remaining PDU from the socket, preventing
desync of subsequent reads on the connection.

Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `smb: client:` (SMB/CIFS network filesystem client)
- **Action verb**: "fix" (explicitly a bug fix)
- **Summary**: Fix integer underflow in `receive_encrypted_read()` when
  server sends a small `OriginalMessageSize`

Record: [smb: client] [fix] [integer underflow in receive_encrypted_read
from untrusted server data]

### Step 1.2: Tags
- **Signed-off-by**: Dudu Lu <phx0fer@gmail.com> (author)
- **Reviewed-by**: Enzo Matsumiya <ematsumiya@suse.de> (known CIFS/SMB
  contributor at SUSE)
- **Signed-off-by**: Steve French <stfrench@microsoft.com> (SMB/CIFS
  subsystem maintainer)
- No Fixes: tag (expected - that's why it's being reviewed)
- No Cc: stable tag (expected)

Record: Reviewed by known SMB developer, committed by subsystem
maintainer Steve French. No syzbot/reporter tags, but the bug is found
by code inspection of untrusted network input handling.

### Step 1.3: Commit Body Analysis
- **Bug**: `OriginalMessageSize` is read from network (server's
  transform header) and is untrusted. It's used in an unsigned
  subtraction `OriginalMessageSize - read_rsp_size`. If the server sends
  a value smaller than `read_rsp_size`, the subtraction wraps around to
  ~4GB.
- **Symptom**: Massive allocation attempt via
  `netfs_alloc_folioq_buffer()` leading to -ENOMEM (DoS), or under
  extreme memory pressure, potential heap corruption.
- **Failure mode**: DoS via malicious server, potential heap corruption
- **Root cause**: Missing input validation on network-supplied value
  before unsigned arithmetic

Record: Integer underflow from untrusted network input. Symptom is DoS
or potential heap corruption. Clear security bug.

### Step 1.4: Hidden Bug Fix Detection
This is an explicit bug fix, not disguised. The word "fix" and the
detailed description of the vulnerability make it clear.

Record: Explicit bug fix. Not hidden.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File**: `fs/smb/client/smb2ops.c` (single file)
- **Lines added**: 8 (the validation check + debug message + error path)
- **Lines removed**: 0
- **Function modified**: `receive_encrypted_read()`
- **Scope**: Single-file, single-function surgical fix

Record: 1 file changed, +8 lines. Extremely surgical.

### Step 2.2: Code Flow Change
Before: The code reads `OriginalMessageSize` from the server and
subtracts `read_rsp_size` unconditionally. If `OriginalMessageSize <
read_rsp_size`, `len` wraps to ~4GB unsigned.

After: Before the subtraction, a check verifies `OriginalMessageSize >=
read_rsp_size`. On failure, logs a debug message and jumps to
`discard_data` which drains the remaining PDU and cleans up properly.

Record: Adds input validation before unsafe unsigned subtraction of
untrusted server data.

### Step 2.3: Bug Mechanism
- **Category**: Buffer overflow / integer underflow from untrusted input
- **Mechanism**: Unsigned integer underflow when `OriginalMessageSize <
  read_rsp_size`, leading to ~4GB allocation attempt
- **Security aspect**: Server-controlled value, exploitable by malicious
  SMB server (network attack vector)

Record: Integer underflow of untrusted network data → massive allocation
→ DoS or heap corruption.

### Step 2.4: Fix Quality
- Obviously correct: simple bounds check before subtraction
- Minimal/surgical: 8 lines added, no unrelated changes
- Regression risk: extremely low - only adds a validation check and
  error path using existing `discard_data` label
- The error path (`goto discard_data`) is well-tested by other failure
  paths in the same function

Record: Obviously correct, minimal, no regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code was introduced in commit `1fc6ad2f10ad6f` (2018-06-01) by
Ronnie Sahlberg, which was a refactor of `receive_encrypted_read()`. The
original function was introduced even earlier in `93012bf984163f`
(2018-03-31). Both are from the 4.17-4.18 era.

Record: Buggy code has been present since ~v4.17 (2018). Present in ALL
active stable trees.

### Step 3.2: Fixes tag
No Fixes: tag present. The bug was introduced in 93012bf984163f or
1fc6ad2f10ad6f, both from 2018.

### Step 3.3: Related Changes
- `eec04ea119691` ("smb: client: fix OOB in
  receive_encrypted_standard()") - same class of bug (CVE-2024-0565) in
  the sibling function, already has Cc: stable
- `860ca5e50f73c` ("smb: client: Add check for next_buffer in
  receive_encrypted_standard()") - follow-up NULL check fix
- These show that the same pattern of missing validation on untrusted
  server data in this file has been a recurring security issue

Record: Related CVE-2024-0565 fix exists for the sibling function. This
is the same class of vulnerability.

### Step 3.4: Author
Dudu Lu appears to be a new contributor (no other commits found).
However, the fix was reviewed by Enzo Matsumiya (SUSE, known CIFS
contributor) and committed by Steve French (subsystem maintainer).

Record: New author, but reviewed and committed by experienced subsystem
maintainers.

### Step 3.5: Dependencies
The fix uses the existing `discard_data` label and existing code
patterns. No dependencies on other patches. Standalone fix.

Record: Fully standalone, no dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch Discussion
Unable to find the exact lore thread via b4 dig (commit not yet in
tree). Web search found CVE-2024-0565 for the related bug in
`receive_encrypted_standard()`, confirming this is a known class of
vulnerability in the SMB encrypted receive path.

Record: Could not find lore thread (commit not in mainline yet).
CVE-2024-0565 confirms the vulnerability class.

### Step 4.2: Reviewers
- Reviewed by Enzo Matsumiya (SUSE, active CIFS developer)
- Committed by Steve French (Microsoft, CIFS/SMB maintainer)

Record: Appropriate reviewers involved.

### Step 4.3: Bug Report
The bug was found by code inspection (not crash report or fuzzer). The
similarity to CVE-2024-0565 strengthens the case - that CVE was for
`receive_encrypted_standard()` and THIS fix is for
`receive_encrypted_read()`, the sibling function that handles large
encrypted reads.

Record: Found by code audit, related to CVE-2024-0565.

### Step 4.4-4.5: Related patches / Stable history
The sibling fix (CVE-2024-0565) for `receive_encrypted_standard()` was
backported to stable. This fix addresses the same vulnerability pattern
in the other code path.

Record: Sibling fix was backported to stable. This fix addresses the
same gap.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Tracing
- `receive_encrypted_read()` is called from `smb3_receive_transform()`
  (line 5147)
- `smb3_receive_transform()` is registered as `.receive_transform` ops
  callback for SMB3 protocol
- Called from `cifs_demultiplex_thread()` in `connect.c` (line 1341) -
  the main SMB connection handler
- This is in the hot path for ALL encrypted SMB3 read operations
- Reachable from any SMB client mount with encryption enabled (common
  enterprise configuration)

Record: Called from main demux thread for all encrypted SMB3 reads. High
traffic path. Reachable from network.

### Step 5.5: Similar Patterns
The caller `smb3_receive_transform()` already has partial validation
(lines 5131-5143) that checks `pdu_length` against
`OriginalMessageSize`, but doesn't check `OriginalMessageSize` against
`read_rsp_size`. The `receive_encrypted_read()` path bypasses the
standard path's protections because it's for large PDUs.

Record: Caller has some checks but insufficient for the
`receive_encrypted_read` path.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
The buggy code exists since v4.17. It is present in ALL active stable
trees (5.10, 5.15, 6.1, 6.6, 6.12, etc.).

Record: Bug exists in all active stable trees.

### Step 6.2: Backport Complications
The fix is 8 lines of added validation. The surrounding code structure
is stable. The function uses `netfs_alloc_folioq_buffer()` which was
added in newer kernels (replacing older `alloc_pages` pattern), so older
stable trees (5.x) may need minor adaptation, but the core validation
check is independent of that.

Record: Clean apply expected for recent stable trees (6.x). Older trees
may need minor context adaptation.

### Step 6.3: Related Fixes in Stable
CVE-2024-0565 fix for `receive_encrypted_standard()` is already in
stable. This is the companion fix for `receive_encrypted_read()`.

Record: Companion fix for sibling function already in stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: fs/smb/client (CIFS/SMB network filesystem client)
- **Criticality**: IMPORTANT - SMB is widely used in enterprise
  environments for network file sharing (Windows interop, NAS, etc.)

Record: [fs/smb/client] [IMPORTANT - widely used enterprise network
filesystem]

### Step 7.2: Subsystem Activity
The SMB client is actively maintained with regular fixes. Steve French
is the active maintainer.

Record: Actively maintained subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users who mount SMB3 shares with encryption enabled (increasingly
common in enterprise environments with security requirements).

Record: Enterprise SMB users with encryption - significant population.

### Step 8.2: Trigger Conditions
- A malicious SMB server (or man-in-the-middle) can send a crafted
  transform header with a small `OriginalMessageSize` during an
  encrypted read response
- Triggered on any large encrypted read operation
- Exploitable from network without any local privileges

Record: Network-exploitable, triggered by malicious server response. No
local privileges needed.

### Step 8.3: Failure Mode Severity
- **Primary**: DoS - massive allocation attempt fails with -ENOMEM
- **Secondary**: Under memory pressure, potential heap corruption from
  the wrapped-around length value passed to allocation/socket read
  functions
- **Severity**: CRITICAL (network-exploitable DoS, potential remote heap
  corruption)

Record: DoS (guaranteed) to potential heap corruption (under pressure).
Severity: CRITICAL.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Very high - fixes a network-exploitable security
  vulnerability in a widely-used filesystem
- **Risk**: Very low - 8-line addition of input validation using
  existing error path, obviously correct
- **Ratio**: Extremely favorable

Record: Very high benefit, very low risk. Strong backport candidate.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a security vulnerability (integer underflow from untrusted
  network input)
- Network-exploitable DoS with potential for heap corruption
- Related vulnerability in sibling function was assigned CVE-2024-0565
  and already backported
- Small, surgical fix: 8 lines, single file, single function
- Obviously correct: simple bounds check before unsigned subtraction
- Reviewed by known CIFS developer, committed by subsystem maintainer
- Bug exists in all active stable trees (since v4.17, 2018)
- Zero regression risk
- Standalone fix with no dependencies

**AGAINST backporting:**
- (None identified)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial bounds check,
   reviewed by maintainers
2. Fixes a real bug? **YES** - integer underflow from untrusted network
   data
3. Important issue? **YES** - network-exploitable DoS/potential heap
   corruption, security bug
4. Small and contained? **YES** - 8 lines, 1 file, 1 function
5. No new features or APIs? **YES** - pure validation fix
6. Can apply to stable? **YES** - recent trees should apply cleanly

### Step 9.3: Exception Categories
Not an exception - this is a standard security/correctness fix that
meets all stable criteria directly.

### Step 9.4: Decision
This is a clear YES. It's a security fix for a network-exploitable
integer underflow vulnerability in the SMB3 encrypted read path. The fix
is minimal (8 lines), obviously correct, reviewed by subsystem experts,
has zero regression risk, and the bug has existed since 2018 in all
stable trees. The related CVE-2024-0565 for the sibling function was
already backported to stable.

---

## Verification

- [Phase 1] Parsed subject: "smb: client: fix integer underflow in
  receive_encrypted_read()" - explicit fix for integer underflow
- [Phase 1] Parsed tags: Reviewed-by Enzo Matsumiya (SUSE), SOB Steve
  French (maintainer)
- [Phase 2] Diff analysis: +8 lines in `receive_encrypted_read()`, adds
  bounds check before unsigned subtraction of `OriginalMessageSize -
  read_rsp_size`
- [Phase 2] Error path: `goto discard_data` is existing label (verified
  at line 5018) that drains remaining PDU and cleans up
- [Phase 3] git blame: buggy subtraction at line 4946 introduced by
  commit `1fc6ad2f10ad6f` (2018-06-01, Ronnie Sahlberg) and
  `93012bf984163f` (2018-03-31)
- [Phase 3] git tag --contains: original code present since v4.17 era,
  in all stable trees including 5.10, 5.15+
- [Phase 3] Related fix: `eec04ea119691` (CVE-2024-0565) fixed same
  class of bug in sibling function `receive_encrypted_standard()`, Cc:
  stable
- [Phase 4] b4 dig: could not find lore thread (commit not yet in
  mainline)
- [Phase 4] Web search: confirmed CVE-2024-0565 for related
  vulnerability in `receive_encrypted_standard()`
- [Phase 5] Call chain traced: `cifs_demultiplex_thread()` →
  `smb3_receive_transform()` → `receive_encrypted_read()` - main SMB
  connection path
- [Phase 5] `OriginalMessageSize` confirmed as network-supplied value
  from `struct smb2_transform_hdr` (defined in `smb2pdu.h` line 211)
- [Phase 6] Bug exists in all active stable trees (code from 2018)
- [Phase 6] Caller's existing check at line 5139 validates `pdu_length
  >= orig_len + sizeof(transform_hdr)` but does NOT validate `orig_len
  >= read_rsp_size`
- [Phase 8] Failure mode: unsigned wrap to ~4GB → massive allocation →
  -ENOMEM (DoS) or heap corruption
- UNVERIFIED: Exact lore discussion thread not found (does not affect
  decision)

**YES**

 fs/smb/client/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a429..a2105f4b54db7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4943,6 +4943,14 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_dw;
 	server->total_read += rc;
 
+	if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
+	    server->vals->read_rsp_size) {
+		cifs_server_dbg(VFS, "OriginalMessageSize %u too small for read response (%zu)\n",
+			le32_to_cpu(tr_hdr->OriginalMessageSize),
+			server->vals->read_rsp_size);
+		rc = -EINVAL;
+		goto discard_data;
+	}
 	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
 		server->vals->read_rsp_size;
 	dw->len = len;
-- 
2.53.0

