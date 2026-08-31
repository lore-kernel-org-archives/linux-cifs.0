Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8834AA587;
	Mon, 31 Aug 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184011; cv=none; b=qE2DRK4qb72f1poaCtKLek63ztgk5VBAYSU/2uSmFdm8T/pzp3xapQHbmPAZKUtfsuLof+sBlDwytFo1d+ET5rl7l4dpebVFqSWUDBBOJK0HuN3wF+c5VZztjNbRHLCf/W1mdoXvfoYeXIG0+NFQ22o/gZ5IMhmkgHmXWhOsYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184011; c=relaxed/simple;
	bh=epeug6m9JjtpboUSuTtJ+voCATAVtX/U6HdyDb9Mojs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1nt/kx9Sy+AZP3C3l4RidH7wY9omprluz/G2ITxR11ddUzSjMpPGqg4CNPQOlg8PvkxbAWoOiJNC0wTJOaC+e2hzjJmy37sTmy6MInwGZd8cXp8YoKoNn16c4/gIba+GHH9ImTmQw4Zur+PPRsPHuycE1UMUpJzAzLw392/Qg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwevBQ0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwevBQ0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77131F00ACF;
	Mon, 31 Aug 2026 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184006;
	bh=JUjSG+2N2M82OX1vNWeP3fNexHqvslrWSoQCJhFQBCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwevBQ0tcQbZD7PYkp+humy+XaEuF2rAhZ7tGgzqZOzMYskrNpWqieurDJID8TkJk
	 3S4DwUSlejOwamW9Mi6B6pQuCLt+qImVyVdYwoyv9+dB+u9ipi7P0VeVsTUEv6JDOz
	 bO3nnnYfE81KyODnBkoIXj7OoCupak8/dHqiRSHcHYL6HLn3lFksPJMrzR/k9EQABr
	 aHD2CYFxA41dhiB60T/L5MGJf5hmjYuUVa/26r+bsH/nADiQHjV1U1Q7+RoSD4CfAq
	 eCZB4Yuui9YMn3u9ouYDalZHSlNAvu4HZj3F6w9bi1hypizf7VXKpWiuviSSsn8VGr
	 hKBhYYOxQlodw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: break RH leases before delete-on-close
Date: Mon, 31 Aug 2026 09:27:42 -0400
Message-ID: <20260831133314.4125787-434-sashal@kernel.org>
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

[ Upstream commit 1f1083c36fa11c5d9011451c7b9ab380545c72ea ]

The delete paths only marked the opened file delete pending or
delete-on-close.  When another client still held a read/handle lease, no
lease break was sent before the delete state changed.

smb2.lease.unlink uses a create request with FILE_DELETE_ON_CLOSE and
expects the second client's unlink to break the first client's RH lease to
R with ACK_REQUIRED set.  SetInfo(FileDispositionInformation) has the same
lease-breaking requirement.

Break level-II/read-handle leases before setting delete pending or
delete-on-close so clients are notified before the file is removed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ksmbd]` `[break]` — Break read/handle (RH) SMB2 leases
before marking files delete-pending or delete-on-close.

### Step 1.2: Tags
**Record:** Tags present:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (author)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (ksmbd
  maintainer)

Not present (expected for this review pipeline): `Fixes:`, `Reported-
by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Cc:
stable@vger.kernel.org`, `Link:`

Notable: Maintainer sign-off from Steve French; no syzbot or user bug
reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Delete paths (`FILE_DELETE_ON_CLOSE` on CREATE,
  `SetInfo(FileDispositionInformation)`) set delete state without
  sending lease-break notifications to clients holding RH (read+handle)
  leases.
- **Symptom:** SMB2 clients are not notified before delete;
  `smb2.lease.unlink` smbtorture test expects RH lease break to `R` with
  `ACK_REQUIRED` on second-client unlink.
- **Root cause:** Delete handlers called
  `ksmbd_fd_set_delete_on_close()` / `ksmbd_set_inode_pending_delete()`
  directly, skipping `smb_break_all_levII_oplock()`.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit protocol-conformance / lease-
coherency bug fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/server/smb2pdu.c` only (+7 / −3 lines)
- **Functions modified:** `smb2_open()`, `set_file_disposition_info()`,
  `smb2_set_info_file()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Changes
**Record:**
1. **`smb2_open()` hunk:** Before → if `FILE_DELETE_ON_CLOSE`, only
   `ksmbd_fd_set_delete_on_close()`. After → call
   `smb_break_all_levII_oplock(work, fp, 0)` first, then set delete-on-
   close.
2. **`set_file_disposition_info()` hunk:** Signature gains `struct
   ksmbd_work *work`. Before → on `DeletePending`, only
   `ksmbd_set_inode_pending_delete()`. After → break level-II/RH leases
   first.
3. **`smb2_set_info_file()` hunk:** Passes `work` into
   `set_file_disposition_info()`.

All affected paths are normal SMB2 request handling (CREATE with delete-
on-close, SET_INFO disposition).

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic / protocol correctness (lease
coherency).

**Mechanism:** SMB2 requires breaking conflicting RH leases before
delete state changes. The server skipped notification, leaving clients
with active read/handle caches on files being deleted. Fix mirrors the
existing rename path pattern (`smb_break_all_levII_oplock(work, fp, 0)`
at line 6169 after successful rename).

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — identical pattern to rename and other
  ksmbd lease-break call sites.
- **Minimal:** Yes — two call sites + signature plumbing.
- **Regression risk:** Very low — only adds lease breaks before delete;
  `smb_break_all_levII_oplock()` already guards on
  `KSMBD_SHARE_FLAG_OPLOCKS` and skips non-level-II/non-RH leases.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Delete-on-close in `smb2_open()` introduced in `e2f34481b24db`
  (2021-05-10, "cifsd: add server-side procedures for SMB3").
- `set_file_disposition_info()` delete-pending path same origin
  (`e2f34481b24db`); directory-empty check from `64b39f4a2fd293`
  (2021-03-30).
- Bug has existed since ksmbd SMB3 support landed; present throughout
  6.18.y.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- Precedent: `3fc74c65b3674` ("ksmbd: send lease break notification on
  FILE_RENAME_INFORMATION", 2024-01-09) — same class of fix, already
  **in** this 6.18.44 tree.
- Target commit `1f1083c36fa11` is **not** in this tree (`merge-base
  --is-ancestor` returns not ancestor).
- Part of 14-patch series (patch 12/14) on master; this specific hunk is
  self-contained.

### Step 3.4: Author Context
**Record:** Namjae Jeon is primary ksmbd author/maintainer. Recent
6.18.y ksmbd work includes security/correctness fixes (UAF, negotiate
races, permission checks).

### Step 3.5: Dependencies
**Record:** No prerequisites required for this tree:
- `smb_break_all_levII_oplock()` exists in `fs/smb/server/oplock.c`
  (since before 6.18).
- `struct ksmbd_work *work` is available at all call sites.
- Cherry-pick to current HEAD applies cleanly (verified: 7 insertions, 3
  deletions, no conflicts).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c 1f1083c36fa11`:
  https://patch.msgid.link/20260618141739.9029-12-linkinjeon@kernel.org
- Series: v1 only (no v2/v3 revisions found for this patch).
- Lore web fetch blocked by Anubis bot protection — could not read
  inline review thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC list: `linux-cifs@vger.kernel.org`, Steve
French (`smfrench@gmail.com`), Sergey Senozhatsky, Tom Talpey, Metze,
Atte Jääskeläinen. Appropriate subsystem coverage.

### Step 4.3: Bug Report
**Record:** No external bug report. Failure mode documented via
`smb2.lease.unlink` smbtorture expectation in commit message. No
syzbot/KASAN report.

### Step 4.4: Related Patches
**Record:** Patch 12/14 of "ksmbd: validate SMB2 lease create contexts"
series. Patches 13–14 address v2 lease-break routing; patch 12 is
independently applicable and matches the rename-path approach already in
6.18.y.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). No stable nomination found in
available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `smb2_open()`, `set_file_disposition_info()`,
`smb_break_all_levII_oplock()`, `ksmbd_fd_set_delete_on_close()`,
`ksmbd_set_inode_pending_delete()`.

### Step 5.2: Callers
**Record:**
- `smb2_open()` — SMB2 CREATE handler (common file-server path).
- `set_file_disposition_info()` — called only from
  `smb2_set_info_file()` on `FILE_DISPOSITION_INFORMATION`.
- `smb2_set_info_file()` — SMB2 SET_INFO handler.

All reachable from authenticated SMB clients when `CONFIG_SMB_SERVER`
(ksmbd) is enabled with oplocks/leases.

### Step 5.3: Callees
**Record:** `smb_break_all_levII_oplock()` iterates inode oplock list,
calls `oplock_break()` to send SMB2 lease-break notifications to clients
with level-II or RH leases.

### Step 5.4: Reachability
**Record:** Triggered by any SMB client issuing CREATE with
`FILE_DELETE_ON_CLOSE` or SET_INFO `FileDispositionInformation` with
`DeletePending=TRUE` on a share with oplocks enabled. Multi-client lease
scenarios are the intended ksmbd use case. Userspace-reachable via SMB
protocol.

### Step 5.5: Similar Patterns
**Record:** Same `smb_break_all_levII_oplock(work, fp, 0)` already used
after rename (`smb2_rename` success at line 6169) and in vfs paths.
Delete was the missing symmetric case.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes** in linux-6.18.44 (`v6.18.44-1-g2736c32da98b9`):
- Lines 3531–3532: delete-on-close without lease break.
- Lines 6458–6462: disposition delete-pending without lease break.
Bug present since ~2021; not introduced after 6.18 branch.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — cherry-pick of `1f1083c36fa11` auto-merges
with no conflicts. Minor line-number offset from master (e.g., `-EINVAL`
vs `-EMSGSIZE` in nearby code) does not affect the fix hunks.

### Step 6.3: Related Fixes Already Present?
**Record:** Rename lease-break fix (`3fc74c65b3674`) is already in
6.18.y. This delete-path fix is the complementary missing piece. No
duplicate fix found.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `fs/smb/server` (ksmbd in-kernel SMB server). **IMPORTANT**
for deployments using ksmbd; peripheral for kernels built without
`CONFIG_SMB_SERVER`.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y — recent commits include UAF
fixes, negotiate hardening, permission enforcement.

---

## Phase 8: Impact and Risk

### Step 8.1: Who Is Affected
**Record:** ksmbd users with SMB2 oplocks/leases enabled on multi-client
shares. Config-specific (`CONFIG_SMB_SERVER`), not universal.

### Step 8.2: Trigger Conditions
**Record:** Client A holds RH lease; Client B deletes same file via
CREATE+`FILE_DELETE_ON_CLOSE` or SET_INFO disposition. Requires oplocks
enabled on share. Realistic in enterprise/embedded NAS scenarios.
Authenticated SMB clients can trigger.

### Step 8.3: Failure Severity
**Record:** **MEDIUM-HIGH** for affected deployments:
- Not a kernel oops/panic.
- SMB2 protocol violation; `smb2.lease.unlink` conformance failure.
- Clients may retain stale read/handle caches after another client
  deletes the file — user-visible coherency/correctness issue on a file
  server.
- Does not corrupt server-side filesystem data, but can cause incorrect
  client behavior.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for ksmbd+lease users — restores spec-
  compliant lease breaks on delete, matching rename behavior already in
  tree.
- **Risk:** VERY LOW — 10-line change using established helper,
  maintainer-reviewed.
- **Ratio:** Favorable for backport to this tree.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, long-standing protocol bug in code present in 6.18.44
- Direct precedent: rename lease-break fix already in 6.18.y
- Small, surgical, applies cleanly
- Maintainer sign-off (Steve French)
- smbtorture-documented expectation (`smb2.lease.unlink`)
- Multi-client cache coherency impact

**AGAINST backport:**
- Not a kernel crash, security CVE, or server-side data corruption
- Only affects `CONFIG_SMB_SERVER` + oplocks/leases
- Part of larger series (though this patch is standalone)
- No explicit stable nomination or user bug reports found

**Unresolved:** Full lore review thread unavailable (Anubis block).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors rename path;
   smbtorture case cited; maintainer SOB.
2. Fixes real bug affecting users? **PASS** — SMB2 lease-break omission
   on delete paths.
3. Important issue? **PASS (MEDIUM-HIGH)** — protocol/coherency bug for
   multi-client file servers; not kernel crash but materially affects
   ksmbd correctness.
4. Small and contained? **PASS** — 1 file, 10 lines.
5. No new features/APIs? **PASS** — uses existing
   `smb_break_all_levII_oplock()`.
6. Can apply to local tree? **PASS** — verified clean cherry-pick.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale

For **linux-6.18.y (v6.18.44)**, this commit should be backported. The
buggy delete paths have existed since ksmbd SMB3 support and are present
in this tree. The fix is minimal, follows an established in-tree pattern
(rename already breaks RH leases via the same helper), applies without
dependencies, and corrects a real SMB2 lease-coherency defect that
affects multi-client file-server deployments — the primary use case for
ksmbd with leases enabled.

---

## Verification

- [Phase 1] Parsed commit `1f1083c36fa11`: only author + maintainer
  Signed-off-by tags
- [Phase 2] Diff: 7+/3− in `fs/smb/server/smb2pdu.c`; two
  `smb_break_all_levII_oplock()` additions
- [Phase 3] `git blame`: delete paths from `e2f34481b24db` (2021-05-10)
- [Phase 3] `git show 3fc74c65b3674`: rename lease-break precedent;
  confirmed ancestor of HEAD
- [Phase 3] `merge-base --is-ancestor 1f1083c36fa11 HEAD`: commit NOT in
  6.18.44 tree
- [Phase 3] Cherry-pick test: applies cleanly (7 insertions, 3
  deletions, no conflicts)
- [Phase 4] `b4 dig -c 1f1083c36fa11`: lore URL found
- [Phase 4] `b4 dig -a`: v1 only, patch 12/14
- [Phase 4] `b4 dig -w`: linux-cifs + Steve French CC'd
- [Phase 4] WebFetch lore: **FAILED** (Anubis bot wall)
- [Phase 5] `grep smb_break_all_levII_oplock`: helper exists; rename
  uses same call at line 6169
- [Phase 5] `grep set_file_disposition_info`: single caller in
  `smb2_set_info_file()`
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
  (linux-6.18.y)
- [Phase 6] Read lines 3531–3532, 6458–6462: buggy code confirmed
  present
- [Phase 6] Read `smb_break_all_levII_oplock()` at oplock.c:1380:
  function fully implemented
- [Phase 7] `fs/smb/server/Kconfig`: `CONFIG_SMB_SERVER` controls ksmbd
- [Phase 8] Failure mode: client lease coherency / protocol non-
  compliance, not kernel crash

**YES**

 fs/smb/server/smb2pdu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0f8194fc17776..da114b2b39ea3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3619,8 +3619,10 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_fd_set_delete_on_close(fp, file_info);
+	}
 
 	if (need_truncate) {
 		rc = smb2_create_truncate(&fp->filp->f_path);
@@ -6558,7 +6560,8 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	return smb2_rename(work, fp, rename_info, work->conn->local_nls);
 }
 
-static int set_file_disposition_info(struct ksmbd_file *fp,
+static int set_file_disposition_info(struct ksmbd_work *work,
+				     struct ksmbd_file *fp,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
@@ -6573,6 +6576,7 @@ static int set_file_disposition_info(struct ksmbd_file *fp,
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
 		ksmbd_clear_inode_pending_delete(fp);
@@ -6702,7 +6706,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EINVAL;
 
-		return set_file_disposition_info(fp,
+		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
 	}
 	case FILE_FULL_EA_INFORMATION:
-- 
2.53.0

