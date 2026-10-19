Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D80E5FF62C;
	Mon, 19 Oct 2026 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418581; cv=none; b=YjcnF2I5I+JAr+OoWIfG282YTp9Gqb+QH1trg5zux6IyagldmhlgGtjmRfmTvAGMfHVja0UwVhsM0sl5mQ8WakgztkP5K8+tfpShL1rMGlaFLYRcqt0YgvRRncnlhEF85pBWWgc0t1B6OD6zMwWXjW8lc59jpt1yrFGFLOAGl4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418581; c=relaxed/simple;
	bh=TTdddeHMtr7wetz1Vsamh2kd68eQ1w7kmjkDp4jMAUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gs2KmFiZE0qE5u2HmyKPuxqZqRc+9H6lyajGek6ZDkD27e4JSVqn3NX9e7FS6W6SgxDN2/F5hxfB9FjZKR0MMjUSPmJ/cZyo6uAyReSudPpiQfwRnekguBFDGeYosFawY6bH/9P0fSyzlUjYwZcfDbYM8DkjJVfr1BBHJKU9ubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaCT8lO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaCT8lO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C5F1F000C7;
	Mon, 19 Oct 2026 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418579;
	bh=1MHD/LNv7217jb5wbOXkHs7+xUUewgbYZ/jth4BbiyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaCT8lO0hkA+2i5uaNu9amvUGB/4STX4QXobNNXrkgBJcD2MBhx69zE4HJ+E3X6CG
	 6TprtMyaU7VkTRB0Hm7U8cIPJMdP1xKXvXVK+2Mi3PRUee4PBORLfTHQu62nMp+D4t
	 VJnrlvkNq/Nn8+0V1mqIrdL8vYXokPENWQFOUdTA2eXwFDPH6tsTM5IVV8PIIql8TZ
	 jXe+hUEIl1R9OdU5uE4MdM6563bPAJrFOubrOt/Q++5vM8VNR9UDnqVmWReuidLZ2z
	 +k06RMI9/QgwIAgEDcLu+NuWYmHqecS3J7NIN1eGypwrLN67zQkfVQ81iBQo4UzmCy
	 fX0CMsIG8pSPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: honor client signing-required in all modes
Date: Mon, 19 Oct 2026 09:50:39 -0400
Message-ID: <20261019135441.1420968-348-sashal@kernel.org>
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

[ Upstream commit bc2f3f3dd69424f76e2ed3dc53d29bfd6c9966d4 ]

The SMB2 NEGOTIATE request's SMB2_NEGOTIATE_SIGNING_REQUIRED bit requires
the server to set Connection.ShouldSign. KSMBD represents that state with
conn->sign, but previously set it only when its signing configuration was
auto or disabled.

Set conn->sign whenever the client requires signing, independently of the
server's signing mode. Keep the mandatory server-mode handling unchanged.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[ksmbd] [honor] honor client signing-required in all modes`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd
  maintainer; author and committer of upstream `bc2f3f3dd694`)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Link:`, or
  `Cc: stable` (absence expected for this review)
- Pipeline `Signed-off-by: Sasha Levin` ignored per instructions

**Step 1.3 — Body**
Record:
- Bug: MS-SMB2 requires `Connection.ShouldSign` when the client sets
  `SMB2_NEGOTIATE_SIGNING_REQUIRED` on NEGOTIATE. ksmbd stores that in
  `conn->sign`, but only set it when `server_conf.signing` was `AUTO` or
  `DISABLED`.
- Symptom: with `server signing = enabled`, a client that requires
  signing does not get `conn->sign` set. Later session signing
  (`sess->sign`) can stay off unless SESSION_SETUP repeats the flag.
- Failure mode: protocol MUST violation; session may not be treated as
  signing-required.
- Version: present since ksmbd was merged; not a new-code-only bug.

**Step 1.4 — Hidden fix?**
Record: Not disguised. It is an explicit protocol/security correctness
fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `fs/smb/server/smb2pdu.c` (upstream +2/−4; this tree matches at
  lines 1252–1263)
- Function: `smb2_handle_negotiate()`
- Scope: single-file surgical logic change

**Step 2.2 — Before → after**
Record:
- Before: `conn->sign = true` only if `(AUTO || DISABLED) && client
  SIGNING_REQUIRED`, else if `MANDATORY` (force required +
  `conn->sign`).
- After: if client SIGNING_REQUIRED → `conn->sign = true` in every
  server mode. `MANDATORY` handling is a separate `if` (not `else if`)
  and is otherwise unchanged.
- Path: SMB2 NEGOTIATE, once per connection.

**Step 2.3 — Bug mechanism**
Record: Logic/correctness (protocol security).
`KSMBD_CONFIG_OPT_ENABLED` (1) was the missing case. Userspace maps
`server signing = enabled` to that value.

**Step 2.4 — Fix quality**
Record: Obviously correct vs MS-SMB2 3.3.5.4. Minimal. Changing `else
if` to `if` is equivalent for AUTO/DISABLED/MANDATORY. Regression risk
is very low; the only new behavior is honoring client-required signing
when the server mode is ENABLED.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Buggy condition is from `e2f34481b24db` (“cifsd: add server-side
procedures for SMB3”, 2021-05-10). Whitespace-only tweak in
`64b39f4a2fd29`. Present since ksmbd entered mainline (~v5.15).

**Step 3.2 — Fixes: tag**
Record: None. Introduction commit is an ancestor of this tree (`git
merge-base --is-ancestor e2f34481b24db HEAD` succeeded).

**Step 3.3 — File history**
Record: Recent `smb2pdu.c` work is leases, durable reconnect, negotiate
races — not this signing condition. Standalone, not “patch X/Y”.

**Step 3.4 — Author**
Record: Namjae Jeon is the ksmbd maintainer. Nearby work is other ksmbd
protocol/security fixes, not a prerequisite series for this hunk.

**Step 3.5 — Dependencies**
Record: None. Uses existing `conn->sign`, `server_conf.signing`, and
`SMB2_NEGOTIATE_SIGNING_REQUIRED_LE`. `git apply --check` of a line-
adjusted patch is clean.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record: Upstream SHA `bc2f3f3dd69424f76e2ed3dc53d29bfd6c9966d4`
(authored 2026-07-17, committed 2026-08-17). `b4 dig` failed:
lore.kernel.org returned errors (bot protection). No thread URL
retrieved.

**Step 4.2 — Reviewers**
Record: UNVERIFIED via b4. Namjae is both author and committer; typical
for ksmbd maintainer commits.

**Step 4.3 — Bug report**
Record: No `Reported-by` / syzbot / bugzilla. The 7.3-rc1 ksmbd pull
(Namjae Jeon, 2026-08-23) lists “signing-required handling” under
“SMB2/SMB3 protocol validation and security issues” and mentions
smbtorture-validated compatibility fixes.

**Step 4.4 — Series**
Record: Independent of the 7.3 features landed the same day (replay,
sequence window, Time Machine). This hunk does not use those structures.

**Step 4.5 — stable@**
Record: lore.kernel.org/stable search returned 403. No stable-specific
NAK found.

## Phase 5: Code semantics

**Step 5.1 — Functions**
Record: `smb2_handle_negotiate()` only.

**Step 5.2 — Callers**
Record: Called from `fs/smb/server/smb_common.c` during SMB2 dialect
negotiate, under `conn->srv_mutex`. That is the first SMB2 command on a
connection (TCP 445). User-reachable on every ksmbd connection.

**Step 5.3 — Callees / effects**
Record: `conn->sign` is `Connection.ShouldSign`. It is consumed in NTLM
and Kerberos session setup to set `sess->sign`. `sess->sign` causes
response signing in `__handle_ksmbd_work()`.

**Step 5.4 — Reachability**
Record: Yes, from the network. Gated on `CONFIG_SMB_SERVER` (default n).

**Step 5.5 — Similar patterns**
Record: SESSION_SETUP has a second check: `req->SecurityMode &
SMB2_NEGOTIATE_SIGNING_REQUIRED`. Compliant clients (MS-SMB2 MUST, Linux
CIFS) usually set the same flag on SESSION_SETUP, so `sess->sign` can
still be set. That is a fallback, not a reason the NEGOTIATE bug is
absent. SMB1-style negotiate around line 307 only advertises REQUIRED in
MANDATORY mode and does not set `conn->sign`.

Verified in this tree: `smb2_is_sign_req()` still only looks at
`SMB2_FLAGS_SIGNED` on the request. This patch does not add reject-
unsigned-when-required. It only sets ShouldSign so session signing state
can follow the spec.

## Phase 6: This tree (6.12.111)

**Step 6.1 — Buggy code present?**
Record: Yes, `fs/smb/server/smb2pdu.c` lines 1255–1263. Local tree:
`p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = **6.12.111**. Upstream
commit is **not** an ancestor (`git merge-base --is-ancestor
bc2f3f3dd694 HEAD` failed).

**Step 6.2 — Backport difficulty**
Record: Clean apply after shifting hunks (~1252 vs upstream ~1687).
Surrounding negotiate code matches.

**Step 6.3 — Related fixes already here?**
Record: `1ae94dd9dea50` (“mark invalid session responses as signed”) is
a different FLAGS_SIGNED error-path issue. No existing fix for the
ENABLED-mode `conn->sign` gap.

## Phase 7: Subsystem

**Step 7.1**
Record: `fs/smb/server` (ksmbd). Criticality: IMPORTANT (network-facing
SMB3 server; not core mm/VFS, but production NAS/OpenWrt/etc.).

**Step 7.2**
Record: Actively maintained; this 6.12 tree already carries many later
ksmbd security/protocol backports.

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: ksmbd users (`CONFIG_SMB_SERVER`) with `server signing =
enabled`. ksmbd-tools `cp_get_group_kv_config_opt()` maps `"enabled"` →
`KSMBD_CONFIG_OPT_ENABLED`. Default in tools is `auto` (already
correct). `"enabled"` is still a parsed, distinct value (Samba-style
configs often use it). Man page documents disabled/auto/mandatory;
userspace still accepts enabled.

**Step 8.2 — Trigger**
Record: Client sets NEGOTIATE `SMB2_NEGOTIATE_SIGNING_REQUIRED` while
server mode is ENABLED. Common for Windows/Linux clients that require
signing. Unprivileged remote clients can send that bit.

**Step 8.3 — Failure mode**
Record: Protocol MUST missed; `Connection.ShouldSign` stays false.
Severity: **MEDIUM–HIGH** (integrity of SMB traffic / spec security
negotiation), not a panic. Mitigated if SESSION_SETUP also carries
SIGNING_REQUIRED.

**Step 8.4 — Risk vs benefit**
Record: Benefit: honor client-required signing in the one broken mode;
matches spec and maintainer intent. Risk: very low (4-line boolean, no
locks/APIs/new features). Ratio: favorable.

## Phase 9: Synthesis

**For backporting**
- Real MS-SMB2 MUST violation in existing 6.12 code
- Security-related signing negotiation on a network file server
- Tiny, obviously correct, applies cleanly
- Maintainer-authored; 7.3-rc1 pull grouped it with protocol/security
  fixes
- `server signing = enabled` is a real userspace mapping

**Against**
- Default `auto` already sets `conn->sign`
- SESSION_SETUP fallback for compliant clients
- No crash/syzbot/CVE
- Does not fully enforce unsigned-request rejection (`is_sign_req` still
  flag-based)

**Unresolved**
- Full lore review thread (lore 403 / b4 failed)
- No stable@ discussion retrieved

**Stable rules**
1. Obviously correct and tested? **PASS** (logic vs spec; maintainer-
   committed)
2. Real bug affecting users? **PASS** (ENABLED mode + client
   SIGNING_REQUIRED)
3. Important (security/protocol integrity)? **PASS** (signing-required
   handling; not a panic)
4. Small and contained? **PASS** (+2/−4, one function)
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** (clean apply)

No exception category (not a device ID/quirk/DT/build/docs-only change).
It is a normal small protocol fix.

The ENABLED hole is the mode where admins reasonably expect signing to
work, and it is the only mode that ignored a client REQUIRED bit. Cost
of backporting to 6.12.y is negligible.

Verification:
- [Phase 1] Parsed message/tags: only Namjae SOB; no Fixes/Reported-by
- [Phase 2] Diff: `smb2_handle_negotiate()` condition; ENABLED was
  skipped
- [Phase 3] `git blame` / `-L`: introduced in `e2f34481b24db` (v5.15-era
  cifsd)
- [Phase 3] `git merge-base --is-ancestor e2f34481b24db HEAD`: yes
- [Phase 3] `git merge-base --is-ancestor bc2f3f3dd694 HEAD`: no (not in
  this tree)
- [Phase 3] `git apply --check`: clean on 6.12 `smb2pdu.c`
- [Phase 4] GitHub API: upstream
  `bc2f3f3dd69424f76e2ed3dc53d29bfd6c9966d4`
- [Phase 4] `b4 dig -c bc2f3f3dd694`: lore errors, no thread
- [Phase 4] 7.3-rc1 GIT PULL: “signing-required handling” under
  protocol/security
- [Phase 5] Caller: `smb_common.c` SMB2 NEGOTIATE; `conn->sign` →
  `sess->sign` in session setup
- [Phase 5] `smb2_is_sign_req()` does not use `conn->sign` (verified)
- [Phase 6] `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111; buggy `if` present at 1255–1263
- [Phase 8] ksmbd-tools `config_parser.c`: `"enabled"` →
  `KSMBD_CONFIG_OPT_ENABLED`; default `"server signing = auto"`
- UNVERIFIED: mailing-list NAKs/Cc: stable (lore unavailable)

This is a small, contained protocol-security fix that already matches
this tree’s ksmbd negotiate path and should be backported.

**YES**

 fs/smb/server/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cc3a3da410eaf..e7b1cab45ab2d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1253,11 +1253,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED_LE;
 	conn->use_spnego = true;
 
-	if ((server_conf.signing == KSMBD_CONFIG_OPT_AUTO ||
-	     server_conf.signing == KSMBD_CONFIG_OPT_DISABLED) &&
-	    req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
+	if (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
 		conn->sign = true;
-	else if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
+	if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
 		server_conf.enforced_signing = true;
 		rsp->SecurityMode |= SMB2_NEGOTIATE_SIGNING_REQUIRED_LE;
 		conn->sign = true;
-- 
2.53.0

