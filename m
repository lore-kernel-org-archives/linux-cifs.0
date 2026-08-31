Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F702476060;
	Mon, 31 Aug 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184332; cv=none; b=l13tzjk1ipGCBNxQjjfqpu1mWOdkx5NqY6Oej9l4zKRpXysuIRkjqiLdVcU7yK6e7geb4VG68/qH6LBiyJxdwYmBuQalvOPbPSNa++uHoIQDpZqzRVX5JxbnVtdr7HtQMxJdL9IwMV33aXq5FXTWSLBuy8qxgCuc8s3eNeweNS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184332; c=relaxed/simple;
	bh=+8ZiQKKyaZYmO9q8rTvBxQD2meYqCapR5UbS8OrCFmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhGDuOBnTlrkjBlYSgerbve/r53xtzv2sEyCYllH4XCKd6yH1MaVHr9ezDxmb4rcA1uu7wta96UQTmzCxAN7tjQ4/NldLAMkMyGzlqLKGaPotD4HZTSWsyz1n4ryJRV35HKfLtJloNU1uqSh4CeR0pYUgA10eOKcv/lQOMfT1wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=du7j9q5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="du7j9q5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4941F00A3F;
	Mon, 31 Aug 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184329;
	bh=8z0Zk6f6IzTTH0YSgbBk7q9JHOnumno17VaPZOVy9u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=du7j9q5d7S+hJGl99Q0zt+jYE/xNWPdDsmvPfxnHvp4BR19AbStx8OrBHRg/UZNhN
	 J3dCPEfOp/rBmGEe86Bvw/Rjt5RDGUwMtYQ6ei/iO8ymlOXRtOPLN1bW28gZ7plml4
	 5fopyOnpEw49ecY5X7FJmS6I/8naQPB90rulepY/Hf6sygpN6JYsiU+t/gUN2jfGIO
	 vtk/pJx4JcEW4i1LHzLh46fZCfxhx6kLgXZGrfKVNhQY60D1Xq4xNq/7alF7hzHCfr
	 cjqJPgy0Oxp4RFgL8Wsn2BbEqgNHpHdiytgJYKXyA+xYO8q2yWPrqw41Zp4Ytac7rH
	 Uv6GnLNkIx/6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: align SMB2 oplock break ack handling
Date: Mon, 31 Aug 2026 09:30:57 -0400
Message-ID: <20260831133314.4125787-629-sashal@kernel.org>
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

[ Upstream commit 80a56d4a826c6c84430286fcf7d8655f7c5b0868 ]

Handle SMB2 oplock break acknowledgments according to the server-side
validation rules in MS-SMB2.

Return STATUS_INVALID_DEVICE_STATE when an ACK arrives while the open is
not breaking, reject SMB2_OPLOCK_LEVEL_LEASE with
STATUS_INVALID_PARAMETER, allow BATCH acknowledgments to EXCLUSIVE, and
make invalid ACK levels fail with STATUS_INVALID_OPLOCK_PROTOCOL after
lowering the oplock to NONE.

Update the successful response from the final granted oplock level instead
of relying on the oplock transition helpers, which could turn invalid ACKs
into successful responses.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: **[ksmbd] [align] SMB2 oplock break ack handling — correct SMB2
oplock-break ACK validation per MS-SMB2**

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (author)
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` (CIFS/ksmbd
  maintainer, committer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags
- Notable: maintainer-authored and maintainer-committed; no syzbot or
  user bug report in message

**Step 1.3 — Body analysis**

Record:
- **Bug:** `smb20_oplock_break_ack()` does not follow MS-SMB2 server-
  side ACK validation
- **Symptoms:**
  - ACK while open is not breaking → wrong handling
  - `SMB2_OPLOCK_LEVEL_LEASE` in oplock-break ACK → not rejected
    correctly
  - Valid BATCH→EXCLUSIVE ACK → incorrectly rejected
  - Invalid ACK levels → can return SUCCESS instead of
    `STATUS_INVALID_OPLOCK_PROTOCOL`
- **Root cause:** State/level checks are wrong; transition helpers
  (`opinfo_write_to_*`) can succeed on invalid ACKs and produce a
  successful response
- **Version info:** None in message

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite “align” wording, this fixes real protocol/logic
bugs: wrong state gating, incorrect rejection of valid BATCH/EXCLUSIVE
ACKs, and invalid ACKs returning NTSTATUS success.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `fs/smb/server/smb2pdu.c` only (+46 / -58)
- **Function:** `smb20_oplock_break_ack()`
- **Scope:** Single-file, single-function surgical change

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (state check):** Before: reject only if `op_state ==
  OPLOCK_STATE_NONE` with `STATUS_UNSUCCESSFUL`. After: require
  `op_state == OPLOCK_ACK_WAIT`; otherwise
  `STATUS_INVALID_DEVICE_STATE`.
- **Hunk 2 (LEASE level):** Before: no explicit LEASE-level rejection.
  After: reject `SMB2_OPLOCK_LEVEL_LEASE` with
  `STATUS_INVALID_PARAMETER`, set level to NONE.
- **Hunk 3 (validation):** Before: complex `oplock_change_type` + switch
  calling `opinfo_write_to_read/none`. After: explicit per-level
  validation; invalid ACKs set level to NONE and error out.
- **Hunk 4 (BATCH/EXCLUSIVE):** Before: BATCH + EXCLUSIVE ACK treated as
  invalid. After: EXCLUSIVE explicitly allowed for BATCH.
- **Hunk 5 (success path):** Before: response level from transition
  helpers. After: set `opinfo->level` and `rsp_oplevel` directly from
  validated request level.
- **Hunk 6 (error path):** Before: `err_out` could conflate pin failures
  with protocol errors. After: clear `status` assignment and separate
  `out` path.

**Step 2.3 — Bug mechanism**

Record: **[Logic / protocol correctness]**
- Wrong state machine gate (never required `OPLOCK_ACK_WAIT` in
  `smb2pdu.c`)
- Incorrect protocol validation for BATCH/EXCLUSIVE
- Invalid ACKs could complete successfully via transition helpers
  despite intended error status

**Step 2.4 — Fix quality**

Record: **High.** Simpler, directly mirrors MS-SMB2 rules, minimal
scope. Low regression risk; uses existing `OPLOCK_ACK_WAIT` constant
already defined in `oplock.h` and set in `oplock.c` during breaks.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy logic introduced in **e2f34481b24db2** (“cifsd: add
server-side procedures for SMB3”, Namjae Jeon, 2021-03-16). BATCH
handling extended in **64b39f4a2fd293** (2021-03-30). Bug present since
ksmbd’s SMB3 server code landed.

**Step 3.2 — Fixes: tag**

Record: **N/A** — no Fixes: tag in commit message.

**Step 3.3 — Related file history**

Record: Recent `smb2pdu.c` changes in this tree are mostly ksmbd
security/UAF/permission fixes. No prior fix for this ACK-validation
issue. Commit is **patch 06/14** in Namjae’s June 2026 lease/oplock
series, but this hunk is self-contained in `smb20_oplock_break_ack()`.

**Step 3.4 — Author context**

Record: Namjae Jeon is ksmbd maintainer. Steve French committed to
mainline. Series was part of the 50-commit “ksmbd server fixes” pull for
Linux 7.2.

**Step 3.5 — Dependencies**

Record: **Standalone for this tree.** `OPLOCK_ACK_WAIT` already exists
in `oplock.h`; `oplock.c` already sets `op_state = OPLOCK_ACK_WAIT`
during breaks. No structural prerequisites from earlier series patches
required for compilation or semantics. Follow-up mainline commit “return
oplock protocol error for level II ack” builds on this but is separate.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **b4 dig -c 80a56d4a826c:**
  https://patch.msgid.link/20260618141739.9029-6-linkinjeon@kernel.org
- **Series:** v1, patch 06/14 of lease/oplock series (2026-06-18)
- **Review thread:** No replies in saved mbox; no NAKs, no stable
  nomination found

**Step 4.2 — Reviewers**

Record: **b4 dig -w** CC’d linux-cifs, Steve French, Senozhatsky, Tom
Talpey, Metze, Atte Pöyölä. No explicit Reviewed-by/Acked-by in thread.

**Step 4.3 — Bug reports**

Record: No direct bug report. Parent git pull (Steve French, 2026-06-26)
states fixes were “found by smbtorture where ksmbd diverged from SMB2/3
protocol requirements,” including “oplock break corner cases, including
ACK validation.”

**Step 4.4 — Related patches**

Record: Same series includes lease rework; separate follow-up “return
oplock protocol error for level II ack” depends on the `OPLOCK_ACK_WAIT`
check introduced here.

**Step 4.5 — Stable list**

Record: **Not searched on lore stable@** (lore blocked by bot protection
for web fetch). No Cc: stable in commit or thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `smb20_oplock_break_ack()` (modified); callers unchanged:
`smb2_oplock_break()`.

**Step 5.2 — Callers**

Record:
- `smb2_oplock_break()` → `smb20_oplock_break_ack()` for SMB 2.0 oplock
  breaks
- Dispatched via `smb2_0_server_cmds[SMB2_OPLOCK_BREAK_HE]` in
  `smb2ops.c`
- Reachable from remote SMB clients over network on established sessions

**Step 5.3 — Callees**

Record: `ksmbd_lookup_fd_slow()`, `opinfo_get()`, `ksmbd_iov_pin_rsp()`,
`smb2_set_err_rsp()`, `wake_up_interruptible_all()`, `opinfo_put()`,
`ksmbd_fd_put()`. Old path also called `opinfo_write_to_read/none()`;
new path removes that dependency for ACK handling.

**Step 5.4 — Reachability**

Record: **Yes, remotely reachable.** Any SMB client using oplocks
(Windows and Samba clients commonly do) triggers oplock breaks and ACKs
during concurrent file access.

**Step 5.5 — Similar patterns**

Record: `OPLOCK_ACK_WAIT` is checked in `oplock.c` (e.g.
`close_id_del_oplock()`), but was never checked in
`smb20_oplock_break_ack()` in this tree — inconsistent state handling.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
Current `smb20_oplock_break_ack()` at lines 8723–8798 still has the old
logic (checks `OPLOCK_STATE_NONE`, rejects BATCH+EXCLUSIVE, uses
transition helpers). `OPLOCK_ACK_WAIT` is not referenced in `smb2pdu.c`.

**Step 6.2 — Backport complications**

Record: **`git apply --check` on mainline commit 80a56d4a826c applies
cleanly to HEAD.** Expected apply: clean.

**Step 6.3 — Related fixes already present?**

Record: **No.** `git merge-base --is-ancestor 80a56d4a826c HEAD` →
NOT_IN_TREE. `git log --grep="align SMB2 oplock"` on reachable history →
no match.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **ksmbd / SMB server** (`fs/smb/server/`). Criticality:
**IMPORTANT** for `CONFIG_SMB_SERVER` users (in-kernel NAS/file server);
not core kernel, but file-sharing correctness is critical for those
deployments.

**Step 7.2 — Activity**

Record: Actively maintained in 6.18.y — recent ksmbd UAF, permission,
and session fixes in this tree’s history.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users running **ksmbd (CONFIG_SMB_SERVER)** with SMB2 clients
using oplocks — especially Windows clients using batch oplocks.

**Step 8.2 — Trigger conditions**

Record: Common multi-client file access scenarios: conflicting opens
causing oplock breaks, client sending oplock-break ACK. Not exotic;
standard SMB caching behavior.

**Step 8.3 — Failure severity**

Record:
- Valid BATCH→EXCLUSIVE ACK rejected → interoperability failure, broken
  caching handshakes
- Invalid ACK returning SUCCESS → server/client oplock state divergence
  → **cache coherency risk / potential data corruption**
- ACK while not in `OPLOCK_ACK_WAIT` (e.g. `OPLOCK_CLOSING`) processed
  incorrectly
- Severity: **HIGH** for ksmbd deployments (data integrity), not kernel
  oops

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH for SMB server users — fixes long-standing protocol
  bugs verified by smbtorture
- **Risk:** LOW — one function, one file, applies cleanly, uses existing
  constants/state machine
- **Ratio:** Strong benefit, low risk for affected users

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

**FOR:**
- Real, verified protocol bugs (smbtorture series context)
- Can cause oplock state mismatch → cache coherency / data integrity
  risk
- Breaks valid Windows BATCH oplock ACK behavior
- Bug present since 2021 in this tree
- Small, surgical, maintainer-authored fix
- Applies cleanly to v6.18.44

**AGAINST:**
- Optional module (`CONFIG_SMB_SERVER`), not all kernel users
- No kernel crash/oops; protocol correctness rather than memory safety
- Part of larger 14-patch series (though this hunk is self-contained)
- No Cc: stable or user bug report in commit message
- Follow-up patch may also be desirable for complete level-II ACK
  handling

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — MS-SMB2 alignment,
   smbtorture-tested series, maintainer commit
2. Fixes a real bug? **PASS** — incorrect ACK validation and wrong
   success responses
3. Important issue? **PASS** — data integrity / interoperability for SMB
   file server users
4. Small and contained? **PASS** — ~100 lines, one function, one file
5. No new features/APIs? **PASS** — validation correction only
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception category**

Record: **N/A** — not device ID, quirk, DT, build, or docs; standard
protocol bug fix.

**Step 9.4 — Decision rationale**

For **v6.18.44**, the buggy code is present and has been since ksmbd
landed. The fix is self-contained, applies cleanly, and addresses real
SMB2 oplock-break ACK validation errors that can cause client/server
oplock state divergence — a data-integrity concern for anyone using
ksmbd as a file server. This meets stable criteria for important,
contained correctness fixes in an actively used subsystem.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show 80a56d4a826c`
- [Phase 2] Read current `smb20_oplock_break_ack()` at lines 8687–8804
  in `fs/smb/server/smb2pdu.c`; confirmed old logic matches “before”
  side of diff
- [Phase 3] `git blame -L 8723,8763`: buggy code from e2f34481b24db2
  (2021-03-16)
- [Phase 3] `git log --oneline -20 -- fs/smb/server/smb2pdu.c`: no prior
  ACK-validation fix
- [Phase 3] `git merge-base --is-ancestor 80a56d4a826c HEAD` →
  NOT_IN_TREE
- [Phase 4] `b4 dig -c 80a56d4a826c` → lore URL found
- [Phase 4] `b4 dig -c 80a56d4a826c -a` → patch 06/14 in v1 series
- [Phase 4] `b4 dig -c 80a56d4a826c -w` → linux-cifs, Steve French CC’d
- [Phase 4] `b4 dig -m /tmp/oplock_ack.mbx` → saved thread; no
  stable/NAK mentions
- [Phase 4] OpenWall git pull (2026-06-26) → smbtorture protocol
  divergence, oplock ACK validation listed
- [Phase 5] `grep smb2_oplock_break`: dispatch via `smb2ops.c` line 189
- [Phase 5] Read `oplock.c` lines 944–954: `op_state = OPLOCK_ACK_WAIT`
  set during breaks
- [Phase 6] `git describe HEAD` → v6.18.44-1-g2736c32da98b9; Makefile
  VERSION 6.18.44
- [Phase 6] `git show 80a56d4a826c -p | git apply --check` → applies
  cleanly
- [Phase 6] `grep OPLOCK_ACK_WAIT fs/smb/server/smb2pdu.c` → no matches
  (bug present)
- [Phase 8] Traced invalid-ACK path in old code: transition helpers can
  return 0 → success response without error status

**YES**The background git searches finished and match the earlier
analysis:

- **`align SMB2 oplock break`** — no match in reachable history; the fix
  is not in v6.18.44.
- **`oplock break ack`** — only older, unrelated oplock commits (e.g.
  CIFS-era fixes from 2021).
- **`OPLOCK_ACK_WAIT` in `smb2pdu.c`** — no matches; the ACK handler
  still uses the old logic.

That supports the **YES** backport recommendation for commit
`80a56d4a826c` on this tree.

 fs/smb/server/smb2pdu.c | 104 ++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1921a87e20855..99a0108cb21f4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8712,11 +8712,10 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	struct smb2_oplock_break *rsp;
 	struct ksmbd_file *fp;
 	struct oplock_info *opinfo = NULL;
-	__le32 err = 0;
-	int ret = 0;
+	__le32 status = STATUS_SUCCESS;
+	int ret;
 	u64 volatile_id, persistent_id;
 	char req_oplevel = 0, rsp_oplevel = 0;
-	unsigned int oplock_change_type;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -8742,71 +8741,55 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 		return;
 	}
 
-	if (opinfo->level == SMB2_OPLOCK_LEVEL_NONE) {
-		rsp->hdr.Status = STATUS_INVALID_OPLOCK_PROTOCOL;
+	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
+		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n",
+			    opinfo->op_state);
+		status = STATUS_INVALID_DEVICE_STATE;
 		goto err_out;
 	}
 
-	if (opinfo->op_state == OPLOCK_STATE_NONE) {
-		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n", opinfo->op_state);
-		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
+	if (req_oplevel == SMB2_OPLOCK_LEVEL_LEASE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_PARAMETER;
 		goto err_out;
 	}
 
-	if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-	     opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-	    (req_oplevel != SMB2_OPLOCK_LEVEL_II &&
-	     req_oplevel != SMB2_OPLOCK_LEVEL_NONE)) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		oplock_change_type = OPLOCK_WRITE_TO_NONE;
-	} else if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
-		   req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		oplock_change_type = OPLOCK_READ_TO_NONE;
-	} else if (req_oplevel == SMB2_OPLOCK_LEVEL_II ||
-		   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-		err = STATUS_INVALID_DEVICE_STATE;
-		if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-		     opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-		    req_oplevel == SMB2_OPLOCK_LEVEL_II) {
-			oplock_change_type = OPLOCK_WRITE_TO_READ;
-		} else if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-			    opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-			   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-			oplock_change_type = OPLOCK_WRITE_TO_NONE;
-		} else if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
-			   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-			oplock_change_type = OPLOCK_READ_TO_NONE;
-		} else {
-			oplock_change_type = 0;
-		}
-	} else {
-		oplock_change_type = 0;
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_NONE) {
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
 	}
 
-	switch (oplock_change_type) {
-	case OPLOCK_WRITE_TO_READ:
-		ret = opinfo_write_to_read(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_II;
-		break;
-	case OPLOCK_WRITE_TO_NONE:
-		ret = opinfo_write_to_none(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
-		break;
-	case OPLOCK_READ_TO_NONE:
-		ret = opinfo_read_to_none(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
-		break;
-	default:
-		pr_err("unknown oplock change 0x%x -> 0x%x\n",
-		       opinfo->level, rsp_oplevel);
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
 	}
 
-	if (ret < 0) {
-		rsp->hdr.Status = err;
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_BATCH &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
+	}
+
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
 		goto err_out;
 	}
 
+	if (req_oplevel == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
+	else
+		rsp_oplevel = req_oplevel;
+
+	opinfo->level = rsp_oplevel;
+
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
 	rsp->Reserved = 0;
@@ -8814,11 +8797,16 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	rsp->VolatileFid = volatile_id;
 	rsp->PersistentFid = persistent_id;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_oplock_break));
-	if (ret) {
+	if (ret)
+		ksmbd_debug(SMB, "failed to pin oplock break response: %d\n",
+			    ret);
+	goto out;
+
 err_out:
-		smb2_set_err_rsp(work);
-	}
+	rsp->hdr.Status = status;
+	smb2_set_err_rsp(work);
 
+out:
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	opinfo_put(opinfo);
-- 
2.53.0

