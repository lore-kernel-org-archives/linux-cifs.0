Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D87A50A409;
	Mon, 19 Oct 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418696; cv=none; b=YNyf2MdqUT6n+Jv8deMK81iv4C8dqx03S8QAcEGGFpWGO5fB1AGA61s6VaUPGggu6Ve+iJuTlr56PKltt/6emaYrocX+7UE7m1B1lHqCqR0LnUd0Ux3gA7F7xjULKtLvzNK5LFjFPoHFFjwkqia/C+SmCn7Btdd79HudV0V7XlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418696; c=relaxed/simple;
	bh=gCVuU97oSrXK/L1JLFSEE/Ug9AxP5Wi7VVOM7nxRM7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lyBmX8mO6nKEAjX4agGGkLkk6XKGKKI9/tUygBjwdOGi5gmfdFPqgHvMy7sR64nN71xfLzBhXnvJWbo//V9oRppYu/p25eTzqERsrt0AZGMag9nfI+0OpxMlrmrEehIMKPqC+2fgYmDf0y2zXabXn+p3QZSO9DF6XN2xzNjgGF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wz0R7P3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wz0R7P3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62161F000C5;
	Mon, 19 Oct 2026 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418693;
	bh=HITv5j7hsqMbUz5K0NPWp26P44NuVIsOAXqSRUFnrE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wz0R7P3ajN5Yx7yShJ4JFWntmCu4fPFOFIILibnePN040A5wTeUNj0XkLQcNwMAst
	 gXKatSeBaqCZrWEHDlvGEeLUcWifdhgY/+lY0IixrX9c1vc0aHEuzGAKDnNub9g7Wo
	 4dRraxkNl6vct0rpZdviPRlZb69A0uRNaIuPgz/hYl4LnZv790MmUFhAKMjm/s6He3
	 CcTw6DJqfmtSjOYw48Uld8h96RpFAVQ/qSv0NuPPuBnJreRRJ+ASZqwr0Zwk7w0zMW
	 acSOHC30KcTmITN8PD38GzkxWJL+YGUbkFQIZE/oI493icc7VGBDE5MJgQUFY/yH85
	 h2NbHXbV48wig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: reject blocking compound lock requests
Date: Mon, 19 Oct 2026 09:52:00 -0400
Message-ID: <20261019135441.1420968-429-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a protocol-validation deadlock fix in ksmbd’s SMB2 LOCK path. It
belongs in this 6.12 tree: the buggy loop has been here since ksmbd was
added, and the change is a seven-line reject of a request the spec and
Samba already forbid.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ksmbd] [reject] [refuse multi-element SMB2 LOCK requests that
omit SMB2_LOCKFLAG_FAIL_IMMEDIATELY]

“Reject” is a bug-fix verb: stop accepting invalid protocol that can
hang the server.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd
  maintainer; ignore any pipeline SOB)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable
- Absence of Fixes/Cc:stable is expected for this review and is not a
  negative signal

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: a LOCK with more than one element may omit FAIL_IMMEDIATELY (a
  blocking lock). ksmbd currently processes elements in order, so
  earlier ranges can be granted while a later range waits
  asynchronously.
- Symptom: prolonged partial lock ownership and avoidable deadlocks.
- Spec intent: clients set FAIL_IMMEDIATELY on multi-element LOCK;
  servers reject requests that omit it with STATUS_INVALID_PARAMETER.
- Unlock arrays are intentionally left unchanged.
- No kernel-version range in the message.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit protocol/deadlock
fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/smb/server/smb2pdu.c` only (~7 lines added, 0 removed)
- Function: `smb2_lock()`
- Scope: single-file surgical validation in the existing lock-element
  loop

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
Before: after building `lock_list`, the loop validates cmd/flags/mix,
then may call `vfs_lock_file()`. A blocking element uses
`F_SETLKW`/`FL_SLEEP`, can return `FILE_LOCK_DEFERRED`, send
STATUS_PENDING, and `ksmbd_vfs_posix_lock_wait()`. Earlier elements
already granted stay on `rollback_list` / `conn->lock_list` during that
wait.
After: if `lock_count > 1`, the first element is not UNLOCK, and the
current element lacks FAIL_IMMEDIATELY, set `err = -EINVAL` and `goto
out` before `vfs_lock_file()` on that element. `out`/`out2` already map
`-EINVAL` to STATUS_INVALID_PARAMETER and roll back granted locks.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / protocol correctness + deadlock prevention]
- Spec (MS-SMB2 3.3.5.14.2): if Locks[] has more than one entry and any
  lacks FAIL_IMMEDIATELY, the server SHOULD fail with
  STATUS_INVALID_PARAMETER.
- Client rule (MS-SMB2 3.2.4.19): if Locks[] has more than one element,
  the client MUST set FAIL_IMMEDIATELY.
- Mechanism: reject blocking multi-element LOCKs so ksmbd cannot hold
  earlier ranges while waiting on a later one.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: same check Samba already does in
  `smbd_smb2_lock_send()`.
- Minimal: one condition, existing error path.
- Regression risk: very low for compliant clients (they always set the
  flag). A non-compliant client that used blocking multi-locks would
  start getting STATUS_INVALID_PARAMETER — that is the intended spec
  behavior.
- Caveat: the check is inside the processing loop, so a later blocking
  element can still apply earlier FAIL_IMMEDIATELY locks and then roll
  them back. That matches existing `out:` rollback, not a new leak.
  Samba checks the whole array first; this is slightly later but still
  correct.
- The new `if` runs before `list_del(&smb_lock->llist)`, so the current
  element is still on `lock_list` and is freed on `out:`. No leak.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The processing loop was introduced in `e2f34481b24db` (“cifsd:
add server-side procedures for SMB3”, 2021-05-10). `git merge-base --is-
ancestor e2f34481b24db HEAD` succeeds. This has been in ksmbd since it
landed, including this 6.12 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The missing check dates to the
original smb2_lock implementation.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `smb2pdu.c` work in this tree is other protocol/security
fixes (partial info, leases, etc.), not this check. Related historical
lock bugs already here include UAFs and leaks in deferred-lock/cancel
(`ddb9239828336`, `89ae9df09d2c1`, `463bbd7969851`, `a0609097fd10d`).
This patch is standalone, not “2/N”.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Namjae Jeon is the ksmbd maintainer. Many of this tree’s ksmbd
stable-style fixes are his. The 7.3-rc1 ksmbd pull lists this commit
among lock/async correctness updates.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers or fields. It uses `lock_count`,
`lock_ele[0].Flags`, `smb_lock->flags`, and `SMB2_LOCKFLAG_*`, all
present here. Nearby 7.3 lock work (replay sequences, deferred-lock
discard) is not required. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: lore.kernel.org search returned 403; `b4 dig -c` needs a commit
that is not in this checkout. The commit is listed in Namjae’s `[GIT
PULL] ksmbd server update for 7.3-rc1` (2026-08-23, Message-ID
`CAKYAXd8PROT1-3CXk2MnJco2KNKH_4iiN-Ypo5vOFWLPhRki4Q@mail.gmail.com`),
tag `ksmbd-for-7.3-rc1`. Full v1/v2 review thread: UNVERIFIED.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: UNVERIFIED for the original To/Cc list. It went through the
ksmbd maintainer pull to Linus. No NAK found in the pull description.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Motivation is MS-SMB2 + deadlock
analysis, not a named CVE. Samba documents the same SHOULD-fail rule
with a comment citing 3.3.5.14.2.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Same 7.3 pull also has lock-sequence replay, deferred-lock
discard, and detach-before-free. Those are separate. This one is self-
contained validation.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. No evidence this was
already rejected for stable. UNVERIFIED whether AUTOSEL already queued
it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `smb2_lock()` only.

Step 5.2: TRACE CALLERS
Record: Dispatched as `smb2_0_server_cmds[SMB2_LOCK_HE].proc =
smb2_lock` in `fs/smb/server/smb2ops.c`. Reached from
`__handle_ksmbd_work()` → `cmds->proc(work)` in `fs/smb/server/server.c`
for any SMB2 LOCK on an authenticated session with a valid file id.

Step 5.3: TRACE CALLEES
Record: Existing path uses `vfs_lock_file()`, `setup_async_work()`,
`smb2_send_interim_resp()`, `ksmbd_vfs_posix_lock_wait()`. The wait is
`wait_event(flock->c.flc_wait, !flock->c.flc_blocker)` —
uninterruptible. That is why a blocking multi-lock can pin a ksmbd
worker while earlier ranges stay held.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace/network reachable: SMB client → TCP → ksmbd worker →
`smb2_lock()`. Needs an authenticated session and open handle, not
CAP_SYS_ADMIN. Typical NAS user can send it.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Samba `source3/smbd/smb2_lock.c` rejects `in_lock_count > 1`
when the first element is a blocking SHARED/EXCLUSIVE lock, then walks
remaining elements and fails any without FAIL_IMMEDIATELY. Same bug
class, already fixed in Samba.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **6.12.111** (`pending-6.12`, `git describe`
`p-6.12-3-gc504cf0baa3d8`). `smb2_lock()` at
`fs/smb/server/smb2pdu.c:7535` still starts the loop at 7635 with no
multi-element FAIL_IMMEDIATELY check. Bug introduced with ksmbd
(v5.15-era `e2f34481b24db`), present here. `git log --grep='reject
blocking compound lock' -- fs/smb/server/` is empty.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Insertion point matches. Upstream hunk context uses
`smb2_lock_init(..., !lock_length, &lock_list)`; this tree still has
`smb2_lock_init(flock, cmd, flags, &lock_list)`. Expect a minor context
conflict, trivial to apply by hand. No semantic dependency on the extra
`!lock_length` argument.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent check. Existing FAIL_IMMEDIATELY use only skips
connection-list conflict checks for blocking single locks (`goto
no_check_cl`). That is the opposite of rejecting multi-element blocking
locks.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [fs/smb/server (ksmbd)] [IMPORTANT for CONFIG_SMB_SERVER;
default n]. Network-facing file server. Lock bugs affect all ksmbd
shares.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; this 6.12 branch already carries many ksmbd
protocol and UAF fixes. Mature lock path, old bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Config-specific: `CONFIG_SMB_SERVER`. Authenticated SMB clients
of ksmbd NAS/embedded/Android-style servers.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: SMB2 LOCK with LockCount > 1 and at least one non-unlock element
without FAIL_IMMEDIATELY. Windows/Samba clients must set the flag, so
well-behaved traffic never hits it. A buggy or malicious authenticated
client can. Unprivileged in the kernel sense; needs a ksmbd login and
file handle.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Deadlock / worker hang / cross-client lock inversion] [HIGH]
Not a KASAN crash. Holding range A while waiting uninterruptibly for
range B is a real deadlock and can stall a ksmbd workqueue thread. That
is why the protocol forbids it.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for ksmbd hosts — closes a remote deadlock/DoS via
  illegal LOCK arrays; aligns with Samba/MS-SMB2.
- Risk: very low — 7 lines, existing `-EINVAL` path, no ABI, no lock-
  order change.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real deadlock/partial-ownership bug on a network file server
- MS-SMB2 3.3.5.14.2 and Samba implement the same reject
- Tiny, obviously correct, uses existing error/rollback
- Buggy code present in this 6.12 tree since ksmbd introduction
- Maintainer-authored; in the 7.3-rc1 ksmbd pull
- Reachable by authenticated SMB clients

AGAINST:
- Spec is SHOULD, not MUST (footnote 373); Windows may differ
- Compliant clients never send this
- No Reported-by / syzbot / CVE
- Original lore review thread not retrieved

UNRESOLVED:
- Exact lore URL / series revisions (b4/lore 403)
- Whether AUTOSEL already picked it for some series

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — matches Samba; ksmbd maintainer;
   uses existing STATUS_INVALID_PARAMETER path
2. Fixes a real bug that affects users? PASS — deadlock/partial lock
   ownership on ksmbd
3. Important issue? PASS — deadlock / server-worker hang, not a style
   tweak
4. Small and contained? PASS — 7 lines, one function
5. No new features or APIs? PASS — validation only
6. Can apply to the local tree? PASS — same loop; at most a trivial
   `smb2_lock_init` context tweak

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None. Qualifies as a normal important bug fix, not a device-
ID/quirk/DT exception.

Step 9.4: MAKE YOUR DECISION
Backport to this 6.12 tree. The bug is here, the fix is surgical, and
leaving ksmbd willing to block on multi-element LOCKs is a deadlock
hazard for a network-facing server.

What it solves for stable users: ksmbd currently accepts multi-range
LOCK requests that omit FAIL_IMMEDIATELY. It can grant earlier ranges,
then sleep uninterruptibly on a later range
(`ksmbd_vfs_posix_lock_wait()`), which enables lock-order deadlocks and
stuck workers. The patch returns STATUS_INVALID_PARAMETER first (unlock
arrays unchanged).

Risk vs benefit: benefit is deadlock prevention on ksmbd; risk is a one-
condition reject of traffic no compliant client sends.

Concerns: apply context around `smb2_lock_init()` may need a one-line
tweak; no other prerequisites.

Verification:
- [Phase 1] Tags: only Namjae Jeon SOB; no Fixes/Reported-by/Link
- [Phase 2] Diff: 7 lines in `smb2_lock()` loop; `-EINVAL` →
  STATUS_INVALID_PARAMETER at smb2pdu.c:7889-7891; check is before
  `list_del`/`vfs_lock_file`
- [Phase 2] Local blocking path: FILE_LOCK_DEFERRED →
  `ksmbd_vfs_posix_lock_wait()` at smb2pdu.c:7760-7788; wait is
  `wait_event()` in vfs.c:1894-1896
- [Phase 3] Blame: loop from e2f34481b24db (2021); ancestor of HEAD; fix
  not in this tree
- [Phase 3] No Fixes: tag to follow
- [Phase 3] Related history: deferred-lock UAFs already in tree; this
  check is independent
- [Phase 4] GIT PULL 7.3-rc1 lists this subject; lore/b4 thread
  UNVERIFIED (403 / no local SHA)
- [Phase 4] MS-SMB2 3.3.5.14.2 SHOULD-fail; 3.2.4.19 client MUST set
  FAIL_IMMEDIATELY on multi-element LOCK
- [Phase 4] Samba smb2_lock.c:342-378 implements the same
  INVALID_PARAMETER reject
- [Phase 5] Caller: smb2ops.c:187 SMB2_LOCK_HE → server.c:147
  `cmds->proc`
- [Phase 6] `make kernelversion` 6.12.111; buggy loop at smb2pdu.c:7635;
  `smb2_lock_init` here has 4 args vs upstream 5 in hunk context
- [Phase 6] `git log --grep='reject blocking compound lock' --
  fs/smb/server/` empty
- [Phase 8] Failure mode: deadlock/worker hang, not oops; authenticated
  SMB client can trigger
- UNVERIFIED: original lore review comments, AUTOSEL status, Windows
  footnote 373 runtime behavior

**YES**

 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ad6faaf54b991..cc3a3da410eaf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7748,6 +7748,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0

