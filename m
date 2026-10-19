Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3DD528E7C;
	Mon, 19 Oct 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418579; cv=none; b=i//t6wZEFeRdRVv9G5NOefD67VyXbLHmQp4nMHdGKxKBUfyoYsrSo1mApX+ZH7kZI8/b30W96xMFEJraY8thvXuaJeqDXyCyoGvFiyxmaId4vQIpyFuraRaiX93/UEJMvKzHj9J2obCHGULBpoK80onEkJf8pnz88/5rREUrvmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418579; c=relaxed/simple;
	bh=X0WWpL/yAc+d45sAZxg4kVZZZqi6sb8JBuCq80J76pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OPUyJtG5NLdoww0i3eK4G1Tk1Jmc4gI5bsTO/dmNZd/trhR+VEEBRBUDLWVX6USj23FvOYw/GVm3lV1HmoR2xR2XmMyq9ffgy8DfjvtRiRVZF0B6rYPn9didP6xb//r9KhrC1YeiKcAynwZgIh+FjGE4Tk+YAi9E1f5VvlwqCRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ME3ZVss+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ME3ZVss+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59BB1F000CD;
	Mon, 19 Oct 2026 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418576;
	bh=wcTZCSdHSKjaGx5kDio+SrLyCa2fp7o+hd0FbeYvW1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ME3ZVss+nm3SGoZwWEz9WoYfJi149CpaEpC1sEplGAhbCcFf/309x4j8kR27vV2Li
	 SryPOlIALhHex7Gfe/CZwfKnnm3DXpVbeTtw+/b7COKASZbRshLoOfx9tDQRf7Esvh
	 2GBn9fjRRT1siVkoWM56BB3NLZjSHLF8eP+MqWJMPti9+tJp2D9+rs6BxsSJt3Ot8E
	 MQsjIiekmjUw47EjDmNqCrliCyoCOhBtycFlZ2UArPdtVMo+0k/l0v07FxBS+pNwVw
	 Ft33IeJ82xGEZX7gCMQWs6uBMgda9loPNAt7pu7IqjjnQ8fDQ+eE4+vzbV3Dke7+r0
	 4AT50XGtfnpLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: return buffer too small for short security queries
Date: Mon, 19 Oct 2026 09:50:37 -0400
Message-ID: <20261019135441.1420968-346-sashal@kernel.org>
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

[ Upstream commit 2103add92a02505bdd536ba6fce7f64a427222a2 ]

SMB2 QUERY_INFO security requests with an output buffer too small for
the self-relative security descriptor header can fall through descriptor
construction and be reported as STATUS_INVALID_INFO_CLASS.

After validating the file handle, reject buffers shorter than struct
smb_ntsd with STATUS_BUFFER_TOO_SMALL before building the descriptor.

This fixes smb2.getinfo.qsec_buffercheck.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The candidate is
mainline `2103add92a02` (“ksmbd: return buffer too small for short
security queries”). It is not an ancestor of HEAD, but the buggy path is
present and the patch applies.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ksmbd] [return] SMB2 QUERY_INFO security with a too-small
output buffer should return STATUS_BUFFER_TOO_SMALL instead of a wrong
NT status.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
- Absence of Fixes/Cc-stable is expected for this review pipeline and is
  not a negative signal
- Pipeline-added markers (Upstream commit / Sasha Levin SOB) ignored per
  instructions

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: SMB2 QUERY_INFO (security) with OutputBufferLength smaller than
  `struct smb_ntsd` can still run descriptor construction and be
  reported as STATUS_INVALID_INFO_CLASS
- Symptom: wrong NT status on short security queries; Samba smbtorture
  `smb2.getinfo.qsec_buffercheck` fails
- Author’s root cause: missing early reject after the file handle is
  validated
- Fix: if OutputBufferLength \< sizeof(struct smb_ntsd), set
  STATUS_BUFFER_TOO_SMALL, put the fd, return -ENOSPC

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit protocol/error-code
fix. The “fall through descriptor construction” wording matches a real
control-flow bug, not style.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/smb/server/smb2pdu.c` (+6 / -0)
- Function: `smb2_get_info_sec()`
- Scope: single-file surgical fix, one insertion after
  `ksmbd_lookup_fd_slow()`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: after a successful fd lookup, the function always builds POSIX
  ACL fattr / optional SD xattr, allocates a scratch SD, calls
  `build_sec_desc()`, then `buffer_check_err()`.
- After: if `OutputBufferLength < sizeof(struct smb_ntsd)` (20 bytes),
  return immediately with STATUS_BUFFER_TOO_SMALL and `ksmbd_fd_put()`.
- Path: error path for client-provided undersized QUERY_INFO security
  buffers (including the Samba test’s 0- and 1-byte probes).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / protocol correctness (wrong NT status)
- Mechanism verified in this tree:
  1. Samba `qsec_buffercheck` uses AdditionalInformation=0 and
     OutputBufferLength 0 then 1.
  2. `smb_acl_sec_desc_scratch_len()` with no OWNER/GROUP/DACL flags
     returns `sizeof(struct smb_ntsd)` = 20.
  3. `build_sec_desc()` also sets `secdesclen` to 20.
  4. The OOB-fix guard `ALIGN(secdesclen, 8) > scratch_len` is 24 > 20,
     so rc = -EFBIG with Status still 0.
  5. `smb2_query_info()` maps unmapped errors with Status==0 to
     STATUS_INVALID_INFO_CLASS.
- That matches the commit message. MS-SMB2 3.3.5.20.3 requires
  STATUS_BUFFER_TOO_SMALL when OutputBufferLength is zero or
  insufficient for the security descriptor.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: a self-relative NTSD is at least `sizeof(struct
  smb_ntsd)`; smaller buffers cannot hold one.
- `ksmbd_fd_put()` is required after `ksmbd_lookup_fd_slow()`; no leak.
- `smb2_query_info()` does not remap -ENOSPC when Status is already set,
  so BUFFER_TOO_SMALL is preserved.
- Regression risk is low: only OutputBufferLength < 20 on QUERY_INFO
  security changes, from a wrong error to the spec-required one.
- Incomplete vs MS-SMB2: the error response still has ByteCount 0
  (`smb2_set_err_rsp()`), so the required size is not returned. The
  torture test only asserts the status. That does not make the patch
  incorrect.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion point is immediately after the fd lookup, which dates to
  e2f34481b24db2 (Namjae Jeon, 2021, original cifsd QUERY_INFO security
  path).
- The INVALID_INFO_CLASS outcome for this short-buffer case comes from
  d48c64fb80ad7 (“ksmbd: fix OOB write in QUERY_INFO for compound
  requests”, 2026-03-25), which added scratch_len + ALIGN check +
  buffer_check_err. That commit **is** in this tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Functionally this is a follow-up to
d48c64fb80ad7, which is already in HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Related QUERY_INFO buffer-status commits already in this tree:
- fb29c008e1f3b ksmbd: return buffer overflow for partial filesystem
  info (fixes smb2.getinfo.qfs_buffercheck)
- df33d8243ce6b ksmbd: fix partial file information responses (mainline
  parent of this candidate)
- ab1da5f071fae ksmbd: keep compound responses on query info errors
- ff021a8abacab ksmbd: fix partial normalized name responses
This is the security-info counterpart of qfs_buffercheck, not a large
series that needs extra unapplied patches.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Namjae Jeon is the ksmbd maintainer (MAINTAINERS / Kconfig
SMB_SERVER). Many of his QUERY_INFO buffer-handling fixes are already on
this branch.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. Needs `smb2_get_info_sec()`, `struct smb_ntsd`,
`ksmbd_fd_put()`, STATUS_BUFFER_TOO_SMALL, and the existing query_info
error mapper — all present. `git apply --check` of 2103add92a succeeded
(hunk offset only). Parent 6b8b79226bc3 (“fix partial file information
responses”) is in the tree as df33d8243ce6b.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Mainline SHA confirmed via GitHub API:
  2103add92a02505bdd536ba6fce7f64a427222a2
- `b4 dig -c 2103add92a` failed: lore.kernel.org returned server errors
  (exact patch-id, author+subject, and in-body From all failed)
- lore WebFetch also 403
- UNVERIFIED: mailing-list review comments, NAKs, Cc: stable from
  reviewers, series revisions

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Commit has only the author’s SOB. UNVERIFIED original To/Cc (b4
-w not usable without lore).

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Samba smbtorture `source4/torture/smb2/getinfo.c`
`torture_smb2_qsec_buffercheck()`:
- QUERY_INFO SECURITY, output_buffer_length 0 → expect
  NT_STATUS_BUFFER_TOO_SMALL
- same with length 1 → expect NT_STATUS_BUFFER_TOO_SMALL
This is a documented interoperability test against Windows/Samba
behavior, not a theoretical check.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Not labeled X/Y. Parent is the already-backported partial file-
info fix. Sister test qfs_buffercheck is already fixed in this tree. No
extra series member is required for this hunk.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED (lore.kernel.org/stable search not available; 403).
Decision does not rely on stable-list history.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `smb2_get_info_sec()` only.

Step 5.2: TRACE CALLERS
Record:
- `smb2_query_info()` → case SMB2_O_INFO_SECURITY
- Registered in `fs/smb/server/smb2ops.c` as SMB2_QUERY_INFO_HE
- Reachable from any SMB2 client that issues QUERY_INFO security
  (Windows ACL UI, `icacls`, Samba, etc.)

Step 5.3: TRACE CALLEES
Record: New path calls `ksmbd_fd_put()` and returns. It avoids
`ksmbd_acls_fattr`, `ksmbd_vfs_get_sd_xattr`,
`smb_acl_sec_desc_scratch_len`, `build_sec_desc`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace/network reachable: authenticated SMB2 QUERY_INFO on an
open handle. Unprivileged local users cannot hit it unless they can
speak SMB to a ksmbd share; remote SMB clients can.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same QUERY_INFO buffer-status pattern already fixed for
filesystem info (qfs_buffercheck) and file info. Security info was the
remaining class for this Samba suite.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `smb2_get_info_sec()` at `fs/smb/server/smb2pdu.c:5789` has
the lookup then immediately `file_mnt_idmap()` with no
OutputBufferLength vs `sizeof(struct smb_ntsd)` check. `git merge-base
--is-ancestor 2103add92a HEAD` is false. `git describe HEAD` =
p-6.12-3-gc504cf0baa3d8, `make kernelversion` = 6.12.111.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply (`git apply --check` succeeded; offset -507 lines
because mainline’s file is larger). No API mismatch.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: qfs_buffercheck / partial file info / compound query-info error
handling are here. This exact BUFFER_TOO_SMALL early reject is not. No
alternate fix for qsec_buffercheck found (`git log --grep=qsec` empty on
fs/smb/server).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ksmbd (`fs/smb/server`, CONFIG_SMB_SERVER, default n).
Criticality: IMPORTANT for ksmbd deployments (network file server),
PERIPHERAL for kernels that do not enable it.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; recent 6.12 backports are mostly ksmbd
protocol and lifetime fixes from Namjae Jeon.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: ksmbd users (CONFIG_SMB_SERVER). Windows/Samba clients querying
security descriptors with a short or zero output buffer.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Common for ACL probes: OutputBufferLength 0 or 1 (exactly what
the Samba test sends; Windows often probes with a small buffer then
retries). Authenticated SMB client on a share; not a local unprivileged
syscall.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Wrong NT status (INVALID_INFO_CLASS instead of
BUFFER_TOO_SMALL). Clients that treat INVALID_INFO_CLASS as
“unsupported” will not retry with a larger buffer, so ACL queries can
fail. Not a kernel oops/UAF. Severity: MEDIUM (interop / functional
failure on a file server), HIGH for ksmbd ACL usability.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: restores MS-SMB2-required status for short security queries;
  unbreaks smb2.getinfo.qsec_buffercheck; repairs fallout from an OOB
  fix already in this tree.
- Risk: very low (6 lines, error path only, fd_put balanced).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real protocol bug: MS-SMB2 3.3.5.20.3 MUST return
  STATUS_BUFFER_TOO_SMALL for insufficient security QUERY_INFO buffers
- Concrete user-visible failure: Samba torture qsec_buffercheck; Windows
  ACL size-probe pattern
- Mechanism verified in this tree: ALIGN(secdesclen,8) > scratch_len →
  -EFBIG → INVALID_INFO_CLASS
- Follow-up to d48c64fb80ad7, which is already in 6.12.111 (stable-to-
  stable)
- 6-line surgical change, fd_put correct, Status not overwritten
- Applies cleanly
- Same class as qfs_buffercheck, already backported here
- Maintainer-authored

AGAINST:
- Not a crash, UAF, or data-corruption fix
- Incomplete vs spec (no 4-byte required length in the error body)
- ksmbd is optional (default n)
- No Fixes:/Cc:stable (expected; not used as a NO)

UNRESOLVED:
- lore/b4 discussion (lore returned errors)
- Whether any reviewer NAK’d (no evidence either way)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — size check vs NTSD header;
   author cites passing qsec_buffercheck; logic confirmed in-tree
2. Fixes a real bug that affects users? PASS — wrong SMB status on
   security queries; Windows/Samba clients
3. Important issue? PASS — interoperability failure on a network file
   server; fallout from an already-applied OOB fix. Not a panic, but
   user-visible ACL query failure
4. Small and contained? PASS — +6 lines, one function
5. No new features or APIs? PASS — error-code correction only
6. Can apply to the local tree? PASS — apply --check succeeded;
   prerequisites present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small bugfix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. The buggy path exists, the
OOB-fix regression is here, the patch is tiny and applies, and the wrong
status is a real ksmbd interop bug.

What the commit solves for stable users:
ksmbd currently answers short SMB2 QUERY_INFO security requests with
STATUS_INVALID_INFO_CLASS (or INFO_LENGTH_MISMATCH when extra secinfo
flags are set). Clients that probe with a 0-byte buffer then retry never
learn that they only needed a larger buffer. The patch returns
STATUS_BUFFER_TOO_SMALL after the handle is validated, which is what MS-
SMB2 requires and what Samba’s qsec_buffercheck expects.

Risk vs benefit:
Benefit is restoring ACL query probing on ksmbd 6.12. Risk is a 6-line
error-path change with balanced fd_put. No new APIs, no extra
prerequisites.

Verification:
- [Phase 1] Parsed tags: only Namjae Jeon SOB; no Fixes/Reported-
  by/Link/Cc stable
- [Phase 2] Diff: +6 in smb2_get_info_sec after fd lookup;
  STATUS_BUFFER_TOO_SMALL + ksmbd_fd_put + return -ENOSPC
- [Phase 2] Confirmed sizeof packed smb_ntsd is 20 bytes
  (le16+le16+4×le32)
- [Phase 2] Confirmed smb2_query_info() keeps pre-set Status for -ENOSPC
  (does not map to INVALID_INFO_CLASS)
- [Phase 2] Confirmed ALIGN(20,8)=24 > scratch_len 20 produces -EFBIG →
  INVALID_INFO_CLASS for AdditionalInformation=0
- [Phase 3] git describe HEAD: p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111
- [Phase 3] git merge-base --is-ancestor 2103add92a HEAD: not ancestor
- [Phase 3] git merge-base --is-ancestor d48c64fb80ad7 HEAD: yes (OOB
  fix present)
- [Phase 3] git blame: lookup from e2f34481b24db2 (2021); ALIGN/scratch
  from d48c64fb80ad7
- [Phase 3] Parent 6b8b79226bc3 is in tree as df33d8243ce6b
- [Phase 3] git apply --check: clean (offset -507)
- [Phase 4] GitHub API: mainline SHA
  2103add92a02505bdd536ba6fce7f64a427222a2
- [Phase 4] b4 dig: UNVERIFIED (lore server error)
- [Phase 4] Samba getinfo.c: qsec_buffercheck expects BUFFER_TOO_SMALL
  for lengths 0 and 1
- [Phase 4] MS-SMB2 3.3.5.20.3: MUST return BUFFER_TOO_SMALL when
  OutputBufferLength is zero or insufficient
- [Phase 5] Caller: smb2_query_info via SMB2_QUERY_INFO_HE; network-
  reachable
- [Phase 6] Buggy code at smb2pdu.c:5840–5846; no existing qsec fix in
  git log
- [Phase 8] Failure mode: wrong NT status → ACL probe/retry failure;
  severity MEDIUM/HIGH for ksmbd users
- UNVERIFIED: lore review thread, stable@ discussion, whether error-data
  required-size follow-up exists in later mainline

**YES**

 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9bb885fa1ac66..0fbbb47f94644 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5902,6 +5902,12 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (!fp)
 		return -ENOENT;
 
+	if (le32_to_cpu(req->OutputBufferLength) < sizeof(struct smb_ntsd)) {
+		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
+		ksmbd_fd_put(work, fp);
+		return -ENOSPC;
+	}
+
 	idmap = file_mnt_idmap(fp->filp);
 	inode = file_inode(fp->filp);
 	ksmbd_acls_fattr(&fattr, idmap, inode);
-- 
2.53.0

