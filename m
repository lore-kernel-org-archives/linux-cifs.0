Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0743502761;
	Mon, 19 Oct 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418100; cv=none; b=L8SQJ41mZo/67AvwStTAeZ1yEK2Fte3JWn8cqM7zlNPHQljzFOYIAX/U6fRnFnQG6ELfwbgE5eHA0TQ/z9CQmnV4IEGbWSZOrSiZeoLb25kXJ1lFJHvdxA3a0op4zJrYYKNLWFj9Kd9GQSG3o+VuCNTRglxIwpfSLZ/wWFaEPhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418100; c=relaxed/simple;
	bh=U1hSlX6is/+DZkSOHfZzx7CPO93HGULopVL/4fORQPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/AsTtESpFIwH9qMuxpUSL2x7B7dhVmz5Uz4XJr0GlQrpiUuY/3o1HayzqMh9q/bbr7Jjr/1c1mthXI6XbFxGLf9Nf6cgxdCUZIQvBU+1mSDayDJQ9Z9+h3PYL5h+jqhtcqb3ZpF6fc7uB/dzy9OAyqitQfZIQnj3I5R3Ho5RHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZ/dEdz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZ/dEdz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F1C1F000C4;
	Mon, 19 Oct 2026 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418096;
	bh=zKuoh1nnUGwxg6ybdmMK7TTsXQpl1pI2r6jynQVGfEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ/dEdz3mRGACoL52g5D+5XLyEum6XEfFc/HJ9GDFsHHK7W9f5YnOpgBMcRqvjwkM
	 wyXa9oBWiEhylBUXRQhoCrQl4yalPmbQNVAKNTQAhbvazQmXcdoHvxOjqBEjk0jK3l
	 +hUsjtFRIQpirCrd8v2MAzdT61sZ30DgX1LDiy+1MKFjos6OLlwEolJwXGKBOCjuDa
	 Wb8zwxSoOt9vijcO4FimbhDXNoUgvIE3m/FEmQk4uYB23R5ZlxzfmMU6u0hOvBJJdq
	 VrKb36XwFvv7FQsHjCf7rp8zGBXSZF5OAynPU6OsouwKxXDkmWAlr/JJ/SBNJMKGik
	 sZ8nLjvIkjq8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Mon, 19 Oct 2026 09:45:01 -0400
Message-ID: <20261019135441.1420968-10-sashal@kernel.org>
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

[ Upstream commit bfdf81c62f4f52a3626ea62db0744def6778e83f ]

smb2_open() calls vfs_fallocate(fp->filp, ...) unconditionally when a
client's CREATE request includes an AllocationSize create context.
For a stream handle, fp->filp refers to the base file's data fork
(streams are xattr-backed on the same underlying file, not separate
files), so this pre-allocates storage on the base file's actual data
instead of doing anything meaningful for the stream -- fallocate has
no applicability to an xattr-backed stream at all.

Skip the fallocate call for stream handles.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111**. The buggy `vfs_fallocate()` on stream
CREATEs is present here, and the skip is a small, self-contained
correctness fix that applies to this checkout.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: **[ksmbd] [skip] skip fallocate for
  SMB2_CREATE_ALLOCATION_SIZE on a stream handle**
- Subsystem: ksmbd (in-kernel SMB3 server). Verb “skip” here means “do
  not run a VFS operation that does not apply.”

**Step 1.2: Tags**
- Record:
  - `Assisted-by: Claude:claude-sonnet-5`
  - `Signed-off-by: Gael Blivet <gael.blivet@gmail.com>`
  - `Acked-by: Namjae Jeon <linkinjeon@kernel.org>` (on `e360be3d03f77`;
    the candidate copy uses `Signed-off-by: Namjae Jeon`)
  - `Signed-off-by: Steve French` (on the smb.git copy)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, or `Link:`
  - Absence of `Fixes:`/`Cc: stable` is expected for this review
    pipeline

**Step 1.3: Body**
- Record:
  - **Bug:** `smb2_open()` always calls `vfs_fallocate(fp->filp,
    FALLOC_FL_KEEP_SIZE, …)` when CREATE has an AllocationSize context.
  - **Root cause:** For a named-stream handle, `fp->filp` is the **base
    file**. Streams are xattr-backed, not separate files.
  - **Symptom:** Preallocation (and a level-II oplock break) hits the
    base file’s data fork instead of the stream.
  - **Failure mode:** Wrong-file disk preallocation; unexpected oplock
    break on the base file.
  - No stack trace, no version list, no user report.

**Step 1.4: Hidden bug fix?**
- Record: **Yes, this is an explicit bug fix**, not cleanup. Cover
  letter for series 8/8: opening a stream with AllocationSize
  “fallocates storage on the underlying base file’s actual data.”

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - File: `fs/smb/server/smb2pdu.c` only
  - Scope: **+16 / −7** (net +9), one function: `smb2_open()`
  - Classification: **single-file surgical fix**

**Step 2.2: Code-flow change**
- Record:
  - **Before:** If CREATE has `SMB2_CREATE_ALLOCATION_SIZE`, always
    `smb_break_all_levII_oplock(work, fp, 1)` then
    `vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0, alloc_size)`.
    Failures are only debug-logged.
  - **After:** Same path, but only when `!ksmbd_stream_fd(fp)`. Stream
    handles skip both the oplock break and fallocate.
  - Affected path: SMB2 CREATE with AllocationSize on a stream, after
    the file is already opened.

**Step 2.3: Bug mechanism**
- Record:
  - **Category:** logic / correctness (wrong object for a VFS call),
    with resource side effects
  - **Mechanism:** Stream fds share the base `struct file`.
    `ksmbd_stream_fd()` is `fp->stream.name != NULL`. Stream I/O already
    goes through xattrs (`ksmbd_vfs_stream_read`/`_write`); fallocate
    has no stream equivalent.
  - `FALLOC_FL_KEEP_SIZE` does not change `i_size`, but it **does**
    allocate blocks on the base inode and can fill the filesystem.
    `vfs_fallocate()` also takes `file_start_write()` and may run for a
    long time on a large client-supplied size (bounded by `s_maxbytes`).

**Step 2.4: Fix quality**
- Record:
  - Obviously correct: skip a VFS op that cannot apply to an xattr
    stream.
  - Matches existing stream guards (read/write/copy-chunk).
  - Regression risk is **very low**: regular-file CREATE is unchanged;
    stream CREATE only stops a harmful no-op-for-the-stream.
  - Incomplete vs SET_INFO: `set_file_allocation_info()` in this tree
    still fallocates `fp->filp` with no stream check. That does not make
    this CREATE skip wrong.

## Phase 3: Git history

**Step 3.1: Blame**
- Record:
  - Unconditional fallocate in `smb2_open()` comes from `e8c061917133dd`
    (“ksmbd: opencode to avoid trivial wrappers”, 2021-06-22), replacing
    `ksmbd_vfs_alloc_size()`.
  - That commit **is an ancestor of this HEAD**.
  - `ksmbd_stream_fd()` is from `f44158485826c0` (2021-03-16) and is
    also an ancestor.
  - Bug has been in ksmbd for the lifetime of this 6.12 line.

**Step 3.2: Fixes: tag**
- Record: **N/A** (no `Fixes:`). Introducer is the original CREATE
  AllocationSize handling, present since cifsd/`e8c0619`.

**Step 3.3: Related file history**
- Record:
  - `a9f106c765c12` — “fix wrong allocation size update in smb2_open()”
    (response timing, not this bug).
  - `2a4179c99bc6b` — overflow in `set_file_allocation_info()` (already
    in this tree).
  - `3b41d8b05dc89` — “return requested create allocation size” is
    **not** in this tree (`merge-base --is-ancestor` failed). Candidate
    parent uses outer-scope `alloc_size`; 6.12 still has a local `loff_t
    alloc_size`. Functional hunk still matches.

**Step 3.4: Author**
- Record: Gael Blivet, stream/AAPL/Time Machine work; maintainer Namjae
  Jeon acked and applied this patch. Not a drive-by.

**Step 3.5: Dependencies**
- Record:
  - Cover: **“None of this depends on or touches the AAPL/Time Machine
    feature series.”**
  - Needs only `ksmbd_stream_fd()`, which exists here.
  - Series is **[PATCH 8/8]**; this hunk does not need patches 1–7.
  - `git apply --check` of `e360be3d03f77` on this tree: **Hunk #1
    succeeded at 3593 (offset -504 lines).**

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record:
  - `b4 dig -c e360be3d03f77` →
    https://patch.msgid.link/20260709000548.66445-9-g.blivet@me.com
  - Series: **[PATCH 0/8] ksmbd: follow-up fixes to previously-merged
    patches** (2026-07-09)
  - Only **v1** found (`b4 dig -a`).
  - Namjae Jeon: **“Applied them except 0002, 0005 patch”** — this is
    patch 8, so it was applied. No NAK on patch 8. No `Cc: stable` in
    review.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Gaël Blivet-Bailly, Namjae Jeon, `linux-cifs@vger.kernel.org`.
  Maintainer was on To/Cc and acked.

**Step 4.3: Bug report**
- Record: No syzbot/bugzilla. Found by **Sashiko (LLM review)** of
  stream-handling code. Related real-world class: namjaejeon/ksmbd#507
  (SetInfo/EOF on a stream truncated the **base** file because
  `fp->filp` is the base file). Same object-confusion pattern.

**Step 4.4: Series context**
- Record: Eight independent follow-ups. Patch 8 is standalone. Also
  listed in the 7.3-rc1 ksmbd pull under alternate-data-stream handling
  (`e360be3d03f77`).

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable returned **403**. **UNVERIFIED**
  whether stable@ already discussed this; that does not change the
  technical verdict.

## Phase 5: Semantic / call-graph

**Step 5.1: Functions**
- Record: `smb2_open()` only. Helper used: `ksmbd_stream_fd()`.

**Step 5.2: Callers**
- Record: `fs/smb/server/smb2ops.c` maps `SMB2_CREATE_HE` → `smb2_open`.
  Reachable from any authenticated SMB2 CREATE.

**Step 5.3: Callees**
- Record: `smb2_find_context_vals()`, `smb_break_all_levII_oplock()`,
  `vfs_fallocate()`. Stream CREATE still sets `fp->stream.name` via
  `smb2_set_stream_name_xattr()` **before** this block (around line
  3485).

**Step 5.4: Reachability**
- Record: **Yes, from the network.** Requires:
  1. `CONFIG_SMB_SERVER`
  2. Share with `KSMBD_SHARE_FLAG_STREAMS`
  3. CREATE of `name:stream` plus AllocationSize create context (`AlSi`)
- Windows ADS and macOS resource-fork/Finder streams are the usual
  clients. Unprivileged local syscall is not the path; an authenticated
  SMB client is.

**Step 5.5: Similar patterns**
- Record: `ksmbd_vfs_read`/`write` already branch on
  `ksmbd_stream_fd()`. `ksmbd_vfs_copy_file_ranges()` returns `-EBADF`
  for streams. This CREATE fallocate path was the missing guard.
  `set_file_allocation_info()` still unguarded in **this** tree.

## Phase 6: This tree (6.12.111)

**Step 6.1: Buggy code present?**
- Record: **Yes.** `fs/smb/server/smb2pdu.c` ~3596–3602:

```3592:3602:fs/smb/server/smb2pdu.c
                        alloc_size =
le64_to_cpu(az_req->AllocationSize);
                        ksmbd_debug(SMB,
                                    "request smb2 create allocate size :
%llu\n",
                                    alloc_size);
                        smb_break_all_levII_oplock(work, fp, 1);
                        err = vfs_fallocate(fp->filp,
FALLOC_FL_KEEP_SIZE, 0,
                                            alloc_size);
                        if (err < 0)
                                ksmbd_debug(SMB,
                                            "vfs_fallocate is failed :
%d\n",
                                            err);
```

- `ksmbd_stream_fd()` is in `fs/smb/server/vfs_cache.h`.
- Candidate SHAs `e360be3d03f77` / `bfdf81c62f4f` are **not** ancestors
  of HEAD.

**Step 6.2: Backport difficulty**
- Record: **Clean apply with offset** (`git apply --check` succeeded at
  line 3593). Local `loff_t alloc_size` vs later outer-scope
  `alloc_size` does not conflict with the wrapped lines.

**Step 6.3: Related fixes already here?**
- Record: No skip of CREATE fallocate for streams. Overflow check in
  SET_INFO allocation is a different bug.

## Phase 7: Subsystem context

**Step 7.1**
- Record: **ksmbd (`fs/smb/server`)**, **IMPORTANT** (in-kernel SMB3
  server for NAS/shares). Not mm/core, but network-facing and used in
  production.

**Step 7.2**
- Record: Actively backported on this branch (many ksmbd fixes in recent
  `git log -- fs/smb/server`).

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: ksmbd users with **streams enabled**, when a client CREATEs a
  named stream with AllocationSize. Typical Windows/macOS
  interoperability.

**Step 8.2: Trigger**
- Record: Authenticated SMB CREATE of `file:stream` + AllocationSize.
  Not every open; common enough for ADS-aware clients. Same client could
  already write the file; unique harm is **wrong object** (base file)
  and a large fallocate without intending to preallocate the data fork.

**Step 8.3: Failure mode**
- Record:
  - Preallocates blocks on the **base file** (`FALLOC_FL_KEEP_SIZE` → no
    size change, but real space use).
  - Breaks level-II oplocks on the base file (other clients can lose
    caching).
  - Large `AllocationSize` can run a long `fallocate` under
    `file_start_write()` (filesystem write exclusion).
  - **Severity: HIGH** for disk/oplock side effects on a NAS; not a
    panic/UAF. Not content corruption of existing data.

**Step 8.4: Risk–benefit**
- Record:
  - **Benefit:** Stops wrong-file preallocation and spurious oplock
    breaks; one `if` around existing code.
  - **Risk:** Very low. Stream CREATE AllocationSize currently does the
    wrong thing; skipping is the correct xattr-stream behavior.
  - **Ratio:** Favorable.

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For:**
- Real wrong-file VFS operation, present since 2021, present in 6.12.111
- User-visible: disk on the base file, oplock disruption
- Small, obviously correct, applies with offset
- `ksmbd_stream_fd()` already here; no AAPL/Time Machine dependency
- Maintainer applied it (patch 8 of 8)
- Same stream/`fp->filp` confusion class as documented user bugs

**Against:**
- No crash/UAF/CVE; found by automated review, not a reporter
- SET_INFO allocation path still unfixed here
- Needs streams share flag
- lore stable search unverified (HTTP 403)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — skip is correct; maintainer
   applied it.
2. Real bug affecting users? **PASS** — wrong-file fallocate on stream
   CREATE.
3. Important (crash/security/corruption/deadlock/etc.)? **PASS** —
   unexpected allocation and oplock break on the base file of a network
   file server; can consume substantial disk.
4. Small and contained? **PASS** — ~9 lines, one function.
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — `git apply --check` succeeded.

**Step 9.3: Exceptions**
- Record: Not a device-ID/quirk/DT/build/doc exception. Qualifies as a
  normal small bugfix.

**Step 9.4: Decision**
Backport to **this** 6.12.111 tree. The bug is here, the helper is here,
the patch applies, and the change only disables a harmful path.

---

### What this solves for 6.12 users
On ksmbd shares with named streams, an SMB2 CREATE of an alternate data
stream that includes AllocationSize currently calls `vfs_fallocate()` on
the **base file**. That can allocate disk and break oplocks on the wrong
object. Streams are xattr-backed; fallocate cannot apply to them.
Skipping it is the correct, minimal fix.

### Verification
- **[Phase 1]** Parsed tags on `e360be3d03f77` / `bfdf81c62f4f` (same
  patch-id `8e46981f5116…`); no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: wrap fallocate + oplock break in `if
  (!ksmbd_stream_fd(fp))` in `smb2_open()`
- **[Phase 3]** `git blame`: fallocate from `e8c061917133dd` (ancestor);
  `ksmbd_stream_fd` from `f44158485826c0` (ancestor)
- **[Phase 3]** `git merge-base --is-ancestor e360be3d03f77 HEAD` → not
  in this tree
- **[Phase 3]** `git merge-base --is-ancestor 3b41d8b05dc89 HEAD` →
  later alloc_size-field commit not here
- **[Phase 4]** `b4 dig -c e360be3d03f77` → lore msgid
  `20260709000548.66445-9-g.blivet@me.com`; series 8/8
- **[Phase 4]** `b4 dig -a`: v1 only; `b4 dig -w`: linux-cifs + Namjae
  Jeon
- **[Phase 4]** mbox: Namjae “Applied them except 0002, 0005”; patch 8
  applied; no NAK
- **[Phase 4]** Cover: independent of Time Machine/AAPL
- **[Phase 5]** `SMB2_CREATE_HE` → `smb2_open`; streams gated by
  `KSMBD_SHARE_FLAG_STREAMS`
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → **6.12.111**
- **[Phase 6]** Buggy lines at `smb2pdu.c:3596–3602`; `git apply
  --check` succeeded at 3593
- **[Phase 8]** Failure mode: wrong-file preallocation + oplock break;
  severity HIGH for ksmbd/NAS, not a panic
- **UNVERIFIED:** stable@ lore search (HTTP 403); whether Windows always
  sends AllocationSize on ADS CREATE (bug is still real when it does)

**YES**

 fs/smb/server/smb2pdu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f383d1e5e5cb7..9c5275d3640cc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3633,13 +3633,22 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
 				    alloc_size);
-			smb_break_all_levII_oplock(work, fp, 1);
-			err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
-					    alloc_size);
-			if (err < 0)
-				ksmbd_debug(SMB,
-					    "vfs_fallocate is failed : %d\n",
-					    err);
+			/*
+			 * fp->filp is the base file's data fork for a stream
+			 * handle (streams are xattr-backed on the same
+			 * underlying file) -- fallocate has no meaning for a
+			 * stream and would otherwise pre-allocate storage on
+			 * the base file's data instead.
+			 */
+			if (!ksmbd_stream_fd(fp)) {
+				smb_break_all_levII_oplock(work, fp, 1);
+				err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
+						    alloc_size);
+				if (err < 0)
+					ksmbd_debug(SMB,
+						    "vfs_fallocate is failed : %d\n",
+						    err);
+			}
 		}
 
 		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
-- 
2.53.0

