Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C705F57506D;
	Mon, 19 Oct 2026 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418310; cv=none; b=EXPVDZhHDQN0YkeyZ4vykENumG3TeMvZS9uoNdH8N2qb0r9hlhw+MWaxD2DVWfSyp/oRj7LMrDj51iyPB2G17ZJZeFQuYXCcX8PljSzquhu3GacyBXGEZ0gqfrXsil06riqxNhB94vMzzzdr8AeqDhoImFR+WCc43X1OX+uin70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418310; c=relaxed/simple;
	bh=tBT/ixsPrVjMDuVRus7A/d5NbWNakWih/48L2P821TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+pkb8R3fUe956NtBqa4SjIsGJju2RAzVMpQwd2PyiVN3uwHQ+O3x21wtTqgC1SUREeJgCxAoJu4XVnnsFu5o0H8PQSOn/JMXhuDKSFWyIJRbyRkEfcS5p7JK+EYnJYY5hohCOfFAlx0twOX09xZINjUoltsgZ0xcMqX44RojXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyAYEPHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyAYEPHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10E31F000CA;
	Mon, 19 Oct 2026 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418306;
	bh=6j0Z5kReX2UGboGTC6pcYi3lKFI5nl0jkWUa/bWWceo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyAYEPHZQPDK11yaRNCZzA9BMbM7dgdXuDAu8Naw46cjRg8Lf9gDKfIfSUl/nA1Pn
	 afjwPjiHVi0b2l4VoU88eGyNronldWUczs1WduxSae5vtftnPAH3YDQbgAodIfngFn
	 CzZ5f87FSdppNgV9C6xyzhXBa8dgMSgbbj3ScNLPR915ahZ5Cda7z1eOO48NwdStUH
	 u4RXD6M+Jyp6PL3vcSYHWSivMdgiuCor+di/CP6M7uq/9MyseaweeWWImMusitm5Bm
	 kozCgJzwDDt7sFs5yGtoJCp1ISojnvYkBe8Ly40+ARBR1vPyApuGMJdHRvwCpXvGr4
	 OyiJkdGReYiHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: report actual xattr value length in stream enumeration
Date: Mon, 19 Oct 2026 09:47:25 -0400
Message-ID: <20261019135441.1420968-154-sashal@kernel.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 689f1eb3719d61700b58f984ac8602837f004f8c ]

get_file_stream_info() (FileStreamInformation QUERY_INFO) reported
each enumerated stream's StreamSize/StreamAllocationSize as
stream_name_len -- the byte length of the stream's *name*, not its
data. This is the same bug class already fixed for EndOfFile/
AllocationSize on an open stream handle (ksmbd_stream_eof()), just
missed at this second site: a client enumerating streams sees a size
derived from the name string length instead of the stream's actual
content length, inconsistent with what querying the same stream by
handle reports.

Compute the real value length the same way ksmbd_stream_eof() does,
via ksmbd_vfs_casexattr_len() on the already-known xattr key.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The patch applies cleanly on this 6.12 tree. I’ll now walk through the
nine-phase analysis and the YES/NO decision.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[ksmbd] [report] report actual xattr value length in stream
enumeration`

Subsystem prefix is `ksmbd`. The verb is “report” (correctness: the
server currently reports the wrong length). Intent:
FileStreamInformation must return the stream’s data size, not the xattr
name length.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record (from the candidate text and from `689f1eb3719d` /
`628ee3ef79ba3`):

- `Assisted-by: Claude:claude-sonnet-5`
- `Signed-off-by: Gael Blivet <gael.blivet@gmail.com>`
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (candidate /
  ksmbd tree)
- `Acked-by: Namjae Jeon` + `Signed-off-by: Steve French` on
  `628ee3ef79ba3`
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Link:`

Notable: ksmbd maintainer sign-off/ack. No syzbot. Ignore any pipeline
“Upstream commit” / Sasha Levin SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:

- **Bug:** `get_file_stream_info()` (SMB2 QUERY_INFO
  `FileStreamInformation`) stores `stream_name_len` in `StreamSize` and
  `StreamAllocationSize`. That is the xattr *name* byte length, not the
  stream payload length.
- **Symptom:** A client enumerating ADS sees sizes derived from the name
  string (`user.DosStream.<name>:$DATA`), inconsistent with MS-FSCC and
  with querying the same stream by handle (after the related
  `ksmbd_stream_eof()` fix).
- **Failure mode:** Wrong stream sizes to Windows `FindFirstStream` /
  copy / backup. Clients that trust `StreamSize` can truncate ADS data.
- **Version info:** None in the message. The buggy assignment dates to
  the original cifsd SMB3 code (2021).
- **Root cause:** Name length reused as content size; second site of the
  same class as `ksmbd_stream_eof()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. Explicit protocol-correctness fix: report xattr
**value** length instead of **name** length.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:

- File: `fs/smb/server/smb2pdu.c` only
- Scope: ~16 insertions, 2 deletions; one function
- Function: `get_file_stream_info()`
- Classification: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (verified against this tree at lines 5173–5175):

- **Before:** After converting the stream name to UTF-16, set
  `StreamSize = StreamAllocationSize = stream_name_len`
  (`stream_name_len` = xattr name minus `user.DosStream.` prefix, e.g.
  `"Zone.Identifier:$DATA"`).
- **After:** Call `ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
  path->dentry, stream_name, strlen(stream_name)+1)`, treat negative as
  0, store that as both sizes.
- **Path:** Normal QUERY_INFO `FILE_STREAM_INFORMATION` for each ADS
  xattr. Unnamed `::$DATA` still uses `stat.size` (unchanged, correct).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / correctness (wrong field used as size).** Not
UAF/leak/race. MS-FSCC `FILE_STREAM_INFORMATION.StreamSize` is “size in
bytes of the stream.” The code used the key name length. Fix queries the
xattr value length via existing `ksmbd_vfs_casexattr_len()` →
`vfs_getxattr(..., NULL, 0)`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:

- Obviously correct: same helper already used for stream xattr lookup
  (`smb2_set_stream_name_xattr`, EA delete).
- v2 changelog (lore): `strlen(stream_name)+1` so the match is exact,
  not a prefix match (`strncasecmp` in `ksmbd_vfs_casexattr_len`).
- Minimal; no API/structure changes.
- Regression risk: low. Extra `listxattr`+size probe per ADS (perf
  only). Lookup failure reports size 0 instead of name length (safer).
  Does not call `ksmbd_stream_eof()` (that helper is not in this tree).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:

- `git blame -L 5174,5175 fs/smb/server/smb2pdu.c` → `e2f34481b24db`
  (“cifsd: add server-side procedures for SMB3”, Namjae Jeon, 2021-03-16
  / committed 2021-05-10).
- Bug has been in ksmbd since the driver landed. `git merge-base --is-
  ancestor e2f34481b24db HEAD` → yes.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Introducer is `e2f34481b24db`, present in this
tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:

- Companion on `origin/master`: `a9417bb1889e` (“report actual xattr
  value length for stream EndOfFile/AllocationSize”) adds
  `ksmbd_stream_eof()`. **Not** in this 6.12 tree (`git merge-base --is-
  ancestor a9417bb1889e3 HEAD` failed).
- This enumeration patch does **not** call `ksmbd_stream_eof()`; it
  inlines the same `ksmbd_vfs_casexattr_len` pattern.
- Recent local `smb2pdu.c` work is other QUERY_INFO buffer/overflow
  fixes; nothing already corrects `StreamSize`.
- Standalone vs series: mailed as patch 3 of a 3-patch v2 set (lock on
  `stream_del_pending`, mdssvc log spam, this). Those other two are
  independent. This hunk does not need them.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Gael Blivet has no ksmbd commits in this 6.12 tree. On mainline,
a batch of stream/protocol fixes for 7.3-rc1. Maintainer Namjae applied
this immediately.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:

- Needs `ksmbd_vfs_casexattr_len()` and `file_mnt_idmap()` — both exist
  here (`vfs.h:108`, `include/linux/fs.h:2745`, used throughout
  `smb2pdu.c`).
- Does **not** require `ksmbd_stream_eof()`.
- `git apply --check` of `689f1eb3719d` succeeded: hunks at 5110 and
  5173 (offset −842).

Can apply standalone: **yes**.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:

- `b4 dig -c 689f1eb3719d` →
  https://patch.msgid.link/20260709165141.2111-3-g.blivet@me.com
- Thread saved to mbox (`b4 dig -m`).
- v1→v2: declare `slen`/`ssize` at function top; pass name length
  including NUL (exact match). Applied version is v2.
- Maintainer Namjae Jeon (2026-07-10): “Applied it to #ksmbd-for-next-
  next. Thanks!”
- No NAK, no stable nomination in the thread.
- Landed in ksmbd 7.3-rc1 pull (“Correct alternate-data-stream and
  named-stream handling”).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Namjae Jeon, `linux-cifs@vger.kernel.org`.
Maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:

- No `Reported-by` on the commit.
- GitHub namjaejeon/ksmbd#522 (“Unable to list streams”, 2026-01-07)
  notes `dir /r` vs Samba and guesses name/length mixup at the same
  lines. That report is about streams **not listing**; this patch only
  fixes **size**. I do **not** treat #522 as proof this patch restores
  listing. Independently, the size bug is visible in the code.
- Older related ADS bugs (e.g. #507 truncated files on SetInfo/EOF on a
  stream) show Windows clients really use stream size/EOF; wrong sizes
  are user-visible.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Independent of the lock and mdssvc patches in the same mail.
Companion `a9417bb1889e` (`ksmbd_stream_eof`) is the same bug class on
**open-handle** QUERY_INFO/CREATE. Not in 6.12;
`get_file_standard_info()` here still uses `stat.size` even for stream
FDs. This enumeration site is still wrong on its own and still worth
fixing.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable fetch returned 403. UNVERIFIED whether
stable@ already discussed this. Absence of `Cc: stable` is expected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `get_file_stream_info()`; new calls to
`ksmbd_vfs_casexattr_len()`.

**Step 5.2: TRACE CALLERS**

Record:

- Only caller: `smb2_get_info_file()` switch `FILE_STREAM_INFORMATION`
  (`smb2pdu.c:5476-5478`).
- That is the SMB2 QUERY_INFO handler for `FileStreamInformation`
  (Windows `FindFirstStreamW` / copy / backup).
- Context: kernel SMB server, network/syscall-equivalent from SMB
  clients, not IRQ.

**Step 5.3: TRACE CALLEES**

Record: `ksmbd_vfs_casexattr_len()` (`vfs.c:1775`) lists xattrs,
`strncasecmp` match, `ksmbd_vfs_xattr_len()` → `vfs_getxattr(..., NULL,
0)` for value length. Side effect: extra xattr probes; no lock/API
change.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: SMB client → QUERY_INFO FileStreamInformation →
`get_file_stream_info`. Reachable whenever ksmbd serves a share with ADS
in user xattrs (`user.DosStream.*`). Unprivileged SMB users who can
QUERY_INFO can trigger it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same name-vs-value confusion: `fp->stream.size` is xattr
**name** length (`smb2_set_stream_name_xattr` sets `fp->stream.size =
xattr_stream_size`). Mainline `ksmbd_stream_eof()` fixes handle
QUERY_INFO; this patch fixes enumeration. Default `::$DATA` already uses
`stat.size`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:

- `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`
- `make kernelversion` → **6.12.111**
- Branch: `pending-6.12`
- Buggy code is present:

```5173:5175:fs/smb/server/smb2pdu.c
                file_info->StreamNameLength = cpu_to_le32(streamlen);
                file_info->StreamSize = cpu_to_le64(stream_name_len);
                file_info->StreamAllocationSize =
cpu_to_le64(stream_name_len);
```

- Introduced in `e2f34481b24db` (v5.15-era cifsd), long before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: `git apply --check` clean with line offset only. Surrounding
`get_file_stream_info` body matches. Expected difficulty: **clean
apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No `ksmbd_stream_eof`, no “xattr value length” commits on
`fs/smb/server/` in this tree. Enumeration still uses `stream_name_len`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `fs/smb/server` (ksmbd). **IMPORTANT** for ksmbd deployments
(NAS, embedded SMB), not core mm/VFS. `CONFIG_SMB_SERVER` default n.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively backported in this pending-6.12 tree (QUERY_INFO
overflow, UAF, ACL, leases). Mature ADS path since 2021.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific:** ksmbd users,
Windows/macOS clients using ADS (`Zone.Identifier`, Office streams, `dir
/r`, copy/backup).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: QUERY_INFO FileStreamInformation on a file with
`user.DosStream.*` xattrs. Common on Windows-facing shares. Unprivileged
SMB users can trigger it. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:

- Failure: wrong `StreamSize`/`StreamAllocationSize` (name length,
  typically tens of bytes, not payload size).
- Clients that size ADS copies from enumeration can **truncate stream
  data**.
- Not a kernel oops/deadlock.
- Severity: **HIGH** for ADS data integrity / protocol correctness; not
  CRITICAL kernel crash.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:

- **Benefit:** Correct ADS sizes on a path Windows copy/backup uses;
  long-standing bug; small fix.
- **Risk:** Very low (~16 lines, existing helper, applies cleanly). Size
  0 on xattr lookup failure is conservative.
- **Ratio:** Benefit outweighs risk for this 6.12 tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**

- Real, long-standing protocol bug in this tree (since cifsd 2021).
- Wrong ADS size can truncate stream copies (data integrity).
- Surgical, obviously correct; v2 matched `ksmbd_vfs_casexattr_len` NUL-
  length convention.
- Maintainer applied it with no objections.
- Helpers exist; `git apply --check` succeeds.
- Does not need `ksmbd_stream_eof()`.

**AGAINST:**

- Not a crash/UAF/CVE.
- `CONFIG_SMB_SERVER` is optional.
- Companion handle-size fix (`a9417bb1889e`) is not in 6.12, so handle
  QUERY_INFO still reports `stat.size` for streams; enumeration vs
  handle remain inconsistent, but enumeration is independently wrong
  today.
- GitHub #522 listing failure is not verified as fixed by this change.

**UNRESOLVED:**

- lore.kernel.org HTTP 403; discussion recovered via `b4` mbox.
- stable@ archives not fetched (403).
- Not verified that Windows copy always uses `StreamSize` rather than
  re-querying the handle.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — maintainer applied v2; logic
   matches existing xattr-length helper.
2. Fixes a real bug that affects users? **PASS** — FileStreamInformation
   returns name length as stream size; Windows ADS clients hit this
   path.
3. Important issue? **PASS** — ADS size lie can truncate stream data;
   protocol spec violation on a production SMB server. Not a panic, but
   data-integrity for named streams.
4. Small and contained? **PASS** — one function, ~16 lines.
5. No new features or APIs? **PASS** — only fills existing SMB2 fields
   correctly.
6. Can apply to the local tree? **PASS** — buggy code present; apply-
   check clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or docs patch).
Qualifies as a normal contained bugfix.

**Step 9.4: MAKE YOUR DECISION**

This 6.12 tree still reports ADS `StreamSize` as the xattr name length.
The fix is the same `ksmbd_vfs_casexattr_len()` lookup already used in
this tree, applies cleanly, and does not depend on later
`ksmbd_stream_eof()`. That is appropriate for stable: real user-visible
metadata/data-integrity bug, tiny scope, low regression risk.

------------------------------------------------
What the commit solves and why it matters here
------------------------------------------------

On 6.12.111, `get_file_stream_info()` still does
`cpu_to_le64(stream_name_len)` for `StreamSize`/`StreamAllocationSize`.
A stream named `Zone.Identifier` is reported as roughly the length of
`"Zone.Identifier:$DATA"`, not the xattr payload. SMB clients that
enumerate streams and copy using that size can drop ADS content. ksmbd
is used as a kernel SMB3 server; that is a real interoperability and
data-integrity bug, not a cleanup.

------------------------------------------------
Stable rules / risk vs benefit
------------------------------------------------

Meets the rules: small, obviously correct, no new API, applies here.
Benefit is correct ADS sizes on QUERY_INFO; risk is an extra xattr size
probe per stream. Incomplete without the later handle
`ksmbd_stream_eof()` fix, but this site is independently buggy and
independently fixable.

------------------------------------------------
Verification
------------------------------------------------

- [Phase 1] Tags: no Fixes/Cc:stable/Reported-by; SOB Gael Blivet +
  Namjae Jeon; Assisted-by Claude.
- [Phase 2] Diff: 16+/2- in `get_file_stream_info()`; replace
  `stream_name_len` with `ksmbd_vfs_casexattr_len()` value length.
- [Phase 3] blame 5174-5175 → `e2f34481b24db` (2021); ancestor of HEAD.
- [Phase 3] Companion `a9417bb1889e` (`ksmbd_stream_eof`) **not** in
  HEAD; this patch does not call it.
- [Phase 3] `git apply --check` of `689f1eb3719d`: both hunks apply
  (offset −842).
- [Phase 4] `b4 dig -c 689f1eb3719d`: lore msgid
  `20260709165141.2111-3-g.blivet@me.com`; v2 applied by Namjae
  (“Applied it to #ksmbd-for-next-next”).
- [Phase 4] `b4 dig -w`: Namjae + linux-cifs; no NAK.
- [Phase 4] UNVERIFIED: stable@ discussion (HTTP 403).
- [Phase 5] Only caller `smb2_get_info_file` /
  `FILE_STREAM_INFORMATION`; helper exists in `vfs.c:1775`.
- [Phase 6] Tree is 6.12.111 (`pending-6.12`); buggy assignment present
  at 5174-5175.
- [Phase 6] `file_mnt_idmap` and `ksmbd_vfs_casexattr_len` present.
- [Phase 8] Failure mode: wrong ADS size → possible truncated stream
  copy; severity HIGH for ADS integrity, not kernel crash.
- UNVERIFIED: whether GitHub #522 (streams not listed) is the same bug;
  not used to drive YES.

**YES**

 fs/smb/server/smb2pdu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9c5275d3640cc..277c03fe2a4e4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5166,6 +5166,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	struct kstat stat;
 	const struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
+	ssize_t slen;
+	loff_t ssize;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
 	int ret;
@@ -5227,8 +5229,20 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = cpu_to_le64(stream_name_len);
-		file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
+		/*
+		 * stream_name_len is the byte length of the xattr's *name*,
+		 * not its value -- same class of bug ksmbd_stream_eof()
+		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
+		 * a stream handle; this enumeration path needs the same
+		 * real xattr value length, not the name length reused as a
+		 * size.
+		 */
+		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
+						path->dentry, stream_name,
+						strlen(stream_name) + 1);
+		ssize = slen < 0 ? 0 : (loff_t)slen;
+		file_info->StreamSize = cpu_to_le64(ssize);
+		file_info->StreamAllocationSize = cpu_to_le64(ssize);
 
 		nbytes += next;
 		buf_free_len -= next;
-- 
2.53.0

