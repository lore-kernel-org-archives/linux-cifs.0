Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175F861F3EF;
	Mon, 19 Oct 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418673; cv=none; b=qQTBnIVa7X0P/6EgW0S3pg58wWjkstywFFn5a/HFze8N98rNIxshEDTYEHfNiDcGq5iDneizOT6cLNDKie4D6e1ck6cdaqJOI1tVRb7zg/yiFH0PDHhYV6GooMx9UwW6KllKzSXxM9CVqSfaS5xbBoI1Fue3v4oBTtJzqUdEvf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418673; c=relaxed/simple;
	bh=wBT+UpiCNd4y3nsEHiyxuV0pRS8k2vPEQBoWPB6bhAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUQtfq5qMkdSidrpZVvOJta6LykVAEOhvhyBAxHqWIVK8RbA7N0jJIYNy72XPVfgAX88R68IwN8pVirOVQENyhnxwUp5WHgUr894qk1L3eSjLYViNqG1CnCB1nYNonAZiGFm2CNBRc8gLyb2DYkgtgvnbvV5QSucw7zMoEX233I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+7vYlvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+7vYlvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AE01F000C5;
	Mon, 19 Oct 2026 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418671;
	bh=JV/rBGGY22lnyRZ5ZT3jhnPWdk4mM9JkDPdi8J0tE0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+7vYlvfiHDWznQ15+mnb3nNpM99gMJFcKnsqVSxGkeQHcT4mBbbHeJPsHNcdH0NK
	 isb7PpFimJI9sda4fgGkxCyDI5hWqFav0icC1r6UMhjgpKM7p2KQ58+BHPH+H/BVCu
	 19OONQm8xvqOcA1HT23eLx2gaK5x5UKgfqaojuOMnbwbVkBGlaVrOqoyiiW71Lmy42
	 tfFbJ/XABXd5q0IR1lrTmE7aFrs1ITQGmsuev6gQN3VActVikRBHGPXlN86nBzWhVr
	 /HtMDMfbHQch+l/M1Q1J0Q+l9zVqpAcWBQJkJt5LfVC+1LLDRCZDiBdzh/6Y6U3gSF
	 i5uiQlACrh5Ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: honor byte-range locks for zero data
Date: Mon, 19 Oct 2026 09:51:45 -0400
Message-ID: <20261019135441.1420968-414-sashal@kernel.org>
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

[ Upstream commit 8b57448a147d2378088e63cd473e7f2a967d6802 ]

FSCTL_SET_ZERO_DATA changes file allocation state and must respect
byte-range locks over the affected part of the file. Check the requested
range, clipped to EOF, before issuing the fallocate operation.

Return STATUS_FILE_LOCK_CONFLICT when the range conflicts with an
existing lock. Ranges starting past EOF are left untouched by the lock
check so they continue to succeed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy
`FSCTL_SET_ZERO_DATA` path is present here, the lock helper already
exists, and the patch applies cleanly. This is a real lock-bypass data-
integrity bug, not a new feature.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ksmbd] [honor] honor byte-range locks for FSCTL_SET_ZERO_DATA`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Original commit: `8b57448a147d2378088e63cd473e7f2a967d6802` (Namjae
Jeon, 2026-08-17)

Tags present:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (author + ksmbd
  maintainer)
- No `Fixes:`, `Cc: stable`, `Reported-by`, `Tested-by`, `Reviewed-by`,
  `Acked-by`, or `Link:` (absence of Fixes/Cc:stable is expected for
  this review)

Record: Maintainer-authored; no user/syzbot report tags.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `FSCTL_SET_ZERO_DATA` changes allocation (punch-hole / zero-
  range) without checking SMB byte-range locks.
- Symptom: a client can zero or punch a range another handle has locked;
  the locker does not get `STATUS_FILE_LOCK_CONFLICT`.
- Root cause: `ksmbd_vfs_zero_data()` calls `vfs_fallocate()` with no
  `check_lock_range()`.
- Intentional edge: ranges starting past EOF skip the lock check so they
  still succeed.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Explicit protocol/correctness fix:
missing lock enforcement on a mutating FSCTL.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `fs/smb/server/vfs.c`: +12 in `ksmbd_vfs_zero_data()`
- `fs/smb/server/smb2pdu.c`: +6/-1 in `smb2_ioctl()`
  `FSCTL_SET_ZERO_DATA`
- Total: 18 insertions, 1 deletion
- Scope: single-subsystem, two-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **vfs.c before:** break Level II oplocks, then
  `vfs_fallocate(PUNCH_HOLE or ZERO_RANGE | KEEP_SIZE)` with no lock
  check.
- **vfs.c after:** same, but for non-POSIX shares, if `off < i_size`,
  call `check_lock_range(filp, off, min(off+len, size)-1, WRITE)` and
  return `-EAGAIN` on conflict.
- **smb2pdu.c before:** any `ret < 0` goes to ioctl `out`, which maps
  unknown errors to `STATUS_INVALID_PARAMETER`.
- **smb2pdu.c after:** `-EAGAIN` sets `STATUS_FILE_LOCK_CONFLICT`, `ret
  = 0`, then `goto out` so the generic mapper does not overwrite the
  status.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: logic / protocol correctness, with data-integrity impact.
- Mechanism: SMB byte-range locks in ksmbd are POSIX locks;
  `vfs_fallocate()` does not consult them (verified in `fs/open.c`:
  permission/lease/overflow checks only). Read, write, truncate, and
  copychunk already call `check_lock_range()`; zero-data did not. A
  WRITE lock on another handle, or a READ lock vs this WRITE, is ignored
  and the range is zeroed/punched.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: high. Same pattern as `ksmbd_vfs_write()` /
  `ksmbd_vfs_truncate()` / `ksmbd_vfs_copy_file_ranges()`.
- `posix_extensions` skip matches those callers.
- Clipping to EOF avoids `start > end` if the request extends past EOF.
- Regression risk: low. Only behavioral change is rejecting previously-
  illegal zeroing of locked ranges. `ret = 0` plus pre-set status is a
  bit awkward versus adding `-EAGAIN` in the ioctl `out` mapper, but it
  works: `out` only overwrites status when `ret < 0 || Status == 0`, so
  `STATUS_FILE_LOCK_CONFLICT` is preserved and `smb2_set_err_rsp()`
  still runs.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `ksmbd_vfs_zero_data()` introduced by Namjae Jeon in 2021
  (`fs/cifsd/vfs.c`, blame `f44158485826c0` / `64b39f4a2fd293`).
- Never had a lock check. Present throughout 6.12.
- `override_creds` wrapper already in this tree via `fb1cae6302d58`
  (`ksmbd: use opener credentials for FSCTL mutations`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the original zero-data
implementation, not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Already in this tree: `f751d6e39d4c9` “Do not skip lock checks for
  single-byte ranges”; `ca53bb17f4e82` “add a permission check for
  FSCTL_SET_ZERO_DATA”; `fe20d492a69a6` lock-owner tracking.
- On `origin/master`, parent `3c707d4b3f926` (“fix permission checks for
  file allocation ioctls”) is independent (SPARSE/QUERY_ALLOCATED_RANGES
  access bits), not required for this lock check.
- No `patch X/Y` in the subject. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namjae Jeon is the ksmbd maintainer (`Signed-off-by` on both
authorship and merge). This tree already carries many of his ksmbd
stable fixes.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. `check_lock_range()` is `static` in the same `vfs.c`
(lines 325–358). `STATUS_FILE_LOCK_CONFLICT` already exists.
`posix_extensions` and `i_size_read`/`min()` are present. `git apply
--check` of `8b57448a147d2` succeeded (smb2pdu offset −1234, vfs.c
offset +71).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 8b57448a147d2`: lore returned server errors; no thread URL.
- WebFetch of lore.kernel.org search URLs: HTTP 403.
- UNVERIFIED: reviewer comments, v2/v3 history, explicit Cc:stable in
  review.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: UNVERIFIED via b4. Commit is maintainer-authored and merged to
`origin/master`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Bug is identified from
protocol analysis, not a crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Nearby `origin/master` ksmbd FSCTL work (`support file level
trim`, allocation ioctl permission, allocated-range holes) is related
thematically, not a hard dependency. Samba’s `fsctl_zero_data()` takes a
WRITE strict lock and returns `NT_STATUS_FILE_LOCK_CONFLICT` on failure
(source3/smbd/smb2_ioctl_filesys.c). That matches this fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED (lore 403). No local evidence this was rejected for
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ksmbd_vfs_zero_data()`, `smb2_ioctl()` (`FSCTL_SET_ZERO_DATA`),
callee `check_lock_range()`.

**Step 5.2: TRACE CALLERS**
Record:
- `ksmbd_vfs_zero_data()`: only `smb2_ioctl()` FSCTL_SET_ZERO_DATA
  (`fs/smb/server/smb2pdu.c:8548`).
- `smb2_ioctl()`: SMB2 command table `SMB2_IOCTL_HE` in
  `fs/smb/server/smb2ops.c`.
- Reachable from authenticated SMB clients issuing ioctl on an open
  writable handle.

**Step 5.3: TRACE CALLEES**
Record: `check_lock_range()` walks `flc_posix` under `flc_lock`;
conflicts if overlapping READ lock vs WRITE, or WRITE lock owned by
another `filp`. `vfs_fallocate()` does not check those locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: SMB2 IOCTL → `smb2_ioctl` → `ksmbd_vfs_zero_data` →
`vfs_fallocate` (punch/zero). Userspace/network reachable on any ksmbd
share without POSIX extensions (the common Windows-client case).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `!posix_extensions` + `check_lock_range` + `-EAGAIN`
pattern in `ksmbd_vfs_read` (396–400), `ksmbd_vfs_write` (521–527),
`ksmbd_vfs_truncate` (835–849), `ksmbd_vfs_copy_file_ranges`
(1854–1866). Zero-data was the missing sibling. Read/write/setinfo
already map `-EAGAIN` to `STATUS_FILE_LOCK_CONFLICT`; ioctl did not,
which is why smb2pdu.c is patched.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local `ksmbd_vfs_zero_data()` at
`fs/smb/server/vfs.c:995-1013` has no lock check. `git merge-base --is-
ancestor 8b57448a147d2 HEAD` failed (not in this tree). Bug present
since ksmbd’s 2021 introduction; well before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply with line offset. Local ioctl `out` mapper still
lacks `-EAGAIN`, so both hunks are required. No refactor blocking the
patch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Permission check for SET_ZERO_DATA is here (`ca53bb17f4e82`);
lock-check skip-for-1-byte fix is here (`f751d6e39d4c9`). Neither
implements this FSCTL lock check. No duplicate fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: ksmbd (`fs/smb/server`, `CONFIG_SMB_SERVER`, default n).
Criticality: IMPORTANT for ksmbd deployments (NAS, distros), not core
mm/VFS. File-server data path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; this 6.12 tree already backports many ksmbd
protocol, lock, and UAF fixes. Mature enough that missing lock checks
are long-standing, not new-code churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: ksmbd users, non-POSIX SMB shares, clients that use byte-range
locks and `FSCTL_SET_ZERO_DATA` (Windows sparse/zero APIs, some
databases/backup tools).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Handle A holds an SMB lock; handle B (or another client) issues
`FSCTL_SET_ZERO_DATA` overlapping that range with `FILE_WRITE_DATA`. Not
every I/O, but a realistic multi-client/multi-handle case. Authenticated
SMB user; not unprivileged local syscall.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Locked file data can be silently zeroed or punched. Failure
mode: data corruption / lock-semantics violation. Severity: HIGH (not a
kernel oops).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for ksmbd — restores lock integrity on a data-destroying
  FSCTL; aligns with Samba/Windows.
- Risk: very low — 18 lines, existing helper, applies cleanly, only
  rejects operations that should have failed.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: SET_ZERO_DATA ignores byte-range locks while
  read/write/truncate/copychunk do not.
- User-visible: silent zero/punch of locked ranges (data integrity).
- Samba returns `NT_STATUS_FILE_LOCK_CONFLICT` for the same FSCTL.
- Small, obviously correct, maintainer-authored.
- Helpers and surrounding lock policy already in 6.12; patch applies
  cleanly.
- This tree already backported the same class (`f751d6e39d4c9`) and
  SET_ZERO_DATA access control (`ca53bb17f4e82`).

AGAINST:
- No crash/UAF/syzbot report.
- ksmbd is optional (`CONFIG_SMB_SERVER`).
- No mailing-list confirmation (lore unreachable).
- Slightly weaker than Samba on past-EOF ranges (intentional per commit
  message).

UNRESOLVED:
- Original lore thread / reviewer NAKs (b4 and lore failed).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches existing ksmbd lock
   checks; maintainer SOB. (No extra Tested-by.)
2. Fixes a real bug that affects users? **PASS** — lock bypass on a
   mutating FSCTL.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   data corruption / exclusive-lock violation. HIGH, not panic.
4. Small and contained? **PASS** — 18/+1 lines, two files, one FSCTL.
5. No new features or APIs? **PASS** — enforces existing SMB lock rules.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/doc exception). Qualifies
as a normal important bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The 6.12 tree has the buggy path, the same
`check_lock_range()` policy, and already takes ksmbd lock-correctness
fixes. Benefit is lock-integrity on a data-destroying ioctl; risk is
minimal.

### What the commit solves
On this 6.12 tree, `FSCTL_SET_ZERO_DATA` breaks oplocks and calls
`vfs_fallocate()` without `check_lock_range()`. POSIX/SMB locks are not
enforced by `vfs_fallocate()`, so another handle can zero or punch a
locked range. The patch checks the range clipped to EOF and returns
`STATUS_FILE_LOCK_CONFLICT`, matching Samba and ksmbd’s other mutating
paths.

### Stable rules
Surgical, no new API, applies here, fixes real data-integrity/protocol
failure. Not a feature add.

### Risk vs benefit
Benefit: prevent silent destruction of locked file data on ksmbd. Risk:
low; only newly failed requests are ones that violated locks.

### Concerns
Mailing-list review could not be fetched. Parent permission-ioctl commit
is not required. `ret = 0` before `goto out` is slightly unusual but
correct given this ioctl error mapper.

Verification:
- [Phase 1] Parsed tags on `8b57448a147d2`: only Namjae Jeon SOB; no
  Fixes/Cc:stable/Reported-by
- [Phase 1] `git describe HEAD` / Makefile: `p-6.12-3-gc504cf0baa3d8`,
  VERSION 6.12.111, branch `pending-6.12`
- [Phase 2] Diff: +12 vfs.c `ksmbd_vfs_zero_data`, +6/-1 smb2pdu.c
  FSCTL_SET_ZERO_DATA
- [Phase 2] Local `smb2_ioctl` `out` (8694–8708) maps unknown errors to
  `STATUS_INVALID_PARAMETER`, not lock conflict — smb2pdu hunk required
- [Phase 2] `vfs_fallocate()` in `fs/open.c:246` has no posix-lock check
- [Phase 3] Blame: zero_data from 2021 cifsd; no lock check ever; `git
  merge-base --is-ancestor 8b57448a147d2 HEAD` → not ancestor
- [Phase 3] Related in-tree: `f751d6e39d4c9` (1-byte lock skip),
  `ca53bb17f4e82` (SET_ZERO_DATA FILE_WRITE_DATA)
- [Phase 3] Parent `3c707d4b3f926` is independent permission tweak, not
  a prerequisite
- [Phase 3] `git apply --check` of `8b57448a147d2`: both hunks apply
  (offsets −1234 / +71)
- [Phase 4] `b4 dig -c 8b57448a147d2`: lore errors, no thread —
  UNVERIFIED review discussion
- [Phase 4] lore WebFetch 403 — UNVERIFIED stable-list discussion
- [Phase 4] Samba `fsctl_zero_data` uses STRICT_LOCK WRITE and returns
  `NT_STATUS_FILE_LOCK_CONFLICT` (web/source confirmation)
- [Phase 5] Only caller of `ksmbd_vfs_zero_data` is `smb2_ioctl`;
  dispatched via `SMB2_IOCTL_HE`
- [Phase 5] `check_lock_range` already used for
  read/write/truncate/copychunk in this tree
- [Phase 6] Local `ksmbd_vfs_zero_data` (vfs.c:995–1013) matches pre-
  patch; bug exists here
- [Phase 8] Failure mode: zero/punch of locked ranges → data integrity
  HIGH
- UNVERIFIED: original lore review comments and whether anyone nominated
  this for stable on the list

**YES**

 fs/smb/server/smb2pdu.c |  7 ++++++-
 fs/smb/server/vfs.c     | 12 ++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c18590d8ee2b9..6b3cf2dadeecd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8665,8 +8665,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 			ret = ksmbd_vfs_zero_data(work, fp, off, len);
 			ksmbd_fd_put(work, fp);
-			if (ret < 0)
+			if (ret == -EAGAIN) {
+				rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
+				ret = 0;
 				goto out;
+			} else if (ret < 0) {
+				goto out;
+			}
 		}
 		break;
 	}
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 47c289ad9c3dc..f894092901bc5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1003,6 +1003,18 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 	int err;
 
 	smb_break_all_levII_oplock(work, fp, 1);
+	if (!work->tcon->posix_extensions) {
+		loff_t size = i_size_read(file_inode(fp->filp));
+
+		if (off < size) {
+			err = check_lock_range(fp->filp, off,
+					       min(off + len, size) - 1,
+					       WRITE);
+			if (err)
+				return -EAGAIN;
+		}
+	}
+
 	saved_cred = override_creds(fp->filp->f_cred);
 	if (fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)
 		err = vfs_fallocate(fp->filp,
-- 
2.53.0

