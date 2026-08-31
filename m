Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9A241DE0F;
	Mon, 31 Aug 2026 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183291; cv=none; b=hviq3+Ccc7A8y80v/aIcvIu9HVvz5BJDuHOHv+TSEWcczFmwyas5uyKqTv2g7QMZ5mhrlIB7OGW3M0Bn2Hqo6rvvFNM7ujdTlJKM8/B5hZWC7SKc6OzSCmScNqk+WLBjXHk90erETLUa9b887D1J5Vy32E09voXX8aOn42rReMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183291; c=relaxed/simple;
	bh=sd/yo/2MaLVKK9crSrnqz2EorDRSvn4hCtQmF+nmx+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqsYovT0s6PbE87M85EpMPq925HU+x8/r+PtVvVf2bsHIdkDZUHOR5lNe2jM8LFW3KtMr7y7kp7qepOqlyWj3AKGmahFW6W37nFu/PXgAiTjL+oUoAmGsLFI4h0tbt7gXxsfUq3buC29EjnpSlB/L6VBiDoWiVS7xOHN/vtxxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrqWSupZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrqWSupZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452E1F000E9;
	Mon, 31 Aug 2026 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183288;
	bh=MLoECygpQTH0YKnAXnC15M1Xe9xOAqkR4Yx5C5mz72k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrqWSupZZjbVJ5mz3hBac53wdfWctkJx/KKUbvNQxM883xGAnZyUdiq4atueDGOoB
	 7jut6DkRMqIaa3MY4S4+TALwKjnux1Ttdd104A5OG7BpiFtU94T4FMHYx3uBnpfSfL
	 Jd2h4fqhUO0PuH2c8xGqfm9pJliL9lUMR7eGNQgcsDjhgomU8/7tiX/GMyT+Fg3+XV
	 o+hjS78TCS1P2huRrlU8xSX0GMtIByrvU57Mw0WLNntJV89j/CHhC0hRFdKn8G85gd
	 b37ZpGeQMDf1XyIviAVl0gAMod+7T+V0i0q4SzcvXYnLti1TQxhzknW22FRwX8VBJQ
	 wpU2DpSVtyowg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Mon, 31 Aug 2026 09:21:27 -0400
Message-ID: <20260831133314.4125787-59-sashal@kernel.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d4d56b00c7df88cd5751e7415bdfabc9fdbc82a7 ]

ndr_encode_v4_ntacl() allocates sd_ndr.data via kzalloc() at entry.
If any subsequent ndr_write_*() call returns error during encoding,
the allocated sd_ndr.data won't be freed and causes memory leak.

Move kfree(sd_ndr.data) into out label to ensure the buffer gets
released on all success and error return paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: fix sd_ndr.data memory leak in
ksmbd_vfs_set_sd_xattr`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)
**Fix commit (mainline):** `d4d56b00c7df8` — present on `master`,
**not** in this 6.18.44 checkout

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd] [fix] sd_ndr.data memory leak in
ksmbd_vfs_set_sd_xattr`

### Step 1.2: Commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** ChenXiaoSong `<chenxiaosong@kylinos.cn>`
- **Acked-by:** Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd maintainer)
- **Link:** — none
- **Cc: stable:** — none (expected)
- **Signed-off-by:** Qiang Liu (author), Steve French (committer);
  ignore pipeline-added SOBs

Notable: maintainer Acked-by is a strong quality signal.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `ndr_encode_v4_ntacl()` allocates `sd_ndr.data` via
  `kzalloc()`; if any subsequent `ndr_write_*()` fails, the buffer is
  not freed.
- **Symptom:** Memory leak on NDR encoding error path.
- **Root cause:** `kfree(sd_ndr.data)` was placed before the `out:`
  label, so `goto out` on `ndr_encode_v4_ntacl()` failure skipped the
  free.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix detection
**Record:** Not hidden — explicitly labeled as a memory leak fix.
Standard error-path cleanup correction.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
- **Files:** `fs/smb/server/vfs.c` (+1 / −1)
- **Function:** `ksmbd_vfs_set_sd_xattr()`
- **Scope:** Single-file, surgical fix (1-line move)

### Step 2.2: Code flow change
**Record:**
- **Hunk (before):** On `ndr_encode_v4_ntacl()` failure → `goto out` →
  `sd_ndr.data` never freed. On success → `kfree(sd_ndr.data)` then
  `out:` cleanup.
- **Hunk (after):** All paths (success and error) reach `out:` where
  `kfree(sd_ndr.data)` runs once, alongside existing cleanup of
  `acl_ndr.data`, `smb_acl`, `def_smb_acl`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Error-path resource leak
- **Mechanism:** `ndr_encode_v4_ntacl()` allocates at entry
  (`kzalloc(2048)`) and returns error without freeing on `ndr_write_*()`
  failure (e.g. `krealloc` → `-ENOMEM`). Caller’s `goto out` bypassed
  `kfree(sd_ndr.data)`.

Verified in `ndr.c`:

```397:447:fs/smb/server/ndr.c
int ndr_encode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
{
        // ...
        n->data = kzalloc(n->length, KSMBD_DEFAULT_GFP);
        if (!n->data)
                return -ENOMEM;

        ret = ndr_write_int16(n, acl->version);
        if (ret)
                return ret;
        // ... more ndr_write_* calls, all return without freeing
n->data ...
        ret = ndr_write_bytes(n, acl->sd_buf, acl->sd_size);
        return ret;
}
```

Buggy caller code in this tree:

```1560:1577:fs/smb/server/vfs.c
        rc = ndr_encode_v4_ntacl(&sd_ndr, &acl);
        if (rc) {
                pr_err("failed to encode ndr to posix acl\n");
                goto out;
        }
        // ...
        kfree(sd_ndr.data);
out:
        kfree(acl_ndr.data);
        kfree(smb_acl);
        kfree(def_smb_acl);
        return rc;
```

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors how `acl_ndr.data` is already
  freed at `out:`.
- **Regression risk:** Very low. `kfree(NULL)` is safe if `sd_ndr.data`
  was never allocated.
- **No double-free:** Success path now frees once at `out:` instead of
  before `out:`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy placement introduced in `f44158485826c` (2021-03-16,
original cifsd/ksmbd code). Present since ksmbd NDR xattr support was
added — long-standing.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Part of v2 series `[PATCH v2 0/3] ksmbd: fix some memory leaks in
  ksmbd_vfs_* functions`
- Sibling fixes on master: `7ac657bb9c5c1` (dos attrib xattr leak),
  `d708a36634bb7` (acl.sd_buf leak)
- **This patch is standalone** — no structural dependencies on siblings

### Step 3.4: Author context
**Record:** Qiang Liu; no prior ksmbd commits in this tree. Patch
reviewed and Acked by subsystem maintainer Namjae Jeon.

### Step 3.5: Prerequisites
**Record:** None. Applies independently; no new APIs or structures
required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c d4d56b00c7df8` →
  https://patch.msgid.link/20260624011320.9146-2-liuqiangneo@163.com
- Series: v1 (2026-06-23) → v2 (2026-06-24); committed version matches
  v2

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC’d Steve French, Namjae Jeon, linux-cifs, and
other ksmbd maintainers/reviewers.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Found via code review
(same pattern as other ksmbd xattr leak fixes).

### Step 4.4: Series context
**Record:** 3-patch series; each patch fixes an independent leak in a
different function. This patch does not require the others.

### Step 4.5: Stable list discussion
**Record:** Could not fetch lore thread body (403/bot protection). No
stable-list nomination verified. Absence of `Cc: stable` is not a
negative signal per review rules.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ksmbd_vfs_set_sd_xattr()`, `ndr_encode_v4_ntacl()`

### Step 5.2: Callers
**Record:**
- `fs/smb/server/smbacl.c:1397` — inherit ACL path
- `fs/smb/server/smbacl.c:1663` — `set_info_sec()` (SMB2 SET_INFO
  security)
- `fs/smb/server/smb2pdu.c:3435` — SMB2 open/create with ACL xattr

All are normal SMB server operation paths when
`KSMBD_SHARE_FLAG_ACL_XATTR` is enabled.

### Step 5.3: Callees
**Record:** `ndr_encode_posix_acl()`, `ndr_encode_v4_ntacl()`,
`ksmbd_vfs_setxattr()`, `kfree()`

### Step 5.4: Reachability
**Record:**
- Triggered by authenticated SMB clients setting security descriptors /
  ACLs on shares with ACL xattr support.
- Error path reachable when NDR buffer growth fails (`-ENOMEM` under
  memory pressure).
- **Userspace-reachable:** yes (SMB2 SET_INFO / ACL operations).

### Step 5.5: Similar patterns
**Record:** Same leak class fixed previously in this subsystem — e.g.
`78ad2c277af4c` (`ksmbd: fix memory leak in ksmbd_vfs_get_sd_xattr()`).
`acl_ndr.data` is already correctly freed at `out:`; only `sd_ndr.data`
placement was wrong.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Bug confirmed at `fs/smb/server/vfs.c:1572-1573` in
this checkout. Present since 2021.

### Step 6.2: Backport complications
**Record:** **Clean apply.** Tested `git cherry-pick --no-commit
d4d56b00c7df8` → auto-merged with no conflicts.

### Step 6.3: Fix already present?
**Record:** **No.** `git log --grep="sd_ndr.data memory leak"` returns
nothing on HEAD. Fix exists only on `master` (`d4d56b00c7df8`), ahead of
6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/smb/server/` (ksmbd SMB3 server). **IMPORTANT** —
affects SMB server deployments; not universal core, but security/ACL
paths matter for server operators.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent fixes in this tree include UAF,
race, overflow, and memory-leak patches in ksmbd.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users running `CONFIG_SMB_SERVER` (ksmbd) with ACL xattr
shares. Not all kernel users, but real production SMB server
deployments.

### Step 8.2: Trigger conditions
**Record:**
- SMB client sets security descriptor / ACL on a file or directory
- `ndr_encode_v4_ntacl()` fails after allocating buffer (typically
  `-ENOMEM` on `krealloc`)
- **Likelihood:** Low per operation, but repeatable; worst case under
  memory pressure when leaks are most harmful

### Step 8.3: Failure mode severity
**Record:** Memory leak (≥2048 bytes per occurrence, potentially more
after `krealloc`). **Severity: MEDIUM** — no direct crash/corruption,
but contributes to OOM under pressure on a server hot path. Precedent:
similar ksmbd leak fixes have been accepted to stable.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents leak on real error path in ACL/security xattr
  handling
- **Risk:** Minimal (1-line move, maintainer-acked, tested apply)
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified memory leak on error path
- Bug present in 6.18.44 since 2021
- Surgical 1-line fix, obviously correct
- Maintainer Acked-by (Namjae Jeon)
- Applies cleanly to this tree
- Reachable from SMB client ACL/security operations
- Consistent with prior ksmbd leak fixes already in stable trees

**AGAINST backport:**
- Error path only (ENOMEM during encoding) — not a crash/corruption bug
- Affects ksmbd users only (`CONFIG_SMB_SERVER`)
- No syzbot/user crash report

**Unresolved:**
- Full lore review thread content (fetch blocked)
- No explicit stable nomination found in accessible sources

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard cleanup pattern;
   maintainer reviewed/acked; cherry-pick applies cleanly
2. Fixes a real bug? **PASS** — verified leak on `goto out` after
   `ndr_encode_v4_ntacl()` failure
3. Important issue? **PASS (MEDIUM)** — memory leak on server error
   path, worsens under memory pressure
4. Small and contained? **PASS** — 1 file, 1 line moved
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean cherry-pick

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs fix — standard
bug fix)

### Step 9.4: Decision rationale
For Linux **6.18.44**, the buggy code exists, the fix is absent, and the
patch is a minimal, maintainer-acked correction of a long-standing
error-path memory leak in ksmbd security-descriptor xattr handling.
While not crash-critical, it meets stable criteria for a real, contained
bug fix with low regression risk and established precedent in this
subsystem.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no syzbot/Reported-by;
  Acked-by Namjae Jeon confirmed
- **[Phase 2]** Read diff and `vfs.c`/`ndr.c`; confirmed leak mechanism
  and fix correctness
- **[Phase 3]** `git blame`: bug since `f44158485826c` (2021); `b4 dig
  -a`: v1→v2 series; fix is patch 1/3, standalone
- **[Phase 3]** `git log master`: fix at `d4d56b00c7df8`, not in HEAD
  (6.18.44)
- **[Phase 4]** `b4 dig -c d4d56b00c7df8`: lore URL found; `b4 dig -w`:
  maintainers CC'd
- **[Phase 4]** WebFetch/curl lore: **blocked** (403/bot protection) —
  reviewer comments/stable nomination unverified
- **[Phase 5]** `grep` callers: `smbacl.c` (×2), `smb2pdu.c` (×1); SMB2
  SET_INFO security path confirmed
- **[Phase 5]** `ndr.c`: `ndr_encode_v4_ntacl()` allocates without
  error-path free confirmed
- **[Phase 6]** `git describe HEAD`: 6.18.44; buggy code at lines
  1572–1573 confirmed present
- **[Phase 6]** `git cherry-pick --no-commit d4d56b00c7df8`: clean apply
- **[Phase 6]** `git log --grep="sd_ndr.data memory leak"`: no existing
  fix in tree
- **[Phase 7]** `git log --oneline -20 -- fs/smb/server/`: active
  subsystem with prior leak fixes
- **[Phase 8]** Precedent: `78ad2c277af4c` similar ksmbd xattr leak fix
  exists in tree history

**YES**

 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 32009ff8dfa45..263032adf0cd8 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1575,8 +1575,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.53.0

