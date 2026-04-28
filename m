Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E393F54AD;
	Tue, 28 Apr 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372912; cv=none; b=tuCFY7O7IIIC91AfcVxAZcol0/TM92HZ9iO/jErGjEQ+vdQUy+u35x5PT+sPLClogDMepTMrFVedNSNuqvQ2DRkVf2A5peN8V17Di1GuDcskc26kC/3tAO3msPPA8WOvDiOnu2LyamR9OiSTXtuLvdfiUT/Xs0GlKBDwiYJXF34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372912; c=relaxed/simple;
	bh=KM8CvkVf9KhC9tS6FGNy0JB1gj2gl8LbhL0+oO30XSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u7afD1HhsIs6dpa7O7eoH9+CXliZTW93BQpdi9Wr9S0rd8J4v+RkzWjnC2HvNS1P23L1oGpXoqOqWVogqkJEd9al0nsznVmjlHuCiIHfPZMHM3AGypBfq91jn996bkEYK+oooxrXx/VURjBaxe7Ri1nPyCnjxZ0lLCVyrnJf7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvA5UzLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvA5UzLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B676CC2BCAF;
	Tue, 28 Apr 2026 10:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372911;
	bh=KM8CvkVf9KhC9tS6FGNy0JB1gj2gl8LbhL0+oO30XSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvA5UzLku9jnYm1QCzLTu14qCOaLxY/yl5HZ13iBD5PZWHAbEsmqoRjMfxelzxW1D
	 baB7MoX4A9Qwr3M0mriKnQ1aUIHOODC27HYAFyO16fs0zMD5/6cPjFRvqx7TJTEkYc
	 xeTQWUJS6534W0Fn50MacbqbbneaazXy2sRTkmkGvCPpEEwBwNbAcTs3apa3Bt5jxb
	 iQRnvIxzuBL3v4y7B6mku7QZefJTKLgU1l3TExXV+nJ29mz9SgZisgakGx2Gf8mrRl
	 fS0sgLGT0DKlTWkDLaqwD+sftJg+BUPGVD4nZ1lS9FvZMenLRe28wxB5gGs4gCzItz
	 skNgl9ozX0YQw==
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
Subject: [PATCH AUTOSEL 7.0-6.12] smb: client: compress: fix buffer overrun in lz77_compress()
Date: Tue, 28 Apr 2026 06:40:24 -0400
Message-ID: <20260428104133.2858589-13-sashal@kernel.org>
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

[ Upstream commit 4c221711b23745e2fb961ee517e9ed96ce76f9cb ]

@dst buffer is allocated with same size as @src, which, for good
compression cases, works fine.

However, when compression goes bad (e.g. random bytes payloads), the
compressed size can increase significantly, and even by stopping the
main loop at 7/8 of @slen, writing leftover literals could write past
the end of @dst because of LZ77 metadata.

To fix this, add lz77_compressed_alloc_size() helper to compute the
correct allocation size for @dst, accounting for metadata and worst
cast scenario (all literals).

While this is overprovisioning memory, it's not only correct, but also
allows lz77_compress() main loop to run without ever checking @dst
limits (i.e. a perf improvement).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have sufficient context to produce the analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: subsystem `smb: client: compress:`, verb `fix`, summary: buffer
overrun in `lz77_compress()`.

**Step 1.2 — Tags**
Record: Only `Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>` and
`Signed-off-by: Steve French <stfrench@microsoft.com>` (subsystem
maintainer). NO `Fixes:`, NO `Cc: stable`, NO `Reported-by`, NO
`Reviewed-by`, NO `Tested-by`, NO `Link:`. Reference on lore:
`<20260413190713.283939-1-ematsumiya@suse.de>` — this is patch **1/8**
of a series.

**Step 1.3 — Body text**
Record: Bug = `@dst` is allocated same size as `@src`. When compression
expands the payload (random/incompressible data), the existing 7/8
bailout in the main loop is insufficient because (a) it only runs in the
match branch, not on the per-literal path and per-flag-word path, and
(b) the trailing-literals loop and final flag-word write at function end
have no bounds check. Failure mode: heap write past `@dst` end. No stack
traces, no reporter. Author explains the root cause clearly.

**Step 1.4 — Hidden bug?**
Record: Not hidden — "fix buffer overrun" is explicit; this is a real
memory-safety fix.

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record: 3 files, +33/-15. `fs/smb/client/compress.c` (caller),
`fs/smb/client/compress/lz77.c` (the compressor),
`fs/smb/client/compress/lz77.h` (new helper). Functions touched:
`smb_compress()`, `lz77_compress()`. Scope: single-file contained
subsystem fix (within new `compress/` subdir).

**Step 2.2 — Code flow before/after**
Record:
- Before: `dlen = slen` ⇒ buffer is `slen` bytes; loop has an in-loop
  `if (dstp - dst >= slen - (slen >> 3))` that only fires on the match
  path; tail literal loop + final `lz77_write32(flag_pos, flag)` run
  with no bounds check.
- After: `dlen = lz77_compressed_alloc_size(slen)` which returns `size +
  (size >> 3) + 8`, providing worst-case all-literal headroom (12.5% + 8
  bytes of flag metadata). The 7/8 in-loop check is deleted. A
  `WARN_ON_ONCE(*dlen < lz77_compressed_alloc_size(slen))` at function
  entry validates the caller provided adequate space.

**Step 2.3 — Bug mechanism**
Record: Memory-safety fix (buffer overrun) = category (d) above. Worst-
case all-literals path writes 1 byte per input byte + 4 bytes per 32
input bytes (flag word) + up to 4 extra trailing bytes for the final
flag write = `slen + slen/8 + ~8` bytes. Old allocation of `slen` is
insufficient.

**Step 2.4 — Quality**
Record: Fix is obviously correct; the helper is a simple inline, and
removing the guard is safe because the buffer is now sized for the worst
case. The WARN provides a safety net. No regressions expected. Caller
semantics preserved: `-EMSGSIZE` is still returned when compression
isn't beneficial (`*dlen >= slen` at the end), and `smb_compress()`
already handles that by falling back to uncompressed send.

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: The buggy allocation and 7/8-bailout loop were introduced in
`94ae8c3fee94a` ("smb: client: compress: LZ77 code improvements
cleanup", dated 2024-09-15, merged into v6.12). Notably that commit's
message even says: *"Known bugs: This implementation currently works
fine in general, but breaks with some payloads used during testing.
Investigation ongoing, to be fixed in a next commit."* The original SMB
compression infrastructure came in `d14bbfff259ca` (also v6.12).

**Step 3.2 — Fixes: follow-up**
Record: No `Fixes:` tag, but the de-facto target is `94ae8c3fee94a` (in
v6.12+).

**Step 3.3 — File history**
Record: `fs/smb/client/compress/lz77.c` has had almost no churn between
v6.12 and v7.0 (only the generic `move asm/unaligned.h ->
linux/unaligned.h` touched it). All stable trees v6.12.y through v6.18.y
carry essentially the same buggy implementation.

**Step 3.4 — Author**
Record: Author (Enzo Matsumiya) is the original implementor of the SMB
LZ77 code. Co-signed by subsystem maintainer (Steve French). Author
credibility: high.

**Step 3.5 — Dependencies**
Record: Patch 1/8 of an 8-patch series. Patches 2/8 and 3/8 are also
fixes (UB in final flag, off-by-one in match length). Patch 1/8 is
**self-contained** — it only calls the new inline helper and the
callsite update in `smb_compress()`; it does not depend on patches 2–8
to be functional or correct. Patches 5–8 are optimizations/docs/new
header.

## Phase 4: Mailing List Research

**Step 4.1 — b4 dig**
Record: `b4 dig -c 4c221711b23745e2fb961ee517e9ed96ce76f9cb` → `https://
lore.kernel.org/all/20260413190713.283939-1-ematsumiya@suse.de/`. Single
revision (v1); no re-spins, no NAKs on this particular patch.

**Step 4.2 — Reviewers**
Record: Original Cc: linux-cifs, Steve French, Paulo Alcantara, Ronnie
Sahlberg, Shyam Prasad, Tom Talpey, Bharath Naik, Henrique Carvalho. No
explicit `Reviewed-by`/`Tested-by`/`Acked-by` replies for patch 1/8 in
the thread.

**Step 4.3 — Bug report**
Record: No `Link:` or `Reported-by`. Author describes the failure as
found during testing with random payloads.

**Step 4.4 — Series context**
Record: 8-patch series; patches 2/8 and 7/8 received replies. Patch 7/8
(unrelated `common.h`) had a 32-bit build breakage reported by Nathan
Chancellor and was dropped from for-next. The remaining patches
including 1/8 were merged. Patch 1/8 is not entangled with 7/8.

**Step 4.5 — Stable list**
Record: No stable-specific discussion found; no prior attempt to send
this to stable.

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `lz77_compress()` (the buggy function), `smb_compress()` (the
sole caller), new helper `lz77_compressed_alloc_size()`.

**Step 5.2 — Callers**
Record: `grep "lz77_compress("` shows exactly one caller:
`fs/smb/client/compress.c:343` in `smb_compress()`. `smb_compress()` is
invoked from the SMB2 write send path when `should_compress()` returns
true.

**Step 5.3 — Callees**
Record: `lz77_compress()` uses `kvcalloc()` for a hash table,
`kvfree()`, `memcpy()`, a few internal helpers. No locks, no blocking
I/O directly.

**Step 5.4 — Reachability**
Record: Reachable from userspace via `write(2)`/`writev(2)`/mmap
writeback on a CIFS mount **when**: (a) `CONFIG_CIFS_COMPRESSION=y`, (b)
the SMB 3.1.1 server negotiated compression, (c) the share has
`SMB2_SHAREFLAG_COMPRESS_DATA`, (d) the payload passes
`is_compressible()` heuristics. Data content is user-controlled; an
attacker (or merely unlucky workload) who gets a payload through
`is_compressible()` but that produces expanding LZ77 output reaches the
overrun. Triggering requires all the config/negotiation stars to align,
but once they do the buggy path is data-driven and realistic.

**Step 5.5 — Similar patterns**
Record: Not applicable — single in-tree LZ77 implementation.

## Phase 6: Stable Tree Analysis

**Step 6.1 — Does the buggy code exist in stable?**
Record: Yes. `v6.12:fs/smb/client/compress/lz77.c` and `.../compress.c`
confirm identical `dlen = slen;` allocation and identical 7/8 bailout.
All active stable trees v6.12.y, v6.13.y/maintained extends, v6.14.y,
v6.15.y, v6.16.y, v6.17.y, v6.18.y carry the bug.

**Step 6.2 — Backport complications**
Record: `git log v6.12.. -- fs/smb/client/compress.c
fs/smb/client/compress/lz77.c fs/smb/client/compress/lz77.h` shows
almost no churn (only `asm/unaligned.h` rename). Expect a clean cherry-
pick. (`v6.12` tree uses `asm/unaligned.h` in lz77.c — irrelevant to
this diff.)

**Step 6.3 — Related fixes already in stable?**
Record: None found.

## Phase 7: Subsystem Context

**Step 7.1 — Criticality**
Record: `fs/smb/client` — IMPORTANT (network filesystem, widely used for
Windows interop). Feature itself (CIFS_COMPRESSION) is PERIPHERAL
because marked "Experimental" and default-N.

**Step 7.2 — Activity**
Record: fs/smb/client is actively maintained; this specific `compress/`
subdir had minimal churn until this v7.1-rc1 batch of fixes.

## Phase 8: Impact and Risk

**Step 8.1 — Who is affected**
Record: Users with `CONFIG_CIFS_COMPRESSION=y` mounting SMB3.1.1 shares
that negotiate compression and issue writes ≥ PAGE_SIZE with
incompressible payloads. Narrow but non-empty user population; distro
default is N, so few production setups, but developers and people
experimenting with the feature are exposed.

**Step 8.2 — Trigger conditions**
Record: Data-dependent (random/encrypted-looking payloads). Does not
require privilege beyond write access to the CIFS mount. Not timing-
dependent.

**Step 8.3 — Failure mode severity**
Record: Kernel heap buffer overrun → memory corruption, potential crash,
potential exploitability. Severity: HIGH (would be CRITICAL if the
feature were enabled by default).

**Step 8.4 — Benefit/Risk**
Record: Benefit = eliminates a real heap overrun in an enabled-by-config
CIFS path. Risk = very low; the fix is tiny, adds headroom, removes a
guard that is no longer needed, and keeps caller semantics (the
`-EMSGSIZE` fallback). Net: favorable for stable.

## Phase 9: Synthesis

**For backporting:** real buffer overrun (category: memory safety),
small surgical patch (~48 lines, 3 files, same subsystem), fix logic is
obviously correct, author is the original implementor, maintainer signed
it off, bug present in all stable trees v6.12+, applies cleanly, self-
contained (does not require the rest of the 8-patch series).

**Against backporting:** feature is `CONFIG_EXPERIMENTAL`, default N; no
`Fixes:`, no `Cc: stable`, no `Reported-by`, no `Reviewed-by`/`Tested-
by`; commit is only ~10 days old at time of review (little mainline soak
time); part of a broader cleanup series.

**Stable rules checklist:**
1. Obviously correct — yes, math on allocation size is direct.
2. Fixes a real bug — yes, documented overrun.
3. Important (memory corruption) — yes.
4. Small and contained — yes.
5. No new features/APIs — the new helper is internal (file-private
   style) and used solely to fix this bug.
6. Applies to stable — yes, the code is unchanged in stable trees.

**Exception categories:** none needed; it qualifies directly as a
memory-safety fix.

**Decision:** despite the experimental gating and thin review metadata,
this is a textbook stable candidate: a heap buffer overrun in a kernel
path reachable from userspace, fixed by a minimal, self-evident patch.
The right call is YES.

## Verification

- [Phase 1] Parsed tags from commit message: only two `Signed-off-by`
  lines; no `Fixes:`/`Cc: stable`/`Reported-by`/`Reviewed-by`/`Tested-
  by` — confirmed by `git show 4c221711b2374 --format='%B' -s | grep -E
  "^(Fixes|Cc:|Reported-by|Reviewed-by|Tested-by|Acked-by|Signed-off-
  by):"`.
- [Phase 2] Diff analysis: verified by reading the full diff and
  `fs/smb/client/compress/lz77.c` at HEAD. Confirmed the pre-fix 7/8
  check is only reached after the match-path branch and that the
  trailing literals loop + final `lz77_write32(flag_pos, flag)` have no
  bounds check.
- [Phase 2] Verified caller semantics: `smb_compress()` in
  `fs/smb/client/compress.c` treats `-EMSGSIZE` or `dlen >= slen` as a
  reason to fall back to uncompressed send — preserved after the fix.
- [Phase 3] `git log --oneline fs/smb/client/compress.c
  fs/smb/client/compress/lz77.c fs/smb/client/compress/lz77.h`
  identified introduction in `d14bbfff259ca` and rewrite in
  `94ae8c3fee94a`.
- [Phase 3] `git describe --contains d14bbfff259ca` →
  `v6.12-rc1~139^2~13`; `git tag --contains d14bbfff259ca | grep
  "^v[0-9]+\.[0-9]+$"` → first release tag is `v6.12`.
- [Phase 3] `git show v6.12:fs/smb/client/compress.c | grep -n "dlen =
  slen"` → line 350 confirms identical buggy allocation in v6.12 stable.
- [Phase 3] `git show v6.12:fs/smb/client/compress/lz77.c | grep -n
  "dstp - dst >= slen"` → line 187 confirms identical 7/8 bailout in
  v6.12 stable.
- [Phase 3] `git show v6.12:fs/smb/client/Kconfig | grep -A10
  CIFS_COMPRESSION` → confirmed `bool "SMB message compression
  (Experimental)" ... default n`.
- [Phase 4] `b4 dig -c 4c221711b2374` → returned lore URL `https://lore.
  kernel.org/all/20260413190713.283939-1-ematsumiya@suse.de/`, which is
  "[PATCH 1/8]".
- [Phase 4] `b4 dig -c 4c221711b2374 -a` → single revision (v1), no re-
  spins.
- [Phase 4] `b4 dig -c 4c221711b2374 -w` → recipients include linux-
  cifs, Steve French, Paulo Alcantara, Ronnie Sahlberg, Shyam Prasad,
  Tom Talpey, Bharath Naik, Henrique Carvalho.
- [Phase 4] Thread mbox (`/tmp/b4-lz77/thread.mbox`) scanned: no
  `Reviewed-by`, `Tested-by`, `Acked-by`, or stable-nomination reply to
  patch 1/8. Build-break comment from Nathan Chancellor targeted patch
  7/8 only.
- [Phase 5] `grep "lz77_compress("` across the repo confirmed only one
  external caller (`fs/smb/client/compress.c:343`) and the prototype in
  lz77.h.
- [Phase 6] `git log --oneline v6.12.. -- fs/smb/client/compress.c
  fs/smb/client/compress/lz77.c fs/smb/client/compress/lz77.h` shows
  only `asm/unaligned.h` rename plus subsequent fixes — indicates clean
  backport.
- [Phase 8] Failure mode inferred from code inspection (heap write past
  `@dst`); confirmed path in `lz77_compress()` tail loop and final flag
  write. Severity HIGH.
- UNVERIFIED: Could not fetch the lore URL directly (Anubis anti-bot
  page); relied on `b4 dig` output and the saved mbox for thread
  contents.
- UNVERIFIED: No independent Tested-by on this specific patch; author's
  claim of triggering via random payloads is not reproducible from the
  commit alone, though the code analysis supports the described bug.

**YES**

 fs/smb/client/compress.c      |  6 +-----
 fs/smb/client/compress/lz77.c | 14 ++++----------
 fs/smb/client/compress/lz77.h | 28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 3d1e73f5d9af9..be9023f841e69 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -329,11 +329,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
-	/*
-	 * This is just overprovisioning, as the algorithm will error out if @dst reaches 7/8
-	 * of @slen.
-	 */
-	dlen = slen;
+	dlen = lz77_compressed_alloc_size(slen);
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index cdd6b53766b0a..c1e7fada6e61c 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -137,6 +137,10 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	long flag = 0;
 	u64 *htable;
 
+	/* This is probably a bug, so throw a warning. */
+	if (WARN_ON_ONCE(*dlen < lz77_compressed_alloc_size(slen)))
+		return -EINVAL;
+
 	srcp = src;
 	end = src + slen;
 	dstp = dst;
@@ -180,15 +184,6 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 			continue;
 		}
 
-		/*
-		 * Bail out if @dstp reached >= 7/8 of @slen -- already compressed badly, not worth
-		 * going further.
-		 */
-		if (unlikely(dstp - dst >= slen - (slen >> 3))) {
-			*dlen = slen;
-			goto out;
-		}
-
 		dstp = lz77_write_match(dstp, &nib, dist, len);
 		srcp += len;
 
@@ -225,7 +220,6 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
-out:
 	kvfree(htable);
 
 	if (*dlen < slen)
diff --git a/fs/smb/client/compress/lz77.h b/fs/smb/client/compress/lz77.h
index cdcb191b48a23..2603eab9e071c 100644
--- a/fs/smb/client/compress/lz77.h
+++ b/fs/smb/client/compress/lz77.h
@@ -11,5 +11,33 @@
 
 #include <linux/kernel.h>
 
+/**
+ * lz77_compressed_alloc_size() - Compute compressed buffer size.
+ * @size:	uncompressed (src) size
+ *
+ * Compute allocation size for the compressed buffer based on uncompressed size.
+ * Accounts for metadata and overprovision for the worst case scenario.
+ *
+ * LZ77 metadata is a 4-byte flag that is written:
+ * - on dst begin (pos 0)
+ * - every 32 literals or matches
+ * - on end-of-stream (possibly, if last write was another flag)
+ *
+ * Worst case scenario is an all-literal compression, which means:
+ * metadata bytes = 4 + ((@size / 32) * 4) + 4, or, simplified, (@size >> 3) + 8
+ *
+ * The worst case scenario rarely happens, but such overprovisioning also allows lz77_compress()
+ * main loop to run without ever bound checking dst, which is a huge perf improvement, while also
+ * being safe when compression goes bad.
+ *
+ * Return: required (*) allocation size for compressed buffer.
+ *
+ * (*) checked once in the beginning of lz77_compress()
+ */
+static __always_inline u32 lz77_compressed_alloc_size(const u32 size)
+{
+	return size + (size >> 3) + 8;
+}
+
 int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen);
 #endif /* _SMB_COMPRESS_LZ77_H */
-- 
2.53.0

