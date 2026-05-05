Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C53148C5;
	Tue,  5 May 2026 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974723; cv=none; b=Qw78biHrfIbaZ0fXGDjN99kyfIlHC98wyP+qiyY2BcSJP+YPym0Q0v36d422tYHuisQTu1CewZcm0gLyDISPIUYC9NCJ6MQ2OfG7fVcff6yHsry5KV1cHh5gStFcu2ZfkVwJ9XLZ7MPdw4k9lUhELyuGVQuW7VAYWMcSYrtDSNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974723; c=relaxed/simple;
	bh=jh/qD6PEr5GFGUgvRTsO9ylZmM5tQFfSBRJfUkrgB7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNGHMjfUAI/Bclr4VE2YPTwhRleFu2Eck1Ybvry8bmj29x1gl/T4nBpnDjGipUqPo7YusRE/WAcynYzmFuKmNbv1+y33EKO1go0M1POYa/iVX7PsxXZiChf3fk4JvPJUtBN6KHDvgr2b4zj/itT2r/WLm+FHzo5AcEKpB9RUMKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxDAWLvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxDAWLvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99316C2BCC7;
	Tue,  5 May 2026 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974722;
	bh=jh/qD6PEr5GFGUgvRTsO9ylZmM5tQFfSBRJfUkrgB7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxDAWLvp/0zMpi8L/q4wwtmPFNyh0ZGeh4TgZo8ZfkjfZgTnA9y4FutNka/smlVjc
	 F3npdAU/r0tfgry3VnojFK0HVbBvfVH3xsNFP5o1ArPKm3aJ/s48grjOAL2XtUk0qQ
	 s1AR/xMHqsgMc/U9AsblP/7BcJ5z158kM/R6L5NCcN8fhoKBRdfRkTEZaHHuXrYJXq
	 GhHzBFlOSuN/BD0zZZJX45gUugaT3fW12s2updp4kUIo7UWP8evbFj5P+cL1UI7HHs
	 rD2j5o9cIlj3MROql1l0fqG7vpnDXFxNL9F5aizVRJ9hPowqWivQA+/RPALSvocGLd
	 nvReWMXr4RSQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] smb: client: change allocation requirements in smb2_compound_op
Date: Tue,  5 May 2026 05:51:20 -0400
Message-ID: <20260505095149.512052-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

[ Upstream commit 8e13b1b4093e0cbcb3dc2906c13b1fdc95cdf0a0 ]

Currently, smb2_compound_op() allocates
struct smb2_compound_vars *vars using GFP_ATOMIC, although
smb2_compound_op() can sleep when it calls compound_send_recv()
before vars is freed.

Allocate vars using GFP_KERNEL.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `smb: client`; action verb `change`; intent
is to change `smb2_compound_op()` allocation from `GFP_ATOMIC` to
`GFP_KERNEL`.

Step 1.2 Record: Tags present: `Signed-off-by: Fredric Cover
<fredric.cover.lkernel@gmail.com>` and `Signed-off-by: Steve French
<stfrench@microsoft.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Reviewed-by:`, `Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
tags were present.

Step 1.3 Record: The commit body says `smb2_compound_op()` allocates
`struct smb2_compound_vars *vars` with `GFP_ATOMIC`, but later calls
`compound_send_recv()` before freeing `vars`, and that path can sleep.
Symptom is not a crash report; the root cause is an over-restrictive
allocation mode in a sleepable path.

Step 1.4 Record: This is a hidden correctness/reliability fix, not a
feature. `GFP_ATOMIC` is allowed only for non-sleeping/atomic-style
allocations and uses atomic reserves; the documented default for
sleepable kernel allocations is `GFP_KERNEL`.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `fs/smb/client/smb2inode.c`, 1
insertion and 1 deletion. Modified function: `smb2_compound_op()`.
Scope: single-file, single-line surgical fix.

Step 2.2 Record: Before, `vars = kzalloc_obj(*vars, GFP_ATOMIC);`.
After, `vars = kzalloc_obj(*vars, GFP_KERNEL);`. The affected path is
allocation at the start of each `smb2_compound_op()` attempt, before
SMB2 compound request setup and before `compound_send_recv()`.

Step 2.3 Record: Bug category is allocation-context correctness /
resource reliability. The function can sleep through retry `msleep()`
and `compound_send_recv()`, which waits for SMB credits and responses.
The fix lets normal reclaim run and avoids consuming atomic reserves.

Step 2.4 Record: The fix is obviously correct if all callers are
sleepable; code inspection verified callers are VFS/SMB client
operations that already perform sleeping network waits. Regression risk
is very low, because the only behavior change is allowing the allocation
itself to sleep in a path that already sleeps.

## Phase 3: Git History Investigation
Step 3.1 Record: Upstream commit is
`8e13b1b4093e0cbcb3dc2906c13b1fdc95cdf0a0`. Blame on the current
`kzalloc_obj(... GFP_ATOMIC)` line points to treewide allocator
conversion `69050f8d6d075`; the original dynamic allocation using
`GFP_ATOMIC` was introduced by `a7d5c294628088` (`cifs: reduce stack use
in smb2_compound_op`), first appearing in `v5.8`.

Step 3.2 Record: No `Fixes:` tag, so no tagged introducing commit to
follow. Independent blame identified `a7d5c294628088` as the relevant
introduction of the heap allocation.

Step 3.3 Record: Recent history of `fs/smb/client/smb2inode.c` includes
several real fixes to this same function/path: off-by-8 bounds check,
buffer size fix, uninitialized variable fix, wrong index reference, and
refcount leak fixes. No prerequisite for this one-line allocation flag
change was found.

Step 3.4 Record: Author Fredric Cover has a small number of recent SMB
client commits. The patch was committed by Steve French, who is listed
as CIFS/SMB3 client maintainer in `MAINTAINERS`.

Step 3.5 Record: For `v7.0.y`, the patch applies cleanly as-is because
`kzalloc_obj()` exists. For older affected stable trees, the equivalent
backport is the same flag change on `kzalloc(sizeof(*vars),
GFP_ATOMIC)`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 8e13b1b4093e0` found the original submission
at
`https://patch.msgid.link/20260429213453.26235-1-FredTheDude@proton.me`.
`b4 dig -a` found only v1; no later revisions.

Step 4.2 Record: `b4 dig -w` showed the patch was sent to Steve French,
Paulo Alcantara, `linux-cifs@vger.kernel.org`, and `linux-
kernel@vger.kernel.org`. Those are appropriate subsystem recipients.

Step 4.3 Record: No `Reported-by` or bug-report `Link` was present.
WebFetch of lore was blocked by Anubis, but `b4` saved the mbox locally;
the mbox contained the patch email and no review replies.

Step 4.4 Record: The patch is standalone, not part of a multi-patch
series.

Step 4.5 Record: Web search did not find stable-specific discussion for
this exact subject. No known objection or known reason to avoid stable
was found.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `smb2_compound_op()`.

Step 5.2 Record: Callers are all internal SMB2/SMB3 client filesystem
operations: `smb2_query_path_info()`, `smb2_mkdir()`,
`smb2_mkdir_setinfo()`, `smb2_rmdir()`, `smb2_set_path_attr()` via
rename/hardlink, `smb2_set_path_size()`, `smb2_set_file_info()`,
`smb2_create_reparse_inode()`, `smb2_query_reparse_point()`, and
`smb2_rename_pending_delete()`.

Step 5.3 Record: Key callees include request initializers, `msleep()` on
replay retries, `compound_send_recv()`, SMB2 request free helpers,
response buffer frees, and `kfree(vars)`.

Step 5.4 Record: Reachability is user-facing: VFS operations such as
`stat/getattr`, mkdir, rmdir, rename, setattr/truncate, link/reparse
handling flow through SMB client ops into `smb2_compound_op()`.
`compound_send_recv()` waits in `wait_for_compound_request()` and
`wait_for_response()`.

Step 5.5 Record: No duplicate same-line allocation bug was found
elsewhere in this file. Related history shows this function has received
multiple independent correctness fixes.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: The buggy heap allocation exists in
`stable/linux-5.10.y`, `5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`,
`6.19.y`, and `7.0.y`. `stable/linux-5.4.y` has `smb2_compound_op()` but
did not show this `vars` heap allocation, so this specific fix is not
needed there.

Step 6.2 Record: Expected backport difficulty: clean for `7.0.y`;
trivial contextual backport for older affected trees by changing
`kzalloc(sizeof(*vars), GFP_ATOMIC)` to `GFP_KERNEL`.

Step 6.3 Record: No related stable fix for this exact allocation flag
issue was found. Current stable file histories still show the
`GFP_ATOMIC` allocation in affected branches.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is CIFS/SMB3 client filesystem code.
Criticality: IMPORTANT, because it affects mounted SMB2/SMB3 filesystems
and normal filesystem operations, not a niche driver.

Step 7.2 Record: The subsystem is active; recent file history contains
multiple 2025-2026 fixes in the same file and function. The maintainer
tree accepted this patch through Steve French.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected users are SMB2/SMB3 client users on kernels
where the heap allocation exists, mainly `v5.8+` and active stable trees
from `5.10.y` onward.

Step 8.2 Record: Trigger condition is any `smb2_compound_op()`
allocation during common SMB client metadata/namespace operations. The
user-visible bad outcome is avoidable `-ENOMEM` or unnecessary atomic
reserve pressure under memory pressure. Unprivileged users can reach
some paths through normal filesystem operations if they have access to
an SMB mount.

Step 8.3 Record: Failure severity is MEDIUM: not proven
crash/corruption/security, but it affects reliability of common
filesystem operations under memory pressure.

Step 8.4 Record: Benefit is medium because it improves allocation
reliability in common SMB client paths. Risk is very low because the
path already sleeps and the patch changes only the GFP flag.

## Phase 9: Final Synthesis
Step 9.1 Record: Evidence for backporting: one-line fix, no feature/API
change, maintainer-applied, correct allocation flag per kernel docs,
path already sleeps, affects common SMB client operations, affected code
exists in active stable trees. Evidence against: no reported crash, no
`Fixes:`/stable tag, and severity is reliability/ENOMEM rather than data
corruption or panic. Unresolved: direct lore WebFetch was blocked, but
`b4` mbox retrieval succeeded and showed no discussion replies.

Step 9.2 Record: Stable rules checklist: obviously correct: yes; tested:
no explicit `Tested-by`; fixes a real bug: yes, wrong allocation mode in
a sleepable common path; important issue: medium reliability issue, not
critical; small and contained: yes, one line; no new feature/API: yes;
can apply to stable: yes, with trivial adjustment before
`kzalloc_obj()`.

Step 9.3 Record: No automatic exception category applies; this is not a
device ID, hardware quirk, DT update, build fix, or documentation fix.

Step 9.4 Record: Decision: backport. The technical merit is enough
because the fix is minimal, clearly correct, affects common SMB client
operations, and has negligible regression risk.

## Verification
- Phase 1: `git show --format=fuller --stat --patch 8e13b1b4093e0`
  verified subject, body, tags, author, committer, and one-line diff.
- Phase 2: `git show` verified exactly `GFP_ATOMIC` to `GFP_KERNEL` in
  `smb2_compound_op()`.
- Phase 2/5: `ReadFile` verified `compound_send_recv()` is called before
  `kfree(vars)` and that retries can call `msleep()`.
- Phase 2/5: `ReadFile` verified `compound_send_recv()` calls
  `wait_for_compound_request()` and `wait_for_response()`, both wait
  paths.
- Phase 3: `git blame` verified the current line was last touched by
  `69050f8d6d075`; `git show a7d5c294628088` verified the original heap
  allocation with `GFP_ATOMIC`.
- Phase 3: `git tag --contains a7d5c294628088` verified first release
  family as `v5.8`.
- Phase 4: `b4 dig -c`, `-a`, and `-w` verified original patch URL,
  single v1 revision, and recipients.
- Phase 4: local mbox read verified the patch email content and absence
  of additional replies in the saved thread.
- Phase 5: `rg` and `ReadFile` verified callers and VFS reachability
  through SMB client ops.
- Phase 6: branch checks verified the buggy allocation in `5.10.y`,
  `5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`;
  `5.4.y` did not show this heap allocation.
- Phase 6: `git apply --check` verified the upstream patch applies
  cleanly to the current `7.0.y` checkout.
- Phase 7: `MAINTAINERS` verified Steve French as CIFS/SMB3 maintainer
  and `linux-cifs@vger.kernel.org` as the subsystem list.
- Phase 8: `Documentation/core-api/memory-allocation.rst` and
  `include/linux/gfp_types.h` verified `GFP_KERNEL` is for sleepable
  kernel allocations and `GFP_ATOMIC` is non-sleeping/atomic-reserve
  allocation.

**YES**

 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index fe1c9d7765806..8f66de216d0b5 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -209,7 +209,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst = 0;
 	server = cifs_pick_channel(ses);
 
-	vars = kzalloc_obj(*vars, GFP_ATOMIC);
+	vars = kzalloc_obj(*vars, GFP_KERNEL);
 	if (vars == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.53.0

