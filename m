Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4244AEBDC;
	Mon, 31 Aug 2026 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184142; cv=none; b=fgprfSKfe6W8QcBoA3ZlXg74nHWQC3+3iw3foNjalREhUOEZ4kK4vLJK6pajwceCe2QPtiwcxuWO4sD41hU/JWCQ/7L3g6apVgo25H89+U1Pn0PpKRU14ceg6xGLCP2zUvG46bNEzOqfkwejVCNKAgsK2zmvqoD0AHeDh6rvtsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184142; c=relaxed/simple;
	bh=hACUCu8rHKbH2YJmGn5n5tpdPTIx3XnhDWO3ZDG6F/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ha6vJQj3MS+i6loCHKvecDe70fCkrYK5TRLjeLScXv/cVFrciVEybHv4E0D42lZcavYcUQFdbXvwZ6Lqpy7PucCgYU0TxzbtpPSB4GkaFTJEJ6yiVezjxmZ8zlDskXnu955H2ZFg0OjGfB5i/fWiA0+rpvpkaMM1GyFrP0ptyF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZP2UfHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZP2UfHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C061F00A3F;
	Mon, 31 Aug 2026 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184139;
	bh=uLvAJwmkYIsQduJns51m3YLsQQW6b9oPEiffIgbTiQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZP2UfHw1dAsXde5DJgM+OFDbgAE1mmrfyy1KPtACliJuSe1rch9YqMPKDpN9MG2A
	 BzPdqcYyGAnOFvAsPdww07uxFX7cSVSzyN3+S4yUOYTq+Z5XynYAXgk1T3WJUrc3/7
	 CW7S5w+mVOuQDWYh7ao446WMw8HlJb55mxiLqEJZ9FEtdeirzyRPBJAnbTeJC9vWzT
	 FJA+kSIg4NcBdm7bvC/dYWVRQiTz8twiX5gmEJafQ78c+vN2Izjd8XQ9sWkKRVzvkl
	 tYO3sKZz+zWcsuKyZApKGlph4IgfpORezZsHWW5xEUgzIn/qD8B2InXyieR56BAObK
	 7r800V0cZZn3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] smb: client: fix races in cifsd thread creation
Date: Mon, 31 Aug 2026 09:29:03 -0400
Message-ID: <20260831133314.4125787-515-sashal@kernel.org>
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

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

[ Upstream commit e8a5cf2ff5a13fefb228f2069e29dd7d8e37185d ]

The cifsd demultiplex thread can run and access tcp_ses before the parent
thread has finished populating tcp_ses, which the worker thread accesses
locklessly.

Also, the kthread_run macro may start the thread before returning the
thread pointer. Because the pointer is part of the structure that the
thread can access, if the kernel is preempted after the thread is spawned,
but before the thread pointer is populated and the thread attempts to exit,
it will sleep, waiting for a SIGKILL signal.

Fix this by moving creation of the thread to after all of tcp_ses'es
fields are populated, and spawning the thread last, using a split
kthread_create/wake_up_process logic.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `smb: client: fix races in cifsd thread
creation`

**Local tree:** `v6.18.44` (`linux-6.18.y` stable), `HEAD` detached at
`2736c32da98b9`
**Upstream fix:** `e8a5cf2ff5a13` (not in this tree; `git merge-base
--is-ancestor` returned 1)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[smb: client]` `[fix]` — fix races in cifsd (demultiplex)
thread creation during TCP session setup.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Fredric Cover `<fredric.cover.lkernel@gmail.com>`
  (author)
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` (SMB
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Link:, or Cc:
  stable tags
- Notable: maintainer sign-off only; no syzbot or user bug report

### Step 1.3: Body analysis
**Record:**
- **Bug 1:** `cifs_demultiplex_thread` can run and access `tcp_ses`
  before the parent finishes populating fields the worker reads without
  locking.
- **Bug 2:** `kthread_run()` may wake the thread before the parent
  stores `tcp_ses->tsk`. If the thread exits while `tsk` is still NULL,
  exit logic sleeps indefinitely waiting for SIGKILL.
- **Symptom:** Race during mount/session setup; potential hung `cifsd`
  kernel thread.
- **Root cause:** `kthread_run()` creates and immediately wakes the
  thread mid-initialization; comment claiming “kernel thread not created
  yet” is incorrect.
- **Fix:** Populate all `tcp_ses` fields first; use `kthread_create()` +
  `wake_up_process()` last.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly described as a race fix. The `spin_lock`
removal around `tcpStatus` is a consequence of correct ordering (thread
not running yet), not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `fs/smb/client/connect.c` (+16 / −11, 27 lines touched)
- **Function:** `cifs_get_tcp_session()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 — remove early `kthread_run`:**
- **Before:** Thread created and woken immediately after
  `__module_get()`, before `min_offload`, `retrans`, `tcpStatus`,
  `max_credits`, etc. are set.
- **After:** No thread yet; parent continues initialization.

**Hunk 2 — remove `spin_lock` around `tcpStatus`:**
- **Before:** Lock taken because thread could already be running
  (contradicting the comment).
- **After:** Unlocked write is safe because thread is still stopped.

**Hunk 3 — `kthread_create` after all fields populated:**
- **Before:** Thread running during list insertion and echo work setup.
- **After:** Thread exists but is not scheduled; `tcp_ses->tsk` is
  assigned before any concurrent access.

**Hunk 4 — `wake_up_process()` at end:**
- **Before:** Thread could run before `tsk` pointer stored in struct.
- **After:** All fields and `tsk` are valid before thread executes.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Race condition / initialization ordering bug
- **Mechanism 1:** TOCTOU between `kthread_run()` wake and field
  initialization — demux thread reads `max_credits`, `tcpStatus`, etc.
  locklessly while parent still writes them.
- **Mechanism 2:** `kthread_run` macro (`kthread_create` +
  `wake_up_process`) returns task pointer to caller *after* thread may
  already be running. Exit path in `cifs_demultiplex_thread()`:

```1437:1448:fs/smb/client/connect.c
        task_to_wake = xchg(&server->tsk, NULL);
        clean_demultiplex_info(server);

        /* if server->tsk was NULL then wait for a signal before exiting
*/
        if (!task_to_wake) {
                set_current_state(TASK_INTERRUPTIBLE);
                while (!signal_pending(current)) {
                        schedule();
                        set_current_state(TASK_INTERRUPTIBLE);
                }
```

If `server->tsk` was never set, the thread hangs forever.

### Step 2.4: Fix quality
**Record:** Obviously correct — standard kernel pattern
(`kthread_create` + `wake_up_process`). Minimal, no API changes. Low
regression risk; removing the unnecessary `srv_lock` around `tcpStatus`
is correct given new ordering.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `kthread_run(cifs_demultiplex_thread, ...)` introduced in
  `7c97c200e2c5a` (2011, Al Viro)
- `task_to_wake` exit-wait logic from `b1c8d2b421376` (2008, Jeff
  Layton), re-added in `a5c3e1c725af9` (2014 revert of removal)
- Buggy pattern present since ~2011; hang path possible since 2008/2014
  tsk handling

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `connect.c` changes in this tree include negotiate
timeout race fix (`266b5d02e14f3`), channel deadlock fix
(`711741f94ac3c`), netns leak fix (`59b33fab4ca4d`). No duplicate fix
for this specific race. Standalone patch.

### Step 3.4: Author context
**Record:** Fredric Cover has prior SMB client fixes in tree
(`86f9c23e0814c` OOB read, `6cc1518357369` kvzalloc). Not subsystem
maintainer; patch signed off by Steve French.

### Step 3.5: Dependencies
**Record:** No prerequisites. `kthread_create`/`wake_up_process` exist
in this tree. Patch applies cleanly (`git apply --check` succeeded).
Self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c e8a5cf2ff5a13` →
https://patch.msgid.link/20260602005512.126883-1-FredTheDude@proton.me
Submitted as `[PATCH RFC]` on 2026-06-01. Lore page blocked by bot
protection; could not read thread replies.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned same URL only. CC list from web search:
`sfrench`, `linux-cifs`, `sprasad@microsoft.com`. Maintainer sign-off
present.

### Step 4.3: Bug reports
**Record:** No Reported-by or syzbot link. Theoretical/review-found
race, but mechanism is verifiable in code.

### Step 4.4: Series context
**Record:** `b4 dig -a` shows single revision. Not part of a multi-patch
series.

### Step 4.5: Stable list
**Record:** UNVERIFIED — could not search lore stable archive due to
fetch blocking. No evidence against backport.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Modified functions
**Record:** `cifs_get_tcp_session()` (primary), affects startup of
`cifs_demultiplex_thread()`.

### Step 5.2: Callers
**Record:** `cifs_get_tcp_session()` called from:
- Mount path (~line 3667 in `connect.c`) — every CIFS/SMB mount
- `sess.c:561` — multichannel session setup

Every SMB/CIFS mount triggers this path.

### Step 5.3: Callees
**Record:** `kthread_create`, `wake_up_process`, `list_add`,
`queue_delayed_work`, field initialization. Demux thread calls
`cifs_read_from_socket`, `allocate_buffers`, credit handling — all use
`server` fields set in this function.

### Step 5.4: Reachability
**Record:** Reachable from userspace via `mount -t cifs` / SMB mount
syscalls. Common enterprise and desktop path. Unprivileged users can
trigger if permitted to mount.

### Step 5.5: Similar patterns
**Record:** No other `kthread_run(cifs_demultiplex_thread` instances.
This is the sole creation site.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `fs/smb/client/connect.c:1874-1906`
has identical buggy `kthread_run` ordering. Bug predates 6.18.y branch
(code from 2008–2011).

### Step 6.2: Backport complications
**Record:** **Clean apply.** `git show e8a5cf2ff5a13 --
fs/smb/client/connect.c | git apply --check` succeeded with no
conflicts.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree. `git merge-base --is-
ancestor e8a5cf2ff5a13 HEAD` → exit 1 (not merged).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/smb/client` — **IMPORTANT**. CIFS/SMB client used widely
on servers, desktops, NAS mounts. Not core VFS, but affects any system
mounting SMB shares.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (20+ recent commits to
`connect.c`).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** All users mounting CIFS/SMB shares (`CONFIG_CIFS`).

### Step 8.2: Trigger conditions
**Record:**
- **Init race:** Any mount — timing-dependent, more likely under
  preemption/scheduling pressure.
- **Hang:** Failed mount or fast teardown after `kthread_run` but before
  `tsk` assignment; requires unlucky scheduling.
- **Unprivileged trigger:** Yes, if user can mount SMB shares.

### Step 8.3: Failure severity
**Record:**
- Init race: incorrect credit/state handling, unpredictable behavior,
  potential protocol errors — **HIGH**
- Hung `cifsd` thread: stuck kernel thread, module unload failure,
  resource leak — **CRITICAL**
- Overall: **HIGH to CRITICAL**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents mount-path races and potential hung
  threads on common filesystem
- **Risk:** LOW — 27-line ordering fix, well-established pattern,
  applies cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, verifiable race in mount hot path
- Can cause hung kernel thread (indefinite sleep in exit path)
- Small, surgical, maintainer-approved
- Applies cleanly to v6.18.44
- Buggy code confirmed present in this tree since long before branch
- No dependencies or new APIs

**AGAINST backport:**
- No user bug report or syzbot reproduction (theoretical timing race)
- RFC submission — may have had review comments we could not read

**UNRESOLVED:**
- Full lore review thread content (bot-blocked)
- Whether any reviewer explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is sound; maintainer
   SOB; no Tested-by
2. Fixes real bug affecting users? **PASS** — mount-path race with
   verifiable hang mechanism
3. Important issue? **PASS** — hung task / mount failures (**CRITICAL**)
4. Small and contained? **PASS** — 1 file, 27 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix —
standard bug fix).

### Step 9.4: Decision rationale

This fix addresses two concrete problems in `cifs_get_tcp_session()`:
the demux thread running before `tcp_ses` is fully initialized, and the
`tsk` pointer race that can leave `cifsd` sleeping forever on exit. The
buggy code is present in v6.18.44, the patch is minimal and applies
cleanly, and the failure modes (hung thread, mount instability) are
serious enough for stable. The absence of a public bug report does not
diminish the technical merit — the race is structurally present in code
that has been wrong since `kthread_run` was adopted here.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show e8a5cf2ff5a13`
- **[Phase 2]** Analyzed diff; read `cifs_demultiplex_thread` exit path
  at lines 1437–1448; read `kthread_run` macro in
  `include/linux/kthread.h:69–76`
- **[Phase 3]** `git blame -L 1870,1910 fs/smb/client/connect.c` —
  kthread_run from 2011
- **[Phase 3]** `git log -S 'kthread_run(cifs_demultiplex_thread'` —
  introduced 7c97c200e2c5a
- **[Phase 3]** `git log -S 'if (!task_to_wake)'` — tsk exit wait from
  b1c8d2b421376, re-added a5c3e1c725af9
- **[Phase 3]** `git log --oneline -20 -- fs/smb/client/connect.c` — no
  duplicate fix
- **[Phase 3]** `git log --author="Fredric Cover" -- fs/smb/client/` — 2
  prior fixes
- **[Phase 4]** `b4 dig -c e8a5cf2ff5a13` → lore URL found; `b4 dig -a`
  → single revision
- **[Phase 4]** Lore fetch blocked (bot protection) — review comments
  UNVERIFIED
- **[Phase 5]** `grep cifs_get_tcp_session` — callers at connect.c:3667,
  sess.c:561
- **[Phase 5]** Read `cifs_demultiplex_thread` startup loop (lines
  1251–1285)
- **[Phase 6]** `git describe HEAD` → v6.18.44; buggy code at
  connect.c:1874–1906 confirmed
- **[Phase 6]** `git merge-base --is-ancestor e8a5cf2ff5a13 HEAD` → exit
  1 (fix not in tree)
- **[Phase 6]** `git show e8a5cf2ff5a13 -- fs/smb/client/connect.c | git
  apply --check` → clean apply
- **[Phase 8]** Failure modes: init race (HIGH), hung cifsd thread
  (CRITICAL)

**YES**

 fs/smb/client/connect.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2ee2199d2a6a2..e8bf3e8868d70 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1871,14 +1871,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
-				  tcp_ses, "cifsd");
-	if (IS_ERR(tcp_ses->tsk)) {
-		rc = PTR_ERR(tcp_ses->tsk);
-		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
-		module_put(THIS_MODULE);
-		goto out_err_crypto_release;
-	}
 	tcp_ses->min_offload = ctx->min_offload;
 	tcp_ses->retrans = ctx->retrans;
 	/*
@@ -1886,9 +1878,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&tcp_ses->srv_lock);
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&tcp_ses->srv_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
 		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
@@ -1897,7 +1887,16 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
-	/* thread spawned, put it on the list */
+
+	tcp_ses->tsk = kthread_create(cifs_demultiplex_thread,
+				  tcp_ses, "cifsd");
+	if (IS_ERR(tcp_ses->tsk)) {
+		rc = PTR_ERR(tcp_ses->tsk);
+		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
+		module_put(THIS_MODULE);
+		goto out_err_crypto_release;
+	}
+	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -1905,6 +1904,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
+	/*
+	 * Use split create/wake logic to ensure that tcp_ses is fully populated
+	 * and tcp_ses->tsk is valid
+	 */
+	wake_up_process(tcp_ses->tsk);
+
 	return tcp_ses;
 
 out_err_crypto_release:
-- 
2.53.0

