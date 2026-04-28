Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB743F7A86;
	Tue, 28 Apr 2026 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372991; cv=none; b=CoEH7Tzw6Ja7psxYSWt0zZPnNgtxuNNJ7Un1CLqVedS55dY1YT3JP14OAT94LYsrytHDGpnNAs2L89Ojl/Cj4Bv/tty1OaV8Q6YaYoQtUboVRseYnYLM/2PAIQUdMzzfMdlJy1X63LWukc8nen/efELtLjYW2p9JiJ8umqSFbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372991; c=relaxed/simple;
	bh=oICg9WaJwPOSZRa7AmD/p8YQESVrP4l3jmF+yMxTsBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzDCNJLq0pobxcIwDp9aGK7uPvNFX03OnkGCR0KQLrSRk6OKxPwlA2NN1d8+XPMb7TolF/Bm3qt9deHQRc4JF0B3R3Y0b8CGqArFioZh2Bg0c+tmRiYIjoec+1HFH0c2jpWu1Kcld3EkVNjM38SrUA++fFsyobN6n3CM3kqLhfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hb9Pi5Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hb9Pi5Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB243C2BCB7;
	Tue, 28 Apr 2026 10:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372990;
	bh=oICg9WaJwPOSZRa7AmD/p8YQESVrP4l3jmF+yMxTsBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb9Pi5YjCSdgs/GW7iKfUS+y2SUKaJwLQ2PQ0CaCsWNolaj78O9Z9s07M60ZuMq+P
	 BfgyHYk1S4RR07WAgBPTH8yZxPraR7D+22FCZXrV0M4mdN+CUuridiiswGZtodEvbf
	 yy2nbnAXcThgseHJasU5PEpaar6d7sU0DlrWNDuuJgbCvMMdFBubX5ajchGSDX5qln
	 m93mijtxhuXimWls0Z9hW2nUDpMCbDnfvYXmaaYyrS+DeZxcI1T7rx0mWf1CEGhhpG
	 3is78W9o/aBq7R+JJeYTZeidxl3Bq9RUs3FQFODQ54wf/pE21buDBahzyPszhF3aMa
	 9D/J+2RqO/Ypw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] smb: server: stop sending fake security descriptors
Date: Tue, 28 Apr 2026 06:41:18 -0400
Message-ID: <20260428104133.2858589-67-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 5efb579e0d1ee02b85e3ce2da691c88c93111060 ]

in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
the requested information is not supported.

the code is currently wrong, as DACL_PROTECTED is set in the type field,
but there is no DACL is present.

instead of faking a security, report a STATUS_NOT_SUPPORTED error.

this seems to fix a "Error 0x80090006: Invalid Signature" on file
transfers with Windows 11 clients (25H2, build 26200.8246).

capturing traffic shows that the client is sending a GET_INFO/SEC_INFO
request, with the additional_info field set to 0x20
(ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
(with only SELF_RELATIVE set) does not fix the error.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

# Analysis: smb: server: stop sending fake security descriptors

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line parsing
- Subsystem: `smb: server:` (ksmbd / in-kernel SMB server)
- Verb: "stop sending" (corrective action - implies current behavior is
  wrong)
- Summary: Replace a fabricated security descriptor (SD) response with a
  proper STATUS_NOT_SUPPORTED error

Record: `[smb/server] [stop sending] Replaces a malformed fake SD
response with a STATUS_NOT_SUPPORTED error when unsupported
AdditionalInformation flags are requested.`

### Step 1.2: Commit message tags
- Signed-off-by: Marios Makassikis (author)
- Acked-by: Namjae Jeon (ksmbd maintainer)
- Signed-off-by: Steve French (tree maintainer)
- No Fixes: tag
- No Cc: stable tag (expected - that's why we evaluate)
- No Reported-by: tag (author appears to be the reporter via real-world
  testing)
- No Link: tag

Record: `Only Acked-by from subsystem maintainer; no Fixes tag, no
Reported-by tag, no Link tag. Author is the reporter/tester.`

### Step 1.3: Commit body text
- Bug mechanism: `smb2_get_info_sec()` returns a "fake" SD when the
  client requests unsupported AdditionalInformation flags. The SD has
  `DACL_PROTECTED` in the `type` field but no DACL is actually present
  (`dacloffset == 0`).
- Symptom: Windows 11 25H2 (build 26200.8246) clients fail file
  transfers with "Error 0x80090006: Invalid Signature".
- Trigger: Windows 11 25H2 sends GET_INFO/SEC_INFO with
  AdditionalInformation=0x20 (ATTRIBUTE_SECINFO).
- Author also confirmed returning an empty SD (with only SELF_RELATIVE
  set) does not fix the error - returning STATUS_NOT_SUPPORTED does.
- "seems to fix" - reflects the empirical nature of the fix (protocol
  reverse engineered via packet capture).

Record: `Bug: malformed SD with DACL_PROTECTED set but no DACL; Symptom:
Win11 25H2 file transfers fail with Error 0x80090006 "Invalid
Signature"; Root cause: sending an inconsistent SD breaks Windows
client's signature verification.`

### Step 1.4: Hidden bug fix detection
- Verb "stop sending fake" = definitely a bug fix (current behavior is
  broken)
- Not disguised; explicitly framed as a correctness issue

Record: `Explicitly framed as a bug fix (malformed SD), not hidden.`

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
- 1 file: `fs/smb/server/smb2pdu.c`
- +2 lines, -15 lines (net -13)
- Single function modified: `smb2_get_info_sec()`
- Scope: surgical, single error path in one function

Record: `1 file, +2/-15, single function smb2_get_info_sec(), SURGICAL
SCOPE`

### Step 2.2: Code flow change
- BEFORE (in current mainline 6.19/7.0):
  - On unsupported AdditionalInformation, allocate a zeroed `smb_ntsd`,
    populate `revision=1`, `type=SELF_RELATIVE|DACL_PROTECTED`, zero all
    offsets, set secdesclen, and goto `iov_pin` to pin the buffer in the
    response. Return 0 (success).
- AFTER:
  - On unsupported AdditionalInformation, set `rsp->hdr.Status =
    STATUS_NOT_SUPPORTED` and return `-EINVAL`.
- The caller `smb2_query_info()` checks `rsp->hdr.Status == 0` before
  overwriting in its error path, so STATUS_NOT_SUPPORTED is preserved
  (verified at lines 5900-5903 of smb2pdu.c).

Record: `Error path change only. Replaces malformed-SD-as-success with
proper SMB error status.`

### Step 2.3: Bug mechanism
- Category: **Logic / correctness fix (SMB protocol compliance)**
- Specific mechanism: The SD's `type` field declared DACL_PROTECTED,
  which asserts that a DACL exists and is protected from inheritance.
  But `dacloffset=0` means no DACL is present. This is self-
  contradictory per MS-DTYP. Windows 11 25H2's stricter parsing rejects
  it; its signature verifier computes signatures over the response and
  the peer verification fails with "Invalid Signature".

Record: `Protocol correctness bug - DACL_PROTECTED claimed without DACL
present; violates MS-DTYP security descriptor invariants.`

### Step 2.4: Fix quality
- Fix is obvious and minimal.
- The STATUS_NOT_SUPPORTED + return -EINVAL pattern is already used
  throughout the file (lines 1219, 3781, 7043, 8158, 8587 - all similar
  patterns).
- The caller's error path preserves a pre-set Status (line 5900 `rc ==
  -EINVAL && rsp->hdr.Status == 0`).
- Minor regression risk: Windows 10 clients that previously "accepted"
  the malformed SD may now get an error instead. However, the fake SD
  was originally added as a temporary workaround (commit
  `ced2b26a76cd1d` from 2021), and STATUS_NOT_SUPPORTED is a standard
  SMB response that clients should handle gracefully.

Record: `Fix quality HIGH. Uses established in-file pattern. Caller's
error handling verified correct. Minor risk of changing behavior for
Windows 10 clients that previously accepted the malformed SD.`

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
- The fake SD code was introduced in commit
  `ced2b26a76cd1db0b6ccb39e0bc873177c9bda21` ("cifsd: Fix regression in
  smb2_get_info") in April 2021, as a workaround for Windows 10 clients
  requesting ATTRIBUTE_SECINFO (mask 0x20).
- That 2021 commit explicitly stated: "For now we just reintroduce the
  old check to avoid processing of unhandled flags until
  ATTRIBUTE_SECINFO is properly handled." - i.e., the fake SD was
  acknowledged as a temporary workaround.
- ksmbd was merged into mainline at v5.15, so this code is present in
  **all stable trees (5.15+)**.

Record: `Fake SD introduced by ced2b26a76cd1d in April 2021 as a
temporary workaround. Present in all stable trees that have ksmbd
(5.15+). Buggy code has existed ~5 years.`

### Step 3.2: Fixes: tag absent
- Commit has no Fixes: tag.
- The commit is effectively fixing the temporary workaround from
  `ced2b26a76cd1d`, but also fixing the original absence of proper
  handling for ATTRIBUTE_SECINFO.

Record: `No Fixes: tag. Implicit target is ced2b26a76cd1d (2021
workaround); but the workaround itself did not go to stable as a named
fix - it was part of the original upstream history of cifsd/ksmbd.`

### Step 3.3: File history related changes
- `8e537d1465e74` (Nov 2021): "ksmbd: downgrade addition info error msg
  to debug in smb2_get_info_sec()" - cc'd to stable, fixed performance
  regression due to log spam, but didn't address the malformed SD bug.
- No other related fixes in this area.

Record: `One related prior fix (8e537d1465e74) that went to stable v5.15
fixed log spam; no one previously addressed the malformed SD.`

### Step 3.4: Author's other commits
- Marios Makassikis is a regular ksmbd contributor, has multiple recent
  fixes (e.g., `1e689a5617382` smb2_open UAF, `88f170814fea7` recursive
  locking fix, `43fb7bce8866e` broken transfers fix).
- Works at Freebox (French ISP, real-world ksmbd deployment).

Record: `Author is a regular, experienced ksmbd contributor with real-
world deployment at Freebox.`

### Step 3.5: Dependencies
- Fix is standalone - it does not depend on any other commit.
- The removed `goto iov_pin` and the iov_pin label are the only
  plumbing; after this change the label becomes unused in mainline
  (which caused a compile warning noted by Steve French in the ML
  thread; Namjae fixed it when merging).
- In stable trees (v5.15 through v6.17), the fake SD code exists in a
  slightly different form (pntsd points to `rsp->Buffer` pre-allocated,
  no kzalloc involved), so the `iov_pin` label does not exist there. The
  backport would be: replace the 8 lines populating the fake SD (and the
  closing `return 0;`) with `rsp->hdr.Status = STATUS_NOT_SUPPORTED;
  return -EINVAL;` - even cleaner than the mainline fix.

Record: `Standalone fix. Backport to 5.15/6.1/6.6/6.12/6.17 is
straightforward since the stable code structure is simpler (no kzalloc,
no iov_pin label). Backport will require minor adaptation but is
trivial.`

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: b4 dig and thread retrieval
- `b4 dig -c 5efb579e0d1ee`: patch-id match failed; found by
  author+subject match.
- Message-ID: `20260421190619.1396589-1-mmakassikis@freebox.fr`
- Lore URL: `https://lore.kernel.org/all/20260421190619.1396589-1-
  mmakassikis@freebox.fr/`
- Thread has 5 messages. Downloaded with `b4 mbox`.

Record: `Thread found via b4 dig (author+subject match); 5 messages
total.`

### Step 4.2: Thread content
- V1 patch posted by Marios on Apr 21 2026.
- Steve French flagged a build warning (unused `iov_pin` label in v1
  patch since it removed the only goto but left the label).
- Namjae Jeon responded: "Right, I directly fixed it and pushed it
  again." - fixed warning when applying.
- Steve French: "merged updated patch to ksmbd-for-next".
- No stable nomination from reviewers.
- No NAKs.
- Recipients were: linkinjeon@kernel.org, smfrench@gmail.com,
  tom@talpey.com (Tom Talpey, SMB protocol expert),
  senozhatsky@chromium.org (Sergey Senozhatsky, Chromium/ksmbd
  reviewer).
- Appropriate reviewers were CC'd.

Record: `Reviewed/acked by maintainer Namjae; merged by Steve French to
ksmbd-for-next. Only issue raised was a compile warning that was fixed
upon merging. No stable nomination in the thread.`

### Step 4.3: Bug report
- No external bug report (Link: or Reported-by:).
- The commit message itself describes the author's packet-capture
  investigation of Windows 11 25H2 behavior.

Record: `No external bug report; author self-reported based on real-
world deployment at Freebox.`

### Step 4.4: Related patches/series
- Standalone single patch - not part of a series.
- b4 dig -a not explicitly run (b4 dig could not match by patch-id, only
  by subject), but the thread shows only a single version.

Record: `Standalone patch, no series.`

### Step 4.5: Stable mailing list
- Not searched explicitly; patch is very recent (April 2026) so unlikely
  to have been discussed on stable list yet.

Record: `Too recent for stable ML discussion.`

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
- `smb2_get_info_sec()` - static, called only from `smb2_query_info()`.

Record: `One modified function: smb2_get_info_sec().`

### Step 5.2: Callers
- Single caller: `smb2_query_info()` at `fs/smb/server/smb2pdu.c:5881`
  (dispatches SMB2_O_INFO_SECURITY).
- `smb2_query_info` is in the SMB2 operation dispatch table at
  `fs/smb/server/smb2ops.c:182`.
- This is reachable from every SMB2 client request with
  `SMB2_QUERY_INFO_HE` opcode and `InfoType == SMB2_O_INFO_SECURITY` - a
  very common operation in file browsing and transfers.

Record: `smb2_get_info_sec reachable from standard SMB2 protocol via
SMB2_QUERY_INFO_HE -> smb2_query_info -> smb2_get_info_sec. HIGH impact
surface.`

### Step 5.3: Callees
- `kzalloc`, `cpu_to_le16`, setup of `smb_ntsd` fields (removed).
- The simple error-return path replaces all these.

Record: `N/A (code is being removed, not added).`

### Step 5.4: Call chain reachability
- Reachable from userspace via: any SMB client -> network -> ksmbd ->
  SMB2 dispatch -> smb2_query_info -> smb2_get_info_sec.
- Triggered by simply mounting or accessing a share from Windows 11 25H2
  clients.

Record: `TRIGGER: any Windows 11 25H2 client performing file operations
on a ksmbd share triggers this path because the client sends
ATTRIBUTE_SECINFO queries. HIGH reachability.`

### Step 5.5: Similar patterns
- `STATUS_NOT_SUPPORTED` is used 6 times in smb2pdu.c as a standard
  error response for unsupported operations.
- The pattern `rsp->hdr.Status = STATUS_NOT_SUPPORTED; return
  -E<error>;` is established.

Record: `Pattern used 5+ places in smb2pdu.c; consistent with codebase
conventions.`

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code existence in stable
- v5.15: buggy code present (fs/ksmbd/smb2pdu.c) - verified via `git
  show v5.15:fs/ksmbd/smb2pdu.c`.
- v6.1: buggy code present (fs/ksmbd/smb2pdu.c).
- v6.6: buggy code present (fs/smb/server/smb2pdu.c - moved).
- v6.12, v6.17: buggy code present (same path).
- All active stable trees 5.15+ have this bug.

Record: `Bug present in ALL active stable trees (5.15.y, 6.1.y, 6.6.y,
6.12.y, 6.17.y, 6.19.y).`

### Step 6.2: Backport complications
- Minor structural differences:
  - Old stable (5.15 - 6.17): `pntsd` is `(struct smb_ntsd
    *)rsp->Buffer` (pre-allocated) - removing the 8 lines and the
    `return 0;` plus inserting `rsp->hdr.Status = STATUS_NOT_SUPPORTED;
    return -EINVAL;` gives a clean backport.
  - Newer (6.19+): `pntsd` is separately allocated via `kzalloc`, with
    `goto iov_pin` - mainline fix directly applies.
- The backport is trivial - just need to remove the fake SD population
  and replace the terminating `return 0;` with the error response.

Record: `Backport requires minor adaptation for <6.19 trees but is
trivial - same logic, simpler code.`

### Step 6.3: Related fixes in stable
- No previously-applied fix addresses this specific issue.
- `8e537d1465e74` (log spam fix) went to stable v5.15 but didn't address
  the malformed SD.

Record: `No prior fix in stable addresses this bug.`

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
- `fs/smb/server/` = ksmbd (in-kernel SMB3 server).
- Criticality: **IMPORTANT** - affects users running Linux as an SMB
  file server (common for NAS devices, home servers, small/medium
  businesses). Not CORE, but widely deployed in enterprise storage and
  consumer NAS (e.g., Freebox, Synology-like devices).

Record: `Subsystem: ksmbd (fs/smb/server/). Criticality: IMPORTANT for
NAS/file server deployments.`

### Step 7.2: Activity
- ksmbd is actively developed, with ~20 recent commits to smb2pdu.c in
  the last few months (leaks, UAFs, OOB fixes, etc.).

Record: `ksmbd is actively developed; many stable-worthy fixes regularly
backported.`

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected users
- All users of ksmbd as SMB server with Windows 11 25H2 clients.
- Windows 11 25H2 is the current Windows 11 version (as of 2026). Broad
  consumer and enterprise deployment.
- Users: home NAS owners, enterprise file servers, embedded storage
  appliances.

Record: `Affected population: everyone with a ksmbd server accessed by
Windows 11 25H2 clients. Large user base (NAS deployments).`

### Step 8.2: Trigger conditions
- Trigger: Normal file operation from Windows 11 25H2 against a ksmbd
  share.
- Frequency: Every file browse/transfer operation that causes Windows 11
  to query security info (i.e., nearly every operation).
- Privilege: Unprivileged SMB client can trigger.

Record: `Triggered on every normal file operation from Win11 25H2
clients. Unprivileged remote trigger.`

### Step 8.3: Failure mode severity
- Failure: File transfers fail with "Error 0x80090006: Invalid
  Signature".
- User impact: **Functionality break** - cannot use the SMB share for
  file operations.
- Severity: **HIGH** - this is a functionality regression for a major
  class of clients. Not a crash, but a complete loss of core file-
  sharing functionality.

Record: `Failure mode: file transfer functionality break (not a crash).
Severity: HIGH (usability regression affecting core purpose of ksmbd for
Win11 25H2 clients).`

### Step 8.4: Risk-benefit
- BENEFIT: Fixes file transfer functionality for Windows 11 25H2 (a
  major, current Windows version) - restores core SMB server
  functionality. HIGH benefit.
- RISK:
  - Code change is 14 lines removed, 2 added - very low scope.
  - Minor behavioral change: Windows 10 clients that previously relied
    on the fake SD may now see STATUS_NOT_SUPPORTED. However,
    STATUS_NOT_SUPPORTED is a standard SMB error that clients should
    handle; it's the correct protocol response.
  - The fake SD was described as a temporary workaround in its original
    commit (2021).
  - LOW-MEDIUM risk.

Record: `Benefit HIGH (fixes broken functionality for common Win11
clients). Risk LOW-MEDIUM (small scope, established pattern, minor risk
of Win10 behavioral change but STATUS_NOT_SUPPORTED is the protocol-
correct response).`

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compilation

FOR backport:
- Fixes a real, user-visible bug (file transfers fail with Windows 11
  25H2).
- Protocol correctness fix (malformed SD with DACL_PROTECTED but no
  DACL).
- Small, surgical, single-function change.
- Uses established in-file pattern (STATUS_NOT_SUPPORTED + return
  -EINVAL).
- Caller's error handling verified to preserve the Status field
  correctly.
- Acked by ksmbd maintainer Namjae Jeon.
- Merged via Steve French (cifs/smb tree maintainer).
- Author is a regular experienced ksmbd contributor at Freebox (real
  production deployment).
- Bug present in all stable trees (5.15+).
- Backport is trivial (even simpler in older stable trees).

AGAINST backport:
- No Fixes: tag (but that's why we're evaluating).
- No Cc: stable tag.
- "seems to fix" language suggests some uncertainty (empirical finding
  from packet capture).
- Minor risk of behavior change for Windows 10 clients (previously used
  fake SD as workaround).
- No syzbot/KASAN/KMSAN backing.
- Single real-world report (the author).

UNRESOLVED:
- Whether Windows 10 clients will gracefully handle STATUS_NOT_SUPPORTED
  in 2026 (likely yes - it's standard).
- Whether there's any client besides Windows 11 25H2 affected by the
  "Invalid Signature" failure.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **Yes** - tested by author against
   Windows 11 25H2, reviewed by maintainer.
2. Fixes a real bug affecting users? **Yes** - file transfer
   functionality broken.
3. Important issue? **Yes** - functional break on a common client class.
4. Small and contained? **Yes** - 16 line diff in a single function.
5. No new features or APIs? **Yes** - only removes broken behavior.
6. Can apply to stable trees? **Yes with trivial adaptation** - older
   trees don't have the kzalloc/iov_pin structure, so the backport is
   even simpler.

### Step 9.3: Exception categories
- This is not a device ID, quirk, DT update, or build fix.
- It IS a protocol-compliance fix that restores broken client
  interoperability - similar in spirit to a hardware workaround
  (compatibility fix for specific client "hardware"/OS versions).

### Step 9.4: Decision
The commit is a clear bug fix for a real, user-impacting
interoperability issue. The fix is:
- Small (2 insertions, 15 deletions, one function)
- Obviously correct (the fake SD was objectively malformed per MS-DTYP)
- Reviewed by the maintainer
- Follows established code patterns in the same file
- Affects all stable trees with ksmbd (5.15+)
- Trivially backportable

The benefit (restoring file-transfer functionality for Windows 11 25H2
clients on ksmbd servers) significantly outweighs the minor risk
(possible slight behavior change for Windows 10 clients, who should
handle the standard STATUS_NOT_SUPPORTED response correctly).

## Verification

- [Phase 1] Parsed subject/body: identified the bug (malformed SD with
  DACL_PROTECTED but no DACL) and the symptom (Win11 25H2 "Invalid
  Signature" errors on file transfers). Verified via `git show
  5efb579e0d1ee`.
- [Phase 1] Tags: confirmed only Signed-off-by (author+Steve French),
  Acked-by (Namjae Jeon); no Fixes:, Cc: stable, Reported-by:, Link:
  tags. Verified via `git show --format='%B'`.
- [Phase 2] Diff inventory: 1 file (fs/smb/server/smb2pdu.c), +2/-15
  lines, one function (smb2_get_info_sec). Verified via `git show
  --stat`.
- [Phase 2] Caller's error path: verified at
  fs/smb/server/smb2pdu.c:5900 - `rc == -EINVAL && rsp->hdr.Status == 0`
  means a pre-set Status (STATUS_NOT_SUPPORTED) is preserved. Verified
  via Read tool.
- [Phase 2] STATUS_NOT_SUPPORTED pattern: confirmed used at 6 locations
  in smb2pdu.c (lines 1219, 1914, 3781, 7043, 8158, 8587) and once in
  transport_rdma.c. Verified via Grep.
- [Phase 2] STATUS_NOT_SUPPORTED definition: `cpu_to_le32(0xC00000BB)`
  mapped to -EOPNOTSUPP - verified at fs/smb/common/smb2status.h:420.
- [Phase 2] ATTRIBUTE_SECINFO = 0x20 definition verified at
  fs/smb/common/smb2pdu.h:1757.
- [Phase 3] git blame / git log -S "SELF_RELATIVE | DACL_PROTECTED":
  confirmed fake SD code was added by ced2b26a76cd1d (April 2021, as a
  temporary workaround for Windows 10). Verified via `git log -p
  --follow -S`.
- [Phase 3] Fixes target: ced2b26a76cd1d is in v5.15 (ksmbd was merged
  in v5.15). Verified via git show of v5.15, v6.1, v6.6 source.
- [Phase 3] Author's contributions: multiple recent ksmbd fixes confirm
  experienced contributor. Verified via `git log --author="Makassikis"`.
- [Phase 4] b4 dig -c 5efb579e0d1ee: patch-id match failed (common for
  rebased patches); subject+author match found `https://lore.kernel.org/
  all/20260421190619.1396589-1-mmakassikis@freebox.fr/`.
- [Phase 4] `b4 mbox` downloaded the 5-message thread; read the thread:
  Steve French flagged a compile warning, Namjae Jeon fixed it when
  merging and applied to ksmbd-for-next. No stable nomination, no NAKs,
  appropriate maintainers CC'd.
- [Phase 5] Call chain: `smb2_get_info_sec` called only by
  `smb2_query_info`, which is in the SMB2 opcode dispatch at
  fs/smb/server/smb2ops.c:182. Reachable from any SMB2 client. Verified
  via Grep for `smb2_query_info`.
- [Phase 6] Buggy code exists in v5.15, v6.1 (as fs/ksmbd/smb2pdu.c);
  v6.6, v6.12, v6.17 (as fs/smb/server/smb2pdu.c). Verified via `git
  show v<VER>:<path>` for all versions.
- [Phase 6] Backport structure in older stable: pntsd is pre-allocated
  as `(struct smb_ntsd *)rsp->Buffer`, no kzalloc, no iov_pin label -
  verified in `git show v6.17:fs/smb/server/smb2pdu.c`.
- [Phase 8] Failure severity: functional break (not crash) on Win11 25H2
  file transfers, severity HIGH. Verified from commit message and
  protocol analysis.
- UNVERIFIED: Could not independently confirm the Windows 11 25H2
  behavior via external sources (Anubis blocking lore browsing); rely on
  the author's packet-capture-based description and maintainer ack.
- UNVERIFIED: Whether Windows 10 clients will behaviorally regress
  (transition from "silently accepts malformed SD" to "sees
  STATUS_NOT_SUPPORTED") was not tested here - but STATUS_NOT_SUPPORTED
  is a standard SMB error code and this is the protocol-correct
  response.

Conclusion: The commit fixes a real, user-visible interoperability bug
(Windows 11 25H2 file transfers fail on ksmbd). The fix is minimal (16
lines), maintainer-acked, follows existing in-file patterns, and applies
trivially to all stable trees with ksmbd (5.15+). The risk of subtle
behavioral change for other clients is outweighed by the concrete
benefit of restoring file-share functionality for a major, current
Windows version.

**YES**

 fs/smb/server/smb2pdu.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8e4cfdc0ba025..e21c6c22355b1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5739,20 +5739,8 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
 		       addition_info);
 
-		pntsd = kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
-				KSMBD_DEFAULT_GFP);
-		if (!pntsd)
-			return -ENOMEM;
-
-		pntsd->revision = cpu_to_le16(1);
-		pntsd->type = cpu_to_le16(SELF_RELATIVE | DACL_PROTECTED);
-		pntsd->osidoffset = 0;
-		pntsd->gsidoffset = 0;
-		pntsd->sacloffset = 0;
-		pntsd->dacloffset = 0;
-
-		secdesclen = sizeof(struct smb_ntsd);
-		goto iov_pin;
+		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		return -EINVAL;
 	}
 
 	if (work->next_smb2_rcv_hdr_off) {
@@ -5819,7 +5807,6 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (rc)
 		goto err_out;
 
-iov_pin:
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      rsp, work->response_buf);
-- 
2.53.0

