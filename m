Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4154A5A8767;
	Mon, 19 Oct 2026 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418397; cv=none; b=qC1a1C776UDMAd8N3en4uTdxqJd66RLLi0hwZOdsjgewhBrsCyL9cgwKW01+pP11rV2YuSQsUVR0JmTN4zRAvDy0MeP2/Jp/nUi8D8am71QyDg4/s4IqvcGsIYaTNMHNRbu9meEOqG+/3u5y8J581kEF5ZHvMyy6F2wPOWEjTck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418397; c=relaxed/simple;
	bh=lXAEDhNCr2vsjmfDWLRZ8UrqZWYjFwAPdewqndj9g24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqYV7QGR0vbN2DeD7Q2IO3h6cEpD8m9pat/0erUIHBYDnnKkpr5EaFDEmuUy8u2/5sU2c4DUbNiAoiFfVc2Rx39Onw6XOaXJNN2ZikbUIT+EsaO56gK+Il/ypFLoIr80iN6k3XxxZDKu8QK3qOOITQFDuvDvPywIQuUfvU3kvSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ll3rkweG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ll3rkweG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAD01F000C4;
	Mon, 19 Oct 2026 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418395;
	bh=Hohi6tC2hi2Y/Me0I+YLX5SX56omrwG9apCpo34mcI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll3rkweGxJmw2LoiZpLRrr0lAIEEr3EPMPu+DYV5xSTbGUQulczmon9fxqpr3SdnS
	 BffvjaoYSMQ0qvv9ojAWUSbdcc8O5KukoHN/36HUTjYNTqJ7kPHsarCzVEM9bwRHRu
	 2r0s54zLtI4Xfi6d9d4y8ss5UXcWOe47aAlqsAQ9PKiTNjYgqKVS2ZMTVohY7xUYkR
	 S9MHigOCSK50eUGx5ixkkr5MhqTPcMAAB0p2+t0kZgC+vjKErjSJpNzZIBmgl3uEhU
	 ObA/Sz8DlLkQYQQ+dOwzc9I6Ki9yr2UcIzWepXZApJHu01vQHllmOxIZuHX5vKV1Fi
	 npna5EbigB4wA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: allow I/O on directory named streams
Date: Mon, 19 Oct 2026 09:48:30 -0400
Message-ID: <20261019135441.1420968-219-sashal@kernel.org>
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

[ Upstream commit 8184c425a19d44f138d42b44cc363917c08e5f1c ]

Named streams are stored as extended attributes on the base inode. The
VFS read and write helpers reject directory inodes before or together
with checking whether the handle represents a stream.

Permit read and write operations when a directory-backed handle is a
named stream. Continue rejecting direct I/O on ordinary directory
handles.

This fixes creation of the directory stream in smb2.getinfo.complex.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ksmbd] [allow] permit read/write on named streams whose base
inode is a directory`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (ksmbd
  maintainer; author)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@`
- Absence of `Fixes:`/`Cc: stable` is expected for this review pipeline
  and is not a negative signal
- Ignore any later `[Upstream commit ...]` / `Signed-off-by: Sasha
  Levin` markers; they are candidate-prep, not selection

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Named streams are stored as xattrs on the base inode.
  `ksmbd_vfs_read()` and `ksmbd_vfs_write()` reject directory inodes
  before (read) or together with (write) the stream-handle check, so a
  directory-backed stream never reaches `ksmbd_vfs_stream_read()` /
  `ksmbd_vfs_stream_write()`.
- **Symptom:** SMB read/write of a named stream on a directory fails
  (`-EISDIR` / `-EACCES`). Samba smbtorture `smb2.getinfo.complex`
  cannot create `DNAME:streamtwo`.
- **Version info in the message:** none.
- **Root cause:** directory inode check is applied to the base inode,
  not to whether the handle is a stream.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. This is an explicit protocol-correctness fix for
existing ADS I/O. “Allow” here means “stop rejecting a path that already
exists,” not a new API.

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/smb/server/vfs.c` — 3 insertions, 2 deletions
- Functions: `ksmbd_vfs_read()`, `ksmbd_vfs_write()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Read, before:** `S_ISDIR(inode)` → immediate `-EISDIR`, so
  `ksmbd_stream_fd()` is never reached.
- **Read, after:** reject only `S_ISDIR && !ksmbd_stream_fd(fp)`. Stream
  handles fall through to `ksmbd_vfs_stream_read()` (xattr).
- **Write, before:** inside the SMB access check, `S_ISDIR` forces
  `-EACCES` even for stream fds.
- **Write, after:** same access check, but directory rejection is
  skipped for `ksmbd_stream_fd(fp)`, then the existing stream-write
  branch runs.
- Ordinary directory I/O is still rejected. Stream I/O still never calls
  `kernel_read()` / `kernel_write()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / protocol correctness.** Directory ADS is valid SMB.
The VFS helpers treated the base directory inode as “no I/O allowed” and
never used the xattr stream path.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `ksmbd_stream_fd()` is an
existing inline (`fp->stream.name != NULL`). After the exemption, both
functions still take the stream branch and `goto out` / return before
VFS file I/O, so the `__kernel_write_iter` WARNING that motivated the
earlier directory-write ban is not reintroduced. Regression risk is very
low.

## Phase 3: Git history investigation

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Read `S_ISDIR` check: `f44158485826c0` (“cifsd: add file operations”,
  2021). Directory stream **reads** have been broken since ksmbd’s
  original file ops.
- Write `S_ISDIR` check: `2a879da5c34a1` (“ksmbd: fix the warning from
  __kernel_write_iter”), upstream `b37f2f332b40`, present here as
  `v6.12.25~99`. That stable backport banned all directory writes to
  avoid `WARNING: CPU: ... at fs/read_write.c:599 __kernel_write_iter`.
  It sits **before** the stream-fd check, so it also blocked directory
  **stream** writes that previously went through xattrs.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The write-side bug is a follow-on to
`2a879da5c34a1` / `b37f2f332b40`, which **is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Stream I/O already exists here (`ksmbd_vfs_stream_read/write`,
`d62ba16563a86` OOB check, `5c54a557bde18` empty-stream write fix,
`a8f5d39971bba` opener creds for ADS). Neighboring 7.3 stream patches
(copychunk, AAPL FinderInfo, stream delete, `::$DATA` validation) are
**not** prerequisites for this 3-line change. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namjae Jeon is the ksmbd maintainer. This landed in the ksmbd
7.3-rc1 pull among other ADS/protocol fixes. Same author previously
landed `2fb9b5dc80cab` (“allow write with FILE_APPEND_DATA”) on stable
for a similar client-visible I/O rejection.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses only `ksmbd_stream_fd()`, already in
`fs/smb/server/vfs_cache.h` and included from `vfs.c`. Parent
`4ea46ea602fc7` (“protect private extended attributes”) is **not** in
this tree and is not required. `git show 8184c425a19d4 | git apply
--check` succeeds on this tree.

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c 8184c425a19d4` failed (lore.kernel.org returned an
error / Anubis bot wall). Same for lore search URLs. Fallback: the
commit is listed in Namjae’s **[GIT PULL] ksmbd server update for
7.3-rc1** (2026-08-23) as `ksmbd: allow I/O on directory named streams`,
under “Correct alternate-data-stream and named-stream handling,” not
under “New features.”

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: UNVERIFIED at patch-thread level (lore unreachable). The pull is
from the subsystem maintainer to Linus.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Samba `smb2.getinfo.complex` (`source4/torture/smb2/getinfo.c`)
does:
- `torture_setup_complex_dir(..., DNAME)`
- `torture_setup_complex_file(..., DNAME ":streamtwo")`
Historically noted as “streams on directories does not work.” That is a
real client/test failure, not a theoretical one.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Part of the large 7.3 ksmbd dump, but this hunk is self-
contained. Later stream patches improve enumeration, delete, copychunk,
AAPL; they are not needed for this I/O gate.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED (lore blocked). No in-tree discussion of rejecting
this fix.

## Phase 5: Code semantic analysis

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `ksmbd_vfs_read()`, `ksmbd_vfs_write()`, helper
`ksmbd_stream_fd()`.

**Step 5.2: TRACE CALLERS**
Record:
- `ksmbd_vfs_read()` ← `smb2_read()` (`smb2pdu.c`)
- `ksmbd_vfs_write()` ← `smb2_write()` and `smb2_write_rdma_channel()`
Reachable from normal SMB2 READ/WRITE on a connected share.
`connection_type` is set from the negotiated dialect, so the write-side
directory check applies to SMB2/SMB3.

**Step 5.3: TRACE CALLEES**
Record: Stream path uses `ksmbd_vfs_getcasexattr` / `ksmbd_vfs_setxattr`
on the dentry. Directories support xattrs; no `kernel_write()` on the
directory inode.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace SMB client → SMB2 CREATE of `dir:streamtwo` (open
already allowed when `s_type` is not explicit `$DATA`) → SMB2 WRITE →
`ksmbd_vfs_write()` currently returns `-EACCES`. Triggerable by any
client with streams enabled (`KSMBD_SHARE_FLAG_STREAMS`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other `S_ISDIR` checks in ksmbd (oplock, setattr, query info)
are separate. No duplicate I/O gate that would still block this path
after the patch.

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local tree is **6.12.111** (`pending-6.12`,
`p-6.12-3-gc504cf0baa3d8`). Current code:

```377:378:fs/smb/server/vfs.c
        if (S_ISDIR(inode->i_mode))
                return -EISDIR;
```

```503:505:fs/smb/server/vfs.c
        if (work->conn->connection_type) {
                if (!(fp->daccess & (FILE_WRITE_DATA_LE |
FILE_APPEND_DATA_LE)) ||
                    S_ISDIR(file_inode(fp->filp)->i_mode)) {
```

`8184c425a19d4` is **not** an ancestor of HEAD. Write-side regression
introduced in **v6.12.25**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply (`git apply --check` exit 0). Surrounding functions
match the upstream hunk context. `ksmbd_stream_fd()` already present.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent directory-stream I/O exemption. Stream write
OOB/empty-xattr fixes are present but do not address `S_ISDIR`.

## Phase 7: Subsystem and maintainer context

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `fs/smb/server` (ksmbd). **IMPORTANT** — in-kernel SMB3 server
used by NAS/embedded/distro images. Not core mm/VFS, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; this tree already carries many ksmbd
protocol and memory-safety backports. Mature ADS support has existed
since the cifsd era (2021).

## Phase 8: Impact and risk assessment

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: ksmbd users with `KSMBD_SHARE_FLAG_STREAMS` who have
Windows/Samba/macOS clients using named streams on directories (Explorer
ADS, smbtorture, some backup/metadata workflows).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: SMB2 WRITE/READ on a handle opened as `dir:stream`. Common in
protocol tests; less common than file ADS, but a supported SMB feature.
Unprivileged share users can trigger it if they can create streams.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Client I/O fails (`STATUS` derived from `-EISDIR`/`-EACCES`);
not a panic, UAF, or silent corruption. **MEDIUM**
functional/interoperability, **HIGH** as a **stable-to-stable write
regression** since v6.12.25.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores directory ADS I/O; undoes over-broad fallout
  from the `__kernel_write_iter` stable fix; unblocks
  `smb2.getinfo.complex`.
- **Risk:** Very low (3 lines, existing helper, stream path still
  bypasses `kernel_write`).
- **Ratio:** favorable.

## Phase 9: Final synthesis

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real SMB protocol bug: named streams live in xattrs; directory base
  inodes must still allow stream I/O.
- Write path is a **regression** from `2a879da5c34a1` (v6.12.25) already
  on this 6.12.y tree.
- Existing ADS stack is in this tree; this only opens the gate to it.
- 3-line, obviously correct, applies cleanly.
- Maintainer-authored; validated via smbtorture `smb2.getinfo.complex`.
- Does not restore the directory `kernel_write` WARNING.

AGAINST:
- Not a crash/security/corruption issue.
- Directory ADS is a narrower client feature than file ADS.
- Read-side rejection has existed since 2021 (enabling reads is
  correctness, not a 6.12.y regression).

UNRESOLVED:
- Original lore review thread (b4/lore blocked).
- Whether reviewers asked for `Cc: stable`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic is local and was
   exercised by smbtorture.
2. Fixes a real bug that affects users? **PASS** — SMB clients cannot
   I/O directory named streams.
3. Important issue? **PASS** — interoperability failure plus a write-
   side regression from a prior stable commit. Not a panic, but user-
   visible and already shipped in 6.12.y.
4. Small and contained? **PASS** — 3 lines, one file.
5. No new features or APIs? **PASS** — no new syscall/sysfs; streams
   already advertised.
6. Can apply to the local tree? **PASS** — clean apply; helpers exist.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None of device-ID / quirk / DT / build / docs. Qualifies on
ordinary bug-fix rules.

**Step 9.4: MAKE YOUR DECISION**
This tree already contains ksmbd named-stream I/O and the v6.12.25
directory-write ban. The ban is correct for ordinary directory handles
but incorrectly covers stream handles, which never use `kernel_write()`.
Backporting this exemption restores intended ADS behavior with
negligible risk.

---

What this solves for 6.12.y: Windows/Samba clients that write a named
stream on a directory (as `smb2.getinfo.complex` does with
`DNAME:streamtwo`) currently get `-EACCES` on write and `-EISDIR` on
read. After v6.12.25 that write failure is a regression from a WARNING
fix. The patch is a 3-line predicate change; stream I/O still goes
through xattrs, so the WARNING does not come back.

Verification:
- [Phase 1] Parsed tags: only maintainer SOB; no Fixes/Reported-by/Cc:
  stable
- [Phase 2] Diff: 3 lines in `ksmbd_vfs_read`/`ksmbd_vfs_write`; exempts
  `ksmbd_stream_fd()` from `S_ISDIR`
- [Phase 3] `git blame`: read check from `f44158485826c0` (2021); write
  check from `2a879da5c34a1` (`v6.12.25~99`)
- [Phase 3] `git merge-base --is-ancestor 2a879da5c34a1 HEAD` → yes;
  `8184c425a19d4` → no
- [Phase 3] `git apply --check` of `8184c425a19d4` → clean
- [Phase 4] `b4 dig -c 8184c425a19d4` failed (lore error)
- [Phase 4] 7.3-rc1 GIT PULL lists this under ADS handling, not new
  features
- [Phase 4] Samba `getinfo.c` creates `DNAME ":streamtwo"` in
  `smb2.getinfo.complex`
- [Phase 5] Callers: `smb2_read` / `smb2_write` / RDMA write; stream
  callees are xattr helpers
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111; buggy `S_ISDIR` present
- [Phase 8] Failure mode: failed SMB stream I/O, plus write regression
  since v6.12.25; not a panic
- UNVERIFIED: lore review comments / stable ML discussion (lore blocked)

**YES**

 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 3ac5f3f48121d..47c289ad9c3dc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -372,7 +372,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	ssize_t nbytes = 0;
 	struct inode *inode = file_inode(filp);
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp))
 		return -EISDIR;
 
 	if (unlikely(count == 0))
@@ -500,7 +500,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 	if (work->conn->connection_type) {
 		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) ||
-		    S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		    (S_ISDIR(file_inode(fp->filp)->i_mode) &&
+		     !ksmbd_stream_fd(fp))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;
-- 
2.53.0

