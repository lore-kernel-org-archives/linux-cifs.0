Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E23542817;
	Mon, 31 Aug 2026 13:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183962; cv=none; b=kwwj99XTeyEKyTExOovKilzR7epjsqYh42usBROLACGmT59ctqdXVoSA1LZwXRo0HfA+X5nWQb3pJX9Cqmq4miM/ArQL3+bFm0RuB3kajKgMXJddjlODDx8a0WVwFHPsdiKgSEreWyZR9JdwGrKZIh5WcK40PVZas6rEg7BPgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183962; c=relaxed/simple;
	bh=l19/Eitnt/WwBn03Y3+MmsIipieO3xBj/2OeQm1eSFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9wy5wTZz/E0Xd9+RlVtUU1c12KzNsOrDwLgDJGeiCG3sgZ5V4af9E+JorcihBipo2AeypKW3g9AeO0UUSO4Rq/Qp/j4zdTQ5k3pSE+qERLhkgpq1BSuauPqBoDA6Z1Kl3pfXoJx9CItn+Z6x4ov55nxGFAYXsnrov7rRQbdX74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6/NvNas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6/NvNas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869421F00A3E;
	Mon, 31 Aug 2026 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183959;
	bh=LGW/tvl6hcNoPK/NHpTAzf50PHQK625S5s/gyCPlYWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6/NvNasORC31p0Fa/fLws6lMfdrmlXM3+y99q5ZNlzook9zIx0SsBPNZ8wteonde
	 aiqn0tx07ADPRLMEJr1tD/IJXbcOh1HGkf1SsipQ3FrmauU5um6gEPNwEdqJd6XVw0
	 2or/H4NgX6+mJP8fV8c/KBhkyVHjkebRw3+58NYeVCmgCv9IlbXhPWQmRTFBl0Nxx0
	 kjzrQlT8exMuCGSaV23XxHIeopABuyDf/BeLJQFtLyVMNKF8kNkbgPhjnTzr2/vz0q
	 MZy2Z1az0m+JN3lBY2fxZl9YiTdnh9pCXTR1rLWujlVJeRFJ9OMK7yRFWXDrfa1Jk3
	 RTEMWl/LviZDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: validate SID namespace before mapping IDs
Date: Mon, 31 Aug 2026 09:27:13 -0400
Message-ID: <20260831133314.4125787-405-sashal@kernel.org>
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

[ Upstream commit fbe0bb2b75eb3c61e8464486506253d1b471240b ]

sid_to_id() currently treats the last subauthority of any owner or group
SID as a Unix uid or gid. For example, this maps Everyone (S-1-1-0) to
uid 0 and BUILTIN\Users (S-1-5-32-545) to gid 545.

When an SMB2 CREATE security descriptor contains those SIDs, ksmbd
attempts to change the newly created file to the bogus Unix ownership.
notify_change() then returns -EPERM, which makes smb2.create.aclfile fail
with NT_STATUS_SHARING_VIOLATION.

Validate the SID prefix before extracting its RID. Only server-domain
owner SIDs and S-1-22-2 Unix group SIDs have local ID representations.
Treat other valid Windows SIDs as unmapped so their original values can
still be preserved in the NT ACL xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: validate SID namespace before
mapping IDs`

**Local tree:** Linux 6.18.44 (`v6.18.44-1-g2736c32da98b9`)
**Candidate commit:** `fbe0bb2b75eb3` (mainline 7.2-rc2; **not** in
current HEAD history)
**Bug status in this tree:** Present — `sid_to_id()` lacks SID prefix
validation

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[ksmbd] [validate] validate SID namespace before mapping IDs` —
ACL/SID correctness fix in the SMB server.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd
  maintainer)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (CIFS/SMB
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Link:`, `Tested-by:`, or
  `Reviewed-by:` tags

**Step 1.3 — Body analysis**
Record:
- **Bug:** `sid_to_id()` treats the last subauthority of *any*
  owner/group SID as a Unix uid/gid.
- **Examples:** Everyone (`S-1-1-0`) → uid 0; `BUILTIN\Users`
  (`S-1-5-32-545`) → gid 545.
- **Symptom:** SMB2 CREATE with such security descriptors causes bogus
  ownership change; `notify_change()` returns `-EPERM`; CREATE fails
  with `NT_STATUS_SHARING_VIOLATION`.
- **Root cause:** No validation that the SID belongs to the server
  domain (owner) or `S-1-22-2` Unix group namespace (group) before RID
  extraction.
- **Fix approach:** Validate SID prefix; only map domain owner SIDs and
  `S-1-22-2-*` group SIDs; treat other valid Windows SIDs as unmapped so
  NT ACL xattrs are preserved.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although titled “validate,” this is a functional
correctness bug — incorrect ID mapping breaks SMB2 CREATE with security
descriptors and can attempt root ownership for `Everyone`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **File:** `fs/smb/server/smbacl.c` (+17 / -4 lines)
- **Functions:** `sid_to_id()`, `parse_sec_desc()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow changes**

| Hunk | Before | After |
|------|--------|-------|
| `sid_to_id()` owner path | Extract last subauthority as uid
unconditionally | Require `psid` to match `server_conf.domain_sid`
prefix + exactly one RID |
| `sid_to_id()` group path | Extract last subauthority as gid
unconditionally | Require `psid` to match `sid_unix_groups` (`S-1-22-2`)
prefix + one RID |
| `parse_sec_desc()` error handling | `pr_err()` on mapping failure |
`ksmbd_debug()` + `rc = 0` for unmapped (non-fatal) SIDs |

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness fix.** `sid_to_id()` is the inverse of
`id_to_sid()` but lacked the corresponding namespace checks. Well-known
Windows SIDs were misinterpreted as Unix IDs.

**Step 2.4 — Fix quality**
Record:
- **Obviously correct:** Mirrors `id_to_sid()` which uses
  `server_conf.domain_sid` for `SIDOWNER` and `sid_unix_groups` for
  groups.
- **Minimal:** Uses existing `compare_sids()`.
- **Low regression risk:** Only rejects SIDs that were never valid Unix
  ID mappings.
- **Note:** `parse_sec_desc()` already ends with `return 0`; the `rc =
  0` reset is defensive/cosmetic but the `sid_to_id()` validation is the
  substantive fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Buggy `sid_to_id()` logic present at HEAD in lines 278–300,
introduced with ksmbd in this tree (blame points to merge
`5d324e5159d9e`).

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: Recent 6.18.y ksmbd ACL hardening commits in same file:
- `337022d9dfac4` — validate ACE size against SID sub-authorities
- `18d8db24b0a5b` — validate SID in parent security descriptor during
  ACL inheritance
- Multiple DACL/OOB validation fixes

This fix fits the same ACL correctness pattern already being backported.

**Step 3.4 — Author context**
Record: Namjae Jeon is the ksmbd maintainer; Steve French committed.
Both are authoritative for this subsystem.

**Step 3.5 — Dependencies**
Record: **Standalone.** Requires only symbols present in 6.18.44:
- `compare_sids()` — exists
- `server_conf.domain_sid` — exists
- `sid_unix_groups` — exists (`S-1-22-2` constant at line 43)

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c fbe0bb2b75eb3` found **no matching lore thread**
(patch-id `dfb14c6056968734ff03c9e2be7c62bc06662d79`). Manual lore
search blocked by bot protection.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` returned nothing (no thread found).

**Step 4.3 — Bug reports**
Record: N/A — no `Reported-by:` or `Link:` tags. Bug described only in
commit message.

**Step 4.4 — Related patches**
Record: Standalone; not part of a numbered series.

**Step 4.5 — Stable list**
Record: No stable-list discussion found (b4/lore unavailable for this
commit).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `sid_to_id()`, `parse_sec_desc()`, `set_info_sec()`,
`smb2_create_sd_buffer()`

**Step 5.2 — Callers**

| Function | Callers | Context |
|----------|---------|---------|
| `sid_to_id()` | `parse_sec_desc()` (owner/group), DACL ACE parsing
(~line 509) | Security descriptor processing |
| `parse_sec_desc()` | `set_info_sec()` | SMB2 SET_INFO / CREATE SD
buffer |
| `set_info_sec()` | `smb2_create_sd_buffer()`, `smb2_set_info_sec()` |
SMB2 CREATE/SET_INFO from network clients |
| `smb2_create_sd_buffer()` | `smb2_open()` CREATE path (~line 3389) |
File creation with `SMB2_CREATE_SD_BUFFER` |

**Step 5.3 — Callees**
Record: `compare_sids()`, `from_vfsuid()`/`from_vfsgid()`,
`notify_change()` (downstream in `set_info_sec()`)

**Step 5.4 — Reachability**
Record: **Reachable from SMB clients** via SMB2 CREATE with security-
descriptor create context. Triggered when Windows clients send SDs
containing well-known SIDs (`Everyone`, `BUILTIN\Users`, etc.) — common
in Windows ACLs.

**Step 5.5 — Similar patterns**
Record: `id_to_sid()` already restricts mapping to
`server_conf.domain_sid` / `sid_unix_groups`; `sid_to_id()` was the
missing inverse validation.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **YES.** Current `sid_to_id()` at lines 257–303 extracts RID
without prefix check. Fix commit `fbe0bb2b75eb3` is **not** an ancestor
of HEAD.

**Step 6.2 — Backport difficulty**
Record: **Clean apply** — `git apply --check` on `fbe0bb2b75eb3` patch
succeeded with no conflicts.

**Step 6.3 — Duplicate fix?**
Record: **No** — grep shows no SID prefix validation in current
`sid_to_id()`.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem**
Record: `fs/smb/server/` (ksmbd SMB server). **Criticality: IMPORTANT**
— network file server, config-dependent (`CONFIG_SMB_SERVER`).

**Step 7.2 — Activity**
Record: Actively maintained in 6.18.y with recent security and ACL fixes
(UAF, OOB, ACL validation).

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
Record: Users running ksmbd (`CONFIG_SMB_SERVER`) with ACL/security-
descriptor features, especially Windows SMB clients creating files with
SD buffers.

**Step 8.2 — Trigger conditions**
Record: SMB2 CREATE (or SET_INFO) carrying a security descriptor whose
owner/group SID is a well-known Windows SID (e.g. `S-1-1-0`,
`S-1-5-32-545`). **Common** in Windows environments. Triggerable by
remote SMB clients (authenticated).

**Step 8.3 — Failure mode**
Record:
- **Primary:** CREATE fails with `NT_STATUS_SHARING_VIOLATION` after
  `-EPERM` from `notify_change()` — **functional breakage**
- **Secondary:** Incorrect mapping of `Everyone` → uid 0; if chown were
  permitted, file would get root ownership — **correctness/security
  concern**
- **Severity: MEDIUM-HIGH** for ksmbd deployments (not kernel panic, but
  breaks interoperability)

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Restores SMB2 CREATE with Windows security descriptors;
  prevents bogus uid/gid assignment
- **Risk:** Very low — 21-line change, uses existing helpers, only
  rejects invalid mappings
- **Ratio:** Favorable for ksmbd users

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backport:**
- Real, reproducible functional bug on common Windows SID patterns
- Small, surgical, applies cleanly to 6.18.44
- Obviously correct — mirrors `id_to_sid()` inverse logic
- Signed by ksmbd and SMB maintainers
- Same subsystem already receives similar ACL fixes in 6.18.y
- Remote SMB clients can trigger the bug path

**Evidence AGAINST:**
- No syzbot report or user `Reported-by:` tags
- Not a kernel crash/UAF/OOB — operational failure
- Only affects `CONFIG_SMB_SERVER` users
- No mailing-list review traceable via b4

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (logic mirrors existing
   `id_to_sid()`; maintainer SOBs)
2. Fixes real bug? **PASS**
3. Important issue? **PASS** (SMB interoperability breakage; potential
   incorrect root ownership)
4. Small and contained? **PASS** (21 lines, 1 file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (verified clean apply)

**Exception category:** N/A (not device ID, quirk, DT, build, or docs)

**Problem summary for stable users:** Windows SMB clients sending
security descriptors with well-known SIDs (e.g. `Everyone`,
`BUILTIN\Users`) cause ksmbd to mis-map them to Unix uid/gid, attempt
invalid ownership changes, and fail file creation. The fix restricts ID
mapping to the same SID namespaces `id_to_sid()` already uses.

---

## Verification

- [Phase 1] `git show fbe0bb2b75eb3 --format=fuller`: parsed subject,
  body, SOB tags
- [Phase 2] `git show fbe0bb2b75eb3`: full diff reviewed; 17 insertions,
  4 deletions
- [Phase 2] Read `fs/smb/server/smbacl.c` lines 257–303, 871–958,
  1601–1654: confirmed buggy code and call chain
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9; Makefile
  VERSION=6 PATCHLEVEL=18 SUBLEVEL=44
- [Phase 3] `git merge-base --is-ancestor fbe0bb2b75eb3 HEAD`: commit
  NOT in HEAD history
- [Phase 3] `git blame -L 278,300 fs/smb/server/smbacl.c`: buggy lines
  present at HEAD
- [Phase 3] `git log --oneline -15 -- fs/smb/server/`: related ACL fixes
  in tree
- [Phase 4] `b4 dig -c fbe0bb2b75eb3 -C`: no lore match found
- [Phase 4] WebFetch lore.kernel.org: blocked by bot protection
- [Phase 5] `grep` for `parse_sec_desc`, `set_info_sec`,
  `smb2_create_sd_buffer`: traced SMB2 CREATE path
- [Phase 5] Read `compare_sids()` lines 71–114: prefix comparison
  behavior verified
- [Phase 5] Read `id_to_sid()` lines 221–231: inverse mapping namespaces
  confirmed
- [Phase 6] Read current `sid_to_id()`: no prefix validation present
- [Phase 6] `git apply --check` on patch: applies cleanly
- [Phase 6] `grep domain_sid`, `sid_unix_groups`: all dependencies exist
- [Phase 8] Read `smb2pdu.c` lines 2647–2672, 3388–3389: CREATE SD
  buffer path confirmed

**YES**The background check finished: commit `fbe0bb2b75eb3` (“ksmbd:
validate SID namespace before mapping IDs”) is on the **7.2-rc2** line,
not in your current **6.18.44** tree — which matches the earlier finding
that the buggy `sid_to_id()` logic is still present locally and the
patch applies cleanly.

**Backport recommendation remains YES** for 6.18.y: it’s a small, self-
contained fix for a real ksmbd interoperability bug where common Windows
SIDs (e.g. `Everyone`, `BUILTIN\Users`) get mis-mapped to Unix IDs and
SMB2 CREATE with security descriptors fails.

 fs/smb/server/smbacl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d3d0a22620f96..0b55c77e64562 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -258,6 +258,7 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
+	const struct smb_sid *sid_prefix;
 	int rc = -EINVAL;
 
 	/*
@@ -279,6 +280,12 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		kuid_t uid;
 		uid_t id;
 
+		/* Only the server domain RID has a local uid representation. */
+		sid_prefix = &server_conf.domain_sid;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		uid = KUIDT_INIT(id);
 		uid = from_vfsuid(idmap, &init_user_ns, VFSUIDT_INIT(uid));
@@ -290,6 +297,12 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		kgid_t gid;
 		gid_t id;
 
+		/* Local gids are represented by S-1-22-2-<gid>. */
+		sid_prefix = &sid_unix_groups;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		gid = KGIDT_INIT(id);
 		gid = from_vfsgid(idmap, &init_user_ns, VFSGIDT_INIT(gid));
@@ -916,9 +929,9 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 
 		rc = sid_to_id(idmap, owner_sid_ptr, SIDOWNER, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Owner SID to uid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
 			owner_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
@@ -934,9 +947,9 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		}
 		rc = sid_to_id(idmap, group_sid_ptr, SIDUNIX_GROUP, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Group SID to gid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Group SID has no Unix gid mapping\n");
 			group_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
-- 
2.53.0

