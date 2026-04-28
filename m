Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047413FAE0E;
	Tue, 28 Apr 2026 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372922; cv=none; b=R38SyGE1uA/KLfg0bWsZCY6c58OPaiiZXFXLx32bhDW7EgTqwLK03Zx0JhwiRKiXo2v69Eg9d4x4FtvZTTqLp3zX+LoJP/hwrwWwsTaJ6TCZz4CFYbEBCugpWwofifvpdJGNudR9qWU/+bUg10lKFOe1StJyL/dCIvZco4x5aeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372922; c=relaxed/simple;
	bh=jyYGDhtrw/szsDNF7cM/8HRXsH2YaxxFQfWiQ+YKGKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVrJA9wM79eb9uY814nmmucZ2t2JV9iU+PtPevFayr0RF2WNf7lOvM9mwnppZGuBRkozQgLi9NXQJFbeE+grsLPErzUdsB7BsDrcJoFhy4RZi30Rwuzzj0djki2w7puzE9rSoRLmIgJlZsFl54+2SJWuUopycyZRK7goNVWeAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DarW9Xr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DarW9Xr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E2EC2BCC6;
	Tue, 28 Apr 2026 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372921;
	bh=jyYGDhtrw/szsDNF7cM/8HRXsH2YaxxFQfWiQ+YKGKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DarW9Xr9dibjK4cv2cAb6RiBRMNgF/cPWNf4DktxLgDDDpDaX6zJcsob55cDRbdYE
	 dv9V3iZbNHS/VE+OpIhavhvbOAD3o7qGTjKpeP4sOXVsz6NpgOxP8yQf5r1Pvo0I6K
	 E5GGzI/FGezaN3D0MVyPJlmiZRgTV+X1VbcQTJutipWPLpXPyfV8i7oDtiXsGo2rOm
	 3f69uI1hYIrFZCnIT+WqkMxQE3ofVJpdOW9z2SLrO6mO5krOCxqolqGunpqYIr6s9c
	 CG5TVh76fj4UU67drnfh/U0VaEleGRXtOveBP8g02izxLsZwtuVdefNxPKtLOPw+jJ
	 VqJYsohxoDGCw==
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
Subject: [PATCH AUTOSEL 7.0-6.12] smb: client: compress: fix bad encoding on last LZ77 flag
Date: Tue, 28 Apr 2026 06:40:31 -0400
Message-ID: <20260428104133.2858589-20-sashal@kernel.org>
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

[ Upstream commit a13e942a03feea211c67a97bc6a57f82aa56e4b6 ]

End-of-stream flag could lead to UB because of int promotion
(overwriting signed bit).

Fix it by changing operand from '1' to '1UL'.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, here's the complete analysis:

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject line parsing:**
Record: `smb: client: compress:` prefix, action verb is "fix", one-line
summary: fix bad encoding on last LZ77 end-of-stream flag due to integer
promotion UB.

**Step 1.2 - Tags:**
Record:
- Signed-off-by: Enzo Matsumiya (author, SUSE)
- Signed-off-by: Steve French (SMB client maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Link:, or Cc:
  stable tags

**Step 1.3 - Commit body:**
Record: Bug described as "End-of-stream flag could lead to UB because of
int promotion (overwriting signed bit)". Fix approach: change operand
from `1` (int) to `1UL` (unsigned long). No crash/stack trace mentioned.
No specific kernel version mentioned.

**Step 1.4 - Hidden bug fix detection:**
Record: Not hidden - explicitly labeled "fix". Author is the original
creator of the LZ77 code, so has clear understanding of intent.

## Phase 2: Diff Analysis

**Step 2.1 - Inventory:**
Record: Single file `fs/smb/client/compress/lz77.c`, 1 line changed
(+1/-1). Function: `lz77_compress()`. Classification: single-file
surgical fix.

**Step 2.2 - Code flow:**
Record: In end-of-stream flag handling:
- Before: `flag |= (1 << (32 - flag_count)) - 1;` — `1` is `int` (signed
  32-bit)
- After: `flag |= (1UL << (32 - flag_count)) - 1;` — `1UL` is `unsigned
  long` (64-bit on 64-bit arches)

**Step 2.3 - Bug mechanism:**
Record: Category (g) Logic / correctness / UB fix. When `flag_count ==
0`, `1 << 32` is shift >= width of `int` → UB (on x86 GCC yields `1`,
then `(1)-1=0`, producing wrong flag byte). When `flag_count == 1`, `1
<< 31` shifts into sign bit of signed int → UB (typically wraps to give
correct result by accident). `1UL` fits these shifts within a 64-bit
unsigned long without UB.

**Step 2.4 - Fix quality:**
Record: Obviously correct. Minimal (1-line). Zero regression risk (on
64-bit, `1UL` is 64-bit, making shift by 32 well-defined; on 32-bit, fix
is equivalent but `1UL << 32` would still be UB — however, `flag` is
`long` which is 32-bit on 32-bit, so the truncation via `lz77_write32()`
ends up correct in practice).

## Phase 3: Git History Investigation

**Step 3.1 - Blame:**
Record: `git log v6.12:fs/smb/client/compress/lz77.c` confirms `flag |=
(1 << (32 - flag_count)) - 1;` exists at v6.12. Bug was introduced in
commit `d14bbfff259ca` ("smb3: mark compression as
CONFIG_EXPERIMENTAL...", July 2024, v6.12).

**Step 3.2 - Fixes: tag:**
Record: No Fixes: tag. Buggy code was introduced in `d14bbfff259ca` per
blame. That commit is present in v6.12 and all later tags (v6.12 through
v6.19).

**Step 3.3 - Related changes:**
Record: Same patch series includes:
- `4c221711b2374` fix buffer overrun in lz77_compress()
- `20d4f9efe008b` fix counting in LZ77 match finding
- `fca46b0e68c5d` increase LZ77_MATCH_MAX_DIST
- `4460e9c68d1a8` LZ77 optimizations
- `71179a5ee916d` add code docs
- `94ae8c3fee94a` cleanup (in v6.12 already)

**Step 3.4 - Author:**
Record: Enzo Matsumiya is the author of the original SMB compression
code and the LZ77 implementation — highest domain authority.

**Step 3.5 - Dependencies:**
Record: Standalone fix. Does not depend on the other patches in the
series (patch 2/8 of series, but only touches 1 line that has been
unchanged since v6.12).

## Phase 4: Mailing List Research

**Step 4.1 - b4 dig:**
Record: `b4 dig -c a13e942a03fee` →
https://lore.kernel.org/all/20260413190713.283939-2-ematsumiya@suse.de/
Patch is 2/8 in series "[PATCH 0-8]" of SMB compression fixes.

**Step 4.1 continued - b4 dig -a:**
Record: Only v1 exists. Applied version is the only version sent.

**Step 4.2 - Reviewers:**
Record: Recipients included smfrench@gmail.com (maintainer),
pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com —
appropriate SMB reviewers.

**Step 4.2 continued - reviewer response:**
Record: Steve French replied "merged into cifs-2.6.git for-next"
confirming acceptance by maintainer. No NAKs or concerns. No explicit
stable nomination.

**Step 4.3 - Bug report:**
Record: No Reported-by or Link tag. Appears to be developer-found
(likely via code inspection or UBSAN).

**Step 4.4 - Series context:**
Record: Part of larger SMB client fixes series. Other series members
(`4c221711b2374` buffer overrun, `20d4f9efe008b` counting fix) are clear
bug fixes in the same code.

**Step 4.5 - Stable ML:**
Record: No explicit stable discussion found.

## Phase 5: Code Semantic Analysis

**Step 5.1 - Modified functions:**
Record: `lz77_compress()` in `fs/smb/client/compress/lz77.c`.

**Step 5.2 - Callers:**
Record: Called from `smb_compress()` in `fs/smb/client/compress.c`,
which is called from the SMB request path only when CIFS_COMPRESSION is
built and user mounts with compression negotiated.

**Step 5.3 - Callees:** Record: Uses `lz77_write32()` → writes little-
endian 32-bit to `flag_pos`.

**Step 5.4 - Reachability:**
Record: Only reachable when: (1) `CONFIG_CIFS_COMPRESSION=y`
(experimental, default N), (2) user mounts with `compress` option, (3)
server negotiates SMB3.1.1 compression, (4) request eligible for
compression (>= PAGE_SIZE write). Not reachable by default kernel
builds.

**Step 5.5 - Similar patterns:**
Record: Only one occurrence of the pattern in this function. Other
shifts in the file (e.g., `LZ77_HASH_SIZE (1 << LZ77_HASH_LOG)` where
LZ77_HASH_LOG=15) are well within int range.

## Phase 6: Cross-Referencing Stable Trees

**Step 6.1 - Code in stable:**
Record: Verified buggy line `flag |= (1 << (32 - flag_count)) - 1;`
exists identically in v6.12, v6.15, v6.17, v6.18, v6.19. Code introduced
in v6.12 (d14bbfff259ca), moved to current form in v6.12 (94ae8c3fee94a)
- both before v6.12 release.

**Step 6.2 - Backport complications:**
Record: The line is identical in all stable trees from v6.12+. Clean
backport expected.

**Step 6.3 - Related fixes in stable:**
Record: No prior fixes for this specific issue in stable trees.

## Phase 7: Subsystem Context

**Step 7.1 - Subsystem criticality:**
Record: `fs/smb/client/compress/` — SMB client compression (experimental
sub-feature of an important filesystem subsystem). Classification:
PERIPHERAL (experimental, opt-in, default off).

**Step 7.2 - Activity:**
Record: Active development — 9 commits to `compress/` directory since
introduction, author is subsystem expert.

## Phase 8: Impact and Risk

**Step 8.1 - Affected users:**
Record: Users with `CONFIG_CIFS_COMPRESSION=y` (experimental, default N)
mounting SMB shares with `compress` option against servers supporting
SMB3.1.1 compression. Very limited population.

**Step 8.2 - Trigger conditions:**
Record: When uncompressed data size produces a state where `flag_count
== 0` on loop exit (i.e., multiple of 32 literal/match tokens followed
by final-loop exit at a 32-boundary) — the end-of-stream flag is
corrupt. Cannot be triggered by unprivileged users without SMB
compression mount.

**Step 8.3 - Failure mode:**
Record: Wrong compressed-payload encoding → server may fail to
decompress → SMB operation failure / possible retry. No crash, no data
corruption of user data (local), no security implications. Severity:
MEDIUM (only affects an experimental feature's correctness).

**Step 8.4 - Risk/benefit:**
Record: Benefit: fixes a real correctness bug for users of compression;
makes code valid under UBSAN. Risk: essentially zero — `1` → `1UL` is a
trivial type promotion that only changes evaluation on the edge UB cases
the fix targets. Very favorable risk/benefit ratio.

## Phase 9: Final Synthesis

**Step 9.1 - Evidence compiled:**
FOR: Real UB per C standard; produces wrong encoded output for
`flag_count == 0` case; 1-line surgical change; zero regression risk;
from the subsystem author; part of a larger fix series that includes
clear bugs; buggy line present and identical in all stable trees v6.12+;
trivial clean apply.
AGAINST: No Fixes:/Reported-by:/Cc: stable/Link: tags; no concrete user
bug report; feature is EXPERIMENTAL (default N) and opt-in; impact
limited to users of experimental compression; no explicit stable
nomination by reviewers.

**Step 9.2 - Stable rules checklist:**
1. Obviously correct and tested? YES — merged by maintainer, trivially
   correct.
2. Fixes a real bug? YES — real C-standard UB producing incorrect bytes.
3. Important issue? BORDERLINE — correctness bug but in experimental
   feature.
4. Small and contained? YES — 1 line.
5. No new features/APIs? YES.
6. Applies cleanly to stable? YES — identical code in v6.12 through
   v6.19.

**Step 9.3 - Exceptions:**
Record: Not a device ID/quirk/DT/build/doc fix. Falls under normal bug-
fix category.

**Step 9.4 - Decision:**
The fix is tiny, obviously correct, zero-risk, and addresses real UB
that produces wrong output in an edge case. Although the feature is
marked EXPERIMENTAL, the fix:
- Is absolutely safe (1 → 1UL)
- Applies cleanly
- Is from the subsystem author
- Makes the code correct under UBSAN
- Complements other bug fixes in the series that should be backported

This is exactly the kind of low-risk correctness fix that stable trees
accept. Users who opted into the experimental feature receive correct
compressed output.

## Verification

- [Phase 1] Parsed tags: no Fixes, no Reported-by, no Cc: stable, no
  Link; two Signed-off-by (author + maintainer)
- [Phase 2] Diff analysis: confirmed via `git show` — single line change
  `1` → `1UL` in `lz77_compress()`
- [Phase 3] git blame/show d14bbfff259ca: original compression commit
  July 2024 → v6.12; confirmed buggy line present
- [Phase 3] git show 94ae8c3fee94a: cleanup commit (Sep 2024, v6.12)
  also contains buggy line — line has been unchanged since v6.12
- [Phase 3] `git tag --contains d14bbfff259ca`: bug reaches v6.12 and
  all releases through v6.19
- [Phase 4] `b4 dig -c a13e942a03fee`: matched to https://lore.kernel.or
  g/all/20260413190713.283939-2-ematsumiya@suse.de/ as patch 2/8
- [Phase 4] `b4 dig -c a13e942a03fee -a`: only v1 exists
- [Phase 4] mbox content: Steve French replied "merged into cifs-2.6.git
  for-next"; no NAKs; no stable request
- [Phase 5] Call chain: `lz77_compress()` ← `smb_compress()` ← SMB
  request path only when CIFS_COMPRESSION=y and compress mount option
  active
- [Phase 6] Verified identical buggy code in v6.12, v6.15, v6.17, v6.18,
  v6.19 via `git show $TAG:fs/smb/client/compress/lz77.c`
- [Phase 7] Confirmed Enzo Matsumiya is the LZ77 code's original author
  (authored d14bbfff259ca, 94ae8c3fee94a and the entire fix/improvement
  series)
- [Phase 8] CONFIG_CIFS_COMPRESSION is "Experimental" and default N
  (verified in `fs/smb/client/Kconfig` line 206-218)
- UNVERIFIED: Whether any real-world SMB server rejects malformed
  compressed frames due to this specific bug — but UB produces wrong bit
  pattern for flag_count == 0, which would be seen as invalid stream
  marker by any standards-compliant decoder.

The fix is a trivial, safe, verifiable correctness improvement that
applies cleanly to all active stable trees. While the feature is
experimental, users opting in get correct output at zero risk to anyone
else.

**YES**

 fs/smb/client/compress/lz77.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 96e8a8057a772..cdd6b53766b0a 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -221,7 +221,7 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	}
 
 	flag <<= (32 - flag_count);
-	flag |= (1 << (32 - flag_count)) - 1;
+	flag |= (1UL << (32 - flag_count)) - 1;
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
-- 
2.53.0

