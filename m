Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7D568540;
	Mon, 31 Aug 2026 13:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184090; cv=none; b=ehwguW8whvjVnpG7MTiKpbMhMYhWNvCd8r4X2GXEbb9w83J91Hq+OMuBU4BBOrVdw2/YsTMbe/DLydIa6ntT0e0g+CCLAuIPCZbKdmPL5sX0MIXkBYSCZpRjv0mv7WiveJjHpqOiSkhDCf+m1ALjDfY+t/hda7Md6iGbwo1TyoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184090; c=relaxed/simple;
	bh=zOjpnBRBvh7HOWBxpkOw8Ix8BKL473KAfyMHTFn5oVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7F7YsKnZdqwT9BxFXgYkYTTJay7CgptTSl91LOyhQeX1mU6xa5+mEbu78FP/Z0UfB/icaoG8hu2JmjXJhoiGO54nkTg220lgr1ftEJV00qx53eo2xF9TSf4rylgfkD1OhP699bvZREpD9/9fH5OZ8PUGO0c9vtlHyolPGPL2io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NY3+haBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY3+haBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4F01F000E9;
	Mon, 31 Aug 2026 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184087;
	bh=Q4ZbAl0hTh63oth7NjFJjAwcZcpB411MsBEkNGifzyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NY3+haBgdgqDc3adSvjJFJcQ7uKx5ZDQtBvuBeg+kIm5hUQTcatbU/UXicRYC5oqb
	 q1CdRGxUY74ipaMqbbXW7w6ryebAz+w2xtuAZRX4su3iAHHFzdX/6QdarPmKdp6/EL
	 fT4Wdq0yiPhSGje/81MQvpOFiXsrk/gFZ+IB02W3VmVMQRt2du5jLQjTNS/Wag58jO
	 SqsipP/qjK3Q6CQ+m9OiG8YFK49zjzskjP/pFAycuFfo55w5feIJgfMOj6YmWDfr2i
	 m/8b/5UGH2luEyoTUYu8B2S3wyZ8XSypiN+45+cCMJEYt+cmxmQ76YEKIJ58FjqE3i
	 qp4SaR3pJHtIA==
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
Subject: [PATCH AUTOSEL 6.18] smb/client: do not account EOF extension as allocation
Date: Mon, 31 Aug 2026 09:28:31 -0400
Message-ID: <20260831133314.4125787-483-sashal@kernel.org>
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

[ Upstream commit 99cd0a6eeb6c20fc6b914e7ce192c6b08e1ef906 ]

cifs_setsize() updates the local inode size after SetEOF succeeds. It also
used the new EOF as a local i_blocks estimate, but extending EOF does not
prove that the intervening range was allocated.

For example, after writing 1 MiB and then extending EOF to 10 MiB, the
client can report the file as fully allocated even though the server still
reports a much smaller AllocationSize:

        $ dd if=/dev/zero of=test bs=1M count=1
        $ truncate -s 10M test && stat -c 'size=%s blocks=%b' test
        $ stat --cached=never -c 'size=%s blocks=%b' test

        client stat:                    size=10485760 blocks=20480
        server stat:                    size=10485760 blocks=2056
        client stat after revalidation: size=10485760 blocks=2056

A later attribute revalidation may correct i_blocks, but callers such as
xfstests generic/495 invoke swapon immediately after truncate. The swapfile
hole check can therefore observe the inflated local i_blocks value and
accept a sparse file.

Do not grow i_blocks from cifs_setsize() on EOF extension.  Only clamp it
on shrink; allocation growth must come from write completion or from
server-reported AllocationSize.

With this change, EOF extension no longer makes a sparse file appear
fully allocated before the next attribute revalidation, and xfstests
generic/495 no longer accepts it through the inflated local i_blocks value.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[smb/client]` `[fix implicit: "do not"]` — Stop treating EOF
extension as block allocation in `cifs_setsize()`.

**Step 1.2 — Tags**
Record:
- Signed-off-by: Huiwen He \<hehuiwen@kylinos.cn\> (author)
- Reviewed-by: ChenXiaoSong \<chenxiaosong@kylinos.cn\>
- Signed-off-by: Steve French \<stfrench@microsoft.com\> (SMB/CIFS
  maintainer)
- No Fixes:, Reported-by:, Link:, Cc: stable, or Tested-by: tags

**Step 1.3 — Body analysis**
Record:
- **Bug:** `cifs_setsize()` sets `inode->i_blocks` from the new EOF
  (`offset`), but extending EOF does not allocate the intervening range
  on SMB.
- **Symptom:** After `truncate -s 10M` on a 1 MiB file, cached `stat`
  shows `blocks=20480` (10 MiB) while the server reports `blocks=2056`
  (~1 MiB). Revalidation corrects it later.
- **Failure mode:** `xfstests generic/495` calls `swapon` immediately
  after `truncate`; `cifs_swap_activate()` sees inflated `i_blocks` and
  accepts a sparse swapfile that should be rejected.
- **Root cause:** Conflating logical file size with physical allocation
  size in `cifs_setsize()`.
- **Fix approach:** Only clamp `i_blocks` on shrink; allocation growth
  must come from write completion or server-reported `AllocationSize`.

**Step 1.4 — Hidden bug fix?**
Record: Yes — this is a real correctness bug disguised as an accounting
fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 1 file: `fs/smb/client/inode.c` (+7 / -4 net)
- Function modified: `cifs_setsize()`
- Scope: single-file, surgical fix

**Step 2.2 — Code flow change**
Record:
- **Before:** On every `cifs_setsize()`, unconditionally
  `inode->i_blocks = CIFS_INO_BLOCKS(offset)`.
- **After:** Save `old_size`, update `i_size`, and only if `offset <
  old_size` clamp `i_blocks` down; on EOF extension, leave `i_blocks`
  unchanged.
- **Paths affected:** All callers of `cifs_setsize()` —
  truncate/ftruncate, fallocate EOF extension, clone/duplicate extents,
  truncate-to-zero.

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness bug** — `i_blocks` (allocation estimate) was
derived from EOF instead of actual allocation. This breaks the sparse-
file invariant used by swap activation.

**Step 2.4 — Fix quality**
Record: Obviously correct per SMB semantics (SetEOF ≠ allocate). Minimal
change. Low regression risk: shrink path still clamps; growth paths
(`netfs_update_i_size()` on write, `cifs_fattr_to_inode()` /
`smb2_close_getattr()` from server) remain intact.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Unconditional `inode->i_blocks = CIFS_INO_BLOCKS(offset)`
introduced in `f4e35576da439` (Paulo Alcantara, 2026-03-18) — "smb:
client: fix generic/694 due to wrong ->i_blocks". `cifs_setsize()`
itself dates to 2007; the buggy `i_blocks` assignment is recent.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag. The regression source is `f4e35576da439`,
which **is** in this tree (ancestor of HEAD, present since v6.18.22).

**Step 3.3 — Related file history**
Record: Recent `inode.c` changes include `efbcecdecefc2`
(fscache_resize_cookie in cifs_setsize), `f4e35576da439` (generic/694
i_blocks fix). This commit is a direct follow-up correcting the over-
broad generic/694 approach. Standalone; no "patch X/Y" series.

**Step 3.4 — Author context**
Record: Huiwen He has prior SMB client commits in this tree (e.g.
fallocate overlap handling). Steve French (maintainer) signed off.

**Step 3.5 — Dependencies**
Record: **Requires `f4e35576da439`** — without it, `cifs_setsize()` does
not set `i_blocks` from offset and this patch has nothing to fix in that
function. In this 6.18.44 tree, that prerequisite is satisfied. Patch
applies cleanly with only minor context (current tree has
`fscache_resize_cookie()` after `netfs_wait_for_outstanding_io()`).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: UNVERIFIED — lore.kernel.org blocked by bot protection. `b4 dig`
on the related generic/694 upstream commit (`23b5df09c27a`) found
https://patch.msgid.link/20260319034252.472217-1-pc@manguebit.org. Could
not locate this specific commit's thread (not yet in local git history,
no SHA for `b4 dig -c`).

**Step 4.2 — Reviewers**
Record: Reviewed-by and maintainer Signed-off-by present in commit
message. Full recipient list UNVERIFIED.

**Step 4.3 — Bug report**
Record: Concrete reproduction in commit message (dd + truncate + stat).
xfstests `generic/495` cited as trigger. No syzbot/external bug link.

**Step 4.4 — Related patches**
Record: Direct follow-up to `f4e35576da439` (generic/694). Complements
existing allocation update paths in `cifs_fattr_to_inode()`,
`smb2_close_getattr()`, and `netfs_update_i_size()`.

**Step 4.5 — Stable list history**
Record: UNVERIFIED — could not search lore stable archive.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `cifs_setsize()` (modified); related: `cifs_swap_activate()`,
`netfs_update_i_size()`, `cifs_fattr_to_inode()`.

**Step 5.2 — Callers of `cifs_setsize()`**
Record:
- `cifs_file_set_size()` — truncate/ftruncate path (`inode.c`)
- `smb3_simple_falloc()` — EOF extension (`smb2ops.c`)
- `smb2_duplicate_extents()` — clone size extension (`smb2ops.c`)
- truncate-to-zero in `file.c`

**Step 5.3 — Callees**
Record: `i_size_write()`, `truncate_pagecache()`,
`netfs_wait_for_outstanding_io()`, timestamp updates.

**Step 5.4 — Reachability**
Record: **Userspace-reachable** via `truncate(2)`/`ftruncate(2)` →
`cifs_setattr()` → `cifs_file_set_size()` → `cifs_setsize()`. Swap
activation via `swapon(2)` → `cifs_swap_activate()` reads cached
`i_blocks`.

**Step 5.5 — Similar patterns**
Record: NFS has identical swap hole check (`fs/nfs/file.c:584`).
`cifs_fattr_to_inode()` correctly uses `fattr->cf_bytes` (allocation),
not EOF — the fix aligns `cifs_setsize()` with that model.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **YES.** At `fs/smb/client/inode.c:3037`:

```3031:3037:fs/smb/client/inode.c
        spin_lock(&inode->i_lock);
        i_size_write(inode, offset);
        /*
  - Until we can query the server for actual allocation size,
  - this is best estimate we have for blocks allocated for a file.
         */
        inode->i_blocks = CIFS_INO_BLOCKS(offset);
```

The candidate fix is **not** yet in this tree (no matching commit or
strings).

**Step 6.2 — Backport complications**
Record: Clean apply expected. Only contextual difference:
`fscache_resize_cookie()` line after the modified block (commit diff
predates or omits it; trivial merge).

**Step 6.3 — Related fixes already present?**
Record: `f4e35576da439` (generic/694) is present and is the source of
the regression this commit corrects. No duplicate fix found.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `fs/smb/client` (CIFS/SMB3 client). Criticality: **IMPORTANT** —
network filesystem used broadly; swap-on-SMB is experimental but the
`i_blocks` cache affects `stat()` and hole detection for all truncate
users.

**Step 7.2 — Activity**
Record: Actively maintained; multiple recent smb/client fixes in this
tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: CIFS/SMB3 mount users who truncate files (especially sparse
files). Swap-on-CIFS users hit the worst case. `stat -c %b` can report
wrong block counts until revalidation.

**Step 8.2 — Trigger conditions**
Record: Extend EOF without allocating (truncate up, sparse fallocate).
Common operation. Unprivileged users can trigger on files they own.

**Step 8.3 — Failure severity**
Record: **HIGH** — `cifs_swap_activate()` hole check (`blocks*512 <
isize`) is bypassed when `i_blocks` is inflated, allowing swap
activation on a sparse file:

```3237:3244:fs/smb/client/file.c
        spin_lock(&inode->i_lock);
        blocks = inode->i_blocks;
        isize = inode->i_size;
        spin_unlock(&inode->i_lock);
        if (blocks*512 < isize) {
                pr_warn("swap activate: swapfile has holes\n");
                return -EINVAL;
        }
```

Using unallocated regions as swap risks data corruption. Wrong `stat`
blocks is a secondary user-visible correctness issue.

**Step 8.4 — Risk/benefit**
Record: **Benefit: HIGH** (correctness, swap safety, xfstests). **Risk:
LOW** (small, well-scoped; shrink still clamped; write/server paths
still grow `i_blocks`). Strong benefit/risk ratio.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real bug: EOF ≠ allocation on SMB; code incorrectly equates them
- Verifiable in local tree (`f4e35576da439` regression present)
- Causes swap hole check to accept invalid sparse swapfiles
- xfstests generic/495 failure documented
- Small, surgical, maintainer-reviewed fix
- Prerequisite commit present in 6.18.44

**AGAINST backport:**
- Fix depends on `f4e35576da439` being present (satisfied here)
- Swap-on-SMB is experimental (but the `stat`/i_blocks bug affects all
  truncate-up paths)
- Lore discussion UNVERIFIED

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic matches SMB semantics;
   xfstests cited; maintainer SOB
2. Fixes real bug affecting users? **PASS** — wrong cached allocation,
   swap acceptance
3. Important issue? **PASS** — HIGH: swap integrity / data corruption
   risk on sparse files
4. Small and contained? **PASS** — ~10 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — prerequisite present, clean apply

**Step 9.3 — Exception categories**
Record: N/A (standard bug fix).

**Step 9.4 — Decision rationale**
This is a regression fix for `f4e35576da439` in the 6.18.y tree. The
buggy code is present at HEAD. The fix restores correct `i_blocks`
accounting without breaking shrink or write/server update paths. It
meets all stable-kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Analyzed provided diff; confirmed current `cifs_setsize()`
  at inode.c:3029-3043
- [Phase 3] `git describe HEAD` → v6.18.44-1-g2736c32da98b9; `make
  kernelversion` → 6.18.44
- [Phase 3] `git blame` on inode.c:3037 → f4e35576da439 introduced
  unconditional i_blocks assignment
- [Phase 3] `git show f4e35576da439` → generic/694 fix added i_blocks to
  cifs_setsize
- [Phase 3] `git merge-base --is-ancestor f4e35576da439 HEAD` →
  prerequisite present
- [Phase 3] `git tag --contains f4e35576da439` → present since v6.18.22
- [Phase 3] `git log --grep="EOF extension"` / `--grep="account EOF"` →
  no match (fix not in tree)
- [Phase 4] WebFetch lore.kernel.org → blocked (bot protection)
- [Phase 4] `b4 dig -c 23b5df09c27a` → found generic/694 thread URL
- [Phase 4] UNVERIFIED: lore thread for this specific commit
- [Phase 5] `grep cifs_setsize` → 4 call sites in smb/client
- [Phase 5] Read `cifs_swap_activate()` at file.c:3223-3244 → hole check
  uses i_blocks vs i_size
- [Phase 5] Read `netfs_update_i_size()` at buffered_write.c:38-72 →
  write path grows i_blocks
- [Phase 5] Read `cifs_fattr_to_inode()` at inode.c:236-238 → server
  revalidation uses cf_bytes
- [Phase 5] Read `smb2_close_getattr()` at smb2ops.c:1530-1532 → server
  AllocationSize updates i_blocks
- [Phase 6] Confirmed buggy line at inode.c:3037 in HEAD
- [Phase 6] Confirmed fix strings absent from tree
- [Phase 8] Severity: swap hole check bypass → HIGH

**YES**The background searches are done. They match the earlier
analysis:

- **Target commit not in tree** — no matches for "EOF extension",
  "account EOF", or "generic/495" in `fs/smb/client/`.
- **Author history** — Huiwen He has prior SMB client work here
  (fallocate overlap handling, `FS_IOC_GETFLAGS`, etc.).
- **Fix-not-present check** — the `git log -S` search timed out, but a
  direct read of `cifs_setsize()` still shows the buggy unconditional
  `i_blocks = CIFS_INO_BLOCKS(offset)` at `inode.c:3037`, with no "Only
  clamp" fix applied.

**Verdict unchanged: YES** for backport to this 6.18.44 tree — it
corrects a regression from `f4e35576da439` where EOF extension is
wrongly treated as allocation, which can let `cifs_swap_activate()`
accept sparse swapfiles.

 fs/smb/client/inode.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c9e955d0d799e..af36936fde08b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3028,13 +3028,20 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
+	loff_t old_size;
+	u64 blocks = CIFS_INO_BLOCKS(offset);
+
 	spin_lock(&inode->i_lock);
+	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
+
 	/*
-	 * Until we can query the server for actual allocation size,
-	 * this is best estimate we have for blocks allocated for a file.
+	 * Extending EOF does not allocate the intervening range. Only clamp
+	 * i_blocks on shrink; allocation growth comes from writes or from the
+	 * server-reported AllocationSize.
 	 */
-	inode->i_blocks = CIFS_INO_BLOCKS(offset);
+	if (offset < old_size && (u64)inode->i_blocks > blocks)
+		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
-- 
2.53.0

