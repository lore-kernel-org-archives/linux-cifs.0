Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1C50F147;
	Mon, 19 Oct 2026 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418207; cv=none; b=rkI5FrZO7C6pdX6tdWyhTscfKoxwPG7lA2tOCJPmw/q8/Ozisp79VMomUTVf9LSGjekDRJput1YxOC9YAKMiXF7ze00rDm+A1rAN4V8Fht2z4NpayTcjIrpQTBKOTSNuO5BFFwoUDbc9XT1WdzhKsJryAkfVbbMrgmFudFaunBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418207; c=relaxed/simple;
	bh=90AR6f7WP+2M4vPZ3hQuN+ladEw1PfaypQRz1o4KN4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IU80H2hdFdvWBsE/BAZ5PrBOmru/9txGwoN5eSyaowSZmx92Qw+3AawQrNJ4ofBL4C6uzNsP8Czn63uM9zGG+TIfgwYr0xVWCerQin2zutEqpXsrw86lqiDiJI5Y3X5rRa5xhyqvlzcT9d8crHqRATgO+/Q09HGi0uYVa3W7wxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bG9ZSGVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bG9ZSGVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D41F000C8;
	Mon, 19 Oct 2026 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418204;
	bh=1CA/esgsMDkCsGUCw34nOJdqRtKVGJ6+sEZGGk5HUio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG9ZSGVCg3jMDvpCEmVdVC9SIDRjwcwsS6xVTUllSMIAUB7hoJ4PlmvHHwGPYke8g
	 H3mJP20D+gciHKgsKJPvJORVnja7mDZ3HWz+oaMdumX98yZgB6VVpxoTcKTLZjCqHU
	 K9EPRfA3Rk92F38KgNjedPgauXkiD98VgJ2t8mlgHi8xDua4klSU09NIQdyXntDYe0
	 GQbLX7ZQ28E/64ENEW1trjQPn4fEqd95nVHFHIBvlwz9gsgFfEYauTIdctuDmJXTKe
	 TpDXlH+3DI+wFCeVRbzabtK4HjEqgh7t6whkJAZ0FFqgeJta+L0zw9IW36HXbnsHno
	 UKGG6VB4JfBhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Mon, 19 Oct 2026 09:46:17 -0400
Message-ID: <20261019135441.1420968-86-sashal@kernel.org>
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

[ Upstream commit 7f07791522a251e2be087d11ae9cd51eb3408f1d ]

FSCTL_QUERY_ALLOCATED_RANGES can be issued with a valid input buffer but
without room for an output range.  Do not reject the request before
looking at the file layout.  If the query would produce a range, return
STATUS_BUFFER_TOO_SMALL.  If it produces no ranges, return success with an
empty output.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `in_count ==
0` path is present here; the upstream fix is not. This is a small, spec-
driven ksmbd protocol fix that applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ksmbd] [handle] empty QUERY_ALLOCATED_RANGES output** —
“handle” here means correct SMB2 status/output when the client supplies
a valid input buffer but no room for an output range.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record: Tags on upstream `7f07791522a251e2be087d11ae9cd51eb3408f1d`:
- Signed-off-by: Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd
  maintainer; also committer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
- The candidate copy’s `[Upstream commit …]` and `Signed-off-by: Sasha
  Levin` were ignored as pipeline markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `FSCTL_QUERY_ALLOCATED_RANGES` is rejected when the output
  buffer cannot hold one `FILE_ALLOCATED_RANGE_BUFFER` (16 bytes),
  before the file layout is inspected.
- **Symptom:** Client gets a hard `STATUS_INVALID_PARAMETER` instead of
  `STATUS_BUFFER_TOO_SMALL` (ranges exist) or success with empty output
  (no ranges).
- **Root cause:** Early `if (in_count == 0) return -EINVAL` in
  `fsctl_query_allocated_ranges()`.
- **No version range** in the message. Function dates to 2021
  (`e2f34481b24db2`).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit protocol-correctness
fix: wrong NTSTATUS for a documented FSCTL.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/smb/server/smb2pdu.c` — **+12 / −4** (16 lines)
- Function: `fsctl_query_allocated_ranges()` only
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `in_count == 0` (i.e. `out_buf_len < sizeof(struct
  file_allocated_range_buffer)`) returns `-EINVAL` immediately, mapped
  in `smb2_ioctl()` to `STATUS_INVALID_PARAMETER`. File is never looked
  at.
- **After:** Validate offset/length and look up the file. If `in_count
  == 0`, probe with a **stack** dummy range and `in_count=1`. If that
  probe fills a range, return `-ENOSPC` (`STATUS_BUFFER_TOO_SMALL` at
  line 8701–8702). If it fills nothing, return 0 with `*out_count = 0`.
  Non-zero `in_count` is unchanged.
- Path: normal FSCTL handling, not an init/error-only cleanup.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / protocol correctness**, matching [MS-FSA]
FSCTL_QUERY_ALLOCATED_RANGES:
- `OutputBufferSize < sizeof(FILE_ALLOCATED_RANGE_BUFFER)` **MUST** fail
  with `STATUS_BUFFER_TOO_SMALL`
- No allocated ranges → `STATUS_SUCCESS`, `BytesReturned = 0`
- Input `Length == 0` → success with empty output

Using a stack dummy is required: calling `ksmbd_vfs_fqar_lseek()` with
`qar_rsp` and `in_count=1` when the real output buffer is shorter than
16 bytes would write past the ioctl response buffer.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct against MS-FSA and the existing `-ENOSPC` →
`STATUS_BUFFER_TOO_SMALL` mapping. Minimal. Regression risk is low: fd
get/put stay balanced; dummy is on-stack; `*out_count` is forced to 0 on
the empty-output path. Slight error-code change for “bad fid **and**
tiny output buffer” (`-EINVAL` → `-ENOENT`) is more correct.

Verified `git apply --check` on this tree: **hunks apply cleanly**
(offset −891 lines only).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `if (in_count == 0) return -EINVAL` lines were introduced in
**`e2f34481b24db2`** (“cifsd: add server-side procedures for SMB3”,
2021-05-10). Present for the entire ksmbd lifetime in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introducing commit **is** an ancestor of HEAD
(`git merge-base --is-ancestor e2f34481b24db2 HEAD` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related later mainline work (not in this tree):
- `350684e049851` — dense-file SEEK_DATA handling (`vfs.c`)
- `25e414db70333` — holes / `-E2BIG` overflow (`vfs.c` + `smb2pdu.c`,
  larger)
- `3c707d4b3f926` — READ_DATA permission on this FSCTL

Those are **independent** bugs. This patch only changes the zero-output-
buffer gate and does not need them.

Recent 6.12 ksmbd work on the same file includes other buffer-size
protocol fixes already in this tree (`fix partial file information
responses`, `return buffer overflow for partial filesystem info`, `fix
partial normalized name responses`). Same class of bug.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namjae Jeon is listed in MAINTAINERS as **KERNEL SMB3 SERVER
(KSMBD)** maintainer. This landed in his 7.3-rc1 ksmbd pull (protocol-
compat / smbtorture).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Calls existing `ksmbd_vfs_fqar_lseek()`. In this
tree that helper still has `if (!in_count) return 0`, which is why the
probe must pass `in_count=1`. No new helpers or struct fields. **Applies
standalone.**

`git merge-base --is-ancestor 7f07791522a251e2be087d11ae9cd51eb3408f1d
HEAD` → not in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 7f07791522a251e2be087d11ae9cd51eb3408f1d` failed:
  lore.kernel.org returned an error
- WebFetch of lore search URLs returned **403**
- **UNVERIFIED:** v1/v2 revisions, NAKs, reviewer-requested Cc: stable
- Verified via LKML: commit is in **[GIT PULL] ksmbd server update for
  7.3-rc1** (Namjae Jeon, 2026-08-23), grouped with protocol-
  compatibility fixes “validated with smbtorture” and “allocated-range
  queries”

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: **UNVERIFIED** (b4 -w failed with lore). Commit is authored
**and** committed by the ksmbd maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla tag. Behavior is specified in [MS-FSA]
2.1.5.10.22: too-small output **MUST** be `STATUS_BUFFER_TOO_SMALL`;
empty result is success. Samba/Windows discussions distinguish that
status from `STATUS_BUFFER_OVERFLOW` (partial fill) and from
`STATUS_INVALID_PARAMETER` (hard fail).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Sequential maintainer commits around 2026-07-09; next ones
change `vfs.c` for dense files/holes. Not a numbered `N/M` series. This
hunk is self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** (lore 403). Absence of Cc: stable is expected for
this pipeline.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `fsctl_query_allocated_ranges()`; helper
`ksmbd_vfs_fqar_lseek()`; dispatcher `smb2_ioctl()`.

**Step 5.2: TRACE CALLERS**
Record:
- Sole caller: `smb2_ioctl()` `case FSCTL_QUERY_ALLOCATED_RANGES`
  (`fs/smb/server/smb2pdu.c`)
- `smb2_ioctl` is `SMB2_IOCTL_HE` in `fs/smb/server/smb2ops.c`
- Reachable from authenticated SMB2 clients over the network (not
  interrupt context)

**Step 5.3: TRACE CALLEES**
Record: `ksmbd_lookup_fd_fast` / `ksmbd_fd_put`; `ksmbd_vfs_fqar_lseek`
→ `vfs_llseek(SEEK_DATA/SEEK_HOLE)`. Probe uses a stack buffer, not the
response buffer.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/network client → SMB2 IOCTL →
FSCTL_QUERY_ALLOCATED_RANGES. **Yes, user-triggerable.** `in_count == 0`
when `smb2_calc_max_out_buf_len()` yields `out_buf_len < 16`
(`MaxOutputResponse` 0..15). Linux CIFS often asks for ≥16 bytes
(`smb2ops.c`); Windows/smbtorture can send a smaller max output. That is
a real client pattern for this FSCTL.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already special-cases `-E2BIG` →
`STATUS_BUFFER_OVERFLOW` and `-ENOSPC` → `STATUS_BUFFER_TOO_SMALL`. This
patch is the missing `in_count==0` case of that protocol. Other ksmbd
“too-small output buffer” fixes are already in this 6.12 tree.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `fs/smb/server/smb2pdu.c` lines 8196–8198:

```8196:8211:fs/smb/server/smb2pdu.c
        *out_count = 0;
        if (in_count == 0)
                return -EINVAL;
        ...
        ret = ksmbd_vfs_fqar_lseek(fp, start, length,
                                   qar_rsp, in_count, out_count);
```

Local version: **6.12.111**. Bug introduced **v5.15-era ksmbd (2021)**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (`git apply --check` succeeded). Surrounding
function matches the upstream pre-image besides line numbers.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit in this tree greps to this subject/behavior.
Dense-file / holes / extra permission commits are **not** ancestors of
HEAD. Not required for this gate-fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM**
Record: **ksmbd** (`fs/smb/server/`). **IMPORTANT** (in-kernel SMB3
server: NAS, OpenWrt, appliances). Not core mm/VFS for all boots;
network-facing for every ksmbd user. `CONFIG_SMB_SERVER` default n.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; many ksmbd protocol fixes already on this
branch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver/config-specific:** ksmbd (`CONFIG_SMB_SERVER`) serving
`FSCTL_QUERY_ALLOCATED_RANGES` (sparse-file tools, backup, smbtorture,
some Windows APIs).

**Step 8.2: TRIGGER CONDITIONS**
Record: Valid QUERY_ALLOCATED_RANGES input **and** `MaxOutputResponse <
16`. Not every IOCTL; not unprivileged local syscalls except via an SMB
session. Timing-independent.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Wrong NTSTATUS → client treats a sizing/empty query as a **hard
parameter error** instead of retry (`BUFFER_TOO_SMALL`) or empty
success. Can fail sparse-file / backup / torture paths. **MEDIUM**
(functional interoperability, not oops/UAF/corruption).

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Medium — restores documented SMB status for a long-
  standing ksmbd FSCTL; clients can retry or accept empty results.
- **Risk:** Very low — 16 lines, existing error mapping, stack dummy,
  clean apply, no API/locking change.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real MS-FSA MUST violation: tiny output buffer returns
  `STATUS_INVALID_PARAMETER` instead of `STATUS_BUFFER_TOO_SMALL` /
  empty success
- User-visible: SMB clients abort instead of retrying or treating the
  file as having no ranges
- Present in this 6.12 tree since ksmbd was added
- 16-line surgical change; applies cleanly; no prerequisites
- Maintainer-authored; in 7.3 ksmbd pull as smbtorture protocol-compat
- Dummy buffer avoids a would-be response-buffer overflow
- Same class as buffer-size ksmbd fixes already on this branch

**AGAINST:**
- Not a crash, UAF, security hole, deadlock, or data corruption
- No syzbot/CVE/Reported-by
- Trigger is a small `MaxOutputResponse`, not the Linux CIFS client’s
  usual 16+-byte buffer
- Sibling dense-file/holes fixes remain separate (they do not block this
  one)

**UNRESOLVED:** lore/b4 review thread (403/server error); no explicit
stable mailing-list discussion.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches MS-FSA; maintainer
   commit; smbtorture-oriented 7.3 pull. Direct lore Tested-by
   unverified.
2. Fixes a real bug that affects users? **PASS** — wrong NTSTATUS on a
   reachable FSCTL.
3. Important issue? **PASS** (MEDIUM-HIGH for a network file server) —
   hard client failure vs retryable/empty result; not a panic.
4. Small and contained? **PASS** — one function, +12/−4.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy code present; `git
   apply --check` clean.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID / quirk / DT / build / docs patch).
Qualifies as a normal contained bugfix.

**Step 9.4: DECISION**
Backport to **this** 6.12 tree. The bug exists here, the fix is
standalone and low-risk, and returning the wrong SMB status on
QUERY_ALLOCATED_RANGES is a real interoperability failure for ksmbd
users.

---

### What the commit solves for stable users
On 6.12 ksmbd, a legal `FSCTL_QUERY_ALLOCATED_RANGES` with
`MaxOutputResponse` smaller than one range is failed as
`STATUS_INVALID_PARAMETER` before the file is examined.
Windows/smbtorture expect `STATUS_BUFFER_TOO_SMALL` if ranges exist, or
success with zero output if they do not. That mismatch can abort sparse-
file queries instead of allowing a retry.

### Stable rules / risk
The change is obviously correct, small, and already wired to this tree’s
`-ENOSPC` mapping. It does not need the later dense-file or holes vfs
work. Risk is a slightly different (more accurate) status on a rare
combined bad-fid + tiny-buffer case.

### Verification
- **[Phase 1]** Parsed upstream
  `7f07791522a251e2be087d11ae9cd51eb3408f1d`: maintainer SOB only; no
  Fixes/Reported-by/Cc stable
- **[Phase 2]** Diff: +12/−4 in `fsctl_query_allocated_ranges()`; dummy
  stack probe; `-ENOSPC` when probe fills a range
- **[Phase 2]** Confirmed `smb2_ioctl()` maps `-ENOSPC` →
  `STATUS_BUFFER_TOO_SMALL` (lines 8701–8702)
- **[Phase 3]** `git blame`: `in_count == 0` from `e2f34481b24db2`
  (2021); ancestor of HEAD
- **[Phase 3]** `git merge-base --is-ancestor 7f077915… HEAD` → not in
  this tree
- **[Phase 3]** `git apply --check` of the upstream diff → clean (offset
  −891)
- **[Phase 3]** Sibling dense/holes/perms commits exist as objects,
  **not** ancestors of HEAD; vfs probe still works with 6.12
  `ksmbd_vfs_fqar_lseek`
- **[Phase 4]** `b4 dig` lore error; lore WebFetch 403; LKML 7.3-rc1
  ksmbd pull lists this subject
- **[Phase 4]** MS-FSA: too-small output MUST be
  `STATUS_BUFFER_TOO_SMALL`
- **[Phase 5]** Only caller is `smb2_ioctl`
  FSCTL_QUERY_ALLOCATED_RANGES; dispatched as `SMB2_IOCTL_HE`
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111; buggy early `-EINVAL` still present
- **[Phase 7]** MAINTAINERS: Namjae Jeon is ksmbd maintainer
- **[Phase 8]** Failure mode: wrong NTSTATUS / client abort, not oops
- **UNVERIFIED:** lore reviewer comments, Tested-by, explicit stable
  nomination

**YES**

 fs/smb/server/smb2pdu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0fbbb47f94644..c18590d8ee2b9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8302,8 +8302,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -8315,8 +8313,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (!fp)
 		return -ENOENT;
 
-	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
-				   qar_rsp, in_count, out_count);
+	if (!in_count) {
+		struct file_allocated_range_buffer range;
+
+		ret = ksmbd_vfs_fqar_lseek(fp, start, length, &range, 1,
+					   out_count);
+		if (!ret && *out_count)
+			ret = -ENOSPC;
+		*out_count = 0;
+	} else {
+		ret = ksmbd_vfs_fqar_lseek(fp, start, length,
+					   qar_rsp, in_count, out_count);
+	}
 	if (ret && ret != -E2BIG)
 		*out_count = 0;
 
-- 
2.53.0

