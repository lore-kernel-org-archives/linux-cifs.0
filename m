Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25E33EF653;
	Tue, 24 Mar 2026 11:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351184; cv=none; b=X7mHEH6uZbyA6/szmnaVYr12NX3Vb26UWMz5WHuWeZFT9GYEoCrxJPCKq55WXNYC3hAaenQ/zcFY2OP6NzbC0fLboDnM7TPauz0cmLOeNdUiUxLU9hYfW7KyVFrqxje23R/xi0JQZiwCvAjqG1lmxlixRDCwEulJFErRO5dulVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351184; c=relaxed/simple;
	bh=sO8/p+vp5dBZICG3fa9qAY/MlcLAQY1FaD4KpkPlWJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX1I4/+OlVudhnIkZ8QG3ZFGp3zCC/KQxw+UlBApnltSjenJCA+l/oLmbO1uCXrR122wGQPkskqkZ1z6NJVN17ebDu6E4unpCA+i0YzbOxsEZmbDEW4yU11D/v0lpR9ckJq/xhl6yufiZZJia3+h5SDakPyFPW9IWFX0LySLjmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sG2A/TMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sG2A/TMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B69C19424;
	Tue, 24 Mar 2026 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351184;
	bh=sO8/p+vp5dBZICG3fa9qAY/MlcLAQY1FaD4KpkPlWJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sG2A/TMVjVITkylIxU1z42+dk/AJya0yDmDeETBuylbRi9GNbtDNhPdz1Lk00b2G9
	 YtH30B8uF9zzg4ErDYcKXApyIqvrswXF2q2zWUgvGoEBWBUA29DW57PKd/WhyKv6ET
	 0jMOICUYRtFf7Vz5vP7PMSLiS2R2q5psLRpi63xlfPCdjtQI9ZiDJat3Y2vxP0mAsb
	 hbSH6u+Cdc2pAcy2OVaGjQ3XW7EKEkNQoiTbMGHAjsi5FVOvWa1XSlZEsy3zU6NGTv
	 2khqWFtb5CWQ2yIsP+1TDaQAC1+3m7gA2k96kwVBVXrlxl8Acq/iGhJ470jGLTIGvO
	 R1UYr+ADEfhSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] smb: client: fix generic/694 due to wrong ->i_blocks
Date: Tue, 24 Mar 2026 07:19:17 -0400
Message-ID: <20260324111931.3257972-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 23b5df09c27aec13962b30d32a4167ebdd043f8e ]

When updating ->i_size, make sure to always update ->i_blocks as well
until we query new allocation size from the server.

generic/694 was failing because smb3_simple_falloc() was missing the
update of ->i_blocks after calling cifs_setsize().  So, fix this by
updating ->i_blocks directly in cifs_setsize(), so all places that
call it doesn't need to worry about updating ->i_blocks later.

Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Closes: https://lore.kernel.org/r/CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a comprehensive analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [subsystem: smb: client] [action verb: fix] [Fixes xfstests
generic/694 test failure due to incorrect i_blocks reporting]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reported-by:** Shyam Prasad N <sprasad@microsoft.com> — Microsoft
  SMB developer; this is a real, reproducible bug
- **Closes:** link to lore.kernel.org bug report email
- **Signed-off-by:** Paulo Alcantara (Red Hat) — CIFS subsystem co-
  maintainer
- **Cc:** David Howells (netfs maintainer), linux-cifs@vger.kernel.org
- **Signed-off-by:** Steve French — CIFS maintainer (committed the
  patch)
- No Fixes: tag, no Cc: stable tag (expected for commits under review)

Record: Reported by a Microsoft SMB developer (Shyam Prasad N). Fixed by
CIFS co-maintainer Paulo Alcantara. Committed by CIFS maintainer Steve
French. Original bug report CC'd stable@vger.kernel.org.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains: When `->i_size` is updated, `->i_blocks` must also
be updated to reflect a consistent estimate of allocated blocks until
the server provides actual allocation sizes. `smb3_simple_falloc()` was
calling `cifs_setsize()` without updating `i_blocks`, causing xfstests
`generic/694` to fail (stat() returning wrong block count).

The fix moves the i_blocks update into `cifs_setsize()` itself, so ALL
callers (not just some) keep i_blocks consistent.

Record: [Bug: stat() returns wrong i_blocks after file size changes via
fallocate/truncate] [Symptom: xfstests generic/694 failure] [Root cause:
missing i_blocks update in cifs_setsize(), callers inconsistently
handled it]

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly labeled as a fix and clearly is one. No hidden nature
here.

Record: [Explicitly a bug fix]

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
| File | Changes |
|------|---------|
| fs/smb/client/cifsglob.h | +6 (new `CIFS_INO_BLOCKS` macro) |
| fs/smb/client/file.c | -1 (remove redundant `inode->i_blocks = 0` from
`cifs_do_truncate`) |
| fs/smb/client/inode.c | +5/-13 (centralize i_blocks into
`cifs_setsize()`, use macro in `cifs_fattr_to_inode`) |
| fs/smb/client/smb2ops.c | +5/-24 (use macro in `smb2_close_getattr`,
remove redundant updates in `cifs_file_set_size` and
`smb2_duplicate_extents`) |

Net: +16/-32 = -16 lines. The fix reduces total code by consolidating
duplicated logic.

Functions modified: `cifs_fattr_to_inode()`, `cifs_do_truncate()`,
`cifs_setsize()`, `cifs_file_set_size()`, `smb2_close_getattr()`,
`smb2_duplicate_extents()`

Record: [4 files, net -16 lines] [Scope: single-subsystem consolidation
fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
1. **cifsglob.h**: Adds `CIFS_INO_BLOCKS(size)` =
   `DIV_ROUND_UP_ULL((u64)(size), 512)` — standardizes the block count
   calculation
2. **cifs_setsize()**: Now sets `inode->i_blocks =
   CIFS_INO_BLOCKS(offset)` inside the spinlock, alongside
   `i_size_write()`
3. **cifs_do_truncate()**: Removes now-redundant `inode->i_blocks = 0`
   after `cifs_setsize(inode, 0)` (cifs_setsize now handles it)
4. **cifs_file_set_size()**: Removes duplicate i_blocks calculation
   after `cifs_setsize()` call
5. **smb2_close_getattr()**: Uses `CIFS_INO_BLOCKS()` macro instead of
   manual calculation
6. **smb2_duplicate_extents()**: Removes comment about needing to set
   i_blocks — cifs_setsize now handles it
7. **cifs_fattr_to_inode()**: Uses `CIFS_INO_BLOCKS()` macro, cleaner
   comment

Record: [Before: i_blocks updated inconsistently in some callers,
missing in others (smb3_simple_falloc)] [After: i_blocks always updated
when i_size changes via cifs_setsize()]

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Logic/correctness fix** — missing metadata update in a
central function, causing inconsistent stat() results.

The bug: `cifs_setsize()` updated `i_size` but not `i_blocks`. Some
callers (like `cifs_file_set_size/cifs_setattr_nounix`) manually updated
`i_blocks` afterward, but other callers (like `smb3_simple_falloc`,
`smb2_duplicate_extents`) did NOT. This meant fallocate operations left
stale `i_blocks` values.

Record: [Missing i_blocks update in cifs_setsize(); inconsistently
handled by callers; smb3_simple_falloc was the concrete failure path]

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct?** YES — moving i_blocks into cifs_setsize() under
  the existing spinlock is the right approach
- **Minimal/surgical?** YES — consolidates duplicated code while fixing
  the bug
- **Regression risk?** Very low — the only semantic change is that
  `i_blocks` is now also set in paths that previously missed it. For
  paths that already set it, there's a harmless double-set
  (cifs_fattr_to_inode uses server-provided `cf_bytes` which may differ
  from `offset`-based estimate, and its update comes from a different
  code path)
- **Note:** `CIFS_INO_BLOCKS` uses `DIV_ROUND_UP_ULL` which is
  equivalent to `(512 - 1 + size) >> 9` but cleaner

Record: [Fix is obviously correct, minimal, low regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The `cifs_setsize()` function was introduced by Steve French in 2007
(commit 3677db10a635a3). The i_blocks patterns in `cifs_fattr_to_inode`
have been present since at least v3.x. The bug has existed since
`smb3_simple_falloc` was added.

Record: [Core function from 2007; i_blocks bug exists since
smb3_simple_falloc was introduced]

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent related commits by Paulo Alcantara include several SMB client
fixes in the same 6.19 timeframe:
- `110fee6b9bb58` — refactored cifs_setattr into cifs_file_set_size (Oct
  2025)
- `dba9f997c9d9a` — fixed race with fallocate and AIO+DIO
- `57ce9f7793b71` — fixed missing timestamp updates after ftruncate

The current commit depends on `110fee6b9bb58` for the
`cifs_file_set_size()` function and `cifs_do_truncate()` function in
file.c.

Record: [Depends on 110fee6b9bb58 for
cifs_file_set_size/cifs_do_truncate code structure. The conceptual fix
(adding i_blocks to cifs_setsize) is standalone.]

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Paulo Alcantara is the CIFS/SMB client co-maintainer at Red Hat. He's
the most active contributor to this subsystem. High trust in the fix.

Record: [Author is subsystem co-maintainer]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The `cifs_file_set_size()` function that this commit modifies was
introduced by `110fee6b9bb58` (v6.19/7.0 era). This function doesn't
exist in v6.12 or earlier. However, the equivalent code
(`cifs_setattr_nounix()`) exists in v6.12 and has the same bug pattern
(i_blocks updated after cifs_setsize, not inside it).

The `cifs_do_truncate()` function in file.c was also
introduced/refactored by `110fee6b9bb58`.

Record: [Direct apply requires 110fee6b9bb58; for older stable trees
(6.12, 6.6, 6.1), the patch needs adaptation but the core fix applies]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: LORE DISCUSSION
The patch was submitted as v1 on 2026-03-19, updated to v2 the same day
(v2 moved i_blocks under spinlock, improved comments). No NAKs or
objections found. No explicit stable nomination by reviewers on-list,
but the original bug report by Shyam CC'd stable@vger.kernel.org.

Record: [v2 submitted, clean discussion, no objections, merged into
7.0-rc5]

### Step 4.2: BUG REPORT
Shyam Prasad N (Microsoft SMB developer) discovered the issue while
running xfstests generic/694 test. The test preallocates/writes a file,
syncs, stats for allocated blocks, unmount/remount, and stats again.
Without this fix, stat() reports 0 blocks. Steve French acknowledged:
"That sounds an important bug to fix."

Record: [Reproducible via standard xfstests; acknowledged as important
by maintainer]

### Step 4.3-4.4: RELATED PATCHES AND STABLE HISTORY
Part of a 3-fix pull request to Linus for 7.0-rc5. No prior stable
discussion about this specific issue found.

Record: [Standalone fix, not dependent on the other patches in the pull
request]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: KEY FUNCTIONS AND CALLERS
`cifs_setsize()` is called from 4 places:
1. `cifs_do_truncate()` (file.c:1000) — truncation path
2. `cifs_file_set_size()` (inode.c:3083) — setattr/truncate path
3. `smb2_duplicate_extents()` (smb2ops.c:2209) — reflink/clone path
4. `smb3_simple_falloc()` (smb2ops.c:3676) — fallocate extending path

Before this fix, only #1 and #2 updated i_blocks after calling
cifs_setsize(). #3 and #4 did NOT — these are the bug paths.

Record: [4 callers; 2 had missing i_blocks update; all are user-
reachable via truncate/fallocate/reflink syscalls]

### Step 5.3-5.5: CALL CHAIN AND SIMILAR PATTERNS
The buggy paths are reachable from:
- `fallocate(2)` syscall → `smb3_fallocate()` → `smb3_simple_falloc()` →
  `cifs_setsize()` — i_blocks NOT updated (BUG)
- `ioctl(FICLONERANGE)` → `smb2_duplicate_extents()` → `cifs_setsize()`
  — i_blocks NOT updated (BUG)

Both are standard user operations on SMB-mounted filesystems.

Record: [Bug reachable from userspace via fallocate and reflink;
standard filesystem operations]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Verified: In v6.6 and v6.12, `smb3_simple_falloc()` calls
`cifs_setsize()` without updating `i_blocks`. The bug exists in ALL
active stable trees.

### Step 6.2: BACKPORT COMPLICATIONS
The patch won't apply cleanly to v6.12 or earlier because:
- `cifs_file_set_size()` doesn't exist (was `cifs_setattr_nounix()`)
- `cifs_do_truncate()` doesn't exist in file.c
- Some context lines differ

However, the core fix (adding i_blocks to cifs_setsize + introducing the
macro) is straightforward to adapt.

Record: [Needs rework for v6.12 and earlier; core concept portable]

### Step 6.3: NO RELATED FIXES ALREADY IN STABLE
No prior fix for this specific issue found in any stable tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
SMB/CIFS client (fs/smb/client/) — IMPORTANT. Used by millions of Linux
systems for network file sharing with Windows/Samba servers. Enterprise,
NAS, and developer environments.

Record: [Subsystem: CIFS/SMB client] [Criticality: IMPORTANT — widely
used filesystem]

### Step 7.2: SUBSYSTEM ACTIVITY
Very actively maintained — 20+ commits in recent history, active
bugfixing by Paulo Alcantara and others.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All SMB/CIFS client users who use fallocate, reflink, or check file
block counts. Affects any mount using SMB2/3.

### Step 8.2: TRIGGER CONDITIONS
- fallocate(2) on SMB-mounted file that extends the file
- Any stat(2) after such operation → reports wrong i_blocks
- Common usage: tools that check disk usage (du, df), xfstests, backup
  software

Record: [Common trigger conditions; any user of fallocate on SMB mounts]

### Step 8.3: FAILURE MODE SEVERITY
- **No crash, no data corruption, no security issue**
- Incorrect metadata: stat() returns wrong block count
- Can mislead disk usage tools and cause test failures
- Severity: **MEDIUM** — data correctness issue in file metadata

Record: [Severity: MEDIUM — incorrect stat metadata, not
crash/corruption]

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Fixes incorrect file metadata for all SMB users using
  fallocate; fixes xfstests generic/694
- **Risk:** Very low — consolidates existing code, net code reduction,
  well-contained within single subsystem
- **Ratio:** Favorable — low risk, medium-high benefit

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real, reproducible bug (xfstests generic/694 failure)
- Fixes incorrect stat() results for all SMB fallocate users
- Reported by Microsoft SMB developer, acknowledged as important by
  maintainer
- Fix by subsystem co-maintainer
- Small scope (-16 net lines), well-contained
- Consolidates duplicated code (reduces maintenance burden)
- Bug exists in all active stable trees
- Original bug report CC'd stable@vger.kernel.org

**AGAINST backporting:**
- Severity is MEDIUM, not CRITICAL (incorrect metadata, not
  crash/corruption)
- Needs rework for older stable trees (dependency on 110fee6b9bb58)
- Touches 4 files across the subsystem

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — fix is clearly correct,
   tested via xfstests
2. Fixes a real bug? **YES** — wrong i_blocks in stat()
3. Important issue? **YES (MEDIUM)** — data correctness for a widely
   used filesystem
4. Small and contained? **YES** — net -16 lines, single subsystem
5. No new features? **YES** — no new features
6. Can apply to stable? **Needs adaptation** for older trees

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category — standard bug fix.

### Step 9.4: DECISION
The fix addresses a real, reproducible bug in the SMB client that causes
incorrect stat() results. It's small, well-contained, written by the
subsystem co-maintainer, and reduces code duplication. The original bug
reporter CC'd stable. While it needs adaptation for older trees, the
conceptual fix is straightforward.

---

## Verification

- [Phase 1] Parsed tags: Reported-by Shyam Prasad N (Microsoft), Closes:
  lore link, SOB Paulo Alcantara (CIFS co-maintainer), committed by
  Steve French (CIFS maintainer)
- [Phase 2] Diff analysis: 4 files, +16/-32 lines, centralizes i_blocks
  update into cifs_setsize(), introduces CIFS_INO_BLOCKS macro
- [Phase 3] git blame: cifs_setsize() from 2007 (3677db10a635a3);
  i_blocks bug since smb3_simple_falloc was added
- [Phase 3] git log: confirmed 110fee6b9bb58 refactored cifs_setattr
  into cifs_file_set_size (dependency)
- [Phase 3] git log author: Paulo Alcantara is the most active CIFS
  contributor, subsystem co-maintainer
- [Phase 4] Lore research: v2 patch, merged without objections into
  7.0-rc5; Steve French called it "an important bug to fix"
- [Phase 5] Callers of cifs_setsize: 4 call sites verified
  (cifs_do_truncate, cifs_file_set_size, smb2_duplicate_extents,
  smb3_simple_falloc)
- [Phase 5] Verified smb3_simple_falloc (line 3676) and
  smb2_duplicate_extents (line 2209) were missing i_blocks updates
- [Phase 6] Verified v6.6 and v6.12 contain the same bug pattern
  (smb3_simple_falloc calls cifs_setsize without i_blocks update)
- [Phase 6] Patch needs adaptation for v6.12 and earlier
  (cifs_file_set_size doesn't exist)
- [Phase 8] Impact: all SMB users using fallocate; trigger is common;
  severity MEDIUM (metadata correctness)

**YES**

 fs/smb/client/cifsglob.h |  6 ++++++
 fs/smb/client/file.c     |  1 -
 fs/smb/client/inode.c    | 21 ++++++---------------
 fs/smb/client/smb2ops.c  | 20 ++++----------------
 4 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0c3d2bbef938e..474d7b2aa2ef5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2324,4 +2324,10 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 	return opts;
 }
 
+/*
+ * The number of blocks is not related to (i_size / i_blksize), but instead
+ * 512 byte (2**9) size is required for calculating num blocks.
+ */
+#define CIFS_INO_BLOCKS(size) DIV_ROUND_UP_ULL((u64)(size), 512)
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 89dab96292de1..59478d819ad0c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -998,7 +998,6 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
-			inode->i_blocks = 0;
 		}
 	}
 	if (cfile)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f9ee95953fa4a..c5d89ddc87c00 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -219,13 +219,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	 */
 	if (is_size_safe_to_change(cifs_i, fattr->cf_eof, from_readdir)) {
 		i_size_write(inode, fattr->cf_eof);
-
-		/*
-		 * i_blocks is not related to (i_size / i_blksize),
-		 * but instead 512 byte (2**9) size is required for
-		 * calculating num blocks.
-		 */
-		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
+		inode->i_blocks = CIFS_INO_BLOCKS(fattr->cf_bytes);
 	}
 
 	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
@@ -3009,6 +3003,11 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 {
 	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
+	/*
+	 * Until we can query the server for actual allocation size,
+	 * this is best estimate we have for blocks allocated for a file.
+	 */
+	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
@@ -3081,14 +3080,6 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	if (rc == 0) {
 		netfs_resize_file(&cifsInode->netfs, size, true);
 		cifs_setsize(inode, size);
-		/*
-		 * i_blocks is not related to (i_size / i_blksize), but instead
-		 * 512 byte (2**9) size is required for calculating num blocks.
-		 * Until we can query the server for actual allocation size,
-		 * this is best estimate we have for blocks allocated for a file
-		 * Number of blocks must be rounded up so size 1 is not 0 blocks
-		 */
-		inode->i_blocks = (512 - 1 + size) >> 9;
 	}
 
 	return rc;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9bfd3711030b4..067e313283291 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1493,6 +1493,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_file_network_open_info file_inf;
 	struct inode *inode;
+	u64 asize;
 	int rc;
 
 	rc = __SMB2_close(xid, tcon, cfile->fid.persistent_fid,
@@ -1516,14 +1517,9 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 		inode_set_atime_to_ts(inode,
 				      cifs_NTtimeToUnix(file_inf.LastAccessTime));
 
-	/*
-	 * i_blocks is not related to (i_size / i_blksize),
-	 * but instead 512 byte (2**9) size is required for
-	 * calculating num blocks.
-	 */
-	if (le64_to_cpu(file_inf.AllocationSize) > 4096)
-		inode->i_blocks =
-			(512 - 1 + le64_to_cpu(file_inf.AllocationSize)) >> 9;
+	asize = le64_to_cpu(file_inf.AllocationSize);
+	if (asize > 4096)
+		inode->i_blocks = CIFS_INO_BLOCKS(asize);
 
 	/* End of file and Attributes should not have to be updated on close */
 	spin_unlock(&inode->i_lock);
@@ -2197,14 +2193,6 @@ smb2_duplicate_extents(const unsigned int xid,
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-
-		/*
-		 * Although also could set plausible allocation size (i_blocks)
-		 * here in addition to setting the file size, in reflink
-		 * it is likely that the target file is sparse. Its allocation
-		 * size will be queried on next revalidate, but it is important
-		 * to make sure that file's cached size is updated immediately
-		 */
 		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
 	}
-- 
2.51.0

