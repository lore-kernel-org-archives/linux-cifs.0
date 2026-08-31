Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E1502B72;
	Mon, 31 Aug 2026 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183720; cv=none; b=B+O9d4PEiqHfluZwqb15WD14mGmTQdj8s0YAPczjjtzMekEjFTj7Gi0oZ1MLDBvMj68a+0OhFf2n9HIGso1qFJl4fHRb4nj3drpFmjvExTK5djpTvymSarAGYTXxcKa41VqmG682QA4/7thzaaS5eoaiA6b+hxPc9D+L4iI1YUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183720; c=relaxed/simple;
	bh=jI3MifJvURhCMhe5llb9pFhFuFsESKWsNnvxvx/pKxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuG4tNVDcxEqDgFJ8x5kWa610cdcouL+3xnLHcBiJpSREvVJT2xH6vgTwlgSe9sEWwUro76b5lFpxTa3XDJbcimR5wQb9H5SUqNuiquO+NjeDaQai3Ck0e+PSbx2aK1x7swDSlcmWvJeK18vsj4pEJTyoo65aYgYzHKVte3s32g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBpwFlKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBpwFlKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D591F00ACA;
	Mon, 31 Aug 2026 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183718;
	bh=nhkSkPNfquyN3SBcKGraIf5P7Jf9eFxdbKaoJ3lQBq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBpwFlKxVIh4sthzIeKV7O5n8YPDNDAQDTQT0qsFv8XgaQ6KOmmG2qRIgAPRvXh9u
	 BQc9SXJpbMMfzAcznkgov/48hXl4g/4TdK3NQURi/F2nmrdZwz/UW0x1QFD4utxwrW
	 c9AskacBvSQyhpejgEitLAk0M/+qkJfWKtJFSuNXqFhoHCaWlvRjp3NKH/qu/clkhQ
	 kdVo344bkzs1jxJMH/d/11I9YikvcYBeLx2TXauIskBkDWe55SbSwyfifbJpqWVLKL
	 0sc1eOyLww6IRqbBGfV8JnrvMgFiSiHDbFA/LRTTSbeZ5Y/ELeb8FfeEPbz+dSOmKp
	 vcyjKHm78QvGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: start file id allocation at 1
Date: Mon, 31 Aug 2026 09:24:51 -0400
Message-ID: <20260831133314.4125787-263-sashal@kernel.org>
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

[ Upstream commit 6b375be0b4e1be89e9a817880515311503a19114 ]

ksmbd allocates both the volatile id (per-session file table) and the
persistent id (global file table) with idr_alloc_cyclic() starting at 0.
The first open after the module loads therefore gets volatile id 0 and
persistent id 0, and ksmbd returns an SMB2 FileId of {0, 0} in the create
response.

Clients treat an all-zero FileId as a null handle. smbtorture's
smb2_util_handle_empty() considers {0, 0} empty, so tests that guard the
close with it (e.g. smb2.oplock.statopen1, smb2.lease.statopen*) never
close that first handle. The leaked open keeps the inode's oplock count
non-zero, so a later batch oplock request on the same file is downgraded
to level II and the test fails.

Start the id allocation at 1 (KSMBD_START_FID) so no handle is ever
assigned a {0, 0} FileId, matching the behaviour of other SMB servers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: start file id allocation at 1`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`,
`VERSION=6`, `PATCHLEVEL=18`, `SUBLEVEL=44`)

**Commit under review:** `6b375be0b4e1be89e9a817880515311503a19114` (not
yet in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ksmbd]` `[start]` — Change SMB2 file ID allocation so the
first assigned ID is 1 instead of 0.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — none (expected for manual review)
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>`
  (author/maintainer), Steve French `<stfrench@microsoft.com>` (SMB
  maintainer)
- No syzbot, no user bug reports, no explicit stable nomination in the
  commit message.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `idr_alloc_cyclic()` starts at 0 for both volatile (per-
  session) and persistent (global) file IDs. The first open after module
  load returns SMB2 FileId `{0, 0}`.
- **Symptom:** Clients treat `{0, 0}` as a null handle and skip `CLOSE`.
  The server leaks the open; oplock counts stay elevated, breaking batch
  oplock behavior.
- **Root cause:** ID allocation starts at 0; `{0, 0}` is semantically a
  null handle in the SMB ecosystem.
- **Fix:** Set `KSMBD_START_FID` to 1 and pass it to
  `idr_alloc_cyclic()`, matching Samba/Windows behavior.
- **Version info:** None in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup — this is an explicit protocol-
correctness and resource-management fix. The leak is real: clients that
treat `{0, 0}` as empty never send `CLOSE`, so `__ksmbd_close_fd()` and
`fd_limit_close()` are never called for that handle.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- `fs/smb/server/vfs_cache.h`: +6 / -1 (comment + `KSMBD_START_FID` 0 →
  1)
- `fs/smb/server/vfs_cache.c`: +2 / -1 (`idr_alloc_cyclic` start `0` →
  `KSMBD_START_FID`)
- **Functions modified:** `__open_id()` (indirectly via macro)
- **Scope:** Single-subsystem, 2-file surgical fix (~8 lines net)

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`vfs_cache.h`):** `KSMBD_START_FID` was defined as `0` but
  unused; now `1` with documentation.
- **Hunk 2 (`vfs_cache.c`):** `idr_alloc_cyclic(ft->idr, fp, 0, ...)` →
  `idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, ...)`.
- **Before:** First allocated volatile and persistent IDs are 0; CREATE
  response is `{PersistentFileId=0, VolatileFileId=0}`.
- **After:** First IDs are 1; CREATE response is never `{0, 0}`.
- **Path affected:** Every file open via `ksmbd_open_fd()` →
  `__open_id()` and durable opens via `ksmbd_open_durable_fd()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Resource leak + logic/protocol correctness
- **Mechanism:** Server assigns ID 0 and considers it valid
  (`has_file_id(0)` is true). Clients treat `{0, 0}` as null and never
  close. Server leaks `ksmbd_file` entries and fd-limit budget; oplock
  state becomes incorrect for affected inodes.

### Step 2.4: Fix quality
**Record:** Obviously correct — uses an existing macro name, one-line
behavioral change, matches other SMB servers. Very low regression risk;
no API or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `idr_alloc_cyclic(..., 0, ...)` introduced in `3867369ef8f760`
  (2021-07-08, Namjae Jeon): `ksmbd: change data type of
  volatile/persistent id to u64`
- `KSMBD_START_FID` defined as `0` since `1a93084b9a898` (2021-06-28):
  `ksmbd: move fs/cifsd to fs/ksmbd`
- Bug present since ksmbd inception; long-lived in this tree.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:** Recent `vfs_cache.c` history is active (UAF fixes, durable-
handle races, fd management). No prior fix for ID-0 allocation. Part of
a 29-patch series (`[PATCH 27/29]`), but this patch is standalone — no
dependency on other series commits.

### Step 3.4: Author's other commits
**Record:** Namjae Jeon is the ksmbd maintainer; recent commits in this
tree include multiple UAF and race fixes in the same subsystem. Steve
French committed the merge.

### Step 3.5: Prerequisites
**Record:** No prerequisites. `KSMBD_START_FID` already exists in this
tree; patch applies cleanly with no structural dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- `b4 dig -c 6b375be0b4e1b`:
  https://patch.msgid.link/20260621124844.6235-27-linkinjeon@kernel.org
- Series: v1, 29 patches, dated 2026-06-21
- Lore page blocked by bot protection; could not read thread replies
- No stable nomination verified from lore

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd to `linux-cifs@vger.kernel.org`, Steve
French, and other SMB reviewers. Maintainer involvement confirmed.

### Step 4.3: Bug report search
**Record:** No external bug report. Evidence is smbtorture failure
(`smb2.oplock.statopen1`, `smb2.lease.statopen*`) and maintainer
knowledge of client behavior.

### Step 4.4: Related patches
**Record:** Patch 27/29 in a larger ksmbd series; this change is
independent.

### Step 4.5: Stable mailing list
**Record:** Not searched (lore blocked); no stable discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__open_id()`, `ksmbd_open_fd()`, `ksmbd_open_durable_fd()`,
`has_file_id()`

### Step 5.2: Callers
**Record:**
- `__open_id()` called from `ksmbd_open_fd()` (normal opens) and
  `ksmbd_open_durable_fd()` (persistent IDs)
- `ksmbd_open_fd()` is on the hot SMB2 CREATE path for every file open
- Reachable from userspace over the network (SMB client CREATE)

### Step 5.3: Callees
**Record:** `idr_alloc_cyclic()`, `idr_preload()`,
`fd_limit_depleted()`, `__open_id_set()`, `write_lock/unlock`

### Step 5.4: Call chain / reachability
**Record:** SMB client CREATE → `ksmbd_open_fd()` → `__open_id()` → ID 0
on first open after module load. **Userspace-reachable** via SMB
protocol; triggers on every server's first file open after (re)start.

### Step 5.5: Similar patterns
**Record:** `has_file_id()` treats `0` as valid (`id < KSMBD_NO_FID`),
but SMB clients treat `{0, 0}` as null — server/client semantic
mismatch. No other instances of this pattern found in ksmbd.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** In this 6.18.44 tree:
- `KSMBD_START_FID` is `0` in `fs/smb/server/vfs_cache.h:26`
- `idr_alloc_cyclic(ft->idr, fp, 0, INT_MAX - 1, GFP_NOWAIT)` at
  `vfs_cache.c:676`
- Fix commit `6b375be0b4e1b` is **not** an ancestor of HEAD

### Step 6.2: Backport complications
**Record:** Clean apply expected — identical code structure, macro
already present. No conflicts anticipated.

### Step 6.3: Related fixes already present?
**Record:** No duplicate fix found. `git log --grep="start file id"`
returns nothing in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/smb/server/` (ksmbd, `CONFIG_SMB_SERVER`) —
**IMPORTANT** for deployments using the in-kernel SMB server; not core
kernel, but file-serving correctness matters for those users.

### Step 7.2: Subsystem activity
**Record:** Highly active — 239 ksmbd commits since 2025-01-01 in this
tree; ongoing maintenance and bug fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_SMB_SERVER` (ksmbd) enabled. Every
deployment hits this on the first file open after module load or server
restart.

### Step 8.2: Trigger conditions
**Record:**
- **When:** First SMB2 CREATE after ksmbd module load/restart (per
  session for volatile ID; globally for persistent ID)
- **Likelihood:** Certain on every restart
- **Privilege:** Any SMB client with access to a share

### Step 8.3: Failure mode severity
**Record:**
- Leaked `ksmbd_file` entry (never closed by client)
- `fd_limit` counter permanently decremented (`fd_limit_depleted()` on
  open, no matching `fd_limit_close()` on client-driven close) — can
  eventually cause `-EMFILE` for new opens
- Incorrect oplock state (elevated oplock count blocks proper batch
  oplocks)
- **Severity: MEDIUM-HIGH** for ksmbd users — not a kernel oops, but a
  real resource leak with functional impact on a common path

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Fixes protocol non-compliance and per-restart resource
  leak affecting all ksmbd deployments; aligns with Samba/Windows
- **Risk:** Very low — 8-line constant change, no new APIs, no locking
  changes
- **Ratio:** Strong benefit, minimal risk for `CONFIG_SMB_SERVER` users

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compiled

**FOR backport:**
- Real bug: resource leak + broken oplock semantics on first open after
  restart
- Affects every ksmbd deployment on a common path
- Tiny, obviously correct fix from subsystem maintainers
- Bug present since ksmbd was added (~2021)
- Buggy code confirmed in this 6.18.44 tree; fix not yet applied
- Clean backport with no dependencies
- Progressive fd-limit depletion from leaked handles

**AGAINST backport:**
- No user bug reports — discovered via smbtorture
- Not a crash, UAF, security issue, or data corruption
- `CONFIG_SMB_SERVER` is optional; smaller user base than core
  subsystems
- Lore review thread not accessible for stable nomination confirmation

**Unresolved:**
- Could not verify lore review comments (bot protection)
- No independent confirmation that Windows clients skip CLOSE for `{0,
  0}` beyond maintainer statement and smbtorture behavior

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial constant change;
   maintainer-signed; part of tested series
2. Fixes a real bug? **PASS** — handle leak and oplock breakage
3. Important issue? **PASS** — resource leak on common path with
   functional impact (oplocks, fd limits); not crash-level but
   materially affects file-server operation
4. Small and contained? **PASS** — 8 lines, 2 files
5. No new features or APIs? **PASS** — behavior correction only
6. Can apply to local tree? **PASS** — clean apply, no prerequisites

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies on merit as a protocol/resource-management bug fix.

### Step 9.4: Decision rationale
For this **6.18.y** tree, ksmbd is present and the buggy code is live.
Every server restart leaks the first opened handle from compliant SMB
clients, permanently consumes fd-limit budget, and corrupts oplock
state. The fix is minimal, maintainer-authored, and matches established
SMB server practice. The issue is below crash/security severity but
clearly meets stable criteria as a real, user-visible resource leak on a
guaranteed code path.

---

## Verification

- **[Phase 1]** Parsed commit `6b375be0b4e1b`: only Signed-off-by tags;
  no Fixes/Reported-by/Link/Cc: stable
- **[Phase 2]** Diff: 2 files, ~8 lines; `KSMBD_START_FID` 0→1;
  `idr_alloc_cyclic` start 0→`KSMBD_START_FID`
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame` line 676:
  `idr_alloc_cyclic` with start 0 since 2021
- **[Phase 3]** `git merge-base --is-ancestor 6b375be0b4e1b HEAD`: exit
  1 — fix NOT in tree
- **[Phase 3]** `git log -S KSMBD_START_FID`: macro introduced
  2021-06-28
- **[Phase 4]** `b4 dig -c 6b375be0b4e1b`: lore URL found; patch 27/29
  in v1 series
- **[Phase 4]** `b4 dig -w`: maintainers CC'd (linux-cifs, smfrench)
- **[Phase 4]** UNVERIFIED: Lore thread content (bot protection on
  patch.msgid.link)
- **[Phase 5]** `grep has_file_id`: `has_file_id(0)` returns true (`id <
  KSMBD_NO_FID`); CREATE sets `rsp->PersistentFileId`/`VolatileFileId`
  from fp IDs at `smb2pdu.c:3649-3650`
- **[Phase 5]** `fd_limit_depleted()`/`fd_limit_close()` at
  `vfs_cache.c:48-61`: leaked handle prevents limit restoration
- **[Phase 6]** `grep KSMBD_START_FID`: only in header, value 0;
  `idr_alloc_cyclic` uses literal 0 at line 676
- **[Phase 6]** `CONFIG_SMB_SERVER` in `fs/smb/server/Kconfig`
- **[Phase 7]** 239 ksmbd commits since 2025-01-01 in this tree
- **[Phase 8]** Failure mode: resource leak + oplock corruption + fd-
  limit depletion; severity MEDIUM-HIGH for ksmbd users

**YES**The background search finished: the fix is commit `6b375be0b4e1b`
on master (merged via the v7.2 SMB3 server fixes tag). It is not in this
6.18.44 tree yet.

That matches the earlier analysis: the buggy `{0, 0}` FileId allocation
is still present here, and the fix is a small, low-risk protocol
correction that stops handle leaks and oplock issues on the first open
after ksmbd starts.

**YES**

 fs/smb/server/vfs_cache.c | 3 ++-
 fs/smb/server/vfs_cache.h | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index aee974a264d51..7b8d3b5ad1c2d 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -698,7 +698,8 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 
 	idr_preload(KSMBD_DEFAULT_GFP);
 	write_lock(&ft->lock);
-	ret = idr_alloc_cyclic(ft->idr, fp, 0, INT_MAX - 1, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, INT_MAX - 1,
+			       GFP_NOWAIT);
 	if (ret >= 0) {
 		id = ret;
 		ret = 0;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index ad7a487a21bb0..955bbf11f1926 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -23,7 +23,12 @@
 #define	FILE_GENERIC_WRITE	0x120116
 #define	FILE_GENERIC_EXECUTE	0X1200a0
 
-#define KSMBD_START_FID		0
+/*
+ * Start volatile/persistent file id allocation at 1. A file id of 0 yields an
+ * SMB2 FileId of {0, 0}, which clients (e.g. Windows, Samba) treat as a null
+ * handle and never close, leaking the open on the server.
+ */
+#define KSMBD_START_FID		1
 #define KSMBD_NO_FID		(INT_MAX)
 #define SMB2_NO_FID		(0xFFFFFFFFFFFFFFFFULL)
 
-- 
2.53.0

