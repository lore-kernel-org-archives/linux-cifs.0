Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFDF548571;
	Mon, 31 Aug 2026 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184014; cv=none; b=qpd2ups8oi+Z5i7qzdFi7MamPJOeIK0TL06h6fw6ZUCB1UlKrBj7SovN4HHxavkLtq85K+FVXWgbQeuvVWZFZQYHzd0v8/2pI19vkwYHIyJ41Kz0JDTWzBTmnLhE536uQObOUJaCsSm1r9CK0+KCQOfwewyjIdEmkVSefcCGpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184014; c=relaxed/simple;
	bh=L8z4OmRIHKSbYTgTNVhBVl1U5Sxb0s9i4ugQ7Yy7MXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ult5r8Glyh0Sa+39lvo8anx0lQasbaBFLh3q0dwkiSPDyav3dVRi2VkqKKMjcanPMQuc/I9wlkyeYwGk/4MZrXvCBfjjRELPM23DgKt5NdCwLReACHWGBdnewQZVEH1HgXLgc7DOyjEY+QkF1j7f4iY6Z9/p502JN8JNQoewmV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Czg6Z8PB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Czg6Z8PB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A9A1F00A3D;
	Mon, 31 Aug 2026 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184010;
	bh=xp2ZHcN22HD2Tab2KGfsBxzXVjB6uvelcnZnqIBUgnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Czg6Z8PBXyQ6ewo09TknOfHaHrk0ynu52NTg5jzZKkYWck7JnbFLaf8U4vi5UAMpx
	 3GzVOL07ZkrUqp0VgULIOmzs2s7HhGgBed3tsQimg8f63uGTe0OR6+WthOQxzndZbf
	 I2Lzd+pTjyaA5KerplUXYFNIZb1GPHe6HnEmihCOey3f1FqqKGDmV/okwDVZutj8It
	 aFvkoZZVjZW2mYH5MiCK02EzW5ZnbGR+EXQQ62oScfxNPLLSj4mk4X6cJXdn0uneY3
	 xBJEtbqSd7Waxif1DGn0ZBzP54BmX2ZWhPis0mOUikXRx6MJQnoIvarm1ePOl2qX6q
	 +F4INlZlNLGRg==
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
Subject: [PATCH AUTOSEL 6.18] smb/client: emulate small EOF-extending mode 0 fallocate ranges
Date: Mon, 31 Aug 2026 09:27:44 -0400
Message-ID: <20260831133314.4125787-436-sashal@kernel.org>
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

[ Upstream commit 7a06d3b816d73448b4e38b83d65049f090b7b201 ]

When a mode 0 fallocate extends EOF from 1G to 2G + 1M, the client
currently sends SetEOF for 2G + 1M. This can make fallocate return
success without allocating the requested range, or allocate extra
space before that range.

For example, on a fresh file:

        xfs_io -f \
          -c "falloc 0 1G" \
          -c "falloc 2G 1M" \
          -c "truncate 3G" test

The second fallocate should allocate [2G, 2G + 1M), leaving [1G, 2G)
as a hole.

Before this change, the result depended on the server allocation policy.
With Samba "strict allocate = no", SetEOF could return success without
allocating [2G, 2G + 1M). With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            allocated unexpectedly
        [2G, 2G + 1M)       allocated

SMB cannot allocate that arbitrary range, so write zeroes to small
EOF-extending ranges instead. Limit this to 1 MiB to bound the
client-side I/O cost.

With "strict allocate = no", the requested range [2G, 2G + 1M) is
allocated by the writes. With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            hole
        [2G, 2G + 1M)       allocated

This fixes the small EOF-extending range case exercised by generic/213.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**

Record: `[smb/client] [emulate] small EOF-extending mode 0 fallocate
ranges — fix incorrect SetEOF-based allocation for small ranges beyond
EOF`

**Step 1.2 — Tags**

Record:
- Signed-off-by: Huiwen He, Steve French
- Reviewed-by: ChenXiaoSong
- No Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org, Tested-
  by:, or syzbot tags
- Notable: Reviewed-by present; no explicit stable nomination in commit
  message

**Step 1.3 — Body analysis**

Record:
- **Bug:** Mode-0 fallocate extending EOF with a gap (e.g., allocate
  [2G, 2G+1M) when EOF is 1G) uses `SMB2_set_eof()` instead of
  allocating the specific range.
- **Symptoms:**
  - With Samba `strict allocate = no`: fallocate can return success
    without allocating [2G, 2G+1M)
  - With `strict allocate = yes`: may allocate [1G, 2G) unexpectedly
    instead of leaving a hole
- **Fix:** For small (≤1 MiB) EOF-extending ranges at or beyond EOF,
  write zeroes via `smb3_simple_fallocate_range()` instead of SetEOF;
  refresh `i_blocks` from server `AllocationSize`.
- **Test reference:** xfstests `generic/213`
- **Root cause:** SMB has no true fallocate; SetEOF cannot allocate an
  arbitrary non-contiguous range.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Subject says "emulate" but this is a correctness fix for
POSIX fallocate semantics on CIFS/SMB mounts, not a feature addition.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**

Record:
- **File:** `fs/smb/client/smb2ops.c` (+60 / -9 lines)
- **Functions modified:** `smb3_simple_fallocate_range()`,
  `smb3_simple_falloc()`
- **Scope:** Single-file, surgical fix in SMB3 fallocate emulation path

**Step 2.2 — Code flow changes**

Record:
- **`smb3_simple_fallocate_range()`:** Buffer allocation moved earlier;
  new fast path when `off >= i_size_read(inode)` skips
  `FSCTL_QUERY_ALLOCATED_RANGES` and directly zero-writes the range
  (correct for beyond-EOF allocation).
- **`smb3_simple_falloc()`:** Before SetEOF for EOF-extending mode-0
  fallocate, detects small ranges at/beyond EOF (`off > old_eof`, or
  `off == old_eof` on sparse non-empty files) and routes through zero-
  write path; updates size and queries server for real `AllocationSize`
  to set `i_blocks`.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic/correctness fix (filesystem semantics)
- **Mechanism:** SetEOF extends file size but cannot allocate a specific
  distant range or preserve an intervening hole; zero-writes allocate
  exactly the requested range on the server.

**Step 2.4 — Fix quality**

Record:
- Fix is logically sound and minimal for the described case.
- 1 MiB cap bounds client I/O cost (consistent with existing internal-
  range fallocate limit).
- **Minor regression risk:** Low; only affects small EOF-extending
  mode-0 fallocate on SMB mounts.
- **Note:** Diff includes `min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE)`
  buffer sizing from sibling commit `9e4ec3be67af4` (not yet in this
  tree); backport may need minor adjustment to existing `kvzalloc(1024 *
  1024)` line.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**

Record: EOF-extending SetEOF path in `smb3_simple_falloc()` dates to
merge base `5d324e5159d9e` (v6.18); underlying fallocate emulation
introduced in `966a3cb7c7db` ("cifs: improve fallocate emulation",
2021). Bug has been present since SetEOF was used for EOF extension.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no Fixes: tag in commit message.

**Step 3.3 — Related file history**

Record:
- `7e08ab7a061b1` — "handle overlapping allocated ranges in fallocate" —
  **already in this tree**
- `6cc1518357369` — kvzalloc for fallocate buffer — **already in this
  tree**
- `9e4ec3be67af4` — reduce fallocate buffer to `min_t(len,
  SMB2_MAX_BUFFER_SIZE)` — on master, **not in this tree**
- `5bd1d3dcc25a5` — refresh allocation after EOF-extending fallocate
  (SetEOF path) — on master, **not in this tree**
- Part of v8 series "fix fallocate and allocation accounting" (patch
  4/5), but this specific patch is largely standalone for the small-gap
  EOF case.

**Step 3.4 — Author context**

Record: Huiwen He authored multiple CIFS fallocate/accounting fixes;
`7e08ab7a061b1` from same author is already backported to this 6.18.y
tree.

**Step 3.5 — Dependencies**

Record:
- **Hard dependency met:** `7e08ab7a061b1` (overlapping ranges fix) is
  in tree.
- **Soft dependency:** `9e4ec3be67af4` (buffer size) makes the diff
  apply cleanly; without it, one hunk needs minor adaptation (use
  existing 1 MiB buffer or include `9e4ec3` alongside).
- **Not required:** `5906d0e82e8e0` (duplicate extents), `5bd1d3dcc25a5`
  (SetEOF allocation refresh) — separate concerns.
- Can apply standalone with at most minor buffer-allocation adjustment.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c 7a06d3b816d73`: [PATCH v8 4/5] at
  https://patch.msgid.link/20260703053300.913371-5-huiwen.he@linux.dev
- Series revisions v4–v8 found; committed version is latest (v8).
- No explicit Cc: stable in thread headers found.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` shows CC to Steve French (maintainer), linux-
cifs@vger.kernel.org, and core CIFS reviewers. Reviewed-by: ChenXiaoSong
on all revisions.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Validation is via
xfstests `generic/213` (referenced in commit message and series cover
letters).

**Step 4.4 — Series context**

Record: v8 series covers fallocate + allocation accounting (5 patches).
Patch 4/5 (this commit) fixes small EOF-extending mode-0 case; patch 5/5
(`5bd1d3dcc25a5`) addresses SetEOF-path allocation refresh for other
generic/213/generic/701 scenarios. This patch stands alone for its
specific bug class.

**Step 4.5 — Stable list**

Record: No stable@vger.kernel.org discussion found for this specific
patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**

Record: `smb3_simple_falloc()`, `smb3_simple_fallocate_range()`,
`smb3_simple_fallocate_write_range()`, `cifs_fallocate()` (caller in
`cifsfs.c`)

**Step 5.2 — Callers**

Record: `cifs_fallocate()` → `server->ops->fallocate()` →
`smb3_fallocate()` → `smb3_simple_falloc(file, tcon, off, len, false)`
for mode 0. Reachable from `fallocate(2)` syscall on CIFS/SMB mounts.

**Step 5.3 — Callees**

Record: `SMB2_write()` (zero-fill), `SMB2_query_info()` (allocation
refresh), `SMB2_ioctl(FSCTL_QUERY_ALLOCATED_RANGES)`,
`netfs_resize_file()`, `cifs_setsize()`. All exist in this tree.

**Step 5.4 — Reachability**

Record: Userspace `fallocate()` on SMB-mounted files with mode 0 and EOF
extension — common for preallocation tools (`xfs_io`, databases, etc.).
Unprivileged users can trigger on writable mounts.

**Step 5.5 — Similar patterns**

Record: Existing code already uses `smb3_simple_fallocate_range()` for
internal sparse-file holes (len ≤ 1 MiB at lines 3726–3728 in current
tree). This commit extends the same pattern to EOF-extending cases.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code exists?**

Record: **YES.** Local tree is **v6.18.44** (`git describe HEAD`).
Current `smb3_simple_falloc()` at lines 3665–3680 still uses SetEOF for
all EOF-extending mode-0 fallocate without the small-range zero-write
path. Bug present since 2021 fallocate emulation.

**Step 6.2 — Backport complications**

Record: **Minor adaptation expected.** Stable tree uses `kvzalloc(1024 *
1024)` at line 3564; upstream commit expects `kvzalloc(min_t(loff_t,
len, SMB2_MAX_BUFFER_SIZE))` from `9e4ec3be67af4`. Core logic applies
cleanly; buffer line is a one-line adjustment or companion pick of
`9e4ec3`.

**Step 6.3 — Related fixes already present?**

Record: `7e08ab7a061b1` (overlapping allocated ranges) already
backported. This specific EOF-extending small-range fix is **not**
present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**

Record: **fs/smb/client** (CIFS/SMB client) — **IMPORTANT** subsystem
for enterprise/consumer network filesystem mounts.

**Step 7.2 — Activity**

Record: Actively maintained; multiple fallocate fixes landed in 6.18.y
cycle including `7e08ab7a061b1`, `6cc1518357369`, `f4e35576da439`
(i_blocks/generic/694).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**

Record: Users of CIFS/SMB mounts who call `fallocate()` (mode 0) to
preallocate space, especially with gaps beyond EOF. Config-specific:
requires SMB2/3 and fallocate support (already emulated in this driver).

**Step 8.2 — Trigger conditions**

Record: `fallocate(0, off, len)` where `off + len > EOF` and (`off >
EOF` with gap, or EOF extension on sparse file). Example: `falloc 0 1G`
then `falloc 2G 1M`. Not exotic — matches xfstests generic/213.
Unprivileged on writable mounts.

**Step 8.3 — Failure mode severity**

Record:
- Success without allocation → applications believe space is reserved;
  later writes may hit ENOSPC unexpectedly
- Over-allocation of gap region → wasted server disk space, incorrect
  sparse layout
- **Severity: MEDIUM-HIGH** (filesystem semantics / space accounting
  correctness; not kernel crash or data corruption, but real user-
  visible misbehavior)

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH for SMB mount users relying on fallocate; fixes
  long-standing emulation gap; aligns with already-backported fallocate
  fixes in this tree
- **Risk:** LOW — ~60 lines, one file, reviewed, bounded to ≤1 MiB
  ranges, uses existing write/query paths
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR backport:**
- Fixes real POSIX fallocate semantics bug on SMB mounts
- Reproducible via xfstests generic/213
- Small, reviewed, maintainer-signed
- Sister fix `7e08ab7a061b1` already in this 6.18.y tree
- Buggy code confirmed present in v6.18.44
- All required APIs exist locally
- Precedent: other CIFS fallocate/i_blocks fixes already in stable

**AGAINST backport:**
- Not a crash/security/data-corruption issue
- Part of larger fallocate series; `5bd1d3dcc25a5` covers related
  SetEOF-path cases separately
- Minor backport adjustment needed for buffer allocation line
  (`9e4ec3be67af4` not in tree)
- `generic/213` may need additional patches for all server
  configurations

**Unresolved:** Whether full `generic/213` pass on all Samba configs
requires `5bd1d3dcc25a5` as well (separate commit). This commit fixes
the specific small EOF-extending range case described.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — clear mechanism, Reviewed-
   by, xfstests reference
2. Fixes real bug affecting users? **PASS** — incorrect fallocate
   allocation/semantics on SMB mounts
3. Important issue? **PASS** — filesystem correctness / space
   preallocation reliability (MEDIUM-HIGH)
4. Small and contained? **PASS** — ~60 lines, one file
5. No new features/APIs? **PASS** — improves existing fallocate
   emulation
6. Can apply to local tree? **PASS** — applies with at most one-line
   buffer allocation adjustment

**Step 9.3 — Exception categories**

Record: Not a device ID, quirk, DT, build, or docs fix. Standard bug-fix
category.

**Step 9.4 — Decision rationale**

This commit fixes a longstanding, user-reachable fallocate correctness
bug in the CIFS/SMB client. The buggy SetEOF path is present in
v6.18.44. The fix is small, reviewed, and consistent with fallocate
fixes already backported to this tree (`7e08ab7a061b1`). While not a
kernel crash, incorrect fallocate success/space allocation directly
affects applications using SMB mounts for preallocation — a real stable-
tree concern for the SMB client subsystem.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 7a06d3b816d73`
- [Phase 2] Diff analysis from provided diff and `git show 7a06d3b816d73
  -p`
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame -L 3665,3680
  fs/smb/client/smb2ops.c` → SetEOF path from v6.18 merge base
- [Phase 3] `git show 966a3cb7c7db` → fallocate emulation introduced
  2021
- [Phase 3] `git log HEAD..master -- fs/smb/client/smb2ops.c` → commit
  not in tree; prerequisites identified
- [Phase 3] `git log --oneline -1 7e08ab7a061b1` → overlapping ranges
  fix in tree
- [Phase 3] `git show 9e4ec3be67af4` → buffer sizing prerequisite on
  master only
- [Phase 3] `git show 5bd1d3dcc25a5` → separate SetEOF-path follow-up
- [Phase 4] `b4 dig -c 7a06d3b816d73` → lore URL found
- [Phase 4] `b4 dig -c 7a06d3b816d73 -a` → v4–v8 series revisions
- [Phase 4] `b4 dig -c 7a06d3b816d73 -w` → maintainers CC'd
- [Phase 4] `rg stable /tmp/falloc_thread.mbox` → no stable nomination
  found
- [Phase 5] `grep smb3_simple_falloc/cifs_fallocate` → syscall-reachable
  call chain confirmed
- [Phase 5] `grep SMB2_query_info/CIFS_INO_BLOCKS` → APIs exist in tree
- [Phase 6] Read `fs/smb/client/smb2ops.c` lines 3541–3758 → buggy
  SetEOF path confirmed present
- [Phase 6] `git merge-base --is-ancestor 99cd0a6eeb6c HEAD` → NOT in
  tree (unrelated to this fix's core logic)
- [Phase 6] Read `fs/smb/client/inode.c` `cifs_setsize()` → EOF
  extension still sets i_blocks from size
- [Phase 7] `git log --oneline -5 --grep=fallocate HEAD` → prior
  fallocate fixes in tree
- [Phase 8] Commit message documents Samba strict-allocate behavior and
  generic/213

**YES****Backport verdict: YES** for the local **v6.18.44** tree.

This commit fixes a real CIFS/SMB client bug: mode-0 `fallocate()` that
extends EOF with a gap (e.g. allocate at 2G when EOF is 1G) incorrectly
used `SetEOF`, which could succeed without allocating the requested
range or allocate the intervening hole. The fix routes small (≤1 MiB)
EOF-extending ranges through zero-writes instead, matching POSIX
semantics and xfstests `generic/213`.

The buggy SetEOF path is present in this tree, and a related fallocate
fix (`7e08ab7a061b1`) is already backported here. The patch is small,
reviewed, and should apply cleanly with at most a one-line buffer-
allocation tweak (upstream also changed `kvzalloc(1024*1024)` to
`min_t(len, SMB2_MAX_BUFFER_SIZE)` in sibling commit `9e4ec3be67af4`,
which is not in this tree yet).

 fs/smb/client/smb2ops.c | 69 +++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 618e36f4d838e..082e6334ab9f6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3545,12 +3545,25 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 				       loff_t off, loff_t len)
 {
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	struct inode *inode = d_inode(cfile->dentry);
 	u32 out_data_len;
 	char *buf = NULL;
 	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
+	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (off >= i_size_read(inode)) {
+		rc = smb3_simple_fallocate_write_range(xid, tcon, cfile,
+						       off, len, buf);
+		goto out;
+	}
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3562,12 +3575,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	tmp_data = out_data;
 	while (len) {
 		/*
@@ -3642,18 +3649,22 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	loff_t new_eof;
+	loff_t old_eof, new_eof;
+	struct smb2_file_all_info file_inf;
+	u64 asize;
+	int qrc;
 
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
+	old_eof = i_size_read(inode);
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
+		if (!keep_size) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
@@ -3663,11 +3674,51 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && old_eof < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range at or beyond EOF can be allocated by writing
+		 * zeroes.  For off > old_eof, this preserves the intervening
+		 * hole instead of allocating from offset 0.
+		 */
+		if (off > old_eof ||
+		    (off == old_eof && old_eof != 0 &&
+		     (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))) {
+			if (len > 1024 * 1024) {
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			if (rc) {
+				spin_lock(&inode->i_lock);
+				cifsi->time = 0;
+				spin_unlock(&inode->i_lock);
+				goto out;
+			}
+
+			new_eof = off + len;
+			netfs_resize_file(&cifsi->netfs, new_eof, true);
+			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
-- 
2.53.0

