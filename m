Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED98538761;
	Mon, 19 Oct 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418701; cv=none; b=mlMSSwuEB/vR20UHU+KYHlkRDwnKD4RG3oO4k/8a40uTvNEItv/KsW83PC3TWntv4xQaj+7kyHMCBMv4i3sKACECRWIEwquXtl1ebH4AtpFguQ1fl6SAv8nruAABsQ27L80uH1DHm7sx4FXp8g/XUpSetV1SjmYX01TBH6pGWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418701; c=relaxed/simple;
	bh=24d7NsJbbsGL/694baAXjNMCkaHCuUP7ioiqoBd8DRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYAxrjublETIQjaXrw4klyP53YhOl0d302MVWz+h92CrwArtMUkD8RMnaIOcmnmQPdJxnpenHWEcxRA5Hmn+Ma77SqSc1p9dinmB3Tjk0CXvSABakMS89LGzu5sQxhBDHCKy8C+04Cwow1BTzwgi+au9RBvTuGTzMp9W8wT/76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqcfdmZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqcfdmZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025671F000C6;
	Mon, 19 Oct 2026 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418698;
	bh=4uUYZsf7HeD1FtA/2f/cFcVEPSgoow6CLwoxLwi+h8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqcfdmZVupyotCD3mZQX+swkTyWLAo80tp1uwKRZWaleWpdrMwh6yHpnTTWZgiG0W
	 BhOfOYkxfcByj2076LvwNJ3lsFcwwl1p8wRCt7wmHueQ3j4XP2/VTLkZX3D1CTZ+CO
	 TOAodqKansN0uanN6Qs5KX/pIigdhOtGReKzsvCnrMcjl+nivO4w7yLKcjTVbocdqn
	 yNvB5gyjEFhdDCccof6Sa1SUuDNIcPcF8SP+RXYAn+ToYcqx9/HBKJ4/p7lcx5NeyE
	 ut4dOqoX4m95dXpQavveWmzJgsov51HHvUNQ3tdVs9y3GEaxowldIpkJYn5b06uPz0
	 2s+uzV4YYSh2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ksmbd: reject SMB3.1.1 binding with mismatched cipher
Date: Mon, 19 Oct 2026 09:52:04 -0400
Message-ID: <20261019135441.1420968-433-sashal@kernel.org>
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

[ Upstream commit 7019a11f79dc408f2b47b1027240e7f198784c9a ]

SMB3.1.1 multichannel connections belonging to the same session must use
the same negotiated encryption cipher.

ksmbd validates the dialect and client GUID during session binding, but
does not compare the cipher negotiated by the new connection with the
cipher used by the existing session channels. This allows a channel
negotiated with AES-128-CCM to bind to a session using AES-128-GCM.

Compare the new connection's cipher with an existing session channel and
return STATUS_INVALID_PARAMETER when they differ.

This fixes smb2.session.bind_negative_smb3encGtoCs.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **6.12.111** (`pending-6.12`, `git describe` =
`p-6.12-3-gc504cf0baa3d8`). The verdict is only for this tree.

Upstream commit analyzed: `7019a11f79dc408f2b47b1027240e7f198784c9a`
(not in this tree). `git apply --check` of that diff against local
`fs/smb/server/smb2pdu.c` succeeds.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject**
Record: `[ksmbd] [reject] SMB3.1.1 session binding must not succeed when
the new connection negotiated a different encryption cipher`

**Step 1.2: Tags**
Record:
- Signed-off-by: Namjae Jeon `<linkinjeon@kernel.org>` (author and
  committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable`
- Absence of `Fixes:`/`Cc: stable` is expected for this review path and
  is not treated as a negative signal

**Step 1.3: Body**
Record:
- Bug: SMB3.1.1 multichannel session binding checks dialect and client
  GUID, but not cipher. A connection that negotiated AES-128-CCM can
  bind to a session whose existing channel uses AES-128-GCM.
- Symptom: invalid bind is accepted; smbtorture
  `smb2.session.bind_negative_smb3encGtoCs` fails (expects
  `STATUS_INVALID_PARAMETER`).
- Root cause: missing comparison of `conn->cipher_type` against an
  existing session channel.
- Fix: under `sess->chann_lock`, compare ciphers and return `-EINVAL` →
  `STATUS_INVALID_PARAMETER`.
- No kernel-version range in the message.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit protocol-validation fix for encryption-
cipher mismatch on bind.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record:
- File: `fs/smb/server/smb2pdu.c` only (`+15` lines)
- Function: `smb2_sess_setup()`
- Scope: single-file surgical insertion in the existing SMB 3.x
  multichannel binding branch, immediately after the dialect check

**Step 2.2: Code flow**
Record:
- Before: after `conn->dialect != sess->dialect`, binding proceeds to
  the signed-request and GUID checks.
- After: if dialect is SMB 3.1.1, take `down_read(&sess->chann_lock)`,
  walk `sess->ksmbd_chann_list`, if `conn->cipher_type !=
  chann->conn->cipher_type` set `rc = -EINVAL`, then `up_read` and `goto
  out_err`.
- Path: SESSION_SETUP with `SMB2_SESSION_REQ_FLAG_BINDING` on SMB 3.1.1
  with multichannel enabled. Existing `out_err` maps `-EINVAL` to
  `STATUS_INVALID_PARAMETER` (local lines 1916–1917).

**Step 2.3: Bug mechanism**
Record:
- Category: protocol/crypto correctness (logic), not UAF/leak/race.
- Mechanism: cipher is per-connection (`conn->cipher_type`, set in
  `decode_encrypt_ctxt()` at NEGOTIATE). Session encryption/decryption
  keys are session-wide (`sess->smb3encryptionkey` /
  `smb3decryptionkey`) and are **not** regenerated on bind
  (`generate_encryptionkey` is skipped when
  `SMB2_SESSION_REQ_FLAG_BINDING` is set, local lines 1545–1546).
  `ksmbd_crypt_message()` then selects GCM vs CCM and 128 vs 256 from
  **this connection’s** `cipher_type` while using those shared session
  keys. Accepting a mismatched cipher therefore attaches a channel that
  will encrypt/decrypt with the wrong AEAD (and possibly the wrong key
  length) for the session keys.
- The `break` after the first channel is intentional: one existing
  channel is enough because all channels of a session are supposed to
  share one cipher.

**Step 2.4: Fix quality**
Record:
- Obviously correct: same lock and `xa_for_each` pattern as
  `free_channel_list()` / `ksmbd_sessions_deregister()`. Lock order
  matches existing `smb2_sess_setup` (`ksmbd_conn_lock` then
  `chann_lock`).
- Minimal: 15 lines, no API/struct change.
- Regression risk: low. Well-behaved clients already use one cipher for
  all channels; the new path only rejects invalid binds. `chann->conn`
  is set when the channel is allocated (`chann->conn = conn` in
  `ntlm_authenticate`) and the channel is erased under `chann_lock`
  before free.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record:
- Binding path originates in `f5a544e3bab7` (“ksmbd: add support for
  SMB3 multichannel”, 2021); it is an ancestor of this HEAD.
- Dialect check: `af7c39d971e43c` (2022); also an ancestor.
- Cipher field: `connection.h` `cipher_type` present in this tree.
- Missing cipher compare has been true for as long as ksmbd had SMB
  3.1.1 encryption + multichannel, including all of 6.12.

**Step 3.2: Fixes: tag**
Record: none. No `Fixes:` follow-up required.

**Step 3.3: File history**
Record:
- Local recent `smb2pdu.c` work is other ksmbd validation/UAF fixes;
  none already implement this cipher compare (`git log -S 'cipher_type
  != chann'` on this file is empty here).
- On `origin/master`, the only commit with this compare is
  `7019a11f79dc4` itself (no later rework).
- Neighbor bind_negative work (`f49bca41c12f9`, `3e67423336f08`,
  `1f12738b0ed7b`, `1c5daa2ea924be`) is **not** in this tree and is
  about signing of rejected responses / user mismatch, not a
  prerequisite for this hunk.

**Step 3.4: Author**
Record: Namjae Jeon is the ksmbd maintainer. Many of his protocol-
validation commits are already in this 6.12 tree.

**Step 3.5: Dependencies**
Record: Standalone. Needs `sess->chann_lock`, `sess->ksmbd_chann_list`,
`struct channel { ... *conn }`, `conn->cipher_type`, `SMB311_PROT_ID` —
all present locally. Not labeled `patch X/Y`. `4b706360ffb7e` (channel
limit) is not required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Original discussion**
Record: `b4 dig -c 7019a11f79dc4` (and `-C`) failed: lore.kernel.org
returned an error. WebFetch of lore URLs returned 403. Mailing-list
review text is **UNVERIFIED**.

**Step 4.2: Recipients**
Record: Could not run `b4 dig -w` successfully. Commit has only the
maintainer’s SOB (author = committer).

**Step 4.3: Bug report / spec / test**
Record (verified):
- Samba smbtorture `test_session_bind_negative_smb3encGtoCs`
  (source4/torture/smb2/session.c): SMB 3.1.1, encryption required,
  channel 1 AES-128-GCM, bind channel AES-128-CCM, same ClientGUID,
  expects `NT_STATUS_INVALID_PARAMETER`.
- Microsoft Open Specifications blog “SMB 3.1.1 Encryption in Windows
  10”: “Session binding (multichannel) requires that all channels bound
  to a given session negotiate the same encryption cipher as the master
  session’s connection” and that all channels share the same encryption
  keys.
- MS-SMB2 3.3.5.5 (SESSION_SETUP) documents dialect/GUID/signed/state
  checks that ksmbd already performs; the published HTML for that
  section does **not** spell out a CipherId compare (the Windows/Samba
  behavior and the blog do).

**Step 4.4: Series**
Record: Cluster of July 2026 `bind_negative_*` ksmbd fixes on
`origin/master`. This commit is self-contained; it does not depend on
the signing-response patches.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable search not reachable (403).
**UNVERIFIED** whether it was previously discussed for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
Record: `smb2_sess_setup()` only.

**Step 5.2: Callers**
Record: `fs/smb/server/smb2ops.c` command table `[SMB2_SESSION_SETUP_HE]
= { .proc = smb2_sess_setup }`. Invoked for every SMB2 SESSION_SETUP on
the ksmbd server. Network-reachable.

**Step 5.3: Callees**
Record: `down_read`/`up_read`, `xa_for_each` on
`sess->ksmbd_chann_list`. Existing error path `goto out_err`.

**Step 5.4: Reachability**
Record: Yes, from a remote SMB client if `CONFIG_SMB_SERVER` and
`KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL` are enabled. Trigger: SMB 3.1.1
session, then a second connection that negotiates a different cipher and
sends a signed binding SESSION_SETUP. Unprivileged in the sense of “any
client that can authenticate to ksmbd”; not a local syscall UAF.

**Step 5.5: Similar patterns**
Record: Dialect mismatch already rejected in the same function. Samba
has a second test `bind_negative_smb3encGtoCd` (different GUID); this
tree already rejects GUID mismatch via `memcmp(conn->ClientGUID,
sess->ClientGUID)`.

---

## PHASE 6: CROSS-REFERENCE AGAINST THIS TREE

**Step 6.1: Buggy code present?**
Record: Yes. Local `smb2_sess_setup()` at `fs/smb/server/smb2pdu.c`
~1743–1757 does dialect/GUID checks and has **no** cipher compare.
`7019a11f79dc4` is not an ancestor of HEAD.

**Step 6.2: Backport difficulty**
Record: **Clean apply** (`git apply --check` exit 0). Line-number offset
only vs mainline.

**Step 6.3: Related fixes already here?**
Record: No `bind_negative` ksmbd commits in this tree. No other cipher-
on-bind check.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
Record: `fs/smb/server` (ksmbd). Criticality: **IMPORTANT** — in-kernel
SMB3 server, remote attack surface, not core mm/VFS, not staging.

**Step 7.2**
Record: Actively maintained; this 6.12 tree already carries many ksmbd
validation backports (`reject repeated SMB2 NEGOTIATE`, DACL bounds,
etc.).

---

## PHASE 8: IMPACT AND RISK

**Step 8.1: Who is affected**
Record: Users of ksmbd with SMB3 multichannel enabled. Not universal.

**Step 8.2: Trigger**
Record: Uncommon for production Windows/Samba clients (they keep one
cipher). Fully reachable from a custom or test client. Requires an
existing authenticated session plus a signed bind (not an
unauthenticated bypass).

**Step 8.3: Failure mode**
Record: Today the invalid bind **succeeds**. Later encrypt/decrypt on
that channel uses the new connection’s AEAD with session keys derived
for the original cipher → AEAD failure / broken encrypted I/O, not a
demonstrated kernel oops. Spec/Windows require rejection with
`STATUS_INVALID_PARAMETER`. Severity: **MEDIUM** (protocol/crypto
invariant), not a panic/UAF.

**Step 8.4: Risk–benefit**
Record:
- Benefit: enforces a documented SMB 3.1.1 encryption invariant on a
  network server; matches Windows/Samba; tiny.
- Risk: very low — 15 lines, existing locks, rejects only illegal binds.
- Ratio: favorable for this tree because the code exists, the patch
  applies cleanly, and ksmbd crypto protocol holes are worth closing
  even when the trigger is rare.

---

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**

FOR:
- Real missing check: dialect is validated, cipher is not.
- Session keys are shared; cipher is per-connection; mismatch is a
  crypto/protocol bug, not cosmetic.
- Samba negative test and Microsoft encryption blog require same cipher
  on all bound channels.
- 15 lines, maintainer-authored, applies cleanly to 6.12.111.
- All data structures and the insertion site exist here; bug is old
  (multichannel + 3.1.1 encryption).

AGAINST:
- No crash, UAF, deadlock, or known CVE.
- Production clients typically never send this.
- No `Reviewed-by`; lore discussion could not be fetched.
- Adjacent bind_negative signing patches are not in this tree (not
  required for this hunk).

UNRESOLVED:
- Original mailing-list review / any NAK (lore unreachable).
- Whether MS-SMB2 3.3.5.5 normative text currently names CipherId (blog
  + Samba/Windows behavior still require the check).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — small, same locking as
   existing channel walks; covered by smbtorture
   `bind_negative_smb3encGtoCs`.
2. Real bug affecting users? **PASS** — ksmbd accepts a bind the
   protocol forbids; encrypted traffic on that channel is then
   inconsistent.
3. Important (crash/security/corruption/deadlock)? **PASS** (lower end)
   — encryption-cipher invariant on a remote SMB server, not a panic.
   Important enough given ksmbd’s role and the size of the fix.
4. Small and contained? **PASS** — +15 lines, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — clean apply; buggy code present.

**Step 9.3: Exception category**
Record: none (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small protocol/crypto bugfix.

**Step 9.4: Decision**
Backport to this 6.12 tree. The missing check is in this code, the fix
is surgical, and rejecting mismatched SMB 3.1.1 ciphers on bind is the
correct, low-risk behavior for stable ksmbd.

---

## Why this matters for 6.12 stable users

ksmbd already refuses a bind when the **dialect** does not match. It
still allows a second SMB 3.1.1 channel to join the same session with a
**different** negotiated cipher (e.g. AES-128-CCM vs AES-128-GCM).
Encryption keys are session-scoped and not rebuilt on bind; each
connection then picks GCM/CCM and key length from its own `cipher_type`.
That is a protocol and crypto consistency bug on a network-facing
server. The patch only adds the missing compare and returns
`STATUS_INVALID_PARAMETER`, which is what Windows/Samba tests expect.

Risk is low: correct clients are unchanged. The hunk applies here
without prerequisites.

### Verification
- [Phase 1] Parsed message/tags: maintainer SOB only; no
  Fixes/Cc/Reported-by.
- [Phase 2] Diff: +15 lines in `smb2_sess_setup()` binding branch;
  `-EINVAL` already maps to `STATUS_INVALID_PARAMETER`.
- [Phase 2] Confirmed bind skips `generate_encryptionkey` (local
  1545–1546); `ksmbd_crypt_message()` uses `conn->cipher_type` (auth.c
  1135–1155).
- [Phase 3] `git describe HEAD` / `make kernelversion`: 6.12.111. `git
  merge-base --is-ancestor 7019a11f79dc4 HEAD` → not in tree.
- [Phase 3] `f5a544e3bab7` and `af7c39d971e43c` are ancestors; dialect
  check present, cipher check absent (local ~1754–1757).
- [Phase 3] `git apply --check` of `7019a11f79dc4` → clean.
- [Phase 3] No later origin/master rework of this compare; related
  bind_negative signing commits are not ancestors and are not required.
- [Phase 4] `b4 dig` lore error; lore WebFetch 403. Samba test and MS
  encryption blog fetched successfully.
- [Phase 5] Caller: `smb2ops.c` SESSION_SETUP proc. Channel
  lock/list/`cipher_type` exist in this tree.
- [Phase 6] Insertion site matches; no local substitute fix.
- [Phase 8] Failure mode: invalid encrypted channel accepted; AEAD
  mismatch on subsequent I/O. Severity MEDIUM, regression risk very low.
- UNVERIFIED: lore review thread, stable@ discussion, explicit CipherId
  sentence in current MS-SMB2 3.3.5.5 HTML.

**YES**

 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ccefd325e52e3..d64753124dd9a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1747,6 +1747,21 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		if (conn->dialect == SMB311_PROT_ID) {
+			struct channel *chann;
+			unsigned long index;
+
+			down_read(&sess->chann_lock);
+			xa_for_each(&sess->ksmbd_chann_list, index, chann) {
+				if (conn->cipher_type != chann->conn->cipher_type)
+					rc = -EINVAL;
+				break;
+			}
+			up_read(&sess->chann_lock);
+			if (rc)
+				goto out_err;
+		}
+
 		if (!(req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
 			rc = -EINVAL;
 			goto out_err;
-- 
2.53.0

