Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F54B53EB;
	Mon, 31 Aug 2026 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184348; cv=none; b=W9ToU6eem5zTZ5uMQ1s/7rQFf1HWnBcjo7BeiP609uMobdMzEi3SgPLYajID0kS9I5ES04UbNsNxjKhKTS28xr36hn4PgKXUCnG6exUXYdAobUlF2EznBGL+ugN0Lbl2sRIh+BfI8mX9BiRdvFIMW66MFRhpsbuJqgpBGNY239g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184348; c=relaxed/simple;
	bh=/5H2QMsFBdC/sHjNWmW+6+m3DluKWJ2DzZGs/u8fOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtCSvLxwXfdnY96oo0/kRC5yrXhDof/rrxSyZwMM3/7YWAjHtvZgL63qODx2LHzmPE8xRgth7MfF9WBUJezn9ARPxDi9us9cC9ONms/MZ2oscwdf+NufJNWUejsbLLbSpamgmqXBwd6shQy5Zp8qT1aXZ4qiAlLXfMIXAJhYZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZvuqgkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZvuqgkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116701F000E9;
	Mon, 31 Aug 2026 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184345;
	bh=x1Z0q7I5beFOwnfBY2vAbNAJbzVWmodoMg+XIypW9KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZvuqgkM5+riojTT/1a9VqynfR2TRrcsxsNnFE2ctPD3NPNV2HsSh40LNbCuezzHQ
	 qnxxf7u06erAtXIRd8xfTTU7ixXiE0HXwbK2T/Lz6CRyfqRbUH++v/JDOC3//ghS2s
	 z8nwugveQ5s0vEfRoE/IallyTf9y1jF87Uecofn0QZ2un3+reQTor3o6WLQc3LTSSd
	 FIFguoOlMGE8kPpCUjz34YlCbPxRswdOfPCSvGn1YlFdpqhFYRcjxI6vPgtMoCN7Pu
	 knKJL3+C5ARHXDWC5URUxM95DXmmAlGOqiWTdVmM1zNQVelup5u+yDQmoRjqxjZfmr
	 z86aDnkHF0URw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: treat unnamed DATA stream as base file
Date: Mon, 31 Aug 2026 09:31:07 -0400
Message-ID: <20260831133314.4125787-639-sashal@kernel.org>
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

[ Upstream commit 171b5d72dd80f99271c073c6e38d5263687c3b6d ]

The SMB path suffix :: names the unnamed data stream of the base
file, not an alternate data stream backed by a DosStream xattr.

Canonicalize an empty stream name with an explicit  type to a NULL
stream name after parsing. This keeps the base filename produced by
strsep() and lets open continue through the normal base-file path instead
of looking for a non-existent empty stream xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd] [treat] — Correctly handle SMB `::$DATA` paths as
the base file's unnamed data stream, not as an alternate DosStream
xattr.`

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>`, Steve French
  `<stfrench@microsoft.com>`
- **Notable:** Part of `[PATCH 7/14]` series
  (`20260618141739.9029-7-linkinjeon@kernel.org`); no syzbot, no
  explicit stable nomination in the patch.

### Step 1.3: Body analysis
**Record:**
- **Bug:** SMB path suffix `::$DATA` names the *unnamed* (default) data
  stream of the base file per SMB/NTFS semantics, not an alternate
  stream stored in a `DosStream` xattr.
- **Symptom:** `parse_stream_name()` leaves `stream_name` pointing to an
  empty string (`""`), which is non-NULL. Callers treat that as an
  alternate stream and look up a non-existent empty-stream xattr;
  `FILE_OPEN` fails with `-EBADF`.
- **Root cause:** Empty stream name after parsing `file::$DATA` is not
  canonicalized to NULL, so the stream-specific open path is taken
  instead of the normal base-file path.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite the neutral verb "treat", this is a functional
correctness fix for SMB CREATE/open when clients use explicit `::$DATA`
syntax (common Windows behavior).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `fs/smb/server/misc.c` (+11 / −3)
- **Function:** `parse_stream_name()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Init | `*stream_name` unset | `*stream_name = NULL` at entry |
| Type detection | Sets `*s_type` inline | Tracks `has_stream_type =
true` when `$DATA` or `$INDEX_ALLOCATION` matched |
| Empty unnamed stream | `*stream_name = s_name` (empty string, non-
NULL) | If `has_stream_type && !s_name[0] && *s_type == DATA_STREAM`,
skip assignment and `goto out` with `stream_name == NULL` |

**Affected path:** SMB2 CREATE/open (and any other caller of
`parse_stream_name()` when path contains `::$DATA`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (wrong interpretation of SMB
  stream syntax)
- **Mechanism:** For `file::$DATA`, `strsep()` yields `s_name=""`. A
  non-NULL pointer to `""` passes `if (stream_name)` in `smb2_create()`
  and triggers `smb2_set_stream_name_xattr()`, which builds
  `user.DosStream.:$DATA` via `ksmbd_vfs_xattr_stream_name()` and fails
  lookup on `FILE_OPEN` (`-EBADF` at lines 2502–2504 of `smb2pdu.c`).
  With the fix, `stream_name == NULL` and the normal base-file open path
  runs.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and matches SMB semantics.
- Initializing `*stream_name = NULL` is correct defensive practice.
- Only empty **DATA** streams are canonicalized; named streams
  (`file:alt::$DATA`) and `$INDEX_ALLOCATION` paths are unchanged.
- **Minor concern:** `smb2_rename()` also calls `parse_stream_name()`
  and passes `stream_name` to `ksmbd_vfs_xattr_stream_name()` without a
  NULL check. Deleting the default unnamed `$DATA` stream via rename is
  not a normal SMB operation; this edge case appears unreachable in
  practice and was already broken with the empty-string xattr lookup.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `parse_stream_name()` introduced in `e2f34481b24db` ("cifsd:
add server-side procedures for SMB3", 2021-03-16). Confirmed ancestor of
current HEAD. Bug present since initial stream parsing; file later moved
to `fs/smb/server/misc.c` in `38c8a9a520825`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent `misc.c` changes in this tree: `c7c884a1305aa` (path
resolution), `0066f623bce8f` (__GFP_RETRY_MAYFAIL), directory move. No
conflicting stream-parsing changes. Fix is standalone (patch 7/14 of a
series, but only touches `misc.c` with no structural dependencies on
other patches).

### Step 3.4: Author context
**Record:** Namjae Jeon is the ksmbd maintainer. Patch is from the June
2026 ksmbd server fixes series later referenced in Steve French's GIT
PULL.

### Step 3.5: Dependencies
**Record:** None. `has_stream_type` is local; `DATA_STREAM` enum already
exists in `vfs.h`. Applies cleanly to current `misc.c` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 178b490...` failed (commit not in this checkout).
- Found patch in local mbox:
  `20260618_linkinjeon_ksmbd_validate_smb2_lease_create_contexts.mbx`,
  `[PATCH 7/14]`, Message-Id
  `20260618141739.9029-7-linkinjeon@kernel.org`.
- lore.kernel.org fetch blocked (bot protection).
- Web search: commit listed in June 2026 `[GIT PULL] ksmbd server fixes`
  under "Tighten CREATE and stream semantics, including ... unnamed DATA
  stream handling".

### Step 4.2: Reviewers
**Record:** Patch has author SOB and Steve French SOB. No Reviewed-
by/Acked-by in the mbox entry. Series CC'd to linux-cifs (inferred from
series context).

### Step 4.3: Bug reports
**Record:** No formal bug report or syzbot link. Related GitHub issue
#507 discusses separate stream SetInfo/truncation bugs, not this
specific `::$DATA` parsing issue.

### Step 4.4: Series context
**Record:** Patch 7/14 of a larger ksmbd fix series. This patch is self-
contained and does not require other series patches.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific patch.
(Unrelated ksmbd stream patches have been nominated to stable
historically.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `parse_stream_name()` (modified). Callers: `smb2_create()`
and `smb2_rename()` in `smb2pdu.c`.

### Step 5.2: Callers
**Record:**
- **`smb2_create()`** (line 2979): Called when `strchr(name, ':')` and
  streams share flag set — primary SMB2 CREATE/open path, reachable from
  any SMB client.
- **`smb2_rename()`** (line 6125): Stream-delete rename path; less
  common.

### Step 5.3: Callees
**Record:** `strsep()`, `strchr()`, `ksmbd_validate_stream_name()`,
`strncasecmp()`. Downstream in open path: `smb2_set_stream_name_xattr()`
→ `ksmbd_vfs_xattr_stream_name()` → xattr lookup/create.

### Step 5.4: Reachability
**Record:** Any SMB client opening a file with explicit `::$DATA` suffix
(standard Windows unnamed-stream notation) on a ksmbd share with
`KSMBD_SHARE_FLAG_STREAMS` enabled triggers the bug. Reachable from
network clients without special privileges.

### Step 5.5: Similar patterns
**Record:** Related but distinct stable-worthy stream fixes exist in
ksmbd history (e.g., default stream in FILE_STREAM_INFORMATION). This
fix addresses CREATE/open parsing specifically.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code in tree?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). `parse_stream_name()` at lines 119–151 of
`fs/smb/server/misc.c` lacks the fix (`has_stream_type` not present).
Bug has existed since ksmbd stream support landed (2021).

### Step 6.2: Backport complications
**Record:** Clean apply expected — `misc.c` is stable, minimal recent
churn, no conflicting edits at the target hunk.

### Step 6.3: Fix already present?
**Record:** **No.** `git grep has_stream_type` only finds the patch in
the mbox file, not in the tree. Fix commit not in this checkout.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **ksmbd** (in-kernel SMB server) under `fs/smb/server/`.
**IMPORTANT** — affects users who run the kernel SMB server
(`CONFIG_SMB_SERVER` in `fs/smb/server/Kconfig`), not all kernel users.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent commits in this tree include UAF
fixes, NEGOTIATE fixes, and DACL validation — indicating ongoing ksmbd
stable fix activity.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users running ksmbd with alternate data streams enabled on a
share, accessed by SMB clients (especially Windows) that open files
using `::$DATA` syntax.

### Step 8.2: Trigger conditions
**Record:** Client sends SMB2 CREATE for a path like
`document.docx::$DATA`. Common when streams support is enabled. Not
timing-dependent; deterministic logic bug.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM-HIGH** — file open fails (`-EBADF` / SMB error),
breaking interoperability. No kernel crash/oops, but prevents access to
files that should open normally. Can affect Office documents and other
apps using explicit default-stream paths.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores correct open behavior for standard SMB unnamed
  data stream syntax; fixes long-standing interoperability bug.
- **Risk:** Very low — ~11 lines, one function, no API changes,
  maintainer-authored.
- **Ratio:** Strong benefit, minimal risk for ksmbd users.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible functional bug in SMB2 CREATE/open
- Long present since 2021 stream parsing code
- Small, surgical, maintainer-authored fix
- Buggy code confirmed in local 6.18.44 tree; fix not yet applied
- Part of reviewed ksmbd server fixes pull request
- Correct per SMB/NTFS `::$DATA` semantics

**AGAINST backport:**
- Only affects ksmbd server users (not universal)
- No syzbot/CVE/crash report
- Theoretical rename-path NULL concern for `::$DATA/` stream delete
  (likely invalid SMB operation, unverified)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches SMB spec;
   maintainer series merged to mainline.
2. Fixes a real bug affecting users? **PASS** — open failures for
   `::$DATA` paths.
3. Important issue? **PASS** — MEDIUM-HIGH severity interoperability
   failure on file open.
4. Small and contained? **PASS** — 1 file, ~14 lines.
5. No new features or APIs? **PASS** — parsing correction only.
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies as a standard bug fix.

### Step 9.4: Problem and decision

Windows and other SMB clients commonly reference the default data stream
with the `::$DATA` suffix. ksmbd's `parse_stream_name()` incorrectly
treats the resulting empty stream name as an alternate stream, routing
opens through xattr lookup that fails. The fix canonicalizes an empty
stream name with explicit `$DATA` type to NULL, allowing normal base-
file open — exactly what SMB semantics require.

For the **6.18.44** tree checked out here, ksmbd is present, the buggy
code is present, and the fix is small, correct, and addresses a real
interoperability failure for SMB server deployments.

---

## Verification

- **[Phase 1]** Parsed subject, body, tags from user-provided commit
  message and mbox
  `20260618_linkinjeon_ksmbd_validate_smb2_lease_create_contexts.mbx`.
- **[Phase 2]** Read diff and current `parse_stream_name()` at lines
  119–151 of `fs/smb/server/misc.c`.
- **[Phase 2]** Traced open failure: `smb2_create()` line 2979 → `if
  (stream_name)` line 3184/3451 → `smb2_set_stream_name_xattr()` →
  `ksmbd_vfs_xattr_stream_name()` lines 1800–1818 → `FILE_OPEN` returns
  `-EBADF` lines 2502–2504.
- **[Phase 3]** `git blame -L 119,151 fs/smb/server/misc.c`: introduced
  `e2f34481b24db` (2021-03-16).
- **[Phase 3]** `git merge-base --is-ancestor e2f34481b24db HEAD`:
  confirmed ancestor.
- **[Phase 3]** `git log --oneline -20 -- fs/smb/server/misc.c`: no
  conflicting stream changes.
- **[Phase 4]** `b4 dig -c 178b490e56d8d4711c0c61d37652bcfd1269d5b0`:
  failed (commit not in tree).
- **[Phase 4]** Grep mbox for patch 7/14: found full diff and Message-
  Id.
- **[Phase 4]** lore.kernel.org fetch: blocked by bot protection.
- **[Phase 4]** Web search: found GIT PULL reference listing this fix
  under stream semantics.
- **[Phase 5]** `grep parse_stream_name`: callers at `smb2pdu.c:2979`
  and `smb2pdu.c:6125`.
- **[Phase 5]** Read `smb2_create()` stream handling at lines 3175–3458.
- **[Phase 5]** Read `ksmbd_vfs_xattr_stream_name()` at
  `vfs.c:1800–1818`.
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44.
- **[Phase 6]** `grep has_stream_type`: only in mbox, not in tree — fix
  absent.
- **[Phase 6]** Read current `misc.c` lines 119–151: buggy code
  confirmed.
- **[Phase 7]** Read `fs/smb/server/Kconfig`: ksmbd server is
  `CONFIG_SMB_SERVER`.
- **[Phase 8]** Traced `file::$DATA` parsing manually via `strsep()`
  logic.
- **UNVERIFIED:** Whether any SMB client issues rename/delete for
  `::$DATA/` (theoretical NULL concern in `smb2_rename()`).

**YES**The background git searches didn’t add much beyond what we
already had:

- **Find commit hash:** Finished with no matches — `has_stream_type` and
  the commit subject aren’t in this 6.18.44 tree, which matches the fix
  not being applied yet.
- **Search git history:** Didn’t complete (timed out / was stopped). The
  commit was already identified from the local mbox (`[PATCH 7/14]`) and
  the GitHub mirror (`178b490`).

The backport recommendation stands: **YES** for this tree — ksmbd
mishandles `::$DATA` opens, and the fix is a small, self-contained
change in `fs/smb/server/misc.c`.

 fs/smb/server/misc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 53ddcae31f719..d6abe574fc89b 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -121,7 +121,9 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 	char *stream_type;
 	char *s_name;
 	int rc = 0;
+	bool has_stream_type = false;
 
+	*stream_name = NULL;
 	s_name = filename;
 	filename = strsep(&s_name, ":");
 	ksmbd_debug(SMB, "filename : %s, streams : %s\n", filename, s_name);
@@ -137,14 +139,20 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 
 		ksmbd_debug(SMB, "stream name : %s, stream type : %s\n", s_name,
 			    stream_type);
-		if (!strncasecmp("$data", stream_type, 5))
+		if (!strncasecmp("$data", stream_type, 5)) {
 			*s_type = DATA_STREAM;
-		else if (!strncasecmp("$index_allocation", stream_type, 17))
+			has_stream_type = true;
+		} else if (!strncasecmp("$index_allocation", stream_type, 17)) {
 			*s_type = DIR_STREAM;
-		else
+			has_stream_type = true;
+		} else {
 			rc = -ENOENT;
+		}
 	}
 
+	if (has_stream_type && !s_name[0] && *s_type == DATA_STREAM)
+		goto out;
+
 	*stream_name = s_name;
 out:
 	return rc;
-- 
2.53.0

