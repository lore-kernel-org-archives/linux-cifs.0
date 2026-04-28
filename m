Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCCB3F7AB3;
	Tue, 28 Apr 2026 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372916; cv=none; b=ecuNII636yHNv7+DwHKDnflHMm+PjZJdy4HK2gGOcwF3Bv2FoVrnz4jBDUMKXb7IiFLyxWOvLY2ag0edzxEwe46gBfClnBwAdtC2bf4++t77XJWLEsNPcD1JbbAhtcF2hZMHKbxFwSZwx+xZjAeKkj/ebvqlzN8g98BQ5lpPsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372916; c=relaxed/simple;
	bh=xOQhvTSWQ6gIx9DqleNJ3v6jwcJQnbebJT1dEWP3NZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Icaj2wMgWfDdIbv6u/6C7ZJaDKqVQ47kyPHBFErUN32uxm5yHPaWQ684U0kWzPAApOqwFaT8Th31UnKl79PzaURn+DyhZWGtyBes8YBhMw/5xWqh6o5CeFFkvCJis/0H6qyWEIQn1ORV3q9qu9M13d1JjneLUtoQZAG+VAgpatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0FkNfhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0FkNfhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463C5C2BCB5;
	Tue, 28 Apr 2026 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372916;
	bh=xOQhvTSWQ6gIx9DqleNJ3v6jwcJQnbebJT1dEWP3NZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0FkNfhyjboOqUZG1yTF6aLNvY3uVOaJayjBlAgt+wAxpEt85lA8HuFmHmKhVVBuK
	 jO2VVmti8chWZFO37m66P1/RLVXhnkMUuQ+cJ9QSYNsNnEW/9Cf4CWXCKVAgDbL1OQ
	 muj6YZMBg00vBhDpD0APA2MRSNK1eaCVfoZW2OdC5pAbMPqK6GZ8gLrbs8R0vVUJDJ
	 1C5zLTV9UFxAAratg1OCY/Bp+BbqSEpOMHD2BcXBa4FRIJMLO2jufWsCX+7GFGsMq6
	 W3PUBkvDKx8n3ienHKjC9hbJCMedV0sWpggKrriyhCZUaFrHS5OOa2jmj6cxQimmbb
	 q4HtR5Ck2gSkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] smb: client: compress: fix counting in LZ77 match finding
Date: Tue, 28 Apr 2026 06:40:27 -0400
Message-ID: <20260428104133.2858589-16-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 20d4f9efe008be1b673f43d38d3d99fb1fd4cd68 ]

- lz77_match_len() increments @cur before checking for equality,
  leading to off-by-one match len in some cases.

  Fix by moving pointers increment to inside the loop.
  Also rename @wnd arg to @match (more accurate name).
- both lz77_match_len() and lz77_compress() checked for
  "buf + step < end" when the correct is "<=" for such cases.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to perform the analysis. Let me structure
my response covering all 9 phases.

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- Subsystem: `smb: client: compress:` (SMB 3.1.1 client-side
  compression)
- Action verb: "fix"
- Summary: fix counting in LZ77 match finding
- **Record:** `[smb/client/compress]` `[fix]` `[off-by-one in LZ77 match
  length counting]`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- `Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>` (author)
- `Signed-off-by: Steve French <stfrench@microsoft.com>` (subsystem
  maintainer)
- NO `Fixes:` tag, NO `Cc: stable`, NO `Reported-by:`, NO `Link:`, NO
  `Tested-by:`, NO `Reviewed-by:`, NO `Acked-by:`
- **Record:** Minimal tag set - only author + maintainer SOBs. No
  explicit stable/reviewer endorsements.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
Two distinct bugs described:
1. `lz77_match_len()` byte-by-byte fallback increments `@cur` before
   equality check, over-counting match length by 1 on mismatch.
2. Both `lz77_match_len()` do-while and `lz77_compress()` do-while use
   `<` where `<=` is correct for the 8-byte window check, causing early
   exit to slow byte-by-byte fallback.
- **Record:** Bug: off-by-one in match length produces incorrect LZ77
  compressed output. Failure mode: decompressed data mismatches original
  (data corruption) on SMB3.1.1 compressed writes.

### Step 1.4: DETECT HIDDEN BUG FIXES
- This is explicitly labeled as a fix ("fix counting"). Not hidden.
- **Record:** Explicit bug fix with clear root cause described.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- 1 file: `fs/smb/client/compress/lz77.c`
- +10/-7 (17 lines changed)
- Functions: `lz77_match_len()`, `lz77_compress()`
- Scope: single-file surgical fix
- **Record:** Minimal-scope single-file fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Three hunks:
1. Rename parameter `wnd` → `match` (cosmetic, all occurrences).
2. Change `cur + LZ77_STEP_SIZE < end` → `<= end` in `lz77_match_len()`
   do-while.
3. Restructure byte-by-byte fallback: was `while(cur<end &&
   lz77_read8(cur++)==lz77_read8(wnd++))` — post-increment executes even
   on mismatch. Now moves increments inside the body after the match is
   confirmed.
4. Change `srcp + LZ77_STEP_SIZE < end` → `<= end` in `lz77_compress()`
   do-while.
- **Record:** Before: byte-by-byte loop advances pointers even on
  mismatch (off-by-one over-count). After: advances only when bytes
  match.

### Step 2.3: IDENTIFY THE BUG MECHANISM
- Logic/correctness fix (off-by-one counting)
- Traced: when actual match is N bytes in the byte-by-byte tail,
  function returns N+1 if the (N+1)th byte is a mismatch. This produces
  a match token with length N+1 that, upon decompression by the server,
  copies N+1 bytes of which the last byte doesn't match the original
  source - **silent data corruption** in the decompressed write payload.
- **Record:** Category: logic/off-by-one. Mechanism: byte-by-byte
  fallback over-counts match length by 1 on mismatch, producing corrupt
  LZ77 stream.

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct (standard idiom of "check, then advance").
- Minimal (10/7 lines, plus a rename).
- No regression risk: `<=` change is safe because `srcp+8 == end` reads
  bytes `[srcp, srcp+7]` which are valid (end is exclusive bound).
- **Record:** Low regression risk; changes are local and obviously
  correct.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- `git blame` shows lines 70, 72-75, 203 were introduced by
  `94ae8c3fee94a` ("smb: client: compress: LZ77 code improvements
  cleanup"), dated 2024-09-06.
- `git describe --contains 94ae8c3fee94a` → `v6.12-rc1~139^2~11`
- **Record:** Buggy code introduced in v6.12. Present in all stable
  branches ≥ 6.12.

### Step 3.2: FOLLOW THE FIXES: TAG
- No `Fixes:` tag present, but blame confirms the target commit is
  `94ae8c3fee94a`.
- **Record:** Implicit Fixes: 94ae8c3fee94a ("smb: client: compress:
  LZ77 code improvements cleanup"). Original commit is in stable 6.12.y
  and later.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
`git log -- fs/smb/client/compress/lz77.c` on origin/master shows a
series of 6 commits around this fix:
- `4c221711b2374` "fix buffer overrun in lz77_compress()" (Patch 1/8 –
  separate fix)
- `a13e942a03fee` "fix bad encoding on last LZ77 flag" (Patch 2/8 –
  separate fix)
- `20d4f9efe008b` **our commit** (Patch 3/8)
- `fca46b0e68c5d`, `4460e9c68d1a8`, `71179a5ee916d` (Patches 4/8, 5/8,
  6/8 – tuning/optimizations/docs)
- **Record:** Part of 8-patch series; patches 1-3 are bug fixes, patches
  4+ are improvements. This patch (3/8) does NOT depend on patches 1/8
  or 2/8.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
- Enzo Matsumiya is the author of the original LZ77 cleanup
  (94ae8c3fee94a) and many other SMB client fixes in 6.12.y stable
  (e.g., `5ac1f99fdd09d` - compression heuristic fix).
- **Record:** Author is the main maintainer/developer of this
  compression code.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
- Verified: `git apply --check -3` against stable/linux-6.12.y through
  7.0.y: **all apply cleanly**.
- The changes touch lines that exist unchanged in the stable branches
  (stable does not have patches 1 or 2 from the series either, but patch
  3/8 doesn't conflict with them).
- **Record:** Standalone, no prerequisites needed.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
- `b4 dig -c 20d4f9efe008b` found the submission at https://lore.kernel.
  org/all/20260413190713.283939-3-ematsumiya@suse.de/
- `b4 dig -a`: only a v1 posted, applied as-is. No revisions.
- The entire thread was saved to mbox and searched: **no** `Cc: stable`,
  **no** `Fixes:`, **no** `Reviewed-by:`, **no** `Tested-by:`, **no**
  NAKs.
- Steve French's only reply is "merged into cifs-2.6.git for-next"
  (applied without reviewer feedback).
- **Record:** v1 only, minimal discussion, no stable nomination by
  reviewers.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
- `b4 dig -w`: Cc list included Steve French (maintainer), Paulo
  Alcantara, Ronnie Sahlberg, Shyam Prasad, Tom Talpey, Bharath SM,
  Henrique Carvalho, and linux-cifs list.
- No explicit Reviewed-by received — applied by maintainer directly.
- **Record:** Appropriate maintainers CC'd; maintainer applied with no
  public review feedback.

### Step 4.3: SEARCH FOR THE BUG REPORT
- No Reported-by/Link tags. No bug report referenced.
- **Record:** No external bug report; bug found by code inspection by
  the author.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
- This is patch 3/8. Patches 1 (buffer overrun) and 2 (UB fix) are also
  bug fixes in the same file.
- Patches 4-8 are optimizations/docs/preparations.
- **Record:** Part of a bug-fix + improvements series. Our patch is
  self-contained.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
- No prior stable discussion about this specific bug.
- **Record:** No prior stable-specific discussion.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
- `lz77_match_len()` (static inline helper)
- `lz77_compress()` (exported entry)
- **Record:** Two functions modified.

### Step 5.2: TRACE CALLERS
- `lz77_compress` is called from `smb_compress` in
  `fs/smb/client/compress.c:343`.
- `smb_compress` is called from `smb_send_rqst` in
  `fs/smb/client/transport.c:398` when `CIFS_COMPRESS_REQ` flag is set.
- `CIFS_COMPRESS_REQ` is set in `fs/smb/client/smb2pdu.c:5201` when
  `should_compress(tcon, &rqst)` is true (SMB2_WRITE of appropriate
  size, compression negotiated, etc.).
- **Record:** Reachable from userspace write(2)→SMB2_WRITE path when
  CIFS_COMPRESSION=y AND mount has compress option AND server negotiated
  compression.

### Step 5.3: TRACE CALLEES
- `lz77_match_len` is called internally by `lz77_compress`'s main loop
  (line 163 in stable 6.12.y).
- **Record:** `lz77_match_len` is a hot inner-loop helper.

### Step 5.4: FOLLOW THE CALL CHAIN
Call chain: `sys_write()` → ... → `cifs_strict_writev()` → SMB2_WRITE
rqst → `smb_send_rqst()` → `smb_compress()` → `lz77_compress()` →
`lz77_match_len()`.
Gated by: `CONFIG_CIFS_COMPRESSION=y` AND `mount -o compress` AND
server-negotiated compression AND write size ≥ PAGE_SIZE AND data is
compressible per heuristic.
- **Record:** Reachable from userspace but behind multiple opt-in gates.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
- The fix removes a classic C idiom bug (`*(p++) == *(q++)` advancing on
  mismatch). No other instances of this pattern found in the file.
- **Record:** No duplicate patterns found.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
- Verified via `git ls-tree` and `git show` on 5 stable branches:
  `stable/linux-6.12.y`, `6.17.y`, `6.18.y`, `6.19.y`, `7.0.y` — all
  have the identical buggy `lz77.c` (blob SHA
  `96e8a8057a7721233dc49d3388d5e40b8a1bab5b`).
- Not in 6.6.y or earlier (file didn't exist).
- **Record:** Bug exists in 6.12.y, 6.17.y, 6.18.y, 6.19.y, 7.0.y.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
- Tested `git apply --check -3` against all 5 affected stable branches:
  **clean apply** everywhere.
- **Record:** Clean apply, no backport adjustments needed.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
- Three prior compression-related fixes are already in 6.12.y stable:
  `5ac1f99fdd09d` (heuristic functions), `9b4af913465cc` (illegal
  accesses), `590efcd3c75f0` (invalid free pointer).
- This establishes a clear pattern of stable maintainers accepting
  compression fixes despite EXPERIMENTAL status.
- **Record:** Precedent exists for backporting fixes to this exact
  file/feature.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- Subsystem: SMB client (network filesystem), specifically
  CIFS_COMPRESSION (EXPERIMENTAL, default N).
- Criticality: **PERIPHERAL** for kernel as a whole (opt-in experimental
  feature), but **IMPORTANT** for users who enable it (fixes data
  integrity).
- **Record:** PERIPHERAL scope but data-integrity class.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
- `git log -20 -- fs/smb/client/compress/` shows low but steady
  activity, mainly by Enzo Matsumiya.
- **Record:** Low-activity experimental feature.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
- Users with `CONFIG_CIFS_COMPRESSION=y` kernel AND `mount -o compress`
  AND SMB 3.1.1 server that negotiates compression.
- **Record:** Narrow audience — opt-in at both build and mount time.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- Trigger: write of ≥ PAGE_SIZE compressible data where a potential
  match exists in the final <8 bytes of the input and the match does not
  extend to the very end.
- Cannot be triggered by unprivileged user without the opt-in
  configuration.
- **Record:** Specific but realistic trigger on any compressed write
  whose tail contains a partial match.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- Wrong match length → decompressed data at the server differs from
  original → **silent data corruption** in the file written over SMB.
- Severity per standard rubric: **HIGH** (data corruption), but
  mitigated by the opt-in nature.
- **Record:** Failure mode: silent data corruption. Severity: HIGH when
  triggered, but narrow audience.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- BENEFIT: Fixes a silent data corruption for users who opt into CIFS
  compression. Consistent with previously accepted compression fixes.
- RISK: Very low. 10/7-line change. Obviously correct idiom fix. Applies
  cleanly. No API changes. The `<=` change is provably safe (8-byte read
  at `end-8` stays in-bounds).
- **Record:** Benefit level: moderate (narrow but data-integrity). Risk
  level: very low. Ratio favors backporting.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real bug confirmed by diff analysis (byte-by-byte post-increment over-
  counts on mismatch)
- Failure mode is silent data corruption on compressed SMB writes
- Small, surgical, obviously-correct fix
- Applies cleanly to all 5 affected stable trees (6.12.y–7.0.y)
- Precedent: similar compression fixes already in stable (5ac1f99fdd09d,
  9b4af913465cc, 590efcd3c75f0)
- Author is the primary maintainer of this code

AGAINST:
- No Cc: stable, no Fixes: tag, no Reported-by
- Feature is EXPERIMENTAL and default N
- Narrow real-world audience
- Part of series with mixed fix/improvement content (but this patch is
  self-contained)

UNRESOLVED: None.

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **Yes** — simple idiom fix; applied in
   Torvalds' tree (7.1-rc1).
2. Fixes a real bug that affects users? **Yes** — data corruption for
   compression users.
3. Important issue? **Yes** — data integrity class.
4. Small and contained? **Yes** — 10/-7 in one file.
5. No new features/APIs? **Yes** (no new API).
6. Applies to stable? **Yes** — verified clean apply on 6.12.y–7.0.y.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
- Not an exception category; stands on its merits as a data-correctness
  fix.

### Step 9.4: MAKE DECISION
Evidence supports backporting. The fix addresses a genuine data-
integrity bug, is minimal and obviously correct, applies cleanly, and is
consistent with previously-accepted fixes to this same file.

---

## Verification
- [Phase 1] Parsed tags: only author + maintainer SOBs, no
  stable/Fixes/Reported-by — verified by reading full commit message.
- [Phase 2] Diff analysis: 10/-7 lines in
  `fs/smb/client/compress/lz77.c`; two functions touched
  (`lz77_match_len`, `lz77_compress`).
- [Phase 2] Semantic correctness: traced byte-by-byte loop manually —
  confirmed over-count by 1 on mismatch; `<=` change verified safe
  (8-byte read at `end-8` in-bounds).
- [Phase 3] `git blame` on changed lines: introduced by `94ae8c3fee94a`
  ("smb: client: compress: LZ77 code improvements cleanup").
- [Phase 3] `git describe --contains 94ae8c3fee94a` →
  `v6.12-rc1~139^2~11` (present since v6.12).
- [Phase 3] `git log -- fs/smb/client/compress/lz77.c` on origin/master:
  confirmed 8-patch series, this is patch 3/8, independent of patches
  1/8 and 2/8.
- [Phase 4] `b4 dig -c 20d4f9efe008b`: found lore submission at https://
  lore.kernel.org/all/20260413190713.283939-3-ematsumiya@suse.de/
- [Phase 4] `b4 dig -a`: only v1, no other revisions.
- [Phase 4] `b4 dig -w`: maintainer Steve French + linux-cifs list +
  related developers CC'd.
- [Phase 4] Full thread mbox saved to `/tmp/lz77_thread.mbox`: confirmed
  no `Cc: stable`, no `Fixes:`, no `Reviewed-by/Tested-by`, only "merged
  into cifs-2.6.git for-next" from maintainer.
- [Phase 5] `grep` for `lz77_compress` callers: `smb_compress`
  (transport.c:398 and compress.c:343); `should_compress` gates call in
  smb2pdu.c:5201.
- [Phase 5] Reachable from userspace write(2) only when
  CIFS_COMPRESSION=y and `mount -o compress`.
- [Phase 6] `git ls-tree` on 5 stable branches: identical blob
  `96e8a8057a7721233dc49d3388d5e40b8a1bab5b` — buggy code in
  6.12.y/6.17.y/6.18.y/6.19.y/7.0.y.
- [Phase 6] `git apply --check -3` on all 5 stable branches: clean apply
  on all.
- [Phase 6] Precedent fixes already in 6.12.y stable: `5ac1f99fdd09d`,
  `9b4af913465cc`, `590efcd3c75f0` — all compression-related fixes to
  same file/feature.
- [Phase 7] `Kconfig` read: `CIFS_COMPRESSION` is `bool "SMB message
  compression (Experimental)"` default n; confirmed in both mainline and
  6.12.y stable.
- [Phase 8] Severity assessment: silent data corruption in compressed
  writes; narrow audience due to opt-in nature.

The fix addresses a real data-integrity bug with a minimal, obviously-
correct change that applies cleanly to all affected stable trees, and it
is consistent with previously accepted compression fixes. The
EXPERIMENTAL/opt-in nature narrows the audience but does not negate the
value of the fix.

**YES**

 fs/smb/client/compress/lz77.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index c1e7fada6e61c..61cdf1c146127 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -48,17 +48,17 @@ static __always_inline void lz77_write32(u32 *ptr, u32 v)
 	put_unaligned_le32(v, ptr);
 }
 
-static __always_inline u32 lz77_match_len(const void *wnd, const void *cur, const void *end)
+static __always_inline u32 lz77_match_len(const void *match, const void *cur, const void *end)
 {
 	const void *start = cur;
 	u64 diff;
 
 	/* Safe for a do/while because otherwise we wouldn't reach here from the main loop. */
 	do {
-		diff = lz77_read64(cur) ^ lz77_read64(wnd);
+		diff = lz77_read64(cur) ^ lz77_read64(match);
 		if (!diff) {
 			cur += LZ77_STEP_SIZE;
-			wnd += LZ77_STEP_SIZE;
+			match += LZ77_STEP_SIZE;
 
 			continue;
 		}
@@ -67,10 +67,13 @@ static __always_inline u32 lz77_match_len(const void *wnd, const void *cur, cons
 		cur += count_trailing_zeros(diff) >> 3;
 
 		return (cur - start);
-	} while (likely(cur + LZ77_STEP_SIZE < end));
+	} while (likely(cur + LZ77_STEP_SIZE <= end));
 
-	while (cur < end && lz77_read8(cur++) == lz77_read8(wnd++))
-		;
+	/* Fallback to byte-by-byte comparison for last <8 bytes. */
+	while (cur < end && lz77_read8(cur) == lz77_read8(match)) {
+		cur++;
+		match++;
+	}
 
 	return (cur - start);
 }
@@ -195,7 +198,7 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 			flag_pos = dstp;
 			dstp += 4;
 		}
-	} while (likely(srcp + LZ77_STEP_SIZE < end));
+	} while (likely(srcp + LZ77_STEP_SIZE <= end));
 
 	while (srcp < end) {
 		u32 c = umin(end - srcp, 32 - flag_count);
-- 
2.53.0

