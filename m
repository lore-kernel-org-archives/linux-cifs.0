Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353A150B3AA;
	Mon, 19 Oct 2026 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418748; cv=none; b=oM6B457ojRZMD0rLeYpdYsuzbT4rypup3TFO0Gf7fh95xoy2+QGQGenEdDcMnvV7MRFFJZkRBXNvQlICWk+h2bIuQO/CYNOdgyso53kWMoHF9ANEc+5n2OVF17fB8zu+sDPjPSgRvgGBrxG3fgV8AQRT8HLFlJsZAC8Q2DSVx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418748; c=relaxed/simple;
	bh=4oRcyGmXOH1XfD125gD7qiYzHYGO3C2D5aOV3bytk8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGbLtkdWMUmxEcyOl7WW48uDg8OONIANdRywVWhzaC3lkQOm1ntYgPEyPFq9bZOt1H4CaWw8KIlmHwT9AcgqqW+l50cLpvo64EvZE4uv3qFzjuu4E6lZY/1y5s07g+FFub0/q33S+/HKUfK1tE39dRB7Fh2WmhqHMr+SsZYcaVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtAbQFID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtAbQFID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F054C1F000C6;
	Mon, 19 Oct 2026 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418744;
	bh=YFFkrLbjthWIX8mSKrxUrc8VHsO1zAFHlMtQctRZNZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtAbQFIDtO2anpDAkwfEOmezSws8jqgDIkEE0x6RfpO0m1M6ic1JHCzUac7zo6brs
	 JA+XjEv4ReRU5spVspX5LIq7Q5uVAA0Wee7131aw2SOTydGUPkd7LgBQMq4QDYyOo7
	 tXVULpqz6+TaJts7jW1i6vd5xCQ9Rap4Zb8bzzsI64xn4lTalTGpxikUwiPNL+XNKr
	 tP5QpcXTh1F+f9a5/qkfVaK2/ccQZe4Yx9LN9MtZKas+jGSpnLkzti0XS5uS/M4wJD
	 Wb9Bx2YzRTt1bYuVasghDhD9l/nSjPJvX481pPLWcAorswhvdSzFEnCP6ESId1X+Sy
	 TWlIQs8CR+WQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Mon, 19 Oct 2026 09:52:36 -0400
Message-ID: <20261019135441.1420968-465-sashal@kernel.org>
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

[ Upstream commit c1d7bbfc5e081875053723d1a69eb2cf341eaaf1 ]

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The buggy
`fp->durable_timeout = 60` assignment is still in this checkout; the
upstream fix is not.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ksmbd]** **[fix]** durable handle v2 default timeout units
(60 → 60000). Subsystem is the in-kernel SMB server. Action verb is
explicitly **fix**.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Upstream commit `337e5ea7498178b3e50b39c266268a8b4d5b48d6` (not an
ancestor of this tree):
- **Assisted-by:** Claude:claude-sonnet-5
- **Signed-off-by:** Gael Blivet \<gael.blivet@gmail.com\>
- **Acked-by:** Namjae Jeon \<linkinjeon@kernel.org\> (ksmbd maintainer;
  query text shows this as SOB from candidate prep)
- **Signed-off-by:** Steve French \<stfrench@microsoft.com\> (CIFS/SMB
  maintainer)
- **No Fixes:** tag (expected for this review queue)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Link**

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** When Durable Handle Request V2 has `Timeout=0` (“let the
  server choose”), `fp->durable_timeout` is set to **60**.
- **Root cause:** Every other use of this field is **milliseconds**:
  wire Timeout per [MS-SMB2], `DURABLE_HANDLE_MAX_TIMEOUT` (300000), the
  nonzero `min_t` branch, and the scavenger adding it to
  `jiffies_to_msecs(jiffies)`.
- **Symptom:** Handle becomes scavenger-eligible **60 ms** after close
  instead of **60 seconds**. A client using the server default cannot
  reconnect after a real disconnect; DH2C fails with a durable-handle
  lookup miss.
- **Version info in message:** none. Introducer is in this tree (see
  Phase 3).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit units/correctness fix (1000×),
not cleanup.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/smb/server/smb2pdu.c` — **+8 / −1**
- Function: `smb2_open()`
- Classification: **single-file surgical fix**
- Functional change: one assignment `60` → `60000`
- Extra: comment before `reconnected_fp:` about `conn->is_aapl` on
  reconnect (documentation only)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (this tree, `smb2_open()` around 3651–3663):

**Before:** `DURABLE_REQ_V2` + `dh_info.timeout == 0` →
`fp->durable_timeout = 60`.

**After:** same path → `fp->durable_timeout = 60000`.

Nonzero Timeout is unchanged (`min_t(..., DURABLE_HANDLE_MAX_TIMEOUT)`).
Path is the **normal CREATE** path when the client requests a v2 durable
handle with Timeout=0, not an error path.

On close/disconnect, `vfs_cache.c` does:

```1276:1278:fs/smb/server/vfs_cache.c
        if (fp->durable_timeout)
                fp->durable_scavenger_timeout =
                        jiffies_to_msecs(jiffies) + fp->durable_timeout;
```

The scavenger then expires the handle when `jiffies_to_msecs(jiffies)`
passes that deadline.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Logic / units / correctness]** Default timeout stored as 60
**seconds-as-if-ms**. Spec Timeout is milliseconds; 0 means server
default. Result: reconnect window is 60 ms instead of 60 s.

Also advertised to the client: `create_durable_v2_rsp_buf()` sends
`buf->Timeout = cpu_to_le32(fp->durable_timeout)`, so the client is told
the window is 60 ms.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: same constant the author intended, in the
units the rest of the code already uses. Samba uses 60×1000 ms when
Timeout=0; Windows DurableOpenTimeout is 60 s. Risk is low: handles may
linger 60 s instead of 60 ms after disconnect, which is the designed
behavior. Cap remains 300000 ms. Comment is unrelated but harmless;
`conn->is_aapl` and `reconnected_fp` exist in this tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: `fp->durable_timeout = 60` introduced in **`c8efcc786146a`**
(“ksmbd: add support for durable handles v1/v2”, Namjae Jeon,
2024-03-12). First appeared in **v6.9-rc1**. Present here. Nearby
`min_t` cap from **`289ebd9afeb94`** (build warning fix), also in this
tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introducer is `c8efcc786146a`, confirmed ancestor
of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `smb2pdu.c` work is other ksmbd fixes (normalized names,
compound errors, leases). No competing timeout-unit fix. Standalone vs
series: submitted as **patch 3/8** of “follow-up fixes”; cover letter
says patch 3 is **unrelated** to the rest (a separate 1000× units bug).
Other patches are stream delete, mdssvc logs, FSCTL bounds, xattr size,
DOS attrib init, stream unlink/fallocate.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Gael Blivet has **no** commits in this tree under
`fs/smb/server/`. Maintainer **Namjae Jeon** acked and applied this
patch (except 2/8 and 5/8, which are different patches). Steve French
signed off.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None for the assignment change. Durable-handle v2, scavenger,
and `DURABLE_HANDLE_MAX_TIMEOUT` are already here. Comment needs only
`reconnected_fp` / `is_aapl`, both present. **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 337e5ea749817` →
  https://patch.msgid.link/20260709000548.66445-4-g.blivet@me.com
- Series: `[PATCH 0/8] ksmbd: follow-up fixes to previously-merged
  patches` (2026-07-09)
- `b4 dig -a`: **v1 only** (no later revisions of this patch)
- Lore HTTP fetch returned 403; full thread retrieved with `b4 mbox` (12
  messages)
- Cover letter: patch 3 found in a durable-handle-v2 reconnect
  investigation; Timeout=0 clients lose the reconnect race
- Namjae on cover: **“Applied them except 0002, 0005 patch to #ksmbd-
  for-next-next.”** Patch 3 applied as submitted. No NAK, no stable
  discussion.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Gaël Blivet-Bailly, **Namjae Jeon**, **linux-
cifs@vger.kernel.org**. Maintainer ack + apply.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Spec: [MS-SMB2] 2.2.13.2.11 Timeout is
**milliseconds**; 0 = server default. Samba sets default **1 minute
(60×1000 ms)** and caps at 300×1000. Windows DurableOpenTimeout is 60 s
(response Timeout sometimes 180 s). Linux CIFS client defaults
`handle_timeout = 0` (“most clients default to 0”).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Other 7 patches are independent bugs. This one does not need
them.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable fetch 403. No stable mention in the
downloaded thread. **UNVERIFIED:** whether anyone already asked for this
on stable@.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `smb2_open()` only.

**Step 5.2: TRACE CALLERS**
Record: `smb2_open` is `SMB2_CREATE` in `fs/smb/server/smb2ops.c`.
Reachable from any SMB3 client CREATE with DH2Q. Durable parsing only if
`KSMBD_GLOBAL_FLAG_DURABLE_HANDLE` is set (ksmbd-tools `durable handles
= yes`; tools default is no).

**Step 5.3: TRACE CALLEES**
Record: Timeout consumed by scavenger (`ksmbd_durable_scavenger`) and
advertised in `create_durable_v2_rsp_buf()`. Parsed from wire via
`le32_to_cpu(durable_v2_blob->Timeout)`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace SMB client → SMB2 CREATE + DH2Q Timeout=0 →
`smb2_open` → later disconnect → scavenger expires in 60 ms → DH2C miss.
CIFS client sends Timeout=0 by default. **Yes, userspace-reachable** for
servers with durable handles enabled.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Only this `= 60` default. V1 durable requests do not set
`durable_timeout` (stays 0; scavenger skips). Separate issue, not this
patch.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `fs/smb/server/smb2pdu.c:3659`: `fp->durable_timeout =
60;`. Introduced v6.9-rc1; this is 6.12.111. `git merge-base --is-
ancestor 337e5ea749817 HEAD` is **false** — fix not present.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Mainline hunk is around line 4186 vs 3659 here (later AAPL/open
growth). Context around the assignment matches. Expected apply: **clean
or trivial offset**. Comment applies; `is_aapl` exists at 3614–3620.
Mainline `app_instance_id` memcpy in the *provided* candidate context is
**not** in this tree; the **actual** upstream diff does not touch that —
only `60`→`60000` plus the comment.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other timeout-units fix. `289ebd9afeb94` only changed `min()`
to `min_t()`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ksmbd** (`fs/smb/server/`). **IMPORTANT** (in-kernel SMB3
server), not mm/VFS core. Affects ksmbd users with durable handles
enabled (Windows/macOS SMB3 reconnect).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active — many recent ksmbd fixes on this 6.12 branch. Durable-
handle code itself has been in tree since 6.9.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Config/feature-specific:** ksmbd with durable handles enabled.
Not all kernel users. Clients that send Timeout=0 (Linux CIFS default,
typical Windows). Clients that send a nonzero Timeout are unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Enable durable handles; CREATE with DH2Q Timeout=0; drop the TCP
connection; reconnect with DH2C. Common for SMB3 durable opens.
Unprivileged SMB clients can trigger it if the share allows them. Not a
timing race of locking — the window is just far too short.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure:** durable reconnect fails (lookup miss); open does
not survive a network blip. **Not** panic, UAF, or silent data
corruption. **Severity: HIGH** for that feature (feature is effectively
broken for the default Timeout=0 case), **MEDIUM–HIGH** overall (opt-in,
but that is exactly who needs reconnect).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** for durable-handle users — reconnect works for the
  common Timeout=0 case.
- **Risk: VERY LOW** — one integer, same units as the rest of the code,
  within the existing 300 s cap. Extra comment is inert.
- **Ratio:** strong yes.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real 1000× units bug; Timeout=0 is the spec/common client default.
- Scavenger and DH2Q response both treat the field as milliseconds.
- Durable reconnect after a real disconnect fails today.
- One-line functional change; obviously correct; maintainer acked and
  applied.
- Buggy code is in this 6.12 tree since v6.9; fix is not.
- Applies with no prerequisites.

**AGAINST:**
- Durable handles are opt-in (tools default off).
- Not a crash/UAF/CVE.
- Extra AAPL comment is unrelated (harmless).
- No Fixes:/Cc: stable (not a negative per rules).

**UNRESOLVED:**
- Direct stable@ lore search (HTTP 403).
- No public user bugzilla for this specific 60 ms window (found by
  reconnect investigation).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — units match spec and
   adjacent code; maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — Timeout=0 durable
   reconnect fails.
3. Important issue? **PASS** — protocol feature that exists to survive
   disconnects is broken in the default-timeout path (not panic, but
   user-visible functional failure).
4. Small and contained? **PASS** — 1 file, 1 assignment (+ comment).
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS**

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc-only). Ordinary
correctness fix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.12. The durable-handle v2 default is stored in the
wrong units, so any client that asks the server to pick a timeout
(including the in-tree CIFS client) gets a 60 ms reconnect window. That
is not a usable durable handle. The fix is a single constant aligned
with Samba (60 s) and with every other millisecond use of the field.
Risk is negligible; the code and introducer are already in this tree.

### What problem this solves for stable users
ksmbd users who enabled durable handles (Windows/macOS/SMB3 reconnect)
currently lose the handle ~60 ms after a drop when the client sent
Timeout=0. The reconnect CREATE then misses. After this change, the
default window is 60 seconds, matching the intended design and the
protocol’s millisecond Timeout field.

### Risk vs benefit
Benefit is restoring the feature those users turned on. Risk is holding
durable state for 60 s instead of 60 ms after disconnect — intended, and
still far below the 300 s cap.

---

Verification:
- [Phase 1] Subject/tags from `git show 337e5ea749817`: fix, Assisted-by
  Claude, Acked-by Namjae Jeon, SOB Steve French; no
  Fixes/Cc:stable/Reported-by
- [Phase 2] Diff: `fp->durable_timeout = 60` → `60000` plus AAPL
  reconnect comment in `smb2_open()`
- [Phase 2] This tree: same assignment at
  `fs/smb/server/smb2pdu.c:3659`; scavenger adds timeout to
  `jiffies_to_msecs(jiffies)` at `vfs_cache.c:1276-1278`; response
  Timeout at `oplock.c:1818`; parse is
  `le32_to_cpu(durable_v2_blob->Timeout)` at `smb2pdu.c:2868-2869`;
  `DURABLE_HANDLE_MAX_TIMEOUT` is 300000
- [Phase 3] `git blame`: line from `c8efcc786146a` (v6.9-rc1); `git
  merge-base --is-ancestor c8efcc786146a HEAD` true; `289ebd9afeb94`
  also in tree
- [Phase 3] `git merge-base --is-ancestor 337e5ea749817 HEAD` false;
  object exists in repo
- [Phase 3] `git log -S 'durable_timeout = 60' --
  fs/smb/server/smb2pdu.c` → only introducer
- [Phase 4] `b4 dig -c 337e5ea749817`:
  patch.msgid.link/20260709000548.66445-4-g.blivet@me.com, PATCH 3/8
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: Namjae + linux-cifs
- [Phase 4] `b4 mbox`: cover letter calls patch 3 standalone units bug;
  Namjae applied all but 2/8 and 5/8
- [Phase 4] MS-SMB2 Timeout is milliseconds, 0 = server default
  (WebFetch)
- [Phase 4] Samba default 60×1000 ms; Windows DurableOpenTimeout 60 s
- [Phase 4] lore.kernel.org HTTP 403; used b4 mbox instead
- [Phase 5] `smb2_open` is SMB2_CREATE handler; gated on
  `KSMBD_GLOBAL_FLAG_DURABLE_HANDLE`
- [Phase 5] CIFS client `ctx->handle_timeout = 0` (`fs_context.c:1839`);
  DH2Q Timeout from that (`smb2pdu.c:2461`)
- [Phase 6] `git describe HEAD` / `make kernelversion`: p-6.12-3 /
  6.12.111; Makefile VERSION=6 PATCHLEVEL=12 SUBLEVEL=111
- [Phase 8] Failure: DH2C lookup miss after disconnect; not a panic
- UNVERIFIED: stable@ mailing list archive via HTTP; no public user
  bugzilla for this 60 ms window

**YES**

 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 22c49921b1c07..ccefd325e52e3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3681,10 +3681,17 @@ int smb2_open(struct ksmbd_work *work)
 					min_t(unsigned int, dh_info.timeout,
 					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.53.0

