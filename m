Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D975053EC;
	Mon, 31 Aug 2026 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183735; cv=none; b=p9j0367/v1EqVA3zQO0LbwvZMSsiYp571Jwqo8fj1W6qRaJrzkHGL3FYqryVOYjk5Gqn48SJibGXTV3yaYz11GM3KKpHjDtBkW0eWnnAByQN7yj5R4HvDgk4VzeuBUpXYsZQYnViCFSqRKHIj/+9DxMn5sK92+1t7mZBvG9Q/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183735; c=relaxed/simple;
	bh=T4pQVF0gppIWRQs+z05Dgb1ezZ53EVDpIf69+u6LnSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6XaI8hzibckMNqb5L7VCg1e/Yj2IgM/w4XoisF1Qt4E9N3eS0xCfs3d1RScyMOXX17AYwv0G7KuK5Vugj0W9Ex5yHY+1O9nvzgK2Ds12MT43rZkbxIeBN7q+X2soszGDzdUDVr+6vrWjvZpoS8TYdJY/m9VUInlGflKp5ifG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFXdORCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFXdORCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936151F00A3E;
	Mon, 31 Aug 2026 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183733;
	bh=jellvt5BpGCHjTqc0FikT8p18tua4sXlDCfnakxaaTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFXdORCKh6RlrJmeGYaV2cEB8qRW0tmGiHtTRBDoRJ0d91OvFPmlhtEhz5/I7d/uN
	 A1QVkwZ3a/KS9YPU3zf/LHW9VVtIG/r4PvhuRUlsbZ5VXTWdzDZ82hgp4sRA2qXzi0
	 HnHImqObsb90fE1viUvcaP5SwlnJ5LLuqLfPYO5cGGd5wBr0bQF+yQRlDzbz+erqHT
	 Pu8rtBvo9bbLklhffvu/sNKhjof7i9deGgEnUrilFNXjmlZdK4/YUxv/YI7yWsWC5o
	 dClVlNdByqeQfnW5OGvANW+2fnwbD1RXq/ZKnTQivHJtwDYoj5CypbKqN1YFyFmjPP
	 Z3rWT0msJXGfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] smb/client: reduce fallocate zero buffer allocation
Date: Mon, 31 Aug 2026 09:24:59 -0400
Message-ID: <20260831133314.4125787-271-sashal@kernel.org>
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

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 9e4ec3be67af41ab859302d7109b34976efd9258 ]

The fallocate emulation allocates a 1 MiB zero-filled buffer even
though each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE,
which is 64 KiB. A high-order 1 MiB allocation is more likely to
fail on a fragmented system.

Allocate only the smaller of the requested range and SMB2_MAX_BUFFER_SIZE,
and reuse that zero-filled buffer for every write request. Also reject
a successful write that makes no progress to avoid looping indefinitely.

This reduces the contiguous allocation required by fallocate emulation
without changing the written data or range semantics.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[smb/client]` `[reduce]` — Reduce the zero-filled buffer size
used by SMB3 fallocate emulation.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>` (author)
- `Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>`
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- Notable: maintainer review chain present; no explicit reporter or
  stable nomination

**Step 1.3 — Body analysis**
Record:
- **Bug:** `smb3_simple_fallocate_range()` allocates a 1 MiB zero buffer
  even though each `SMB2_write` is capped at `SMB2_MAX_BUFFER_SIZE` (64
  KiB). Large contiguous allocations are more likely to fail on
  fragmented systems.
- **Symptom:** `fallocate()` on CIFS/SMB mounts can return `-ENOMEM`
  unnecessarily; successful writes reporting 0 bytes can spin forever.
- **Root cause:** Over-allocation relative to per-write limit; buffer
  pointer advanced across a shrinking reusable zero buffer; no guard
  against zero-progress writes.
- **Version info:** None in the message.

**Step 1.4 — Hidden bug fix detection**
Record: **Yes.** Besides the allocation-size issue, it adds `if
(!nbytes) return -EIO;` to stop an infinite loop when `SMB2_write()`
succeeds but reports 0 bytes written, and removes `buf += nbytes` so a
smaller reused zero buffer stays valid.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `fs/smb/client/smb2ops.c`: +4 / −3 lines (7-line net change)
- Functions: `smb3_simple_fallocate_write_range()`,
  `smb3_simple_fallocate_range()`
- Scope: single-file surgical fix

**Step 2.2 — Code flow changes**
Record:
- **Hunk 1 (`smb3_simple_fallocate_write_range`):**
  - Before: `nbytes` was `int`; loop advanced `buf` on each write; no
    zero-progress check.
  - After: `nbytes` is `unsigned int`; zero-progress write returns
    `-EIO`; `buf` is not advanced (buffer reused).
- **Hunk 2 (`smb3_simple_fallocate_range`):**
  - Before: `kvzalloc(1024 * 1024, GFP_KERNEL)`
  - After: `kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE),
    GFP_KERNEL)`

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Resource allocation failure + logic/infinite-loop bug
- **Mechanism:** A 1 MiB buffer was allocated though writes are chunked
  to 64 KiB. After the prior `kvzalloc()` backport, kmalloc can still
  fail first and vmalloc fallback is heavier than needed. If
  `SMB2_write()` returns success with `DataLength == 0`, `while (len)`
  never advances and the syscall hangs.

**Step 2.4 — Fix quality**
Record: Fix is minimal and correct. Reusing the start of a zero-filled
buffer is semantically equivalent. Removing `buf += nbytes` is required
once the buffer shrinks below cumulative write size. Regression risk is
low.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record:
- 1 MiB allocation introduced with fallocate emulation (commit
  `966a3cb7c7db`, Jun 2021: "cifs: improve fallocate emulation")
- Current 1 MiB line changed to `kvzalloc` by `6cc1518357369` (Jul
  2026), already in this tree
- Write loop logic dates to merge `5d324e5159d9e` (Nov 2025)

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record:
- `6cc1518357369` — `kzalloc` → `kvzalloc` for same 1 MiB buffer (ENOMEM
  on fragmented systems, xfstests generic/013)
- `7e08ab7a061b1` — overlapping allocated ranges in fallocate (already
  in this tree)
- Target commit `9e4ec3be67af4` is **not** in this tree yet
- Standalone within a larger series (v8 3/5); does not require other
  series patches

**Step 3.4 — Author context**
Record: Huiwen He authored multiple SMB fallocate fixes; Steve French
(maintainer) committed. Same author area as `7e08ab7a061b1` already
backported here.

**Step 3.5 — Dependencies**
Record: No prerequisites beyond code already present. `git apply
--check` on `9e4ec3be67af4` against current tree succeeds.
`SMB2_MAX_BUFFER_SIZE` is 65536 in `fs/smb/common/smb2pdu.h`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 9e4ec3be67af4`:
  https://patch.msgid.link/20260703053300.913371-4-huiwen.he@linux.dev
- Matched as `[PATCH v8 3/5] smb/client: reduce fallocate zero buffer
  allocation`
- `b4 dig -a`: v1 through v8 revisions (Jun 23 – Jul 3, 2026); committed
  version is latest (v8)

**Step 4.2 — Reviewers**
Record: `b4 dig -w` CC'd Steve French, Ronnie Sahlberg, linux-
cifs@vger.kernel.org, and other SMB maintainers/reviewers.

**Step 4.3 — Bug reports**
Record: No direct bug report in this commit. Related prior fix
`6cc1518357369` documented xfstests generic/013 ENOMEM with stack trace
through `smb3_simple_falloc`.

**Step 4.4 — Series context**
Record: Part of Huiwen He's fallocate series, but this hunk is self-
contained and applies independently.

**Step 4.5 — Stable list history**
Record: No stable-list discussion found for this specific patch. Prior
related `6cc1518357369` explicitly had `Cc: stable@vger.kernel.org` and
was backported here.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `smb3_simple_fallocate_write_range()`,
`smb3_simple_fallocate_range()`, caller `smb3_simple_falloc()`

**Step 5.2 — Callers**
Record:
- `cifs_fallocate()` → `server->ops->fallocate()` →
  `smb3_simple_falloc()` → `smb3_simple_fallocate_range()` when `len <=
  1 MiB` on sparse internal regions
- Reachable from `fallocate()` syscall on CIFS/SMB mounts

**Step 5.3 — Callees**
Record: `SMB2_write()`, `SMB2_ioctl(FSCTL_QUERY_ALLOCATED_RANGES)`,
`kvzalloc()`, `kvfree()`

**Step 5.4 — Reachability**
Record: Userspace `fallocate()` on mounted SMB/CIFS shares with sparse
files and internal-hole preallocation (`len <= 1 MiB`). Unprivileged
users with write access can trigger it.

**Step 5.5 — Similar patterns**
Record: `6cc1518357369` addressed the same allocation site with
`kvzalloc()` fallback. This commit further right-sizes the buffer to the
actual per-write maximum.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
Current code at line 3564:

```3564:3564:fs/smb/client/smb2ops.c
        buf = kvzalloc(1024 * 1024, GFP_KERNEL);
```

Write loop still has `buf += nbytes` and no zero-progress guard. Bug
dates to 2021 fallocate emulation; partially mitigated by
`6cc1518357369`, not fully fixed.

**Step 6.2 — Backport complications**
Record: Clean apply verified with `git apply --check`. No conflicts
expected.

**Step 6.3 — Related fixes already present**
Record:
- `6cc1518357369` (`kvzalloc` for 1 MiB) — present
- `7e08ab7a061b1` (overlapping ranges) — present
- `9e4ec3be67af4` (this commit) — **not** present

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `fs/smb/client` — IMPORTANT (filesystem client, affects CIFS/SMB
users; not universal core)

**Step 7.2 — Subsystem activity**
Record: Active — multiple fallocate and client fixes recently backported
to this 6.18.y tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of CIFS/SMB mounts performing `fallocate()` on sparse
files (internal hole zero-fill path, `len <= 1 MiB`).

**Step 8.2 — Trigger conditions**
Record:
- Sparse SMB file + fallocate on internal unallocated range ≤ 1 MiB
- Allocation failure more likely under memory pressure/fragmentation
  (reduced but not eliminated by prior `kvzalloc` fix)
- Infinite loop if server returns successful write with `DataLength ==
  0` (unusual but possible misbehavior)

**Step 8.3 — Failure mode severity**
Record:
- `-ENOMEM` on fallocate: **MEDIUM** (syscall failure, no kernel crash)
- Infinite loop on zero-progress write: **CRITICAL** (hung `fallocate()`
  syscall / unkillable task)

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** HIGH for hang prevention; MEDIUM for allocation
  reliability and memory use
- **Risk:** VERY LOW (7-line change, maintainer-reviewed, applies
  cleanly)
- **Ratio:** Favorable

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

FOR backport:
- Fixes real hang (infinite loop on zero-progress `SMB2_write`)
- Reduces fallocate buffer from 1 MiB to at most 64 KiB on a path
  already deemed stable-worthy
- Small, surgical, maintainer-reviewed
- Applies cleanly to v6.18.44
- Complements existing `6cc1518357369` backport rather than duplicating
  it
- Userspace-reachable via `fallocate()`

AGAINST backport:
- Primary ENOMEM issue partially addressed by `6cc1518357369` already in
  tree
- No explicit user report, syzbot, or `Cc: stable` on this commit
- Zero-progress write scenario may be rare

UNRESOLVED:
- No independent confirmation of a production server returning
  `DataLength == 0` on success (defensive fix is still sound)

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; `Reviewed-
   by` present; no `Tested-by`
2. Fixes a real bug affecting users? **PASS** — hang + unnecessary
   allocation failures on `fallocate()`
3. Important issue? **PASS** — hang is critical; ENOMEM is medium
4. Small and contained? **PASS** — 7 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception categories**
Record: Not a device-ID/quirk/DT/docs exception; standard bug fix.

**Step 9.4 — Decision rationale**
This tree (6.18.44) still allocates 1 MiB for fallocate zero-fill
despite 64 KiB write chunks, and lacks protection against a zero-
progress write loop. The prior `kvzalloc()` backport mitigated physical-
contiguity failures but did not right-size the buffer or fix the loop.
The patch is tiny, low-risk, maintainer-approved, and addresses a
userspace-visible stability issue on a code path already receiving
stable backports.

---

## Verification

- [Phase 1] Parsed commit `9e4ec3be67af4` message and tags via `git
  show`
- [Phase 2] Analyzed full diff via `git show 9e4ec3be67af4 -p`
- [Phase 3] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`;
  `VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`
- [Phase 3] `git blame` on lines 3521–3537 and 3564 of `smb2ops.c`
- [Phase 3] `git show 966a3cb7c7db` — fallocate emulation origin (2021)
- [Phase 3] `git show 6cc1518357369` — prior `kvzalloc` fix with
  xfstests ENOMEM trace, `Cc: stable`
- [Phase 3] `git log --oneline` on `fs/smb/client/smb2ops.c` — related
  fallocate commits present
- [Phase 3] `git apply --check` on patch — applies cleanly
- [Phase 4] `b4 dig -c 9e4ec3be67af4` — lore URL found
- [Phase 4] `b4 dig -a` — v1–v8 series revisions listed
- [Phase 4] `b4 dig -w` — maintainers CC'd (Steve French, linux-cifs,
  etc.)
- [Phase 4] `b4 dig -m /tmp/fallocate_thread.mbox` — thread saved; no
  stable nomination found for this patch
- [Phase 5] Read `SMB2_write()` in `smb2pdu.c` — sets `*nbytes =
  le32_to_cpu(rsp->DataLength)` on success (lines 5208–5209)
- [Phase 5] Traced call chain: `cifs_fallocate()` →
  `smb3_simple_falloc()` → `smb3_simple_fallocate_range()`
- [Phase 5] `SMB2_MAX_BUFFER_SIZE` = 65536 in `fs/smb/common/smb2pdu.h`
- [Phase 6] Confirmed buggy `kvzalloc(1024 * 1024)` at line 3564 in
  current tree
- [Phase 6] Confirmed commit `9e4ec3be67af4` not in current tree (`git
  log --grep` empty on HEAD)
- [Phase 6] Confirmed `6cc1518357369` and `7e08ab7a061b1` already in
  tree
- [Phase 8] Failure modes: ENOMEM (medium), infinite loop (critical)

**YES**The master-branch search finished successfully. It found commit
`9e4ec3be67af4` ("smb/client: reduce fallocate zero buffer allocation")
on `master`, merged via `fce2dfa773ced`.

For this **6.18.44** tree, the verdict stands: **YES** for stable
backport. The patch is small, applies cleanly, and fixes a real
`fallocate()` hang risk (zero-progress `SMB2_write` loop) while right-
sizing the zero buffer from 1 MiB to at most 64 KiB — a useful follow-up
to the `kvzalloc()` fix already in this tree.

 fs/smb/client/smb2ops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5bbe98dc0529b..4b7bc048854d1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3508,7 +3508,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3529,9 +3529,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
 		if (rc)
 			break;
+		if (!nbytes)
+			return -EIO;
 		if (nbytes > len)
 			return -EINVAL;
-		buf += nbytes;
 		off += nbytes;
 		len -= nbytes;
 	}
@@ -3561,7 +3562,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.53.0

