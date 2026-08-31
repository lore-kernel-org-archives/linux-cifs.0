Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900F521217;
	Mon, 31 Aug 2026 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183848; cv=none; b=UsDJnJmp3yca8x4HVsefkVo74pDdEerMVHK16arwUH7WAFVgF+cdfz6pJQ065VhOjBzFX0y9VyL+7O0u78TrXJPwSXOQ49N6zRUjxuz2nInwHgNrz76ng9R/ebw6s7tnpnuRa9RAyR3q4rTCgr5Subv4UnSNAA7e0pK/k9K1aYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183848; c=relaxed/simple;
	bh=fbb/XzSo55vj3huuzwL2yEi5LA7bnlJyMuDd806RsXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZUFi2WaN7HDluQ/jx+wYjaRF2Em54jOFOlD5KXr9rbqDpfozAib8X+gTOCGpNtf2syCgKfB9GJ7a3zgokodqEM2ORSkMNI3Aw26dqjeYsuBlYAyBqBaLIz9FRnsZwMwqXOCYFCAF4CV2jZfoUBUq/DyvDn8E7Iayhyno1+Bi/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPUj4WCk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPUj4WCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E921E1F00A3E;
	Mon, 31 Aug 2026 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183845;
	bh=oZi5SHoqJrChRZg5EFnfIQx80XMngEC5PQOBfym6q5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPUj4WCktOR7tmCsYvnnxphwHXaUIei8OOQNs5Qi8SrbpwuN0mcbr3p2odBorYnmS
	 78OaG4CYkQtgx6tYBOtj9J4BB+h95Ecy+7NNIhhOqMRYmMEGesCMoe1J8Up9KMzgd6
	 X+ouJK0ervJ+EmWSAG4KNE/DO5fQRFarvA+0mQeYMQnrwWYNqj9p5MT6R+kv46+RMq
	 HwI0otGncIZvW6+nGbe05EOo+BXws09YGRuny0MhYDwhkrvpRBX78WbWwurqibQv5G
	 dtVe2qc9vCMp2fn8XYDSC5uAbu/Gr8DtC4Gy2bNcsWttCQuSgaU7qnSNK8DeTJSs0F
	 r5JyZ3qsQZtyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] cifs: validate idmap key payload length
Date: Mon, 31 Aug 2026 09:26:06 -0400
Message-ID: <20260831133314.4125787-338-sashal@kernel.org>
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 455488cd5054bcc59db40fa1cc2c004031a5b2a5 ]

The cifs.idmap key type stores its payload length in key->datalen, which
is limited to U16_MAX.  Accepting a larger key payload truncates the
recorded length and can make later users interpret the payload using
inconsistent bounds.

Reject oversized preparsed payloads before allocating or copying them.
This keeps key->datalen consistent with the stored data for both inline
and separately allocated idmap payloads.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[cifs] [validate] validate idmap key payload length` —
subsystem is CIFS/SMB client idmap keys; action is validation/rejection
of oversized payloads.

### Step 1.2: Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected for manual review)
- **Signed-off-by:** Li Qiang `<liqiang01@kylinos.cn>`, Steve French
  `<stfrench@microsoft.com>` (maintainer sign-off)

No syzbot, no fuzzer report, no explicit stable nomination in the
message.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `cifs.idmap` stores payload length in `key->datalen`, which
  is `unsigned short` (max `U16_MAX`). `prep->datalen` is `size_t` and
  can be larger.
- **Symptom:** Oversized payloads are copied/allocated at full
  `prep->datalen`, but `key->datalen` is silently truncated on
  assignment.
- **Failure mode:** Later code uses truncated `key->datalen` for inline-
  vs-heap selection and bounds checks, while storage was sized for the
  full payload — inconsistent bounds.
- **Fix:** Reject `prep->datalen > U16_MAX` before allocation/copy.
- **Version info:** none in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although labeled “validate”, this is a real memory-
safety / correctness bug fix, not cosmetic cleanup. The inline-vs-heap
optimization makes truncation especially dangerous.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/client/cifsacl.c` (+3 lines)
- **Function:** `cifs_idmap_key_instantiate()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Any `prep->datalen` accepted; full payload
  copied/allocated; `key->datalen = prep->datalen` truncates values >
  65535.
- **After:** Oversized payloads rejected with `-EINVAL` before any
  copy/allocation or length assignment.
- **Path affected:** Key instantiation for `cifs.idmap` keys from
  userspace upcall responses.

### Step 2.3: Bug mechanism
**Record:** **Memory safety / logic correctness bug** caused by `size_t`
→ `unsigned short` truncation.

Concrete failure in this tree:

1. `union key_payload` is 32 bytes on 64-bit (`void *data[4]`).
2. If `prep->datalen = 65552` (65536+16):
   - Instantiate uses **heap** path (`65552 > 32`), `kmemdup()`
     allocates full size, `key->payload.data[0]` holds pointer.
   - `key->datalen` becomes `16` (truncated).
3. In `id_to_sid()`:

```314:316:fs/smb/client/cifsacl.c
        ksid = sidkey->datalen <= sizeof(sidkey->payload) ?
                (struct smb_sid *)&sidkey->payload :
                (struct smb_sid *)sidkey->payload.data[0];
```

   Truncated `datalen=16` selects **inline** path, but real data is on
the heap. `cifs_copy_sid()` then interprets union bytes (including the
stored pointer) as a SID and can read past the 32-byte union based on
crafted `num_subauth`.

4. In `cifs_idmap_key_destroy()`:

```97:98:fs/smb/client/cifsacl.c
        if (key->datalen > sizeof(key->payload))
                kfree(key->payload.data[0]);
```

   Truncated `datalen` can skip `kfree()` → memory leak.

### Step 2.4: Fix quality
**Record:** Obviously correct and minimal. Matches validation patterns
in other key types (`user_preparse()` rejects `datalen > 32767`). Very
low regression risk; only rejects pathological oversized payloads that
cannot be represented correctly anyway.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `cifs_idmap_key_instantiate()` lines blame to merge commit
`5d324e5159d9e` in this checkout (shallow history). The function and
inline/heap logic are present in the current `6.18.44` tree without the
fix. `key->datalen` has been `unsigned short` in `include/linux/key.h`
for a long time.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent related hardening already in this tree:
- `ff0ca46b13b9e` — validate whole DACL before rewriting
- `c688f3ed73d31` — validate `dacloffset`
- `38a69f08ee82c` — require full NFS mode SID
- `86c5d470f5d42` — harden POSIX SID length parsing

This fix fits the same security-hardening theme in `cifsacl.c`.
Standalone; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Li Qiang submitted the patch. Steve French (CIFS maintainer)
signed off. No other commits from this author on this file visible in
this checkout.

### Step 3.5: Dependencies
**Record:** None. Uses `U16_MAX` (available via kernel include chain;
already used in `fs/smb/client/smbdirect.c`). Patch applies cleanly
(`git apply --check` succeeded). No prerequisite commits required.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** Found via openwall mirror: https://lists.openwall.net/linux-
kernel/2026/07/18/621
Message-ID: `<20260718162228.193366-1-liqiang01@kylinos.cn>`, dated
2026-07-19.
Ratatoskr shows thread as **DORMANT / no replies**. `b4 dig -c <hash>`
could not be run — commit hash not available in this checkout.

### Step 4.2: Reviewers
**Record:** CC list included `linux-cifs@`, `samba-technical@`, `linux-
kernel@`, Steve French. No public review thread found. Maintainer sign-
off present in the candidate commit message.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or CVE referenced.

### Step 4.4: Related patches
**Record:** Related historical work: `cifs: extra sanity checking for
cifs.idmap keys` (Jeff Layton) added `ksid_size > sidkey->datalen`
checks in `id_to_sid()` — those checks assume `sidkey->datalen` is
trustworthy. This commit closes the gap where `datalen` itself can be
wrong.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found for this specific patch.
UNVERIFIED whether it already landed in a newer `6.18.y` release after
`.44`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `cifs_idmap_key_instantiate()`, `cifs_idmap_key_destroy()`,
consumers `id_to_sid()`, `sid_to_id()`.

### Step 5.2: Callers
**Record:** `id_to_sid()` and `sid_to_id()` call
`request_key(&cifs_idmap_key_type, ...)` during CIFS UID/GID ↔ SID
mapping. Triggered during normal CIFS file operations on mounts using
idmapping (`init_cifs_idmap()` registers the key type at module init).

### Step 5.3: Callees
**Record:** `kmemdup()`, `memcpy()`, `key->datalen` assignment.
Instantiate is called from the key subsystem when userspace idmap helper
responds to `request_key()` upcall.

### Step 5.4: Reachability
**Record:** Reachable on CIFS mounts with idmapping enabled
(`CONFIG_CIFS`). Any file operation requiring SID/UID translation can
trigger the upcall path. Payload is supplied by the userspace idmap
helper; a malicious or buggy helper returning >64 KiB can trigger the
bug.

### Step 5.5: Similar patterns
**Record:** Other key types validate payload size in `preparse()`
(`user_preparse`: max 32767; `trusted_core`: max 32767; `big_key`: max 1
MiB). `cifs.idmap` lacked any upper bound check.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is `v6.18.44` (`VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`). `cifs_idmap_key_instantiate()` at lines
67–91 lacks the `U16_MAX` check. `key->datalen` is `unsigned short` per
`include/linux/key.h:217`.

### Step 6.2: Backport complications
**Record:** **Clean apply** to `fs/smb/client/cifsacl.c`. This tree uses
the `fs/smb/client/` path (not legacy `fs/cifs/`). No conflicts
expected.

### Step 6.3: Related fixes already present?
**Record:** Related SID/DACL validation fixes are present; this specific
`U16_MAX` validation is **not** present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — SMB/CIFS client (`fs/smb/client`),
filesystem driver used in enterprise/embedded deployments with network
file access.

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent security hardening
commits in `cifsacl.c` in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_CIFS` mounts with UID/GID idmapping
(userspace `cifs.idmap` upcall). Not universal, but real production
configuration.

### Step 8.2: Trigger conditions
**Record:** Userspace idmap helper instantiates a `cifs.idmap` key with
`prep->datalen > 65535`. Unusual but possible from a compromised/buggy
helper. Not a typical remote network attack by itself, but kernel must
not trust oversized helper input.

### Step 8.3: Failure mode severity
**Record:**
- Wrong inline/heap selection → misinterpreted SID data, potential out-
  of-bounds read in `cifs_copy_sid()` — **HIGH**
- Skipped `kfree()` in destroy → memory leak — **MEDIUM**
- Inconsistent bounds checks undermining prior `id_to_sid()` validation
  — **HIGH**

Overall: **HIGH** for a kernel memory-safety issue in a trust-boundary
path (kernel ↔ userspace key payload).

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** HIGH — closes a real truncation bug at the trust
  boundary; complements existing SID validation.
- **Risk:** VERY LOW — 3-line bounds check, rejects only invalid inputs.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: `size_t` payload length truncated into `unsigned short
  key->datalen`
- Causes inline/heap mismatch, broken bounds logic, and memory leak
- Small, obviously correct, maintainer-signed
- Applies cleanly to this `6.18.44` tree
- Consistent with other key-type validation and recent CIFS hardening in
  same file
- Fixes trust-boundary input validation gap

**AGAINST backport:**
- No syzbot/CVE/user report
- Requires unusual >64 KiB idmap payload from userspace helper
- No public review discussion found (DORMANT thread)

**UNRESOLVED:**
- Exact mainline commit hash not in this checkout
- Whether a later `6.18.y` release already contains it (not in `.44`)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial validation;
   maintainer SOB; no Tested-by but logic is self-evident.
2. Fixes a real bug affecting users? **PASS** — truncation with concrete
   failure modes on CIFS idmap mounts.
3. Important issue? **PASS** — kernel memory-safety / inconsistent
   bounds at userspace trust boundary (HIGH).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features/APIs? **PASS** — input validation only.
6. Can apply to local tree? **PASS** — verified with `git apply
   --check`.

### Step 9.3: Exception category
**Record:** None of the hardware-quirk/build-fix exceptions apply. This
is a standard security/correctness bug fix.

### Step 9.4: Decision rationale
This commit should be backported to **this** `6.18.44` tree. The buggy
code is present, the failure mode is serious (truncated length breaks
inline/heap selection and destroy logic), the fix is minimal and matches
established key-subsystem practice, and it fits the ongoing CIFS ACL/SID
hardening already landing in stable.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided
  candidate; cross-checked openwall mirror.
- **[Phase 2]** Read `cifs_idmap_key_instantiate()`,
  `cifs_idmap_key_destroy()`, `id_to_sid()` in
  `fs/smb/client/cifsacl.c`.
- **[Phase 2]** Verified `key->datalen` is `unsigned short` in
  `include/linux/key.h:217`.
- **[Phase 2]** Verified `prep->datalen` is `size_t` in
  `include/linux/key-type.h:36`.
- **[Phase 2]** Verified `union key_payload` is `void *data[4]` (32
  bytes on 64-bit) in `include/linux/key.h:134-137`.
- **[Phase 3]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`.
- **[Phase 3]** `git blame` on `cifs_idmap_key_instantiate()` — function
  present without fix.
- **[Phase 3]** Found related hardening commits: `ff0ca46b13b9e`,
  `c688f3ed73d31`, `38a69f08ee82c`, `86c5d470f5d42`.
- **[Phase 3]** `git apply --check` — patch applies cleanly.
- **[Phase 4]** WebFetch openwall: https://lists.openwall.net/linux-
  kernel/2026/07/18/621 — original submission found.
- **[Phase 4]** WebFetch ratatoskr — thread DORMANT, no replies.
- **[Phase 4]** `b4 dig -c <hash>` — **UNVERIFIED** (commit hash
  unavailable in checkout).
- **[Phase 5]** Grep callers: `request_key(&cifs_idmap_key_type)` in
  `id_to_sid()` / `sid_to_id()`.
- **[Phase 5]** Compared with `user_preparse()` size validation in
  `security/keys/user_defined.c:64`.
- **[Phase 6]** Confirmed fix absent in current tree; `U16_MAX` defined
  in `include/linux/limits.h:18`, used elsewhere in
  `fs/smb/client/smbdirect.c`.
- **[Phase 6]** Confirmed `cifs_idmap_key_instantiate()` does not call
  `key_payload_reserve()`.
- **[Phase 8]** Traced inline/heap mismatch scenario with
  `prep->datalen=65552`, truncated `datalen=16`.

**YES**

 fs/smb/client/cifsacl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 92ee03cd01b39..50cf6345975e3 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -69,6 +69,9 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 
+	if (prep->datalen > U16_MAX)
+		return -EINVAL;
+
 	/*
 	 * If the payload is less than or equal to the size of a pointer, then
 	 * an allocation here is wasteful. Just copy the data directly to the
-- 
2.53.0

