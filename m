Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD60755CE8A;
	Mon, 19 Oct 2026 13:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418241; cv=none; b=meG8y8WFfLQiKIbFu0K74YBofOkl675cJuXPXksRZUB+uITyGfIAx8XFsUmEz1Tqwt3kE4wi4h7KNnTcs9HaAgntZbIBOZ3HjNhpcyQnBjVN+g0TjuU+leUkFs7Wk8OCl5p9g2DpiMBs4frGuUQ1XRHyZjoT6Rlf78OuorHZHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418241; c=relaxed/simple;
	bh=lllUlP1QonrTirlCoHP92O/x64/muos+cHM+k1w8JyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npA6mA/0a8IHrvphG+bVmk9JTcfunA9byzuhCHfHVjEgwEnsxk+FFlTE1AkX0j8g792EiGyJeyHbEscvyYiNngdjC5IJTR2zw3uSuB5AgGbcJqpRGKwaxugbP7ri3nwZ9US7zYmIiOVrM79erCmD1rLxWP7U2Fbww9qf0oQ/q6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzYo2Eyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzYo2Eyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF81F000C4;
	Mon, 19 Oct 2026 13:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418237;
	bh=NOLY40vBr3l0eZcVND2O1VKq9S6GQPH/WQtkykAh8/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzYo2EylKwwp/h1b/TPMs9WTGtlSM4iGFAkiXKULlQc/sUcMD+DiBa2XeNW6YOZRr
	 iIPXtZ9DBEAuIXviPQnje6CZcALvqgL4phEH0v832l8s97xi6Qqfl2J/9qeQqUANaE
	 ccFH1ER2Qe5rSrOE+8wx3X5pOA38DG0NzdajtmL/lW27Nm0wHd8wZpNhyZla0Mtqp/
	 IE5so/gWCuxRYx3iJ3b9zUMcjK4l62Ex1IVsMu+j3Q+xBpxuJ75yhaD3b2L07fqL8c
	 s+z4M4iCjgE7/zkGcaUsK26dU0W8FmnlsgwU0NNglpBm+hF/vgbdDRD4Xu8mXl1Kex
	 zb7zwaUlD/bog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: handle allocated range queries on dense files
Date: Mon, 19 Oct 2026 09:46:41 -0400
Message-ID: <20261019135441.1420968-110-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 350684e0498512d06963858b810101f58563810b ]

FSCTL_QUERY_ALLOCATED_RANGES currently relies on SEEK_DATA and SEEK_HOLE
for every file. That works for files with holes, but it is not a good
match for dense files.

A zeroed range in a dense file may be represented as an unwritten extent
and skipped by SEEK_DATA. The server can then return no allocated ranges
even though the file should still be treated as allocated from the
protocol point of view.

For dense files, report the requested range clipped to EOF as allocated
instead of probing holes. Keep using SEEK_DATA and SEEK_HOLE for files
marked with FILE_ATTRIBUTE_SPARSE_FILE, and wait for writeback before
probing so punch-hole updates are visible to the filesystem seek
implementation.

This fixes the case where a query after zeroing data could return no
ranges for a dense file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Local tree is **6.12.111** (`pending-6.12`). The buggy
`ksmbd_vfs_fqar_lseek()` path is in this checkout; the candidate is not.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ksmbd] [handle] FSCTL_QUERY_ALLOCATED_RANGES on dense (non-
sparse) files should not use SEEK_DATA/SEEK_HOLE**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd
  maintainer)
- No Fixes, Reported-by, Tested-by, Reviewed-by, Acked-by, Link, or Cc:
  stable
- Ignore pipeline markers (none in the provided message besides the
  evaluation copy)
- Notable: maintainer-authored; no syzbot/CVE tags

Upstream SHA recovered from GitHub:
`350684e0498512d06963858b810101f58563810b` (Namjae Jeon, 2026-07-11;
+26/-3 in `fs/smb/server/vfs.c`). Merged via ksmbd-for-7.3-rc1.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** FSCTL_QUERY_ALLOCATED_RANGES always uses SEEK_DATA/SEEK_HOLE.
  After FSCTL_SET_ZERO_DATA on a dense file, ksmbd uses
  `FALLOC_FL_ZERO_RANGE`, which can leave unwritten extents. SEEK_DATA
  skips those, so the server can return **no allocated ranges**.
- **Symptom:** Protocol-incorrect empty range list after zeroing a dense
  file. Copy/backup clients that copy only allocated ranges can skip the
  zeroed region and leave **stale data** on the destination.
- **Root cause:** Linux SEEK_DATA treats unwritten extents as holes; SMB
  dense files must still be reported as allocated (MS-FSA).
- **Fix:** For non-sparse files, return the request clipped to EOF as
  one allocated range. For sparse files, keep SEEK_DATA/SEEK_HOLE and
  `file_write_and_wait_range()` first so punch-hole is visible.
- **Versions:** No version listed. Code has been in tree since cifsd
  file ops (2021).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Subject “handle” plus body “This fixes
the case where a query after zeroing data could return no ranges” is an
explicit protocol/correctness fix. Extra i_size clipping (`start >=
size`, `!length`, `i_size_read`) is a real underflow/EOF-handling
improvement in the same function.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/smb/server/vfs.c` only (+26/-3; GitHub)
- Function: `ksmbd_vfs_fqar_lseek()`
- Scope: single-function surgical change
- `ksmbd_vfs_zero_data()` is **not** modified (only described as context
  in the message)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **EOF clip (before):** `if (start + length > inode->i_size) length =
  inode->i_size - start` using unlocked `inode->i_size`. If `start >
  i_size`, length goes negative; the loop then does not run.
- **EOF clip (after):** `size = i_size_read(inode)`; return 0 if `start
  >= size` or `!length`; then clip `length` to `size - start`.
- **Dense path (before):** always SEEK_DATA/SEEK_HOLE.
- **Dense path (after):** if `!(m_fattr &
  FILE_ATTRIBUTE_SPARSE_FILE_LE)`, write one
  `FILE_ALLOCATED_RANGE_BUFFER` for `[query_start, query_length]` and
  return.
- **Sparse path (after):** `file_write_and_wait_range(f, start, end-1)`
  then the existing SEEK loop.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic/protocol correctness (allocated-range under-
  reporting), plus sparse writeback visibility
- **Mechanism:** `iomap_seek_data()` treats `IOMAP_UNWRITTEN` as a hole
  unless pagecache has data (`fs/iomap/seek.c`). `FALLOC_FL_ZERO_RANGE`
  on dense files creates unwritten extents → SEEK_DATA returns `-ENXIO`
  → empty SMB range list.
- MS-FSA (FSCTL_QUERY_ALLOCATED_RANGES): if `Open.Stream.IsSparse` is
  FALSE, return a single range of the requested offset/length. Win32:
  non-sparse files return one entry covering the request.
- Sparse writeback: after punch-hole, seek can see stale extents until
  writeback.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Dense shortcut matches MS-FSA and is easy to verify.
- `in_count` is already rejected as 0 before `ranges[0]` is written.
- `file_write_and_wait_range()` exists in this tree
  (`include/linux/fs.h`) and `vfs.c` already includes `linux/fs.h`.
- **Regression risk:** non-sparse files that still have Linux holes
  (write-beyond-EOF, sparse attr cleared without materializing) will be
  reported as fully allocated. That matches Windows QUERY semantics;
  reads still return zeros. Bandwidth can increase for holey non-sparse
  files. Later mainline commit `25e414db7033` removed this shortcut for
  CIFS FIEMAP (see Phase 3).
- No new API, no lock-order change, no data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- SEEK_DATA/SEEK_HOLE loop: `f44158485826c0` (“cifsd: add file
  operations”, 2021-03-16; in tree 2021-05-10). Present since ksmbd was
  merged.
- `vfs_llseek(..., SEEK_DATA/SEEK_HOLE)`: `067baa9a37b32b` (2022).
- Dense vs sparse zeroing: original `f44158485826c0` already used
  PUNCH_HOLE for sparse and ZERO_RANGE for dense. `18e39fb960e6a` added
  `FALLOC_FL_KEEP_SIZE`.
- Bug is old, not post-6.12.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy code is the original fqar implementation,
ancestor of HEAD (`git merge-base --is-ancestor f44158485826c0 HEAD`
succeeded).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Candidate **not** in this tree (`git merge-base --is-ancestor
  350684e0498512d06963858b810101f58563810b HEAD` failed).
- Follow-up **not** in this tree:
  `25e414db703334954747cb1b3eedf914b093ff8c` “ksmbd: report holes in
  allocated range queries” (2026-07-26, +148/-46, 3 files).
- That follow-up **removes** the dense early-return, renames the helper,
  writes real zeros for dense SET_ZERO_DATA, and materializes holes when
  clearing sparse. It is a later redesign, not a prerequisite.
- Sibling “handle empty QUERY_ALLOCATED_RANGES output” is also absent;
  this patch does not need it (it does not touch `smb2pdu.c`).
- Current `ksmbd_vfs_fqar_lseek()` matches the pre-image of the
  candidate; apply is offset-only.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Namjae Jeon is the ksmbd maintainer. Recent local ksmbd work is
protocol/security fixes already on this branch. This commit is
maintainer-authored for 7.3-rc1, listed in the ksmbd pull as smbtorture-
validated protocol compatibility.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. Uses existing `i_size_read`,
`file_write_and_wait_range`, `FILE_ATTRIBUTE_SPARSE_FILE_LE`,
`ksmbd_vfs_fqar_lseek`. No rename, no new helper. Follow-up is larger
and depends on empty-output handling that 6.12 does not have; this
commit does not.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 350684e0498512d06963858b810101f58563810b`: lore.kernel.org
  returned errors; no thread URL.
- lore WebFetch: HTTP 403.
- Openwall `[GIT PULL] ksmbd server update for 7.3-rc1` (2026-08-23)
  lists this commit among allocated-range / sparse-file protocol fixes
  “validated with smbtorture”.
- GitHub commit page confirms the same message and +26/-3 vfs.c diff as
  the candidate.

UNVERIFIED: v1/v2 review comments, NAKs, explicit Cc: stable on the
original mail.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Commit has only the author’s SOB (Steve French did not SOB this
one; it went through Namjae’s ksmbd tree). `b4 dig -w` failed with lore
errors.

UNVERIFIED: original To/Cc list.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- No Reported-by on the commit.
- 2023 thread “Issues with FIEMAP, xfstests, Samba, ksmbd and CIFS”
  (lkml/fsdevel) describes the same class: SET_ZERO_DATA vs
  PUNCH_HOLE/ZERO_RANGE and SEEK_DATA/HOLE returning no allocated range.
- MS-FSA: non-sparse → single allocated range of the request.
- Win32 FSCTL_QUERY_ALLOCATED_RANGES: non-sparse output is one entry
  covering the requested range.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 7.3-rc1 cluster:
- persist/reject/allow FSCTL_SET_SPARSE
- handle empty QUERY_ALLOCATED_RANGES output
- **this commit**
- later: report holes in allocated range queries (`25e414db7033`)

This function-level change is self-contained. The follow-up replaces the
dense shortcut rather than depending on it.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search not available (403). No evidence
this was rejected for stable.

UNVERIFIED: stable@ discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `ksmbd_vfs_fqar_lseek()` only.

Step 5.2: TRACE CALLERS
Record: Single caller: `fsctl_query_allocated_ranges()` in
`fs/smb/server/smb2pdu.c`, from `smb2_ioctl()`
`FSCTL_QUERY_ALLOCATED_RANGES`. Userspace/SMB-client reachable (backup,
robocopy, CIFS FIEMAP, smbtorture). Not interrupt context.

Step 5.3: TRACE CALLEES
Record: After the patch: `i_size_read`, `file_write_and_wait_range`
(sparse only), `vfs_llseek(SEEK_DATA/SEEK_HOLE)` (sparse only). Zeroing
still goes through `ksmbd_vfs_zero_data()` →
`vfs_fallocate(FALLOC_FL_ZERO_RANGE)` for dense files.

Step 5.4: FOLLOW THE CALL CHAIN
Record: SMB2 IOCTL (authenticated session, valid file id) →
`fsctl_query_allocated_ranges` → `ksmbd_vfs_fqar_lseek`. Triggered by
normal Windows/Linux SMB clients. Combined with SET_ZERO_DATA on a non-
sparse handle, this is a realistic path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: CIFS client `smb3_llseek()` already special-cases non-sparse
files (`!(cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)` skips
QUERY_ALLOCATED_RANGES and treats the file as fully allocated) and
flushes before querying. Samba/Windows do the same for dense files.
ksmbd was the outlier.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `ksmbd_vfs_fqar_lseek()` at `fs/smb/server/vfs.c` still
always SEEK_DATA/SEEK_HOLE. Dense zeroing still uses
`FALLOC_FL_ZERO_RANGE`. Introduced 2021; this 6.12.111 tree has it.
`query_start` / dense early-return are absent.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply with line offset** (function is ~1015 here vs ~947
in the 7.3 pre-image). Surrounding function body matches the candidate
hunk. `file_write_and_wait_range` is present.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No “dense files”, “report holes”, or “empty QUERY_ALLOCATED”
commits in `fs/smb/server/`. Current empty `in_count == 0` still returns
`-EINVAL` in `fsctl_query_allocated_ranges`; unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **ksmbd (fs/smb/server)** — SMB3 in-kernel server. **IMPORTANT**
for NAS/embedded/enterprise SMB users; default `n` so not universal. Not
staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active on this branch (many recent protocol/security ksmbd
backports). This is long-standing protocol behavior, not a bug in brand-
new 7.3-only code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: ksmbd users (`CONFIG_SMB_SERVER`). Dense-file path hits handles
without `FILE_ATTRIBUTE_SPARSE_FILE` (FSCTL_SET_SPARSE off, no fake-
sparse DOS attr). Sparse path (writeback wait) hits sparse files,
including the common fake-fscaps sparse marking.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Dense bug: SET_ZERO_DATA (or other ZERO_RANGE) then
  QUERY_ALLOCATED_RANGES on a non-sparse file, on filesystems where
  unwritten extents are SEEK holes (ext4/xfs via iomap).
- Sparse writeback: QUERY after punch-hole before writeback.
- Authenticated SMB client; not unprivileged local syscall except via a
  mounted share.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: empty allocated-range list for data that SMB considers
  allocated (zeros). Copy/backup that skips holes can leave **old
  contents** instead of zeros.
- Severity: **HIGH** for data integrity of SMB copy/zero workflows; not
  a kernel oops/UAF.
- Sparse stale seek: wrong ranges until writeback; usually zeros-vs-
  holes, less severe.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** HIGH for ksmbd dense-file zero+query and Windows-
  compatible QUERY; writeback wait is a small sparse correctness win.
- **Risk:** LOW-MEDIUM. ~25 lines, one function. Behavior change: non-
  sparse files with Linux holes look fully allocated (MS-FSA-correct;
  more network copy of zeros, not stale data). Follow-up `25e414db7033`
  later dropped the shortcut for CIFS FIEMAP; that is a later redesign,
  not a crash report against this patch.
- Ratio: benefit outweighs risk on this 6.12 tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real protocol bug since 2021; present in 6.12.111
- Under-reporting allocated ranges after dense ZERO_RANGE can cause
  client copies to skip zeros → stale destination data
- Matches MS-FSA / Win32 / CIFS-client dense handling
- Small, contained, applies cleanly
- iomap SEEK_DATA skipping `IOMAP_UNWRITTEN` verified in this tree
- Sparse `file_write_and_wait_range` is independently correct and kept
  in later mainline
- Maintainer patch; listed in 7.3-rc1 ksmbd pull as smbtorture-related
  protocol work
- No new features/APIs

AGAINST:
- Not a kernel crash/UAF/deadlock
- Core dense shortcut was removed 15 days later in `25e414db7033`
  because CIFS FIEMAP saw holes as allocated
- No Fixes/Reported-by/Reviewed-by (absence expected; review thread
  UNVERIFIED due to lore)
- ksmbd is opt-in

UNRESOLVED:
- Original lore review/NAKs (lore 403, b4 dig failed)
- stable@ history

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — MS-FSA match; logic is local
   and readable. Testing claimed via 7.3-rc1 smbtorture set, not a named
   Tested-by.
2. Fixes a real bug that affects users? **PASS** — wrong
   QUERY_ALLOCATED_RANGES after zeroing dense files.
3. Important issue? **PASS** — application-level data integrity on
   copy/backup after SET_ZERO_DATA, not a panic. Severity HIGH for that
   path.
4. Small and contained? **PASS** — one function, ~25 lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy function present; hunk
   matches; helpers exist.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal bugfix.

Step 9.4: MAKE YOUR DECISION
This tree still has the 2021 SEEK_DATA-only QUERY path and dense
`FALLOC_FL_ZERO_RANGE`. The patch is the small MS-FSA-correct fix for
empty ranges after zeroing. The later mainline redesign is not a reason
to leave 6.12 returning no ranges; over-reporting allocation is safer
than under-reporting, and the follow-up is a larger 3-file change that
needs other 7.3 ksmbd work.

The problem is protocol-incorrect FSCTL_QUERY_ALLOCATED_RANGES on dense
files after zeroing, which can make copy/backup skip zeros and keep
stale data. It meets stable rules: real user-visible bug, small, no new
API, clean apply on this 6.12 tree. Risk is a Windows-correct change in
reported ranges for holey non-sparse files, not a crash.

Verification:
- [Phase 1] Subject/tags: ksmbd “handle”; only Namjae Jeon SOB; no
  Fixes/syzbot
- [Phase 1] Body: empty ranges after zeroing dense files via SEEK_DATA
  vs unwritten extents
- [Phase 2] Diff: +26/-3 `ksmbd_vfs_fqar_lseek` only; dense early-return
  + sparse writeback + i_size_read EOF clip
- [Phase 2] `fs/iomap/seek.c`: `IOMAP_UNWRITTEN` skipped by SEEK_DATA
  unless pagecache has data
- [Phase 2] MS-FSA: non-sparse returns one range; Win32 docs agree
- [Phase 3] blame: `f44158485826c0` (2021) introduced fqar SEEK loop;
  ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor 350684e04985 HEAD` → not in
  this tree
- [Phase 3] follow-up `25e414db7033` not in tree; removes dense
  shortcut; not required for this backport
- [Phase 3] current function body matches candidate pre-image (apply
  with offset)
- [Phase 4] b4 dig: lore errors, no thread; openwall 7.3-rc1 pull lists
  the commit
- [Phase 4] UNVERIFIED: original review comments / stable@
- [Phase 5] only caller `fsctl_query_allocated_ranges` ← SMB2
  FSCTL_QUERY_ALLOCATED_RANGES
- [Phase 5] CIFS client already special-cases non-sparse files in
  `smb3_llseek()`
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] `file_write_and_wait_range` declared in
  `include/linux/fs.h`; `vfs.c` includes `linux/fs.h`
- [Phase 8] Failure mode: empty allocated ranges after dense zero →
  skipped copy → stale data; HIGH for that SMB path

**YES**

 fs/smb/server/vfs.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f894092901bc5..cd0d3c13da3e7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1034,7 +1034,8 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
-	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end;
+	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end, query_start;
+	loff_t query_length, size;
 	loff_t extent_start, extent_end;
 	int ret = 0;
 
@@ -1050,11 +1051,33 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 	if (length > maxbytes || (maxbytes - length) < start)
 		length = maxbytes - start;
 
-	if (start + length > inode->i_size)
-		length = inode->i_size - start;
+	size = i_size_read(inode);
+	if (start >= size)
+		return 0;
+
+	if (!length)
+		return 0;
+
+	if (start + length > size)
+		length = size - start;
 
 	*out_count = 0;
+	query_start = start;
+	query_length = length;
 	end = start + length;
+	if (!(fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)) {
+		ranges[0].file_offset = cpu_to_le64(query_start);
+		ranges[0].length = cpu_to_le64(query_length);
+		*out_count = 1;
+		return 0;
+	}
+
+	if (start < end) {
+		ret = file_write_and_wait_range(f, start, end - 1);
+		if (ret)
+			return ret;
+	}
+
 	while (start < end && *out_count < in_count) {
 		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
-- 
2.53.0

