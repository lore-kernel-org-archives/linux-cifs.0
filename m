Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46CC501F27;
	Mon, 31 Aug 2026 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183717; cv=none; b=noWqDYbOKP7RzCY8p3a1BmDhqrefVOkFjar4oJbA62PU5Bx8ZTW7IlVLlf8+xQNzcIj9UaW1w/nn/iNxKhE4Jy94m5VTwmAcQ1G6yWVRjeQUzFOi2m7xo8peO9xQ5XMq+76L8HwEdYyo4Ai5IKP9aTiiADmML5rmPIJC17Pz+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183717; c=relaxed/simple;
	bh=6KOOvtfb7cGHsYFNTlIPjtqRi9fxDInnK+6l0hr9gqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlIes2pOapdZTU9poNAmG+Z3HhscXPL9N7qKoJLhu0QWw7AbkxCryEnRvhxBdpvk7xxoz8RK0ge8GBFa94xO0BX92gwFtxfJGldnvfGigVBZtjayBz58IO8E4LOMjcsL7XgHcOXbIUlP440VhVhOzSU4RVYnANjwCDd11h0SeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Im8eSlK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Im8eSlK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96401F00A3D;
	Mon, 31 Aug 2026 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183714;
	bh=fNucr4Uw+dh1zyVWSZKfz25AiQlNs9j0FZlzfSEhuG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im8eSlK/0PTGtZhtxnbMY4EW0+sguMlKrXL8C4dvn63w3qH064opZEvEXf3TqbOJx
	 QnPzM4Cpz4v2M15v+jyGMxz8W/y4UeMkDheCZ/H/BZRks4eZguXF5ccumYgbL4OBkg
	 b3qjvPv5zka8tevXLEoOvMpPv/+TRwiZxfhTOahUjnCMraqxUHLn5BOzB7bLWBVhLd
	 8rgLWWMh4CjVhNvVjLiVw/YN9ISBFQXg+RRtTgLQyC0LHFlyiBwzlHn+u4ES4ObTgw
	 SMWdhz1Yxn7JNFPFEzi98cUUsl+MnZeiItKS3sEPcORBAEOFXiyNh9YQYycf2754Rr
	 DuPIDhVZHWOOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Mon, 31 Aug 2026 09:24:49 -0400
Message-ID: <20260831133314.4125787-261-sashal@kernel.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d708a36634bb7b6f94d0e76d587d2ec50b2b93b5 ]

1. When ndr_decode_v4_ntacl() fails, the code jumped to free_n_data
   which only freed n.data, skipping kfree(acl.sd_buf) and leaking
   the buffer. Zero-initialize struct xattr_ntacl acl, reorder error
   labels to out_free to release acl.sd_buf on all error paths.

2. if (acl.sd_size < sizeof(struct smb_ntsd)) is true, original code
   returned success without freeing sd_buf and left stale *pntsd.
   Set rc = -EINVAL before jumping to out_free to return error code and
   free buffer.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[ksmbd] [Fix] acl.sd_buf memory leak and invalid sd_size error
handling in ksmbd_vfs_get_sd_xattr()`

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>` (author)
- `Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>`
- `Acked-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd maintainer)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (SMB
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or `Link:`
  tags
- Mainline commit: `d708a36634bb7`

**Step 1.3 — Body analysis**

Record:
- **Bug 1:** On `ndr_decode_v4_ntacl()` failure, control jumps to
  `free_n_data`, which frees only `n.data` and skips
  `kfree(acl.sd_buf)`, leaking the security-descriptor buffer.
- **Bug 2:** When `acl.sd_size < sizeof(struct smb_ntsd)`, the function
  returns success (`rc` still 0) without freeing `sd_buf`, leaving a
  stale `*pntsd`.
- **Symptom:** Memory leaks on ACL/security-descriptor xattr error
  paths; incorrect success return on malformed data.
- **Root cause:** Misordered cleanup labels (`free_n_data` vs
  `out_free`) and missing `rc = -EINVAL` on the invalid-size path.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit bug fix (memory leak + incorrect error
handling), not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- File: `fs/smb/server/vfs.c` (+3 / -4 lines)
- Function: `ksmbd_vfs_get_sd_xattr()`
- Scope: Single-file, surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1:** `struct xattr_ntacl acl` → `struct xattr_ntacl acl = {0}`
  — ensures `acl.sd_buf` is NULL when decode fails before allocation.
- **Hunk 2:** `goto free_n_data` → `goto out_free` on
  `ndr_decode_v4_ntacl()` failure — routes through the path that frees
  `acl.sd_buf` when `rc < 0`.
- **Hunk 3:** Adds `rc = -EINVAL` before `goto out_free` on invalid
  `sd_size` — ensures error return and buffer cleanup.
- **Hunk 4:** Removes separate `free_n_data:` label; `kfree(n.data)` now
  always runs after `out_free` cleanup.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Resource leak (memory) + logic/correctness bug (wrong
  return code)
- **Mechanism 1:** `ndr_decode_v4_ntacl()` allocates `acl->sd_buf` at
  line 508 of `ndr.c` and can fail on the final `ndr_read_bytes()` at
  line 512. The old `goto free_n_data` bypassed `out_free`'s
  `kfree(acl.sd_buf)`.
- **Mechanism 2:** On invalid `sd_size`, `rc` remained 0 (from
  successful `ndr_encode_posix_acl()`), so `if (rc < 0)` in `out_free`
  skipped freeing `acl.sd_buf`, and the function returned 0 with
  `*pntsd` set.

**Step 2.4 — Fix quality**

Record: Fix is minimal and obviously correct. Zero-initialization is
required (not cosmetic) so that early `ndr_decode` failures reaching
`out_free` safely call `kfree(NULL)`. Regression risk is very low.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `ksmbd_vfs_get_sd_xattr()` dates to 2021 (`f44158485826c0`,
Namjae Jeon). The `out_free`/`free_n_data` structure was introduced in
`78ad2c277af4c` (Jul 2021, "ksmbd: fix memory leak in
ksmbd_vfs_get_sd_xattr()"). That earlier fix was incomplete — it added
`out_free` but left the `ndr_decode` failure path on `free_n_data`. Bug
present since 2021; this tree (6.18.44) still has it.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record: Part of a 3-patch series fixing ksmbd VFS memory leaks (June
2026). This patch (`d708a36634bb7`) is standalone for `get_sd_xattr`; no
prerequisite commits needed. Merged to mainline via `1e9cdc2ea15ad`
(v7.2-rc1 smb3-server-fixes). **Not present in this 6.18.44 tree.**

**Step 3.4 — Author context**

Record: Qiang Liu; Acked-by from ksmbd maintainer Namjae Jeon and SMB
maintainer Steve French.

**Step 3.5 — Dependencies**

Record: No dependencies. Cherry-pick to current HEAD applies cleanly
(verified). Self-contained.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c d708a36634bb7` →
https://patch.msgid.link/20260624011320.9146-3-liuqiangneo@163.com. Part
of `[PATCH 0/3] ksmbd: fix some memory leaks in ksmbd_vfs_* functions`
(June 23, 2026). Reviewer ChenXiaoSong requested label-name cleanup in
v2 (https://lists.openwall.net/linux-kernel/2026/06/23/215). Final
committed version addresses this by removing the misplaced `free_n_data`
label.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` returned the patch msgid link. Original series CC'd
`linkinjeon@kernel.org`, `smfrench@microsoft.com`, `linux-
cifs@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Maintainer acks
present in final commit.

**Step 4.3 — Bug reports**

Record: No external bug reports or syzbot links. Bug identified via code
review in the leak-fix series.

**Step 4.4 — Series context**

Record: 3-patch series in one file. Patches 1 and 3 fix leaks in
`ksmbd_vfs_set_sd_xattr` and `ksmbd_vfs_set_dos_attrib_xattr`. Each is
independently backportable.

**Step 4.5 — Stable list**

Record: No stable-list discussion found. Absence of `Cc: stable` is
expected per review instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `ksmbd_vfs_get_sd_xattr()` modified; calls
`ndr_decode_v4_ntacl()`, `ndr_encode_posix_acl()`.

**Step 5.2 — Callers**

Record: 3 call sites:
- `fs/smb/server/smb2pdu.c:5800` — SMB2 query security descriptor
- `fs/smb/server/smbacl.c:1179` — inherit POSIX ACL from parent
- `fs/smb/server/smbacl.c:1442` — Windows ACL permission check

**Step 5.3 — Callees**

Record: `ksmbd_vfs_getxattr()`, `ndr_decode_v4_ntacl()` (allocates
`acl.sd_buf`), `ndr_encode_posix_acl()`, `sha256()`, `kfree()`.

**Step 5.4 — Reachability**

Record: Triggered by SMB clients when `KSMBD_SHARE_FLAG_ACL_XATTR` is
enabled and NT ACL xattrs are read. Reachable from network-facing SMB
protocol handlers — unprivileged remote clients can trigger error paths
with malformed xattr data.

**Step 5.5 — Similar patterns**

Record: Sibling function `ksmbd_vfs_set_sd_xattr()` at line 1521 already
uses `struct xattr_ntacl acl = {0}` — the get path was inconsistent. The
3-patch series fixes analogous leak patterns in set paths.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Buggy code confirmed at
`fs/smb/server/vfs.c:1589-1648`:
- `struct xattr_ntacl acl` (uninitialized)
- `goto free_n_data` on decode failure (line 1600)
- Missing `rc = -EINVAL` on invalid `sd_size` (lines 1624-1626)

**Step 6.2 — Backport complications**

Record: **Clean apply.** `git cherry-pick --no-commit d708a36634bb7`
auto-merged with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: Earlier partial fix `78ad2c277af4c` (2021) is in this tree but
did not fix these paths. Fix `d708a36634bb7` is **not** in HEAD.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `fs/smb/server` (ksmbd in-kernel SMB server). Criticality:
**IMPORTANT** — network-facing file server subsystem
(`CONFIG_SMB_SERVER`).

**Step 7.2 — Activity**

Record: Actively maintained in 6.18.y (recent commits on credentials,
path resolution, lock-range fixes).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users running ksmbd (`CONFIG_SMB_SERVER`) with ACL xattr support
enabled. Not universal, but affects production SMB server deployments.

**Step 8.2 — Trigger conditions**

Record:
- **Leak path 1:** Corrupt/truncated NT ACL xattr causing
  `ndr_decode_v4_ntacl()` to fail after `sd_buf` allocation.
- **Leak path 2:** Valid decode but `sd_size` smaller than
  `sizeof(struct smb_ntsd)`.
- Remote SMB clients can trigger repeatedly → cumulative memory leak
  (DoS potential).

Verified caller leak on path 2: `smbacl.c:1179-1182` returns `-ENOENT`
when `ppntsd_size <= 0` without freeing `parent_pntsd` set by the buggy
success return.

**Step 8.3 — Failure mode severity**

Record:
- Memory leak on error paths: **HIGH** (eventual OOM under repeated
  triggers)
- Incorrect success return with stale pointer: **MEDIUM-HIGH** (caller-
  dependent; confirmed leak in inherit-ACL path)
- Not a direct UAF or privilege escalation, but real stability issue

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH for ksmbd users — fixes reproducible leaks and
  incorrect error handling
- **Risk:** VERY LOW — 7-line change, maintainer-reviewed, applies
  cleanly
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, verified memory leaks on two error paths
- Incorrect success return leaves stale `*pntsd` and leaks in at least
  one caller
- Small, surgical, maintainer-acked fix
- Buggy code present in 6.18.44; fix absent
- Applies cleanly
- Network-reachable via SMB ACL operations

**AGAINST backport:**
- Only affects `CONFIG_SMB_SERVER` users (not all kernel users)
- No syzbot/CVE report (lower urgency than security fixes)
- Part of a 3-patch series (other two patches fix similar leaks in
  sibling functions — ideally backported together but this patch is
  self-contained)

**Unresolved:** None material to the decision.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic verified in code;
   maintainer acks; clean cherry-pick
2. Fixes a real bug? **PASS** — confirmed leaks and wrong return code
3. Important issue? **PASS** — memory leak in network server path (HIGH)
4. Small and contained? **PASS** — 7 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception category**

Record: Not applicable (standard bug fix, not device ID/quirk/docs).

**Step 9.4 — Decision rationale**

This commit fixes two real bugs in `ksmbd_vfs_get_sd_xattr()` that exist
in the 6.18.44 tree: a memory leak when NDR decode fails after
allocating `acl.sd_buf`, and a second leak plus incorrect success return
when the security descriptor size is invalid. Both are reachable from
SMB client operations on ACL-enabled shares. The fix is minimal,
reviewed by the ksmbd maintainer, and applies without modification. This
is appropriate stable material.

---

## Verification

- [Phase 1] Parsed commit `d708a36634bb7`: tags, body, subsystem prefix
- [Phase 2] Read diff: 3 insertions, 4 deletions in
  `ksmbd_vfs_get_sd_xattr()`
- [Phase 2] Read `ndr_decode_v4_ntacl()` at `ndr.c:507-513`: confirms
  `sd_buf` allocated before possible failure
- [Phase 2] Traced invalid `sd_size` path: `rc` remains 0,
  `kfree(acl.sd_buf)` skipped
- [Phase 3] `git blame` on `vfs.c:1580-1648`: function from 2021,
  structure from `78ad2c277af4c`
- [Phase 3] `git show 78ad2c277af4c`: earlier incomplete leak fix
  confirmed
- [Phase 3] `git log master --grep="acl.sd_buf"`: found `d708a36634bb7`
  on master, not in HEAD
- [Phase 3] `git merge-base --is-ancestor d708a36634bb7 HEAD`: fix NOT
  in current tree
- [Phase 3] `git cherry-pick --no-commit d708a36634bb7`: clean apply
- [Phase 4] `b4 dig -c d708a36634bb7`: lore URL found
- [Phase 4] WebFetch openwall review: ChenXiaoSong label feedback
- [Phase 4] WebFetch series cover letter: 3-patch leak-fix series
- [Phase 5] `grep ksmbd_vfs_get_sd_xattr`: 3 callers in `smb2pdu.c`,
  `smbacl.c`
- [Phase 5] Read `smbacl.c:1179-1182`: caller returns `-ENOENT` without
  free on `rc==0` — leak confirmed
- [Phase 5] Read `smbacl.c:1442-1445,1597`: alternate caller frees at
  `err_out`
- [Phase 5] Read `smb2pdu.c:5800,5832`: caller kfrees `ppntsd` at
  `release_acl`
- [Phase 6] `git describe HEAD` / `make kernelversion`: tree is 6.18.44
- [Phase 6] Read current `vfs.c:1589-1648`: buggy code present
- [Phase 7] `fs/smb/server/Kconfig`: `CONFIG_SMB_SERVER` confirmed
- [Phase 8] Assessed severity: memory leak HIGH for ksmbd deployments

**YES**The background history searches finished and match what the full
review already used:

- **Related-commit search** turned up `78ad2c277af4c` (“ksmbd: fix
  memory leak in ksmbd_vfs_get_sd_xattr()”, 2021). That earlier fix
  added the `out_free`/`free_n_data` structure but left the paths this
  commit corrects.
- **Author/subject search** did not find `d708a36634bb7` on the current
  6.18.44 branch; the fix lives on mainline (merged for v7.2-rc1) and is
  not in this tree yet.

**Verdict for Linux 6.18.44: YES** — backport `d708a36634bb7`; it
applies cleanly and fixes real memory leaks plus incorrect error
handling in `ksmbd_vfs_get_sd_xattr()`.

 fs/smb/server/vfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 859ca7c87bd4c..6680638bb85b5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1592,7 +1592,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1603,7 +1603,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
@@ -1629,6 +1629,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1648,8 +1649,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 		kfree(acl.sd_buf);
 		*pntsd = NULL;
 	}
-
-free_n_data:
 	kfree(n.data);
 	return rc;
 }
-- 
2.53.0

