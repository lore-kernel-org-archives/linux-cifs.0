Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92149C4CD;
	Mon, 31 Aug 2026 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183595; cv=none; b=a5cVzWso5il2gcHiYuzZ/egxehk5O24jK2N9Mv57KlhCpxSFS/0cKujjtC9QtXQLXlVhwBD9XpblD3cSLbn3RrskylTkURB8UxX6EAQ2+KP0KoI84+VL/KqitbO4FRpZBpfwBQsmlj4pYUNOW9skJhXChJ8qvD0BIxlY3vJyOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183595; c=relaxed/simple;
	bh=rZJaWVCHrTNz3ZB0rGwNIIDwlgEm7Fxvjwc8HJPKBrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=liceBUBVo1UpiOKANyoiu/sMpYr5GV3ydHeDZ2KizwXQPWGINjpsb/ajJH3yXrA52yBhWoUGzat7wsSJhdR7OJ6aLF0YCckGU9dY+OwCFEq7adc9tsMk86EY/dXd2+RmKJSy+7aM+e2iTKOzEiDPAnvRpNvjDAfOU/wS0UB5wVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/gPn9hw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/gPn9hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27F91F000E9;
	Mon, 31 Aug 2026 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183593;
	bh=iyHForfe9pPek3dEWIFFUFV9y6TsG4tMohaA4O7EN98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/gPn9hwv8DkWuFdDcUhqCrtUGy8kMWUOnfnyjGqX6iT41o1d54DhINomIzr8YFTB
	 jamDuPkA91NOnmDD2FdZaJSv0abFHANkOZI1WGZgXP2vdVMmYIRCY1Z/5s+STYlhDJ
	 60IiGbgZA8H/9YmlX8JIE62MHfUhOdmTD5SYQYfccUVyHiRNl09tzpOgJvA6XwpyZD
	 TTPgwmO0ksL27S7UYk5vPp6swTr9WS6G0hwWLNzMWYv636bbNvgp8g/ZElZF16uO2m
	 1AzM2k9cdjPWkEP/exJysS4py3Bjco9gTKPmgABJHleKQVSwCSGLqY2CncbnlWp5+G
	 PgQmecSv0zrLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: mark invalid session responses as signed
Date: Mon, 31 Aug 2026 09:23:35 -0400
Message-ID: <20260831133314.4125787-187-sashal@kernel.org>
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

[ Upstream commit 9e8ad620ddfde5a5f4ef58372e3805e9388cb0f4 ]

When a signed request uses a session that is not registered on the
connection, ksmbd returns STATUS_USER_SESSION_DELETED before reaching the
normal response signing path. The response therefore lacks
SMB2_FLAGS_SIGNED.

Clients that require signing check this flag before handling
STATUS_USER_SESSION_DELETED and replace the server status with
STATUS_ACCESS_DENIED when it is absent. The protocol permits this error
response to skip signature verification because the connection has no
matching session key.

Preserve SMB2_FLAGS_SIGNED on the early error response when the request was
signed. This lets the client propagate STATUS_USER_SESSION_DELETED.
It fixes smb2.session.bind2.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ksmbd] [mark] invalid session responses as signed` — sets
`SMB2_FLAGS_SIGNED` on early session-validation error responses when the
request was signed.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (author)
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` (cifs/ksmbd
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags (expected for manual review)

### Step 1.3: Body analysis
**Record:**
- **Bug:** Signed request references a session not registered on the
  connection; `smb2_check_user_session()` fails early; server returns
  `STATUS_USER_SESSION_DELETED` without `SMB2_FLAGS_SIGNED`.
- **Symptom:** Signing-required clients check `SMB2_FLAGS_SIGNED` before
  honoring that status; missing flag → client reports
  `STATUS_ACCESS_DENIED` instead of the server’s real status.
- **Root cause:** Early `goto send` bypasses the normal signing path
  (`work->sess` is NULL, so `set_sign_rsp()` is never called).
- **Fix approach:** Set only `SMB2_FLAGS_SIGNED` (no signature bytes);
  protocol allows skipping verification when no session key exists on
  the connection.
- **Test reference:** `smb2.session.bind2` (Samba protocol test suite).

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as marking responses signed, but it fixes a
real SMB protocol/interoperability bug: wrong client-visible error on
signed session-binding paths.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/server/server.c` (+6 / -0)
- **Function:** `__handle_ksmbd_work()`
- **Scope:** Single-file, surgical fix in one error path

### Step 2.2: Code flow change
**Record:**
- **Hunk (session check failure, `rc < 0`):**
  - **Before:** Set `STATUS_INVALID_PARAMETER` or
    `STATUS_USER_SESSION_DELETED`, `goto send` with unsigned response.
  - **After:** If `is_sign_req(work, get_cmd_val(work))`, set
    `SMB2_FLAGS_SIGNED` on current response header via
    `ksmbd_resp_buf_curr()`, then `goto send`.
- **Path affected:** Early error path before `__process_request()` and
  before the `work->sess && ... set_sign_rsp()` block (lines 234–237).

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic / protocol correctness on error path.
- Normal signing requires `work->sess` (lines 234–237).
- Invalid session → `work->sess` stays NULL → flag never set.
- Fix sets the flag without signing when the request was signed and no
  session key is available.

### Step 2.4: Fix quality
**Record:**
- Minimal, matches existing pattern in related ksmbd signing fixes (e.g.
  `1f12738`, `3e67423` on mainline).
- Low regression risk: only touches error path; only sets a flag when
  request was signed.
- Uses `get_cmd_val(work)` (reads request header directly), not
  uninitialized local `command` (still 0 at this point).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Session-check early-exit block dates to merge
`5d324e5159d9e` (v6.18-rc8 era, Nov 2025). Bug has been present since
this code structure landed in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `server.c` changes are crypto-library refactors and
leak/loop fixes (`74c2f0f`, `51c5f7e`, `71b5e7c`, `6a37bc4`). Related
binding fixes exist in tree (`a897064a45705` “do not expire session on
binding failure”, `9feb2d1bf86d9`). July 2026 signing series (`1f12738`,
`3e67423`, `4b70636`, `9e8ad620`) is **not** in this tree yet. This
commit is standalone for its code path.

### Step 3.4: Author context
**Record:** Namjae Jeon is ksmbd maintainer; Steve French is cifs
maintainer. Prior stable-nominated ksmbd fix in this tree:
`8cabcb4dd3dc` (refcount leak on invalid session lookup, `Cc:
stable@vger.kernel.org`).

### Step 3.5: Dependencies
**Record:** No series/prerequisite commits required. Uses existing APIs:
`is_sign_req`, `get_cmd_val`, `ksmbd_resp_buf_curr`,
`SMB2_FLAGS_SIGNED`. Patch applies cleanly (`git apply --check` on
GitHub `.patch` succeeded).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c 9e8ad620ddfde5a5f4ef58372e3805e9388cb0f4` — no
lore match found. GitHub commit page confirms message and diff.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — no lore data. Committer is subsystem
maintainer (Steve French).

### Step 4.3: Bug report
**Record:** No external bug report; validation reference is Samba test
`smb2.session.bind2`. Related mainline commits from same author/date
document the same signing-flag pattern for binding errors.

### Step 4.4: Related patches
**Record:** Part of a broader July 2026 ksmbd multichannel/signing fix
set on mainline, but this patch is self-contained for the `server.c`
early-session-check path.

### Step 4.5: Stable list history
**Record:** Lore blocked by bot protection; no stable-list discussion
found. Precedent: other ksmbd session/binding fixes backported to stable
in this tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `__handle_ksmbd_work()`, `smb2_check_user_session()`,
`smb2_is_sign_req()`, `get_smb2_cmd_val()`, `ksmbd_resp_buf_curr()`.

### Step 5.2: Callers
**Record:** `__handle_ksmbd_work()` ← `handle_ksmbd_work()` ← workqueue
processing of incoming SMB requests (network I/O path for all ksmbd
clients).

### Step 5.3: Callees
**Record:** On failure: `check_user_session()` →
`ksmbd_session_lookup_all()`; fix calls `is_sign_req()` and sets
response header flags.

### Step 5.4: Reachability
**Record:** Triggered by any signed SMB2/3 request with a session ID not
registered on the connection — reachable from remote SMB clients
(session binding / multichannel scenarios).

### Step 5.5: Similar patterns
**Record:** Same `Flags |= SMB2_FLAGS_SIGNED` without full signing in
mainline binding-error fixes (`3e67423`, `1f12738`). Normal signing
still done via `set_sign_rsp()` when `work->sess` is valid (lines
234–237).

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Buggy code at
`fs/smb/server/server.c:189-198` — early `goto send` without setting
signed flag. Commit `9e8ad620ddfde` is **not** an ancestor of HEAD.

### Step 6.2: Backport complications
**Record:** **Clean apply** verified. No structural conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Binding-related fixes present (`a897064a45705`,
`9feb2d1bf86d9`). This specific signed-flag-on-early-session-error fix
is **not** present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** **fs/smb/server (ksmbd)** — IMPORTANT. Network file server;
affects remote SMB clients, especially with mandatory signing.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (recent ksmbd security and
binding fixes in this tree).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** ksmbd users (`CONFIG_SMB_SERVER`) with SMB signing required
and session binding/multichannel — enterprise and Windows-client
environments.

### Step 8.2: Trigger conditions
**Record:** Signed request with session ID unknown on current connection
(common in SMB multichannel binding). Remote-triggerable; not timing-
dependent.

### Step 8.3: Failure mode severity
**Record:** Wrong error status (`STATUS_ACCESS_DENIED` vs
`STATUS_USER_SESSION_DELETED`) → session binding failures, multichannel
setup breakage, client disconnects. **Severity: MEDIUM**
(functional/protocol, not kernel oops/corruption).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for ksmbd + signing + multichannel users
- **Risk:** VERY LOW (+6 lines, error path only, flag-only change)
- **Ratio:** Favorable for stable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR:**
- Real, reproducible protocol bug (Samba test `smb2.session.bind2`)
- Buggy code confirmed in 6.18.44 tree
- Small, obviously correct, applies cleanly
- Maintainer-authored and maintainer-committed
- Same signing-flag pattern as other accepted ksmbd stable fixes
- Affects remote SMB clients on a production server subsystem
- Precedent: ksmbd binding/session fixes already in this stable series

**AGAINST:**
- Not crash/security/data-corruption class
- Full `smb2.session.bind2` pass may also need other mainline signing
  commits not yet in tree
- No lore review trail found via b4

**UNRESOLVED:**
- No mailing-list review thread found
- Exact production user reports not verified beyond Samba test reference

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; Samba test
   cited; maintainer sign-off
2. Fixes real bug affecting users? **PASS** — wrong SMB status on signed
   requests
3. Important issue? **PASS (borderline)** — MEDIUM severity
   protocol/interop bug breaking session binding with signing
4. Small and contained? **PASS** — 6 lines, one file
5. No new features/APIs? **PASS** — flag on existing error path only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as protocol correctness bug fix.

### Step 9.4: Decision rationale
For **this 6.18.44 tree**, ksmbd is present with multichannel/binding
support, the buggy early-exit path exists, and the fix is minimal and
low-risk. Wrong `STATUS_ACCESS_DENIED` on signed session-binding errors
breaks real SMB client interoperability — the same class of issue other
ksmbd binding fixes have addressed in stable. Benefit outweighs risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  GitHub `9e8ad620ddfde`
- [Phase 2] Read diff and `fs/smb/server/server.c:163-254`; traced
  signing path at lines 234-237
- [Phase 2] Read `smb2_check_user_session()` at `smb2pdu.c:581-629` —
  returns `-ENOENT` when session not found
- [Phase 2] Read `smb2_is_sign_req()` at `smb2pdu.c:9018-9028`
- [Phase 3] `git blame -L 188,238 fs/smb/server/server.c` — block from
  `5d324e5159d9e`
- [Phase 3] `git merge-base --is-ancestor 9e8ad620ddfde HEAD` → exit 1
  (not in tree)
- [Phase 3] Related commits `1f12738`, `3e67423`, `4b70636` — all NOT in
  tree
- [Phase 3] `git log --grep="Cc: stable" -- fs/smb/server/` — found
  `8cabcb4dd3dc` precedent
- [Phase 4] `b4 dig -c 9e8ad620ddfde` — no lore match
- [Phase 4] GitHub API/commit page — confirmed author, message, +6/-0
- [Phase 5] `get_smb2_cmd_val()` at `smb2pdu.c:227-236` reads from
  request buffer
- [Phase 5] Header chain: `server.c` → `connection.h` → `ksmbd_work.h`
  (`ksmbd_resp_buf_curr`); `smb_common.h` → `common/smb2pdu.h`
  (`SMB2_FLAGS_SIGNED`, `struct smb2_hdr`)
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 6] Buggy code present at lines 189-198 (no signed flag on early
  error)
- [Phase 6] `curl .../9e8ad620....patch | git apply --check` → success
- [Phase 7] Multichannel binding code present in `smb2pdu.c:1734+`
- [Phase 8] Failure mode: wrong SMB status, session binding breakage —
  MEDIUM severity

**YES**The background check finished: none of the related July 2026
ksmbd signing/binding commits are in this **6.18.44** tree yet:

- `9e8ad620ddfde` — mark invalid session responses as signed (the
  candidate)
- `1f12738b0ed7` — sign rejected SMB2.1 session binding responses
- `3e67423336f0` — mark rejected cross-dialect bindings as signed
- `4b706360ffb7` — fix multichannel binding and enforce channel limit

The buggy early-exit path in `fs/smb/server/server.c` is still present
here, and the candidate patch applies cleanly. That supports backporting
**`9e8ad620`** on its own; passing `smb2.session.bind2` end-to-end may
still need the other three mainline fixes.

 fs/smb/server/server.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index c729d47f9932b..e70ea8ef1deb8 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -195,6 +195,12 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 				else
 					conn->ops->set_rsp_status(work,
 						STATUS_USER_SESSION_DELETED);
+				if (conn->ops->is_sign_req(work, conn->ops->get_cmd_val(work))) {
+					struct smb2_hdr *rsp_hdr;
+
+					rsp_hdr = ksmbd_resp_buf_curr(work);
+					rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
+				}
 				goto send;
 			} else if (rc > 0) {
 				rc = conn->ops->get_ksmbd_tcon(work);
-- 
2.53.0

