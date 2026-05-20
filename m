Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8A23A381C;
	Wed, 20 May 2026 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276001; cv=none; b=RoDQOwDgqgwBgEQCnrVcTdmZiIrdndwn/KbWeJVozD/FFy/OqXgI378UNqfDy296bp2DclNCzpmAd/wFhxIVvDjJ9tBHFMhRPB2q+WQadeWGHn6XaU97LTMssCu9cCe217kJsRYulu8Qb9ME++q8NxiiZppO6Ak1Yoc2CFCuf3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276001; c=relaxed/simple;
	bh=ml+G5+JCQ5h+voXXANy33pfz69ElvWpDb6Wv7+uPcyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5z5dvWUd4RIzilZNNZsnWQFH1I+KerYcAYMF/Gh8kWpwA6oKWh03SIa3XrLPmhCCo6sKeOIjJvnPXS0wbW/yYO2LQ5eOgDs3YnkP1ngTNGFApCL6iKEQXxKFtICLB767g18i+kV1XFRWAb0KXRXlc6EHW9Vqi2meoYKAOPbB6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMnYUfvp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMnYUfvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB61F000E9;
	Wed, 20 May 2026 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275999;
	bh=nlY92QB3mvBfJmeeOnE6vg9zLpMxhZsUSgGEybZgriI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMnYUfvpv+fZC6pQ5v0rx10ErQYxDUNMbE1pYHD2h0By+EmVCAKAmR2wxECXhJ1So
	 Dpmvvt172DIWhUPiYJW0ZeJEokwWJpQHwCQECN6Xo/F9n6qpJ4hBAbILm0eMmBFhcE
	 qGD+V/PcgXWL7v66P+JfJ4csELVdK3NeiLTlJ0W3MLpZbAvsF5zCgtUnDdrYXe7Zyz
	 vGz78OsifYzHS8zVAWvD/73qGuDR4u7xJlYKV5mYCWITuvYFvR4YiTj2LJGSNSTsyR
	 0b3RZIMAPEwTYfGNq5MhYu886NbRKGBYcFWKtGqix/MlAmYNFNgW+XSscgqvxgyp3T
	 vOYD8YRZG+oMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jeremy Erazo <mendozayt13@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] smb: client: avoid integer overflow in SMB2 READ length check
Date: Wed, 20 May 2026 07:18:42 -0400
Message-ID: <20260520111944.3424570-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Erazo <mendozayt13@gmail.com>

[ Upstream commit 81a874233c305d29e37fdb70b691ff4254294c0b ]

SMB2 READ response validation in cifs_readv_receive() and
handle_read_data() checks data_offset + data_len against the received
buffer length.  Both values are attacker-controlled fields from the
server response and are stored as unsigned int, so the addition can
wrap before the bounds check:

	fs/smb/client/transport.c:1259
		if (!use_rdma_mr && (data_offset + data_len > buflen))

	fs/smb/client/smb2ops.c:4839
		else if (buf_len >= data_offset + data_len)

A malicious SMB server can use this to bypass validation.  In the
non-encrypted receive path the client attempts an oversized socket
read and stalls for the SMB response timeout (180 seconds) before
reconnecting.  In the SMB3 encrypted path, runtime testing shows the
malformed length can reach copy_to_iter() in handle_read_data() with
attacker-controlled size, where usercopy hardening stops the oversized
copy before bytes reach userspace.

Guard both call sites with check_add_overflow(), which is already
used elsewhere in this subsystem (smb2pdu.c).  On overflow, treat the
response as malformed and reject with -EIO.

Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Record: Subsystem is `smb: client`; action verb is `avoid`; claimed
intent is preventing integer overflow in SMB2 READ response length
validation.

Record: Tags present are `Signed-off-by: Jeremy Erazo
<mendozayt13@gmail.com>` and `Signed-off-by: Steve French
<stfrench@microsoft.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Reviewed-by:`, `Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
tags were present.

Record: The body describes attacker-controlled SMB2 READ response fields
`DataOffset` and `DataLength` being added as `unsigned int`, allowing
wraparound before bounds checks. The stated symptoms are a 180-second
client stall/reconnect in the non-encrypted path and an oversized
`copy_to_iter()` attempt in the encrypted path, stopped by usercopy
hardening.

Record: This is a direct bug fix, not hidden cleanup: it changes
overflow-prone bounds checks into checked arithmetic and rejects
malformed responses with `-EIO`.

### Phase 2: Diff Analysis
Record: Files changed: `fs/smb/client/smb2ops.c` and
`fs/smb/client/transport.c`; upstream stat is 12 insertions and 7
deletions. Modified functions are `handle_read_data()` and
`cifs_readv_receive()`. Scope is small and surgical.

Record: In `handle_read_data()`, before the patch `buf_len >=
data_offset + data_len` could pass after unsigned wrap. After the patch,
`check_add_overflow(data_offset, data_len, &end_off)` must be false and
`buf_len >= end_off` must be true before copying from `buf +
data_offset`.

Record: In `cifs_readv_receive()`, before the patch `data_offset +
data_len > buflen` could wrap and fail to reject malformed lengths.
After the patch, overflow or `end_off > buflen` marks the response
malformed and discards the frame.

Record: Bug category is integer overflow leading to bounds-check bypass.
The fix quality is good: it uses the kernel overflow helper already used
in this SMB client area, changes no ABI, and affects only malformed
server responses. Regression risk is low.

### Phase 3: Git History Investigation
Record: Upstream commit found on `origin/master` as
`81a874233c305d29e37fdb70b691ff4254294c0b`, merged by `b0662be9131d8` in
“Pull smb client fixes from Steve French”, explicitly listing “Fix
integer overflow in read”.

Record: `git blame` shows the current `handle_read_data()` vulnerable
expression attributed to `7c00c3a625f8`, but `git grep` confirmed the
same expression exists as far back as `v4.14`, so the bug predates that
current-line attribution. The `cifs_readv_receive()` vulnerable
expression is attributed to `fb157ed226d2`, described by `git describe
--contains` as `v6.0-rc1~75^2~4`.

Record: No `Fixes:` tag exists, so Step 3.2 is not applicable.

Record: Recent file history contains other SMB client fixes, including
OOB and data-corruption fixes, but no prerequisite for this commit was
identified. The commit is standalone.

Record: Jeremy Erazo had no prior SMB client commits in the checked
history. Steve French has many SMB/CIFS commits and is the SMB client
maintainer who committed this patch.

### Phase 4: Mailing List And External Research
Record: `b4 dig -c 81a874233c305d29e37fdb70b691ff4254294c0b` found the
original submission at `https://patch.msgid.link/20260514120334.2925013-
1-mendozayt13@gmail.com`.

Record: `b4 dig -a` found only v1 of the patch; no later revisions were
found.

Record: `b4 dig -w` showed Jeremy Erazo, Steve French, `linux-
cifs@vger.kernel.org`, `samba-technical@lists.samba.org`, and `linux-
kernel@vger.kernel.org` were included.

Record: Saved mbox contained the patch only; no review replies, NAKs,
stable nominations, or objections were present in that matched thread.
WebFetch to lore search pages was blocked by Anubis, so stable-list
search via web could not be independently verified.

### Phase 5: Code Semantic Analysis
Record: Modified functions are `handle_read_data()` and
`cifs_readv_receive()`.

Record: Callers: `smb2_async_readv()` passes `cifs_readv_receive` and
`smb3_handle_read_data` to `cifs_call_async()`. `cifs_call_async()`
stores them in the MID entry. The receive loop in `connect.c` invokes
`mids[0]->receive()` for non-encrypted async reads, while encrypted
large reads call `receive_encrypted_read()` and then
`handle_read_data()`.

Record: User reachability is verified through normal file reads:
`cifs_issue_read()` calls the dialect `async_readv()` operation, and
SMB2/SMB3 operation tables use `smb2_async_readv()`.

Record: Key callees are `server->ops->read_data_offset()`,
`server->ops->read_data_length()`, `cifs_read_iter_from_socket()`,
`cifs_readv_discard()`, and `copy_to_iter()`. `smb2_read_data_offset()`
reads `DataOffset`; `smb2_read_data_length()` reads `DataLength` or
`DataRemaining`.

Record: Similar pattern search found the same vulnerable `data_offset +
data_len` expressions in active stable tags; `check_add_overflow()` is
already used elsewhere in SMB client files.

### Phase 6: Stable Tree Analysis
Record: The vulnerable `handle_read_data()` expression exists in `v7.0`,
`v6.12`, `v6.6`, `v6.1`, `v5.15`, `v5.10`, `v4.19`, and `v4.14`. The
vulnerable `cifs_readv_receive()` expression exists in `v7.0`, `v6.12`,
`v6.6`, and `v6.1`; it was not found in `v5.15`/`v5.10` by the checked
grep.

Record: The patch applies cleanly to the current `7.0` tree with `git
apply --check`.

Record: Backport difficulty should be low for `v7.0`, `v6.12`, and
`v6.6`; `v6.1` and older need path adjustment from `fs/smb/client` to
`fs/cifs`. Older trees may need per-tree adjustment because
`v5.15`/`v5.10` only showed the `smb2ops.c` instance, and `v4.14` did
not have `check_add_overflow()` in `include/linux`.

### Phase 7: Subsystem Context
Record: Subsystem is SMB/CIFS client filesystem/network filesystem code.
Criticality is important: it affects SMB/CIFS mounts and reads from
remote servers.

Record: The subsystem is active; recent history includes SMB client
fixes for OOB reads, data corruption, replay initialization, races, and
read-path issues.

### Phase 8: Impact And Risk
Record: Affected users are SMB2/SMB3 client users mounting shares from a
malicious or broken server.

Record: Trigger condition is a crafted SMB2 READ response with
`DataOffset + DataLength` wrapping `unsigned int`. This is reachable
from normal file read paths over an SMB mount. Whether an unprivileged
local user can trigger it depends on mount/access policy; a malicious
server can trigger it once the client reads from that share.

Record: Failure mode is high severity: denial of service via read
stall/reconnect in the non-encrypted path, and malformed attacker-
controlled copy length reaching `copy_to_iter()` in the encrypted path.
I verified the call path to `copy_to_iter()` and the 3 * default
60-second unresponsive timeout logic; I did not independently reproduce
the runtime usercopy-hardening behavior.

Record: Benefit is high because this prevents a remotely supplied
malformed SMB response from bypassing validation. Risk is low because
the patch only rejects overflowed or out-of-bounds malformed READ
responses and does not alter valid response handling.

### Phase 9: Final Synthesis
Evidence for backporting: real bounds-check bypass from attacker-
controlled network fields; reachable in normal SMB read paths; high-
impact DoS/memory-safety-adjacent behavior; tiny two-function fix;
committed by the SMB maintainer; merged by Linus as an SMB client fix;
vulnerable code exists in multiple stable trees.

Evidence against backporting: no `Fixes:`/`Cc: stable`/review tags;
older stable trees need path/context adjustments, and very old trees may
lack `check_add_overflow()`.

Unresolved: I could not verify stable-list discussion because lore
WebFetch search was blocked, and I did not reproduce the runtime
hardening behavior. These do not change the decision because the integer
overflow and reachable bounds-check bypass are verified from code.

Stable rules checklist: obviously correct and tested enough by
review/merge evidence, yes; fixes a real bug, yes; important issue, yes;
small and contained, yes; no new feature/API, yes; applies cleanly to
7.0 and should be straightforward elsewhere with noted adjustments,
yes/minor backport work.

Verification:
- [Phase 1] Parsed upstream commit
  `81a874233c305d29e37fdb70b691ff4254294c0b`; found only Jeremy/Steve
  `Signed-off-by` tags.
- [Phase 2] `git show --stat` confirmed 2 files, 12 insertions, 7
  deletions.
- [Phase 3] `git blame` and `git describe --contains` checked history
  for both changed sites.
- [Phase 4] `b4 dig`, `b4 dig -a`, `b4 dig -w`, and saved mbox verified
  lore URL, v1-only series, recipients, and lack of replies.
- [Phase 5] `rg` and source reads verified read call path from
  `cifs_issue_read()` to `smb2_async_readv()` to receive handlers.
- [Phase 6] `git grep` checked vulnerable expressions in `v7.0`,
  `v6.12`, `v6.6`, `v6.1`, `v5.15`, `v5.10`, `v4.19`, and `v4.14`; `git
  apply --check` confirmed clean 7.0 application.
- [Phase 8] Source reads verified socket-read loop, reconnect timeout
  basis, and `copy_to_iter()` path.
- UNVERIFIED: independent runtime reproduction of the oversized
  copy/usercopy-hardening stop.
- UNVERIFIED: stable mailing-list search beyond `b4` mbox, because lore
  WebFetch search pages were blocked.

This should be backported to stable trees.

**YES**

 fs/smb/client/smb2ops.c   |  4 +++-
 fs/smb/client/transport.c | 15 +++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ccc06c83956b5..d443cc8097df6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4721,6 +4721,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 {
 	unsigned int data_offset;
 	unsigned int data_len;
+	unsigned int end_off;
 	unsigned int cur_off;
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
@@ -4836,7 +4837,8 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		}
 		rdata->got_bytes = buffer_len;
 
-	} else if (buf_len >= data_offset + data_len) {
+	} else if (!check_add_overflow(data_offset, data_len, &end_off) &&
+		   buf_len >= end_off) {
 		/* read response payload is in buf */
 		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
 		copied = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 05f8099047e1a..fdf4e50c27ceb 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1158,7 +1158,7 @@ int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
-	unsigned int data_offset, data_len;
+	unsigned int data_offset, data_len, end_off;
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	char *buf = server->smallbuf;
 	unsigned int buflen = server->pdu_size;
@@ -1256,11 +1256,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	use_rdma_mr = rdata->mr;
 #endif
 	data_len = server->ops->read_data_length(buf, use_rdma_mr);
-	if (!use_rdma_mr && (data_offset + data_len > buflen)) {
-		/* data_len is corrupt -- discard frame */
-		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
-					 data_offset + data_len, buflen);
-		return cifs_readv_discard(server, mid);
+	if (!use_rdma_mr) {
+		if (check_add_overflow(data_offset, data_len, &end_off) ||
+		    end_off > buflen) {
+			/* data_len is corrupt -- discard frame */
+			rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
+						 end_off, buflen);
+			return cifs_readv_discard(server, mid);
+		}
 	}
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-- 
2.53.0

