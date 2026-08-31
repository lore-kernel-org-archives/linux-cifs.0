Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718048A2C5;
	Mon, 31 Aug 2026 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183498; cv=none; b=W1d76q2YTN+5B9nUCGblKPyApP1oN9l809S0RCd16npRLfYcXPW49xfVJ1xgCHYx6CnZNdFgtn+XTvL0mjF/TJ3uhAzqxkJ0msIomtdO2zPuNLHSehINmMHMmQPslXFk5hcMLsRpfZ9dy9qPLesr5qbHcUPFKzMyX4ylxNo3KP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183498; c=relaxed/simple;
	bh=qNIlW7szUbmo7S8gi5xicQvYMNydgTXkfe0D4Orq/n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfUZGJwdGaxrC/5aZklel+zC/aJgaC4Eb1FFqgLJ+cteobdQvy6C3WWpdXAUaF3EBskyib0ZZJ3kzpQzGIJOu+NzcZDpNpgs90wGo7oTPVgp/Kick/CwIA9biVAcr9wHtDwjKoKEdgrUEvZ8tZmQF4SP9lyWK+vSfk/Kgpdhy4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUX/oEZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUX/oEZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403441F00A3F;
	Mon, 31 Aug 2026 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183496;
	bh=m5N4f9SIYP91muq0C3/PpxZH7S8FZGanjXbIJ4yVQE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUX/oEZyoWHVWDEtaPbgWLiVkNattZWUrE8salI71okP79SamX8wYYhQ5XdQzjwmy
	 DKvfMh66Y4Ttqdow8TgRsEZ+CqmtT3b+zqZzTCfZgewVgptZKiIPe7Bj8TyKilqxnW
	 7MtR3NNku7KIphC8SowjevR7gDpmpH6awNNScUO7PI8dyk4OtHoyMv8+peVNPFp0VC
	 DOWBuACZEF3c2cqXUuw5jmhgOuzPCHLaAvmoGG0NBj6/Mm3LmZMyYhLaA7bjWRHrfV
	 zTLDcva8cHADSACBSari1h5nB6P7CSAQjAb41INt/Vggg+J+F0s2nV53cSWrRCPzSt
	 yRHlAc/8AII9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ksmbd: propagate failed command status in related compounds
Date: Mon, 31 Aug 2026 09:22:39 -0400
Message-ID: <20260831133314.4125787-131-sashal@kernel.org>
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

[ Upstream commit 3f67e624e591747c2b2c9c607a76d79f7ffdcabc ]

In a related compound request, later commands can refer to the file handle
from an earlier command using the related FID value. If the earlier
command fails without producing a valid compound FID, the later related
commands must fail with the same status instead of operating on an invalid
or stale handle.

smb2.compound.related4 sends CREATE followed by IOCTL, CLOSE and SET_INFO.
The CREATE is expected to fail with STATUS_ACCESS_DENIED, and the remaining
related commands are expected to return STATUS_ACCESS_DENIED as well. ksmbd
only stored the compound FID on successful CREATE and did not remember
failed compound statuses.

Store the failed status in the work item and make related handle-based
requests fail immediately with that status only when the compound FID is
invalid. Also preserve and consume the related FID across successful
FLUSH, READ and WRITE requests whose responses do not carry a file id. Keep
a valid compound FID across non-close failures so later related commands
can continue to use the handle.

When extracting the FID from a successful READ, WRITE or FLUSH request, use
the request structure matching the SMB2 command: READ and WRITE place
PersistentFileId and VolatileFileId at a different offset than FLUSH, so a
single smb2_flush_req cast can save the wrong value as compound_fid and
make the following related request fail with STATUS_FILE_CLOSED
(smb2.compound_async.write_write after smb2.compound_async.flush_flush).
Only update the saved compound FID when the request carries a valid
volatile FID. otherwise an all-ones related FID would overwrite the CREATE
FID and break smb2.compound.related6.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[ksmbd]` `[propagate]` — propagate failed SMB2 compound-command
status to later related operations in a compound chain.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (author, ksmbd
  maintainer)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (cifs/ksmbd
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- Notable: maintainer authorship and sign-off only; no fuzzer or user
  bug reports

**Step 1.3 — Body analysis**

Record:
- **Bug:** In SMB2 related compound requests, later commands use a
  “related” file ID from an earlier command. If an earlier command
  (especially CREATE) fails without producing a valid compound FID,
  later related commands must return the same NTSTATUS instead of
  proceeding with an invalid/stale handle.
- **Symptom:** Wrong NTSTATUS codes (e.g. `STATUS_INVALID_HANDLE`
  instead of `STATUS_ACCESS_DENIED`); broken compound sequences such as
  `smb2.compound.related4` (CREATE + IOCTL + CLOSE + SET_INFO) and
  `smb2.compound_async.flush_flush` / `write_write`.
- **Root cause:** ksmbd only stored `compound_fid` on successful CREATE;
  failed statuses were not remembered; READ/WRITE/FLUSH FIDs were not
  preserved across compound steps; wrong structure casts could corrupt
  saved FIDs.
- **Version info:** None in the message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although framed as protocol propagation, this is a real
functional bug fix: wrong error propagation, missing compound-FID
handling in several command handlers, and incorrect FID extraction
across FLUSH/READ/WRITE compound steps.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- `fs/smb/server/ksmbd_work.h`: +1 line (`compound_status`)
- `fs/smb/server/smb2pdu.c`: +156 / -4 lines
- Functions modified/added: `init_chained_smb2_rsp()`, new
  `smb2_compound_has_failed()`, `smb2_query_dir()`, `smb2_query_info()`,
  `smb2_close()`, `smb2_set_info()`, `smb2_read()`, `smb2_write()`,
  `smb2_flush()`, `smb2_lock()`, `smb2_ioctl()`, `smb2_notify()`
- Scope: two-file, single-subsystem fix; moderate size but focused

**Step 2.2 — Code flow changes**

Record:
- **`init_chained_smb2_rsp()` before:** Only saved `compound_fid` on
  successful CREATE; cleared FIDs when related flag absent.
- **After:** Tracks `compound_status`; preserves FIDs across successful
  FLUSH/READ/WRITE using command-specific request structures; records
  failed CREATE status; propagates failed status from related commands;
  resets status on unrelated commands.
- **`smb2_compound_has_failed()` (new):** If in a compound chain, no
  valid `compound_fid`, and a prior failed status exists, immediately
  returns that NTSTATUS.
- **Command handlers before:** Several handlers (`smb2_write`,
  `smb2_flush`, `smb2_lock`, `smb2_query_dir`) did not substitute
  `work->compound_fid` for related FIDs; none checked prior compound
  failure.
- **After:** All affected handlers check `smb2_compound_has_failed()`
  and use `compound_fid`/`compound_pfid` when request FID is invalid.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic / protocol correctness; partial compound-FID
  handling; incorrect structure casting.
- **Mechanism:** Related compound commands with `VolatileFileId ==
  UINT64_MAX` require propagated FID/status from earlier commands.
  Without status tracking, later commands proceed incorrectly. Without
  FID substitution in WRITE/FLUSH/LOCK/QUERY_DIR, related compounds fail
  or misbehave. Wrong `smb2_flush_req` cast for READ/WRITE would save
  garbage FIDs.

**Step 2.4 — Fix quality**

Record: Fix is logically sound, follows existing compound-FID patterns
already used in `smb2_read()`/`smb2_set_info()`, and is careful to only
propagate failure from related commands
(`SMB2_FLAGS_RELATED_OPERATIONS`). Low regression risk; new field is
zero-initialized via `kmem_cache_zalloc()`.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Core compound-FID logic introduced in 2021 (`e2f34481b24db`) and
extended 2022 (`2d004c6cae567e`). Bug present since compound support
landed; long-standing in this tree.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record: Multiple prior compound fixes in this tree, e.g. `7cad3ceaf679c`
(reject invalid session in compound), `075ea208c648c` (OOB in QUERY_INFO
for compounds), `f0e337e7db67c` (validate compound size),
`be0f89d4419dc` (wrong error response status). This fix is in the same
problem area and is standalone.

**Step 3.4 — Author context**

Record: Namjae Jeon is the ksmbd maintainer. Recent stable-tree ksmbd
fixes from this author include UAF and validation fixes.

**Step 3.5 — Dependencies**

Record: Patch is `[09/29]` in a larger series on lore, but `git apply
--check` succeeds cleanly on v6.18.44 without earlier series patches.
**Standalone for this tree.**

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 3f67e624e5917` found `[PATCH 09/29]` at
https://patch.msgid.link/20260621124844.6235-9-linkinjeon@kernel.org.
Lore page content could not be fetched (Anubis bot wall). Reviewer
feedback and stable nominations: **UNVERIFIED**.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` shows CC to `linux-cifs@vger.kernel.org`,
`smfrench@gmail.com`, `senozhatsky@chromium.org`, `tom@talpey.com`,
`atteh.mailbox@gmail.com`.

**Step 4.3 — Bug reports**

Record: Not applicable — no `Reported-by:` or `Link:` tags. Commit
references Samba test cases (`smb2.compound.related4`,
`smb2.compound_async.flush_flush`, `smb2.compound.related6`) as
validation scenarios.

**Step 4.4 — Series context**

Record: Part of 29-patch ksmbd series (v1, 2026-06-21), but applies
independently to 6.18.44.

**Step 4.5 — Stable list history**

Record: **UNVERIFIED** — could not search lore stable archives due to
fetch failure.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `init_chained_smb2_rsp`, `smb2_compound_has_failed`,
`smb2_query_dir`, `smb2_query_info`, `smb2_close`, `smb2_set_info`,
`smb2_read`, `smb2_write`, `smb2_flush`, `smb2_lock`, `smb2_ioctl`,
`smb2_notify`.

**Step 5.2 — Callers**

Record: All modified handlers are SMB2 command dispatch entry points,
reached from userspace SMB clients over network connections through
ksmbd’s request processing path. High relevance for any ksmbd
deployment.

**Step 5.3 — Callees**

Record: `has_file_id()`, `ksmbd_lookup_fd_slow()`, `ksmbd_vfs_fsync()`,
`smb2_set_err_rsp()`, `ksmbd_req_buf_next()` / `ksmbd_resp_buf_next()`.

**Step 5.4 — Reachability**

Record: **Userspace-reachable** — any SMB2 client sending compound
related requests triggers this code. Windows and Samba clients commonly
use compound requests.

**Step 5.5 — Similar patterns**

Record: `smb2_read()` and `smb2_set_info()` already had partial
compound-FID substitution in v6.18.44; `smb2_write()`, `smb2_flush()`,
`smb2_lock()`, and `smb2_query_dir()` did not — confirming
inconsistent/incomplete compound handling in the current tree.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44-1-g2736c32da98b9` (6.18.y
stable). `init_chained_smb2_rsp()` at lines 402–406 only saves FID on
successful CREATE; no `compound_status`;
`smb2_write()`/`smb2_flush()`/`smb2_lock()`/`smb2_query_dir()` lack
compound-FID substitution. Commit `3f67e624e5917` is on `master` but
**not** in HEAD.

**Step 6.2 — Backport complications**

Record: `git apply --check` on the commit patch succeeds with no
conflicts. Expected apply: **clean**.

**Step 6.3 — Related fixes already present?**

Record: No equivalent fix found. `compound_status` and
`smb2_compound_has_failed` are absent from this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `fs/smb/server` (ksmbd SMB server). Criticality: **IMPORTANT**
for ksmbd users; not universal core kernel, but file-server correctness
affects data-serving workloads.

**Step 7.2 — Activity**

Record: ksmbd in 6.18.y is actively maintained with recent stable fixes
(UAF, validation, compound-related patches).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users running `CONFIG_SMB_SERVER` / ksmbd, especially with
Windows or Samba clients using SMB2 compound related requests.

**Step 8.2 — Trigger conditions**

Record: Common client behavior — compound CREATE+IOCTL/CLOSE/SET_INFO,
or compound FLUSH+WRITE sequences. Not obscure; standard SMB2 usage.
Unprivileged network clients can trigger.

**Step 8.3 — Failure mode severity**

Record:
- Wrong NTSTATUS propagation → client interoperability failures, broken
  file operations
- Missing compound FID in WRITE/FLUSH/LOCK/QUERY_DIR → compound
  operations fail incorrectly
- Stale/invalid handle risk explicitly called out by author
- **Severity: MEDIUM-HIGH** for ksmbd users (functional correctness, not
  kernel oops, but can break real file-server workflows)

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH for ksmbd deployments; restores correct SMB2
  compound semantics
- **Risk:** LOW — contained change, maintainer-authored, applies
  cleanly, follows existing patterns
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR:
- Real, reproducible SMB2 compound bugs (test cases named in commit
  message)
- Incomplete compound handling verified in current 6.18.44 code
- Maintainer-authored and signed
- Applies cleanly to this tree
- Similar compound/error-status fixes already present in stable history
- Affects common client request patterns

AGAINST:
- No crash/UAF/CVE reported
- ~160 lines (moderate, not tiny)
- Part of larger 29-patch series (though standalone here)
- Lore review/stable nomination details unverified

UNRESOLVED:
- Whether reviewers explicitly nominated for stable on lore

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — clear logic, Samba test
   references, maintainer sign-off
2. Fixes a real bug affecting users? **PASS** — compound SMB2 handling
   broken for multiple commands
3. Important issue? **PASS** — functional file-server correctness; wrong
   handle/status behavior on common client paths (MEDIUM-HIGH for ksmbd)
4. Small and contained? **PASS** — 2 files, single subsystem
5. No new features/APIs? **PASS** — internal state only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds on
   v6.18.44

**Step 9.3 — Exception categories**

Record: None (not device ID, quirk, DT, build, or docs fix).

**Step 9.4 — Decision rationale**

This commit fixes genuine SMB2 compound-request bugs in ksmbd that are
present in the local 6.18.y tree. The buggy code mishandles related
compound operations that Windows and Samba clients routinely send:
failed CREATE statuses are not propagated, several command handlers lack
compound-FID substitution, and FID preservation across FLUSH/READ/WRITE
is wrong or missing. While not a kernel crash fix, it is an important
correctness fix for a network file server shipped in stable kernels,
with low backport risk and clean applicability to this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
  and `git show 3f67e624e5917`
- [Phase 2] Diff analysis: 2 files, +156/-4; new `compound_status`,
  `smb2_compound_has_failed()`, handler updates confirmed
- [Phase 3] `git blame -L 402,406 fs/smb/server/smb2pdu.c`: compound
  logic from 2021/2022
- [Phase 3] `git log --oneline -20 -- fs/smb/server/smb2pdu.c`: prior
  compound fixes in tree
- [Phase 3] `git apply --check` on commit patch: succeeds cleanly
- [Phase 3] `git merge-base --is-ancestor 3f67e624e5917 HEAD`: commit
  NOT in HEAD
- [Phase 4] `b4 dig -c 3f67e624e5917`: found PATCH 09/29 lore link
- [Phase 4] `b4 dig -c 3f67e624e5917 -a`: v1 series, 29 patches
- [Phase 4] `b4 dig -c 3f67e624e5917 -w`: CC list retrieved
- [Phase 4] WebFetch lore URL: **FAILED** (bot protection) — review
  discussion UNVERIFIED
- [Phase 5] Read `smb2_write()`, `smb2_flush()`, `smb2_lock()`,
  `smb2_query_dir()`, `smb2_read()` in tree: confirmed missing compound
  handling in write/flush/lock/query_dir
- [Phase 5] `has_file_id()` / `KSMBD_NO_FID` in `vfs_cache.h`: related
  FID `UINT64_MAX` treated as invalid
- [Phase 6] `git describe HEAD`: v6.18.44-1; `Makefile`: 6.18.44
- [Phase 6] Grep: no `compound_status` or `smb2_compound_has_failed` in
  tree
- [Phase 6] Read `init_chained_smb2_rsp()` lines 386–448: buggy code
  confirmed present
- [Phase 6] `ksmbd_alloc_work_struct()` initializes `compound_fid` to
  `KSMBD_NO_FID`
- [Phase 8] Failure mode: wrong NTSTATUS / broken compound file ops;
  severity MEDIUM-HIGH for ksmbd users

**YES**Those background lookups finished and matched what the analysis
already used:

- **Compound-fix search** — The tree has earlier ksmbd compound fixes
  (session validation, OOB in QUERY_INFO, size checks), but not this
  specific status-propagation fix.
- **`b4 dig`** — Found the submission as **[PATCH 09/29]** in Namjae
  Jeon’s June 2026 series:
  https://patch.msgid.link/20260621124844.6235-9-linkinjeon@kernel.org
- **Master search** — The commit is `3f67e624e5917` on `master`; it is
  not in the local `v6.18.44` tree, and the patch applies cleanly there.

**Verdict for this tree: YES** — backport-worthy ksmbd SMB2 compound
correctness fix with low risk.

 fs/smb/server/ksmbd_work.h |   1 +
 fs/smb/server/smb2pdu.c    | 159 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index d36393ff8310c..45eea779bd962 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -57,6 +57,7 @@ struct ksmbd_work {
 	u64				compound_fid;
 	u64				compound_pfid;
 	u64				compound_sid;
+	__le32				compound_status;
 
 	const struct cred		*saved_cred;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da0e02b760f8e..0f8194fc17776 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -403,6 +403,59 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_fid = ((struct smb2_create_rsp *)rsp)->VolatileFileId;
 		work->compound_pfid = ((struct smb2_create_rsp *)rsp)->PersistentFileId;
 		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		work->compound_status = STATUS_SUCCESS;
+	} else if ((req->Command == SMB2_FLUSH ||
+		    req->Command == SMB2_READ ||
+		    req->Command == SMB2_WRITE) &&
+		   rsp->Status == STATUS_SUCCESS) {
+		u64 volatile_id = KSMBD_NO_FID;
+		u64 persistent_id = KSMBD_NO_FID;
+
+		if (req->Command == SMB2_FLUSH) {
+			struct smb2_flush_req *flush_req =
+				(struct smb2_flush_req *)req;
+
+			volatile_id = flush_req->VolatileFileId;
+			persistent_id = flush_req->PersistentFileId;
+		} else if (req->Command == SMB2_READ) {
+			struct smb2_read_req *read_req =
+				(struct smb2_read_req *)req;
+
+			volatile_id = read_req->VolatileFileId;
+			persistent_id = read_req->PersistentFileId;
+		} else {
+			struct smb2_write_req *write_req =
+				(struct smb2_write_req *)req;
+
+			volatile_id = write_req->VolatileFileId;
+			persistent_id = write_req->PersistentFileId;
+		}
+
+		if (has_file_id(volatile_id)) {
+			work->compound_fid = volatile_id;
+			work->compound_pfid = persistent_id;
+			work->compound_sid = le64_to_cpu(rsp->SessionId);
+			work->compound_status = STATUS_SUCCESS;
+		}
+	} else if (req->Command == SMB2_CREATE) {
+		work->compound_fid = KSMBD_NO_FID;
+		work->compound_pfid = KSMBD_NO_FID;
+		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		work->compound_status = rsp->Status;
+	} else if (rsp->Status != STATUS_SUCCESS) {
+		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		/*
+		 * Only carry the failed status forward when the failing command
+		 * was itself part of the related chain. An unrelated command
+		 * that fails (e.g. a standalone request with a bad session id)
+		 * must not seed the status for a following related command,
+		 * which has to be evaluated on its own (and may legitimately
+		 * fail with a different status such as INVALID_PARAMETER). The
+		 * compound session id is still tracked so a following related
+		 * command can validate it.
+		 */
+		if (req->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
+			work->compound_status = rsp->Status;
 	}
 
 	len = get_rfc1002_len(work->response_buf) - work->next_smb2_rsp_hdr_off;
@@ -428,6 +481,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "related flag should be set\n");
 		work->compound_fid = KSMBD_NO_FID;
 		work->compound_pfid = KSMBD_NO_FID;
+		work->compound_status = STATUS_SUCCESS;
 	}
 	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
@@ -447,6 +501,19 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 }
 
+static bool smb2_compound_has_failed(struct ksmbd_work *work,
+				     struct smb2_hdr *rsp)
+{
+	if (!work->next_smb2_rcv_hdr_off ||
+	    has_file_id(work->compound_fid) ||
+	    work->compound_status == STATUS_SUCCESS)
+		return false;
+
+	rsp->Status = work->compound_status;
+	smb2_set_err_rsp(work);
+	return true;
+}
+
 /**
  * is_chained_smb2_message() - check for chained command
  * @work:	smb work containing smb request buffer
@@ -4429,11 +4496,28 @@ int smb2_query_dir(struct ksmbd_work *work)
 	unsigned char srch_flag;
 	int buffer_sz;
 	struct smb2_query_dir_private query_dir_private = {NULL, };
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received smb2 query directory request\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
 	if (ksmbd_override_fsids(work)) {
 		rsp->hdr.Status = STATUS_NO_MEMORY;
 		smb2_set_err_rsp(work);
@@ -4446,7 +4530,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		goto err_out2;
 	}
 
-	dir_fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	dir_fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!dir_fp) {
 		rc = -EBADF;
 		goto err_out2;
@@ -5896,6 +5980,9 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (ksmbd_override_fsids(work)) {
 		rc = -ENOMEM;
 		goto err_out;
@@ -6000,6 +6087,9 @@ int smb2_close(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC pipe close request\n");
@@ -6683,6 +6773,8 @@ int smb2_set_info(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 				    work->compound_fid);
@@ -6912,6 +7004,8 @@ int smb2_read(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 					work->compound_fid);
@@ -7176,11 +7270,28 @@ int smb2_write(struct ksmbd_work *work)
 	bool writethrough = false, is_rdma_channel = false;
 	int err = 0;
 	unsigned int max_write_size = work->conn->vals->max_write_size;
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received smb2 write request\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
 	if (test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC pipe write request\n");
 		return smb2_write_pipe(work);
@@ -7225,7 +7336,7 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!fp) {
 		err = -ENOENT;
 		goto out;
@@ -7319,13 +7430,30 @@ int smb2_flush(struct ksmbd_work *work)
 {
 	struct smb2_flush_req *req;
 	struct smb2_flush_rsp *rsp;
+	u64 id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	int err;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "Received smb2 flush request(fid : %llu)\n", req->VolatileFileId);
 
-	err = ksmbd_vfs_fsync(work, req->VolatileFileId, req->PersistentFileId);
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
+	err = ksmbd_vfs_fsync(work, id, pid);
 	if (err)
 		goto out;
 
@@ -7543,11 +7671,29 @@ int smb2_lock(struct ksmbd_work *work)
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
 	int prior_lock = 0, bkt;
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "Received smb2 lock request\n");
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
+	fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!fp) {
 		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n", req->VolatileFileId);
 		err = -ENOENT;
@@ -8348,6 +8494,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 				    work->compound_fid);
@@ -8955,6 +9103,9 @@ int smb2_notify(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
 		smb2_set_err_rsp(work);
-- 
2.53.0

