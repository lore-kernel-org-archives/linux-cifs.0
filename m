Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8A59F51D;
	Mon, 19 Oct 2026 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418371; cv=none; b=Uii3MqE7cYGTFwJftx8VPVqwNBhLgoLqJHHoayNXSSruGL7t3Pxw6j8uIcpYrmKBonRxNwIgyDkTP1+jXKsWg5qLxL5h1QPNHl9icKm5QAXG8Do74TnBub0BZDXK0DDFm4IB573G7/L284Ak7tGN6mchWYp19y0t9FXXkWlhitk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418371; c=relaxed/simple;
	bh=3CqDiwc+aGFulVbpCYEr+hO5CJ/k3rk2QV1mL+1tE4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCza7iNm8ECpPipHLREQfGUEuCg8BDa9XrOK16I+7L7ZCbut5tcIjiXr8wrbXAql+sI9+9ZcRNseZRvxEVHGyMcDereYn9I3sLS/1x3tSWwxJ8/HgvopRxseYKd7SOhXaUCPlZ7B/+nV+BzZ3fkvtH9w3wvWkgOxzyeq/mTTC0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyPBK8u8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyPBK8u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647931F000C4;
	Mon, 19 Oct 2026 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418368;
	bh=rMXuUkx7GYbCKLLF+yXIXy6tQcY24ixbQww77LpLt8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyPBK8u80WaGlrmXoaR4m6iZmUSAstYEekTbyqD5AGQ3QDzLmi1QH0zSFjN95grV5
	 zgJofTrSGx2HMcb2XM15dssiYy5hH3/6uYueYkCvK8E2aCB2ZToSwHgJfXZbEg3gL8
	 fSrHuaoEpNBpizO6vowVEuPBkQSyxjLU5zCxqtTBknk8IoA4qj/ZVf1KgWQ8O4Ajrj
	 5S9zBGiH98idh+/ySvbhFZN1h6OYq+CX876ixyyc7//5BrbRhe4uV/c5UpU4iuS/1R
	 u6xadD1pwJc13xOOrL1XWdUc6ssmXrjMZ8Yi4bNTB67Rtil4WC9s+wL8t5+Bd5Qm9b
	 mZbGeVSEI9elQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Mon, 19 Oct 2026 09:48:09 -0400
Message-ID: <20261019135441.1420968-198-sashal@kernel.org>
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

[ Upstream commit 86c84cc760080929b7be44bceebe5854957b99da ]

FSCTL_SET_SPARSE without an input buffer sets a file sparse.  Treat a
zero-length input buffer as SetSparse=true and keep rejecting truncated
non-empty buffers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The candidate is
mainline `86c84cc76008` (“ksmbd: allow FSCTL_SET_SPARSE without input
buffer”). It is **not** in this checkout; the overly strict length check
**is**.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ksmbd] [allow] [accept FSCTL_SET_SPARSE with a zero-length
input buffer]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (author and,
  on GitHub, committer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:,
  Link:, or Cc: stable
- Absence of Fixes/Cc: stable is expected for this review pipeline and
  is **not** a negative signal
- Ignore any “[Upstream commit …]” / “Signed-off-by: Sasha Levin”
  markers if present in candidate prep

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** MS-FSCC FSCTL_SET_SPARSE with no data element must set the
  sparse flag (SetSparse=TRUE). ksmbd currently rejects InputCount==0.
- **Symptom:** Client gets an invalid-parameter style failure (`-EINVAL`
  from this path) instead of marking the file sparse.
- **Root cause (from message + code):** A length check requires
  `in_buf_len >= sizeof(struct file_sparse)` (1 byte), so a spec-legal
  empty buffer is treated as truncated.
- **Version info in the message:** none
- **Failure mode:** interoperability / protocol reject, not a kernel
  oops

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised cleanup.** Subject says “allow”, but this
restores documented protocol behavior that the 2021 ioctl validation
made too strict. It is a spec-compliance bug fix, not a new API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `fs/smb/server/smb2pdu.c` only (**+8 / −2** upstream)
- **Function:** `smb2_ioctl()`, `case FSCTL_SET_SPARSE:`
- **Scope:** single-file surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `if (in_buf_len < sizeof(struct file_sparse)) return
  -EINVAL;` then pass `buffer` to `fsctl_set_sparse()`.
- **After:** reject only **non-empty truncated** buffers; if `in_buf_len
  == 0`, pass a stack `file_sparse` with SetSparse=1; otherwise keep
  using the request buffer.
- **Path:** ioctl handling for one FSCTL; not init, not an error-path
  leak fix.

Verified current 6.12 code (exact pre-image of the patch):

```8496:8505:fs/smb/server/smb2pdu.c
        case FSCTL_SET_SPARSE:
                if (in_buf_len < sizeof(struct file_sparse)) {
                        ret = -EINVAL;
                        goto out;
                }

                ret = fsctl_set_sparse(work, id, (struct file_sparse
*)buffer);
                if (ret < 0)
                        goto out;
                break;
```

`struct file_sparse` is a packed 1-byte `SetSparse` field
(`fs/smb/server/smb2pdu.h`). `in_buf_len` is
`le32_to_cpu(req->InputCount)` (`unsigned int`). For a 1-byte struct,
`in_buf_len && in_buf_len < 1` is never true; the real behavioral change
is **InputCount == 0**.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** logic / protocol correctness (over-strict length check)
- **Mechanism:** 2021 validation blocked the documented empty-buffer
  form to avoid reading `SetSparse` from a zero-length buffer. The fix
  keeps that OOB protection (does not dereference `buffer` when
  `in_buf_len == 0`) and supplies SetSparse=true locally.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct** vs MS-FSCC 2.3.83 and vs Samba `vfswrap_fsctl()`
  (`set_sparse = true` unless `in_len >= 1 && in_data[0] == 0`).
- **Minimal.** No unrelated edits.
- **Regression risk low:** existing 1-byte path unchanged; share/handle
  checks in `fsctl_set_sparse()` still apply
  (`KSMBD_TREE_CONN_FLAG_WRITABLE` and
  `FILE_WRITE_DATA|FILE_WRITE_ATTRIBUTES`, already in this tree via
  `c5ab11263e3c8`).
- `*(u8 *)&sparse = 1` is equivalent to `sparse.SetSparse = 1` for this
  struct.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `case FSCTL_SET_SPARSE:` from `e2f34481b24d` (“cifsd: add server-side
  procedures for SMB3”, 2021) — **in this tree**
- Length check from `f7db8fd03a4bc5` (“ksmbd: add validation in
  smb2_ioctl”, 2021-10-13) — **in this tree**
- Buffer base from `c6cd2e8d2d9aa7` (InputOffset, not `&req->Buffer[0]`)
- Bug has been present for the entire 6.12 lifetime (introduced 2021)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Introducer of the too-strict check is
`f7db8fd03a4bc5`, present here.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same-day mainline series around sparse (2026-07-08), including:
  - `159e727f763d` persist FSCTL_SET_SPARSE state
  - `31169f41778a` reject FSCTL_SET_SPARSE on directories
  - `86c84cc76008` **this** empty-buffer change
- Those other patches change advertisement/persistence and directory
  rejection. **This hunk does not use those new structures.**
- Recent 6.12 ksmbd work on `smb2pdu.c` is unrelated (compound/query-
  info, leases, etc.).
- **Standalone** for backport of the empty-buffer check.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namjae Jeon is the **ksmbd maintainer**. Many ksmbd fixes in
this tree are his. That is a strong quality signal, not a substitute for
importance.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs existing `fsctl_set_sparse()`, `struct file_sparse`, and
  `in_buf_len` — all present.
- Does **not** require persist-xattr or directory-reject commits.
- `git merge-base --is-ancestor 86c84cc76008 HEAD` → **not an ancestor**
  (candidate not in this tree).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 86c84cc76008` (and `-a`/`-w`): lore.kernel.org returned an
  error; **no thread matched**
- Direct lore fetch: **403 / Anubis bot wall**
- GitHub commit: https://github.com/torvalds/linux/commit/86c84cc7600809
  29b7be44bceebe5854957b99da (2026-07-08 / committed 2026-08-17)
- **UNVERIFIED:** reviewer comments, v2/v3, NAKs, in-thread Cc: stable

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Message has only the author’s SOB. Maintainer self-applied.
**UNVERIFIED** original To/Cc list (`b4 -w` failed).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by/Link. Bug is specified by protocol, not a syzbot
crash.

Verified spec (MS-FSCC 2.3.83): *“The message either has no data
elements at all or it contains a FILE_SET_SPARSE_BUFFER element. If
there is no data element, the sparse flag for the file is set, exactly
as if … SetSparse value of TRUE.”*

Win32 `FSCTL_SET_SPARSE`: *“If the lpInBuffer parameter is NULL, the
operation will behave the same as if … SetSparse … were TRUE.”*

Samba `vfs_default.c`: empty/`in_len==0` → `file_set_sparse(..., true)`.
smbtorture includes `test_ioctl_sparse_set_nobuf`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-day sparse series exists; this patch is the empty-buffer
piece and is **self-contained**. Later `smb2pdu.c` mainline commits
(Aug–Sep 2026) do not revert or retune this hunk.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** (lore/stable search blocked). No evidence this
was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `smb2_ioctl()` (modified); `fsctl_set_sparse()` (callee,
unchanged by this patch).

**Step 5.2: TRACE CALLERS**
Record:
- `smb2_ioctl` registered as `[SMB2_IOCTL_HE].proc` in
  `fs/smb/server/smb2ops.c`
- Reachable from authenticated SMB2 IOCTL over the network
  (`CONFIG_SMB_SERVER`)
- Not interrupt context; request path from ksmbd workers

**Step 5.3: TRACE CALLEES**
Record: `fsctl_set_sparse()` looks up the handle, checks writability,
sets/clears `FILE_ATTRIBUTE_SPARSE_FILE_LE`, optionally writes DOS
xattr, `ksmbd_fd_put()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: SMB client → SMB2 IOCTL → `smb2_ioctl` → FSCTL_SET_SPARSE.
**Yes, userspace/network reachable.** Linux CIFS client currently sends
a 1-byte buffer (`smb2_set_sparse` → `SMB2_ioctl(..., &setsparse, 1,
...)`), so Linux-to-ksmbd already works. Windows `DeviceIoControl` with
NULL buffer and Samba torture `*_nobuf` hit the broken path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other FSCTLs in the same switch still require a non-empty input
struct (`SET_ZERO_DATA`, copychunk, duplicate extents). Only SET_SPARSE
is specified as valid with no data element. No sibling copy-paste of
this empty-buffer rule in 6.12 ksmbd.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes**, `fs/smb/server/smb2pdu.c` `smb2_ioctl()`
FSCTL_SET_SPARSE case, lines 8496–8505. Introduced 2021
(`f7db8fd03a4bc5`). Local version **6.12.111**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Pre-image matches exactly (line numbers ~8496 vs mainline
~9470). **Expected clean apply** with only context offset. No struct/API
mismatch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record:
- Permission checks: **yes** (`c5ab11263e3c8`)
- Empty-buffer handling: **no**
- Persist/advertise sparse overhaul (`159e727f763d`) and directory
  reject (`31169f41778a`): **not in this tree**, and **not required**
  for this fix

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ksmbd** (`fs/smb/server/`, `CONFIG_SMB_SERVER`). **IMPORTANT**
for SMB server deployments (Windows/macOS clients), not core mm/VFS. Not
staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively patched in 6.12.y (leases, query-info, durable
reconnect, SET_SPARSE permission). Mature server with ongoing protocol-
correctness backports.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver/config-specific:** ksmbd (`CONFIG_SMB_SERVER`) users
whose clients send FSCTL_SET_SPARSE with InputCount=0 (Windows NULL
`lpInBuffer`, Samba torture nobuf). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: SMB2 IOCTL FSCTL_SET_SPARSE with zero InputCount
- Common for **Windows** documented API; **not** the Linux CIFS client
  path (sends 1 byte)
- Authenticated client with a writable handle (existing checks)
- Not a race

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- **Failure:** request rejected; file not marked sparse
- **Not** oops, UAF, deadlock, or silent data corruption
- **Severity: MEDIUM** — user-visible protocol break for a documented,
  commonly used FSCTL

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Windows/spec clients can set sparse the way MS-FSCC and
  Samba already do; smbtorture nobuf can pass
- **Risk:** very low (≈10-line ioctl case, no locking/API change, still
  go through `fsctl_set_sparse()`)
- **Ratio:** favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real protocol bug: empty SET_SPARSE must set sparse (MS-FSCC + Win32 +
  Samba)
- Buggy length check has been in this tree since 2021
- Small, obviously correct; does not reintroduce the OOB the 2021
  validation prevented
- Applies cleanly; no missing helpers
- ksmbd maintainer authored it
- Same class of ksmbd protocol-correctness fixes already land in 6.12.y
- Existing permission checks still gate the operation

**AGAINST:**
- Not a crash, UAF, leak, or CVE-class issue
- No user report / Tested-by / lore review recovered
- Same-day mainline series also changes sparse persistence/advertising;
  this patch is the least dependent piece of that work
- Linux CIFS client already sends a 1-byte buffer
- On 6.12, `smb2_get_dos_mode()` still ORs SPARSE onto every regular
  file when `share_fake_fscaps` has `FILE_SUPPORTS_SPARSE_FILES`, which
  can mask some client need to SET_SPARSE

**UNRESOLVED:**
- Mailing-list review, stable nomination, and whether a newer revision
  existed (`b4`/lore blocked)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches MS-FSCC/Samba;
   maintainer-authored. No independent Tested-by (typical for this
   size).
2. Fixes a real bug that affects users? **PASS** — spec-legal
   Windows/Samba requests fail on ksmbd.
3. Important issue? **PASS** (medium) — interoperability failure on a
   documented FSCTL, which stable-kernel-rules.rst here also covers as
   an “oh, that’s not good” user-visible bug; not a kernel panic.
4. Small and contained? **PASS** — one case in one file, +8/−2.
5. No new features or APIs? **PASS** — does not add a userspace API;
   restores required SMB behavior.
6. Can apply to the local tree? **PASS** — pre-image present, would
   apply with line-number offset only.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
normal small protocol bugfix.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to **this** 6.12.111 tree. The code the patch
fixes is here, the change is surgical, and rejecting empty
FSCTL_SET_SPARSE is a real Windows/Samba interoperability bug, not a new
feature and not blocked by the later persist-sparse series.

What it solves for stable users: ksmbd no longer returns invalid
parameter when a client sends the documented empty SET_SPARSE request;
the file is marked sparse via the existing `fsctl_set_sparse()` path.

Risk vs benefit: very low risk, clear spec-backed benefit. No extra
commits are required for the empty-buffer path to work here.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed message/tags: only Namjae Jeon SOB; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +8/−2 in `smb2_ioctl` FSCTL_SET_SPARSE; empty buffer →
  stack SetSparse=1; non-empty path unchanged
- [Phase 2] Confirmed `struct file_sparse` is one packed `__u8`;
  `in_buf_len` is `unsigned int` from `InputCount`
- [Phase 2] Confirmed `fsctl_set_sparse()` already has share/handle
  write checks in this tree (`c5ab11263e3c8`)
- [Phase 3] `git describe HEAD` / Makefile: 6.12.111
  (`p-6.12-3-gc504cf0baa3d8`)
- [Phase 3] `git blame`: length check from `f7db8fd03a4bc5` (2021); case
  from `e2f34481b24d`; both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 86c84cc76008 HEAD` → not in
  this tree
- [Phase 3] Related mainline series (`159e727f763d`, `31169f41778a`) not
  required; this hunk is independent
- [Phase 4] `b4 dig -c/-a/-w 86c84cc76008`: lore error, no thread —
  UNVERIFIED review
- [Phase 4] GitHub: commit `86c84cc760080929b7be44bceebe5854957b99da`
  matches the candidate text
- [Phase 4] MS-FSCC 2.3.83 and Win32 FSCTL_SET_SPARSE: empty/NULL buffer
  = SetSparse TRUE
- [Phase 4] Samba `vfswrap_fsctl` FSCTL_SET_SPARSE: `in_len==0` → set
  sparse true
- [Phase 5] Caller: `smb2ops.c` SMB2_IOCTL_HE → `smb2_ioctl`; Linux
  client sends 1-byte buffer in `smb2_set_sparse()`
- [Phase 6] Local pre-image unique match at `smb2pdu.c` 8496–8505;
  expected clean apply
- [Phase 7] Subsystem ksmbd / CONFIG_SMB_SERVER, actively maintained on
  this branch
- [Phase 8] Failure: client EINVAL, severity MEDIUM; not oops/UAF
- UNVERIFIED: lore/stable discussion and any mailing-list NAKs (lore
  403)

**YES**

 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b3cf2dadeecd..f383d1e5e5cb7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8612,15 +8612,21 @@ int smb2_ioctl(struct ksmbd_work *work)
 				rsp);
 		break;
 	case FSCTL_SET_SPARSE:
-		if (in_buf_len < sizeof(struct file_sparse)) {
+	{
+		struct file_sparse sparse = {0};
+
+		if (in_buf_len && in_buf_len < sizeof(struct file_sparse)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = fsctl_set_sparse(work, id, (struct file_sparse *)buffer);
+		*(u8 *)&sparse = 1;
+		ret = fsctl_set_sparse(work, id, in_buf_len ?
+				       (struct file_sparse *)buffer : &sparse);
 		if (ret < 0)
 			goto out;
 		break;
+	}
 	case FSCTL_SET_ZERO_DATA:
 	{
 		struct file_zero_data_information *zero_data;
-- 
2.53.0

