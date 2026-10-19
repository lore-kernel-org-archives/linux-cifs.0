Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C654558703;
	Mon, 19 Oct 2026 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418231; cv=none; b=G+eeubZjuwwgrMesq4uFNXr1VPUzFgvswfG+gbcOj9HUuXYlLqU1Ej3j4Rih0RVai0M7eOU5ydAW/wq0sBPyvS470rfqrH6OoCYSastU1kvoDAJ5vENZWtdA2RZyXlsHpvAZJwE+A3IlSvNVjxt1iGCSZWQA/OkWaJ2d1ZYftNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418231; c=relaxed/simple;
	bh=aHgLq/tebAINb5gYHKI0k1iGNAU4UAK6jtVtJx1xs3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0YtO4YTvO9aGGyjc/HvYD34LpNML3rqac+gMArI/1hZeU/Q/bzB3Jdm5XskDg97akMNSREDiSIo01R4cSMpNgdwz5Yo3sMbCr3hS+Aqpw3kejbYgQve1t2wYvvGqGc6uNsZNfDPVjr/TuBiLe/6dT1EEWx16spftlpP8tICzm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddtRi9mQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddtRi9mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDB1F000C8;
	Mon, 19 Oct 2026 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418228;
	bh=0r/8Lb/WBrvIXryyNi1s30vdlPNeUoD+N6RqN8PvK/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddtRi9mQh5Pr9pwqwQjf+1sIz2QQZ9eCiMa4mn42OG9tqNS1dcn8HORBCervIwuPz
	 lStlOf5cuu5/W+0wbJMs29u+RaG0i6psAuUtgz1Qj7+ZKW56d7NyncGuU9q/uDYyIO
	 Hx4bO/y8QooRdXdPWq2PxrYQLr+fEDKFDobNnnHg3Bzil6UWyNRoCZwEjLCZ/z9Njx
	 QhkctS071vQGxrvjhAEMDz2Ar6WXnM4VZiOCbBbPowCEpt9/Cj+whnUasGDQEn1wAq
	 cJYf3kHPNvv1M9Q0/o+a5B8opqbWxladQ4j+xV0iNLQ7vDyW0hnsxCygElP0O+V+ZC
	 lzDSIULJPN1bQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: notify parent directory leases on child create
Date: Mon, 19 Oct 2026 09:46:34 -0400
Message-ID: <20261019135441.1420968-103-sashal@kernel.org>
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

[ Upstream commit abe5acb34282206c2a6303d0e09b3165b1addf0e ]

BVT_DirectoryLeasing_ReadWriteHandleCaching requires a parent directory
lease break notification when another client creates a child in the
leased directory. A child CREATE without a lease context did not notify
the parent lease holders because the notification path expected a
non-NULL lease context.

Allow the parent lease notification helper to handle a NULL child lease
context and notify matching parent leases. Invoke it after a child is
created without a lease context while preserving the existing lease-key
filtering for requests that provide one.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). Directory leasing is
already advertised here, and this patch fills a hole in that existing
notification path.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ksmbd] [notify] parent directory leases on child create**

- Subsystem: `ksmbd` (kernel SMB3 server)
- Verb: “notify” — protocol-correctness / missing-event fix, not a
  feature add
- Claimed intent: send a parent directory lease break when a child is
  created

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Verified from `git log -1 --format='%B' abe5acb342822`:

- **Signed-off-by: Namjae Jeon** `<linkinjeon@kernel.org>` (author and
  committer; ksmbd maintainer)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link**
- Ignore pipeline-added Sasha Levin SOB / `[Upstream commit …]` if
  present on a candidate copy

Notable: maintainer-authored, no external review tags. The body cites
Microsoft BVT `BVT_DirectoryLeasing_ReadWriteHandleCaching`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** A child CREATE with no lease context never notifies holders
  of a parent directory lease, because
  `smb_send_parent_lease_break_noti()` assumed `lctx` was non-NULL.
- **Symptom:** Windows BVT `BVT_DirectoryLeasing_ReadWriteHandleCaching`
  fails; SMB3 clients with a directory lease keep a stale directory
  cache after another client creates a child.
- **Version info:** None in the message. Introducing code is from
  v6.7-rc6 (`d47d9886aeef7`).
- **Root cause:** Notification only ran on CREATE-with-lease-context;
  the helper immediately used `lctx->version`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** This is an explicit protocol bug
fix: missing lease-break on a common CREATE path. Not a refactor or new
API.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `fs/smb/server/oplock.c`: +5/−4 in
  `smb_send_parent_lease_break_noti()`
- `fs/smb/server/smb2pdu.c`: +3 in `smb2_open()`
- **Scope:** 8 insertions, 4 deletions; single-subsystem surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Verified against local `smb_send_parent_lease_break_noti()`
(`fs/smb/server/oplock.c` ~1214) and `smb2_open()` (~3521):

Hunk 1 (helper guard):
- **Before:** `if (lctx->version != 2) return;` — NULL `lctx` would
  crash; callers never passed NULL.
- **After:** `if (lctx && lctx->version != 2) return;` — NULL means
  “notify matching parent leases”.

Hunk 2 (filter condition):
- **Before:** Always used `lctx->flags` / `lctx->parent_lease_key` to
  skip the same parent lease.
- **After:** `!lctx || (existing parent-key filter)` — NULL child
  context breaks all active parent directory leases; lease-key filtering
  is unchanged when `lctx` is present.

Hunk 3 (`smb2_open`):
- **Before:** Parent notify only inside `if (req_op_level ==
  SMB2_OPLOCK_LEVEL_LEASE && lc)`.
- **After:** Also `if (created && !lc)
  smb_send_parent_lease_break_noti(fp, NULL);` in the oplocks-enabled
  branch.

`created` is set when `smb2_creat()` succeeds (`smb2pdu.c` ~3301–3313).
`lc` is only set when a lease create context is parsed (~3017, ~3061).
The two notify sites are mutually exclusive (`!lc` vs `lc`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / protocol correctness]** Directory leasing is
advertised (`SMB2_GLOBAL_CAP_DIRECTORY_LEASING` in `smb2ops.c`; docs say
“Directory leases(v2 lease) Supported”). CREATE without a lease context
never broke the parent directory lease. The helper change is a NULL-safe
call convention so that path can notify. Not UAF/leak/race/overflow by
itself; the failure mode is stale client directory cache.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: short-circuit `!lctx` avoids `lctx->flags` deref;
  reuses the existing break helper.
- Minimal; no unrelated edits.
- Regression risk **low**: extra breaks only on real child create with
  no lease context, which MS-SMB2 requires. Locking matches the existing
  `smb_send_parent_lease_break_noti(fp, lc)` call a few lines later
  (`p_ci->m_lock` then `oplock_break_drain_none()`).
- No public API / data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy helper and the lease-context-only call site: **`d47d9886aeef7`**
  (“ksmbd: send v2 lease break notification for directory”, Namjae Jeon,
  2023-12-08).
- First contained in **`v6.7-rc6`**. Present in this 6.12 tree (`git
  merge-base --is-ancestor d47d9886aeef7 HEAD` → yes).
- Directory leasing capability: **`18dd1c367c31d`** (“ksmbd: set v2
  lease capability”), also in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** The incomplete behavior was introduced by
`d47d9886aeef7`, which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Same class already in this tree: `3fc74c65b3674` “send lease break
  notification on FILE_RENAME_INFORMATION” (smb2.lease.v2_epoch2);
  `7f58458e9db92` “break RH leases before delete-on-close”.
- Later on `all-next`, `0e753899627b5` only changes
  `oplock_break_drain_none(&brk_list)` → `(&brk_list, p_ci)` — **already
  present locally** via `5de0527f78243`. Not a prerequisite of this
  patch.
- `git log all-next -S 'created && !lc'` shows **only** `abe5acb342822`
  — no follow-up rewrite of this call.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Namjae Jeon is listed as **KERNEL SMB3 SERVER (KSMBD)**
maintainer in `MAINTAINERS`. Recent local ksmbd lease work includes
lease lookup, RH lease break, lease context validation.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **Standalone.** Uses existing
`smb_send_parent_lease_break_noti()`, `created`, and `lc`. `git show
abe5acb342822 | git apply --check` **succeeds** on this tree (oplock.c
offset −232, smb2pdu.c offset −1136).

Candidate SHA on `all-next`: **`abe5acb342822`** (in `ksmbd-
for-7.3-rc1`, described as `v7.3-rc1~77^2~20`). **Not** in HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c abe5acb342822`: lore search returned server errors; **no
  thread URL**.
- lore.kernel.org WebFetch: **403**.
- Found via LKML: [GIT PULL] ksmbd server update for 7.3-rc1 (Namjae
  Jeon, 2026-08-23) lists this commit and calls out **“parent directory
  lease notifications”** among protocol-compatibility fixes.
- Linus merge `61a09cfc12147` uses the same wording.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: No Reviewed-by. Author is the maintainer and committed it to the
ksmbd tree. Recipients of the original mail **unverified** (lore 403 /
b4 failure).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Trigger is Microsoft BVT
**BVT_DirectoryLeasing_ReadWriteHandleCaching** (Windows protocol test:
client A holds a directory RWH lease; client B creates a child without a
lease context; A must get a break).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Not labeled `N/M`. Adjacent commits are AppInstanceVersion
takeover / durable reconnect — unrelated. Independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** (lore 403). No evidence it was rejected for
stable. Absence of Cc: stable is expected here.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `smb_send_parent_lease_break_noti()`, `smb2_open()`.

**Step 5.2: TRACE CALLERS**

Record (this tree, `git grep`):
- `smb_send_parent_lease_break_noti` — only `smb2_open()`.
- After the patch: two sites in `smb2_open` (`created && !lc`, and
  existing lease-context path).
- `smb2_open` is the SMB2 CREATE handler — authenticated SMB clients.

Related: `smb_lazy_parent_lease_break_close()` on close after write
(`reserve_lease_break`); not this CREATE gap.

**Step 5.3: TRACE CALLEES**

Record: `ksmbd_inode_lookup_lock(parent)`, `down_read(p_ci->m_lock)`,
walk `m_op_list`, `compare_guid_key()`, `oplock_break_add()`,
`oplock_break_drain_none()`, `ksmbd_inode_put()`. Same as today’s
helper.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace SMB2 CREATE → `smb2_open` → (new) parent lease break.
Reachable whenever ksmbd is running with leases/`smb2 leases` and a
client holds a directory lease. Windows 8+ SMB3 clients request
directory leases by default. **Yes, client-triggerable.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same missing-break pattern already fixed for rename
(`3fc74c65b3674`, in this tree). Unlink/close uses
`smb_lazy_parent_lease_break_close`. This patch is the CREATE-without-
lease counterpart.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.**

```1221:1236:fs/smb/server/oplock.c
        if (lctx->version != 2)
                return;
        // ...
                    (!(lctx->flags &
SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
                     !compare_guid_key(opinfo, fp->conn->ClientGUID,
                                      lctx->parent_lease_key))) {
```

```3530:3541:fs/smb/server/smb2pdu.c
                if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
                        // ...
                        smb_send_parent_lease_break_noti(fp, lc);
```

Bug introduced **v6.7** (`d47d9886aeef7`). Capability advertised in
`init_smb3_0_server()` / `init_smb3_02_server()`. Docs: “Directory
leases(v2 lease) Supported.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply with offset.** Local helper already has
`oplock_break_drain_none(&brk_list, p_ci)` from `5de0527f78243`; that
line is outside the candidate hunks. `git apply --check` succeeded.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Rename/delete-on-close lease-break fixes are here. **This
CREATE-without-lease notify is not.** Subject grep found no equivalent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **[ksmbd / fs/smb/server] [IMPORTANT]** — in-kernel SMB3 server
for NAS/embedded. Not core VFS; not staging. Config `SMB_SERVER`,
default n.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: **Actively developed.** This pending 6.12 tree already carries
many ksmbd protocol and lease fixes (partial responses, RH lease break,
lease context validation, oplock UAF). Mature enough that directory
leasing has been “Supported” since ~6.7.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Config/driver-specific:** `CONFIG_SMB_SERVER` with SMB2 leases
and SMB3 directory leasing. Affects Windows/SMB3 clients that cache
directories against ksmbd.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Client A holds a v2 directory lease.
- Client B creates a child **without** a lease create context (`created
  && !lc`).
- Common for a second client or simple SMB CREATE; exactly the BVT
  setup.
- Authenticated SMB client, not a local unprivileged syscall.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Stale directory cache / protocol violation.** Not
oops/deadlock/fs corruption. Clients can miss newly created names until
some other break. **Severity: MEDIUM** (interoperability / user-visible
wrong directory contents), same class as the rename lease-break fix
already in this tree.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for ksmbd+Windows SMB3: advertised directory leasing
  actually invalidates on child create.
- **Risk:** Very low — ~8 lines, existing helper, applies cleanly, no
  new locks/APIs.
- **Ratio:** Favor backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real protocol bug in **advertised** directory leasing (docs +
  `SMB2_GLOBAL_CAP_DIRECTORY_LEASING`).
- User-visible: stale Windows directory cache; Microsoft BVT failure.
- Buggy code in this 6.12 tree since v6.7.
- Small, obviously correct, applies cleanly.
- Same class as `3fc74c65b3674` already in this tree.
- Maintainer-authored; in `ksmbd-for-7.3-rc1` as a protocol-
  compatibility fix.
- No extra prerequisites.

**AGAINST:**
- Not a crash, UAF, or security issue.
- No Fixes:/Cc: stable (expected; not a negative).
- No public user bugzilla; test-suite driven.
- `SMB_SERVER` is optional.

**UNRESOLVED:** Original lore review thread (b4/lore 403). No NAK found
in the 7.3-rc1 pull.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — logic is clear; cited BVT;
   maintainer committed it.
2. Fixes a real bug that affects users? **PASS** — missing required
   lease break; stale listings.
3. Important issue? **PASS** at protocol-correctness / “oh, that's not
   good” — not CRITICAL crash, but user-visible on an advertised file-
   server feature. Matches other ksmbd lease-break backports in this
   tree.
4. Small and contained? **PASS** — 2 files, ~8 lines.
5. No new features or APIs? **PASS** — completes existing notify helper;
   no new uAPI.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal contained bugfix.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this 6.12 tree**. Directory leasing is
already on; CREATE without a lease context is a hole in the existing
break path; the fix is tiny and applies cleanly. Treating it as a new
feature would be wrong: the feature is already shipped and documented as
supported.

---

## What the commit solves (and why it matters here)

On 6.12, ksmbd advertises SMB3 directory leasing. Parent breaks were
only sent when the **child CREATE included a lease context**. A second
client creating a file the usual way (no lease context) left the
directory lease intact, so Windows clients could keep a cached listing
that omitted the new name. That fails
`BVT_DirectoryLeasing_ReadWriteHandleCaching` and breaks real SMB3
directory caching.

The patch (1) lets the existing helper accept `lctx == NULL` and break
active parent leases, and (2) calls it after a successful create when
`!lc`. Lease-key filtering for CREATE-with-lease is unchanged.

## Risk vs benefit

Benefit is correct directory invalidation for ksmbd users with
Windows/SMB3 clients. Risk is extra lease breaks only when a child is
actually created — required by the protocol. No new locking scheme; same
helper already used in `smb2_open`.

## Concerns

- Context offset vs mainline (`oplock_break_drain_none` already takes
  `p_ci` here) — **does not block apply**.
- Remaining gap (pre-existing): CREATE with a **v1** lease still returns
  early (`lctx->version != 2`). This patch correctly does not expand
  that; it only adds the NULL-context path the BVT hits.
- Not a panic/UAF; still appropriate because this tree already backports
  the same kind of ksmbd lease-break completeness fixes.

---

## Verification

- **[Phase 1]** `git log -1 --format='%B' abe5acb342822`: only Namjae
  SOB; BVT named; no Fixes/Cc/Reported-by.
- **[Phase 1]** `git describe HEAD` / Makefile: **p-6.12-3 / 6.12.111**.
- **[Phase 2]** Read local `smb_send_parent_lease_break_noti` and
  `smb2_open`; confirmed NULL deref assumption and lease-context-only
  call.
- **[Phase 2]** Confirmed `created` set after `smb2_creat`; `lc` only
  from `parse_lease_state`.
- **[Phase 3]** `git blame`: helper/call site from `d47d9886aeef7`
  (2023-12-08); `git describe --contains` → **v6.7-rc6**.
- **[Phase 3]** `git merge-base --is-ancestor d47d9886aeef7 HEAD` → yes;
  `abe5acb342822` → **not** in HEAD.
- **[Phase 3]** `git show abe5acb342822 | git apply --check --verbose` →
  both files apply (offsets −232 / −1136).
- **[Phase 3]** `git log all-next -S 'created && !lc'` → only this
  commit; no follow-up.
- **[Phase 4]** `b4 dig -c abe5acb342822` → lore errors, no match.
- **[Phase 4]** WebFetch lore.kernel.org → 403.
- **[Phase 4]** LKML GIT PULL 7.3-rc1 lists this commit; merge
  `61a09cfc12147` mentions parent directory lease notifications.
- **[Phase 5]** `git grep smb_send_parent_lease_break_noti` → only
  `smb2_open` + declaration.
- **[Phase 5]** `smb2ops.c`: `SMB2_GLOBAL_CAP_DIRECTORY_LEASING` set for
  SMB3.0/3.02 when leases enabled.
- **[Phase 6]** Docs `ksmbd.rst`: “Directory leases(v2 lease)
  Supported.”
- **[Phase 6]** Similar fix `3fc74c65b3674` is already an ancestor of
  HEAD.
- **[Phase 7]** `MAINTAINERS`: Namjae Jeon is ksmbd maintainer.
- **[Phase 8]** Failure mode verified from code + BVT name: stale
  directory lease, not a kernel oops.
- **UNVERIFIED:** Original lore review comments / NAKs (lore
  unavailable). Not used to drive the verdict; maintainer merge is
  verified.

The fix is small, applies to this tree, and closes a real hole in
advertised SMB3 directory leasing.

**YES**

 fs/smb/server/oplock.c  | 9 +++++----
 fs/smb/server/smb2pdu.c | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 08e3e4504b03f..7d78d4ae43acb 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1271,7 +1271,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	struct ksmbd_inode *p_ci = NULL;
 	LIST_HEAD(brk_list);
 
-	if (lctx->version != 2)
+	if (lctx && lctx->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
@@ -1284,9 +1284,10 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			continue;
 
 		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
-		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
-		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
-				      lctx->parent_lease_key))) {
+		    (!lctx ||
+		     (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		      !compare_guid_key(opinfo, fp->conn->ClientGUID,
+			       lctx->parent_lease_key)))) {
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e7b1cab45ab2d..7d9c8246edfd6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3565,6 +3565,9 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
+		if (created && !lc)
+			smb_send_parent_lease_break_noti(fp, NULL);
+
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			if (S_ISDIR(file_inode(filp)->i_mode)) {
 				lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
-- 
2.53.0

