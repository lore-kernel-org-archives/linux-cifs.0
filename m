Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB603F65EA;
	Tue, 28 Apr 2026 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372908; cv=none; b=g8FKa1pwpVf7dp5M7rvxmPSVR5dJWvYBrVQjBxva+JRiNiUyUqQAH61UA+bvnHygi7C5ttYO3QTmAbcuLYbGxLX69PnwPcmQFkI349/+KWu5m/rudP++n2DkoI2x4MYg01DBonuPWUIZycd7pDBLG5wSVDsCDG+82xorjxBojF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372908; c=relaxed/simple;
	bh=28H3QED5diOYDEZms+DhgAqauRgZpWHVwGC8rmqcsPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JaojJfJektPyVT78PUmxhbqG+PiJi91wK8J4yxpSo47jcdZquHtJPliFRy1utdZuWHu/4icwCL55PLlf083oUizhPqseMzHCk18d/2DuK+EwQGy1MCQszKfgeqgxH2gvvfDIbRHYeG5vNv3dK2jyy2iSZZfTHxGh1EkpYyg4MCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkLrcwaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkLrcwaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67EAC2BCC9;
	Tue, 28 Apr 2026 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372907;
	bh=28H3QED5diOYDEZms+DhgAqauRgZpWHVwGC8rmqcsPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkLrcwaFaHUMZsrpVio9gqNa1dX/z40+GdkdaAbLsOBqBiCPLVgnsJRJEM7X9r94/
	 TiMVsJNnDAkqnJ7BpQe8NLMLcGvCjS5IOwhN2d5oWCBCICsQCmizJMOfr7zE5Vfmk2
	 v+2G6ajDtvEayK63BEONq9lLnPz/G+mUr51kyJEX53HoxSsQhY7yss6aPo8zr4xVXY
	 +GjmmdEo3mnpDBOFzxE00C2cTJymvheedEDWR02etljR5spBLFnSs+6PwkC8cY4otC
	 iqqm+/RHIzqrHJCmDdfAkDqlPjg2jtlwWWDaOIi/kIBuKpM8jDBduETAuhYPgY27Ku
	 /EZnYC6enGwWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ksmbd: fix CreateOptions sanitization clobbering the whole field
Date: Tue, 28 Apr 2026 06:40:21 -0400
Message-ID: <20260428104133.2858589-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 5d115fa84027e4b999c3d3c7b1294849cf35cdb2 ]

smb2_open() attempts to clear conflicting CreateOptions bits
(FILE_SEQUENTIAL_ONLY_LE together with FILE_RANDOM_ACCESS_LE, and
FILE_NO_COMPRESSION_LE on a directory open), but uses a plain
assignment of the bitwise negation of the target flag:

	req->CreateOptions = ~(FILE_SEQUENTIAL_ONLY_LE);
	req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);

This replaces the entire field with 0xFFFFFFFB / 0xFFFFFFEF rather
than clearing a single bit. With the SEQUENTIAL/RANDOM case, the
next check for FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
FILE_RESERVE_OPFILTER_LE then trivially matches and a legitimate
request is rejected with -EOPNOTSUPP. With the NO_COMPRESSION case,
every downstream test (FILE_DELETE_ON_CLOSE, etc.) operates on a
corrupted CreateOptions value.

Use &= ~FLAG to clear only the intended bit in both places.

Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed to complete the full analysis.

## Phase 1: Commit Message Forensics

**Step 1.1: Subject line parsing**
- Record: Subsystem prefix `ksmbd:` (kernel SMB3 server), action verb
  `fix`, one-line summary: "CreateOptions sanitization clobbering the
  whole field"

**Step 1.2: Tags**
- Signed-off-by: DaeMyung Kang (community contributor who authored the
  fix)
- **Acked-by: Namjae Jeon** (the ksmbd maintainer and original author of
  the buggy code)
- Signed-off-by: Steve French (VFS/SMB maintainer, committed the patch)
- No `Fixes:` tag (expected - this is a candidate under review)
- No `Reported-by:` / `Link:` / `Cc: stable` tags
- Record: Author + ksmbd maintainer Acked + SMB subsystem maintainer
  committed

**Step 1.3: Commit body analysis**
- Record: Author clearly explains the bug mechanism: two lines use `=`
  (assignment) instead of `&=` (bit-clear). `req->CreateOptions = ~FLAG`
  replaces the ENTIRE field with `0xFFFFFFFB` (sequential case) or
  `0xFFFF7FFF`-ish (no-compression case, message says 0xFFFFFFEF -
  slight discrepancy but point stands). Consequence 1: immediately next
  `EOPNOTSUPP` check trivially matches → legitimate client requests
  rejected. Consequence 2: every downstream test (FILE_DELETE_ON_CLOSE,
  etc.) operates on corrupted value.

**Step 1.4: Hidden bug detection**
- Record: Not hidden — commit subject explicitly says "fix".

## Phase 2: Diff Analysis

**Step 2.1: Inventory**
- Record: 1 file changed (`fs/smb/server/smb2pdu.c`), +2/-2 lines, 1
  function touched (`smb2_open()`), single-file surgical fix.

**Step 2.2: Code flow change**
- Record:
  - Hunk 1 (line ~3064): Before: `req->CreateOptions =
    ~(FILE_SEQUENTIAL_ONLY_LE);` writes `0xFFFFFFFB` to the field.
    After: `req->CreateOptions &= ~FILE_SEQUENTIAL_ONLY_LE;` clears only
    bit 0x00000004.
  - Hunk 2 (line ~3078, inside DIRECTORY_FILE branch): Before:
    `req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);` writes ~`0x8000`
    into the field. After: `req->CreateOptions &=
    ~FILE_NO_COMPRESSION_LE;` clears only bit 0x00008000.

**Step 2.3: Bug mechanism**
- Record: Category (g) "Logic / correctness fix" — classic missing `&`
  in `&=`, making assignment clobber the field. Two independent sites,
  same root cause.

**Step 2.4: Fix quality**
- Record: Obviously correct, minimal and idiomatic (`&= ~FLAG` is the
  standard kernel pattern). Zero regression risk — the fix makes the
  code do exactly what the surrounding check clearly intends. In both
  sites the value was already mangled post-change by the buggy line;
  restoring correct semantics cannot introduce a new failure mode.

## Phase 3: Git History Investigation

**Step 3.1: Blame**
- Record: `git blame -L 3055,3075 fs/smb/server/smb2pdu.c` shows both
  buggy lines come from commit `e2f34481b24db2` ("cifsd: add server-side
  procedures for SMB3", Namjae Jeon, 2021) — the very first commit that
  added ksmbd to the kernel. `git describe --contains e2f34481b24db2`
  returns `v5.15-rc1~183^2~93` → present since **v5.15-rc1**.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag in the commit, but blame unambiguously
  identifies the introducing commit. That commit (ksmbd initial merge)
  is present in every ksmbd-capable stable tree (5.15.y and later).

**Step 3.3: Related file changes**
- Record: `git log --oneline -- fs/smb/server/smb2pdu.c | head -30`
  shows a steady stream of ksmbd CVE / bug fixes (UAF, OOB, refcount
  leaks) in the file — an actively maintained, churn-prone area. No
  prerequisite commit is implied by the diff hunks.

**Step 3.4: Author's other commits**
- Record: `git log --author="DaeMyung Kang"` shows 4 related ksmbd fixes
  (durable fd leak, async_ida destroy, tree_conn_ida destroy, and this
  one). Regular ksmbd contributor, not a one-off submitter.

**Step 3.5: Dependencies**
- Record: Patch is `[PATCH 2/2]` of a series. Patch 1/2
  (`804054d19886a`, durable fd leak) touches
  `parse_durable_handle_context()` at line ~2844, completely independent
  from this patch's changes at lines ~3064/3078. `git show
  804054d19886a` confirms zero textual/semantic overlap → **this patch
  is fully standalone**, no dependency on 1/2.

## Phase 4: Mailing List Research

**Step 4.1: b4 dig**
- Record: `b4 dig -c 5d115fa84027e` found match by patch-id at https://l
  ore.kernel.org/all/20260420175125.3341090-1-charsyam@gmail.com/

**Step 4.2: Reviewers (b4 dig -w)**
- Record: Originally sent to ksmbd maintainer Namjae Jeon, Steve French
  (SMB maintainer), Sergey Senozhatsky, Tom Talpey, linux-cifs, LKML.
  The right audience was included.

**Step 4.3: Revisions (b4 dig -a)**
- Record: Only v1, no rework needed — the fix was straightforward enough
  to be accepted on first submission.

**Step 4.4: Thread content**
- Record: `b4 dig -m /tmp/ksmbd_createopts_thread.mbox` retrieved the
  full thread. The only reply is from Namjae Jeon: *"Applied it to
  #ksmbd-for-next-next. Note that I have added the missing signed-off-by
  tag..."* — no NAKs, no concerns, no revision requests, no explicit
  stable nomination, but unambiguous maintainer approval.

**Step 4.5: Stable ML**
- Record: No prior stable mailing-list discussion found; the bug has
  been latent since v5.15 but only now diagnosed.

## Phase 5: Code Semantic Analysis

**Step 5.1: Key functions**
- Record: `smb2_open()` in `fs/smb/server/smb2pdu.c`

**Step 5.2: Callers**
- Record: `fs/smb/server/smb2ops.c:181` registers `smb2_open` as the
  handler for `SMB2_CREATE_HE` in the `smb2_0_server_cmds[]` dispatch
  table. This means **every SMB2 CREATE request** (file/directory open —
  the bread-and-butter operation of an SMB server) enters `smb2_open()`.
  The buggy code executes unconditionally whenever the client sets the
  relevant CreateOptions flags.

**Step 5.3: Callees**
- Record: Downstream, `req->CreateOptions` is tested against
  `FILE_DELETE_ON_CLOSE_LE` at lines 3159, 3216, 3240, 3317, and 3537
  (per grep). Line 3537 is especially consequential — it calls
  `ksmbd_fd_set_delete_on_close(fp, file_info)`, which marks the newly
  opened file/dir for deletion on close.

**Step 5.4: Reachability**
- Record: CreateOptions is attacker/client-controlled and reaches
  `smb2_open()` from an authenticated SMB session (or guest, depending
  on server config). Both trigger paths are reachable from any connected
  SMB client — trivially triggerable by sending a crafted SMB2 CREATE
  request.

**Step 5.5: Similar patterns**
- Record: Only these two sites in ksmbd use `req->CreateOptions =
  ~FLAG`; no other copies of this pattern exist in the tree (confirmed
  by reading the surrounding hunk — the rest of the file uses
  `&=`/`|=`/masking correctly).

## Phase 6: Stable Tree Analysis

**Step 6.1: Code existence in stable**
- Record: Verified buggy code exists verbatim in: `stable-
  push/linux-5.15.y` (at `fs/ksmbd/smb2pdu.c`), `linux-6.1.y`,
  `linux-6.6.y`, `linux-6.12.y`, `linux-6.18.y`, `linux-6.19.y` (all at
  `fs/smb/server/smb2pdu.c`). Confirmed with `git show <branch>:<path> |
  grep ~(FILE_SEQUENTIAL_ONLY_LE)`.

**Step 6.2: Backport complications**
- Record: Surrounding context lines are IDENTICAL in 6.1.y through
  6.19.y — the mainline patch applies cleanly. For 5.15.y the file was
  renamed from `fs/ksmbd/` to `fs/smb/server/` in v6.1, so the patch
  needs a trivial path rewrite but the code context is the same.

**Step 6.3: Related fixes in stable**
- Record: No prior fix of the same bug in any stable tree. The buggy
  code has been shipping since v5.15.

## Phase 7: Subsystem Context

**Step 7.1: Criticality**
- Record: `fs/smb/server/` = ksmbd = in-kernel SMB3 server. Network-
  facing, security-sensitive, used for file sharing. Classification:
  **IMPORTANT** (not quite CORE, but exposed to remote input and used in
  real deployments — many ksmbd fixes have been CVE-class in the last
  year).

**Step 7.2: Activity**
- Record: ksmbd receives frequent fixes (UAF, OOB, refcount, memory leak
  fixes in recent history — see Step 3.3). Active subsystem, fixes are
  expected to land in stable.

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who is affected**
- Record: Anyone running ksmbd (Linux as SMB file server). Bug is
  triggered purely from client-side input → every ksmbd instance is
  potentially affected.

**Step 8.2: Trigger conditions**
- Record:
  - Case 1 (SEQUENTIAL+RANDOM): client sends CREATE with both
    `FILE_SEQUENTIAL_ONLY` and `FILE_RANDOM_ACCESS` flags → server
    wrongly rejects with `-EOPNOTSUPP`. Some SMB clients/workloads do
    set both hints; the rejection is an interop bug.
  - Case 2 (DIRECTORY+NO_COMPRESSION): client issues directory open with
    `FILE_NO_COMPRESSION` → `CreateOptions` is set to
    `~FILE_NO_COMPRESSION_LE` (approximately `0xFFFF7FFF`), which has
    the `FILE_DELETE_ON_CLOSE_LE` bit set plus many other unintended
    bits. Every subsequent test in `smb2_open()` (lines 3159, 3216,
    3240, 3317, 3537) operates on wrong data. In particular line 3537
    may call `ksmbd_fd_set_delete_on_close()`, silently marking an
    opened directory for deletion when the handle closes. Triggered by
    unprivileged (authenticated) SMB client.

**Step 8.3: Failure mode severity**
- Record: Case 1 = functional/interop failure (user-visible: "can't open
  file through SMB"). Case 2 = logic corruption, potentially including
  unintended delete-on-close marking on directory opens → **potential
  data loss / unexpected state**. Combined severity: MEDIUM-HIGH. Not a
  crash, not a classic security UAF, but a real, reachable, client-
  controllable behavioral corruption bug in a file server.

**Step 8.4: Risk-benefit**
- Record: **Benefit** = fixes wrong behavior / potential data-affecting
  logic on every SMB client CREATE that sets the relevant bits, across
  every ksmbd deployment since v5.15. **Risk** = negligible: 2 lines,
  corrects `=` to `&=`, cannot regress anything (the pre-patch code
  demonstrably clobbers the field). Textbook stable candidate.

## Phase 9: Final Synthesis

**Step 9.1: Evidence summary**
- FOR: (1) Obvious typo fix — `=` → `&=`; (2) 2-line diff, zero
  regression risk; (3) Bug reachable via client-supplied CreateOptions
  in every SMB2 CREATE; (4) Both failure modes matter — one breaks
  interop, the other corrupts downstream semantics including potential
  unintended DELETE_ON_CLOSE marking; (5) Acked by ksmbd maintainer,
  committed by SMB subsystem maintainer; (6) Bug present since v5.15 —
  all active stable trees affected; (7) Patch applies cleanly to
  6.1.y–6.19.y, needs only path rename for 5.15.y.
- AGAINST: No Fixes: tag, no explicit stable nomination, no Reported-by
  (expected for a code-inspection find). None of these outweigh the
  above.
- UNVERIFIED: I did not reproduce the bug with a live ksmbd server;
  analysis is based on code reading and the commit author's explanation,
  which is consistent with the code.

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested — YES (typo fix, trivial to verify by
   reading; maintainer Ack)
2. Fixes real bug affecting users — YES (every ksmbd CREATE path)
3. Important issue — YES (client-triggerable behavioral corruption)
4. Small and contained — YES (2 lines, 1 function)
5. No new features/APIs — YES (pure bug fix)
6. Applies to stable — YES (clean in 6.1+, trivial path rename for 5.15)

**Step 9.3: Exception category**
- Record: N/A — this is a straightforward bug fix, not an exception-
  class change.

**Step 9.4: Decision**
- Clear YES. Textbook stable material: tiny, obviously correct, fixes a
  real client-reachable bug in a maintained subsystem, present in every
  active stable tree since v5.15.

## Verification
- [Phase 1] Parsed tags: DaeMyung Kang (author), Namjae Jeon (ksmbd
  maintainer, Acked), Steve French (SMB maintainer, signed-off). No
  Fixes/Reported-by/Link/Cc: stable.
- [Phase 1] Parsed body: author's description of `=` vs `&=` bug and
  downstream consequences is accurate (verified by inspecting the code).
- [Phase 2] Diff: `git show 5d115fa84027e` → 2 lines changed, both in
  `smb2_open()`, in `fs/smb/server/smb2pdu.c`.
- [Phase 2] Flag values confirmed via `fs/smb/common/smb2pdu.h`:
  `FILE_SEQUENTIAL_ONLY_LE=0x4`, `FILE_RANDOM_ACCESS_LE=0x800`,
  `FILE_NO_COMPRESSION_LE=0x8000`, `FILE_DELETE_ON_CLOSE_LE=0x1000`,
  `FILE_OPEN_BY_FILE_ID_LE=0x2000`, `FILE_DIRECTORY_FILE_LE=0x1`. Commit
  message's `0xFFFFFFEF` for the NO_COMPRESSION case is slightly off
  (actual `~0x8000` ≈ `0xFFFF7FFF`), but the core claim (entire field
  clobbered and `FILE_DELETE_ON_CLOSE_LE` wrongly set) is correct.
- [Phase 3] `git blame -L 3055,3075 fs/smb/server/smb2pdu.c` → buggy
  lines come from commit `e2f34481b24db2`.
- [Phase 3] `git describe --contains e2f34481b24db2` →
  `v5.15-rc1~183^2~93`, i.e., ksmbd initial merge in v5.15.
- [Phase 3] `git show 804054d19886a`: patch 1/2 edits
  `parse_durable_handle_context()` around line 2844, unrelated to this
  patch's edits around line 3064/3078 — confirms standalone
  applicability.
- [Phase 4] `b4 dig -c 5d115fa84027e`: matched on patch-id, lore URL htt
  ps://lore.kernel.org/all/20260420175125.3341090-1-charsyam@gmail.com/
  returned.
- [Phase 4] `b4 dig -c ... -w`: recipients include Namjae Jeon
  (maintainer), Steve French, linux-cifs, LKML.
- [Phase 4] `b4 dig -c ... -a`: only v1, no revisions.
- [Phase 4] `b4 dig -c ... -m /tmp/ksmbd_createopts_thread.mbox`: thread
  contents read — only reply from Namjae Jeon says "Applied it to
  #ksmbd-for-next-next"; no NAKs, no concerns.
- [Phase 5] `fs/smb/server/smb2ops.c:181` confirms `smb2_open` is
  dispatched for SMB2_CREATE_HE — every CREATE request path.
- [Phase 5] `grep 'CreateOptions.*FILE_DELETE_ON_CLOSE_LE'
  fs/smb/server`: 5 downstream sites at lines 3159/3216/3240/3317/3537
  depend on `CreateOptions`, and line 3537 calls
  `ksmbd_fd_set_delete_on_close()`.
- [Phase 6] `git show stable-
  push/linux-{5.15,6.1,6.6,6.12,6.18,6.19}.y:<path>`: buggy lines
  present in every listed stable tree.
- [Phase 6] Context around buggy lines in 6.1.y–6.19.y is textually
  identical to mainline → patch applies cleanly.
- [Phase 6] 5.15.y file path is `fs/ksmbd/smb2pdu.c` (not
  `fs/smb/server/...`) — trivial path rename required for that tree, no
  content rework.
- [Phase 7] `fs/smb/server/` is ksmbd (in-kernel SMB3 server); subsystem
  is active, has received many CVE-class fixes recently.
- [Phase 8] Failure mode: (1) legitimate CREATE requests rejected with
  `-EOPNOTSUPP`, (2) directory opens with NO_COMPRESSION corrupt
  CreateOptions including wrongly setting `FILE_DELETE_ON_CLOSE_LE` for
  line 3537. Severity MEDIUM-HIGH.
- UNVERIFIED: Did not run ksmbd and craft a CREATE packet to observe the
  bug at runtime; analysis relies on static reading of the code which
  matches the commit message and is unambiguous.

The patch is a 2-line, obviously-correct typo fix (`=` → `&=`) in
`smb2_open()` that corrects a client-reachable sanitization bug present
in ksmbd since v5.15. It is Acked by the ksmbd maintainer, affects every
active stable tree, and applies cleanly with at most a trivial path
rename for 5.15.y. It meets every stable-kernel-rules criterion and
introduces essentially zero regression risk.

**YES**

 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e21c6c22355b1..ad5559d48975b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3061,7 +3061,7 @@ int smb2_open(struct ksmbd_work *work)
 	} else {
 		if (req->CreateOptions & FILE_SEQUENTIAL_ONLY_LE &&
 		    req->CreateOptions & FILE_RANDOM_ACCESS_LE)
-			req->CreateOptions = ~(FILE_SEQUENTIAL_ONLY_LE);
+			req->CreateOptions &= ~FILE_SEQUENTIAL_ONLY_LE;
 
 		if (req->CreateOptions &
 		    (FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
@@ -3075,7 +3075,7 @@ int smb2_open(struct ksmbd_work *work)
 				rc = -EINVAL;
 				goto err_out2;
 			} else if (req->CreateOptions & FILE_NO_COMPRESSION_LE) {
-				req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);
+				req->CreateOptions &= ~FILE_NO_COMPRESSION_LE;
 			}
 		}
 	}
-- 
2.53.0

