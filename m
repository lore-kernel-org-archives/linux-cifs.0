Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795AB54024F;
	Mon, 19 Oct 2026 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418727; cv=none; b=WbqPpn8JxZZnVWtPSREwR9xQxcfdiU0MxlaIU9WtiqNC08DTmd1E9BXsVIYBiNlNjPNasBhQaRq1H+FY8vfEpPbxpoabrATXMzstXk9OoOw0wOKbbyauyTtrrT2LIwbpZjf30QQ76KrQ3Kzhpx7ZKfZKS8yw13ZWXgxv32iDTH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418727; c=relaxed/simple;
	bh=zAbzEIwYHU/qp4jRLkxsZDK5qS5LL626QZGpVqB1D/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQg38y6ic7BoUF/WG9OXoIPmDCyxpDc1hiOBjoUxHgemzFGOzsvk8kgN+seri4hYXBumrQWBU7SoRoFXWqTa9qvlVRbG5f7W603CTLlDwECkdiN+iXN7/o40V13vKp1JIpbRxGoy2N8MILOrW8UO7RU6C6Q6aYqUn7Qf2Mq6E9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoF05GmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoF05GmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF9A1F000C8;
	Mon, 19 Oct 2026 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418724;
	bh=OL2beYpPvbFBzAAyisE5y8bt5ZznuG/GnZOAEoYd9rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoF05GmGW2+8gLcl0Pj6MorGfyfzrATwuvAiSpRYjqLdyC6vXqDYYgZ4rPAfYvTW1
	 6qYgk8FLt4CIIdrg5duKVi7+FpjRSw53ryIdLp2vd1IusZdQCwvdXuNXI+vkjYToTV
	 3mPALpmzuIoaONsjPcnE8JPWjMInsHihDrfrm7PVUAn3H2XKEpzenyAW54fp3J55br
	 X4mPATMJOoKlLJxehUJUT67VL7X9+EyrH9efPyq3wU7qPRVrJ1pR3rGEN4ZbNMaZnU
	 9Rc1f72EAhyzz42L/AI1QuSESdNOPO/WR7TpwJgSEWwGkx/+dTdqCCayoyfofAqwE/
	 ip7rmLfBf41XA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response
Date: Mon, 19 Oct 2026 09:52:22 -0400
Message-ID: <20261019135441.1420968-451-sashal@kernel.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 7b461610882c8baa64d56dade57cdbfb686739fa ]

release_async_work() zeroes work->async_id before the CANCELLED path
calls smb2_send_interim_resp(work, STATUS_CANCELLED), which reads
work->async_id to build the response's AsyncId field. The cancellation
response for a cancelled blocked-lock request is sent with AsyncId=0
instead of the id the client received in the original STATUS_PENDING
response for this request.

Checked against every other release_async_work() call site in this
file: smb2_read()/smb2_write() don't send a further async response
afterward (their status goes out on the synchronous path instead), and
smb2_notify()'s two async paths already transfer the id to a separate
struct before releasing, so this reordering is scoped to smb2_lock()
only.

Send the STATUS_CANCELLED response while work->async_id is still valid,
then release the async work afterward.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `smb2_lock()`
cancel path is present here; it was introduced by a UAF backport already
on this branch. This is a small protocol-correctness follow-up for that
regression.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ksmbd]** **[fix]** AsyncId is cleared before the SMB2 lock-
cancel interim response is built, so the client gets AsyncId=0.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record (from the candidate text, ignoring pipeline-added Sasha Levin SOB
/ Upstream markers):
- **Signed-off-by:** Gael Blivet `<gael.blivet@gmail.com>`
- **Assisted-by:** Claude:claude-sonnet-5
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (candidate
  text)

Verified mainline object `af25b28a866c85662723f437d2f2bd433b3ecf92`
(same patch-id) actually has:
- **Acked-by:** Namjae Jeon
- **Signed-off-by:** Steve French
- No **Fixes:**, no **Cc: stable**, no **Reported-by**, no **Tested-
  by**, no **Link:**

Absence of Fixes/Cc:stable is expected for this review and is not a
negative signal.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `release_async_work()` sets `work->async_id = 0` before
  `smb2_send_interim_resp(work, STATUS_CANCELLED)`. That helper copies
  `work->async_id` into the SMB2 header AsyncId field.
- **Symptom:** A cancelled blocked lock is answered with **AsyncId=0**,
  not the id from the earlier STATUS_PENDING interim response.
- **Root cause:** Ordering: release-then-send on the CANCELLED path.
- **Author’s audit:** Other `release_async_work()` sites in that file do
  not send another async response afterward (read/write) or copy the id
  aside first (notify on mainline). Reorder is scoped to `smb2_lock()`
  only.
- **Version info:** None in the message. The ordering bug is a side-
  effect of the earlier UAF reshuffle (see Phase 3).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. It is an explicit protocol-correctness fix: the
cancel response is unusable if AsyncId does not match the pending
request.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `fs/smb/server/smb2pdu.c` — **+9 / −6** (net +3), one hunk
- **Function:** `smb2_lock()`
- **Scope:** single-file surgical reorder of existing calls; no
  API/struct changes

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Local tree today (`smb2_lock` deferred-wait cleanup):

```7794:7814:fs/smb/server/smb2pdu.c
                                list_del(&smb_lock->llist);
                                release_async_work(work);

                                if (work->state == KSMBD_WORK_ACTIVE)
                                        goto retry;

                                locks_free_lock(flock);

                                if (work->state == KSMBD_WORK_CANCELLED)
{
                                        rsp->hdr.Status =
STATUS_CANCELLED;
                                        kfree(smb_lock);
                                        smb2_send_interim_resp(work,
STATUS_CANCELLED);
                                        work->send_no_response = 1;
                                        goto out;
                                }

                                rsp->hdr.Status =
                                        STATUS_RANGE_NOT_LOCKED;
```

After the patch:
- **CANCELLED:** send STATUS_CANCELLED **while `async_id` is live**,
  then `release_async_work()`, then `locks_free_lock()`, then `goto out`
- **ACTIVE:** `release_async_work()` then `goto retry` (unchanged)
- **other non-ACTIVE (e.g. CLOSED):** `release_async_work()` then
  `locks_free_lock()` then STATUS_RANGE_NOT_LOCKED (unchanged)

`smb2_send_interim_resp()` really does use the id:

```731:733:fs/smb/server/smb2pdu.c
        rsp_hdr = smb_get_msg(in_work->response_buf);
        rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
        rsp_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
```

and `release_async_work()` really zeroes it:

```707:710:fs/smb/server/smb2pdu.c
        if (work->async_id) {
                ksmbd_release_id(&conn->async_ida, work->async_id);
                work->async_id = 0;
        }
```

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Logic / protocol correctness** (wrong AsyncId on the cancel
response).
Not a UAF/leak/null-deref in this patch itself. The UAF invariant from
`463bbd79698513` is kept: `release_async_work()` still runs **before**
`locks_free_lock(flock)` on every terminal path, so `smb2_cancel()`
cannot invoke `smb2_remove_blocked_lock()` on a freed `file_lock`.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct from the code. Minimal. No new locks, APIs, or
control-flow besides reordering existing calls.
**Regression risk:** Low. The extra window is only
`smb2_send_interim_resp()` before dequeue; `cancel_fn` still sees a live
`flock`. Same three `work->state` outcomes as today.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The current “release, then maybe send CANCELLED” block was
written by **`463bbd79698513`** (“ksmbd: fix UAF of struct file_lock in
SMB2_LOCK deferred-lock cancellation”, Greg backport 2026-07-18). That
commit **is an ancestor of HEAD**.

`release_async_work()` itself is from `3a9b557f44ea8f` (2023). Interim
AsyncId is filled from `work->async_id` since `9ac45ac7cf65b` (2023),
also in this tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The commit that introduced **this** bug is the
UAF reshuffle:
- This tree: `463bbd79698513af4dad50fe1c573825f297ca2e`
- Upstream: `d20d1c8ba5765` (present as an object; already backported
  here)

Before `463bbd`, the CANCELLED path sent STATUS_CANCELLED **without**
calling `release_async_work()` first (that skip was the UAF). After
`463bbd`, release always happens first, which zeros AsyncId and breaks
the cancel response.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Related lock/cancel UAF series already in this tree, in order:
- `89ae9df09d2c1` double SMB2_CANCEL UAF
- `ddb9239828336` CLOSE then CANCEL UAF
- `463bbd7969851` deferred-lock cancellation UAF (introduces this
  AsyncId bug)

This patch is a **standalone follow-up** to `463bbd`, not part of a
numbered series. No extra prerequisite beyond that UAF fix, which is
already here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Gael Blivet has **no other ksmbd commits on this branch**.
Namjae Jeon (ksmbd maintainer) **Acked** the patch on-list and applied
it (`#ksmbd-for-next-next`); Steve French signed it into the CIFS tree.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `release_async_work()`, `smb2_send_interim_resp()` filling
AsyncId from `work->async_id`, and the `463bbd` lock-wait layout. All
are in this tree. Applies standalone. A string match of the local hunk
confirmed the old block is present and the new block is not.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Mainline SHA: **`af25b28a866c85662723f437d2f2bd433b3ecf92`** (not an
  ancestor of this HEAD)
- Lore/msgid:
  `https://patch.msgid.link/20260717073721.7487-1-g.blivet@me.com`
- **v1 only** (`b4 dig -a`); applied version is that v1
- Namjae reply (same thread): “Applied it to #ksmbd-for-next-next.
  Thanks!” — **no NAK, no requested changes, no stable discussion**

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc were **Namjae Jeon** and **linux-
cifs@vger.kernel.org**. Maintainer reviewed and applied.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla/Reported-by. The bug is deduced from code
after the UAF reorder; that analysis matches the local sources.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. The author’s note about
`smb2_read()`/`smb2_write()`/`smb2_notify()` async sites describes
**mainline**; in **this** 6.12 tree `smb2_notify()` is a
`STATUS_NOT_IMPLEMENTED` stub and only `smb2_lock()` (plus oplock) uses
`setup_async_work()`. That does not change the `smb2_lock()` fix.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org search URLs returned 403. `b4 dig` found only
the linux-cifs thread (2 messages). **UNVERIFIED:** no evidence this was
already NAK’d or requested on stable@; no evidence it was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `smb2_lock()` only. It uses `release_async_work()`,
`smb2_send_interim_resp()`, `locks_free_lock()`.

Step 5.2: TRACE CALLERS
Record: `smb2_lock` is registered as the SMB2_LOCK handler in
`fs/smb/server/smb2ops.c` (`[SMB2_LOCK_HE] = { .proc = smb2_lock}`).
Reachable from an authenticated ksmbd client issuing a blocking byte-
range lock, then SMB2_CANCEL.

Step 5.3: TRACE CALLEES
Record:
- `setup_async_work()` allocates `async_id` and registers
  `smb2_remove_blocked_lock`
- `smb2_send_interim_resp()` copies the SMB2 header and sets AsyncId
  from `work->async_id`
- `release_async_work()` unlinks from `conn->async_requests`, clears
  `cancel_fn`, frees `cancel_argv`, releases and zeros `async_id`
- `smb2_remove_blocked_lock()` only unblocks/wakes the `file_lock`
  (verified in `smb2pdu.c`)

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-triggerable over SMB (needs a ksmbd share and a
blocking lock). Not a local unprivileged syscall UAF, but a real server
path for Windows/`LockFileEx`-style blocking locks plus cancel.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: In this tree, `release_async_work()` call sites are
`smb2_lock()`, `connection.c` teardown, and `oplock.c`. Only
`smb2_lock()` sends STATUS_CANCELLED afterward. Matches the author’s
“scope to smb2_lock only” claim **for this tree**.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `pending-6.12` / **6.12.111** (`git describe`:
`p-6.12-3-gc504cf0baa3d8`). The exact pre-patch block is at
`fs/smb/server/smb2pdu.c:7794-7808`. The bug was introduced **in this
series** by the `463bbd79698513` stable backport (2026-07-18), not by
original v6.12.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Context around `list_del(&smb_lock->llist)` /
`release_async_work` / CANCELLED send matches the candidate; only line
numbers differ (mainline ~9319 vs local ~7794 because this file is
smaller here). Confirmed with a direct string match of the old hunk.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `git log --grep="AsyncId zeroed" -- fs/smb/server/` is empty on
this branch. `af25b28a866c8` **is not** an ancestor of HEAD. The UAF fix
is here; this follow-up is not.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **ksmbd** (`fs/smb/server/`, `CONFIG_SMB_SERVER`). **IMPORTANT**
for systems that run the in-kernel SMB3 server (NAS/embedded); not core
mm/VFS for every machine. Default is `n`.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively patched on this branch (many recent ksmbd fixes in
`smb2pdu.c`). Mature SMB2 lock/cancel path, recently hit by several UAF
fixes.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver/config-specific:** ksmbd users (`CONFIG_SMB_SERVER`)
who issue **blocking SMB2_LOCK** and then **SMB2_CANCEL**.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Common SMB lock-cancel pattern (blocking lock held by another
client, then cancel). Needs SMB authentication to the server. Timing:
after the wait returns with `KSMBD_WORK_CANCELLED`.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Protocol mismatch → client cannot correlate the cancel
completion with the STATUS_PENDING AsyncId.** Typical client effect is a
**hung/outstanding lock request until timeout**, not a kernel oops.
Severity **HIGH** for ksmbd lock-cancel (user-visible hang), not
CRITICAL kernel crash.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** High for this tree specifically — restores correct cancel
  matching **after a UAF backport that regressed it**.
- **Risk:** Very low — ~15-line reorder, UAF dequeue-before-free
  preserved, maintainer-acked.
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real bug: cancel response AsyncId is 0; clients match async work by
  AsyncId
- Regression introduced by `463bbd79698513`, **already in this 6.12.y
  tree**
- Small, obviously correct, applies cleanly
- Maintainer ack + applied upstream (`af25b28a866c8`)
- Does not undo the UAF fix (still `release_async_work` before
  `locks_free_lock`)

**AGAINST:**
- Not a kernel oops/KASAN bug; protocol/hang rather than panic
- ksmbd is opt-in (`CONFIG_SMB_SERVER` default n)
- No Fixes:/Cc:stable/syzbot (expected; not a reason to reject)
- Author’s read/write/notify audit refers to newer mainline, not this
  tree (irrelevant to the lock hunk)

**UNRESOLVED:**
- Could not search lore.kernel.org/stable/?q=… (HTTP 403); `b4` only saw
  the linux-cifs v1 + maintainer apply

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — ordering is visible in
   source; maintainer applied v1 with no revisions
2. Fixes a real bug that affects users? **PASS** — wrong AsyncId on
   lock-cancel completion
3. Important issue? **PASS** — client-visible hang/mismatch on cancel;
   **stable-to-stable regression** after the UAF backport
4. Small and contained? **PASS** — one function, +9/−6
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — hunk matches local
   `smb2_lock()`

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device-id/quirk/DT/build/docs exception). It
qualifies as a normal bugfix, specifically a **follow-up to a prior
stable backport**.

Step 9.4: MAKE YOUR DECISION
Backport. Leaving `463bbd79698513` in 6.12.y without this reorder keeps
a regression: lock-cancel replies with AsyncId=0. The fix is tiny and
keeps the UAF-safety ordering.

What problem it solves for stable users: after the deferred-lock UAF
fix, a cancelled blocking SMB2_LOCK still sends STATUS_CANCELLED, but
with AsyncId already cleared, so SMB2 clients cannot match it to the
STATUS_PENDING they already got.

Risk vs benefit: benefit is restoring lock-cancel completion on ksmbd;
risk is a short send-before-dequeue window on a still-valid `file_lock`.

===============================================================
Verification:
- [Phase 1] Parsed tags: no Fixes/Cc:stable/Reported-by; mainline
  `af25b28a866c8` has Acked-by Namjae + SOB Steve French
- [Phase 2] Diff: +9/−6 in `smb2_lock()`; send CANCELLED before
  `release_async_work()`; confirmed `async_id` zeroed in
  `release_async_work()` and copied in `smb2_send_interim_resp()`
- [Phase 3] blame: buggy order from `463bbd79698513` (2026-07-18
  backport of `d20d1c8ba5765`); `git merge-base --is-ancestor
  463bbd79698513 HEAD` → yes
- [Phase 3] related UAF commits `89ae9df09d2c1` and `ddb9239828336` are
  ancestors; this patch is the missing follow-up
- [Phase 4] `b4 dig -c af25b28a866c8`:
  https://patch.msgid.link/20260717073721.7487-1-g.blivet@me.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Namjae + linux-cifs
- [Phase 4] mbox: Namjae “Applied it to #ksmbd-for-next-next”; no NAK
- [Phase 4] lore.kernel.org HTTP search: 403 — UNVERIFIED for stable@
  archive
- [Phase 5] `smb2_lock` is SMB2_LOCK proc; `smb2_remove_blocked_lock`
  only wakes the flock
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111; buggy code at smb2pdu.c:7794-7808;
  `af25b28a866c8` is NOT ancestor; hunk string-matched
- [Phase 7] CONFIG_SMB_SERVER default n; subsystem actively receiving
  lock/cancel UAF fixes
- [Phase 8] Failure mode: wrong AsyncId → client cannot complete
  cancelled lock (hang/timeout), not kernel oops
- UNVERIFIED: whether every SMB client treats AsyncId=0 as a timeout vs
  ignore; spec matching is by AsyncId, so mismatch is real regardless

**YES**

 fs/smb/server/smb2pdu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ea5a130ef83ce..ad6faaf54b991 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7909,22 +7909,25 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_unlock(&fp->f_lock);
 
 				list_del(&smb_lock->llist);
-				release_async_work(work);
-
-				if (work->state == KSMBD_WORK_ACTIVE)
-					goto retry;
-
-				locks_free_lock(flock);
 
 				if (work->state == KSMBD_WORK_CANCELLED) {
 					rsp->hdr.Status = STATUS_CANCELLED;
 					kfree(smb_lock);
 					smb2_send_interim_resp(work,
 							STATUS_CANCELLED);
+					release_async_work(work);
+					locks_free_lock(flock);
 					work->send_no_response = 1;
 					goto out;
 				}
 
+				release_async_work(work);
+
+				if (work->state == KSMBD_WORK_ACTIVE)
+					goto retry;
+
+				locks_free_lock(flock);
+
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);
-- 
2.53.0

