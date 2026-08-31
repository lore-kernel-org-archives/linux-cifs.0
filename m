Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08E0430CE6;
	Mon, 31 Aug 2026 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183229; cv=none; b=ngDzB3rA+hEgogfi0yeVmKfAKSxaoGUxJpDzBk/aWHk13WVn6Y0ftrJ7gPNehoQY3sACgliRcj0DsncRSu37vcU7c3AKuVUWiqxI/rUnQtGUKy0UaZViV8FRqqs63HQwg1r7idstg6ljHXo+EgAHQMAIjtLxQSKJXSeqFr3xY3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183229; c=relaxed/simple;
	bh=ncOw5D6/e8S0ejtclzOxXRHGZZDqI655tdb+9GwJK8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvxrE++MFWbzN3BcFH2O8Jqcj+u0umSCHnybrEKJoaHi+b8jLOOX/2I2RFh2GhMtnxRBgm4m5lpoHatEyjE16gb4zkUvo7FBs7K9xvFjP6p8KQKLba9/uba9YPBbAFtr0t8B6PYP+wozs9iZHynQhIxeyX31xMqkGt8f4mjfkr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfRIoilB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfRIoilB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD851F00A3E;
	Mon, 31 Aug 2026 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183226;
	bh=h0/09us6WyDiR1m51ogWN0HbVCXO7FYBwv/l5okE+GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfRIoilBk7AYO8LOnsTkgYsDjGAJPs0QOC9opvC/PPox8zjw5z99TI/XWvYxbs6re
	 pszRq6NzUk8Lwf6vitr7PZIEmu6WmQp77g8XP+KB8PkapNSJJnYoJe7WFVVVVlmvWO
	 pRGHMkV6Zy1UXsUZ5GVgfrZrqN739QWCjzXexDTMO3DoCQ7kn2WJipKW9WcMhkDBg/
	 1FNIRee5BBEfM5pDcCEwxPqS9LrgFPZQ4SmHt9/XgWEq7vzgtnCllOk4or8f8w3o7z
	 aMBnVTx2kM4+ORw1er8WZ+CE1OuiZvJcTOfLz77kkPXwH17udzM1rQx5r1TwmHckCU
	 EDt9EFFTDYxag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: fix outstanding credit leak on abort and error paths
Date: Mon, 31 Aug 2026 09:20:49 -0400
Message-ID: <20260831133314.4125787-21-sashal@kernel.org>
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

[ Upstream commit 4a0b7826615a01c47924334a2e8a9dbd84a598b2 ]

smb2_validate_credit_charge() adds the request's CreditCharge to
conn->outstanding_credits when an SMB2 PDU is received, and
smb2_set_rsp_credits() subtracts it again when the response is built.
However smb2_set_rsp_credits() only runs on the normal response path:

  - __process_request() returning SERVER_HANDLER_ABORT (unimplemented
    command, command index out of range, signature check failure, or a
    handler that sets send_no_response such as a cancelled blocking
    lock) breaks out of the processing loop before set_rsp_credits() is
    called;
  - smb2_set_rsp_credits() itself returns early with -EINVAL (total
    credit overflow or insufficient credits) before the subtraction.

On all of these paths the charge added at receive time is never
returned, so conn->outstanding_credits only grows. Because a client can
repeatedly trigger them (e.g. by sending unimplemented commands or by
issuing and cancelling blocking locks), outstanding_credits eventually
reaches total_credits and smb2_validate_credit_charge() then rejects
every subsequent request, wedging the connection.

Record the charge that was added in work->credit_charge and release any
charge still pending at the single send. exit point of
__handle_ksmbd_work(), which all abort and error paths fall through to.
smb2_set_rsp_credits() clears work->credit_charge once it has returned
the charge so the response path is unchanged and the credit is never
released twice. Paths that never charged a credit (no multi-credit
support, validation failure) leave work->credit_charge at zero and are
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[ksmbd] [fix] outstanding credit leak on abort and error
paths` — subsystem is ksmbd (SMB3 in-kernel server); action verb is
"fix"; claimed intent is repairing a credit accounting leak.

### Step 1.2: Parse All Commit Message Tags
**Record:** Tags present:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (author, ksmbd
  maintainer)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (committer,
  CIFS/ksmbd maintainer)

Notable absences (expected for manual review pipeline):
- No `Fixes:` tag
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Cc:
  stable@vger.kernel.org` / `Link:`

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `smb2_validate_credit_charge()` increments
  `conn->outstanding_credits` at PDU receive time;
  `smb2_set_rsp_credits()` is supposed to decrement it when building the
  response, but is skipped on abort/error paths.
- **Symptom:** `outstanding_credits` monotonically grows; once it
  reaches `total_credits`, all further requests are rejected — the SMB
  connection is wedged.
- **Trigger:** Repeatable by clients sending unimplemented commands,
  cancelling blocking locks (`send_no_response`), signature failures, or
  hitting `-EINVAL` inside `smb2_set_rsp_credits()`.
- **Root cause:** No cleanup of the receive-time charge when the normal
  response credit path is bypassed.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — this is an explicit bug fix for a resource-
accounting leak with a documented denial-of-service failure mode.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
| File | Changes | Functions touched |
|------|---------|-------------------|
| `fs/smb/server/ksmbd_work.h` | +7 lines | struct `ksmbd_work` |
| `fs/smb/server/server.c` | +14 lines | `__handle_ksmbd_work()` |
| `fs/smb/server/smb2misc.c` | +6 / -3 lines |
`smb2_validate_credit_charge()`, `ksmbd_smb2_check_message()` |
| `fs/smb/server/smb2pdu.c` | +1 line | `smb2_set_rsp_credits()` |

**Total:** 28 insertions, 3 deletions across 4 files. **Scope:** single-
subsystem, surgical fix.

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 (`ksmbd_work.h`):** Adds `credit_charge` field to track pending
receive-time charge.

**Hunk 2 (`smb2misc.c`):** When credit is successfully charged to
`outstanding_credits`, also records it in `work->credit_charge`.

**Hunk 3 (`smb2pdu.c`):** On normal response path, clears
`work->credit_charge` after decrementing `outstanding_credits` —
prevents double-release.

**Hunk 4 (`server.c`):** At the common `send:` exit of
`__handle_ksmbd_work()`, if `work->credit_charge` is still non-zero,
subtract it from `outstanding_credits` under `credits_lock`.

**Record:**
- **Before:** Charge at receive, release only if
  `smb2_set_rsp_credits()` runs to completion.
- **After:** Charge at receive, release on normal path via
  `smb2_set_rsp_credits()` OR on any exit via `send:` label.
- **Affected paths:** Abort (`SERVER_HANDLER_ABORT`),
  `set_rsp_credits()` early `-EINVAL`, and any path that reaches `send:`
  without clearing the charge.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Resource leak (credit accounting) leading to
connection-level DoS.

**Mechanism verified in current tree:**

```214:215:fs/smb/server/server.c
                if (rc == SERVER_HANDLER_ABORT)
                        break;
```

This `break` skips `set_rsp_credits()` at lines 221–229.

```337:352:fs/smb/server/smb2pdu.c
        if (conn->total_credits > conn->vals->max_credits) {
                hdr->CreditRequest = 0;
                pr_err("Total credits overflow: %d\n",
conn->total_credits);
                return -EINVAL;
        }
        // ...
        conn->total_credits -= credit_charge;
        conn->outstanding_credits -= credit_charge;
```

`-EINVAL` returns occur **before** the `outstanding_credits`
subtraction.

```349:361:fs/smb/server/smb2misc.c
        spin_lock(&conn->credits_lock);
        // ...
        } else
                conn->outstanding_credits += credit_charge;
```

Charge happens at receive with no corresponding guaranteed release.

### Step 2.4: Fix Quality Assessment
**Record:**
- **Obviously correct:** Yes — classic "track pending resource, release
  at unified exit" pattern.
- **Minimal:** Yes — 28 lines, no refactoring.
- **Regression risk:** Very low. `kmem_cache_zalloc()` zero-initializes
  work structs; paths that never charge leave `credit_charge == 0`;
  normal path clears the field in `smb2_set_rsp_credits()` before
  reaching `send:`.
- **Locking:** Uses existing `credits_lock`, consistent with surrounding
  credit code.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** `outstanding_credits += credit_charge` in `smb2misc.c`
(lines 356–361) blames to merge commit `5d324e5159d9e` (v6.18-rc8,
2025-11-28). The credit validation logic is present in this 6.18.44
tree. Fix commit `4a0b7826615a0` is **not** an ancestor of HEAD.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File History for Related Changes
**Record:** Recent ksmbd fixes in this tree include UAF fixes, session
handling, and validation hardening (`9be4a66f019ea`, `a60b5da05e318`,
etc.). Prior related fix: `85bf0a73831cc` ("smb: server: fix last send
credit problem causing disconnects"). **Standalone** — not part of a
multi-patch series.

### Step 3.4: Author's Other Commits
**Record:** Namjae Jeon is the primary ksmbd maintainer with numerous
recent fixes in `fs/smb/server/`. Steve French committed the patch. High
subsystem trust.

### Step 3.5: Dependent/Prerequisite Commits
**Record:** No dependencies. `git show 4a0b7826615a0 -- . | git apply
--check` succeeds on current HEAD — patch applies cleanly with no
prerequisites.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c 4a0b7826615a0` returned no match on
lore.kernel.org. `b4 dig -a` and `b4 dig -w` also failed. Likely
committed directly via maintainer tree (`Merge tag
'v7.2-rc1-smb3-server-fixes'`). Lore search blocked by bot protection.

### Step 4.2: Reviewers
**Record:** UNVERIFIED from lore — commit signed off by author and
committed by subsystem maintainer (Steve French).

### Step 4.3: Bug Report
**Record:** No external bug report referenced. Bug mechanism is
explained in detail in the commit message and verifiable from code.

### Step 4.4: Related Patches/Series
**Record:** Standalone fix, not part of a series.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — lore search unavailable; no stable-list
discussion found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `smb2_validate_credit_charge()`, `smb2_set_rsp_credits()`,
`__handle_ksmbd_work()`, `__process_request()`,
`ksmbd_smb2_check_message()`, `ksmbd_verify_smb_message()`.

### Step 5.2: Trace Callers
**Record:**
- `ksmbd_smb2_check_message()` ← `ksmbd_verify_smb_message()` ←
  `__process_request()` ← `__handle_ksmbd_work()` ←
  `handle_ksmbd_work()` (kworker)
- Every incoming SMB2 work item on connections with
  `SMB2_GLOBAL_CAP_LARGE_MTU` goes through this path.
- `SMB2_GLOBAL_CAP_LARGE_MTU` is set for all SMB 2.1+ protocol versions
  in `fs/smb/server/smb2ops.c`.

### Step 5.3: Key Callees
**Record:** Credit paths use `spin_lock(&conn->credits_lock)` around
`outstanding_credits` / `total_credits` mutations.

### Step 5.4: Call Chain / Reachability
**Record:** Any networked SMB client that can send SMB2 requests to
ksmbd can trigger abort paths (unimplemented commands, signature
failures, cancelled blocking locks). **Reachable from remote clients**
on any ksmbd-enabled system (`CONFIG_SMB_SERVER`).

### Step 5.5: Similar Patterns
**Record:** Prior credit accounting bug fixed in `85bf0a73831cc` (SMB
Direct send credits). Same subsystem, same class of problem.

---

## Phase 6: Cross-Referencing Against Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → `v6.18.44-1-g2736c32da98b9`). Buggy code confirmed at
`smb2misc.c:361`, `server.c:214-215`, `smb2pdu.c:337-352`. No
`credit_charge` field in `ksmbd_work.h`. Fix commit `4a0b7826615a0` is
**not** in HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` passes without
modification. No `compress_response` code in this 6.18 tree (present in
newer mainline context lines of the patch), so the `send:` hunk applies
against the simpler local `server.c`.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found. `git log --grep="outstanding credit
leak"` returns nothing on this branch.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **Subsystem:** `fs/smb/server` (ksmbd /
`CONFIG_SMB_SERVER`). **Criticality:** IMPORTANT — optional but
production-relevant for users running the in-kernel SMB3 server; not
core kernel, but file-server availability is business-critical for those
deployments.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — multiple ksmbd fixes landed in this
6.18.y tree in 2026.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_SMB_SERVER` enabled (module `ksmbd` or
built-in), using SMB 2.1+ (LARGE_MTU). Not universal, but affects all
ksmbd server deployments.

### Step 8.2: Trigger Conditions
**Record:**
- Client sends requests that hit `SERVER_HANDLER_ABORT` (unimplemented
  command, bad signature, `send_no_response`, command index out of
  range).
- Or `smb2_set_rsp_credits()` returns `-EINVAL`.
- Repeated triggers exhaust the credit window.
- **Likelihood:** Moderate — unimplemented commands and lock cancel are
  normal SMB client behaviors; a buggy or malicious client can wedge the
  connection deliberately.

### Step 8.3: Failure Mode Severity
**Record:** Connection wedge — all subsequent SMB requests rejected once
credits exhaust. **Severity: HIGH** for affected deployments (complete
loss of SMB service on that connection; requires reconnect/restart). Not
a kernel oops/panic, but a reproducible availability failure.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** HIGH for ksmbd users — prevents progressive credit leak
  and connection DoS.
- **Risk:** VERY LOW — 28-line, obviously correct accounting fix using
  existing locks; applies cleanly.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable resource leak in credit accounting
- Leads to connection wedge (availability DoS)
- Triggerable by remote SMB clients
- Small, surgical, maintainer-authored fix
- Applies cleanly to 6.18.44
- Buggy code present; fix not yet applied
- Prior similar credit fixes exist in this subsystem

**AGAINST backport:**
- Only affects `CONFIG_SMB_SERVER` users (optional, default disabled)
- No kernel crash/panic — connection-level rather than system-level
  failure
- No external bug report or syzbot finding

**Unresolved:** Lore discussion and stable-list nomination not found (b4
dig failed; lore blocked).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; committed by
   subsystem maintainer (testing implied by maintainer merge, but no
   explicit Tested-by).
2. Fixes a real bug affecting users? **PASS** — credit leak wedges SMB
   connections.
3. Important issue? **PASS** — connection-level DoS for file server
   users (HIGH severity for that subsystem).
4. Small and contained? **PASS** — 4 files, 28 lines.
5. No new features or APIs? **PASS** — internal accounting field only.
6. Can apply to local tree? **PASS** — clean `git apply --check`.

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale

This commit fixes a genuine credit accounting leak in ksmbd that allows
remote clients to progressively exhaust `outstanding_credits` and wedge
the SMB connection. The bug exists in Linux 6.18.44, the fix is minimal
and applies cleanly, and the failure mode is a complete loss of SMB
service on the affected connection. While ksmbd is optional, stable
trees routinely accept such fixes for optional but production-used
server subsystems — especially when the fix is this small and the
mechanism is clearly correct.

---

## Verification

- [Phase 1] Parsed commit `4a0b7826615a0` message: fix for credit leak
  on abort/error paths; SOBs from Namjae Jeon and Steve French only
- [Phase 2] Read current `server.c:214-215` — `SERVER_HANDLER_ABORT`
  breaks before `set_rsp_credits()`
- [Phase 2] Read current `smb2pdu.c:337-352` — `-EINVAL` returns before
  `outstanding_credits` decrement
- [Phase 2] Read current `smb2misc.c:349-361` — charge added at receive
  without guaranteed release
- [Phase 2] Read `ksmbd_work.c:21` — `kmem_cache_zalloc()` confirms
  zero-init of new `credit_charge` field
- [Phase 3] `git describe HEAD` → v6.18.44; Makefile confirms 6.18.44
- [Phase 3] `git merge-base --is-ancestor 4a0b7826615a0 HEAD` → fix NOT
  in HEAD
- [Phase 3] `git blame smb2misc.c:356-361` → credit code present since
  6.18-rc8 merge
- [Phase 3] `git show 4a0b7826615a0 -- . | git apply --check` → applies
  cleanly
- [Phase 4] `b4 dig -c/-a/-w 4a0b7826615a0` → no lore match found
- [Phase 5] Grep `SMB2_GLOBAL_CAP_LARGE_MTU` in
  `fs/smb/server/smb2ops.c` → all SMB2.1+ server versions use LARGE_MTU
- [Phase 5] Traced `__process_request()` abort paths at
  `server.c:118-159` — signature failure, unimplemented command,
  `send_no_response`
- [Phase 6] Grep `credit_charge` in tree → field absent (bug present,
  fix absent)
- [Phase 6] Read `fs/smb/server/Kconfig` → `CONFIG_SMB_SERVER` (ksmbd),
  default `n`
- [Phase 7] `git log --author=Namjae -- fs/smb/server/` → active
  maintainer with recent fixes
- [Phase 8] Confirmed failure mode: `outstanding_credits` exhaustion
  blocks all further requests per commit message and
  `smb2_validate_credit_charge()` logic at lines 356-359
- [UNVERIFIED] Lore/stable-list reviewer discussion (b4 dig and web
  fetch unavailable)
- [UNVERIFIED] Explicit runtime testing evidence (no Tested-by tag)

**YES**The background check finished: commit `4a0b7826615a0` is **not**
in this tree (Linux **6.18.44**), and the buggy credit-accounting code
is still present.

**Verdict: YES** — backport this fix. It’s a small, clean patch that
stops a credit leak on abort/error paths, which can wedge ksmbd SMB
connections until they’re restarted. It applies cleanly to the current
checkout.

 fs/smb/server/ksmbd_work.h |  7 +++++++
 fs/smb/server/server.c     | 14 ++++++++++++++
 fs/smb/server/smb2misc.c   |  9 ++++++---
 fs/smb/server/smb2pdu.c    |  1 +
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 45eea779bd962..ffac059306966 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -64,6 +64,13 @@ struct ksmbd_work {
 	/* Number of granted credits */
 	unsigned int			credits_granted;
 
+	/*
+	 * Credit charge added to conn->outstanding_credits at receive time
+	 * for the SMB2 PDU currently being processed, pending release.  Zero
+	 * once the charge has been returned (on the response or error path).
+	 */
+	unsigned short			credit_charge;
+
 	/* response smb header size */
 	unsigned int                    response_sz;
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index b78126bb23711..c729d47f9932b 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -238,6 +238,20 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	} while (is_chained == true);
 
 send:
+	/*
+	 * Release any credit charge still outstanding for this request.  On
+	 * the normal path smb2_set_rsp_credits() already returned it, but the
+	 * abort, error and send-no-response paths skip that call, so the
+	 * charge would otherwise leak and eventually exhaust the connection's
+	 * outstanding credit window.
+	 */
+	if (work->credit_charge) {
+		spin_lock(&conn->credits_lock);
+		conn->outstanding_credits -= work->credit_charge;
+		work->credit_charge = 0;
+		spin_unlock(&conn->credits_lock);
+	}
+
 	if (work->tcon)
 		ksmbd_tree_connect_put(work->tcon);
 	smb3_preauth_hash_rsp(work);
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index b11d854d3fcfb..d8913d2008748 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -298,9 +298,10 @@ static inline int smb2_ioctl_resp_len(struct smb2_ioctl_req *h)
 		le32_to_cpu(h->MaxOutputResponse);
 }
 
-static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
+static int smb2_validate_credit_charge(struct ksmbd_work *work,
 				       struct smb2_hdr *hdr)
 {
+	struct ksmbd_conn *conn = work->conn;
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
@@ -357,8 +358,10 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
-	} else
+	} else {
 		conn->outstanding_credits += credit_charge;
+		work->credit_charge = credit_charge;
+	}
 
 	spin_unlock(&conn->credits_lock);
 
@@ -466,7 +469,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 
 validate_credit:
 	if ((work->conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(work->conn, hdr))
+	    smb2_validate_credit_charge(work, hdr))
 		return 1;
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da114b2b39ea3..55ac0ee338dae 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -350,6 +350,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
 	conn->total_credits -= credit_charge;
 	conn->outstanding_credits -= credit_charge;
+	work->credit_charge = 0;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-- 
2.53.0

