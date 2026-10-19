Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF85560FEEC;
	Mon, 19 Oct 2026 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418624; cv=none; b=fMeKbD4AdxiKltxK5zTKxIqg1AogZycVyqGiUyODMVnfUXgMweUsMcEWEehUq2HcREiDQeO91Yaofp+MazLKMFaPeIxzdB6V6/AuG5CfoFeGMBcvpCiMQqua9Uyi9rVLdfn/PZEMEUurwLKQ9BaBK6MyAf+UYMoX4p5ku8ujSns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418624; c=relaxed/simple;
	bh=HFPDjsmkDaFNueVcRLv5yIDSYQxUXS4BARS7ATXhhXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g6AnNafybWQr76VYK0oVa0B5OOP0ePGRDPWlG1Er0wuai8glXHYR+qvllCt5wW07mLgCMZj3pneV527V8FKtaqAY+uzC6dQE1IKksKKhlGDlYw37GDzZ6qmVVp0v73M6QCY0LDLT5KyyLjiljNlD0aBuiNaPsG2Zo6H07e4Hylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ic5U0hdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ic5U0hdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08DC1F000C6;
	Mon, 19 Oct 2026 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418621;
	bh=AlwlwgS9Y/I1s9P3UBBS2X0yBOzNwOax0VPJjy3Gpso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ic5U0hdhyfJSL8Bmf/OmLcJlklKIZLK0dXyBU+Eejy5ti5zkOdYY6jI3ovuVg3Uuy
	 kkzUA9OCXQ4SffyoHVpMorLbFjitEG1DGnqrqDHonLkVh5VVMX9r75grzr81RekIm3
	 wsRzYsT01WmTeyG7U0czwbP7Zqk7dKijXerqzkA3SKbGVtRQn3QJR2tsl/vF/srh72
	 7KDkqF360H6IW5Jk45f/YHtWFPU18pVSTVLoGGo5HVWyPzIzjxCO3xFzbWtO4apwr7
	 cwxqSKZI1/6Vt3AKyLCppahWUEILWPP9gvuVA0werf4RQjl+GPK3dxCoHYm97QiF8N
	 WcA+2BADbzNeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: fix heap out-of-bounds write in krb5_authenticate()
Date: Mon, 19 Oct 2026 09:51:10 -0400
Message-ID: <20261019135441.1420968-379-sashal@kernel.org>
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

From: Ilan Dudnik <ilan.dudnik@safebreach.com>

[ Upstream commit 23a0be6a84a38ac169eeab49017934e8e27c65f0 ]

In krb5_authenticate(), out_len is calculated to determine available
headroom in response_buf for the incoming Kerberos AP-REP token. However,
when SMB2_SESSION_SETUP is processed as a non-first element of a compounded
SMB2 request, the calculation omits work->next_smb2_rsp_hdr_off.

This causes out_len to overstate remaining buffer headroom by
the cumulative size of prior responses in the compound chain. Consequently,
the length check in ksmbd_krb5_authenticate()
(*out_len <= resp->spnego_blob_len) passes erroneously, allowing memcpy()
to write the AP-REP blob past the end of response_buf into adjacent kernel
heap memory.

Fix this by subtracting work->next_smb2_rsp_hdr_off when computing out_len,
ensuring it accurately reflects physical remaining buffer space.

Signed-off-by: Ilan Dudnik <ilan.dudnik@safebreach.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `out_len`
math is present, and the one-line heap-OOB fix applies here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ksmbd] [fix] heap out-of-bounds write in krb5_authenticate()`
- Subsystem: ksmbd (in-kernel SMB3 server)
- Action verb: **fix**
- Claimed intent: stop a heap OOB write while building a Kerberos AP-REP
  in `krb5_authenticate()`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Upstream commit: `23a0be6a84a38ac169eeab49017934e8e27c65f0` (verified
via `git show` on `origin/master`)

Tags present:
- Signed-off-by: Ilan Dudnik \<ilan.dudnik@safebreach.com\> (author;
  SafeBreach threat research)
- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd
  maintainer, committer)

Tags absent (expected for this review pipeline):
- No `Fixes:`
- No `Cc: stable@vger.kernel.org`
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:` /
  `Link:`

Notable: author is a security researcher; the ksmbd maintainer applied
the patch directly.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `out_len` is computed from `work->response_sz` minus
  `SecurityBufferOffset + 4`, and does not subtract
  `work->next_smb2_rsp_hdr_off`.
- **When:** SMB2 `SESSION_SETUP` as a **non-first** compound command
  (`next_smb2_rsp_hdr_off > 0`).
- **Symptom:** `out_len` overstates remaining heap by the size of prior
  compound responses. `ksmbd_krb5_authenticate()` then accepts a blob
  that does not actually fit, and `memcpy()` writes the AP-REP past
  `response_buf`.
- **Failure mode:** kernel **heap out-of-bounds write**.
- **Version info in message:** none. Code has been this way since ksmbd
  was added.
- **Root cause:** remaining-space calculation uses the start of the
  allocation, not the current compound slot.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit heap-OOB write fix. Not cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/smb/server/smb2pdu.c` — **+1 / -1** (one line)
- Function: `krb5_authenticate()`
- Scope: **single-file surgical fix**

```2160:2164:fs/smb/server/smb2pdu.c
        out_blob = (char *)&rsp->hdr.ProtocolId +
                le16_to_cpu(rsp->SecurityBufferOffset);
- out_len = work->response_sz -
+       out_len = work->response_sz - work->next_smb2_rsp_hdr_off -
                (le16_to_cpu(rsp->SecurityBufferOffset) + 4);
```

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `out_len = response_sz - (SecurityBufferOffset + 4)` =
  space from the **start** of the SMB payload to the end of the
  allocation.
- **After:** also subtract `next_smb2_rsp_hdr_off`, i.e. space from the
  **current** compound response to the end of the allocation.
- Path: Kerberos `SESSION_SETUP` after
  `ksmbd_ipc_spnego_authen_request()` succeeds, immediately before
  `memcpy(out_blob, ...)`.
- First-in-compound (`next_smb2_rsp_hdr_off == 0`): behavior unchanged.

Verified layout in this tree:
- `ksmbd_resp_buf_next()` = `response_buf + next_smb2_rsp_hdr_off + 4`
- `WORK_BUFFERS` uses that for non-first compound commands
- `out_blob = rsp + SecurityBufferOffset`
- Remaining bytes = `response_sz - next_smb2_rsp_hdr_off -
  SecurityBufferOffset - 4`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** (d) memory safety — heap buffer overflow / OOB write
- **Mechanism:** length check `*out_len <= resp->spnego_blob_len` in
  `ksmbd_krb5_authenticate()` uses an inflated `out_len`. Check passes;
  `memcpy(out_blob, resp->payload + session_key_len,
  resp->spnego_blob_len)` writes off the end of `response_buf`.
- Confirmed memcpy in this tree:

```533:572:fs/smb/server/auth.c
        if (*out_len <= resp->spnego_blob_len) {
                ksmbd_debug(AUTH, "buf len %d, but blob len %d\n",
                            *out_len, resp->spnego_blob_len);
                retval = -EINVAL;
                goto out;
        }
        ...
        memcpy(out_blob, resp->payload + resp->session_key_len,
               resp->spnego_blob_len);
```

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: remaining space must exclude prior compound
  responses.
- Minimal: one term added to one expression.
- Regression risk: **very low**.
  - First command: `next_smb2_rsp_hdr_off` is 0 (work is zeroed).
  - If `out_len` goes negative, `*out_len <= blob_len` is true →
    `-EINVAL`, no memcpy (fail closed).
- No API/data-structure/locking changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `out_len = work->response_sz -` introduced in `e2f34481b24db2`
  (“cifsd: add server-side procedures for SMB3”, 2021-05-10). Ancestor
  of HEAD.
- Offset term `(SecurityBufferOffset + 4)` from `cb4517201b8acd`
  (“ksmbd: remove smb2_buf_length in smb2_hdr”, 2021-11-11).
- Bug has been in ksmbd since it entered the kernel (~5.15), including
  6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is `e2f34481b24db2`, present in this
tree (`git merge-base --is-ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `98422bdd4cb3c` “ksmbd: fix out of bounds read in smb2_sess_setup” (in
  this tree): compound `SESSION_SETUP` used `smb2_get_msg()` on the
  **start** of the buffer → OOB **read**. ZDI-CAN-21355. They passed
  `req`/`rsp` from `WORK_BUFFERS` but **did not** fix `out_len`.
- Other compound OOB fixes already in 6.12 (`smb2_get_ea`, `QUERY_INFO`,
  `get_file_all_info`) show this class of bug is real and has been
  backported before.
- This commit is standalone (not `N/M`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Ilan Dudnik: two ksmbd security fixes in 7.3 (`23a0be6a84a38` and
  `29f74f0f2e6df` UAF/double-free in lock publishing). Not a regular in-
  tree 6.12 contributor.
- Namjae Jeon is the ksmbd maintainer and committed this.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Mainline `krb5_authenticate()` later grew `channel_key` / `auth_key`;
  **6.12 does not have those**. The changed `out_len` lines are the
  same.
- `next_smb2_rsp_hdr_off` exists in `ksmbd_work.h` here.
- `git show 23a0be6a84a38 | git apply --check` **succeeds** on this
  tree.
- Standalone: **yes**.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 23a0be6a84a38`: lore returned errors; no thread match.
- `curl` lore linux-cifs / all for `Ilan Dudnik` and `krb5_authenticate
  heap`: **no public thread**.
- Likely private maintainer submission (typical for a security-firm heap
  overflow).
- Landed via ksmbd-for-7.3-rc1 pull (Namjae Jeon, 2026-08-23). Pull
  text: “Fix heap out-of-bounds accesses … in authentication, Kerberos
  …”.
- Contained in `v7.3-rc1~77^2~32`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: No public review trail. Signed off and committed by Namjae Jeon
(MAINTAINERS: KERNEL SMB3 SERVER). That is maintainer-acked.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/CVE found for **this** heap OOB (other 2026
ksmbd CVEs are different bugs). Author affiliation is independently
verified (SafeBreach). UNVERIFIED: no public reproducer.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-author sibling `29f74f0f2e6df` is a different bug (lock
UAF). This `out_len` change does not depend on it.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore/stable hits are **other** ksmbd OOB patches (ZDI compound
sess_setup OOB-read; stack channel_key overflow). **This** commit is not
on stable@ yet. The 2023 compound sess_setup OOB-read **was**
backported, which supports backporting this related compound-buffer bug.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `krb5_authenticate()` (caller of `ksmbd_krb5_authenticate()`).

**Step 5.2: TRACE CALLERS**
Record:
- Only caller: `smb2_sess_setup()` when `preferred_auth_mech` includes
  `KSMBD_AUTH_KRB5 | KSMBD_AUTH_MSKRB5`.
- `smb2_sess_setup` is the SMB2 SESSION_SETUP handler (`server.c`
  `__process_request` loop).
- Compound: after each command, `is_chained_smb2_message()` advances
  `next_smb2_rsp_hdr_off`.
- `smb2_check_user_session()` returns 0 for SESSION_SETUP **without**
  requiring a session, so SESSION_SETUP as a later compound element is
  allowed.

**Step 5.3: TRACE CALLEES**
Record: `ksmbd_krb5_authenticate()` →
`ksmbd_ipc_spnego_authen_request()` (netlink to ksmbd.mountd) → length
check → `memcpy` of AP-REP into `out_blob`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Reachable from the network on a ksmbd share with Kerberos
  (`CONFIG_SMB_SERVER_KERBEROS5`).
- `memcpy` runs only after userspace reports `KSMBD_USER_FLAG_OK`
  (successful Kerberos).
- Trigger is still realistic: compound a large command (e.g.
  `QUERY_DIRECTORY` / `IOCTL`, which use `large_sz = 448 +
  max_trans_size` with `max_trans_size` typically 1MB) then Kerberos
  `SESSION_SETUP`.
- `is_chained_smb2_message()` continues while remaining ≥
  `MAX_CIFS_SMALL_BUFFER_SIZE` (**448**). After a ~72-byte SESSION_SETUP
  header, ~376 bytes remain for the blob.
- `spnego_blob_len` is `__u16`; IPC request blobs are capped at
  `KSMBD_IPC_MAX_PAYLOAD` (4096). A typical AP-REP is hundreds to
  thousands of bytes — larger than 376, smaller than the inflated
  `out_len`.
- Userspace-reachable: **yes** (SMB client with Kerberos). Unprivileged
  remote without tickets: memcpy does not run (auth fails first).
  Authenticated Kerberos user: **yes**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record:
- `smb2_resp_buf_len()` correctly uses `get_rfc1002_len(response_buf)`
  for remaining space (QUERY_DIR/INFO). Kerberos setup does not.
- `ntlm_negotiate()` `memcpy(rsp->Buffer, spnego_blob, spnego_blob_len)`
  has no remaining-space check (separate issue, not this commit).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `fs/smb/server/smb2pdu.c` lines 1616–1617:

```
        out_len = work->response_sz -
                (le16_to_cpu(rsp->SecurityBufferOffset) + 4);
```

`git merge-base --is-ancestor 23a0be6a84a38 HEAD` → **not in this tree**
(exit 1).
Bug introduced ~v5.15 (`e2f34481b24db2`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git apply --check` of `23a0be6a84a38`
succeeded. Surrounding `krb5_authenticate()` is simpler than mainline
(no `channel_key`/`auth_key`); the `out_len` lines match.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Compound `req`/`rsp` pointer fix (`98422bdd4cb3c`) is here; it
does **not** correct `out_len`. No substitute for this overflow.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record:
- Subsystem: `fs/smb/server` (ksmbd)
- Criticality: **IMPORTANT** — network-facing file server. Not core
  mm/VFS, but historically a high-CVE surface; enterprise/NAS use.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained. Many 6.12 ksmbd security backports already
on this branch. Kerberos path is `#ifdef CONFIG_SMB_SERVER_KERBEROS5`
(`default n`).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: ksmbd servers with `CONFIG_SMB_SERVER_KERBEROS5=y`
(AD/Kerberos). Config- and driver-specific, not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Compound SMB2 with SESSION_SETUP not first, Kerberos selected,
  userspace auth success, AP-REP larger than **actual** remaining heap.
- Common Windows `NEGOTIATE+SESSION_SETUP` often still has ~1MB
  remaining, so a small AP-REP may fit — **not** the only case.
- Crafted compound that leaves ~448 bytes (allowed by
  `is_chained_smb2_message`) **does** overflow for a normal-sized
  ticket.
- Unprivileged unauthenticated remote: memcpy not reached (UNVERIFIED as
  a pre-auth RCE).
- Authenticated Kerberos client: **yes** (reauth after a large compound
  command).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure mode: heap OOB write → memory corruption, oops/panic, possible
  code execution in ksmbd workqueue context.
- Severity: **CRITICAL** (network-facing heap write). Same class as
  prior ksmbd stable CVEs.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **very high** for Kerberos ksmbd (stops kernel heap
  corruption).
- Risk: **very low** (1 line, first-command path unchanged, fail-closed
  if `out_len` is negative).
- Ratio: strongly in favor of backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real heap OOB write on a documented, previously attacked compound
  SESSION_SETUP path (ZDI-CAN-21355 was the OOB-read sibling).
- Network-facing ksmbd; memcpy after a broken length check.
- One-line, obviously correct, applies cleanly to 6.12.111.
- Bug present since ksmbd introduction; maintainer-signed; in v7.3-rc1.
- Fail-closed if `out_len` becomes negative.
- Author is a professional vulnerability researcher.

AGAINST:
- Kerberos is `default n`; only those builds.
- memcpy requires successful Kerberos (not a trivial pre-auth spray).
- No public lore thread, syzbot report, or CVE **for this SHA**
  (UNVERIFIED as assigned CVE).
- Happy-path NEGOTIATE+SESSION_SETUP may not overflow if the AP-REP fits
  in leftover 1MB.

UNRESOLVED:
- No public reproducer (lore empty; b4 failed).
- No CVE number found for this exact bug.

Those gaps do not outweigh a verified heap write with a one-line fix.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — arithmetic matches buffer
   layout; maintainer applied it; first-command behavior unchanged.
2. Fixes a real bug that affects users? **PASS** — compound Kerberos
   SESSION_SETUP overstates headroom; memcpy OOB is in this tree.
3. Important issue? **PASS** — heap OOB write / memory corruption
   (CRITICAL).
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   buggy code present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not ID/quirk/DT/docs. Ordinary security bugfix; no exception
needed.

**Step 9.4: MAKE YOUR DECISION**
This is a one-line remaining-space correction that stops a kernel heap
overflow in ksmbd’s Kerberos session-setup path. The buggy calculation
exists in 6.12.111, the patch applies cleanly, and the downside is
negligible. It belongs in this stable tree.

Verification:
- [Phase 1] Parsed message/tags: SOB Dudnik + Namjae Jeon; no Fixes/Cc
  stable/Reported-by. SHA `23a0be6a84a38ac169eeab49017934e8e27c65f0`.
- [Phase 1] `git show --no-walk --format=fuller 23a0be6a84a38`:
  AuthorDate 2026-08-07, CommitDate 2026-08-17, committer Namjae Jeon.
- [Phase 2] Diff: one line in `krb5_authenticate()` adding `-
  work->next_smb2_rsp_hdr_off`.
- [Phase 2] Read local `ksmbd_resp_buf_next` / `WORK_BUFFERS` /
  `ksmbd_krb5_authenticate` memcpy; remaining-space formula matches the
  fix.
- [Phase 3] `git blame -L 1610,1630 fs/smb/server/smb2pdu.c`: out_len
  from `e2f34481b24db2` (2021).
- [Phase 3] `git merge-base --is-ancestor e2f34481b24db2 HEAD` → 0
  (present). `23a0be6a84a38` → 1 (not in this tree).
- [Phase 3] Related: `98422bdd4cb3c` compound sess_setup OOB-read (ZDI-
  CAN-21355) is in this tree; does not fix out_len.
- [Phase 4] `b4 dig -c 23a0be6a84a38`: lore errors, no match.
- [Phase 4] lore.kernel.org linux-cifs/all: no Ilan Dudnik / this
  subject thread.
- [Phase 4] ksmbd-for-7.3-rc1 pull lists this commit under heap-
  OOB/Kerberos security fixes; `git describe --contains` →
  `v7.3-rc1~77^2~32`.
- [Phase 4] lore/stable: other ksmbd OOB backports, not this SHA.
- [Phase 5] `krb5_authenticate` only from `smb2_sess_setup`;
  SESSION_SETUP skips session check; compound loop in `server.c` +
  `init_chained_smb2_rsp`.
- [Phase 5] `MAX_CIFS_SMALL_BUFFER_SIZE` 448; `SMB3_DEFAULT_TRANS_SIZE`
  1MB; `spnego_blob_len` is `__u16`; IPC request cap 4096.
- [Phase 6] Local tree: `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`;
  `make kernelversion` → **6.12.111**.
- [Phase 6] Buggy out_len at smb2pdu.c:1616-1617; `git apply --check` of
  23a0be6a84a38 **clean**.
- [Phase 7] MAINTAINERS: Namjae Jeon + Steve French, linux-cifs.
- [Phase 8] Heap OOB write after successful Kerberos on compound
  SESSION_SETUP; severity CRITICAL.
- UNVERIFIED: public reproducer, CVE ID, mailing-list review comments
  (no public thread).

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7d9c8246edfd6..5a61beef9cc44 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1607,7 +1607,7 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	in_len = le16_to_cpu(req->SecurityBufferLength);
 	out_blob = (char *)&rsp->hdr.ProtocolId +
 		le16_to_cpu(rsp->SecurityBufferOffset);
-	out_len = work->response_sz -
+	out_len = work->response_sz - work->next_smb2_rsp_hdr_off -
 		(le16_to_cpu(rsp->SecurityBufferOffset) + 4);
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
-- 
2.53.0

