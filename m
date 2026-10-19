Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8D6167AE;
	Mon, 19 Oct 2026 14:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418649; cv=none; b=Eln4/3ubGi5v/WQ5o2KW1ZRQ5USQ+x7lrPGWB/yJXp0KaZ6WOGlyE7HBgWzrboEqFLXyQMfQwMFTtBrnwKb1Bqti9VKWO/LIzI47UewJVD5OSbfIsqmcRsqPhC86kVkjynQkCsCFAchh+tLA07cotnB2GhiD3WjAgPbYmpzTj3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418649; c=relaxed/simple;
	bh=h28QfuKQW0s/T3nHUNG4IwJWf6u0RYiVoNZv09vhwZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqlaQy3R1JGaWM5RZkArDn4Pp2H5gJI+ywR6NmHHJ7tArc/omDSTKeZ0uuu68TiNE0tn2JPpW7PbYitBOnHoLxhEb6T/28UKrU6JfjDcaWCt3UFQSYdNlssG7rnH3T9PQt6/LEDm0MI6s5pttvnp8Gx2VXGw0Igd1aQ/l3p+gJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ag4e60XY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ag4e60XY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF94F1F000C5;
	Mon, 19 Oct 2026 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418646;
	bh=3OZNVVxxdQo5rbx1RXIX1Z+cH2R3fiOyYgS+oEmHadE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ag4e60XYGLakfiLnkR1ZfYt0vJIS0UmPeza5E/PlMj1sTGbkUTsTre5eHOXLeIyao
	 O//xl0ZUiDbJK+FosZ4Y7dobI+qp5wOL7c5Fzscwl3mbmezx6LfpeB5BxvbU3dd4xU
	 65Dm3qOTk5uhsth0siHeaKF/j+aduEf21VsxcCE02oey1WAudSbJb4en8nNZmtq1ix
	 8iqbkU/J1yAUENpV34asIpqURdGBU8jZRmJmW+gXQx6xsu7C8lKAFcPNXXreBstwB9
	 JM6nlec+CLxybQ2yfKXzcsLt9ehK6HjTZoSC5Hd+JYYlph9cwmRzzb+NP9sghEd1nO
	 V6JdXa2zmQkOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] smb: server: Make sure that passkey is not leaked on the heap in user_config.c
Date: Mon, 19 Oct 2026 09:51:28 -0400
Message-ID: <20261019135441.1420968-397-sashal@kernel.org>
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

[ Upstream commit 2c5a176882695f73b52482df03b0017b006ef2d1 ]

Use kfree_sensitive() to free the user->passkey (and the struct
ksmbd_login_response in ksmbd_login_user() that contains the same
information) to avoid that this information could leak somewhere
else via the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the NTLM passkey wipe is present in this 6.12
tree, the helpers already exist, and the change is a three-line secret-
clearing fix. Fetching the series cover letter wrapped up the remaining
mailing-list context.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[smb: server:] [Make sure] [passkey is not leaked on the heap
in user_config.c]**

- Subsystem: `smb: server:` (ksmbd in-kernel SMB3 server)
- Action verb: “Make sure” — safety/correctness language, not a feature
- Claimed intent: wipe `user->passkey` (and the IPC login response that
  holds the same hash) before returning the memory to the heap

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none on the commit itself
- **Acked-by:** none
- **Link:** none in the commit message
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Thomas Huth \<thuth@redhat.com\> (author); Namjae
  Jeon \<linkinjeon@kernel.org\> (ksmbd maintainer). Ignore any Sasha
  Levin SOB from candidate preparation.

Notable pattern: no syzbot/CVE/reporter tags. This came from a
maintainer-applied hardening series, not a crash report.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `user->passkey` and `struct ksmbd_login_response` (which
  contains `hash[]`) are freed with ordinary `kfree()`/`kvfree()`, so
  the NTLM password hash remains in the slab until the object is reused.
- **Symptom/failure mode:** heap leftover of authentication secret
  material; a later kmalloc of the same cache can return pages still
  holding the hash (classic kfree-vs-kfree_sensitive info leak).
- **Version information:** none in the message.
- **Root cause (author):** passkey-bearing objects were not cleared
  before free.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The message is explicit about a secret
leak. It is a security hygiene fix (wipe-before-free), not a crash/UAF.
Still a real bug class the kernel already treats as such via
`kfree_sensitive()`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `fs/smb/server/mgmt/user_config.c` only
- Scope: **3 substitutions, ~3 lines**, single-file surgical
- Functions: `ksmbd_login_user()`, `ksmbd_alloc_user()` error path,
  `ksmbd_free_user()`
- Surrounding mainline context in the candidate (hash_sz bounds check,
  `kmalloc_obj`) is **not** part of this commit’s semantic change; it is
  later-tree context.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. `ksmbd_login_user()` `out:` path: `kvfree(resp)` →
   `kvfree_sensitive(resp, sizeof(*resp))`. This is the **normal** login
   path (and the login-failure path). `resp` is the IPC login response
   from ksmbd.mountd and contains `hash[]`.
2. `ksmbd_alloc_user()` `err_free:`: `kfree(user->passkey)` →
   `kfree_sensitive(user->passkey)`. **Error** path after the hash was
   copied into `user->passkey`.
3. `ksmbd_free_user()`: same `kfree` → `kfree_sensitive` for
   `user->passkey`. **Normal** session teardown / reauth mismatch path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** security / sensitive-data leak (heap residual), not
  UAF/race/crash
- **Mechanism:** `resp->hash` is the NT hash (`KSMBD_REQ_MAX_HASH_SZ` is
  18; auth uses `CIFS_ENCPWD_SIZE` of 16 as HMAC-MD5 key in
  `calc_ntlmv2_hash()`). After `kfree`/`kvfree`, that hash stays in the
  slab. `kfree_sensitive()` does `memzero_explicit()` over `ksize()`
  then `kfree()`. `kvfree_sensitive()` does `memzero_explicit(addr,
  len)` then `kvfree()`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: drop-in replacement; `kfree_sensitive(NULL)` is a
  documented no-op (needed on `err_free` when `passkey` alloc failed);
  `kvfree_sensitive` skips `ZERO_OR_NULL_PTR`.
- Minimal: three call-site changes, no API/structure change.
- Regression risk: **very low**. Same free, plus a small
  `memzero_explicit`. `passkey` is ~16 bytes; `sizeof(*resp)` is a fixed
  login-response struct. No lock/order/API change.
- Incomplete vs the rest of ksmbd (auth.c still `kvfree(resp)` on the
  SPNEGO path) — that is a **sibling** series patch, not a dependency of
  this one.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `kvfree(resp)`: introduced as cifsd code in `79f6b11a104f3a` (“cifsd:
  remove wrappers of kvmalloc/kvfree”, 2021) on top of `e2f34481b24db2`
  (“cifsd: add server-side procedures for SMB3”, 2021-05-10).
- `kfree(user->passkey)` in `ksmbd_free_user()`: `822bc8ea514ecd`
  (“cifsd: use kfree to free memory allocated by kmalloc or kzalloc”,
  2021) — switched from kvfree wrappers to `kfree`.
- `kfree(user->passkey)` on `err_free`: `a77e0e02af1c2` (“ksmbd: add
  support for supplementary groups”, 2024-10-11).
- The leak has been in the SMB server **since cifsd/ksmbd was merged
  (~v5.15 era)**. Present in this 6.12 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The buggy free sites predate
this tree’s branch point and are in HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (this tree, `-- fs/smb/server/mgmt/user_config.c`):
- `c9f2872e91b9f` — leak of `ksmbd_ipc_login_request_ext()` buffer
  (already in this tree; candidate context includes `kvfree(resp_ext)`).
- `7dd0c858e1909` — ipc_validate_msg size checks
- `a77e0e02af1c2` — supplementary groups
- No existing `kfree_sensitive` conversion in this file.
- Standalone relative to later hash_sz/`kmalloc_obj` work (those strings
  are **absent** here).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Thomas Huth has **no** other commits under `fs/smb/` in this
checkout (series is newer than 6.12). Namjae Jeon is the ksmbd
maintainer and signed the patch off. Cover letter: 5-patch series “Clear
sensitive data before freeing it”; this is **v2 2/5**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `kfree_sensitive()` / `kvfree_sensitive()` — both exist in this
  tree (`include/linux/slab.h`, implemented in `mm/slab_common.c` /
  `mm/util.c`).
- Does **not** need `kmalloc_obj` or the hash_sz guard (those are only
  nearby mainline context).
- Other patches in the series (auth.c, user_session.c, connection.c,
  smb2pdu.c) are independent per-file wipes. This file’s change applies
  **standalone**.
- `user_config.c` already includes `<linux/slab.h>`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <sha>`: **not run** — the candidate SHA is not in this
  checkout (evaluating a candidate, not an in-tree commit).
- Found via search: **[PATCH v2 2/5]** Message-ID
  `20260811154620.2425851-3-thuth@redhat.com`
- Cover:
  https://patchew.org/linux/20260811154620.2425851-1-thuth@redhat.com/
- Openwall: https://lists.openwall.net/linux-kernel/2026/08/11/1820
- v2 vs v1: cover letter says v2 fixed `kvfree_sensitive` **size in
  patch 1 (auth.c)**, added a connection.c hunk, and added the smb2pdu.c
  patch. **This user_config.c patch was not the one that needed a size-
  calculation fix.**
- Namjae Jeon: “Applied them to #ksmbd-for-next-next.” No NAK found.
- Author framed it as “good security practice”; spots found with AI,
  patches written by hand; asked for careful review. Maintainer still
  applied the series.
- No reviewer `Cc: stable` found.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc from the v2 mail: Namjae Jeon (ksmbd maintainer), Steve
French (CIFS/SMB maintainer), linux-kernel, Sergey Senozhatsky, Tom
Talpey. Maintainer applied it. No separate Reviewed-by on this patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot, bugzilla, or user crash. This is proactive secret-
wipe, not a reported oops. Severity from the author: heap leftover of
passkey/hash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series of 5 independent kfree_sensitive/memzero_explicit
patches:
1. auth.c stack/heap
2. **user_config.c passkey (this one)**
3. user_session.c
4. connection.c
5. smb2pdu.c Preauth_HashValue

This patch does not depend on 1/3/4/5 applying first.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable-list hit for this passkey wipe (search did not turn up
a prior stable request or a rejection). UNVERIFIED that a later stable
thread exists beyond what search returned. lore.kernel.org fetches
returned 403 in this environment; discussion was recovered from
patchew/openwall.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `ksmbd_login_user`, `ksmbd_alloc_user`, `ksmbd_free_user`

**Step 5.2: TRACE CALLERS**

Record (this tree):
- `ksmbd_login_user()` ← `session_user()` in `fs/smb/server/smb2pdu.c` ←
  SMB2 SESSION_SETUP / `ntlm_authenticate()`. **Network-reachable** on
  every NTLM login.
- `ksmbd_alloc_user()` ← `ksmbd_login_user()` and
  `ksmbd_krb5_authenticate()` in `auth.c` (CONFIG_SMB_SERVER_KERBEROS5).
- `ksmbd_free_user()` ← session teardown in `user_session.c`; reauth
  mismatch / anonymous reuse in `smb2pdu.c`; kerberos reauth in
  `auth.c`.

**Step 5.3: TRACE CALLEES**

Record:
- `ksmbd_ipc_login_request()` → netlink to ksmbd.mountd; response
  allocated with `kvzalloc(sz)` in `handle_response()`
  (`transport_ipc.c:294`), so `kvfree`/`kvfree_sensitive` is the right
  family.
- `user->passkey = kmalloc(resp->hash_sz, ...)` then `memcpy` from
  `resp->hash` — `kfree_sensitive` is the right family.
- `calc_ntlmv2_hash()` uses `user_passkey()` as HMAC-MD5 key
  (`CIFS_ENCPWD_SIZE`). Confirmed: this is the NT hash, not a username.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Unprivileged SMB client sends SESSION_SETUP → kernel looks up
user via IPC → hash lives in `resp` then `user->passkey` → on
logout/free, hash is currently left in the slab. Path is **reachable
from the network** whenever ksmbd is enabled and serving NTLM users. Not
a syscall-from-unprivileged-local-only issue; it is a **server-side
credential residual**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: The SMB **client** in this same tree already uses
`kfree_sensitive` widely for passwords/`auth_key`
(`fs/smb/client/smb2pdu.c`, `sess.c`, `fs_context.c`, `misc.c`, …).
ksmbd server side in this tree still uses plain `kfree`/`kvfree` for
passkey (only `auth.c` has one `kfree_sensitive(ctx_arc4)`). Same bug
class, server lagging the client.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **6.12.111** (`pending-6.12`,
`p-6.12-3-gc504cf0baa3d8`).

```31:31:fs/smb/server/mgmt/user_config.c
        kvfree(resp);
```

```74:74:fs/smb/server/mgmt/user_config.c
        kfree(user->passkey);
```

```84:84:fs/smb/server/mgmt/user_config.c
        kfree(user->passkey);
```

No `kvfree_sensitive` / `kfree_sensitive` in this file today. Bug
introduced with cifsd (2021), long before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor context, not semantic.** This tree has
`kmalloc(sizeof(struct ksmbd_user), ...)` not `kmalloc_obj`, and **no**
`hash_sz > sizeof(resp->hash)` guard. The three substitution sites exist
verbatim (`kvfree(resp);` ×1, `kfree(user->passkey);` ×2). A 3-line
backport applies; a raw mainline patch with 41-line context around
`ksmbd_alloc_user` would conflict. `kvfree(resp_ext)` from
`c9f2872e91b9f` is already here, matching the candidate’s
`ksmbd_login_user` shape.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No passkey wipe already in this file. Client-side
`kfree_sensitive` does not cover ksmbd server objects.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ksmbd (CONFIG_SMB_SERVER)** under `fs/smb/server/`.
**IMPORTANT** (not core mm/VFS): optional in-kernel SMB3 server used on
NAS/embedded; default `n`. Network-facing auth path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (many recent ksmbd fixes on this branch:
OOB, ACL, session, credit). Mature enough that the passkey free path has
been stable since 2021.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **config-specific / driver-specific:** systems with
`CONFIG_SMB_SERVER` (ksmbd) and live SMB sessions. Distros that ship
ksmbd for NAS (openSUSE, some embedded, ksmbd-tools users).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: **every successful NTLM login** (`ksmbd_login_user` always
  frees `resp` containing the hash) and **every `ksmbd_free_user`**
  (session destroy / failed reauth).
- Common on any ksmbd server with password auth.
- Local unprivileged userspace does not need to call a special syscall;
  a remote SMB client causes the kernel to hold then free the hash.
  Recovering the leftover bytes still needs another heap-read primitive
  or slab reuse that exposes old contents — that is the usual
  `kfree_sensitive` threat model.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Failure mode:** NT hash residual in kmalloc/kvmalloc heap.
**Severity: HIGH** (credential/info leak; pass-the-hash material). Not a
panic. Not theoretical-only in kind: this is why `kfree_sensitive`
exists, and the CIFS client already wipes the same class of secrets.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for ksmbd users — wipes NTLM hashes that currently
  survive free on a hot auth path.
- **Risk:** VERY LOW — 3 lines, existing helpers, NULL-safe, no behavior
  change except zeroing freed secret bytes.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real leftover NT hash (`resp->hash` / `user->passkey`) on heap after
  login IPC and session free
- Reachable from SMB SESSION_SETUP on deployed ksmbd
- 3-line, obviously correct, uses APIs that exist in 6.12
- Buggy frees present in this tree since 2021
- Maintainer (Namjae Jeon) applied the series
- Same pattern already used by `fs/smb/client/` in this tree
- `kfree_sensitive(NULL)` safe on the alloc-failure path

**AGAINST:**
- Hardening / defense-in-depth, no CVE/syzbot/user report
- Part of a 5-patch series (others also wipe secrets; this file does not
  need them)
- ksmbd is optional (`default n`)
- Raw mainline hunk context includes later `kmalloc_obj` / hash_sz check
  (needs a tiny backport, not the later features)

**UNRESOLVED:**
- Could not run `b4 dig` against a local SHA (candidate not in this git
  object store)
- lore.kernel.org HTTP 403; discussion recovered from patchew/openwall
- No evidence this was previously rejected for stable

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — drop-in sensitive-free;
   maintainer applied v2.
2. Fixes a real bug that affects users? **PASS** — NTLM hash left in
   slab after ksmbd login/logout.
3. Important issue? **PASS** — security info leak of auth material
   (HIGH, not a crash).
4. Small and contained? **PASS** — 3 lines, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — sites and helpers exist;
   context tweak only (no `kmalloc_obj` required).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
**small security fix** (secret wipe), which stable regularly takes.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.12 tree. The bug is here, the
helpers are here, and the change is a surgical wipe of NTLM passkeys
that ksmbd currently leaves in the heap after every login IPC and
session free. Risk is negligible; benefit is wiping high-value
credential material on a network-facing path.

### What the commit solves for this tree

On 6.12.111 ksmbd still does `kvfree(resp)` on the login response (which
includes `hash[KSMBD_REQ_MAX_HASH_SZ]`) and `kfree(user->passkey)` after
copying that hash. Those bytes are the NT hash used as the NTLMv2 HMAC
key. Switching to `kvfree_sensitive` / `kfree_sensitive` zeros them
before the slab can reuse the object. That matches what the SMB client
in this same tree already does for passwords.

### Risk vs benefit

Benefit is wiping secrets on a common ksmbd auth path. Risk is a few
extra `memzero_explicit` bytes on free. No locking, no API, no control-
flow change.

### Concerns

A verbatim mainline apply may need a 3-line backport because this tree
lacks `kmalloc_obj` and the later `hash_sz` cap; those are **not**
prerequisites. Sibling series patches (auth.c SPNEGO `kvfree(resp)`,
session/connection/preauth) are independent and do not block this file’s
fix.

Verification:
- [Phase 1] Parsed subject/body/tags: no Fixes/Reported-by/Cc:stable;
  SOBs Thomas Huth + Namjae Jeon
- [Phase 2] Diff: 3 substitutions in user_config.c; `kvfree(resp)` and
  two `kfree(user->passkey)`
- [Phase 2] Confirmed `KSMBD_REQ_MAX_HASH_SZ` is 18 and
  `calc_ntlmv2_hash()` uses `user_passkey()` as HMAC-MD5 key
  (`CIFS_ENCPWD_SIZE` 16)
- [Phase 3] `git blame`: `kvfree(resp)` from 2021 cifsd
  (`79f6b11a104f3a` / `e2f34481b24db2`); passkey `kfree` from
  `822bc8ea514ecd` / `a77e0e02af1c2`
- [Phase 3] `git merge-base --is-ancestor` of those SHAs vs HEAD: all
  present (exit 0)
- [Phase 3] `git log --author="Thomas Huth" -- fs/smb/`: empty in this
  tree (series is newer)
- [Phase 4] Patchew/openwall: v2 2/5 of “Clear sensitive data before
  freeing it”; Namjae applied to ksmbd-for-next-next; no NAK
- [Phase 4] lore.kernel.org WebFetch: 403; b4 dig: no local candidate
  SHA — discussion recovered from patchew/openwall
- [Phase 5] Callers: `smb2pdu.c` SESSION_SETUP
  `session_user()`/`ntlm_authenticate()`, `auth.c` krb5 path,
  `user_session.c` teardown
- [Phase 5] `handle_response()` uses `kvzalloc` — `kvfree_sensitive` is
  the correct free family
- [Phase 6] `git describe HEAD` / `make kernelversion`: **6.12.111**
  (`pending-6.12`); buggy kfree/kvfree still in file;
  `kfree_sensitive`/`kvfree_sensitive` declared in
  `include/linux/slab.h`
- [Phase 6] Local file has no `kmalloc_obj` / hash_sz cap; three target
  call sites exist verbatim
- [Phase 8] Failure mode: NT-hash residual in heap after login/free;
  severity HIGH; regression risk very low
- UNVERIFIED: full lore mailbox / b4 patch-id match; whether a later CVE
  was assigned

**YES**

 fs/smb/server/mgmt/user_config.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index 0e5fcd6f95c15..909f219c79faa 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -28,7 +28,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 	user = ksmbd_alloc_user(resp, resp_ext);
 	kvfree(resp_ext);
 out:
-	kvfree(resp);
+	kvfree_sensitive(resp, sizeof(*resp));
 	return user;
 }
 
@@ -82,7 +82,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 
 err_free:
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 	return NULL;
 }
@@ -92,7 +92,7 @@ void ksmbd_free_user(struct ksmbd_user *user)
 	ksmbd_ipc_logout_request(user->name, user->flags);
 	kfree(user->sgid);
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 }
 
-- 
2.53.0

