Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ABD6050B6;
	Mon, 19 Oct 2026 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418596; cv=none; b=dSRKDUjx/2r+vWBNL/H/vwLzUSF10pr3/dNDhBz07JCXlmDSGnN74Wmhpgz7lTiDFwQkQPJh2mmZ1Z29lxUlWk+A0lS8czJ2xrc5oiQiVI5hUJDhjyayoJ7HbWrMjXZshuxCm6JtTSpg/SZCEqgFy/rV4q6ZEVCl1EzCIpGhoWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418596; c=relaxed/simple;
	bh=bAkn31bfhihMnu+4s73ziXtAiWB3g5T7iCPLK092/Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ba9UECa6bLJIJWFeOgFPq9nXM7I6JviMoPn2IqXGEO5wTgV6Vh9txJ1YOkqogQt7czhtaEJGP3Fk5MGMYsdFj0ead2T/lC+21cOMjd60qsUCuIGFxajxRlaJfNlTqiTlKMnkysrYukcG3XyQLCR6S8+G5wSVFSjLTcWhYVqgfk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ix/FWIZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ix/FWIZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43031F000C8;
	Mon, 19 Oct 2026 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418593;
	bh=S9xlGI5jGkR9UswSLAQN8kEyFXa7BHo3/L0IuGZTnog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ix/FWIZ11W7hG4fxIn8FL4xbgjnhh+Ar14sDAUevEVrqjjiX0dpAuyKCM1z75iGg5
	 kcZykv4JqQHCRqoj53LbF5nL0cA4q4/knMCPrQljMsNnT4CacjOwVyZ/Zc5J26w7f2
	 pfEleYv+nEpN1fol2trMIwm5HeXh4F0RmY+WreWqZ6Ez/f7telDkrNEnvXATzhCCvR
	 JIt3uGxopCOqFlFsdwWipML8gYpCUfNjLGn3Ts0Mu4quXUdoCejd/y4StBDi9y+t8x
	 PhOZ74eYj7Fx/Tgpk12r7CFN308k4yNQB+qt7DcDiDidJtJcWm8sDiCUAY6OdgWE7g
	 1j3PymLdvt98A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: preserve access denied status for copychunk
Date: Mon, 19 Oct 2026 09:50:49 -0400
Message-ID: <20261019135441.1420968-358-sashal@kernel.org>
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

[ Upstream commit f7c0366e0a80bf8cd5eacc5479927abb50958b5e ]

The copychunk error mapping handles -EACCES in an independent if
statement. The following error chain therefore reaches its final else
clause and overwrites STATUS_ACCESS_DENIED with
STATUS_UNEXPECTED_IO_ERROR.

Join the -EACCES check to the remaining error chain so an access failure
is returned as STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the full picture: the one-line `if`/`else if` bug is in this
6.12.111 tree, it applies cleanly, and the original submitter explicitly
asked for stable. Writing up the nine-phase analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ksmbd]** **[preserve]** preserve access denied status for
copychunk.

Subsystem is the in-kernel SMB3 server. “Preserve” here means “stop
overwriting a correctly computed NTSTATUS,” which is a correctness fix,
not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Mainline commit `f7c0366e0a80bf8cd5eacc5479927abb50958b5e` (author
Namjae Jeon, AuthorDate 2026-07-07, CommitDate 2026-08-17):

- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd
  maintainer; he both authored and committed it)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable on the committed version

The absence of Fixes:/Cc: stable on the committed object is expected for
this review pipeline and is not a negative signal.

An independent mailing-list submission of the **same one-line change**
did carry those tags (see Phase 4):
- Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
- Cc: stable@vger.kernel.org
- Reviewed-by: ChenXiaoSong

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** In `fsctl_copychunk()`, `-EACCES` is handled by a standalone
  `if`. The next `if (ret == -EAGAIN) / else if ... / else` chain then
  runs anyway.
- **Symptom:** `STATUS_ACCESS_DENIED` is written, then immediately
  overwritten by `STATUS_UNEXPECTED_IO_ERROR`.
- **Failure mode:** SMB clients doing server-side copy (FSCTL_COPYCHUNK
  / FSCTL_COPYCHUNK_WRITE) see a generic I/O error instead of access
  denied. The copy is still rejected; the protocol status is wrong.
- **Version info:** none in the committed message. The UnionTech
  submission pins it to the original cifsd SMB3 engine commit.
- **Root cause:** missing `else` so `-EACCES` falls into the final
  `else`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. The message describes a real control-flow bug.
“Preserve” is the action verb for keeping the correct status.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `fs/smb/server/smb2pdu.c` — 1 line changed (`if` → `else if`)
- Function: `fsctl_copychunk()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

This tree currently has:

```7988:8005:fs/smb/server/smb2pdu.c
        if (ret < 0) {
                if (ret == -EACCES)
                        rsp->hdr.Status = STATUS_ACCESS_DENIED;
                if (ret == -EAGAIN)
                        rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
                else if (ret == -EBADF)
                        rsp->hdr.Status = STATUS_INVALID_HANDLE;
                else if (ret == -EFBIG || ret == -ENOSPC)
                        rsp->hdr.Status = STATUS_DISK_FULL;
                else if (ret == -EINVAL)
                        rsp->hdr.Status = STATUS_INVALID_PARAMETER;
                else if (ret == -EISDIR)
                        rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
                else if (ret == -E2BIG)
                        rsp->hdr.Status = STATUS_INVALID_VIEW_SIZE;
                else
                        rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
        }
```

Record: Before, `-EACCES` sets `STATUS_ACCESS_DENIED`, then misses
`-EAGAIN` and every later `else if`, and the final `else` overwrites it
with `STATUS_UNEXPECTED_IO_ERROR`. After, `-EACCES` is exclusive and the
status sticks. Other errno mappings are unchanged. This is the
`ksmbd_vfs_copy_file_ranges()` error path, not probe/init.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / correctness.** Missing `else` on an errno-to-NTSTATUS
ladder. `-EACCES` is a real return from `ksmbd_vfs_copy_file_ranges()`:

```1840:1847:fs/smb/server/vfs.c
        if (!(src_fp->daccess & (FILE_READ_DATA_LE | FILE_EXECUTE_LE)))
{
                pr_err("no right to read(%pD)\n", src_fp->filp);
                return -EACCES;
        }
        if (!(dst_fp->daccess & (FILE_WRITE_DATA_LE |
FILE_APPEND_DATA_LE))) {
                pr_err("no right to write(%pD)\n", dst_fp->filp);
                return -EACCES;
        }
```

`vfs_copy_file_range()` can also return `-EACCES`. The access check
still denies the copy; only the SMB status is wrong.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct. One token. No API, locking, or allocation
change. Regression risk is negligible: `-EACCES` already matched nothing
else in the chain.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: `git blame -L 7988,8005 fs/smb/server/smb2pdu.c` attributes the
whole ladder to `e2f34481b24db2` (“cifsd: add server-side procedures for
SMB3”, Namjae Jeon, 2021-03-16). That is the original ksmbd/cifsd SMB3
engine, present since the server was merged (v5.15-era). The bug is old,
not recent churn.

**Step 3.2: FOLLOW THE FIXES: TAG**

Committed object has no Fixes: tag. The equivalent linux-cifs patch
tagged `e2f34481b24d`. `git merge-base --is-ancestor e2f34481b24db2
HEAD` succeeded — the introducing commit is in this tree. No later
rewrite of this ladder was found in this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `smb2pdu.c` work in this tree is unrelated (partial
QUERY_INFO responses, compound errors, lease/durable-handle fixes).
Neighboring mainline copychunk work from the same day (`fd309860ef245`
overlapping-copy data preservation, `8482150a0743c` ADS copychunk) is
**not** in HEAD and is **not** required: this change only joins two
`if`s in the error map. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Namjae Jeon is the ksmbd maintainer (`git log --author="Namjae
Jeon" -- fs/smb/server/`). He authored and committed this. Same-day
mainline commits touch other copychunk behavior but do not alter this
mapping.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. `git show f7c0366e0a80b | git apply --check` succeeded on
this tree (hunk offset -764 lines). No new helpers or structs.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c f7c0366e0a80b` failed (lore returned an error to b4).
- Direct lore search found the same fix submitted independently:

https://lore.kernel.org/linux-
cifs/2DC5EE1DC892643F+20260731072020.1307022-1-raoxu@uniontech.com/

Xu Rao (UnionTech), 2026-07-31, subject “ksmbd: preserve
STATUS_ACCESS_DENIED for copychunk errors”. Same `if` → `else if`. Cites
**MS-SMB2 3.3.5.15.6**: FSCTL_SRV_COPYCHUNK / COPYCHUNK_WRITE must fail
with `STATUS_ACCESS_DENIED` when the source open lacks `FILE_READ_DATA`
or the destination lacks `FILE_WRITE_DATA`/`FILE_APPEND_DATA`.
**Fixes:** e2f34481b24d. **Cc: stable@vger.kernel.org.** No NAK.

Namjae’s committed patch (author date 2026-07-07) is the same change,
queued earlier in ksmbd-for-next and merged via `ksmbd-for-7.3-rc1`
(`git describe --contains` → `v7.3-rc1~77^2~124`).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: UnionTech patch To/Cc: Namjae Jeon, Steve French, Sergey
Senozhatsky, Tom Talpey, linux-cifs, LKML, **stable@vger.kernel.org**.
ChenXiaoSong replied with Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Two independent authors (maintainer +
UnionTech) found the same missing-`else`. Spec citation is MS-SMB2
3.3.5.15.6.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Not a numbered series. Same-day copychunk patches are
independent and not in this tree; this line does not need them.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search for this subject did not turn up a
prior rejection. The UnionTech mail itself was Cced to stable.
ChenXiaoSong noted the bug was already fixed in ksmbd-for-next-next (htt
ps://github.com/smfrench/smb3-
kernel/commit/35e11e324a2f97d2974ef08d308063c9c5f9e9d8) — that is the
maintainer tree copy of this same fix, not a reason to skip stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `fsctl_copychunk()` only.

**Step 5.2: TRACE CALLERS**

Record: Only caller is `smb2_ioctl()` for `FSCTL_COPYCHUNK` /
`FSCTL_COPYCHUNK_WRITE` (`fs/smb/server/smb2pdu.c` around 8466–8495).
`smb2_ioctl` is registered as `SMB2_IOCTL_HE` in
`fs/smb/server/smb2ops.c`. Reachable from any authenticated SMB2/SMB3
client issuing a copychunk FSCTL (Windows Explorer / CopyFile server-
side copy, robocopy, smbclient, etc.).

Important: `fsctl_copychunk()`’s return value is discarded. Status is
taken from `rsp->hdr.Status`, then `ksmbd_iov_pin_rsp()` sends the ioctl
response. The wrong status is what the client actually receives.

Tree-not-writable uses `ret = -EACCES; goto out;` in `smb2_ioctl()` and
maps correctly. The broken path is the **file-handle** access check
inside `ksmbd_vfs_copy_file_ranges()`.

**Step 5.3: TRACE CALLEES**

Record: `ksmbd_vfs_copy_file_ranges()` → access checks, lock checks,
`vfs_copy_file_range()`. `-EACCES` comes from the access checks (and
potentially VFS).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: SMB2 IOCTL (network) → `smb2_ioctl` → `fsctl_copychunk` →
`ksmbd_vfs_copy_file_ranges`. Triggerable by a logged-in SMB user with
opens that lack read-on-source or write-on-dest. Not a local
unprivileged syscall, but a normal file-server path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: The only other `if (ret == -EACCES)` in
`fs/smb/server/smb2pdu.c` is the outer `smb2_ioctl()` mapper, which
**already** uses `else if`. This copychunk ladder is the broken
instance.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
kernelversion` = **6.12.111**. Buggy ladder is at
`fs/smb/server/smb2pdu.c:7988-8005`. `git merge-base --is-ancestor
f7c0366e0a80b HEAD` failed — fix is **not** in this checkout. Introduced
by `e2f34481b24d` (2021), which **is** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** `git apply --check` of the mainline diff
succeeded (offset -764). Surrounding copychunk ioctl code matches aside
from line numbers. Mainline context uses `FSCTL_SRV_COPYCHUNK` in a
nearby (unchanged) check; this tree still uses `FSCTL_COPYCHUNK`. That
is outside the changed line and did not block apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep="preserve access denied" -- fs/smb/server` has
no hit. No alternate mapping fix in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `fs/smb/server` (ksmbd), `CONFIG_SMB_SERVER`. **IMPORTANT** for
NAS/embedded/distros that ship ksmbd; not core mm/VFS for every box.
Protocol status on copychunk is user-visible for those servers.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (many recent ksmbd commits on this branch).
This particular ladder has been unchanged since 2021.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Config-specific / server-specific: ksmbd users. Windows and
other SMB clients using server-side copy against ksmbd.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Authenticated client issues FSCTL_COPYCHUNK[_WRITE] with a
source handle lacking read/execute or a dest handle lacking write/append
(or VFS returns `-EACCES`). Common for copy-offload when opens don’t
carry the rights MS-SMB2 requires. Not a rare race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Wrong NTSTATUS (`STATUS_UNEXPECTED_IO_ERROR` instead of
`STATUS_ACCESS_DENIED`). Copy is still denied — not a bypass, crash, or
corruption. Clients/apps can surface “I/O device error”, retry, or
mishandle a permission failure. **Severity: MEDIUM**, but it is a
documented SMB protocol violation (MS-SMB2 3.3.5.15.6).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Correct access-denied reporting on a standard Windows
  copy-offload path; matches spec.
- **Risk:** Very low (one `else`, no behavioral change except the status
  for `-EACCES`).
- **Ratio:** Favorable. Independent submitter Cced stable for this exact
  change.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, verified missing-`else` bug in this 6.12.111 tree
- `-EACCES` is a live return from `ksmbd_vfs_copy_file_ranges()`
- Client-visible SMB status is wrong; MS-SMB2 requires ACCESS_DENIED
- 1-line, obviously correct, applies cleanly
- Present since original cifsd merge; introducing commit is in HEAD
- Maintainer-authored; independently rediscovered; Reviewed-by
  ChenXiaoSong; **Cc: stable** on the public patch
- No prerequisites

AGAINST:
- Not a crash, UAF, deadlock, or data-corruption fix
- Committed object dropped Fixes:/Cc: stable
- Only affects `CONFIG_SMB_SERVER`

UNRESOLVED:
- `b4 dig` could not match Namjae’s committed subject (lore error). The
  UnionTech thread was recovered by direct lore search and is the same
  diff.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — control flow is unambiguous;
   maintainer committed it; Reviewed-by on the twin patch.
2. Fixes a real bug that affects users? **PASS** — wrong NTSTATUS on
   copychunk permission failure.
3. Important issue? **PASS** (medium, protocol) — spec-mandated
   ACCESS_DENIED becomes UNEXPECTED_IO_ERROR on a common Windows copy
   path; not a crash, but user-visible interoperability.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small correctness fix.

**Step 9.4: MAKE YOUR DECISION**

This belongs in 6.12.y. The buggy ladder is here, the fix is one `else`,
and it restores the NTSTATUS ksmbd already tried to set and that MS-SMB2
requires. Risk is essentially zero.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------

On 6.12.111 ksmbd, `fsctl_copychunk()` maps `-EACCES` from
`ksmbd_vfs_copy_file_ranges()` to `STATUS_ACCESS_DENIED`, then the next
if/else chain overwrites it with `STATUS_UNEXPECTED_IO_ERROR`. SMB
clients doing server-side copy therefore see a generic I/O error instead
of access denied. The copy is still rejected; the protocol status is
wrong. Joining the `-EACCES` arm with `else if` is the whole fix.

It meets the stable rules: obviously correct, real user-visible bug,
tiny, no new API, applies cleanly here. Benefit is correct SMB
semantics; regression risk is negligible.

Concerns: not a panic/UAF class bug; ksmbd-only. Those do not outweigh a
one-line protocol-status fix that an independent submitter already
nominated for stable.

Verification:
- [Phase 1] Parsed committed tags: only SOB Namjae Jeon on
  `f7c0366e0a80b`; no Fixes:/Cc: stable on the git object
- [Phase 1] UnionTech twin patch on lore has Fixes: e2f34481b24d and Cc:
  stable@vger.kernel.org
- [Phase 2] Diff: 1 line in `fsctl_copychunk()`, `if` → `else if` on
  `-EAGAIN`
- [Phase 2] Confirmed `-EACCES` returns in
  `ksmbd_vfs_copy_file_ranges()` at vfs.c:1840-1847 in this tree
- [Phase 2] Confirmed overwrite path in smb2pdu.c:7988-8005 in this tree
- [Phase 3] git blame: ladder from e2f34481b24db2 (2021 cifsd SMB3
  engine)
- [Phase 3] git merge-base --is-ancestor e2f34481b24db2 HEAD: yes
- [Phase 3] git merge-base --is-ancestor f7c0366e0a80b HEAD: no (fix not
  present)
- [Phase 3] Neighboring copychunk commits fd309860ef245 / 8482150a0743c:
  not in HEAD, not required
- [Phase 3] git apply --check of mainline diff: succeeded at offset -764
- [Phase 4] b4 dig -c f7c0366e0a80b: lore error, no match
- [Phase 4] lore thread: https://lore.kernel.org/linux-
  cifs/2DC5EE1DC892643F+20260731072020.1307022-1-raoxu@uniontech.com/ —
  same diff, Cc: stable, MS-SMB2 3.3.5.15.6
- [Phase 4] ChenXiaoSong Reviewed-by; noted already in ksmbd-for-next-
  next
- [Phase 4] stable list: no prior rejection found
- [Phase 5] Only caller: smb2_ioctl FSCTL_COPYCHUNK/COPYCHUNK_WRITE;
  return value discarded; client sees rsp->hdr.Status
- [Phase 5] Only other -EACCES map in smb2pdu.c already uses else if
- [Phase 6] git describe HEAD: p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111
- [Phase 6] git describe --contains f7c0366e0a80b: v7.3-rc1~77^2~124
  (merged in ksmbd-for-7.3-rc1)
- [Phase 8] Failure mode: wrong NTSTATUS on permission failure, MEDIUM,
  not a crash
- UNVERIFIED: Could not retrieve Namjae’s original mail (b4/lore subject
  mismatch); content confirmed via committed diff + UnionTech thread

**YES**

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4f8e2a6307602..22c49921b1c07 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8068,7 +8068,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-- 
2.53.0

