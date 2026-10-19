Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D2A546278;
	Mon, 19 Oct 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418824; cv=none; b=NP9DfuRfrQraOM8VQQ/DcQBtCfhJRbFQvoNmHZbY3h34v0Nj2Toiv8Qw6BJAh8yrr3cpj5l9frCTIMQJ10/nngDAaA9QywuWuCQzCL2spOu/CtO2UBfnrCuhPCXE3H3Ua6IJgiMKE1Di1ydBrPQtJboy+r6KO29+WZ2sptU9An0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418824; c=relaxed/simple;
	bh=eIiTJCnbyurFWbexnYa44LpNvzRx5yq71nsTVY+qbPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJEN3Uqq3mA0dz0LC7vBp9eHfmtydtBtX9oUL4yCaYsdoEj36QOUYFQwWGRsNsAP4fU9bkDFf7ETWeX8pEvVtUNwIhFophadJkD63kzsa48fSP4wKqdFsMdzF2iSOynjHrqQMFECjzl8xAE8p//Z7Tn9RpJVHq+nughHR/8Ye5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOFNmjFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOFNmjFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC731F000C7;
	Mon, 19 Oct 2026 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418817;
	bh=56dMIbxR9eJy41+fq2GpRGFSyd+njYgwae4ZeSsn8ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOFNmjFNtXbodbWsrfan8Yfl82s8rwCq4WYVVzzwnw5a1gJ+lEAi3yLtxUMo+Fhdw
	 wxt6MzEXElIqIuzOBC9TVNSd5yQtK7HG+4UTVMQxTeyl3B3pm2JNbfmBWSdAfBe2s+
	 PnQ+JNGnEzCBXCPVezWQeU1NbmvevXu/iZjCXL21AG8+0njaU4YXqM0FwJ61kUPYn6
	 6iAgk5l1PASOplT2yspvZDOwzC/6NXW6sfPekn+15iamgQmpzBV1ykVY67QZjmFGTq
	 e76L/GE9XXq7wJOERwnTGGXprT9aumuYTBT13RNRKeCp4v1qLd3VuTdDe5vVt7Fcjo
	 g53L1szYqP8pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: fix SMB2 byte-range lock end offset
Date: Mon, 19 Oct 2026 09:53:29 -0400
Message-ID: <20261019135441.1420968-518-sashal@kernel.org>
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

[ Upstream commit 54d90311f9b4eb23f3b0b62650b0cfddb11a12ef ]

SMB2 describes a byte-range lock using an offset and a length, while
Linux file_lock uses an inclusive end offset. smb2_lock() currently sets
fl_end to start + length and consequently locks one extra byte for every
nonzero-length request.

Translate nonzero lengths to start + length - 1 and reject ranges that
cannot be represented by loff_t instead of silently truncating them at
OFFSET_MAX. Track zero-length locks from the request length so one-byte
ranges are not mistaken for zero-length locks after endpoint conversion.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The candidate is
mainline `54d90311f9b4e` (`ksmbd: fix SMB2 byte-range lock end offset`).
It is not in this checkout, and the buggy `smb2_lock()` conversion is.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ksmbd] [fix] [SMB2 byte-range lock end offset is off by one vs
Linux file_lock inclusive ends]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd
  maintainer)
- No Fixes:
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- No Link:
- No Cc: stable
Absence of Fixes/Cc:stable is expected for this review pipeline and is
not a negative signal.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: SMB2 describes a lock as (offset, length). Linux `file_lock` uses
  an inclusive `fl_end`. `smb2_lock()` sets `fl_end = start + length`,
  so every nonzero-length lock covers one extra byte.
- Symptom: adjacent-byte I/O or locks can hit a false conflict;
  unlock/lock ranges disagree with Windows/Samba; huge ranges are
  silently truncated at `OFFSET_MAX` instead of being rejected.
- Root cause: missing `length - 1` conversion, plus `start == end` used
  as a zero-length detector (that becomes wrong once 1-byte locks
  correctly get `start == end`).
- No kernel version called out in the message. Pull text for 7.3-rc1
  lists this among protocol-compatibility lock fixes.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit off-by-one / range-translation
bug fix, plus a necessary zero-length tracking correction so the
conversion does not reclassify 1-byte locks as empty.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/smb/server/smb2pdu.c` only (+14 / -30)
- Functions: `smb2_lock_init()`, `smb2_lock()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
1. `smb2_lock_init()`: stop inferring `zero_len` from `start == end`;
   take it from the SMB2 request length (`!lock_length`).
2. Range setup in `smb2_lock()`:
   - Before: clamp start/length to `OFFSET_MAX`, set `fl_end = start +
     length`, then reject wrap with `fl_end < fl_start`.
   - After: reject if start or inclusive end cannot be represented in
     `loff_t`; set `fl_end = start + length - 1` (or `start` if length
     is 0).
3. Zero-byte conflict tests: `< end` → `<= end` so the last locked byte
   is included.
4. Non-zero overlap test: ad-hoc half-open checks → standard inclusive
   overlap (`start1 <= end2 && start2 <= end1`), matching VFS
   `locks_overlap()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / correctness, plus bounds]
- Off-by-one: POSIX `fl_end` is inclusive (`fs/locks.c` uses `fl_end =
  fl_start + (l_len - 1)`).
- Classification: after that conversion, a 1-byte lock has `start ==
  end`. Using that as `zero_len` would skip `vfs_lock_file()` (`if
  (smb_lock->zero_len) goto skip`).
- Overflow: old code silently truncated at `OFFSET_MAX`; new code
  returns `STATUS_INVALID_LOCK_RANGE`.
- Conflict checks: old comparisons assumed exclusive-ish ends and missed
  some inclusive overlaps.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct. Same conversion as VFS
`flock_to_posix_lock()` and the CIFS client (`fl_end = start + (length ?
length - 1 : 0)`). Overlap test matches `locks_overlap()`. Minimal, no
API change. Regression risk is low: adjacent-byte I/O that was wrongly
denied will now succeed; unrepresentable ranges that were clamped will
now fail, which matches the spec.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Core `fl_end = fl_start + lock_length` comes from `e2f34481b24db2`
  (“cifsd: add server-side procedures for SMB3”, 2021-05-10), first in
  v5.15-rc1.
- `OFFSET_MAX` clamping: `50bf80a553ccb5` (“cifsd: fix xfstests
  generic/504 test failure”).
- `zero_len` / conflict checks: `d63528eb0d43c4` (Hyunchul Lee,
  2021-07-10).
The bug has been in ksmbd since the server was merged.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The introducing commit is in this tree (`git
merge-base --is-ancestor e2f34481b24db2 HEAD` succeeded).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Already in this tree: `f751d6e39d4c9` “ksmbd: Do not skip lock checks
  for single-byte ranges” — `check_lock_range()` uses inclusive `start +
  length - 1`. That makes the remaining `smb2_lock()` off-by-one more
  inconsistent, not less.
- Later on fs-next, not required here: `5ce5227cd60b7` “recognize
  replayed SMB2 lock sequences” (replay feature, not a prerequisite).
Standalone.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Namjae Jeon is the ksmbd maintainer (MAINTAINERS + Git). This is
not a drive-by change.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers. `smb2_lock_init()` has a single caller. `git
apply --check` of `54d90311f9b4e` succeeds on this tree (hunk offsets
only). Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 54d90311f9b4e` (with and without `-C`/`-a`):
  lore.kernel.org returned errors; no thread URL.
- WebFetch of lore.kernel.org: HTTP 403.
- LKML `[GIT PULL] ksmbd server update for 7.3-rc1` lists this commit in
  Namjae’s 7.3-rc1 pull, among lock/protocol-compatibility fixes.
UNVERIFIED: individual review comments, v2/v3 revisions, reviewer
Cc:stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Only the maintainer SOB is on the commit. `b4 dig -w` failed.
Subsystem maintainer authored it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by on this commit. Older ksmbd-tools issue #68 shows
real users hitting `smb2_lock` “end offset(ffffffffffffffff) is smaller
than the start offset” — the overflow path this patch now rejects
instead of wrapping. That report is historical (cifsd era), not a direct
report of this patch.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Adjacent 7.3 lock patches are replay/UAF/compound features. This
conversion fix does not depend on them. Related inclusive-range I/O fix
is already in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search could not be fetched (403). No
verified stable NAK. This tree does not already contain “lock end
offset”.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `smb2_lock_init()`, `smb2_lock()`

Step 5.2: TRACE CALLERS
Record:
- `smb2_lock()` is the SMB2_LOCK handler
  (`smb2_0_server_cmds[SMB2_LOCK_HE]` in `fs/smb/server/smb2ops.c`).
- `smb2_lock_init()` is only called from `smb2_lock()`.
Reachable from any SMB2/SMB3 client that issues LOCK.

Step 5.3: TRACE CALLEES
Record: `vfs_lock_file()`, `locks_free_lock()`, `smb_flock_init()`,
ksmbd connection lock-list walk. Zero-length locks still skip
`vfs_lock_file()` by design (POSIX `l_len == 0` means lock-to-EOF, which
is not SMB zero-byte lock semantics).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Network SMB2 LOCK → `smb2_lock()` → VFS POSIX locks / ksmbd lock
list → later `check_lock_range()` on read/write/truncate. Userspace-
reachable over the network. Not a rare config path if
`CONFIG_SMB_SERVER` is enabled.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same inclusive conversion already exists in `fs/locks.c` and
`fs/smb/client/cifssmb.c`. I/O-side `check_lock_range()` in this tree
already uses `pos + count - 1`. Only the LOCK request path was still off
by one.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `fs/smb/server/smb2pdu.c` around 7584–7602 still does
`fl_end = fl_start + lock_length` and `if (lock->start == lock->end)
lock->zero_len = 1`. Introduced with cifsd in v5.15, present in
6.12.111.
`git merge-base --is-ancestor 54d90311f9b4e HEAD` failed — the fix is
not here.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply (`git apply --check` succeeded; hunks at 7488+).
Nearby mainline-only context (`lock_count > 64`, `kzalloc_obj`) is not
part of this commit’s hunks. Expected difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Inclusive I/O lock checks (`f751d6e39d4c9`) are here. No prior
“lock end offset” fix. Applying this makes LOCK and I/O use the same
inclusive model.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [fs/smb/server (ksmbd)] [IMPORTANT for ksmbd users / PERIPHERAL
vs core VFS]. Byte-range locks are a core SMB feature for Windows apps,
databases, and exclusive file access. `CONFIG_SMB_SERVER` defaults to n.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; this 6.12 tree already carries many ksmbd
stable backports. The author is the maintainer.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: ksmbd/SMB3 server users (`CONFIG_SMB_SERVER`). Every SMB2 LOCK
with nonzero length.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Common for any client using byte-range locks (Office, databases,
installers, some build tools). Network-facing; an unprivileged SMB user
who can open a file can issue LOCK. Not a rare race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Over-lock of one extra byte → false `STATUS_FILE_LOCK_CONFLICT` /
  denied I/O on the adjacent byte; apps can fail or block. HIGH for
  ksmbd shares that use locking.
- Silent clamp of huge ranges → requested bytes past `OFFSET_MAX` stay
  unlocked. Integrity hole, rare offsets. MEDIUM.
- If this conversion were done without passing original `zero_len`,
  1-byte locks would skip VFS — that would be under-lock / data-race.
  The patch prevents that. HIGH if mishandled; the patch handles it.
Severity overall: HIGH for locking correctness, not a kernel oops.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: correct exclusive ranges vs Windows/Samba/VFS; fewer false
  conflicts; no silent truncation.
- Risk: very low (14/30 lines, one file, applies cleanly, matches
  established conversion).
- Ratio: strongly favors backporting.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real, long-standing off-by-one in mandatory SMB byte-range locks
  (since v5.15).
- User-visible false conflicts on the extra byte; protocol mismatch with
  Windows/Samba.
- Silent `OFFSET_MAX` truncation replaced by a spec-style invalid-range
  error.
- Zero-length vs 1-byte classification fixed so inclusive ends do not
  skip `vfs_lock_file()`.
- Overlap tests aligned with VFS `locks_overlap()`.
- Small, maintainer-authored, applies cleanly here.
- This tree already uses inclusive ends on the I/O path, so leaving LOCK
  wrong is inconsistent.

AGAINST:
- No crash/UAF/CVE; no Reported-by on this commit.
- ksmbd is opt-in, not core VFS.
- Could not retrieve the original review thread (lore errors).

UNRESOLVED:
- Original mailing-list review comments / explicit stable nomination.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — matches VFS and CIFS client
   math; maintainer SOB; in the 7.3-rc1 ksmbd pull.
2. Fixes a real bug that affects users? PASS — wrong lock coverage on
   every nonzero SMB2 LOCK.
3. Important issue? PASS — mandatory lock correctness (false conflicts;
   possible under-lock on truncated huge ranges). Not a panic, but it is
   data-access / sharing integrity.
4. Small and contained? PASS — one file, +14/-30.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — `git apply --check` clean; buggy
   code present.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
correctness fix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. The extra locked byte is a
real protocol bug on a path every locking SMB client hits. The patch is
small, correct, has no prerequisites that this tree lacks, and applies
cleanly.

Verification:
- [Phase 1] Parsed subject/body/tags on `54d90311f9b4e`; maintainer SOB
  only; no Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff: `smb2_lock_init` + `smb2_lock` in
  `fs/smb/server/smb2pdu.c`, +14/-30; inclusive `fl_end`, request-based
  `zero_len`, overlap `<=`.
- [Phase 2] Confirmed VFS conversion at `fs/locks.c:515-518` (`fl_end =
  fl_start + (l_len - 1)`) and `locks_overlap()` at 621-624.
- [Phase 2] Confirmed CIFS client uses the same formula at
  `fs/smb/client/cifssmb.c:2122-2124`.
- [Phase 2] Confirmed zero-len locks skip `vfs_lock_file()` at
  `smb2pdu.c:7742-7748` in this tree.
- [Phase 3] `git blame`: buggy `fl_end = start + length` from
  `e2f34481b24db2` (v5.15-rc1); clamp from `50bf80a553ccb5`.
- [Phase 3] `git merge-base --is-ancestor e2f34481b24db2 HEAD`
  succeeded; `54d90311f9b4e` is not an ancestor of HEAD.
- [Phase 3] Follow-up `5ce5227cd60b7` is lock-replay, not a
  prerequisite.
- [Phase 4] `b4 dig -c 54d90311f9b4e` failed (lore errors). LKML 7.3-rc1
  ksmbd pull lists this commit.
- [Phase 4] UNVERIFIED: original lore review thread (403/server error).
- [Phase 5] `smb2_lock` is `SMB2_LOCK_HE` proc; `smb2_lock_init` has one
  caller.
- [Phase 6] `make kernelversion` / Makefile: 6.12.111, branch
  `pending-6.12`, `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`.
- [Phase 6] Live code at `smb2pdu.c:7602` still uses `fl_start +
  lock_length`.
- [Phase 6] `git show 54d90311f9b4e | git apply --check` succeeded.
- [Phase 6] Related `f751d6e39d4c9` (inclusive I/O checks) is already in
  HEAD.
- [Phase 7] MAINTAINERS: ksmbd maintained by Namjae Jeon;
  `CONFIG_SMB_SERVER` default n.
- [Phase 8] Failure mode: false lock conflicts / incorrect coverage on
  SMB2 LOCK; severity HIGH for ksmbd locking users, not a kernel oops.
- UNVERIFIED: Could not read lore.kernel.org patch review or stable@
  discussion.

The extra-byte lock is a real, old ksmbd protocol bug. The fix is small,
matches VFS, and applies cleanly to 6.12.111.

**YES**

 fs/smb/server/smb2pdu.c | 44 +++++++++++++----------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 277c03fe2a4e4..ea5a130ef83ce 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7604,7 +7604,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 }
 
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
-					 unsigned int cmd, int flags,
+					 unsigned int cmd, int flags, bool zero_len,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -7618,8 +7618,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->start = flock->fl_start;
 	lock->end = flock->fl_end;
 	lock->flags = flags;
-	if (lock->start == lock->end)
-		lock->zero_len = 1;
+	lock->zero_len = zero_len;
 	INIT_LIST_HEAD(&lock->clist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -7712,32 +7711,18 @@ int smb2_lock(struct ksmbd_work *work)
 
 		lock_start = le64_to_cpu(lock_ele[i].Offset);
 		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_start > U64_MAX - lock_length) {
+		if (lock_start > OFFSET_MAX ||
+		    (lock_length &&
+		     lock_length - 1 > OFFSET_MAX - lock_start)) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
 			locks_free_lock(flock);
 			goto out;
 		}
 
-		if (lock_start > OFFSET_MAX)
-			flock->fl_start = OFFSET_MAX;
-		else
-			flock->fl_start = lock_start;
-
-		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_length > OFFSET_MAX - flock->fl_start)
-			lock_length = OFFSET_MAX - flock->fl_start;
-
-		flock->fl_end = flock->fl_start + lock_length;
-
-		if (flock->fl_end < flock->fl_start) {
-			ksmbd_debug(SMB,
-				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
-				    flock->fl_end, flock->fl_start);
-			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
-			locks_free_lock(flock);
-			goto out;
-		}
+		flock->fl_start = lock_start;
+		flock->fl_end = lock_length ?
+			flock->fl_start + lock_length - 1 : flock->fl_start;
 
 		/* Check conflict locks in one request */
 		list_for_each_entry(cmp_lock, &lock_list, llist) {
@@ -7753,7 +7738,8 @@ int smb2_lock(struct ksmbd_work *work)
 			}
 		}
 
-		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
+		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
 			locks_free_lock(flock);
@@ -7827,7 +7813,7 @@ int smb2_lock(struct ksmbd_work *work)
 				/* check zero byte lock range */
 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
 				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start < smb_lock->end) {
+				    cmp_lock->start <= smb_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("previous lock conflict with zero byte lock range\n");
@@ -7836,17 +7822,15 @@ int smb2_lock(struct ksmbd_work *work)
 
 				if (smb_lock->zero_len && !cmp_lock->zero_len &&
 				    smb_lock->start > cmp_lock->start &&
-				    smb_lock->start < cmp_lock->end) {
+				    smb_lock->start <= cmp_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("current lock conflict with zero byte lock range\n");
 					goto out;
 				}
 
-				if (((cmp_lock->start <= smb_lock->start &&
-				      cmp_lock->end > smb_lock->start) ||
-				     (cmp_lock->start < smb_lock->end &&
-				      cmp_lock->end >= smb_lock->end)) &&
+				if (cmp_lock->start <= smb_lock->end &&
+				    smb_lock->start <= cmp_lock->end &&
 				    !cmp_lock->zero_len && !smb_lock->zero_len) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
-- 
2.53.0

