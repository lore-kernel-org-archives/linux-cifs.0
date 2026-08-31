Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47972456DF6;
	Mon, 31 Aug 2026 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183832; cv=none; b=hpYe0GEVbTdEhgqoFx4PCTMUpWNxnFWvY5y/3BOCsnPdRCs+dA+8ymC6TVmYvFUwUmyTK7yKjOTJTgRglFPYNGr1IBwd+nUUsG1uSpdpj6gdFRk6osWKrk7sT0dhIEsCPjpPFtkjlcajN6wb9gluoOB2TcaN+wmGIvdqUMB/6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183832; c=relaxed/simple;
	bh=BY0sYsOkjw+lwbo2U/1KhTCXJdcjvMjWFoxeMZn/7jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bk9uQdtU0z0cQO3cph8hUe/sR/ko43AYqtbCKBrweTo2ZWKGMfnqg7iku7WgFo8zQo6m5yTiCFAcmXHWbaodGS9rNnHJs/4Oqxajr1Sm7LYg/Oo66tZ8HdTUXZ5WbVcu4X2ft7SZmLDYvwuiGH4MElTJWQCYkAllJcfTLUJTcFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZJTJV5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZJTJV5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC66D1F000E9;
	Mon, 31 Aug 2026 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183830;
	bh=jBxWzahJoB3M+7XdxC2rqWeCO4g1U/kwfCrwcjLGMLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZJTJV5xxyteRiiH9fMwgR0RqEB6JzhULGlsU3HXIx+I2bX8wg/0Lji30vlx3eQu9
	 CKPUN4A2XgMtFIi0EA/7dFRcTYaSj9a/s9Yi0Q9Y5HV37NK/QSqTjA7N0Ou4B7m/6r
	 J5iLKf7msKLLEMeIsIMLYaEf1Pq0V6ox+tLH6u1ni/R8HNSc9RuYurR5TjfZpDkR3m
	 9cd7wUGG43iD16jB9FU19HEXo4JdIUcBtqdDkwINpEAGoLiYZ+JGM8QIQDv4Z9E6xV
	 AUPWiTy4oDWPJtPgbo4vSG2rPsFqziwuYMbYcmGNfwjWculUL6VwXO5WlT4xpLOMn5
	 dudxpD9RreaDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: apply create security descriptor first
Date: Mon, 31 Aug 2026 09:25:58 -0400
Message-ID: <20260831133314.4125787-330-sashal@kernel.org>
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

[ Upstream commit ba3cf6ee4f0eacc1f8c607b80188e3b32ef5e0e3 ]

smb2.create.aclfile creates files with an SMB2_CREATE_SD_BUFFER create
context and expects the resulting security descriptor to match
the descriptor supplied by the client.

ksmbd currently tries to inherit the parent DACL first and only parses
the SMB2_CREATE_SD_BUFFER context when DACL inheritance fails.
If inheritance succeeds, the explicit security descriptor supplied on
create is ignored. This breaks create requests that include owner/group
information in the security descriptor.

Apply the create security descriptor first when the context is present.
Fall back to the existing inherited/default ACL path only when no create
security descriptor was supplied.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: apply create security descriptor
first`

**Local tree:** `v6.18.44` (linux-6.18.y stable), commit `ba3cf6ee4f0ea`
is **not** in this tree; buggy code is present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ksmbd] [apply] Reorder SMB2 file-create security
descriptor handling so explicit client-supplied descriptors are applied
before DACL inheritance fallback.`

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — none
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>`, Steve French
  `<stfrench@microsoft.com>` (ignore pipeline-added SOBs)

No syzbot, no user bug reports, no explicit stable nomination in tags.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** When a client sends `SMB2_CREATE_SD_BUFFER` with an explicit
  security descriptor (including owner/group), ksmbd applies parent DACL
  inheritance first and only parses the create context if inheritance
  fails. If inheritance succeeds, the client-supplied descriptor is
  silently ignored.
- **Symptom:** `smb2.create.aclfile` test fails; created files do not
  match the security descriptor the client supplied.
- **Root cause:** Wrong ordering — inheritance attempted before explicit
  create-context SD.
- **Fix:** Call `smb2_create_sd_buffer()` first; fall back to
  inherit/default ACL path only when no create SD was supplied
  (`-ENOENT`).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised as cleanup — this is an explicit
protocol/access-control correctness fix. The wrong ordering causes
incorrect owner/group/ACL assignment on newly created files.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `fs/smb/server/smb2pdu.c` (+9 / -7, net +2)
- **Function:** `smb2_open()` — file-create ACL setup block (`if
  (created)`)
- **Scope:** Single-file, surgical reorder of existing logic

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| ACL setup on create | `smb_inherit_dacl()` first (if `ACL_XATTR`
flag); only on failure call `smb2_create_sd_buffer()` |
`smb2_create_sd_buffer()` first; on `-ENOENT` (no SD context), fall back
to `smb_inherit_dacl()` and existing default-ACL path |
| Error handling | Inherited path errors fell through to SD buffer |
Real SD-buffer errors (`!= -ENOENT`) go directly to `err_out` |

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic / correctness fix (access control).
**Mechanism:** `smb_inherit_dacl()` returning success (`rc == 0`)
prevented the `if (rc)` block from ever calling
`smb2_create_sd_buffer()`, so explicit client security descriptors were
discarded whenever parent DACL inheritance succeeded.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and obviously correct — it mirrors SMB2
protocol intent (explicit create context takes precedence). No new APIs,
no structural changes. Regression risk is low: when no SD buffer is
present, `smb2_create_sd_buffer()` returns `-ENOENT` and the original
inherit/default fallback path runs unchanged. Verified that the inner
default-ACL block still gates on `KSMBD_SHARE_FLAG_ACL_XATTR`, so
behavior without that flag and without an explicit SD is unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy ordering introduced in `e2f34481b24db2` ("cifsd: add
server-side procedures for SMB3", March 2021). Present in this tree at
lines 3382–3389 of `fs/smb/server/smb2pdu.c`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Recent `smb2pdu.c` activity in 6.18.y includes multiple
ksmbd security/ACL fixes (UAF, permission checks, DACL validation). Fix
commit `ba3cf6ee4f0ea` is on `master` but not in 6.18.y.

### Step 3.4: Author Context
**Record:** Namjae Jeon is the ksmbd maintainer. Steve French (co-SOB)
is the CIFS/ksmbd subsystem maintainer.

### Step 3.5: Dependencies
**Record:** Patch is **[PATCH 18/29]** in a series, but this hunk is
**standalone** — only reorders calls to existing functions in
`smb2_open()`. No prerequisite commits required. `git apply --check`
passes cleanly on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c ba3cf6ee4f0ea` →
https://patch.msgid.link/20260621124844.6235-18-linkinjeon@kernel.org.
Part of v1 series "[PATCH 01/29] ksmbd: handle missing create contexts
for lease opens". Thread saved to mbox; contains patch submission only
(no review replies in thread).

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd: `linux-cifs@vger.kernel.org`, Steve
French, Sergey Senozhatsky, Tom Talpey, Hyunchul Lee. No `Reviewed-
by`/`Acked-by` in committed version.

### Step 4.3: Bug Report
**Record:** Referenced test `smb2.create.aclfile` (Samba/ksmbd test
suite). No external bugzilla or syzbot report.

### Step 4.4: Series Context
**Record:** 29-patch series; this patch is self-contained and does not
depend on other series members.

### Step 4.5: Stable List History
**Record:** No `stable@vger.kernel.org` nomination found in mbox thread.
WebFetch of lore blocked by bot protection; analysis based on b4 mbox
download.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `smb2_open()`, `smb2_create_sd_buffer()`,
`smb_inherit_dacl()`, `set_info_sec()`

### Step 5.2: Callers
**Record:** `smb2_open` registered as handler for `SMB2_CREATE` in
`fs/smb/server/smb2ops.c` (`[SMB2_CREATE_HE] = { .proc = smb2_open }`).
Triggered by remote SMB clients on every file/directory create.

### Step 5.3: Callees
**Record:** `smb2_create_sd_buffer()` → `set_info_sec()` which parses
the NT security descriptor and applies owner, group, mode, and ACLs via
VFS (`notify_change`, `set_posix_acl`, xattrs).

### Step 5.4: Reachability
**Record:** Fully reachable from network clients via SMB2 CREATE with
`SMB2_CREATE_SD_BUFFER` create context. Any authenticated SMB client can
trigger this path when creating files with explicit security
descriptors.

### Step 5.5: Similar Patterns
**Record:** No other instances of this ordering bug found in the ksmbd
tree. Related ACL fixes in stable (e.g., `ksmbd: add a
WRITE_DAC/WRITE_OWNER check to SMB2 SET_INFO SECURITY`) show ACL
correctness is actively maintained in 6.18.y.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree at `fs/smb/server/smb2pdu.c:3382-3389`
still has inherit-first ordering. Bug present since ksmbd was introduced
(~5.13).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git show ba3cf6ee4f0ea | git apply
--check` succeeds with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** Fix commit `ba3cf6ee4f0ea` is NOT an ancestor of HEAD. No
duplicate fix found via `git log --grep`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `fs/smb/server` (ksmbd in-kernel SMB3 server). **IMPORTANT**
— network file server with access-control semantics; config-gated via
`CONFIG_SMB_SERVER`.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained in 6.18.y with frequent security and
ACL-related stable backports.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** Users running ksmbd (`CONFIG_SMB_SERVER`) with shares that
use NT ACLs (`KSMBD_SHARE_FLAG_ACL_XATTR`) and clients that create files
with explicit security descriptors.

### Step 8.2: Trigger Conditions
**Record:** SMB2 CREATE with `SMB2_CREATE_SD_BUFFER` create context,
while parent DACL inheritance succeeds. Common for Windows/Samba clients
managing file ownership and ACLs. Network-reachable by authenticated
clients.

### Step 8.3: Failure Mode Severity
**Record:** Incorrect owner/group/ACL on created files — **access
control violation**. Not a kernel crash, but wrong permissions on a file
server can grant unintended access or deny intended access. Severity:
**HIGH** for security/access-control context; not CRITICAL (no
crash/corruption).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for ksmbd deployments using NT ACLs — restores
  correct SMB2 protocol behavior
- **Risk:** VERY LOW — 16-line reorder of existing calls, applies
  cleanly, no behavior change when no explicit SD is supplied
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, long-standing protocol bug (since 2021)
- Access-control correctness on network file server
- Small, surgical, maintainer-authored fix
- Applies cleanly to 6.18.y
- Buggy code confirmed present; fix not yet applied
- Standalone despite being patch 18/29

**AGAINST backport:**
- No crash/panic/data corruption
- No syzbot or user bug reports
- Only affects `CONFIG_SMB_SERVER` users
- No explicit stable nomination in mailing list
- Part of larger series (though self-contained)

**Unresolved:** No independent test results beyond commit message
reference to `smb2.create.aclfile`.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer-
   signed; Samba test referenced
2. Fixes a real bug affecting users? **PASS** — explicit SD ignored on
   file create
3. Important issue? **PASS** — access-control correctness on file server
   (security-relevant)
4. Small and contained? **PASS** — 1 file, ~16 lines
5. No new features or APIs? **PASS** — reorder only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a protocol/access-control bug fix.

### Step 9.4: Problem Summary for Stable Users

ksmbd deployments using NT ACLs can create files with wrong owner,
group, or DACL when clients supply an explicit security descriptor via
`SMB2_CREATE_SD_BUFFER`. The server silently ignores the client's
descriptor if parent DACL inheritance succeeds. This breaks SMB2
interoperability (Samba test `smb2.create.aclfile`) and can result in
incorrect file permissions — a security concern on multi-user file
servers.

The fix is minimal, self-contained, applies cleanly to 6.18.y, and
restores correct protocol ordering without changing the no-explicit-SD
fallback path.

---

## Verification

- [Phase 1] `git show ba3cf6ee4f0ea`: parsed subject, body, SOBs; no
  Fixes/Reported-by/Link tags
- [Phase 2] `git show ba3cf6ee4f0ea -p`: 1 file, +9/-7, reorder in
  `smb2_open()` create-ACL block
- [Phase 2] Read `fs/smb/server/smb2pdu.c:3371-3448`: confirmed current
  buggy ordering and full fallback path
- [Phase 2] Read `smb2_create_sd_buffer()` at line 2647: returns
  `-ENOENT` when no SD context
- [Phase 2] Read `set_info_sec()` in `smbacl.c:1601`: applies
  owner/group/mode/ACL from SD
- [Phase 3] `git blame -L 3380,3395 fs/smb/server/smb2pdu.c`: buggy
  logic from `e2f34481b24db2` (2021)
- [Phase 3] `git show e2f34481b24db2 --oneline`: "cifsd: add server-side
  procedures for SMB3"
- [Phase 3] `git log --oneline -20 -- fs/smb/server/smb2pdu.c`: recent
  ksmbd ACL/security activity in tree
- [Phase 3] `git merge-base --is-ancestor ba3cf6ee4f0ea HEAD`: NOT IN
  TREE
- [Phase 3] `git show ba3cf6ee4f0ea | git apply --check`: applies
  cleanly
- [Phase 4] `b4 dig -c ba3cf6ee4f0ea`: lore URL found
- [Phase 4] `b4 dig -c ba3cf6ee4f0ea -a`: v1 series, patch 18/29
- [Phase 4] `b4 dig -c ba3cf6ee4f0ea -w`: CC list includes Steve French,
  linux-cifs
- [Phase 4] `b4 dig -c ba3cf6ee4f0ea -m /tmp/ksmbd-sd-thread.mbox`:
  thread downloaded; no Reviewed-by/stable@/NAK found
- [Phase 4] WebFetch lore.kernel.org: blocked (bot protection) — used b4
  mbox instead
- [Phase 5] `grep smb2_open fs/smb/server/`: handler for `SMB2_CREATE`
  in `smb2ops.c`
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 6] `head Makefile`: VERSION=6, PATCHLEVEL=18, SUBLEVEL=44
- [Phase 6] Read current `smb2pdu.c:3382-3389`: buggy inherit-first code
  confirmed present
- [Phase 6] `git log master --grep="apply create security descriptor
  first"`: found `ba3cf6ee4f0ea` on master only

**YES**The background searches finished and match the earlier analysis:

- **Commit hash:** `ba3cf6ee4f0ea` on `master` — not in the local 6.18.y
  tree (`v6.18.44`)
- **Buggy code:** still present in `fs/smb/server/smb2pdu.c` (inherit
  DACL before explicit create SD)
- **Patch:** applies cleanly to this tree

**Verdict for 6.18.y: YES** — small access-control fix; when clients
send `SMB2_CREATE_SD_BUFFER`, ksmbd should apply that descriptor first
instead of ignoring it after successful DACL inheritance.

 fs/smb/server/smb2pdu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 66871fbe53f48..da0e02b760f8e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3401,14 +3401,16 @@ int smb2_open(struct ksmbd_work *work)
 		if (posix_acl_rc)
 			ksmbd_debug(SMB, "inherit posix acl failed : %d\n", posix_acl_rc);
 
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_ACL_XATTR)) {
-			rc = smb_inherit_dacl(conn, &path, sess->user->uid,
-					      sess->user->gid);
-		}
+		rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc && rc != -ENOENT)
+			goto err_out;
 
-		if (rc) {
-			rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc == -ENOENT) {
+			if (test_share_config_flag(work->tcon->share_conf,
+						   KSMBD_SHARE_FLAG_ACL_XATTR)) {
+				rc = smb_inherit_dacl(conn, &path, sess->user->uid,
+						      sess->user->gid);
+			}
 			if (rc) {
 				if (posix_acl_rc)
 					ksmbd_vfs_set_init_posix_acl(idmap,
-- 
2.53.0

