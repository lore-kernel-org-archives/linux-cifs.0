Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2994B2CD0;
	Mon, 31 Aug 2026 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184308; cv=none; b=HpHJ2cugTGmhau1ZMuO+NhZOdpNQV8hrwEB4WuuLMR3RArhVAccVkIhYTP7LwocmFXmnlQSCjTe/zdfNF3noizbqzLk/gLd8ccCMrvIPsAh3IeVh/a/OywB+LqpoS0Fm3D8YMgL9qxEfGOkGofBH2rFG+/VtxqRYULgXeo5IjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184308; c=relaxed/simple;
	bh=+bgH+6fQdc0CDeEey0yKNHCaY9sWUoyXx5KIn1hcxqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJDnFG09oh+j4xB57+WMPw408lFf14mAH2y0aZ4h89cOUCIR4rpvHbWGQa9+aneTYJ7ES3I1yWXCFuqHK6vcXjZjzNONBZLd0daV2aXqVF9t0F1nB6Vd34FonShskSHOgdfYXhsTcjAOL8htrc0kbTvvuQgp1KSr4wcn5XbZWYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB5u/KGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB5u/KGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3631F00ACA;
	Mon, 31 Aug 2026 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184305;
	bh=DYuIMm6sOTCZzKxDv31EBBEdn7Pb+U/nNZcyAaoStBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB5u/KGMgMzBHQCKDydd5H3ovsYG5cLLeaM0bq0hN+MwTcAQtO6jqnBRHPQFy/jS7
	 W91hbFs1tnoeGeviUoJDFIVk4Z/DJVNhdw4EUI4z5a7I5cDt5wKrltAls0Ul5EmbDx
	 BKVhhCO48YdMLT1ogN7YW3PCi4jn4fs9QRAatXv8rY9BzUhz7bAEUXkW8Mm5qqb8f+
	 yoHH+xc2z28vdhWyPEG7dBiyJ6OtfYzZqAkP+iKT1k3i8ywoOaMrUBJIP35+OmSAxp
	 qj5+oCSrboBud5NypHwK06sKTie8sZf3b5DXooU8V2ldhWLToK1B2nm3GGEJCB3Rxe
	 4/VcQuGkkYvNg==
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
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Mon, 31 Aug 2026 09:30:41 -0400
Message-ID: <20260831133314.4125787-613-sashal@kernel.org>
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

[ Upstream commit 7ac657bb9c5c1b0f7bdf1fa6d3ad532f969be5cf ]

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: fix n.data memory leak in
ksmbd_vfs_set_dos_attrib_xattr`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `make kernelversion`
= 6.18.44)
**Commit under review:** `7ac657bb9c5c1` (on `master`, **not yet** in
this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd]` `[fix]` — memory leak of `n.data` in
`ksmbd_vfs_set_dos_attrib_xattr` when `ndr_encode_dos_attr()` fails.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Qiang Liu `<liuqiang@kylinos.cn>` (author)
- **Reviewed-by:** ChenXiaoSong `<chenxiaosong@kylinos.cn>`
- **Acked-by:** Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd maintainer)
- **Signed-off-by:** Steve French `<stfrench@microsoft.com>` (committer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, or `Tested-by:`
  tags
- Notable: maintainer **Acked-by** is a strong quality signal

### Step 1.3: Body analysis
**Record:**
- **Bug:** `ndr_encode_dos_attr()` allocates an NDR buffer (`n.data`);
  on encoding error, `ksmbd_vfs_set_dos_attrib_xattr()` returned early
  without `kfree(n.data)`.
- **Symptom:** Memory leak (no crash/corruption described).
- **Root cause:** Missing cleanup on the `ndr_encode_dos_attr()` error
  path.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled as a memory leak fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/smb/server/vfs.c` only (+3 / −2 lines)
- **Function modified:** `ksmbd_vfs_set_dos_attrib_xattr()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| Error from `ndr_encode_dos_attr()` | `return err;` (leaks `n.data`) |
`goto out;` |
| Success path cleanup | `kfree(n.data); return err;` | `out:
kfree(n.data); return err;` |

Both success and error paths now converge at `out:` and always free
`n.data` when it was allocated.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Resource leak on error path
- **Mechanism:** `ndr_encode_dos_attr()` calls `kzalloc(1024)` then may
  fail in `ndr_write_string()` / `ndr_write_int*()` via
  `try_to_realloc_ndr_blob()` returning `-ENOMEM`. The caller returned
  without freeing the already-allocated buffer.

Verified in `ndr.c`:

```170:188:fs/smb/server/ndr.c
int ndr_encode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
{
        // ...
        n->data = kzalloc(n->length, KSMBD_DEFAULT_GFP);
        if (!n->data)
                return -ENOMEM;
        // ... ndr_write_* calls that can return -ENOMEM ...
        if (ret)
                return ret;
```

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors the `goto out` + `kfree`
  pattern used elsewhere in the same file (e.g.
  `ksmbd_vfs_set_sd_xattr`, `ksmbd_vfs_get_dos_attrib_xattr`).
- **Regression risk:** Very low — only adds cleanup on a previously
  leaked path.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy logic introduced in `f44158485826c` ("cifsd: add file
  operations", 2021-05-10).
- Function has been in ksmbd/cifsd since v5.13 era; present in this
  6.18.y tree at `fs/smb/server/vfs.c:1651–1670`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:**
- Part of v2 series: `[PATCH v2 0/3] ksmbd: fix some memory leaks in
  ksmbd_vfs_* functions`
- Sibling commits on `master`:
  - `d4d56b00c7df8` — `sd_ndr.data` leak in `ksmbd_vfs_set_sd_xattr`
  - `d708a36634bb7` — `acl.sd_buf` leak in `ksmbd_vfs_get_sd_xattr`
  - `7ac657bb9c5c1` — this commit (patch 3/3)
- **This commit is standalone** — fixes a different function; no
  dependency on siblings.

### Step 3.4: Author context
**Record:** Qiang Liu submitted the 3-patch leak-fix series. Namjae Jeon
(maintainer) Acked all three. Steve French committed.

### Step 3.5: Prerequisites
**Record:** None. `git apply --check` against this tree succeeds
cleanly. No structural/API assumptions beyond existing code.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260624011320.9146-4-liuqiangneo@163.com
- **Series revisions:** v1 (2026-06-23), v2 (2026-06-24); committed
  version matches v2 patch 3/3
- **Lore fetch:** Blocked by Anubis bot protection — could not read
  thread body for stable nominations or NAKs

### Step 4.2: Reviewers (b4 dig -w)
**Record:** CC'd to Steve French, Namjae Jeon, Ronnie Sahlberg, linux-
cifs@vger.kernel.org, and other ksmbd maintainers/reviewers.

### Step 4.3: Bug report
**Record:** N/A — no external bug report or syzbot link.

### Step 4.4: Related patches
**Record:** 3-patch series fixing independent leaks in `vfs.c`. Other
two patches are also absent from this tree but are not prerequisites for
this one.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable search blocked by bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ksmbd_vfs_set_dos_attrib_xattr()` modified;
`ndr_encode_dos_attr()` is the allocator whose errors were mishandled.

### Step 5.2: Callers
**Record:** Three call sites in `smb2pdu.c`, all behind
`KSMBD_SHARE_FLAG_STORE_DOS_ATTRS`:
1. `smb2_new_xattrs()` — file creation (called from `smb2_open` path)
2. `set_file_basic_info()` — SMB2 SET_INFO (file attribute/time updates)
3. `fsctl_set_sparse()` — FSCTL_SET_SPARSE IOCTL

All are SMB2 protocol handlers reachable by remote clients when the
share stores DOS attributes in xattrs.

### Step 5.3: Callees
**Record:** `ndr_encode_dos_attr()` → `kzalloc` / `krealloc` /
`ndr_write_*`; `ksmbd_vfs_setxattr()` on success path.

### Step 5.4: Reachability
**Record:** Reachable from network clients performing file create, set-
info, or sparse-file FSCTL on shares with `STORE_DOS_ATTRS` enabled
(`CONFIG_SMB_SERVER`). Trigger for the leak requires
`ndr_encode_dos_attr()` to fail after allocation (typically `-ENOMEM`
under memory pressure).

### Step 5.5: Similar patterns
**Record:** Same file already uses `goto out` + `kfree` for NDR buffers
in `ksmbd_vfs_set_sd_xattr` and `ksmbd_vfs_get_sd_xattr`. Sibling commit
`d4d56b00` applies the identical pattern fix to `sd_ndr.data` in
`ksmbd_vfs_set_sd_xattr`. This tree already has a precedent backport:
`d026f47db6863` ("ksmbd: Fix memory leak in get_file_all_info()").

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `vfs.c:1659–1661`:

```1659:1661:fs/smb/server/vfs.c
        err = ndr_encode_dos_attr(&n, da);
        if (err)
                return err;
```

Bug present since 2021; well predates 6.18.y branch.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passes with no
conflicts. File layout matches mainline.

### Step 6.3: Related fixes already present?
**Record:** Fix commit `7ac657bb9c5c1` is **NOT** in HEAD. Sibling
series commits `d4d56b00` and `d708a36634bb7` also **NOT** in HEAD. No
duplicate fix for this specific leak found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/smb/server` (ksmbd SMB3 server). **IMPORTANT** — affects
users running in-kernel SMB server (`CONFIG_SMB_SERVER`), not universal
but security/stability-sensitive for deployments using it.

### Step 7.2: Subsystem activity
**Record:** Highly active in 6.18.y — recent backports include UAF
fixes, integer overflow, ACL validation, transport leaks. Memory leak
fixes are routinely accepted.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_SMB_SERVER` enabled and shares configured
with `STORE_DOS_ATTRS`. Driver/server-specific, not all kernel users.

### Step 8.2: Trigger conditions
**Record:** SMB file create, SET_INFO, or sparse FSCTL that stores DOS
attributes; `ndr_encode_dos_attr()` must fail after `kzalloc` (most
likely `-ENOMEM` during NDR buffer growth). Unprivileged remote clients
can trigger the code path; the leak itself requires the encoding error.

### Step 8.3: Failure mode severity
**Record:** Memory leak (~1 KB+ per failed encode, potentially more if
reallocs occurred). **Severity: MEDIUM** — no direct crash/corruption,
but under memory pressure the leak worsens OOM conditions in an active
server path.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents per-operation leaks in a commonly-used ksmbd
  path; aligns with existing stable backport policy for ksmbd leak
  fixes.
- **Risk:** Minimal — 5-line, obviously correct cleanup addition.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified memory leak on error path (code inspection confirms)
- Bug present since 2021, exists in this 6.18.44 tree
- Surgical 5-line fix, applies cleanly
- Acked-by subsystem maintainer (Namjae Jeon)
- Reachable from SMB2 client operations on active server paths
- Precedent: similar ksmbd leak fix already backported to this tree
  (`d026f47db6863`)
- Under memory pressure, leak compounds the failure mode

**AGAINST backport:**
- Only triggers on `ndr_encode_dos_attr()` failure (typically ENOMEM),
  not the common success path
- No user crash reports, syzbot, or CVE
- Lore thread content unverified (bot blocked)

**Unresolved:** Whether reviewers explicitly nominated for stable on
lore (could not fetch thread).

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard `goto
out`/`kfree` pattern; Reviewed-by + Acked-by; no Tested-by |
| 2. Fixes a real bug affecting users? | **PASS** — verified leak on SMB
server error path |
| 3. Important issue? | **PASS (borderline)** — MEDIUM severity memory
leak in active server code; not crash/corruption but worsens OOM |
| 4. Small and contained? | **PASS** — 1 file, 5 lines |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — clean apply verified |

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies as a standard bug fix.

### Step 9.4: Decision rationale
This is a small, maintainer-acked fix for a long-standing resource leak
in ksmbd's DOS-attribute xattr storage path. The leak is real and
verified by reading `ndr_encode_dos_attr()` and the caller. While it
only fires on encoding errors (typically under memory pressure), that is
exactly when leaking memory is most harmful. The fix is trivial, applies
cleanly to 6.18.44, and matches established precedent for ksmbd leak
fixes already backported to this stable tree.

---

## Verification

- **[Phase 1]** Parsed commit `7ac657bb9c5c1` message and tags via `git
  show`
- **[Phase 2]** Read diff and current `vfs.c:1651–1670` and
  `ndr.c:170–227` — confirmed leak mechanism
- **[Phase 3]** `git blame -L 1651,1670` — bug since `f44158485826c`
  (2021-05-10)
- **[Phase 3]** `git merge-base --is-ancestor 7ac657bb9c5c1 HEAD` — fix
  **NOT** in tree
- **[Phase 3]** `git apply --check` — patch applies cleanly
- **[Phase 3]** Identified 3-patch series on master; confirmed this
  patch is independent
- **[Phase 4]** `b4 dig -c 7ac657bb9c5c1` — found lore URL and v1/v2
  revisions
- **[Phase 4]** `b4 dig -c 7ac657bb9c5c1 -w` — maintainer CC list
  confirmed
- **[Phase 4]** WebFetch lore — blocked by Anubis (UNVERIFIED: thread
  review comments)
- **[Phase 5]** `grep ksmbd_vfs_set_dos_attrib_xattr` — 3 callers in
  `smb2pdu.c` identified
- **[Phase 5]** Read caller context: `smb2_new_xattrs`,
  `set_file_basic_info`, `fsctl_set_sparse`
- **[Phase 6]** `git describe HEAD` = v6.18.44; `make kernelversion` =
  6.18.44
- **[Phase 6]** Buggy code confirmed present at `vfs.c:1659–1661`
- **[Phase 6]** `git log --grep='memory leak in get_file_all_info'` —
  precedent backport `d026f47db6863` in tree
- **[Phase 7]** `git log --oneline -20 -- fs/smb/server/` — active ksmbd
  maintenance in 6.18.y
- **[Phase 8]** Assessed trigger (ENOMEM on NDR encode) and severity
  (MEDIUM leak)

**YES**The sibling-patch check finished successfully: neither
`d4d56b00c7df8` (`sd_ndr.data` leak in `ksmbd_vfs_set_sd_xattr`) nor the
other series commits are in this `6.18.44` tree. That doesn’t block this
backport — `7ac657bb9c5c1` is a standalone fix for
`ksmbd_vfs_set_dos_attrib_xattr`, applies cleanly, and the leak is still
present here.

**Verdict for this tree: YES** — small, maintainer-acked error-path
memory leak fix in an active ksmbd SMB2 path.

 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 263032adf0cd8..859ca7c87bd4c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1664,14 +1664,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 
 	err = ndr_encode_dos_attr(&n, da);
 	if (err)
-		return err;
+		goto out;
 
 	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
-	kfree(n.data);
 
+out:
+	kfree(n.data);
 	return err;
 }
 
-- 
2.53.0

