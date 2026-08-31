Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA424E3782;
	Mon, 31 Aug 2026 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183567; cv=none; b=G10r4sgBJk+OhlBHlb3qYXi90MuNqGUe/47fjGmKc/Y1SS3rhunPuC4rKIDTxLDydfaLG1W/CpdCQ7oruTpgUaS+7LdvDtABu5Twcqu2hSrK1goPHc6f5xOmjyRABzSQ5+JXgzcYhZ+1t9NFAlz3e0ViAksI3lzfmxW2s6ED9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183567; c=relaxed/simple;
	bh=oeU7jOD1C0UTRvrVcggrEmhcm0kMGclwDI6jyj28Hfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1GrUomViqpEpFL5kmCD3pYmXbXwSjtJzUBdIXSaNrKIyFNu3+yNk/UJXZS3IGolIidTjiUw6HkHavxs5Oo4NabaqaHwkzW6RPitM2G/goN8dVaOAtbhvCnSsrFU8z5C8lC0JCnc9THcW0AN3Eg+4NgnWCWaWmBrxqBIbIdbH2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aR5REhXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aR5REhXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618951F00A3F;
	Mon, 31 Aug 2026 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183564;
	bh=EBHL3ebJEglbrEUidGQrHGwY+GePgvhXRvXxJLLBbCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aR5REhXppD3xC43PrfmzAXAV2ffZha3R7kc0tydqbSQFKeg2s5IFngBsZoLUzbslv
	 H24KGpmDiJIX4l0UERDZDgnL6pMnPm1fhWPGv3KwTa9iZO0D8a9yCi7BpZW+D76Quz
	 M6nJzB35eSg48EiS6xO6lP3YgAm5X7j2fdj4PQngGuON6IhI+LYAIDhuR4uOYUSipt
	 r6Z8F57/KfIKIzeoKXsNHqNiDfEu2rGCbH5L223Xx4oSIO0Cur9eW5hASQC99U9kg6
	 BiL3TKF/nKouYWpW1F1Vrcqg9R2Giibk1xcoELOLKj73+gJKE4oAKLLmgxgg9jCnUG
	 tOXsxmVPhODaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: treat read-control opens as stat opens only for leases
Date: Mon, 31 Aug 2026 09:23:20 -0400
Message-ID: <20260831133314.4125787-172-sashal@kernel.org>
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

[ Upstream commit be939e11c4724d1de3650e8bafd4c3583d9684b2 ]

A second open that requests only metadata-level access must not break
the existing caching state. ksmbd already skips the break for such opens
via fp->attrib_only (FILE_READ_ATTRIBUTES,
FILE_WRITE_ATTRIBUTES and FILE_SYNCHRONIZE).

An open requesting only READ_CONTROL (reading the security descriptor)
must be treated differently depending on the existing caching state.
smbtorture smb2.lease.statopen4 expects a read-control open NOT to break
a caching lease, while smb2.oplock.statopen1 expects the same open to
break a batch oplock. So READ_CONTROL is a stat open for leases but not
for oplocks.

Extend the stat-open break-skip in smb_grant_oplock() to also cover a
read-control-only open, but only when the existing holder is a lease.
The global fp->attrib_only flag (used for share-mode, rename and truncate
decisions) is left unchanged so oplock behaviour is preserved.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: treat read-control opens as stat
opens only for leases`

**Local tree:** `v6.18.44` (`linux-6.18.y` stable, `HEAD` detached at
`2736c32da98b9`)
**Candidate commit (mainline):** `be939e11c4724` (on `master`, not yet
in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[ksmbd] [treat] READ_CONTROL-only opens should be treated as
stat opens for leases (but not oplocks)`

**Step 1.2 – Tags**
Record:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (author)
- `Signed-off-by: Steve French <stfrench@microsoft.com>`
  (committer/maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Notable absence: no user report or syzbot; verification cited is Samba
  torture tests

**Step 1.3 – Body analysis**
Record:
- **Bug:** A second open requesting only `READ_CONTROL` (security-
  descriptor read) incorrectly breaks an existing SMB2 caching lease.
- **Symptom:** Spurious lease break when a metadata-only open should
  leave caching state intact; fails `smbtorture smb2.lease.statopen4`.
- **Expected behavior:** `READ_CONTROL` is a stat open for leases (no
  break) but not for oplocks (`smb2.oplock.statopen1` expects break).
- **Root cause:** `fp->attrib_only` covers `FILE_READ_ATTRIBUTES`,
  `FILE_WRITE_ATTRIBUTES`, and `FILE_SYNCHRONIZE` but not
  `READ_CONTROL`; the stat-open skip in `smb_grant_oplock()` therefore
  does not apply.
- **Fix approach:** Extend the stat-open break-skip for
  `READ_CONTROL`-only opens, but only when the existing holder is a
  lease; leave `fp->attrib_only` unchanged so oplock behavior is
  preserved.

**Step 1.4 – Hidden bug fix?**
Record: **Yes.** Despite no "fix" in the subject, this is a protocol-
correctness bug in lease/oplock handling, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- **Files:** `fs/smb/server/oplock.c` only (+27 / −3 lines)
- **Functions modified:** new `ksmbd_inode_has_lease()`; modified
  `smb_grant_oplock()`
- **Scope:** Single-file, surgical fix

**Step 2.2 – Code flow per hunk**

*Hunk 1 – `ksmbd_inode_has_lease()`:*
Record: **Before:** no way to distinguish lease vs oplock holder in the
stat-open path. **After:** peek at first `opinfo` on inode list, return
`is_lease`, with proper refcount via `opinfo_get_list()` /
`opinfo_put()`.

*Hunk 2 – `smb_grant_oplock()` stat-open skip:*
Record: **Before:** only `fp->attrib_only` opens skip the break path
(set `req_op_level = NONE`, `goto set_lev`). **After:** also skip when
open requests only stat/metadata access including `READ_CONTROL` **and**
`ksmbd_inode_has_lease(ci)` is true. Truncating dispositions
(`FILE_OVERWRITE_*`, `FILE_SUPERSEDE`) still force a break.

**Step 2.3 – Bug mechanism**
Record:
- **Category:** Logic / protocol correctness (lease vs oplock semantics)
- **Mechanism:** `READ_CONTROL`-only open has `fp->attrib_only == false`
  (set in `smb2pdu.c:3461-3462`), so code falls through to
  `opinfo_get_list()` and `oplock_break()` even when the existing holder
  is a caching lease. Fix short-circuits that path for lease holders.

**Step 2.4 – Fix quality**
Record:
- Fix is minimal and mirrors existing `attrib_only` logic.
- Deliberately preserves oplock break behavior by gating on
  `ksmbd_inode_has_lease()`.
- Uses existing `fp->daccess` (already set at `smb2pdu.c:3367` before
  `smb_grant_oplock()` at line 3523).
- Low regression risk; same `opinfo_get_list()` pattern already used
  later in `smb_grant_oplock()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record: Stat-open skip introduced in `849fbc549d4cca` (2021-06-29,
"ksmbd: opencode to remove ATTR_FP macro"). Bug has existed since
`attrib_only` was introduced. Present in this 6.18.y tree.

**Step 3.2 – Fixes: tag**
Record: N/A – no `Fixes:` tag.

**Step 3.3 – Related file history**
Record: Recent `oplock.c` changes in 6.18.y are mostly UAF/NULL-
deref/refcount fixes. Mainline has ~27 additional lease/oplock commits
not in 6.18.y (series starting `a04159d96c27f`). This patch is **patch
26/29** of that series but **`git apply --check` succeeds cleanly** on
6.18.y without the other 25 patches.

**Step 3.4 – Author context**
Record: Namjae Jeon is ksmbd maintainer; Steve French is SMB/CIFS
maintainer. Both signed off.

**Step 3.5 – Dependencies**
Record: **Standalone.** No prerequisite commits required; all symbols
(`opinfo_get_list`, `fp->daccess`, `FILE_READ_CONTROL_LE`, `is_lease`)
exist in 6.18.y.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record:
- `b4 dig -c be939e11c4724`:
  https://patch.msgid.link/20260621124844.6235-26-linkinjeon@kernel.org
- Part of v1 series `[PATCH 01/29]` through `[PATCH 29/29]`, dated
  2026-06-21

**Step 4.2 – Reviewers**
Record: `b4 dig -w` CC'd `linux-cifs@vger.kernel.org`,
`smfrench@gmail.com`, `senozhatsky@chromium.org`, `tom@talpey.com`,
`atteh.mailbox@gmail.com`. No `Reviewed-by`/`Acked-by` on the committed
patch.

**Step 4.3 – Bug report**
Record: No external bug report. Verification is internal Samba torture
references (`smb2.lease.statopen4`, `smb2.oplock.statopen1`).

**Step 4.4 – Series context**
Record: Patch 26/29 in a large lease-improvement series. Earlier patches
(e.g. `889d2e38943ad` "break conflicting-open leases only as far as
needed") address related lease-break issues but are **not**
prerequisites for this patch on 6.18.y.

**Step 4.5 – Stable list history**
Record: No `Cc: stable@vger.kernel.org` found in the lore thread (`rg`
over downloaded mbox). No stable-specific discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `ksmbd_inode_has_lease()`, `smb_grant_oplock()`, helpers
`opinfo_get_list()`, `opinfo_put()`, `opinfo_count()`

**Step 5.2 – Callers**
Record: `smb_grant_oplock()` called from `smb2pdu.c:3523` during SMB2
CREATE handling — common file-server path reachable by remote SMB
clients on every open with oplock/lease request.

**Step 5.3 – Callees**
Record: `opinfo_get_list()` acquires `ci->m_lock` read lock and bumps
refcount; `oplock_break()` (avoided by fix) sends break notifications to
clients.

**Step 5.4 – Reachability**
Record: **Yes, remotely triggerable.** Any SMB client opening a file
with only `READ_CONTROL` (+ stat bits) while another client holds a
lease hits this path. ACL/security-descriptor reads are routine Windows
operations.

**Step 5.5 – Similar patterns**
Record: `smb2pdu.c:3303` already treats `FILE_READ_CONTROL` as non-
conflicting for inode permission checks. `fp->attrib_only` definition at
`smb2pdu.c:3461-3462` intentionally excludes `READ_CONTROL` because
oplocks must still break — confirming the fix must be lease-specific,
not a global `attrib_only` change.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.y)

**Step 6.1 – Buggy code present?**
Record: **Yes.** Current tree at `oplock.c:1237-1243`:

```1237:1243:fs/smb/server/oplock.c
        /* grant none-oplock if second open is trunc */
        if (fp->attrib_only && fp->cdoption != FILE_OVERWRITE_IF_LE &&
            fp->cdoption != FILE_OVERWRITE_LE &&
            fp->cdoption != FILE_SUPERSEDE_LE) {
                req_op_level = SMB2_OPLOCK_LEVEL_NONE;
                goto set_lev;
        }
```

Bug present since 2021 (`849fbc549d4cca`).

**Step 6.2 – Backport complications**
Record: **`git format-patch -1 be939e11c4724 | git apply --check` →
clean apply.** No conflicts expected.

**Step 6.3 – Related fixes already present?**
Record: No equivalent fix in 6.18.y (`git log -S
'ksmbd_inode_has_lease'` returns nothing on this tree).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 – Subsystem**
Record: `fs/smb/server` (ksmbd / `CONFIG_SMB_SERVER`) — **IMPORTANT**
for SMB file-server deployments; not core kernel, but critical for that
use case.

**Step 7.2 – Activity**
Record: Actively maintained in 6.18.y with frequent security and
protocol fixes (e.g. `a60b5da05e318` negotiate rejection,
`213b4568f6e5d` deferred-close status).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**
Record: Users running `CONFIG_SMB_SERVER` (module `ksmbd`) with
oplocks/leases enabled — SMB/NAS/file-server deployments.

**Step 8.2 – Trigger conditions**
Record: Second client opens a file requesting only `READ_CONTROL` (+
optional stat bits) while a caching lease is held. **Common** for
ACL/security-descriptor access. Unprivileged remote SMB clients can
trigger.

**Step 8.3 – Failure mode severity**
Record: Spurious lease break → unnecessary client cache invalidation,
extra break/ack round-trips, degraded I/O performance. **Not** crash,
corruption, deadlock, or security exploit. Severity: **MEDIUM**
(protocol/interoperability + performance).

**Step 8.4 – Risk-benefit**
Record:
- **Benefit:** Correct SMB2 lease semantics; passes
  `smb2.lease.statopen4`; prevents unnecessary cache churn on routine
  ACL reads.
- **Risk:** Very low — 27 lines, one file, clean apply, mirrors existing
  logic.
- **Ratio:** Favorable for SMB server users; conservative but justified.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence compile**

*FOR backport:*
- Real, long-standing protocol bug (since 2021)
- Remotely triggerable on common SMB server path
- Small, obviously correct, maintainer-authored fix
- Applies cleanly to 6.18.y without series dependencies
- In mainline (`be939e11c4724` on `master`)
- Precedent: 6.18.y already backports ksmbd protocol/interop fixes
  (`a60b5da`, `213b4568f6e5d`)
- Samba torture test provides concrete verification

*AGAINST backport:*
- No crash, corruption, security issue, or hang
- No user `Reported-by`, no `Cc: stable`, no distro-maintainer
  nomination
- `CONFIG_SMB_SERVER` defaults to `n` — narrower audience
- Performance/interop issue rather than hard failure
- Part of a larger 29-patch lease series (though standalone applicable)

*Unresolved:* No end-user production bug reports found; impact
quantified only via torture tests.

**Step 9.2 – Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; torture-test
   references; maintainer sign-off.
2. Fixes a real bug affecting users? **PASS** — incorrect lease breaks
   on ACL reads affect SMB server clients.
3. Important issue? **PASS (borderline)** — not crash/corruption, but
   protocol non-compliance causing spurious lease breaks and measurable
   cache/performance impact on a file server.
4. Small and contained? **PASS** — 27 lines, one file.
5. No new features/APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — verified clean apply.

**Step 9.3 – Exception categories**
Record: None (not device ID, quirk, DT, build fix, or docs). Qualifies
as protocol correctness fix for existing `CONFIG_SMB_SERVER`
functionality.

**Step 9.4 – Problem summary for stable users**
Without this fix, ksmbd incorrectly breaks caching leases when a client
opens a file solely to read its security descriptor (`READ_CONTROL`).
Windows and Samba clients routinely perform such opens (Explorer
properties, ACL tools, backup software). Each spurious break forces
clients to flush caches and complete break acknowledgments, degrading
performance and violating SMB2 lease semantics that Samba and Windows
implement correctly. The fix is surgical, self-contained, and applies
cleanly to 6.18.y.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and `git show
  be939e11c4724`; tags recorded.
- **[Phase 2]** Analyzed diff; confirmed `fp->daccess` field in
  `vfs_cache.h:94`; confirmed `daccess` set before `smb_grant_oplock()`
  at `smb2pdu.c:3367`/`3523`.
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `git blame` → bug
  since `849fbc549d4cca` (2021); `git log HEAD..master --
  fs/smb/server/oplock.c` → 15+ commits including candidate; `git apply
  --check` → clean.
- **[Phase 4]** `b4 dig -c be939e11c4724` → lore URL found; `b4 dig -a`
  → patch 26/29; `b4 dig -w` → recipients listed; mbox downloaded; no
  `Cc: stable` or NAKs found.
- **[Phase 5]** `grep smb_grant_oplock` → caller in `smb2pdu.c`; traced
  `attrib_only` definition at `smb2pdu.c:3461-3462`.
- **[Phase 6]** Confirmed buggy code at `oplock.c:1237-1243`;
  `ksmbd_inode_has_lease` absent; `git apply --check` passes.
- **[Phase 7]** `CONFIG_SMB_SERVER` in `fs/smb/server/Kconfig`; recent
  ksmbd stable commits reviewed.
- **[Phase 8]** Assessed trigger (remote READ_CONTROL open) and severity
  (spurious lease break, MEDIUM).
- **[Phase 9]** Stable rules checklist completed; decision synthesized.

**YES**The background `git log` searches timed out, but that didn’t
block the analysis — the commit was found on `master` as
`be939e11c4724`, and the rest of the investigation (clean apply to
6.18.y, lore thread, code review) completed normally.

**Verdict for 6.18.y: YES** — this is a real SMB2 lease protocol bug
(spurious lease breaks on `READ_CONTROL`-only opens) with a small, self-
contained fix that applies cleanly.

 fs/smb/server/oplock.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index b6705a07c6ebe..f700ee48c54c0 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -208,6 +208,18 @@ void opinfo_put(struct oplock_info *opinfo)
 	free_opinfo(opinfo);
 }
 
+static bool ksmbd_inode_has_lease(struct ksmbd_inode *ci)
+{
+	struct oplock_info *opinfo = opinfo_get_list(ci);
+	bool is_lease;
+
+	if (!opinfo)
+		return false;
+	is_lease = opinfo->is_lease;
+	opinfo_put(opinfo);
+	return is_lease;
+}
+
 static void opinfo_add(struct oplock_info *opinfo, struct ksmbd_file *fp)
 {
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1251,10 +1263,22 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (!opinfo_count(fp))
 		goto set_lev;
 
-	/* grant none-oplock if second open is trunc */
-	if (fp->attrib_only && fp->cdoption != FILE_OVERWRITE_IF_LE &&
+	/*
+	 * A stat open that only requests metadata access must not break the
+	 * existing caching state. READ_CONTROL (reading the security
+	 * descriptor) does not conflict with a lease, but it does conflict
+	 * with an oplock, so only treat a read-control-only open as a stat
+	 * open when the existing holder is a lease.
+	 */
+	if (fp->cdoption != FILE_OVERWRITE_IF_LE &&
 	    fp->cdoption != FILE_OVERWRITE_LE &&
-	    fp->cdoption != FILE_SUPERSEDE_LE) {
+	    fp->cdoption != FILE_SUPERSEDE_LE &&
+	    (fp->attrib_only ||
+	     (!(fp->daccess & ~(FILE_READ_ATTRIBUTES_LE |
+				FILE_WRITE_ATTRIBUTES_LE |
+				FILE_SYNCHRONIZE_LE |
+				FILE_READ_CONTROL_LE)) &&
+	      ksmbd_inode_has_lease(ci)))) {
 		req_op_level = SMB2_OPLOCK_LEVEL_NONE;
 		goto set_lev;
 	}
-- 
2.53.0

