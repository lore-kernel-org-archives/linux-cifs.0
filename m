Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00B55265A1;
	Mon, 19 Oct 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418156; cv=none; b=rXjqlI8NCiedwMO1Vdd3uCj8iaInq4PGgTrJ1ZuTf3p/Vo9M+mlXHb9tI65GGwX62ZjwcojfQ8v5GOugQYRnuS0dTHcUnbjyTTLhc7G2UXK9EEWCrZvpMUjhKTe5dyxAkfGnMmbhsyKFGwKA5i+J+B/d7624cinPsOJF7ReerIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418156; c=relaxed/simple;
	bh=NUzz42/l/JNvh+aKl8Zudn1jS2p3hLZsgKoC7V6+ag4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BmkLLesb6qlbV5FrhYyDAyrMy4wEtrmCmoQTdeHVXb90S4YbP0lenPZsnp92ACaBecHAqG3vHuofAt2NEqecvQo0bjVFj+bXhUSpViy5o6452thVuVYweOc3WthZXFHQRnHa6JpYY5HrLyNDJFRcyldL0ePVpXIBnfYOZMsc4xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjDKKG2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjDKKG2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D328B1F000C7;
	Mon, 19 Oct 2026 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418153;
	bh=QGfTKxqXLTODBipg9RV5zTAAjhUlDhSEXdbND3UDPm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjDKKG2bqHBAzwV4H6yJDDYl7LQpHMVrT8wsOogxENTvlSWBfYNQqvMwWZboDd1/4
	 MsE3ifFDZg+xzeOXN8gp9egl6/PaIZ0an03OW+ggcnz+O3NQVcGart5eZ8MN/ik2on
	 QEhwcW3eJpp7jHjUac1OfkR6u9fFL758KLvwqqcGrvrynRENnLgqZUmZaa5eU5kCwQ
	 9umcd6Nvph/FKQ8mw6RZN568OOonc9ZliMsYthagrWI+sreYhUdWI4yh+LEmSng1Mq
	 yqa7/yqRBHzLh3PIoX0RTGzI4M/EOdSzsGhtAZ+vz/1N7nlSKhKGVdLAecRnF1d14O
	 /6EClBSAG6mCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
Date: Mon, 19 Oct 2026 09:45:41 -0400
Message-ID: <20261019135441.1420968-50-sashal@kernel.org>
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

[ Upstream commit d68d4b3293034f549d55f407a23b4c0a6c90e50a ]

The FSCTL_COPYCHUNK/FSCTL_COPYCHUNK_WRITE input length check uses
in_buf_len <= sizeof(struct copychunk_ioctl_req), which rejects a
buffer that is exactly sizeof(struct copychunk_ioctl_req) bytes -- the
minimal, valid request containing only the fixed header with
ChunkCount=0 and no chunk entries, used by clients to query the
server's copy limits before issuing a real copychunk.

Since copychunk_ioctl_req ends in a flexible array member, the correct
minimum is that the buffer covers the fixed header, so use
offsetof(..., Chunks) with '<' instead of '<=' against sizeof(): same
value, but the boundary case is now correctly accepted.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this as a one-line protocol check against the
6.12 tree: the buggy `<= sizeof` test is present, the handler already
implements ChunkCount=0, and the patch applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ksmbd]** **[fix]** off-by-one that rejects a minimal
COPYCHUNK query-limits request (ChunkCount=0, header-only).

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Gael Blivet `<gael.blivet@gmail.com>` (author)
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd
  maintainer)
- **Assisted-by:** Claude:claude-sonnet-5
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link:** in the
  committed message
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB (none in the
  provided message)

Notable: maintainer SOB is a quality signal. No syzbot/KASAN tags.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `in_buf_len <= sizeof(struct copychunk_ioctl_req)` rejects a
  buffer that is **exactly** the fixed header size.
- **Symptom:** clients sending FSCTL_COPYCHUNK / FSCTL_COPYCHUNK_WRITE
  with ChunkCount=0 and no chunk entries (the standard “query server
  copy limits” request) get `-EINVAL` / `STATUS_INVALID_PARAMETER`.
- **Root cause:** the struct ends in a flexible array; the minimum valid
  length is the fixed header. `sizeof` and `offsetof(..., Chunks)` are
  the same numeric value (32); the real change is `<=` → `<` so equality
  is accepted.
- **Version info:** none in the message. The FAM conversion that made
  `sizeof` equal the header size is in this tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject/body explicitly describe a protocol off-
by-one. Not cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `fs/smb/server/smb2pdu.c` — 1 line changed (`<= sizeof(...)`
  → `< offsetof(..., Chunks)`).
- **Function:** `smb2_ioctl()` (`FSCTL_SRV_COPYCHUNK` /
  `FSCTL_SRV_COPYCHUNK_WRITE` cases).
- **Scope:** single-file surgical fix, ~1 line.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** reject when `in_buf_len <= 32` → a valid 32-byte header-
  only request is rejected; `goto out` with `ret = -EINVAL` **before**
  `nbytes` is set, so the client gets an error response **without** the
  copychunk limits body.
- **After:** reject only when `in_buf_len < 32` → 32-byte request
  proceeds into `fsctl_copychunk()`.
- **Path:** ioctl input-length check (not a crash path). Downstream
  `fsctl_copychunk()` already does `if (chunk_count == 0) goto out;`
  after filling max chunk count/size/total in the response.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** logic / correctness (off-by-one bounds check), protocol
  interoperability.
- **Mechanism:** `<=` vs `<` on a FAM struct whose `sizeof` is the
  header size. Valid minimum request was treated as too small.
- **Not:** UAF, leak, race, overflow, deadlock.

Verified safety after the change: if a 32-byte buffer lies with
ChunkCount ≠ 0, `fsctl_copychunk()` still rejects via `input_count <
struct_size(ci_req, Chunks, chunk_count)` before touching `Chunks[]`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct.** `offsetof` on a FAM is the idiomatic minimum;
  verified `sizeof == offsetof == 32` with a packed layout compile.
- **Minimal.** No unrelated changes, no API/struct changes.
- **Regression risk: very low.** Only newly accepted case is `in_buf_len
  == 32`, which is the documented header-only request. Inner
  ChunkCount=0 path already exists in this tree.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Current check is from **8bb04fb2b7e34** (“ksmbd: Replace one-element
  arrays with flexible-array members”, Thorsten Blum, 2024-08-20; in
  v6.12).
- That commit changed `< sizeof` to `<= sizeof` when converting `__u8
  Chunks[1]` (sizeof **33**) to a FAM (sizeof **32**), preserving “need
  33+ bytes” and thus still rejecting the 32-byte query.
- Original ioctl length check: **f7db8fd03a4bc5** (“ksmbd: add
  validation in smb2_ioctl”, 2021-10-08), `in_buf_len < sizeof` with the
  1-byte dummy array — also rejected 32-byte requests.
- **Bug has been present since ioctl validation was added (5.16-era
  ksmbd), still present in this 6.12 tree.**

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Buggy behavior traces to f7db8fd / 8bb04fb as
above. Both are ancestors of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- **0801c1374ab15** — `__counted_by_le` on `copychunk_ioctl_req` (in
  this tree); inner `struct_size` check is already correct.
- **8a84ffa455462** — moved copychunk structs to
  `fs/smb/common/smb2pdu.h` (in this tree).
- No other local commit already applies this `<=` → `< offsetof` change
  (`git log --grep` on the path found nothing).
- **Standalone.** Cover letter: “These 7 fixes are independent of each
  other.”

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Author Gael Blivet has **no** prior commits in this tree’s `fs/smb/`.
- Series: macOS/Time Machine work; this patch is explicitly **not**
  Apple-specific.
- **Namjae Jeon** (maintainer) applied the series (except patch 7,
  replaced by other ADS copychunk commits).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs FAM `Chunks[]` so `offsetof(..., Chunks)` is valid — **present**
  (8bb04fb).
- Does **not** need later AAPL full-file-copy (`529d203daa00b`, not in
  this tree). In 6.12, ChunkCount=0 already means “return limits and
  succeed.”
- **Can apply standalone.** `git apply --check` succeeded at offset −857
  lines.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig -c fdf17b206bdc8:** match at
  https://patch.msgid.link/20260707100033.47512-2-g.blivet@me.com
- **b4 dig -a:** only **v1**; committed version is that v1 (plus later
  Assisted-by in the git message).
- Cover: `[PATCH 0/7] ksmbd: assorted fixes found while adding
  macOS/Time Machine support` (2026-07-07).
- Author: independent of Apple-specific behavior; this one “affects any
  client probing server copy limits with a minimal FSCTL_SRV_COPYCHUNK
  request (ChunkCount=0).” Found and verified in live Time
  Machine/Finder testing.
- **Namjae Jeon (2026-07-08):** “Applied them to #ksmbd-for-next-next
  except 0007 patch.” **No NAK.** No reviewer asked for Cc: stable.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (**b4 dig -w**): To/Cc were Gaël Blivet-Bailly, **Namjae Jeon**,
**linux-cifs@vger.kernel.org**. Maintainer was the recipient and applied
it. No other Named Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: no bugzilla/syzbot. Evidence is live macOS Finder/Time Machine
testing described in the cover letter. Linux CIFS client
(`__smb2_copychunk_range`) does **not** send ChunkCount=0; it sends real
chunks and learns limits from `STATUS_INVALID_PARAMETER` + response
body. This bug hits clients that probe with a header-only request (macOS
Finder, and any similar SMB2 client).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 7 independent patches. This is 1/7. Patch 7 (ADS copychunk) was
**not** taken; maintainer used other commits. Later AAPL ChunkCount=0
full-file copy is a **feature**, not required here.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search did not turn up discussion of this
specific fix (WebSearch results were unrelated). No evidence it was
previously rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `smb2_ioctl()` (length check). Downstream: `fsctl_copychunk()`.

**Step 5.2: TRACE CALLERS**
Record: `smb2_ioctl` is `SMB2_IOCTL_HE` in `fs/smb/server/smb2ops.c`.
Reachable from authenticated SMB2/SMB3 clients over the network (not a
local syscall). Interrupt/hot-path: no; file-server request path.

**Step 5.3: TRACE CALLEES**
Record: on success, `fsctl_copychunk()` fills `copychunk_ioctl_rsp` with
`ksmbd_server_side_copy_max_{chunk_count,chunk_size,total_size}()` (256
chunks, ~2GiB), then if ChunkCount==0 returns 0 without copy I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: SMB client → SMB2 IOCTL → `smb2_ioctl` → (currently rejected) /
(after fix) `fsctl_copychunk`. **Reachable from userspace/network** with
a writable share. Unprivileged local users cannot hit it unless they are
SMB clients of ksmbd.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: same FAM conversion also used `<= sizeof` for `smb2_ea_info_req`
(line 4779). That is a **different** request and not this patch. Other
ioctl checks already use `in_buf_len < sizeof` or `offsetof`
(validate_negotiate, sparse, zero-data, etc.).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Local tree is **6.12.111** (`pending-6.12`, `git
describe` p-6.12-3-gc504cf0baa3d8). Buggy check is at
`fs/smb/server/smb2pdu.c:8475`. Inner ChunkCount=0 limits path is at
7925–7934. Candidate commit **fdf17b206bdc8 is not** an ancestor of
HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** with line-number offset (`git apply --check`:
hunk succeeded at 8472). Context around the COPYCHUNK cases matches. No
conflicting local refactor of this check.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: **No.** `git log --grep='off-by-one rejecting minimal
COPYCHUNK'` on `fs/smb/server/` is empty. No alternate fix of this
comparison.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ksmbd** (`fs/smb/server/`), in-kernel SMB3 server.
**IMPORTANT** (not core mm/VFS; not staging). `CONFIG_SMB_SERVER`.
Network-facing; protocol mistakes affect all clients of that server.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: **Active.** Recent 6.12.y ksmbd work is mostly
protocol/security/response-size fixes. Mature enough that this ioctl
check dates to 2021; still getting interoperability fixes.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Config-specific + client-specific:** ksmbd servers whose
clients send a 32-byte COPYCHUNK query-limits request. Linux CIFS does
not. macOS Finder does (author’s live testing). Any other SMB2 client
using that probe is affected.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Authenticated client, writable share,
FSCTL_SRV_COPYCHUNK(_WRITE) with InputCount=32 and ChunkCount=0.
**Common for macOS file copy / Time Machine-style copychunk probing.**
Not a race. Not triggerable by a random unprivileged local process
unless it is an SMB client.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- **Failure:** `STATUS_INVALID_PARAMETER` and **no** limits payload
  (`smb2_set_err_rsp` after `-EINVAL` with nbytes still 0).
- Server-side copy probe fails; clients that require this query cannot
  offload copy (fail or fall back to read/write).
- **Not** a panic, UAF, deadlock, or corruption.
- **Severity: MEDIUM** (functional/interop), important for
  ksmbd+macOS/Finder, not a kernel crash.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: medium-high for ksmbd users** — restores a path the inner
  handler already implements; 1-line; live-tested against real clients.
- **Risk: very low** — equality case only; ChunkCount≠0 still size-
  checked; no locking/API change.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real protocol bug: valid header-only COPYCHUNK is rejected; inner
  handler already supports ChunkCount=0 query-limits.
- User-visible: macOS Finder/Time Machine testing; any client using that
  probe.
- 1-line, obviously correct; sizeof/offsetof verified equal to 32.
- Standalone; maintainer applied it; applies cleanly here.
- Buggy code is in 6.12; candidate is not.
- Downstream access of `Chunks[]` remains guarded.

**AGAINST:**
- Not a crash/security/corruption/deadlock.
- Linux CIFS does not use this probe (Windows often uses oversized-chunk
  + EINVAL).
- Full Time Machine still needs later AAPL work not in 6.12 — but Finder
  copychunk probing does not.
- No Fixes:/Cc: stable (expected; not a negative).

**UNRESOLVED:**
- Exact share of Windows versions that send ChunkCount=0 was not
  verified against MS-SMB2 traces (author’s claim is “any client” using
  that probe; macOS was live-tested).
- lore.kernel.org HTTP fetch returned 403; discussion recovered via `b4
  dig -m`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line; maintainer applied;
   live Finder/TM testing.
2. Fixes a real bug that affects users? **PASS** — valid SMB2 request
   rejected.
3. Important issue? **PASS** — interoperability for server-side copy
   (MEDIUM, not panic). For ksmbd this is a real service bug, not
   cosmetic.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS** — enables an already-implemented
   handler path.
6. Can apply to the local tree? **PASS** — `git apply --check` clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a surgical protocol off-by-one in ksmbd’s COPYCHUNK ioctl check.
The 6.12 tree still has `in_buf_len <= sizeof(...)`, which rejects the
32-byte query-limits request that `fsctl_copychunk()` already handles.
Benefit is real for ksmbd users with clients that probe that way; risk
is negligible. It meets stable rules for this tree.

### What the commit solves and why it matters here
ksmbd currently turns a spec-valid FSCTL_COPYCHUNK with only the 32-byte
header (ChunkCount=0) into `STATUS_INVALID_PARAMETER` and drops the
limits body. After the fix, that request reaches the existing
ChunkCount=0 path and returns max chunk count/size/total. That is
required for server-side copy probing used by macOS Finder (and similar
clients). On **this** 6.12 tree the bug is present and the later AAPL
full-file-copy feature is not required.

### Risk vs benefit
Benefit: restore working COPYCHUNK limit queries. Risk: one comparison
change; non-zero ChunkCount still validated with `struct_size`. Applies
with a line offset only.

Verification:
- [Phase 1] Parsed tags: SOB Gael Blivet + Namjae Jeon; Assisted-by
  Claude; no Fixes/Cc stable/Reported-by
- [Phase 2] Diff: 1 line in `smb2_ioctl` COPYCHUNK cases; `<= sizeof` →
  `< offsetof(..., Chunks)`
- [Phase 2] Compile check: packed `sizeof=32` and `offsetof(Chunks)=32`
- [Phase 2] Read `fsctl_copychunk`: ChunkCount==0 already fills limits
  and returns 0; non-zero uses `struct_size` before `Chunks[]`
- [Phase 2] Read `smb2_ioctl` `out:`: `-EINVAL` →
  `STATUS_INVALID_PARAMETER` via `smb2_set_err_rsp` (no limits body)
- [Phase 3] `git blame`: check from 8bb04fb2b7e34 (FAM); originally
  f7db8fd03a4bc5
- [Phase 3] `git merge-base --is-ancestor` 8bb04fb, f7db8fd, 0801c137:
  all in HEAD; fdf17b206bdc8 not in HEAD
- [Phase 3] `git log --grep='off-by-one rejecting minimal COPYCHUNK' --
  fs/smb/server/`: empty
- [Phase 4] `b4 dig -c fdf17b206bdc8`: lore match
  20260707100033.47512-2; cover 0/7; Namjae applied except 0007
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: maintainer + linux-cifs
- [Phase 4] Cover letter: independent of Apple-specific patches; live
  TM/Finder testing
- [Phase 4] stable@ lore search: no hit for this subject
- [Phase 5] Caller: `smb2ops.c` SMB2_IOCTL_HE → `smb2_ioctl`; network
  SMB path
- [Phase 5] Linux client `__smb2_copychunk_range` does not send
  ChunkCount=0
- [Phase 6] `git describe HEAD`: p-6.12-3-gc504cf0baa3d8; `make
  kernelversion`: 6.12.111
- [Phase 6] Buggy line at smb2pdu.c:8475; `git apply --check` succeeded
  at 8472
- [Phase 8] Failure: protocol reject of valid COPYCHUNK query, severity
  MEDIUM; not a crash
- UNVERIFIED: whether every Windows build sends ChunkCount=0 (not used
  to drive the verdict)

**YES**

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d64753124dd9a..9bb885fa1ac66 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8576,7 +8576,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len <= sizeof(struct copychunk_ioctl_req)) {
+		if (in_buf_len < offsetof(struct copychunk_ioctl_req, Chunks)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.53.0

