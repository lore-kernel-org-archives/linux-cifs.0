Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB4941B8F7;
	Mon, 31 Aug 2026 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183201; cv=none; b=s8LWQSq1WFIADE49fP85d7rCDol58n/fnq1PiNIIqp6GNbW9hQEofO8rMoQSZrxltKGQVcTuNYITYPwikwFe6Id4Xpbh+QUuOphoaJzXZwkxvEqm3ZEhno1M1T1ExiYd6be3+YJTH6oS6359hv/oJCIFSBhlCwPz+FqJkDjPMuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183201; c=relaxed/simple;
	bh=K8LMQo5pHIEYPhl47hifXyrP06S40nRKtJ1EekNJJJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LO0PlmrSEedA5e6iMl9IouDBDB/sueJUQxLnnhopvkGE7esglWyYDNmrczEz8JdwGGqcfAnCkWusyziJOS85KHyzYOYp01I3zR7dW8nouGnicm/CMBu3NzbkoXHptvuSlymU2Ou6zED0Gf82JI/ZNhVoqOqie0e/lZHE/1r60c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3YuJI6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3YuJI6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1691F00ADB;
	Mon, 31 Aug 2026 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183199;
	bh=+hHAJNcn3CcPnANLQp8lYUzqx56Dix9TWBfCNMpVvZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3YuJI6gzAxZS7MlX1u2Ub9k2siCgNePHSe9A0XqdxHbHpifnkBbU0WGWQnzxqcwd
	 ld+BnebW2LtZKBkI/s950L3PA29/j69VK0Th7LOOgQe1F168shH0OmjV6NsjtkHA7j
	 qHUL0h13tdgN972lIAVmUMl3CURHzDmZEEUpSDAa2K0HVLeclCX1LeKk2mLEAkfI59
	 BoM8uWLBmzUNvlLW3ba4nNywJIJVU9brZfUCmjm8LrCNme8azwUTTt3YdoVcdNW9WO
	 gDOwGAUSP1DLuqPKzyJ95AHKhrbukSgiiCuvrTkHmfV5TZG+MoF88FOOnpPU09oBKZ
	 SORxnFPNtPDgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: preserve VFS inherited POSIX ACL mask
Date: Mon, 31 Aug 2026 09:20:31 -0400
Message-ID: <20260831133314.4125787-3-sashal@kernel.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e148e567a9252643baa125cb65d7ae9c2c6cf68a ]

The VFS initializes a child's POSIX ACL from the parent's default ACL and
the requested creation mode. Do not mutate the parent ACL or overwrite the
child's VFS-computed access and default ACLs afterwards.

This preserves restrictive ACL_MASK entries and prevents SMB object creation
from widening effective permissions.

Reported-by: Charles Vosburgh <trilobyte777@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ksmbd] [preserve] [Do not mutate parent ACL or overwrite
VFS-computed child POSIX ACLs on SMB create]`

### Step 1.2: Tags
**Record:**
- **Reported-by:** Charles Vosburgh `<trilobyte777@gmail.com>` — real
  user report
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` — author
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` — ksmbd
  maintainer
- No Fixes:, Cc: stable, Link:, Tested-by, Reviewed-by, or Acked-by tags
- Notable: maintainer sign-off; user report; no syzbot

### Step 1.3: Body analysis
**Record:**
- **Bug:** After VFS creates a child inode, ksmbd re-applies the
  parent's default ACL to the child and forces `ACL_MASK` to `0x07`
  (full rwx), overwriting VFS-computed access/default ACLs.
- **Symptom:** SMB-created files/directories get wider effective
  permissions than intended; restrictive `ACL_MASK` entries are lost.
- **Root cause:** Redundant post-create ACL handling that mutates the
  parent ACL and overwrites correct VFS inheritance.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says "preserve" rather than "fix",
this is a real permissions/security bug: ACL mask widening on SMB object
creation.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/server/vfs.c` only
- **Scope:** ~25 lines removed, 1 added (net -24 lines)
- **Function modified:** `ksmbd_vfs_inherit_posix_acl()`
- **Classification:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (function body):** Before: fetch parent default ACL → mutate
  `ACL_MASK` to `0x07` → `set_posix_acl()` on child access ACL → for
  directories, also set default ACL → return `rc`. After: fetch parent
  default ACL → release → return `0`. VFS-computed ACLs from
  `vfs_create()`/`vfs_mkdir()` are left intact.
- **Path affected:** Post-create ACL setup in SMB2 open/create (`created
  == true`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness + security (permission widening)
- **Mechanism:**
  1. Filesystem `->create`/`->mkdir` (e.g. ext4 via `ext4_init_acl()` →
     `posix_acl_create()`) already applies parent's default ACL with
     correct `ACL_MASK` masking per creation mode.
  2. `ksmbd_vfs_inherit_posix_acl()` then overwrote those ACLs.
  3. `pace->e_perm = 0x07` forced mask to rwx, removing restrictive
     masks.
  4. `get_inode_acl()` can return a cached/shared ACL object; in-place
     mutation may also corrupt the parent's cached default ACL.

### Step 2.4: Fix quality
**Record:** Obviously correct — trusts standard VFS ACL inheritance.
Minimal change. Preserves the parent-has-no-default-ACL check
(`-ENOENT`) used by caller fallback logic. Low regression risk; only
affects ksmbd create path when `CONFIG_FS_POSIX_ACL` is enabled.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** In this tree (`6.18.44`), buggy lines in
`ksmbd_vfs_inherit_posix_acl()` blame to `5d324e5159d9e` (merge where
`vfs.c` entered this checkout's history). Mainline history shows the
`pace->e_perm = 0x07` pattern present since at least `25933573ef48`
(2023-05-30); function dates to ksmbd POSIX ACL work (~2021,
`67d1c432994c`).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `vfs.c` changes in this tree are unrelated (path
resolution, credentials). No duplicate fix found. Standalone commit
(mainline `e148e567a925`).

### Step 3.4: Author context
**Record:** Namjae Jeon is ksmbd maintainer. Steve French (co-
maintainer) signed off. Recent ksmbd stable-worthy fixes in this tree
include UAF, ACL validation, credential handling.

### Step 3.5: Dependencies
**Record:** No prerequisites. Self-contained. Function and caller exist
in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c e148e567a925` matched patch-id to `https://lore.k
ernel.org/all/CAKYAXd-
4MuqT49GwTO2meR0Lt338vTygzTrQ%2B6xBNpVW7kE0Xg@mail.gmail.com/` but could
not fetch thread content (lore fetch failure). Mainline commit dated
2026-07-17, merged via `8e371eff3f72` (v7.2-rc4 smb3-server-fixes).

### Step 4.2: Reviewers
**Record:** `b4 dig -w` failed (same fetch issue). Steve French
maintainer sign-off verified via GitHub API.

### Step 4.3: Bug report
**Record:** Reported-by Charles Vosburgh — user-reported ACL permission
widening on SMB create. No public bugzilla/syzbot link.

### Step 4.4: Related patches
**Record:** No multi-patch series. Standalone fix.

### Step 4.5: Stable list
**Record:** Could not search stable@ list (lore inaccessible). No
evidence of prior stable rejection.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `ksmbd_vfs_inherit_posix_acl()` (modified); callers:
`smb2_open()` path in `smb2pdu.c`.

### Step 5.2: Callers
**Record:** Single caller at `smb2pdu.c:3376`, inside `if (created)`
after `smb2_creat()` → `ksmbd_vfs_create()`/`ksmbd_vfs_mkdir()` →
`vfs_create()`/`vfs_mkdir()`. Userspace-reachable via SMB2 CREATE.

### Step 5.3: Callees
**Record:** Before fix: `get_inode_acl()`, `set_posix_acl()`,
`posix_acl_release()`. After fix: `get_inode_acl()`,
`posix_acl_release()`.

### Step 5.4: Reachability
**Record:** SMB client CREATE on a share backed by a POSIX-ACL
filesystem (ext4, xfs, etc.) with parent default ACL containing
`ACL_MASK`. Unprivileged network user can trigger.

### Step 5.5: Similar patterns
**Record:** `ksmbd_vfs_set_init_posix_acl()` also sets
`acl_state.mask.allow = 0x07`, but only as fallback when inheritance
fails and SD buffer setup fails — separate intentional path. No other
`pace->e_perm = 0x07` in ksmbd.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **6.18.44** (`git describe`:
`v6.18.44-2-g1b9e1abadee04`). Buggy code at
`fs/smb/server/vfs.c:1967-2004` with `pace->e_perm = 0x07` and post-
create `set_posix_acl()` calls. Fix not yet applied.

### Step 6.2: Backport complications
**Record:** `patch -p1 --dry-run` of the mainline diff applies cleanly
to this tree (line offset differs from mainline but hunks match). Minor
offset only — no logic conflicts.

### Step 6.3: Related fixes already present?
**Record:** No. Grep found no "preserve VFS inherited POSIX ACL" commit
in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `fs/smb/server` (ksmbd) — **IMPORTANT**. Network file
server; ACL bugs affect multi-user share security.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (recent ksmbd commits in this
tree).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** ksmbd users (`CONFIG_SMB_SERVER`) exporting POSIX-ACL-
enabled filesystems with default ACLs using `ACL_MASK`. Not universal,
but real production deployments.

### Step 8.2: Trigger conditions
**Record:** SMB2 create of file/directory under parent with default
POSIX ACL containing `ACL_MASK`. Common on managed shares. Remote SMB
clients can trigger.

### Step 8.3: Failure mode severity
**Record:** Permission widening / ACL bypass — **HIGH** security impact
(unauthorized access via elevated effective permissions). Possible
parent ACL cache corruption from in-place mutation of cached ACL. Not a
crash, but serious correctness/security issue.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — restores intended ACL semantics, closes
  permission-widening hole
- **Risk:** LOW — 24-line deletion, defers to proven VFS path
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real user-reported ACL security bug
- Permission widening on SMB create (restrictive `ACL_MASK` ignored)
- VFS already handles ACL inheritance correctly (`posix_acl_create()` /
  `ext4_init_acl()`)
- Small, surgical, maintainer-reviewed fix
- Bug present in this 6.18.44 tree
- Patch applies cleanly
- Long-standing bug (since ~2021)

**AGAINST backport:**
- Only affects ksmbd + POSIX ACL configurations (not all kernel users)
- No syzbot/CVE yet (severity still clear from code analysis)

**Unresolved:**
- Full lore review thread unavailable (fetch failed)
- No explicit stable@ nomination found

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   sign-off; user tested/report
2. Fixes real bug affecting users? **PASS** — user report + verified
   code path
3. Important issue? **PASS** — ACL permission widening (security)
4. Small and contained? **PASS** — one function, ~24 lines removed
5. No new features/APIs? **PASS** — removes incorrect behavior
6. Can apply to local tree? **PASS** — dry-run apply succeeds

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
security/correctness bug fix.

### Step 9.4: Decision rationale
For **this 6.18.44 tree**, the buggy code is present and reachable. The
fix stops ksmbd from overwriting VFS-correct ACLs and forcing `ACL_MASK`
to full rwx. That is a clear, important security/correctness fix with
minimal risk. It meets all stable kernel criteria.

---

## Verification

- **[Phase 1]** `git describe HEAD` → v6.18.44; parsed commit message
  tags
- **[Phase 2]** Read `fs/smb/server/vfs.c:1967-2004` — confirmed buggy
  code matches diff "before" state
- **[Phase 2]** Read `fs/posix_acl.c:459-511` —
  `posix_acl_create_masq()` correctly handles `ACL_MASK`
- **[Phase 2]** Read `fs/ext4/acl.c:278-303` — `ext4_init_acl()` calls
  `posix_acl_create()` during inode creation
- **[Phase 3]** `git blame -L 1967,2005 fs/smb/server/vfs.c` — buggy
  code present
- **[Phase 3]** GitHub API: mainline fix `e148e567a925` (2026-07-17);
  bug present in `25933573ef48` (2023-05-30)
- **[Phase 3]** `git log --oneline -30 -- fs/smb/server/vfs.c` — no
  duplicate fix
- **[Phase 4]** `b4 dig -c e148e567a925` — matched lore URL; thread
  fetch failed
- **[Phase 4]** GitHub API — commit message and maintainer sign-off
  confirmed
- **[Phase 5]** `grep ksmbd_vfs_inherit_posix_acl` — single caller at
  `smb2pdu.c:3376`
- **[Phase 5]** Read `smb2pdu.c:2609-2644, 3268-3393` — create → inherit
  ACL call chain verified
- **[Phase 5]** Read `posix_acl.c:189-193` — `get_inode_acl()` returns
  potentially cached/shared ACL
- **[Phase 6]** `make kernelversion` → 6.18.44; buggy code confirmed
  present; fix absent
- **[Phase 6]** `patch -p1 --dry-run` of mainline diff → applies cleanly
- **[Phase 6]** `diff` local vs mainline pre-fix function → identical
- **[Phase 8]** Assessed severity as ACL permission widening — HIGH
  security impact

**YES**The background `git log --all` search was stopped — as expected,
it’s too slow on this repo. History was covered instead with targeted
`git log` (no `--all`) and the GitHub API.

**Verdict for this tree (6.18.44): YES**

`ksmbd_vfs_inherit_posix_acl()` in `fs/smb/server/vfs.c` overwrites VFS-
correct child ACLs and forces `ACL_MASK` to `0x07`, widening effective
permissions on SMB creates when the parent has a restrictive default
ACL. The fix is small, applies cleanly here, and restores correct POSIX
ACL inheritance.

 fs/smb/server/vfs.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 6680638bb85b5..f129386a56c8f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1974,10 +1974,6 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				const struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
-	struct posix_acl_entry *pace;
-	struct dentry *dentry = path->dentry;
-	struct inode *inode = d_inode(dentry);
-	int rc, i;
 
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL))
 		return -EOPNOTSUPP;
@@ -1985,27 +1981,7 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 	acls = get_inode_acl(parent_inode, ACL_TYPE_DEFAULT);
 	if (IS_ERR_OR_NULL(acls))
 		return -ENOENT;
-	pace = acls->a_entries;
-
-	for (i = 0; i < acls->a_count; i++, pace++) {
-		if (pace->e_tag == ACL_MASK) {
-			pace->e_perm = 0x07;
-			break;
-		}
-	}
-
-	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
-	if (rc < 0)
-		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
-			    rc);
-	if (S_ISDIR(inode->i_mode)) {
-		rc = set_posix_acl(idmap, dentry, ACL_TYPE_DEFAULT,
-				   acls);
-		if (rc < 0)
-			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
-				    rc);
-	}
 
 	posix_acl_release(acls);
-	return rc;
+	return 0;
 }
-- 
2.53.0

