Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD5F3F1665;
	Tue, 28 Apr 2026 10:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372947; cv=none; b=NJV6T/Btl4XtPrpF+UYs17ppIj/VHAAJozexCaamcdoiNj1KtkBOHEUkHay/zQ58txC1l6wnDJFK5+vZKXdl2h8g/1rSwfptZ2/fpzFKykScIL8HYWbyjGZj/Gvg/ffQ+SYtuTGPVNdISpVeZKKIKqL1os8eJdLG9H0cK4zQc4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372947; c=relaxed/simple;
	bh=MvsYJAw/ycvumPUKI6XJQ4whW6JyJykHMPTpKlTFua0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDC4UZrWFHarF3lKs9Z0YX7H36O/CdhJoilyyt87ejiWptproZa7a5nAmvpwxOBBHZlD5HmtHITq9fz7rgeN/HT5F4Jfpjnqh5PpNo8uHOGoeRdn4wYfVtUp1auuI+gfnMKowdDvGovkp/Plrs5Gm1WyMuKxuSTGjJSOdcs5uT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2xQPy+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2xQPy+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EACC2BCB7;
	Tue, 28 Apr 2026 10:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372947;
	bh=MvsYJAw/ycvumPUKI6XJQ4whW6JyJykHMPTpKlTFua0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2xQPy+ClLQXDQNXQt6nLVLH5cLdTUWTMacLTWoK3vxGFCL/KSxo+L0J6/CQtXqs8
	 x9brAHlmK/IXRDr452NsD5xb+MNyDOikfTfB2QAC4o+LF3fKHTbqyJK8rtBy5KO3IO
	 zFrae+sPN7KWzIzldhcZfyHswaUtUgLaHw3yEB7fTLhprJkBDgYncUAMXcAl9vC46B
	 xcocrY55WwXrBR7J1SQZn6ik1rHv0RxXRMqRKgG2AslrFlDsOXk0KV0TdKr+6QjY1V
	 hKSKr1dQQdHbd+t4OgpapYtqlr4ZVNWlfx2ZEhqVOww44X2srUH6kH69ZmATVIV9cl
	 onIeonYZ1pVkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Akif Sait <akif.sait111@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ksmbd: fix O(N^2) DoS in smb2_lock via unbounded LockCount
Date: Tue, 28 Apr 2026 06:40:49 -0400
Message-ID: <20260428104133.2858589-38-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akif Sait <akif.sait111@gmail.com>

[ Upstream commit bd0a1ca52b6da64b1a163f103b28b488b20497fe ]

smb2_lock() performs O(N^2) conflict detection with no cap on LockCount.
Cap lock_count at 64 to prevent CPU exhaustion from a single request.

Signed-off-by: Akif Sait <akif.sait111@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my complete walkthrough:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parse**
Record: `[ksmbd:] [fix]` O(N^2) DoS in smb2_lock via unbounded LockCount
- claims to fix a denial-of-service vulnerability.

**Step 1.2: Parse tags**
Record:
- Signed-off-by: Akif Sait <akif.sait111@gmail.com> (author)
- Acked-by: Namjae Jeon <linkinjeon@kernel.org> (**ksmbd maintainer**)
- Signed-off-by: Steve French <stfrench@microsoft.com> (**maintainer who
  pulled it via samba tree**)
- No Fixes: tag (expected for manual review), no Cc: stable (expected)

**Step 1.3: Commit body analysis**
Record: Describes O(N^2) conflict detection with uncapped LockCount.
Attack: authenticated client sends LockCount=65535 -> ~2.1 billion
iterations pinning CPU. A few concurrent requests hang the host.
Justifies cap at 64 per MS-SMB2 spec's Open.LockSequenceArray size.

**Step 1.4: Hidden bug fix detection**
Record: Explicitly labeled "fix" and "DoS" - not hidden; clearly a
security fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file (`fs/smb/server/smb2pdu.c`), ~7 lines added (1 functional
line + 5-line comment + structural whitespace), 1 line removed. Single
surgical fix in `smb2_lock()`.

**Step 2.2: Code flow change**
Record: Before: `if (!lock_count)` rejected only zero. After: `if
(!lock_count || lock_count > 64)` rejects zero AND values >64 with
`-EINVAL` before any work is done.

**Step 2.3: Bug mechanism**
Record: DoS / resource-exhaustion / algorithmic complexity attack. `for
(i = 0; i < lock_count; i++)` with nested `list_for_each_entry(cmp_lock,
&lock_list, llist)` = O(N²). LockCount is u16 (max 65535), giving
~2.1×10⁹ inner-loop iterations plus N smb_flock_init allocations per
request. Fix: bound input parameter.

**Step 2.4: Fix quality**
Record: Obviously correct, minimal, cannot introduce regression for
legitimate workloads (MS-SMB2 spec ceiling is 64), no lock/memory/API
changes.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: The vulnerable `if (!lock_count)` pattern has existed since
ksmbd was first merged into the kernel in v5.15 (commit that added
`fs/cifsd/smb2pdu.c` then moved to `fs/ksmbd/`, then to `fs/smb/server/`
in v6.3). Confirmed identical pattern in v5.15, v6.1, v6.6, v6.12, v7.0.

**Step 3.2: Fixes: tag follow**
Record: No Fixes: tag provided. Bug is original to ksmbd (v5.15).

**Step 3.3: File history**
Record: Prior related fixes to smb2_lock: `309b44ed68449` (memory
leaks/NULL deref), `e26e2d2e15daf` (bug on trap), `84d2d1641b71d` (UAF),
`8f1752723019d` (memory leak), `75ac9a3dd65f7` (race). Our fix is
independent and standalone.

**Step 3.4: Author**
Record: Akif Sait is a contributor (not maintainer); patch was Acked-by
ksmbd maintainer Namjae Jeon and signed off by CIFS/samba maintainer
Steve French.

**Step 3.5: Dependencies**
Record: None. The fix applies to unchanged `le16_to_cpu(req->LockCount)`
code that exists identically across all stable trees.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Find discussion**
Record: Original submission https://yhbt.net/lore/linux-
cifs/?q=ksmbd+unbounded+LockCount - posted 2026-04-18 15:45 UTC by Akif
Sait. Cover note explicitly states "a single authenticated request with
LockCount=65535 results in roughly 2.1 billion iterations inside a ksmbd
worker thread, pinning the CPU completely. A few concurrent requests
hang the host entirely." Applied by Namjae Jeon to #ksmbd-for-next-next
on 2026-04-20.

**Step 4.2: Reviewers**
Record: To: Namjae Jeon (maintainer), Steve French (CIFS maintainer).
Cc: senozhatsky, tom, linux-cifs - correct mailing lists and
maintainers.

**Step 4.3: Bug report**
Record: No public bug report; the submitter found it via code
inspection, explaining the trigger and providing a reproducer offer.

**Step 4.4: Related patches**
Record: Not part of a series; standalone patch.

**Step 4.5: Stable list**
Record: Included in Steve French's "GIT PULL ksmbd server fixes"
(2026-04-23), explicitly described as "cap maximum lock count to avoid
potential denial of service."

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key functions**
Record: `smb2_lock()` in fs/smb/server/smb2pdu.c.

**Step 5.2: Callers**
Record: `smb2_lock()` is the SMB2_LOCK_HE handler in the command
dispatch table (`fs/smb/server/smb2ops.c:191`). Reachable from any SMB2
LOCK request from any authenticated client with a valid file handle.

**Step 5.3: Callees**
Record: `smb_flock_init()` (memory alloc), `smb2_set_flock_flags()`,
`smb2_lock_init()` (memory alloc), `list_for_each_entry()` (the O(N²)
loop).

**Step 5.4: Reachability**
Record: SMB2 LOCK handlers are reachable by any authenticated SMB client
after they open a file. This is a network-reachable CPU DoS.

**Step 5.5: Similar patterns**
Record: Smb2misc.c already validates `lock_count * sizeof(struct
smb2_lock_element) <= MAX_STREAM_PROT_LEN (16MB)`, but that still allows
65535 (u16 max) locks, so the size check does not mitigate the O(N²) CPU
attack.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Vulnerable code in stable**
Record: Confirmed present in v5.15.203, v6.1.169, v6.6.135, v6.12.83,
v7.0.1 - every active stable tree that contains ksmbd.

**Step 6.2: Backport complications**
Record: In 5.15 the file is `fs/ksmbd/smb2pdu.c`; in 6.1+ it's
`fs/smb/server/smb2pdu.c`. The surrounding code (the `if (!lock_count)`
block) is identical in all versions - patch applies cleanly with at most
a path adjustment for 5.15.

**Step 6.3: Related stable fixes**
Record: Prior smb2_lock fixes already went to stable (e.g.
309b44ed68449, 84d2d1641b71d). None address the O(N²) issue.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
Record: fs/smb/server/ (ksmbd) - in-kernel SMB3 server, network-exposed
on TCP/445. IMPORTANT criticality (anyone running ksmbd server is
exposed).

**Step 7.2: Activity**
Record: Active subsystem with regular security fixes; this fix is part
of a broader security hardening cycle (per 2026-04-23 pull request).

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected users**
Record: All systems running ksmbd (config-dependent - requires
CONFIG_SMB_SERVER=y and active share). Any SMB client with valid
credentials + any opened file can trigger.

**Step 8.2: Trigger**
Record: Single authenticated SMB2 LOCK request with LockCount=65535.
Easily crafted; attacker needs SMB credentials (guest accounts would
qualify on permissive shares).

**Step 8.3: Failure severity**
Record: CPU exhaustion / worker thread hang / service DoS - **HIGH
severity** (service unavailability from network). Not data
corruption/UAF, but a reliable, cheap DoS against network-exposed
service.

**Step 8.4: Benefit vs risk**
Record: Benefit = HIGH (closes a cheap DoS vector in network service).
Risk = VERY LOW (1 functional line, spec-backed cap, legitimate clients
don't exceed this). Excellent benefit/risk ratio.

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**
- FOR: Network-reachable DoS; trivial surgical fix; Acked by maintainer;
  applies to all stable trees; vulnerability present since v5.15;
  explicit maintainer description as "denial of service" fix; spec-
  justified cap.
- AGAINST: Requires authentication (but many deployments allow guest);
  no CVE assigned yet.

**Step 9.2: Stable rules**
1. Obviously correct & tested: YES (Acked-by maintainer, spec-justified
   cap)
2. Fixes a real bug: YES (authenticated DoS of network service)
3. Important issue: YES (security/availability)
4. Small & contained: YES (1 functional line + comment)
5. No new features: YES
6. Applies cleanly: YES (identical context in all stable trees)

**Step 9.3: Exception categories**
N/A - this is a straightforward bug/security fix.

**Step 9.4: Decision**
Strong YES. A one-line cap that kills a trivially-triggerable O(N²)
network DoS in an in-kernel SMB server, acked by the maintainer, applies
cleanly to every stable tree that has ksmbd.

## Verification

- [Phase 1] Parsed tags: Acked-by Namjae Jeon (ksmbd maintainer,
  verified via MAINTAINERS file for fs/smb/server/), Signed-off-by Steve
  French (CIFS/samba maintainer).
- [Phase 2] Diff analysis confirmed via Read: only functional change is
  adding `|| lock_count > 64` to an existing `if` at line 7494 in
  current tree; rest is a 5-line comment.
- [Phase 3] git log `fs/smb/server/smb2pdu.c`, git show
  v5.15/v6.1/v6.6/v6.12/v7.0 for the smb2_lock function - confirmed
  identical `if (!lock_count)` pattern in every stable tree.
- [Phase 3] Verified the nested O(N²) `list_for_each_entry(cmp_lock,
  &lock_list, llist)` inside `for (i = 0; i < lock_count; i++)` is
  present in v5.15 through v7.0.
- [Phase 4] WebFetch https://yhbt.net/lore/linux-
  cifs/?q=ksmbd+unbounded+LockCount - found the patch submission and
  Namjae Jeon's "Applied it to #ksmbd-for-next-next" reply.
- [Phase 4] WebFetch Steve French's [GIT PULL] ksmbd server fixes on
  2026-04-23 containing the commit, describing it as "cap maximum lock
  count to avoid potential denial of service".
- [Phase 4] b4 dig -c <hash> not usable because the commit is not in the
  local repo (it is a candidate from a future/incoming pull request).
- [Phase 5] Grep for `smb2_lock` - confirmed dispatched via
  `smb2ops.c:191` as SMB2_LOCK_HE command handler.
- [Phase 5] Read fs/smb/server/smb2misc.c lines 168-197 confirmed
  LockCount is sanity-checked against buffer size (16MB) but not against
  u16 range, so 65535 locks pass validation.
- [Phase 6] git log stable branches confirmed the vulnerable pattern
  exists in 5.15.203, 6.1.169, 6.6.135, 6.12.83, 7.0.1.
- [Phase 8] struct smb2_lock_element size (8+8+4+4=24 bytes) verified
  via fs/smb/common/smb2pdu.h - max buffer-bounded LockCount exceeds
  65535, so u16 max is reachable.
- UNVERIFIED: No CVE has been assigned (not verifiable from available
  data); not needed for decision.
- UNVERIFIED: Exact perf impact in seconds per 65535-lock request
  (commit message claims ~2.1 billion iterations; verified arithmetic
  65535*65536/2 ≈ 2.15×10⁹ matches).

This is a classic stable-candidate fix: small, obvious, maintainer-
acked, closes a cheap network-triggerable DoS against ksmbd that has
been exploitable since v5.15.

**YES**

 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ad5559d48975b..660dfefeba8e7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7473,7 +7473,12 @@ int smb2_lock(struct ksmbd_work *work)
 	lock_ele = req->locks;
 
 	ksmbd_debug(SMB, "lock count is %d\n", lock_count);
-	if (!lock_count) {
+	/*
+	 * Cap lock_count at 64. The MS-SMB2 spec defines Open.LockSequenceArray
+	 * as exactly 64 entries so 64 is the intended ceiling. No real workload
+	 * comes close to this in a single request.
+	 */
+	if (!lock_count || lock_count > 64) {
 		err = -EINVAL;
 		goto out2;
 	}
-- 
2.53.0

