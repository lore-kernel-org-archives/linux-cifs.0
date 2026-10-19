Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA6546443;
	Mon, 19 Oct 2026 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418823; cv=none; b=Mbh0jE7iec2v/soAfjl/zyXwB5h4maBY0jlphYAIELuo18XNhY0lNSyA526ZJmWJBdhWBYReT76dcjO66u/A4US8upBTURJRfj+fTaq6LzI9bV9uHjTB1v7CBCbRwmjZ7UwgE4KiI8HXbxmZE8iZVI4Y1PoLE2/5lGWIkjAzeRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418823; c=relaxed/simple;
	bh=SEXOvpv4tjRY8TmdjmlMaarnyXmkYcb0LWl4CaXOQ2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPiONGYPVCTIQMsk209F07hFMfP89qR8kptw8hpLolZjSlrqouJG/JsYjeomeMKp+bKw1wMRcJ4+PQRZim412twMZ+4I4hWrTfsrqVdTrjcNFwE8+WwvtIEjGSRr2M0Nv2YO/H2BIMwJlKobsgQC6hm138mzGcujnYSxO7hoiJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nR16xfd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nR16xfd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3848D1F000C8;
	Mon, 19 Oct 2026 14:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418810;
	bh=Txqof9Akvi325cjYNjB/ahec7ok75H6zc/VAzTFmsdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nR16xfd7PL6OfpL/nylqaHlqJd9RM1CUt1kt3khds2ngQrBRB3APxsqXAI5vaknAC
	 u38rssmoBIu/o/vbq7wVjL8LN/cueEumJlZcrB3/oSJf+8Bhu6QUM6mK/SaDuO8+O+
	 PVuc06GIKYPOlfpqNp5Rp9mLxTynm6/xeaJHNzWeZhU/EkPhQdwl1Rz53iTcVmorhD
	 OukgXhly3tHlFDtMIhnIDXjm9/Z3Kle+hgQCmRYmLqGko9GGamNjKbjTsASGz4QXlK
	 qpoJiNoKuTqITaJMtKcjX/eAfwsSABfNc5z+QFGWNy3OFaXBN+zzwVRw5jp6VSHLLd
	 3FvT19IaXo5+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: enable TCP keepalive for accepted connections
Date: Mon, 19 Oct 2026 09:53:24 -0400
Message-ID: <20261019135441.1420968-513-sashal@kernel.org>
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

[ Upstream commit 56549c18a4f75309161ca780feaa4d17904e3ee9 ]

A client that disappears without sending a FIN or RST can leave its
ksmbd connection in ESTABLISHED indefinitely. ksmbd sets a socket
receive timeout, but the connection receive loop retries timeout errors
without a limit, so the connection remains in conn_list and consumes the
per-IP connection quota.

Enable SO_KEEPALIVE on accepted TCP sockets so the TCP stack can detect a
silent peer failure. The keepalive idle time, interval, and probe count
remain controlled by the existing TCP sysctl settings.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy
accept/receive path is present, and this is a small, real connection-
leak fix that belongs here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ksmbd]** **[enable]** Enable TCP keepalive on accepted ksmbd
sockets so a silent peer does not leave the connection ESTABLISHED
forever.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (ksmbd
  maintainer)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Reviewed-by:**,
  **Acked-by:**, **Link:**, or **Cc: stable** on this commit (absence
  expected for this review)
- Companion later commit `80b6367ec37f` has `Link:
  https://github.com/openwrt/openwrt/issues/24744` (different bug: FIN-
  WAIT-1 orphans)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Client vanishes without FIN/RST; ksmbd connection stays
  ESTABLISHED.
- **Mechanism:** `sk_rcvtimeo` is set, but the receive loop retries
  timeout/`-EAGAIN` with no limit, so the conn stays in `conn_list` and
  consumes the per-IP quota.
- **Fix:** `sock_set_keepalive()` on the accepted socket;
  idle/interval/probes stay on existing TCP sysctls.
- **Symptom:** leaked kthreads/sockets and eventual refusal of new
  clients from that IP.
- **Version info:** none in the message. Code path has been in-tree
  since the 2023 unlimited-retry change.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is explicitly a leak/stuck-connection fix that
uses an existing socket option. Not a new userspace API.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/smb/server/transport_tcp.c` (**+6 / -0**)
- Function: `ksmbd_kthread_fn()` (accept path)
- Scope: single-file surgical fix (one call + comment)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** After accept, set `sk_rcvtimeo` / `sk_sndtimeo`, then
  `ksmbd_tcp_new_connection()`.
- **After:** Same, plus `sock_set_keepalive(client_sk->sk)` so TCP
  probes a silent peer.
- Path: normal accept of a new SMB TCP connection.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** resource leak / stuck connection (logic/correctness),
  mitigated by a standard TCP keepalive workaround.
- **Broken behavior:** `ksmbd_conn_handler_loop()` reads the RFC1002
  header with `max_retries = -1`. `ksmbd_tcp_readv()` treats negative
  `max_retries` as unlimited `-EAGAIN` retries. `KSMBD_TCP_RECV_TIMEOUT`
  is `7 * HZ`, so a dead peer yields `-EAGAIN` forever.
- `ksmbd_conn_alive()` only drops idle conns when `deadtime > 0` **and**
  `open_files_count == 0`. A crashed client with open files stays alive
  forever.
- **Fix:** `sock_set_keepalive()` → `tcp_set_keepalive()` → keepalive
  timer. Failed probes produce RST/`tcp_write_err()`, `kernel_recvmsg()`
  returns 0/error, handler exits, conn leaves `conn_list`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same helper NFS/RPC and RDS already use
  (`sock_set_keepalive` since 2020).
- Minimal; comment-only extra.
- Regression risk **low**: default keepalive is 2 hours + 9 probes ×
  75s. Healthy SMB clients send traffic/echoes. No new sysctl/API. Does
  not change the unlimited-retry policy for truly idle-but-alive
  sessions.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Timeout assignment: present since original cifsd/ksmbd
  (`0626e6641f6b`, 2021).
- Unlimited retry: **`be6f42fad5f5fd`** “ksmbd: don't terminate inactive
  sessions after a few seconds” (**v6.3-rc4**, 2023-03-22). That commit
  is in this tree and was itself `Cc: stable`. Keepalive was never added
  then.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Conceptual introducer is `be6f42fad5f5fd`,
present here.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `transport_tcp.c` work: per-IP limits, `sock_create_kern`,
  `active_num_conn` leaks.
- Same-day companion: **`80b6367ec37f`** “keep TCP timers alive for
  kernel sockets” (`sk_net_refcnt_upgrade` on the **listen** socket).
  That is a **different** bug (FIN-WAIT-1 orphans after `tcp_close()`
  clears timers on kernel sockets). Not required for keepalive on a
  still-held ESTABLISHED socket.
- Standalone for the ESTABLISHED leak.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namjae Jeon is the ksmbd maintainer; many recent ksmbd fixes in
this tree.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `sock_set_keepalive()` — in this tree (`ce3d9544cecac`, 2020),
  `EXPORT_SYMBOL`.
- `connection.h` already includes `<net/sock.h>`.
- Companion `sk_net_refcnt_upgrade` is **not** a prerequisite for this
  ESTABLISHED-path fix.
- Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Upstream SHA: **`56549c18a4f75309161ca780feaa4d17904e3ee9`**
- Lore:
  https://patch.msgid.link/20260820135420.5634-1-linkinjeon@kernel.org
- Submitted 2026-08-20 as `[PATCH]` (with the timer patch as `-2`);
  merged in ksmbd 7.3-rc1 pull (“Improve TCP connection reliability…”)
- `b4 dig -a`: v1 keepalive + v2 timer companion, same day. No later
  unapplied revision.
- Mbox: author-only; no NAK, no extra review comments (maintainer tree).
- WebFetch of lore URLs returned 403; thread recovered via `b4`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linux-cifs@vger.kernel.org, Sergey Senozhatsky,
Tom Talpey, Atte Heikkilä, ChenXiaoSong. No NAK found.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- Direct Reported-by: none on this commit.
- Real-world match: [cifsd-team/ksmbd#627](https://github.com/cifsd-
  team/ksmbd/issues/627) — Windows 11, stale ESTABLISHED sockets,
  connection limit exhausted (default ~32), only restart helps. Kernel
  6.19.9 in that report; **same receive-loop logic is in 6.12**.
- Related: namjaejeon/ksmbd#517 (ESTABLISHED after client power-off;
  `deadtime = 10` did not help — consistent with open files skipping
  deadtime).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Two-patch reliability pair. Patch 1 = this (keepalive). Patch 2
= listen-socket netns upgrade for post-close timers. This patch is
useful alone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search 403. No evidence this was already
rejected for 6.12. Not in this tree (`git merge-base --is-ancestor
56549c18… HEAD` failed).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: modified `ksmbd_kthread_fn`; callees `sock_set_keepalive` /
`tcp_set_keepalive`; related `ksmbd_tcp_readv`,
`ksmbd_conn_handler_loop`, `ksmbd_conn_alive`.

**Step 5.2: TRACE CALLERS**
Record:
- `ksmbd_kthread_fn` ← `kthread_run` in `ksmbd_tcp_run_kthread` (listen
  on 445).
- Header read: `ksmbd_conn_handler_loop` → `t->ops->read(..., -1)` →
  `ksmbd_tcp_read` → `ksmbd_tcp_readv`.
- Process context, one kthread per connection. Userspace-reachable: any
  SMB client connect.

**Step 5.3: TRACE CALLEES**
Record: `sock_set_keepalive` locks the sock, calls
`sk->sk_prot->keepalive(sk, true)` (`tcp_set_keepalive` for TCP), sets
`SOCK_KEEPOPEN`. `tcp_set_keepalive` arms
`inet_csk_reset_keepalive_timer`. Failed probes: `tcp_send_active_reset`
+ `tcp_write_err`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: SMB connect to 445 → accept → keepalive enabled → handler recv
loop. Unprivileged network clients can leave zombie conns (especially
after crash/VPN drop). **Reachable.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `net/sunrpc/xprtsock.c` and `net/rds/tcp_listen.c` already call
`sock_set_keepalive`. ksmbd was the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- Tree: **pending-6.12 / 6.12.111** (`p-6.12-3-gc504cf0baa3d8`)
- Accept path at `ksmbd_kthread_fn` (~L325–329): timeouts set, **no**
  keepalive.
- Unlimited retry in `ksmbd_tcp_readv` (L409–423) and `max_retries = -1`
  (connection.c L444).
- Introduced v6.3 (`be6f42fad5f5fd`); present for the whole 6.12
  lifetime.
- Keepalive commit is **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Insertion point matches this file exactly
(`sk_sndtimeo` then `ksmbd_tcp_new_connection`). `sock_set_keepalive`
already exported.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No keepalive on ksmbd sockets. `deadtime` is optional userspace
config and skipped when files are open. Not a substitute.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fs/smb/server (ksmbd)**. **IMPORTANT** (in-kernel SMB3 server:
NAS, OpenWrt, appliances). Not core mm/VFS, but production file service.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (connection-limit, sock_create_kern, leak fixes). Mature
enough that this long-standing hole matters.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver/config-specific:** `CONFIG_SMB_SERVER`. Typical stable
users: NAS, routers, embedded SMB.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: client crash, sleep, VPN drop, power-off without FIN/RST.
- Common on laptops/Wi‑Fi/VPN.
- Unprivileged remote clients can fill the per-IP quota
  (`max_ip_connections` is in this tree).
- Timing: default first probe after **2 hours**, then ~11 minutes of
  probes. Slow but **finite**, vs never.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: kthread + socket + `conn_list` entry leak; per-IP/global
  connection quota exhaustion; new mounts fail until ksmbd restart.
- **Severity: HIGH** (service outage / resource leak). Not a panic, but
  a real production hang of the SMB service.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** for ksmbd users (closes zombies, restores quota).
- **Risk: VERY LOW** (6 lines, existing helper, sysctl-controlled,
  conservative defaults).
- Ratio strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real stuck-connection / quota DoS, not style.
- Unlimited `-EAGAIN` retry (`be6f42fad5f5fd`, in this tree, previously
  sent to stable) without keepalive is the hole.
- `deadtime` does not cover open-file + silent peer.
- User reports of ESTABLISHED pile-up (#627).
- 6-line, obviously correct, existing API.
- Applies cleanly to 6.12.111.
- Maintainer-authored; same pattern as sunrpc/RDS.

**AGAINST:**
- Looks like “enable a feature,” but it only turns on SO_KEEPALIVE.
- Default 2-hour idle before probes (slow, still a fix).
- No Fixes:/Cc: stable on this commit (not a negative per review rules).
- Companion timer patch is separate (do not block this on it).

**UNRESOLVED:**
- lore.kernel.org HTTP 403 (thread recovered via b4).
- No on-list Reviewed-by (maintainer submission).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one well-known helper; in
   mainline 7.3.
2. Fixes a real bug that affects users? **PASS** — leaked ESTABLISHED
   conns / quota; #627.
3. Important issue? **PASS** — service DoS / resource leak on a file
   server (HIGH).
4. Small and contained? **PASS** — +6 lines, one function.
5. No new features or APIs? **PASS** — existing SO_KEEPALIVE / sysctls
   only.
6. Can apply to the local tree? **PASS** — code and helper exist; clean
   insert.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/DT/build/docs exception. Fits “hardware/protocol
workaround”: enable kernel TCP keepalive so dead peers are detected.

**Step 9.4: MAKE YOUR DECISION**
This tree has the unlimited recv-timeout retry and no keepalive. The
patch is the missing counterpart to the 2023 stable change that stopped
tearing down idle sessions. Benefit is real for ksmbd; risk is
negligible.

---

### What it solves for stable users
A client that disappears without FIN/RST leaves ksmbd in ESTABLISHED:
the handler retries receive timeouts forever, holding a kthread and a
`conn_list` slot (and the per-IP quota). That matches field reports of
Windows clients filling the connection limit until ksmbd is restarted.
Keepalive lets TCP fail the socket so the handler can tear the conn
down.

### Risk vs benefit
Benefit: prevents unbounded connection growth and SMB accept failures.
Risk: one `sock_set_keepalive()` with default 2-hour keepalive — will
not drop healthy sessions on a short idle.

### Concerns
None that block 6.12. The later `sk_net_refcnt_upgrade` patch is a
separate FIN-WAIT-1 orphan fix, not required for this ESTABLISHED-path
change.

---

### Verification
- **[Phase 1]** Parsed message: enable keepalive; SOB Namjae Jeon; no
  Fixes/Reported-by.
- **[Phase 2]** Diff: +6 in `ksmbd_kthread_fn`;
  `sock_set_keepalive(client_sk->sk)` after timeouts.
- **[Phase 2]** Confirmed `ksmbd_tcp_readv` unlimited retry when
  `max_retries < 0`; handler uses `-1` for header read.
- **[Phase 2]** Confirmed `ksmbd_conn_alive()` returns true if
  `open_files_count > 0`, ignoring deadtime.
- **[Phase 2]** Confirmed `sock_set_keepalive` → `tcp_set_keepalive`
  (`net/core/sock.c`, `net/ipv4/tcp_timer.c`).
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: **p-6.12-3 /
  6.12.111**.
- **[Phase 3]** Blame: unlimited retry from `be6f42fad5f5fd` (v6.3);
  `git merge-base --is-ancestor be6f42fad5f5f HEAD` succeeded.
- **[Phase 3]** `git merge-base --is-ancestor
  56549c18a4f75309161ca780feaa4d17904e3ee9 HEAD` failed (not in this
  tree).
- **[Phase 3]** `sock_set_keepalive` introduced `ce3d9544cecac` (2020);
  present here.
- **[Phase 4]** `b4 dig -c 56549c18…`: lore `20260820135420.5634-1`;
  series with timer patch `-2`.
- **[Phase 4]** `b4 dig -w`: linux-cifs, Senozhatsky, Talpey, et al.
- **[Phase 4]** `b4 dig -a`: v1 keepalive + companion timer patch; no
  later unapplied rev.
- **[Phase 4]** GitHub ksmbd#627: stale ESTABLISHED / quota exhaustion.
- **[Phase 4]** Companion `80b6367ec37f`: listen-socket
  `sk_net_refcnt_upgrade` for post-close timers — different bug.
- **[Phase 5]** Call chain: accept kthread → `ksmbd_tcp_new_connection`
  → `ksmbd_conn_handler_loop` → unlimited `read(..., -1)`.
- **[Phase 5]** Same helper in sunrpc/RDS.
- **[Phase 6]** Local accept path L325–329 has no keepalive; context
  matches the patch.
- **[Phase 6]** `connection.h` includes `<net/sock.h>`.
- **[Phase 8]** Defaults: `TCP_KEEPALIVE_TIME` 2h, `PROBES` 9, `INTVL`
  75s (`include/net/tcp.h`).
- **UNVERIFIED:** HTTP fetch of lore.kernel.org (403); recovered via b4.
  Whether every distro sets `deadtime` (irrelevant: deadtime skipped
  with open files).

**YES**

 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 472d387098767..ede54bb049532 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -312,6 +312,12 @@ static int ksmbd_kthread_fn(void *p)
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
+		/*
+		 * Detect peers that disappear without sending a FIN or RST.
+		 * Otherwise the connection handler can retry receive timeouts
+		 * indefinitely and keep the connection in conn_list.
+		 */
+		sock_set_keepalive(client_sk->sk);
 
 		ksmbd_tcp_new_connection(client_sk);
 	}
-- 
2.53.0

