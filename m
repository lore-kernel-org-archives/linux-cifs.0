Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAFD4B515F;
	Mon, 31 Aug 2026 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184343; cv=none; b=bWTmwa8nOGvxXij18e7zrzbn+xKR0EpBa1g763DIDOjldExKjAlHtxk4GYIQkaBVE3Ao5oYzYsH850a3HdSI552cbd+0m5cG27wiPKCE9pd2y4osRCo8IvLvnSkTBe6rq2e4pvFktdcMNmCtAQiZULhtpJve2s6ZrSjoohSZ9wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184343; c=relaxed/simple;
	bh=eHx3amXNhOVlef7GzxiXEqJtumuGXI7EImt89ZvyRyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNtYXg3P9z7opfa88tgHZu6wqBM33RjvBP5Mgs+HOHiUVbKT0vMcvvDwjcuFI8nuAUoOyUKMI56/YJFxkgiWT7l+sJXTmTecK1LiqYxIjeUnos2FYlpmxwYfXzrFWmDrAaO3v6+X0p4rYZiCh4hy9XnIs83QJg9b6PMiLHYLPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajMcV7Ph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajMcV7Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2711F00A3E;
	Mon, 31 Aug 2026 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184340;
	bh=1wGb+6oE0KrrHjfDj2IYokzShLHSQgCgV8eSZ+XEUhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajMcV7Ph5GdgXIGENvc6dEzaKoKrRWTMEttLSyY/j4f3sNt4EFKByS0VJT0bu0p7b
	 ono0obKkPeUjkGxsAs7EC4yDB7MIG3bBmnAvmutKaCDXrLQtPxawWNCFllJK6QDgo+
	 fhpu7FvT092aWIiDJljDfkq7Dz7vIRu2M9LWe7m1uBb5kTv1RUC+NJfAtjDBUQvvG7
	 +KV84Lt5nZ/EPZJmZEfoUCu4bVx3Y7ZFPckr3OP/8Mm+G9rUZGhbcFm4DLcDJPaole
	 5HsFbTIVWILmHCzANT28sqS1CtO/rO99D/iHoMH281/rUR7rElmw9W3MGamWNtiGWA
	 n8fC4t1nRm7ZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: deny renaming directory with open children
Date: Mon, 31 Aug 2026 09:31:04 -0400
Message-ID: <20260831133314.4125787-636-sashal@kernel.org>
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

[ Upstream commit c841bd3d8dec33a000d6e31b7e7fafb22c39e4e9 ]

Windows denies renaming a directory while a file below that directory is
still open. smb2.rename.rename_dir_openfile checks this by keeping a file
handle open under the directory and then attempting to rename the directory
handle.  ksmbd did not check open children before calling vfs_rename(), so
the rename incorrectly succeeded.

For non-POSIX clients, scan the global open file table for active handles
whose dentries are below the directory being renamed.  If any child is
open, fail the rename with -EACCES so the client receives
STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: deny renaming directory with open
children`

**Local tree:** `v6.18.44` (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, Makefile `6.18.44`)
**Commit analyzed:** `c841bd3d8dec3` (on `origin/master`, not yet in
this checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd] [deny] — reject directory rename when descendant
files remain open (SMB/Windows semantics)`

### Step 1.2: Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable@vger.kernel.org:** none (expected for manual review)
- **Signed-off-by:** Namjae Jeon, Steve French (ignore pipeline-added
  SOBs)

Notable: no fuzzer or user bug reports; rationale is Windows conformance
(`smb2.rename.rename_dir_openfile`).

### Step 1.3: Body analysis
**Record:**
- **Bug:** ksmbd allowed `vfs_rename()` on a directory while files
  beneath it were still open.
- **Symptom:** Rename succeeds; Windows returns `STATUS_ACCESS_DENIED`.
- **Root cause:** No scan of active SMB file handles under the target
  directory before rename.
- **Fix approach:** For non-POSIX clients, walk `global_ft` and fail
  with `-EACCES` if any `FP_INITED` handle dentry is a subdirectory of
  the directory being renamed.
- **Version info:** none in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as conformance, but it corrects incorrect
server behavior that can surprise Windows SMB clients and fail MS
protocol tests. Not a kernel crash/UAF, but a real functional/protocol
bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `fs/smb/server/vfs.c` | +6 lines |
| `fs/smb/server/vfs_cache.c` | +25 lines, +1 include |
| `fs/smb/server/vfs_cache.h` | +1 prototype |

**Functions:** `ksmbd_vfs_rename()`, new `ksmbd_has_open_files()`
**Scope:** Single-subsystem, surgical (~32 lines). **Classification:**
small, contained fix.

### Step 2.2: Code flow per hunk

**Hunk 1 — `vfs.c`:**
- **Before:** Proceed from rename setup directly to parent sharing
  checks and `vfs_rename()`.
- **After:** If non-POSIX tree connection, target is a directory, and
  `ksmbd_has_open_files(old_child)` → return `-EACCES` before rename.
- **Path:** SMB2 `SET_INFO` / `FILE_RENAME_INFORMATION` →
  `ksmbd_vfs_rename()`.

**Hunk 2 — `vfs_cache.c`:**
- **Before:** No helper to detect open descendants.
- **After:** `ksmbd_has_open_files()` iterates `global_ft.idr` under
  `global_ft.lock`, skips non-`FP_INITED` entries and the directory
  itself, uses `is_subdir(fp_dentry, dentry)`.

**Hunk 3 — `vfs_cache.h`:** Export prototype.

### Step 2.3: Bug mechanism
**Record:** **Category:** logic / SMB protocol correctness.
**Mechanism:** Linux VFS permits directory rename with open children;
Windows SMB does not. ksmbd delegated to VFS without enforcing SMB
semantics. Fix adds an explicit open-handle check for non-POSIX clients.

### Step 2.4: Fix quality
**Record:**
- **Correctness:** Mirrors documented Windows behavior; uses existing
  `global_ft` + `is_subdir()` patterns.
- **Minimal:** Yes.
- **Regression risk:** Low. POSIX-extension connections are explicitly
  excluded (`!work->tcon->posix_extensions`). Only denies renames that
  Windows would deny.
- **Red flags:** None significant. Scan is O(n) in open files —
  acceptable on rename path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `ksmbd_vfs_rename()` dates to cifsd/ksmbd origins (Namjae
Jeon, 2021). Missing open-children check has been present since rename
support; not a recently introduced regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Part of 29-patch series (`[PATCH 08/29]`, Jun 2026).
- Related sibling: `9a5784f4d58b0` “check parent directory sharing
  conflicts on rename” (patch 07/29) — separate concern, also not in
  this tree.
- Prior rename fixes in this tree: `53e3e5babc096` (empty string),
  `68477b5dc5710` (rename failure), `4973b04d3ea57` (RENAME_NOREPLACE).
- **Standalone:** This patch does not depend on other series members.

### Step 3.4: Author context
**Record:** Namjae Jeon is ksmbd maintainer; Steve French committed.
Active ksmbd development in this tree.

### Step 3.5: Dependencies
**Record:** Requires `global_ft`, `FP_INITED`, `posix_extensions`,
`is_subdir()` — all present in v6.18.44. No prerequisite commits needed
for the logic itself.

**Backport note:** `vfs.c` context differs from upstream commit parent.
Local tree uses `lock_rename_child()` / `unlock_rename()`; upstream
patch targets `start_renaming_dentry()` / `end_renaming()`.
`vfs_cache.c` and `vfs_cache.h` should apply cleanly; `vfs.c` needs
relocation after dentry validation (~line 749), before `parent_fp`
check.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c c841bd3d8dec3` →
  https://patch.msgid.link/20260621124844.6235-8-linkinjeon@kernel.org
- Series: `[PATCH 08/29]`
- WebFetch of lore URL blocked (bot protection); thread retrieved via
  `b4 dig -m /tmp/ksmbd_rename_thread.mbx`
- No explicit `Cc: stable` found in thread grep
- No NAKs found in mbox grep

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned same lore URL; CC includes Steve French
/ linux-cifs list. Maintainer-authored.

### Step 4.3: Bug report
**Record:** N/A — reference is MS test
`smb2.rename.rename_dir_openfile`, not a user/syzbot report.

### Step 4.4: Series context
**Record:** 29-patch ksmbd series; this patch is independently
applicable.

### Step 4.5: Stable list
**Record:** Not searched separately; no stable nomination found in patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ksmbd_has_open_files()`, `ksmbd_vfs_rename()`, callers
`smb2_rename()` → `set_rename_info()` → `smb2_set_info_file()`.

### Step 5.2: Callers
**Record:** Reachable from SMB2 `SET_INFO` / rename — userspace-
triggerable by any SMB client with rename permission. Rename locks are
already held in `ksmbd_vfs_rename()` when the check would run.

### Step 5.3: Callees
**Record:** `idr_for_each_entry()`, `is_subdir()`, `d_is_dir()`,
`read_lock(&global_ft.lock)`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** via SMB2 rename of a directory
handle. Common file-server operation for `CONFIG_SMB_SERVER` / ksmbd
users.

### Step 5.5: Similar patterns
**Record:** `ksmbd_lookup_fd_cguid()` uses the same `global_ft`
iteration pattern. `ksmbd_lookup_fd_inode()` checks `FP_INITED`.
`-EACCES` maps to `STATUS_ACCESS_DENIED` in `smb2_set_info()` err_out
(lines 6722–6723).

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** `ksmbd_vfs_rename()` at lines 691–814 has no open-
children check. `ksmbd_has_open_files()` is absent. Bug present since
rename support landed.

### Step 6.2: Backport complications
**Record:** **Minor rework** for `vfs.c` only (different rename helper
API). `vfs_cache.c`/`vfs_cache.h` clean apply expected.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix. Related rename sharing fix
(`9a5784f4d58b0`) also absent but separate.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **ksmbd / SMB server** (`fs/smb/server/`). **IMPORTANT** for
deployments using in-kernel SMB server; not universal like mm/net core.

### Step 7.2: Activity
**Record:** Actively developed; many recent ksmbd commits in v6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** **CONFIG-dependent** — users running ksmbd with non-POSIX
SMB clients performing directory renames.

### Step 8.2: Trigger conditions
**Record:** Rename a directory via SMB while another open handle exists
on a file/subdirectory beneath it. Unprivileged SMB user with
delete/rename rights can trigger. Not timing-dependent.

### Step 8.3: Failure mode severity
**Record:** **Incorrect success** of forbidden rename (protocol
violation). Not kernel oops/UAF/leak. Possible client confusion /
namespace inconsistency vs Windows expectations. **Severity: MEDIUM**
(functional/protocol; not CRITICAL kernel stability).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Windows SMB compatibility; passes MS conformance test;
  aligns with established Windows semantics; low-risk behavioral
  correction.
- **Risk:** Very low — small, well-scoped denial path.
- **Ratio:** Favorable for ksmbd stable users; precedent exists for
  ksmbd rename/protocol fixes in stable (e.g. `53e3e5babc096`,
  `ca4974ca95456`).

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real, reproducible protocol bug (MS test case named in commit).
- Small (32 lines), obviously correct, maintainer-authored.
- Buggy code exists in v6.18.44.
- All infrastructure present (`global_ft`, `is_subdir`,
  `posix_extensions`).
- `-EACCES` → `STATUS_ACCESS_DENIED` mapping verified.
- ksmbd rename/protocol correctness fixes have stable precedent in this
  tree.

**AGAINST backport:**
- Not crash, security, memory safety, or explicit data corruption.
- No user/syzbot reports.
- Part of larger series (though standalone).
- `vfs.c` needs minor context adaptation for this tree.
- Only affects ksmbd users; POSIX-extension clients excluded.

**Unresolved:** No production user reports verified; lore thread not
fully readable via WebFetch.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — clear logic; MS test
   reference; maintainer commit.
2. Fixes real bug affecting users? **PASS** — incorrect SMB rename
   semantics for Windows clients.
3. Important issue? **PASS (borderline)** — protocol correctness
   affecting SMB file-server interoperability; not kernel
   crash/corruption, but “real bug that bothers people” per stable rules
   for server workloads.
4. Small and contained? **PASS** — 32 lines, 3 files.
5. No new features/APIs? **PASS** — enforces existing protocol
   semantics; no userspace API change.
6. Can apply to local tree? **PASS** — `vfs_cache.*` clean; `vfs.c`
   needs relocated hunk.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Protocol
correctness fix.

### Step 9.4: Decision rationale

This is not a kernel-stability fix, but it is a genuine, well-defined
SMB server bug: ksmbd incorrectly allows an operation Windows explicitly
forbids. For v6.18.y users running ksmbd as a Windows-compatible file
server, the fix is small, low-risk, and matches the class of ksmbd
rename/protocol corrections already carried in stable. The buggy path
exists in this tree and all prerequisites are present.

---

## Verification

- **[Phase 1]** Parsed commit `c841bd3d8dec3` message; no
  Fixes/Reported-by/Link/Cc:stable tags.
- **[Phase 2]** Diff: +32 lines across 3 files; new
  `ksmbd_has_open_files()`; check in `ksmbd_vfs_rename()`.
- **[Phase 3]** `git blame` on `ksmbd_vfs_rename()`: function since
  2021; `git log origin/master`: commit not in HEAD; merge-base
  confirmed divergence.
- **[Phase 3]** `git show 9a5784f4d58b0`: related rename sharing fix,
  separate.
- **[Phase 4]** `b4 dig -c c841bd3d8dec3`: lore URL found; patch 08/29.
- **[Phase 4]** `b4 dig -m`: thread saved; no stable CC found in grep.
- **[Phase 5]** `grep ksmbd_vfs_rename`: called from `smb2pdu.c:6167`.
- **[Phase 5]** Read `smb2_set_info()` err_out: `-EACCES` →
  `STATUS_ACCESS_DENIED` (lines 6722–6723).
- **[Phase 5]** `grep is_subdir` in `fs/dcache.c`: `bool
  is_subdir(struct dentry *new, struct dentry *old)`.
- **[Phase 6]** `git describe HEAD`: v6.18.44; `ksmbd_has_open_files`
  absent in tree.
- **[Phase 6]** Read local `ksmbd_vfs_rename()` (691–814): no open-
  children check; uses `lock_rename_child`.
- **[Phase 6]** `grep global_ft` in `vfs_cache.c`: present since
  durable-handle support.
- **[Phase 6]** `grep posix_extensions` in `fs/smb/server/`: present on
  `tree_connect`.
- **[Phase 7]** ksmbd active in v6.18.44 per `git log --
  fs/smb/server/`.
- **[Phase 8]** Failure mode: protocol violation, not kernel crash;
  severity MEDIUM.

**YES**The background searches finished. The commit `c841bd3d8dec3`
(“ksmbd: deny renaming directory with open children”) is on
`origin/master` but not in your local v6.18.44 tree yet.

Recent history on `fs/smb/server/vfs.c` shows active ksmbd rename work
(path resolution, credential handling, VFS rename API updates), which
confirms the `vfs.c` hunk would need minor relocation for this tree —
the `vfs_cache.c`/`vfs_cache.h` parts should apply cleanly.

**Verdict from the full analysis: YES** — small SMB protocol correctness
fix worth backporting to this tree.

 fs/smb/server/vfs.c       |  6 ++++++
 fs/smb/server/vfs_cache.c | 25 +++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 32 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 764eca75291ce..32009ff8dfa45 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -748,6 +748,12 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out3;
 	}
 
+	if (!work->tcon->posix_extensions && d_is_dir(old_child) &&
+	    ksmbd_has_open_files(old_child)) {
+		err = -EACCES;
+		goto out3;
+	}
+
 	parent_fp = ksmbd_lookup_fd_inode(old_child->d_parent);
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 51e37e89d1aa5..aee974a264d51 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/dcache.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -649,6 +650,30 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
+bool ksmbd_has_open_files(struct dentry *dentry)
+{
+	struct ksmbd_file *fp;
+	unsigned int id;
+	bool ret = false;
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		struct dentry *fp_dentry = fp->filp->f_path.dentry;
+
+		if (fp->f_state != FP_INITED)
+			continue;
+		if (fp_dentry == dentry)
+			continue;
+		if (is_subdir(fp_dentry, dentry)) {
+			ret = true;
+			break;
+		}
+	}
+	read_unlock(&global_ft.lock);
+
+	return ret;
+}
+
 #define OPEN_ID_TYPE_VOLATILE_ID	(0)
 #define OPEN_ID_TYPE_PERSISTENT_ID	(1)
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 10f4172ec8017..ad7a487a21bb0 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -165,6 +165,7 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
+bool ksmbd_has_open_files(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
-- 
2.53.0

