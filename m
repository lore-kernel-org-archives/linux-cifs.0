Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923355A4659;
	Mon, 19 Oct 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418385; cv=none; b=GNC3Fx3dolh4hkxSJuHyem2syknV/CRZZU5UO0DTzHcL3nOv9F549toUFK11vV/qipDd6Odt3Rh+rAQEcXEjqFs2RIpsZG9/a3Zj5f0ZKuFax9bzioqC+RJU0u2JRFpwzf5RwGbd+LhEkTUzP03+qxUGYSKLqKcEtrtnoUkrJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418385; c=relaxed/simple;
	bh=CXnKF4+ZDrpWbpAZxBrFKka87tvf/mPvxrk92r7+buY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdrlAI4ORqpS1awKda7ZSWO7Ex4ZN+3ekPH0sCpWaeUss28Mi7QhR9SBO4B+ITodMdzCENEr8P0Uh+2sXrLMK6vMdn/dydmjD2V/fcffY9LoAE3NT1Z2yacc5Wt+sPZWvhSpTZWnDC0e464I5Yv5ShaFZOoEImA3lQn83tmlULY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GY2EEfgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GY2EEfgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724951F000C7;
	Mon, 19 Oct 2026 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418382;
	bh=U9Vkwbm05lDdxzxOAYs6Jk3Nr9THOJjffnHBcf4GiHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GY2EEfgIrn+JQr1y96dyZF9u1Yct5GyqIzR1eAw2qXf8dOszuMl4W8S9mvhEQa3Cu
	 2tHHre59FvD6BMX5HnX2AmPBb4WUrZx/DnCNuios4+vyi2UJLQ003nHm04wKaWDJ3X
	 Djf0hEMYwU/x8kBmuNp/vh1zQjmP31bYOoIyA4mpMOD3kjfiKZZPlHBxE/AyqFxMoX
	 QCANvLXNiJ7FLwgOwnSbTJcj5yAjpE0of8XnfhAeRXgiyWZbBNsQzfSTKKnVHO+EIS
	 qY2xoprPbblqr4YNx0DSNVIUZcaH8J7n1yFDJvbJ2c9qvOPpwcGorxyBSvudsRQHuW
	 qer5vka9HhUNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: protect private extended attributes
Date: Mon, 19 Oct 2026 09:48:20 -0400
Message-ID: <20261019135441.1420968-209-sashal@kernel.org>
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

[ Upstream commit 4ea46ea602fc7055eee4b5b0e84f90f22da7f7e7 ]

SMB clients can currently create an EA named NTACL because SMB EAs are
mapped into the user namespace while the ksmbd security descriptor is
stored as security.NTACL. Allowing the reserved logical name makes the
server-private ACL metadata appear writable through the SMB EA API.

Reject NTACL, DOSATTRIB, and DosStream-prefixed EA names without regard
to case. Filter the same private names from EA query results so stale or
externally-created user namespace attributes cannot be exposed.

This fixes smb2.ea.acl_xattr when acl_xattr_name is configured as
NTACL.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[ksmbd] [protect] keep server-private xattr names off the SMB
  EA API`

**Step 1.2 — Tags**
- Record: `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd
  maintainer; author and committer).
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable`. Absence of `Fixes:`/`Cc: stable` is
  expected for this review and is not a negative signal.

**Step 1.3 — Body**
- Record: SMB EAs are stored as `user.*` xattrs. ksmbd keeps NT ACL
  metadata in `security.NTACL`. Clients can still create an EA named
  `NTACL`, so the reserved logical name looks writable over SMB
  SET_INFO/QUERY_INFO EA. The patch rejects `NTACL`, `DOSATTRIB`, and
  `DosStream.`-prefixed names case-insensitively on set, and filters the
  same names from query results so leftover `user.*` copies are not
  exposed. Failure mode: reserved metadata can be written or listed
  through the EA API. Symptom: Samba smbtorture `smb2.ea.acl_xattr`
  fails when `acl_xattr_name=NTACL`. Introduced with original ksmbd EA
  mapping; not a new 7.x-only bug.

**Step 1.4 — Hidden bug fix?**
- Record: Yes. “Protect” is a security/integrity fix, not cleanup. SET
  currently does not reject reserved names. GET already skipped
  `DosStream.` / `DOSATTRIB` with case-sensitive `strncmp`, but not
  `NTACL` and not case variants.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `fs/smb/server/smb2pdu.c` only (`+22/-6`). Functions: new
  `smb2_is_private_ea()`; `smb2_set_ea()`; `smb2_get_ea()`.
  Classification: single-file surgical fix.

**Step 2.2 — Flow**
- Record:
  - SET: after the EA name-length check, reserved names return `-EACCES`
    instead of `ksmbd_vfs_setxattr`/`remove_xattr` on `user.<name>`.
  - GET: STREAM and DOSATTRIB `strncmp` skips become one
    `smb2_is_private_ea()` skip (adds `NTACL`, case-insensitive).
    Specific-name QUERY still cannot return those names.

**Step 2.3 — Bug mechanism**
- Record: Logic/correctness plus a hardware/protocol reserved-name
  filter (category g/h). Same-namespace collisions: `user.DOSATTRIB`
  (DOS flags/create time) and `user.DosStream.*` (named streams).
  `security.NTACL` is a different namespace, so SET of EA `NTACL`
  creates `user.NTACL` rather than overwriting the SD; the patch still
  blocks that reserved name and hides any leftover `user.NTACL`.

**Step 2.4 — Fix quality**
- Record: Obviously correct. `strncasecmp` + exact length for
  `NTACL`/`DOSATTRIB`, prefix match for streams. `-EACCES` maps to
  `STATUS_ACCESS_DENIED` in both `smb2_set_info()` and CREATE error
  mapping, matching smbtorture. Regression risk is low: only reserved
  Samba/ksmbd names are rejected. Query of a private name still yields
  `STATUS_NO_EAS_ON_FILE` rather than ACCESS_DENIED; that is pre-
  existing GET skip behavior, not a new crash path.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Unfiltered SET and GET STREAM/DOSATTRIB skips come from
  `e2f34481b24db` (“cifsd: add server-side procedures for SMB3”,
  2021-03-16). Present since ksmbd entered the kernel (5.15 era). `git
  merge-base --is-ancestor e2f34481b24db HEAD` succeeds.

**Step 3.2 — Fixes tag**
- Record: None. Buggy behavior is the original EA mapping, not a later
  regression.

**Step 3.3 — File history**
- Record: Recent 6.12 ksmbd work is unrelated (buffer sizes, leases,
  durable reconnect). No competing private-EA helper in this tree.

**Step 3.4 — Author**
- Record: Namjae Jeon is the ksmbd maintainer. Surrounding 7.3 ksmbd
  commits are other protocol/security fixes; this commit is standalone
  (`4ea46ea602fc`).

**Step 3.5 — Dependencies**
- Record: Needs `SD_PREFIX`, `DOS_ATTRIBUTE_PREFIX`, `STREAM_PREFIX`
  from `fs/smb/server/xattr.h` (included via `vfs.h` in `smb2pdu.c`).
  All exist here. `strncasecmp` is in `include/linux/string.h`. Applies
  standalone.

## Phase 4: Mailing list / external

**Step 4.1**
- Record: SHA `4ea46ea602fc7055eee4b5b0e84f90f22da7f7e7` (v7.3-rc1). `b4
  dig -c 4ea46ea602fc` failed: lore.kernel.org returned errors (Anubis
  bot challenge). WebFetch to lore also 403. UNVERIFIED: original thread
  text, NAKs, reviewer Cc:stable.

**Step 4.2**
- Record: UNVERIFIED recipients. Commit is authored and committed by the
  subsystem maintainer; Linus merged it in `ksmbd-for-7.3-rc1`
  (`61a09cfc12147`), described as smbtorture-validated protocol fixes
  and security hardening.

**Step 4.3**
- Record: Samba `source4/torture/smb2/ea.c` `torture_smb2_acl_xattr`
  (`smb2.ea.acl_xattr`) requires `acl_xattr_name`, checks the name is
  not listed, and expects SET to fail with `NT_STATUS_ACCESS_DENIED`.
  Confirmed from samba-team/samba master.

**Step 4.4**
- Record: Standalone. No later revert or follow-up on
  `smb2_is_private_ea` through v7.3-rc1 (`git grep` still shows the
  helper at three sites).

**Step 4.5**
- Record: UNVERIFIED on lore.kernel.org/stable (lore blocked). No in-
  tree revert.

## Phase 5: Code semantics

**Step 5.1**
- Record: `smb2_is_private_ea`, `smb2_set_ea`, `smb2_get_ea`.

**Step 5.2**
- Record: `smb2_set_ea` callers: CREATE EA context (`smb2_open` path
  ~3322) and `FILE_FULL_EA_INFORMATION` in `smb2_set_info_file` (~6644).
  `smb2_get_ea` caller: `smb2_get_info_file` (~5493). Reachable from
  SMB2 CREATE / SET_INFO / QUERY_INFO.

**Step 5.3**
- Record: SET uses `ksmbd_vfs_setxattr` / `ksmbd_vfs_remove_xattr` after
  prefixing `XATTR_USER_PREFIX`. GET uses `ksmbd_vfs_listxattr` /
  `ksmbd_vfs_getxattr`. Internal DOS/stream/SD writers
  (`ksmbd_vfs_set_dos_attrib_xattr`, stream helpers,
  `ksmbd_vfs_set_sd_xattr`) do not go through `smb2_set_ea`, so server-
  internal writes remain allowed.

**Step 5.4**
- Record: Yes, from userspace: authenticated SMB client with
  `FILE_WRITE_EA` / `FILE_READ_EA`. Those rights are normally part of
  generic write/read.

**Step 5.5**
- Record: GET already special-cased STREAM and DOSATTRIB; SET did not.
  Same reserved names as Samba (`user.DOSATTRIB`, `user.DosStream.*`,
  `security.NTACL`).

## Phase 6: This tree (6.12.111)

**Step 6.1**
- Record: Local tree is `pending-6.12`, `git describe`
  `p-6.12-3-gc504cf0baa3d8`, `make kernelversion` **6.12.111**.
  Candidate is **not** an ancestor of HEAD. Buggy SET/GET code is
  present (`smb2_set_ea` at 2392, `smb2_get_ea` at 4758).
  `smb2_is_private_ea` is absent.

**Step 6.2**
- Record: `git apply --check` of `4ea46ea602fc` succeeded (hunks at
  2379, 2436, 4852; offsets only). Clean apply.

**Step 6.3**
- Record: No alternate fix. GET still uses case-sensitive
  STREAM/DOSATTRIB skips and does not filter NTACL.

## Phase 7: Subsystem

**Step 7.1**
- Record: `fs/smb/server` (ksmbd). Criticality: IMPORTANT — network file
  server, optional (`CONFIG_SMB_SERVER` default n), but a common stable
  attack/integrity surface.

**Step 7.2**
- Record: Actively maintained. This bug is old (original EA code), not a
  7.3-only feature.

## Phase 8: Impact and risk

**Step 8.1**
- Record: ksmbd users only (NAS, appliances, distro ksmbd). Not
  universal.

**Step 8.2**
- Record: Trigger: SMB2 SET_INFO FULL_EA or CREATE with EA context using
  reserved names. Common for any client that can write EAs. Unprivileged
  local processes cannot hit it unless they are SMB clients; an
  authenticated SMB user can.

**Step 8.3**
- Record: Failure mode: overwrite `user.DOSATTRIB` (hidden/system/create
  time) and `user.DosStream.*` (stream data); expose or plant
  `user.NTACL`. Severity: **HIGH** (metadata/stream integrity and
  reserved-name ACL confusion). Not a kernel oops. Default ksmbd ACL
  store is `security.NTACL`, so SET EA `NTACL` does not overwrite the
  SD; DOSATTRIB/streams are the real same-namespace collisions.

**Step 8.4**
- Record: Benefit high for ksmbd hosts. Risk very low (~20-line filter,
  no locking/API change). Ratio favors backport.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real reserved-name hole on a network server: SET can write
  `user.DOSATTRIB` and `user.DosStream.*`.
- GET can leak `user.NTACL` if that xattr exists.
- Matches Samba’s long-standing hide/reject of those names; smbtorture
  `smb2.ea.acl_xattr` expects ACCESS_DENIED.
- Small, maintainer-authored, in v7.3-rc1 with no revert.
- Applies cleanly to this 6.12 tree; macros and callers exist.
- `-EACCES` already maps to `STATUS_ACCESS_DENIED`.

AGAINST:
- Not a crash/UAF.
- NTACL SD lives in `security.*`, so this is not a direct ACL overwrite
  on default ksmbd.
- Commit message is partly a test fix.
- Lore review UNVERIFIED.

UNRESOLVED:
- Original lore thread / reviewer stable nomination (lore blocked).

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** (applies cleanly; smbtorture
   named; maintainer).
2. Real user-visible bug? **PASS** (EA write/list of private metadata).
3. Important (crash/security/corruption/deadlock)? **PASS** (HIGH:
   metadata/stream integrity on an SMB server; security-boundary).
4. Small and contained? **PASS** (+22/-6, one file).
5. No new features/APIs? **PASS** (reject/filter only).
6. Applies to this tree? **PASS** (`git apply --check` succeeded).

**Step 9.3 — Exceptions**
- Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
  normal security/integrity bug fix.

**Step 9.4 — Decision**
Backport to this 6.12 tree. The important part is not the Samba test
name; it is that authenticated clients can currently smash DOS attribute
and named-stream xattrs that ksmbd treats as private.

---

### What this solves for 6.12 users

ksmbd maps SMB EAs to `user.*`. It stores DOS attributes in
`user.DOSATTRIB` and streams in `user.DosStream.*`. `smb2_set_ea()` does
not reject those names, so a client with `FILE_WRITE_EA` can overwrite
that metadata. Query already hid some of those names, but not `NTACL`
and not case variants. The patch closes SET and GET.

### Stable-rules / risk

Meets all six criteria. Benefit is integrity of ksmbd private xattrs;
risk is a tight ACCESS_DENIED on reserved names that Samba has treated
as private for years.

### Verification
- [Phase 1] Parsed message/tags on `4ea46ea602fc`; only author SOB; no
  Fixes/Link.
- [Phase 2] Full `git show 4ea46ea602fc` diff: helper + SET `-EACCES` +
  GET filter.
- [Phase 2] Confirmed `-EACCES` → `STATUS_ACCESS_DENIED` at
  `smb2_set_info` err_out (~6761) and CREATE err_out (~3812).
- [Phase 2] Confirmed `XATTR_NAME_DOS_ATTRIBUTE` = `user.`+`DOSATTRIB`,
  `XATTR_NAME_STREAM` = `user.`+`DosStream.`, `XATTR_NAME_SD` =
  `security.`+`NTACL` in `xattr.h`.
- [Phase 3] `git blame` SET/GET: `e2f34481b24db` (2021); ancestor of
  HEAD.
- [Phase 3] `git merge-base --is-ancestor 4ea46ea602fc HEAD` → no (not
  in 6.12).
- [Phase 4] `b4 dig -c 4ea46ea602fc` → lore error. UNVERIFIED mailing-
  list discussion.
- [Phase 4] Samba `torture_smb2_acl_xattr` expects SET ACCESS_DENIED and
  no list leak.
- [Phase 4] Merge `61a09cfc12147` mentions smbtorture protocol fixes /
  security hardening.
- [Phase 4] `smb2_is_private_ea` still in v7.3-rc1; no revert.
- [Phase 5] Callers: CREATE EA context, SET_INFO FULL_EA, QUERY_INFO EA.
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`;
  kernelversion 6.12.111.
- [Phase 6] `git apply --check` of the commit succeeded with line
  offsets only.
- [Phase 8] Same-namespace overwrite of DOSATTRIB/streams verified in
  `vfs.c` / `smb2_update_xattrs`.
- UNVERIFIED: lore reviewers, CVE assignment, whether any distro already
  carries a different backport.

**YES**

 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e73edf006df72..4f8e2a6307602 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2378,6 +2378,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
+static bool smb2_is_private_ea(const char *name, size_t name_len)
+{
+	if (name_len == SD_PREFIX_LEN &&
+	    !strncasecmp(name, SD_PREFIX, SD_PREFIX_LEN))
+		return true;
+	if (name_len == DOS_ATTRIBUTE_PREFIX_LEN &&
+	    !strncasecmp(name, DOS_ATTRIBUTE_PREFIX,
+			   DOS_ATTRIBUTE_PREFIX_LEN))
+		return true;
+	if (name_len >= STREAM_PREFIX_LEN &&
+	    !strncasecmp(name, STREAM_PREFIX, STREAM_PREFIX_LEN))
+		return true;
+
+	return false;
+}
+
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
@@ -2419,6 +2435,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = -EINVAL;
 			break;
 		}
+		if (smb2_is_private_ea(eabuf->name, eabuf->EaNameLength)) {
+			rc = -EACCES;
+			break;
+		}
 
 		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
@@ -4828,17 +4848,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 			continue;
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
-			     STREAM_PREFIX_LEN))
-			continue;
-
 		if (req->InputBufferLength &&
 		    strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
 			    ea_req->EaNameLength))
 			continue;
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN],
-			     DOS_ATTRIBUTE_PREFIX, DOS_ATTRIBUTE_PREFIX_LEN))
+		if (smb2_is_private_ea(&name[XATTR_USER_PREFIX_LEN],
+				       name_len - XATTR_USER_PREFIX_LEN))
 			continue;
 
 		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-- 
2.53.0

