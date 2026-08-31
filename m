Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A9A58125B;
	Mon, 31 Aug 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184201; cv=none; b=EVNXepNm14ILTuJU/K8s24Ke6apKQTsmmoZHc55K+G8FzKTmToHXDvOAfQMr6BzxbyKZs9M8i4+oE/4irOWqhQv5AuFdyqHhd0kq949N8PHirFpjdTy+nmXNol7gBB6X/whGqG5PFB8J69wWUjLcpUffT1ChpvpE2JNGNGoGp6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184201; c=relaxed/simple;
	bh=vGQiJ2+FxvfV2Xf6OT7ONCyn7m0kWvsKDjX4mSoNoSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yx4hdedsuGf/IJLT0+nc0d3RDCC/ENY0J0x4knVH/5r8H4+KdUznYh0IoIRwje2H+wsdSCI6zpl1sbPrq34M0bswVvYFQOuEyPpjR2Rp5wkl3HYp5dvvQ5nWyj2UrD137QxpZYIeSdHZezEiKOFxstWUppNnXqp+p8XcEyxcclc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bt/hHLzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bt/hHLzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A701F00A3D;
	Mon, 31 Aug 2026 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184199;
	bh=Qty0XSGjkL2jQVRkRq+xD7ruk6d4D6pb1K/ZTQbW448=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bt/hHLzqrMcIu5yytubr2v6qRPz6/L8CIvXL0gEIupsL4ZQwC7I7hL6Zc3zdQOpqP
	 C0AonPrSeVlMZt+s9KgZ3bnvljbUHrVW9EnDqQtgWQHAb0AUEkKuJ0BTiv62d2jXt8
	 TwgluLszGbdaYHMJo85Dokft9kOMFP07+USsNFtobb3Hdu/W/Y9TNqxOqLBAAaze+7
	 c6COrS7LPAtGa/jhqBxOGBfeLDdL0c+3kLMvjYfB/7ARTnrzuT75mpW6VHRDKtu3qW
	 wcXuskNgzmitxaXCo6oezCUxw3nEQWUx2ZTd2s/ovwzSf36FJILMLa8yjs3i/wvU0y
	 jhjmDcz9Cj/qA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: fix lease break and ack state handling
Date: Mon, 31 Aug 2026 09:29:38 -0400
Message-ID: <20260831133314.4125787-550-sashal@kernel.org>
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

[ Upstream commit 5015191096db311759fef98769270336cd8b1324 ]

Do not skip valid lease states containing WRITE_CACHING when breaking
level-II/read leases for writes and truncates.

Handle lease break acknowledgments according to the SMB2 rule that the
acknowledged state must be a subset of the server's break target. Apply
the acknowledged state directly and keep the break pending on failed ACKs.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: fix lease break and ack state
handling`

**Local tree:** `v6.18.44` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 44`)
**Commit under review:** `5015191096db3` (on `master`, not yet in this
checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd]` `[fix]` — Correct SMB2 lease-break dispatch and
lease-break-ACK handling in the in-kernel SMB server.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` — author
- `Signed-off-by: Steve French <stfrench@microsoft.com>` — subsystem
  maintainer
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`,
  `Tested-by:`, or `Reviewed-by:` tags

Notable: maintainer sign-off only; no explicit reporter or stable
nomination.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Level-II/read lease breaks for writes/truncates incorrectly
  skip leases that still have `WRITE_CACHING`. Lease-break ACK handling
  does not follow the SMB2 rule that the acknowledged state must be a
  subset of the server’s break target.
- **Symptom:** Missed lease breaks and incorrect ACK completion; clients
  can retain stale caches.
- **Root cause (author):** Overly strict lease-state filter in
  `smb_break_all_levII_oplock()`; ACK path applies wrong/complex state
  transitions instead of validating subset and applying acknowledged
  state directly; failed ACKs should leave the break pending.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly described as a protocol-correctness bug fix,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `fs/smb/server/oplock.c` | ~24 lines changed (net reduction) |
| `fs/smb/server/smb2pdu.c` | ~106 lines changed (large net reduction) |

**Functions modified:**
- `smb_break_all_levII_oplock()`
- `smb2_map_lease_to_oplock()`
- `check_lease_state()` (+ new `smb2_lease_state_valid()`)
- `smb21_lease_break_ack()`

**Scope:** Two-file, surgical SMB server oplock/lease fix.

### Step 2.2: Code flow changes

**Hunk 1 — `smb_break_all_levII_oplock()`**
- **Before:** Rejects any lease whose state includes `WRITE_CACHING`
  (treated as “unexpected”), then requires level-II oplock for non-
  leases.
- **After:** Only validates oplock level for non-lease entries; leases
  with `WRITE_CACHING` are no longer skipped.
- **Path:** Write/truncate/rename/create conflict paths that break
  level-II/read leases.

**Hunk 2 — `smb2_map_lease_to_oplock()`**
- **Before:** Exact-match batch mapping; exclusive mapping fails when
  `HANDLE` is set without `READ`.
- **After:** Batch = `WRITE`+`HANDLE`; exclusive = any `WRITE`; level-II
  = `READ` or `HANDLE`.
- **Path:** Lease open and post-ACK level updates.

**Hunk 3 — `smb21_lease_break_ack()` / `check_lease_state()`**
- **Before:** Narrow ACK validation; large `lease_change_type` switch;
  on many error paths falls through to success cleanup (`op_state =
  NONE`, `breaking_cnt--`).
- **After:** Validates `req_state` is legal and `req_state ⊆
  lease->new_state`; applies `req->LeaseState` directly; success and
  error paths are fully separated — failed ACKs keep break pending.
- **Path:** Client SMB2 lease-break ACK handling.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / protocol correctness (cache coherency)
- **Mechanism 1:** `state & ~(READ|HANDLE)` flags `WRITE_CACHING` as
  invalid → lease breaks skipped during writes/truncates → stale client
  caches.
- **Mechanism 2:** ACK handler does not implement subset semantics;
  incorrect state transitions and wrong `opinfo->level`.
- **Mechanism 3:** `goto err_out` in current tree still falls through to
  unconditional break completion after `smb2_set_err_rsp()`.

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct against SMB2 lease semantics.
- Net -62 lines; removes overcomplicated ACK logic.
- Low regression risk: narrower validation is more permissive only where
  protocol allows (subset ACKs); stricter about illegal states via
  `smb2_lease_state_valid()`.
- No public API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy `smb_break_all_levII_oplock()` filter: `e2f34481b24db` (Namjae
  Jeon, 2021-03-16) — original ksmbd server import.
- Buggy `check_lease_state()`: same commit; RH special-case added in
  `64b39f4a2fd293` (2021-03-30).
- Bug present since ksmbd introduction in this form; long-lived in
  6.18.y.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Many ksmbd oplock/lease commits on `master` since
`v6.18.44`, including `cd80ce7e68f16` (“don't update ->op_state as
OPLOCK_STATE_NONE on error”, 2023) — partial fix only; current tree
still has fall-through bug on failed ACKs. This commit is patch 3/14 of
a June 2026 series but is logically standalone.

### Step 3.4: Author context
**Record:** Namjae Jeon is primary ksmbd maintainer; Steve French is SMB
maintainer. Both signed off.

### Step 3.5: Dependencies
**Record:** `git cherry-pick --no-commit 5015191096db3` applies cleanly
to current `HEAD` (exit 0). No hard dependency on other series patches
for this diff.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 5015191096db3` →
https://patch.msgid.link/20260618141739.9029-3-linkinjeon@kernel.org —
`[PATCH 03/14] ksmbd: fix lease break and ack state handling`.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd: `linux-cifs@vger.kernel.org`,
`smfrench@gmail.com`, `senozhatsky@chromium.org`, `tom@talpey.com`,
`metze@samba.org`, `atteh.mailbox@gmail.com`.

### Step 4.3: Bug reports
**Record:** No external bug report in commit message. Prior related fix
`cd80ce7e68f16` mentions `smb2.lease.breaking2` test failure for a
narrower issue.

### Step 4.4: Series context
**Record:** Part of 14-patch ksmbd lease series (starts with “validate
SMB2 lease create contexts”). This patch applies standalone to 6.18.44;
earlier series patches are not required for this diff to build/apply.

### Step 4.5: Stable list
**Record:** UNVERIFIED — lore.kernel.org blocked automated fetch (Anubis
bot protection). No stable-list discussion found via other means.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `smb_break_all_levII_oplock`, `smb2_map_lease_to_oplock`,
`check_lease_state`, `smb21_lease_break_ack`, `smb2_oplock_break`.

### Step 5.2: Callers of `smb_break_all_levII_oplock`
**Record:**
- `fs/smb/server/vfs.c` — write, truncate, setattr paths (e.g. line 535
  on write)
- `fs/smb/server/smb2pdu.c` — create, rename, set-info
- `fs/smb/server/oplock.c` — `smb_break_all_oplock()`

Common hot paths for multi-client file server workloads.

### Step 5.3: Callees
**Record:** `oplock_break()` → `smb2_lease_break_noti()`; ACK path uses
`lookup_lease_in_table()`, `ksmbd_iov_pin_rsp()`.

### Step 5.4: Reachability
**Record:** Triggered by remote SMB2 clients during writes, truncates,
renames, and conflicting opens when `CONFIG_SMB_SERVER` and
oplocks/leases are enabled. Network-reachable, normal file-server
operations.

### Step 5.5: Similar patterns
**Record:** Multiple prior ksmbd stable-worthy oplock/lease fixes in
this tree (`50f930db22365` UAF in break ack, `e735dbd489e3e` NULL-deref
in break notifiers, `cd80ce7e68f16` partial ACK error handling). Same
subsystem, same concern area.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** YES. Current tree at `v6.18.44` contains all three buggy
patterns:
- `oplock.c:1407-1418` — WRITE_CACHING rejection
- `oplock.c:1464-1477` — old `smb2_map_lease_to_oplock()` logic
- `smb2pdu.c:8806-8950` — old ACK handling with fall-through cleanup

### Step 6.2: Backport difficulty
**Record:** Clean apply verified via test cherry-pick. No rework needed.

### Step 6.3: Related fixes already present?
**Record:** `cd80ce7e68f16` partially addressed ACK error handling but
did not fix fall-through after `goto err_out`, subset ACK semantics,
WRITE_CACHING skip, or lease-to-oplock mapping. This fix is not
redundant.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `fs/smb/server` (ksmbd in-kernel SMB server). **IMPORTANT**
— affects all ksmbd users; not core kernel, but file-server data
integrity is critical for deployments using it.

### Step 7.2: Activity
**Record:** Actively maintained; many ksmbd commits between `v6.18.44`
and `master`.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_SMB_SERVER` with oplocks/leases enabled —
enterprise/embedded Samba-alternative file serving, multi-client SMB
workloads.

### Step 8.2: Trigger conditions
**Record:**
- Multiple clients with leases on the same file
- Write, truncate, rename, or conflicting open
- Client sends lease-break ACK (including partial/subset ACKs)
- Common in real SMB deployments; not exotic

### Step 8.3: Failure mode severity
**Record:**
- **Failure mode:** Stale client-side read/write caches; incorrect lease
  state after ACK; break prematurely marked complete on failed ACK
- **Severity:** **CRITICAL** for data coherency — can cause silent data
  corruption across SMB clients (not a kernel oops, but a serious
  correctness bug for a file server)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — fixes long-standing protocol bugs on common multi-
  client paths
- **Risk:** LOW — small, localized, maintainer-authored, verified clean
  apply
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real SMB2 lease coherency bugs present since 2021
- Can cause stale caches / data corruption with multiple clients
- Small, surgical (-62 lines net), maintainer-reviewed
- Applies cleanly to 6.18.44
- No new APIs or features
- Failed ACK handling properly keeps break pending

**AGAINST backport:**
- Only affects `CONFIG_SMB_SERVER` users (subset of kernel users)
- Part of a 14-patch series (but standalone-applicable)
- No syzbot/user bug report in commit message

**Unresolved:** Lore thread content and stable-list discussion
(UNVERIFIED).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — protocol-aligned logic,
   maintainer SOBs; no explicit Tested-by
2. Fixes a real bug affecting users? **PASS** — multi-client lease
   coherency
3. Important issue? **PASS** — data coherency / potential corruption
   (CRITICAL for file server)
4. Small and contained? **PASS** — 2 files, ~130 lines touched, -62 net
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean cherry-pick verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale
For **this** tree (`6.18.44`), the buggy code is present, the fix is
self-contained, applies cleanly, and addresses important SMB2 lease
coherency bugs that can lead to stale client caches and data corruption.
This meets stable kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags (Namjae Jeon + Steve French SOBs only),
  body
- [Phase 2] Read full diff from `git show 5015191096db3`; analyzed all 4
  function changes
- [Phase 2] Confirmed `goto err_out` fall-through bug in current
  `smb2pdu.c:8859-8950`
- [Phase 3] `git blame` on `oplock.c:1407-1418` and
  `smb2pdu.c:8806-8818` → `e2f34481b24db` (2021)
- [Phase 3] `git show cd80ce7e68f16` — partial prior fix, insufficient
- [Phase 3] `git merge-base --is-ancestor 5015191096db3 HEAD` → exit 1
  (not in tree)
- [Phase 3] `git cherry-pick --no-commit 5015191096db3` → exit 0 (clean
  apply)
- [Phase 4] `b4 dig -c 5015191096db3` → lore URL found
- [Phase 4] `b4 dig -a` → patch 03/14 of series
- [Phase 4] `b4 dig -w` → linux-cifs, smfrench CC'd
- [Phase 4] UNVERIFIED: lore thread content (Anubis blocked WebFetch)
- [Phase 5] `grep smb_break_all_levII_oplock` → callers in vfs.c,
  smb2pdu.c, oplock.c
- [Phase 5] Read `oplock_break()` lease break logic in
  `oplock.c:893-958`
- [Phase 6] `git describe HEAD` → `v6.18.44`; buggy code confirmed
  present
- [Phase 6] `git log v6.18.44..master -- fs/smb/server/oplock.c` — many
  intervening commits; patch still applies cleanly
- [Phase 7] `fs/smb/server/Kconfig` — `CONFIG_SMB_SERVER` exists
- [Phase 8] Failure mode: cache coherency / data corruption risk,
  severity CRITICAL for SMB server use

**YES**The background checks finished and match the earlier analysis:

- **Master:** commit `5015191096db3` (`ksmbd: fix lease break and ack
  state handling`) is on `master`.
- **This tree (`v6.18.44`):** that commit is **not** present yet.

So the lease-break/ACK bugs are still in your checkout, and the fix is
available on `master` and applies cleanly here. The backport
recommendation remains **YES**.

 fs/smb/server/oplock.c  |  24 +++------
 fs/smb/server/smb2pdu.c | 106 ++++++++++------------------------------
 2 files changed, 34 insertions(+), 96 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index ff0dbf3f8cbf4..d7ba8a01f2c68 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1404,14 +1404,8 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			continue;
 		}
 
-		if (brk_op->is_lease && (brk_op->o_lease->state &
-		    (~(SMB2_LEASE_READ_CACHING_LE |
-				SMB2_LEASE_HANDLE_CACHING_LE)))) {
-			ksmbd_debug(OPLOCK, "unexpected lease state(0x%x)\n",
-				    brk_op->o_lease->state);
-			goto next;
-		} else if (brk_op->level !=
-				SMB2_OPLOCK_LEVEL_II) {
+		if (!brk_op->is_lease &&
+		    brk_op->level != SMB2_OPLOCK_LEVEL_II) {
 			ksmbd_debug(OPLOCK, "unexpected oplock(0x%x)\n",
 				    brk_op->level);
 			goto next;
@@ -1463,15 +1457,13 @@ void smb_break_all_oplock(struct ksmbd_work *work, struct ksmbd_file *fp)
  */
 __u8 smb2_map_lease_to_oplock(__le32 lease_state)
 {
-	if (lease_state == (SMB2_LEASE_HANDLE_CACHING_LE |
-			    SMB2_LEASE_READ_CACHING_LE |
-			    SMB2_LEASE_WRITE_CACHING_LE)) {
+	if ((lease_state & SMB2_LEASE_WRITE_CACHING_LE) &&
+	    (lease_state & SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_BATCH;
-	} else if (lease_state != SMB2_LEASE_WRITE_CACHING_LE &&
-		 lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
-		if (!(lease_state & SMB2_LEASE_HANDLE_CACHING_LE))
-			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (lease_state & SMB2_LEASE_READ_CACHING_LE) {
+	} else if (lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
+		return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (lease_state & (SMB2_LEASE_READ_CACHING_LE |
+				  SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_II;
 	}
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b610cad470ea0..b16e1c156ee5f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8803,16 +8803,17 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	ksmbd_fd_put(work, fp);
 }
 
-static int check_lease_state(struct lease *lease, __le32 req_state)
+static bool smb2_lease_state_valid(__le32 state)
 {
-	if ((lease->new_state ==
-	     (SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE)) &&
-	    !(req_state & SMB2_LEASE_WRITE_CACHING_LE)) {
-		lease->new_state = req_state;
-		return 0;
-	}
+	return !(state & ~(SMB2_LEASE_READ_CACHING_LE |
+			   SMB2_LEASE_HANDLE_CACHING_LE |
+			   SMB2_LEASE_WRITE_CACHING_LE));
+}
 
-	if (lease->new_state == req_state)
+static int check_lease_state(struct lease *lease, __le32 req_state)
+{
+	if (smb2_lease_state_valid(req_state) &&
+	    !(req_state & ~lease->new_state))
 		return 0;
 
 	return 1;
@@ -8830,9 +8831,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
-	__le32 err = 0;
 	int ret = 0;
-	unsigned int lease_change_type;
 	__le32 lease_state;
 	struct lease *lease;
 
@@ -8856,80 +8855,23 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	if (check_lease_state(lease, req->LeaseState)) {
-		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
-		ksmbd_debug(OPLOCK,
-			    "req lease state: 0x%x, expected state: 0x%x\n",
-			    req->LeaseState, lease->new_state);
-		goto err_out;
-	}
-
 	if (!atomic_read(&opinfo->breaking_cnt)) {
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
 		goto err_out;
 	}
 
-	/* check for bad lease state */
-	if (req->LeaseState &
-	    (~(SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE))) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-			lease_change_type = OPLOCK_WRITE_TO_NONE;
-		else
-			lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else if (lease->state == SMB2_LEASE_READ_CACHING_LE &&
-		   req->LeaseState != SMB2_LEASE_NONE_LE) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else {
-		/* valid lease state changes */
-		err = STATUS_INVALID_DEVICE_STATE;
-		if (req->LeaseState == SMB2_LEASE_NONE_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_NONE;
-			else
-				lease_change_type = OPLOCK_READ_TO_NONE;
-		} else if (req->LeaseState & SMB2_LEASE_READ_CACHING_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_READ;
-			else
-				lease_change_type = OPLOCK_READ_HANDLE_TO_READ;
-		} else {
-			lease_change_type = 0;
-		}
-	}
-
-	switch (lease_change_type) {
-	case OPLOCK_WRITE_TO_READ:
-		ret = opinfo_write_to_read(opinfo);
-		break;
-	case OPLOCK_READ_HANDLE_TO_READ:
-		ret = opinfo_read_handle_to_read(opinfo);
-		break;
-	case OPLOCK_WRITE_TO_NONE:
-		ret = opinfo_write_to_none(opinfo);
-		break;
-	case OPLOCK_READ_TO_NONE:
-		ret = opinfo_read_to_none(opinfo);
-		break;
-	default:
-		ksmbd_debug(OPLOCK, "unknown lease change 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	}
-
-	if (ret < 0) {
-		rsp->hdr.Status = err;
+	if (check_lease_state(lease, req->LeaseState)) {
+		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
+		ksmbd_debug(OPLOCK,
+			    "req lease state: 0x%x, expected state: 0x%x\n",
+			    req->LeaseState, lease->new_state);
 		goto err_out;
 	}
 
-	lease_state = lease->state;
+	lease_state = req->LeaseState;
+	lease->state = lease_state;
+	lease->new_state = SMB2_LEASE_NONE_LE;
+	opinfo->level = smb2_map_lease_to_oplock(lease_state);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8938,16 +8880,20 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (ret) {
-err_out:
-		smb2_set_err_rsp(work);
-	}
+	if (ret)
+		goto err_out;
 
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
+	return;
+
+err_out:
+	smb2_set_err_rsp(work);
+	opinfo_put(opinfo);
+	return;
 }
 
 /**
-- 
2.53.0

