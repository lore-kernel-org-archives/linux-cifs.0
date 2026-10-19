Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8EE4D1F8B;
	Mon, 19 Oct 2026 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418503; cv=none; b=SCSGRteuEuVdmmuIR0nXq2icIk4+L3oORrLXcBMA86EK83BGXk9lDbNR/dcBF0sDfbwqfUme8+PNZ8+LezBIJVrPyXDN8M7QJgGacHCCPb94FUfhCPh2+Xwwcle39C/FcsmaeOmHIvoM2duHrVNhLAVEer4P9AalCZhxLjAPokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418503; c=relaxed/simple;
	bh=Pw16NMBKp4Tb7RpBxtRLoXIQzsakfGEM8SLKudZ+8JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cNomdWyhUh1mtzIgymZsFFsWtOM3DouuOJSNAUnD+p81c3Dfd/fq+3y9zoCFQbNnlMDMOhIJXMd2Nq/dJ6mEP/fVpfn39S22oRtuwRZzpo+FVkmjONczgG7Ub7mLtHJj2UJqqNm0BZU06/XlsxQTJWrYEIwyAPmqEfjv95Y5DVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bb0BZXX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bb0BZXX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0992C1F000C9;
	Mon, 19 Oct 2026 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418500;
	bh=vCYSX0KAdzMp4LUoB36agPXg/WOb5Qw+5T8Kzg7aaEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb0BZXX+XXSb2TK8BkM7gxBi954yujRm0UpD3MDPufSsrMxxU/FkEf4gu+H1SvsJY
	 YxdNc/MAcEYDhFXezh0wSMyDCpo6gbKE743Ww/+m0Gy58Oy1ggZymCWzZndOEb+sSn
	 jLpLUivEEQFfxGm2pFEKMZOJH5vXPRKMv3nW/N+rmq2sU+pl934FjfiDN92DVH5X88
	 xI34YrU499JZoCvDPYclaD4TUKF9XXkF0qZLnzjF7cUuAAYyjzE2Tw6eFMb+dEStqU
	 Otw48UlEh+5rvgKZpHBbilza91rCTFgxl1Q0PuuQDiyMhnCmLxh+2m17XrYULJuO69
	 ixAMwR6X9F5HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Mon, 19 Oct 2026 09:49:44 -0400
Message-ID: <20261019135441.1420968-293-sashal@kernel.org>
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

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 9a4bd6507c21f66e84dc021705a4b9d84773111e ]

struct ksmbd_session contains some arrays with sensitive information, like
sess_key, smb3encryptionkey, smb3decryptionkey and smb3signingkey. Thus
let's make sure that this information cannot leak via the heap and use
kfree_sensitive() to free it.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local 6.12.111 code, the upstream commit, and the mailing-
list thread. Compiling the nine-phase analysis next.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[smb/ksmbd server] [Free / use kfree_sensitive] Wipe ksmbd
  session objects (and Preauth_HashValue) so session keys cannot remain
  in freed heap memory`

**Step 1.2: Tags** (from upstream
`d4a6d1c94f7a383c16fd5f5e912a39a640d1cb9d`; ignore pipeline SOBs)
- No `Fixes:`
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Cc: stable`
- `Acked-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd maintainer)
- `Signed-off-by: Thomas Huth <thuth@redhat.com>` (author)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (CIFS
  maintainer; present on the merged commit)
- Candidate-prep copy also had `Signed-off-by: Namjae Jeon`; merged form
  uses Acked-by instead
- Record: Maintainer ack, no user report, no syzbot, no CVE tag

**Step 1.3: Body**
- Record: `[Bug] ksmbd_session holds sess_key, smb3encryptionkey,
  smb3decryptionkey, smb3signingkey and a Preauth_HashValue buffer, then
  frees them with kfree(), so those secrets can remain in the slab.
  [Symptom] Potential heap disclosure of SMB session/crypto keys after
  session teardown. [Versions] None stated. [Root cause] Sensitive
  material is returned to the allocator without memzero_explicit.]`
- Cover letter (series v2 0/5): “It's good security practice to clear
  sensitive data… and to use kfree_sensitive() for data that is returned
  to the heap.”

**Step 1.4: Hidden bug fix?**
- Record: Not disguised cleanup. It is an explicit secret-wipe / heap-
  disclosure hardening change. Functional behavior of session teardown
  is unchanged except the object is zeroed before free.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `[fs/smb/server/mgmt/user_session.c: 2 insertions, 2
  deletions] [function: ksmbd_session_destroy] [scope: single-file, two-
  call-site surgical change]`

**Step 2.2: Code flow**
- Record: Before, `ksmbd_session_destroy()` calls
  `kfree(sess->Preauth_HashValue)` then `kfree(sess)` after logoff/file-
  table/user/RPC/channel teardown. After, those two frees use
  `kfree_sensitive()`, which `memzero_explicit`s the whole allocation
  then `kfree`s. Normal teardown path only; not an error-path
  restructure.

Verified in this tree at:

```159:175:fs/smb/server/mgmt/user_session.c
void ksmbd_session_destroy(struct ksmbd_session *sess)
{
        if (!sess)
                return;

        ksmbd_tree_conn_session_logoff(sess);
        ksmbd_destroy_file_table(sess);
        if (sess->user)
                ksmbd_free_user(sess->user);
        ksmbd_launch_ksmbd_durable_scavenger();
        ksmbd_session_rpc_clear_list(sess);
        free_channel_list(sess);
        kfree(sess->Preauth_HashValue);
        ksmbd_release_id(&session_ida, sess->id);
        ida_destroy(&sess->tree_conn_ida);
        kfree(sess);
}
```

Sensitive fields verified in `struct ksmbd_session` (`user_session.h`):
`sess_key`, `smb3encryptionkey`, `smb3decryptionkey`, `smb3signingkey`,
plus `Preauth_HashValue`.

**Step 2.3: Bug mechanism**
- Record: `[Memory safety / cryptographic material leftover] [kfree()
  does not clear; kfree_sensitive() zeros via memzero_explicit then
  frees. Category: information leak / CWE-226 class, not UAF/crash.]`

**Step 2.4: Fix quality**
- Record: `[Obviously correct drop-in. kfree_sensitive() is NULL-safe
  like kfree(). Session is kzalloc'd, so ksize/kfree_sensitive is the
  right API. No API/lock/struct change.] [Regression risk: very low.
  Docs warn kfree_sensitive is not for hot paths; session destroy is
  logoff/expire/teardown, not a packet hot path.]`

## Phase 3: Git history

**Step 3.1: Blame**
- Record: `ksmbd_session_destroy` and `kfree(sess->Preauth_HashValue)`
  from `e2f34481b24db2` (“cifsd: add server-side procedures for SMB3”),
  contained in `v5.15-rc1`. `kfree(sess)` from `822bc8ea514ecd` (2021).
  Encryption key fields from `5a0ca7700591a5` (2021). Bug has been in
  this code since ksmbd entered mainline.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag. Not applicable. Introducer is the original
  ksmbd session code, which is in this tree (`git merge-base --is-
  ancestor` of those SHAs vs HEAD succeeded).

**Step 3.3: File history**
- Record: Recent 6.12.y ksmbd session work is lifetime/UAF/ida (e.g.
  `9d58ac0643e5b` destroy tree_conn_ida, session leak/UAF fixes). None
  already switches these two `kfree`s. Not blocked by later refactor in
  this file.

**Step 3.4: Author**
- Record: Thomas Huth (Red Hat); not the ksmbd maintainer. Series of
  five independent kfree_sensitive conversions. Maintainer Namjae Jeon
  acked and applied to `#ksmbd-for-next-next`. Steve French signed off
  on the merge.

**Step 3.5: Dependencies**
- Record: Patch 3/5 of “Clear sensitive data before freeing it”. Sibling
  patches touch `auth.c`, `user_config.c`, `connection.c`, `smb2pdu.c`.
  This hunk does not call new helpers and does not depend on those other
  diffs. `linux/slab.h` already included. `kfree_sensitive()` exists in
  this tree (`mm/slab_common.c`, exported). Standalone apply: yes.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `[Lore]
  https://patch.msgid.link/20260811154620.2425851-4-thuth@redhat.com`
- Series: v1 (4 patches, 2026-08-10) → v2 (5 patches, 2026-08-11). This
  file hunk is unchanged v1→v2.
- v1 review (Namjae): also wipe `struct preauth_session` in
  `ksmbd_preauth_session_destroy()`. That was handled in v2 patch 5
  (`smb2pdu.c` session-setup paths), not in this commit. This commit is
  still self-contained.
- No NAK. No reviewer asked for `Cc: stable`. Maintainer: “Applied them
  to #ksmbd-for-next-next.”

**Step 4.2: Recipients (b4 dig -w)**
- Record: Thomas Huth; Namjae Jeon; Steve French; Sergey Senozhatsky;
  Tom Talpey; linux-kernel@. Subsystem maintainers were on To/Cc and the
  ksmbd maintainer acked.

**Step 4.3: Bug report**
- Record: No syzbot/bugzilla/CVE for this change. Author framed it as
  hygiene; spots “identified with AI” then written by hand.

**Step 4.4: Series context**
- Record: Five independent wipe sites. This one wipes the session object
  that actually embeds the SMB3 keys. Related remaining `kfree(chann)`
  of `struct channel` (contains `smb3signingkey`) is not part of this
  commit; that does not make this hunk incorrect.

**Step 4.5: Stable list**
- Record: No stable@ discussion found for this subject. Unverified that
  it was previously rejected for stable.

Upstream SHA (not in this branch):
`d4a6d1c94f7a383c16fd5f5e912a39a640d1cb9d`. `git merge-base --is-
ancestor d4a6d1c94f7a3 HEAD` failed (exit 1).

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: `ksmbd_session_destroy` only.

**Step 5.2: Callers**
- Record: Same file: `ksmbd_expire_session`, `ksmbd_sessions_deregister`
  (two sites), `ksmbd_user_session_put`, `__session_create` error path.
- `ksmbd_user_session_put` is used from `smb2pdu.c` (session
  setup/logoff), `server.c`, `auth.c`, and register failure.
- Context: SMB session lifetime (logoff, expire, connection teardown,
  create failure). Not IRQ. Reachable from a connected SMB client.

**Step 5.3: Callees**
- Record: tree-connect logoff, file table destroy, `ksmbd_free_user`,
  durable scavenger, RPC clear, `free_channel_list`, then the two frees.
  Side effect of the patch is only the wipe-before-free.

**Step 5.4: Reachability**
- Record: Yes. Any ksmbd login then logoff/disconnect/expire hits this.
  CONFIG_SMB_SERVER (default n), module `ksmbd`. Network-facing when
  enabled.

**Step 5.5: Similar patterns**
- Record: CIFS client already uses `kfree_sensitive` widely for session
  keys/passwords in this tree. ksmbd server only uses it in `auth.c`
  (`kfree_sensitive(ctx_arc4)`). `free_channel_list`/`ksmbd_chann_del`
  still `kfree` channel objects that embed `smb3signingkey`.
  `ksmbd_preauth_session_destroy` still `kfree`s `preauth_session` (hash
  embedded). Same class of leftover secrets; this patch still covers the
  primary session key material.

## Phase 6: This tree (6.12.111)

**Step 6.1: Buggy code present?**
- Record: Yes. `pending-6.12` / `make kernelversion` = 6.12.111. Exact
  `kfree(sess->Preauth_HashValue)` and `kfree(sess)` still in
  `ksmbd_session_destroy`. Introduced with ksmbd (v5.15), long before
  6.12.

**Step 6.2: Backport difficulty**
- Record: Clean apply. Mailing-list hunk context
  (`ksmbd_launch_ksmbd_durable_scavenger` … `ida_destroy`) matches this
  tree. Upstream later added `delete_proc_session(sess)` above these
  lines; that symbol is absent here but is not in the 3-line context of
  the actual change. `kfree_sensitive` already declared in
  `include/linux/slab.h`.

**Step 6.3: Related fixes already here?**
- Record: No equivalent wipe of these two allocations. `git log
  --grep=kfree_sensitive -- fs/smb/server` has no matching session-
  destroy commit.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[ksmbd / fs/smb/server] [IMPORTANT for systems with
  CONFIG_SMB_SERVER: NAS/embedded SMB3 server; not CORE for every 6.12
  user]`

**Step 7.2**
- Record: Actively maintained; this 6.12.y branch already carries many
  ksmbd security/UAF backports. Code path itself is mature (since 5.15).

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Config-specific (`CONFIG_SMB_SERVER`). Users running ksmbd
  (SMB3 kernel server).

**Step 8.2: Trigger**
- Record: Session destroy on logoff, idle expire, connection teardown,
  or failed session create. Common on any real ksmbd workload.
  Triggering the leftover keys does not require a race; the wipe
  omission is deterministic. Reading the leftover keys does require
  another info leak, a dump, or similar.

**Step 8.3: Failure mode**
- Record: `[Residual SMB session/encryption/signing keys and preauth
  hash in slab after free] [Severity: MEDIUM as a standalone disclosure
  (needs another read of freed/reused heap), HIGH in combination with an
  uninitialized-kmalloc leak or memory dump because the secrets can
  decrypt prior SMB3 traffic or expose session key material]`

**Step 8.4: Risk-benefit**
- Record: `[Benefit: medium for ksmbd deployments — clears the actual
  SMB3 key material on every session end] [Risk: very low — 2 lines,
  dedicated API, teardown path only] [Ratio: favorable]`

## Phase 9: Synthesis

**Evidence FOR**
- Deterministic failure to clear SMB3 session keys, signing keys,
  encryption/decryption keys, and Preauth_HashValue on session destroy.
- `kfree_sensitive()` exists specifically for this; CIFS client in this
  tree already uses it for the same class of secrets.
- Two-line, obviously correct, maintainer-acked, already merged
  upstream.
- Applies cleanly to 6.12.111; no new API; no lock/data-structure
  change.
- ksmbd is a network-facing file server; leftover keys after logoff are
  real cryptographic material, not a style nit.
- Official stable rules include “a real security issue”; this is secret
  leftover in heap (CWE-226), not a feature.

**Evidence AGAINST**
- Cover letter calls it “good security practice,” not a demonstrated
  crash/CVE. No `Reported-by`, no exploit write-up.
- Official rule: no “this could be a problem” without how it is
  exploited. Direct userspace leak is not shown; it is residual data
  until slab reuse or a dump.
- Incomplete hygiene: channel objects and
  `ksmbd_preauth_session_destroy()` still use `kfree` in this file.
- `CONFIG_SMB_SERVER` defaults to n.

**Unresolved**
- No stable@ thread found (search quality limited;
  lore.kernel.org/stable returned unrelated hits).
- Semcode MCP not available; callers traced with `git grep`.

**Stable rules checklist**
1. Obviously correct and tested? **PASS** — drop-in `kfree` →
   `kfree_sensitive`; maintainer ack; applied upstream.
2. Fixes a real bug that affects users? **PASS** — session objects with
   live SMB3 keys are freed without wiping; that is leftover secret
   material on a path every ksmbd session takes.
3. Important issue? **PASS** (security: key leftover; not
   oops/deadlock). Severity is secret wipe, not a panic.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — same function body aside from
   later `delete_proc_session`, which this hunk does not need.

**Exception category:** None of ID/quirk/DT/build/docs. Security wipe of
existing allocations.

This is not a crash fix, but it is a small, obviously correct wipe of
real SMB3 key material on session teardown, the code is present in
6.12.111, and regression risk is negligible. That meets the stable bar
for a real security issue on ksmbd.

Verification:
- [Phase 1] Parsed subject/body/tags from candidate text and `git log -1
  d4a6d1c94f7a3`; maintainer Acked-by; no Fixes/Reported-by/Cc: stable
- [Phase 2] Read `ksmbd_session_destroy` and `struct ksmbd_session` in
  this tree; confirmed two `kfree` sites and key arrays
- [Phase 2] Read `kfree_sensitive()` in `mm/slab_common.c` (zeros via
  `memzero_explicit`, then `kfree`)
- [Phase 3] `git blame -L 159,175` user_session.c; introducer
  `e2f34481b24db2` contained in v5.15-rc1
- [Phase 3] `git merge-base --is-ancestor` of introducer and of
  `d4a6d1c94f7a3` vs HEAD: introducer yes, this fix no
- [Phase 3] `git log --oneline -20 --
  fs/smb/server/mgmt/user_session.c`: no prior equivalent wipe
- [Phase 4] `b4 dig -c d4a6d1c94f7a3` / `-a` / `-w`: v1 then v2; lore
  https://patch.msgid.link/20260811154620.2425851-4-thuth@redhat.com;
  Namjae applied v2; no NAK; no stable nomination
- [Phase 4] Cover letter and v1 review (preauth_session) fetched from
  openwall/lkml/patchew
- [Phase 5] `git grep ksmbd_session_destroy` / `ksmbd_user_session_put`:
  session logoff/expire/teardown/create-error
- [Phase 5] Confirmed `__session_create` uses `kzalloc`;
  `user_session.c` includes `linux/slab.h`
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] `delete_proc_session` absent here; does not block the two-
  line hunk
- [Phase 7] `CONFIG_SMB_SERVER` in `fs/smb/server/Kconfig`, default n
- [Phase 8] Failure mode: leftover session keys in slab after destroy
- UNVERIFIED: no dedicated stable@ discussion located

The two-line `kfree_sensitive()` conversion belongs in this 6.12 tree:
the buggy frees are here, the API is here, and it wipes real SMB3
session keys on teardown with negligible risk.

**YES**

 fs/smb/server/mgmt/user_session.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 3a2591434b5f8..973db0466575e 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -168,10 +168,10 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_launch_ksmbd_durable_scavenger();
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
-	kfree(sess->Preauth_HashValue);
+	kfree_sensitive(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
 	ida_destroy(&sess->tree_conn_ida);
-	kfree(sess);
+	kfree_sensitive(sess);
 }
 
 struct ksmbd_session *__session_lookup(unsigned long long id)
-- 
2.53.0

