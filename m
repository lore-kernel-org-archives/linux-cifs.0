Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E901F568FC7;
	Mon, 31 Aug 2026 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184093; cv=none; b=crsuEOjLesW/RrGzwg0X+kctf3xV4LMY2GC8l3RZ8EMs+mUK1K8PsUpuLAPwBuggW5lkvzYiwMmHma9NMmMIB6bH7TngYID0Kc3b6AfXxnrTNXBIcm8/OxNDQilwkHZndggVrQolzS0OC1kTMuW+leBa+p/zj1hy9CN4JOkBksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184093; c=relaxed/simple;
	bh=z5n/K/m6fSx9G4/VNhIsilNx8BXYkXQy5ogj3Q73zMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GgMGEnm85ANqceuo4icSH6SHn1JaqYjbgA/ekSRrJmjwCTNQ9RzkFWmvbSfEUpU0wUJUe+C8fM8r3xP4XOCCtiZvdvzymnfFWsnUnYPuCIH7MyI7uDFJ1EHojQRv2vHSe5AIhAnEjLkvyn5yEgig79EgpcWeKHW9pWLcznsAezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRVoRpZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRVoRpZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760251F00A3E;
	Mon, 31 Aug 2026 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184090;
	bh=tqz2zyJS33LKAnCBHIvrjxX3OohRQsopJ0HI4znSklI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRVoRpZWC8wtHkBnUi8t5zGw9tn6TEUaknVrVUncWtGF40Fd6jeSGcdeaKBMTxZXZ
	 RqiZ3aNLJqGuJIwKJXkUXTT5W06kajcSRGFKdS7VwRRy8PSrFhN+sC6NvBgbeE+8vo
	 Z3sC5ypH1JO5YBfcHa43Twt75pEw+6wfvfF9hkQtByjvXzBvNHrgnZla1JKdXvj8Xr
	 g4QaKN0opuHqgMmHUJLUCe7Bzz7Y54CLTq9oAikXI8fvQKKCMfn+6MmZaVrBbl+Dxv
	 mp/G5X4hDM0umlRaUktY1OkJZmm8cnfF1lkAkjXle61Vv+EUMww2aXg+AB4dCbDHWh
	 RrrUIRDeSjQrw==
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
Subject: [PATCH AUTOSEL 6.18-6.6] smb/client: flush dirty data before punching a hole
Date: Mon, 31 Aug 2026 09:28:33 -0400
Message-ID: <20260831133314.4125787-485-sashal@kernel.org>
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

[ Upstream commit d7d2adcd022baade5cab65ca492ce63421ce3a6e ]

Punching a hole after a large buffered write may leave the range
reported as data. Reproduce it with:

  xfs_io -f \
    -c "pwrite -b 3m -S 0x61 0 3m" \
    -c "fpunch 1m 1m" \
    -c "seek -h 0" \
    -c "seek -d 1m" \
    /mnt/test/repro

Punching 1 MiB at offset 1 MiB should produce:

  0          1 MiB       2 MiB       3 MiB
  |  DATA    |   HOLE    |   DATA    | EOF

Instead, the entire file is reported as data. SEEK_HOLE(0) returns EOF,
and SEEK_DATA(1M) returns 1M.

This happens because a dirty folio spanning the punched range can be
written back after the punch and refill the hole.

Fix this by flushing and waiting for dirty data in the punched range
before invalidating the page cache and issuing FSCTL_SET_ZERO_DATA.

The xfstests generic/539 pass against Samba/ksmbd with this change.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `smb/client: flush dirty data before
punching a hole`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Linux 6.18.44 stable)
**Candidate commit:** `d7d2adcd022ba` (on `master`, not yet in this
checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[smb/client]` — implicit **fix** (flush before punch) —
ensure dirty folios are written back before punching a hole so hole
semantics are correct.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Huiwen He `<hehuiwen@kylinos.cn>` (author)
- **Reviewed-by:** ChenXiaoSong `<chenxiaosong@kylinos.cn>`
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` (maintainer
  commit)
- No Fixes:, Reported-by:, Link:, Cc: stable, Tested-by:, or Acked-by:
- Notable: maintainer-reviewed and committed; no syzbot/fuzzer
  involvement

### Step 1.3: Body analysis
**Record:**
- **Bug:** After a large buffered write, punching a hole in the middle
  can leave the entire file reported as data.
- **Symptom:** `SEEK_HOLE(0)` returns EOF; `SEEK_DATA(1M)` returns 1M
  instead of the expected `DATA | HOLE | DATA` layout.
- **Root cause:** A dirty folio spanning the punched range can be
  written back *after* the punch ioctl, refilling the hole in the page
  cache.
- **Reproducer:** `xfs_io` sequence with `pwrite -b 3m`, `fpunch 1m 1m`,
  then `seek -h` / `seek -d`.
- **Validation:** xfstests `generic/539` passes against Samba/ksmbd with
  this change.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — this is an explicit correctness fix for
page-cache coherency during `FALLOC_FL_PUNCH_HOLE`. The missing
`filemap_write_and_wait_range()` is an oversight relative to sibling
code paths in the same file.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/client/smb2ops.c` (+9 lines, 0 removed)
- **Function:** `smb3_punch_hole()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `filemap_invalidate_lock()` → `truncate_pagecache_range()`
  → `netfs_wait_for_outstanding_io()` → `FSCTL_SET_ZERO_DATA`
- **After:** `filemap_invalidate_lock()` →
  **`filemap_write_and_wait_range(offset..offset+len-1)`** → on error
  `goto unlock` → then same truncate/ioctl path
- **Path affected:** Normal punch-hole path after sparse-file setup;
  error path gains proper unlock on flush failure.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Cache coherency / logic correctness (stale dirty
  writeback refilling a punched hole)
- **Mechanism:** Page cache invalidated and server hole punched, but a
  dirty folio spanning the range was not flushed first; later writeback
  repopulates the “hole” locally, breaking `SEEK_HOLE`/`SEEK_DATA`
  semantics.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — mirrors the existing pattern in
  `smb3_zero_range()` in the same file (lines 3384–3400).
- **Regression risk:** Low — `filemap_write_and_wait_range()` under
  `filemap_invalidate_lock()` is already used in `smb3_zero_range()` and
  other fallocate paths in this file; error handling uses existing
  `unlock` label.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Punch-hole invalidation block (`filemap_invalidate_lock`
through `truncate_pagecache_range`) introduced at `5d324e5159d9e` (6.18
merge, Nov 2025). Bug has been present since that code landed in this
tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: File history
**Record:** Recent related commits in this tree include `d0bfd7004a87f`
(preserve `smb2_set_sparse()` errors) and `7e08ab7a061b1` (overlapping
allocated ranges in fallocate). This fix is standalone; `git format-
patch -1 d7d2adcd022ba | git apply --check` succeeds on HEAD.

### Step 3.4: Author context
**Record:** Huiwen He has multiple smb/client fixes in this tree
(`d0bfd7004a87f`, `7e08ab7a061b1`, `74badb5e2b00a`). Steve French is the
CIFS/SMB maintainer and committed this patch.

### Step 3.5: Dependencies
**Record:** No dependencies. v2 lore note says “Rebased onto cifs-2.6
for-next, No functional changes.” Applies cleanly to 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260715013901.156851-1-huiwen.he@linux.dev
- **Series:** v1 (2026-07-14) → v2 (2026-07-15, committed version)
- **Reviewer feedback:** No NAKs or objections in thread mbox; v2 only
  rebased
- **Stable nomination:** None found in thread

### Step 4.2: Reviewers
**Record:** CC'd to Steve French, linux-cifs maintainers/contributors
(linkinjeon, dhowells, etc.), and `linux-cifs@vger.kernel.org`.
Reviewed-by ChenXiaoSong.

### Step 4.3: Bug report
**Record:** Reproducer provided in commit message; validated by xfstests
`generic/539`. No external bugzilla/syzbot link.

### Step 4.4: Related patches
**Record:** Standalone 1-patch series; not part of a multi-patch
dependency chain.

### Step 4.5: Stable list
**Record:** Not searched on lore stable (WebFetch blocked by bot
protection); no stable discussion found in b4 mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `smb3_punch_hole()` (modified); callers: `smb3_fallocate()`.

### Step 5.2: Callers
**Record:**
- `smb3_fallocate()` → when `mode & FALLOC_FL_PUNCH_HOLE`
- `smb3_fallocate` registered as `.fallocate` in SMB2/SMB3 ops tables
- Reached from `cifs_fallocate()` in `cifsfs.c` via VFS `fallocate()`
  syscall
- Userspace-triggerable on CIFS/SMB mounts

### Step 5.3: Callees
**Record:** `smb2_set_sparse()`, `filemap_invalidate_lock()`,
**`filemap_write_and_wait_range()`** (added),
`truncate_pagecache_range()`, `netfs_wait_for_outstanding_io()`,
`SMB2_ioctl(FSCTL_SET_ZERO_DATA)`.

### Step 5.4: Reachability
**Record:** `fallocate(FALLOC_FL_PUNCH_HOLE)` from userspace on SMB-
mounted files. Common for databases, VM images, backup tools doing thin-
provisioning/space reclamation.

### Step 5.5: Similar patterns
**Record:** Strong precedent in same file:
- `smb3_zero_range()` already calls `filemap_write_and_wait_range()`
  before `truncate_pagecache_range()` (lines 3388–3400)
- `smb3_llseek()` documents “dirty pages … might fill holes on the
  server” and flushes before `FSCTL_QUERY_ALLOCATED_RANGES` (lines
  3888–3898)
- Punch hole was the outlier missing this flush.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `smb3_punch_hole()` at lines 3459–3465
lacks `filemap_write_and_wait_range()` before cache invalidation. Bug
present since punch-hole code landed in 6.18.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passes. No structural
conflicts with recent `d0bfd7004a87f` sparse-error fix.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in HEAD. `git log HEAD --grep='flush
dirty'` returns nothing for this file. Fix exists only on `master` as
`d7d2adcd022ba`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **fs/smb/client** (CIFS/SMB client) — **IMPORTANT**. Affects
users of network filesystem mounts; not universal like VFS core, but
widely deployed in enterprise/desktop.

### Step 7.2: Activity
**Record:** Actively maintained; multiple smb/client fixes in recent
6.18.y history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of CIFS/SMB mounts who use
`fallocate(FALLOC_FL_PUNCH_HOLE)` — databases, QEMU/img tools,
backup/dedup software, anything using `SEEK_HOLE`/`SEEK_DATA` after
punch.

### Step 8.2: Trigger conditions
**Record:** Buffered write creating a dirty folio spanning the punch
range, followed by punch hole on the same file. Reproducible with
`xfs_io`. Requires SMB mount with punch-hole support; not theoretical.

### Step 8.3: Failure mode severity
**Record:** Incorrect hole/data extent reporting; stale writeback can
refill punched regions in the page cache. **Severity: HIGH** for
correctness (not a kernel oops, but breaks filesystem semantics and can
defeat space reclamation). Analogous to known CIFS cache-coherency
issues already handled in `smb3_llseek`.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for SMB users relying on punch-hole semantics
- **Risk:** LOW — 9 lines, established API/pattern, maintainer-
  committed, xfstests-validated
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible bug with clear root cause
- Breaks `SEEK_HOLE`/`SEEK_DATA` after punch hole
- Fix mirrors existing code in `smb3_zero_range()` and `smb3_llseek()`
  in the same file
- Small (9 lines), surgical, applies cleanly to 6.18.44
- Reviewed and committed by subsystem maintainer
- xfstests `generic/539` validation
- Userspace-reachable via `fallocate()` on SMB mounts

**AGAINST backport:**
- No crash/panic/security issue — correctness/semantics bug
- No explicit stable nomination in lore thread

**Unresolved:** No independent Tested-by beyond author's xfstests claim;
lore replies not fully readable via WebFetch (bot protection). Neither
affects the technical decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors sibling functions;
   xfstests cited
2. Fixes a real bug affecting users? **PASS** — reproducible with xfs_io
3. Important issue? **PASS** — filesystem semantics/correctness on
   common network FS path (HIGH)
4. Small and contained? **PASS** — 9 lines, one function
5. No new features or APIs? **PASS** — adds missing flush only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard bug
fix).

### Step 9.4: Decision rationale

For Linux **6.18.y**, `smb3_punch_hole()` has been missing a dirty-page
flush that every related code path in the same file already performs.
Without it, punch hole can appear to succeed while the page cache is
later repopulated by writeback, breaking hole/data reporting. The fix is
minimal, follows an established in-tree pattern, applies cleanly, and is
maintainer-reviewed. This is appropriate stable material.

---

## Verification

- **[Phase 1]** `git show d7d2adcd022ba`: parsed full commit message and
  tags
- **[Phase 1]** No Fixes:/Reported-by:/Cc: stable tags found
- **[Phase 2]** `git show d7d2adcd022ba -p`: confirmed +9 lines in
  `smb3_punch_hole()`
- **[Phase 2]** Read `fs/smb/client/smb2ops.c` lines 3366–3502,
  3868–3920: confirmed `smb3_zero_range` has flush, `smb3_punch_hole`
  does not; `smb3_llseek` documents same issue
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9; Makefile
  VERSION=6 PATCHLEVEL=18 SUBLEVEL=44
- **[Phase 3]** `git blame -L 3459,3465 fs/smb/client/smb2ops.c`: punch-
  hole block from 5d324e5159d9e
- **[Phase 3]** `git log HEAD..master -- fs/smb/client/smb2ops.c`:
  d7d2adcd022ba present on master, not in HEAD
- **[Phase 3]** `git format-patch -1 d7d2adcd022ba | git apply --check`:
  applies cleanly
- **[Phase 3]** `git log --author='Huiwen' -10`: author has prior
  smb/client fixes in tree
- **[Phase 4]** `b4 dig -c d7d2adcd022ba`: lore URL found
- **[Phase 4]** `b4 dig -c d7d2adcd022ba -a`: v1→v2, no functional v2
  changes
- **[Phase 4]** `b4 dig -c d7d2adcd022ba -w`: Steve French and linux-
  cifs CC'd
- **[Phase 4]** `b4 dig -c d7d2adcd022ba -m /tmp/punch_hole_thread.mbx`:
  thread saved; Reviewed-by present; no stable Cc found
- **[Phase 4]** WebFetch lore URL: blocked by bot protection (Anubis)
- **[Phase 5]** `grep smb3_punch_hole fs/smb/client/`: caller is
  `smb3_fallocate` at line 4032
- **[Phase 5]** Read `cifsfs.c` `cifs_fallocate()`: VFS entry via
  `server->ops->fallocate`
- **[Phase 6]** Read current `smb3_punch_hole()` at lines 3440–3502:
  buggy code confirmed present
- **[Phase 6]** `git show v6.12:fs/smb/client/smb2ops.c | rg
  punch_hole`: function exists at v6.12 without flush (bug predates
  6.18.44)
- **[Phase 6]** `git log HEAD --grep='flush dirty'`: no existing fix in
  tree
- **[Phase 8]** Failure mode assessed as HIGH correctness impact on
  punch-hole/SEEK semantics

**YES**The background `git log -S` searches didn’t add much:

- **`smb3_punch_hole` search** (accidentally used `----all`) returned
  unrelated commits, not the punch-hole introduction.
- **`cifs_punch_hole` search** timed out on this large repo.

That didn’t change the conclusion. Targeted checks already showed
`smb3_punch_hole()` is present in this **6.18.44** tree without the
flush, matches the same pattern already used in `smb3_zero_range()` and
`smb3_llseek()`, and the fix applies cleanly from `d7d2adcd022ba`.

**Recommendation for 6.18.y: YES** — backport the flush-before-punch
fix.

 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 082e6334ab9f6..b62c5e49e1eb1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3457,6 +3457,15 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
+	/*
+	 * Flush dirty data first, otherwise a dirty folio spanning the punched
+	 * range may be written back after the ioctl and refill the hole.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto unlock;
+
 	/*
 	 * We implement the punch hole through ioctl, so we need remove the page
 	 * caches first, otherwise the data may be inconsistent with the server.
-- 
2.53.0

