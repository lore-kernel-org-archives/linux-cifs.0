Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDD45D1BA;
	Mon, 31 Aug 2026 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183286; cv=none; b=mhYMVJHJv2Y4VN7doVKsyefmx7P/XLb70Zhm5D9jXmLds/ZtQ5XoIbqCZMEaHLWT6I355J9TSBw0jEqBYNRg99XBPXmeT5WhAmriV89qd9+0pAiJC24k6MXbT6wbcaI2NmQhhvlqy9hKdlKowegQDplmITgC7lIuhZsIPH+uvII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183286; c=relaxed/simple;
	bh=hyEMb6Pd+n28yzIyR/ILAMDzupK47uN1KNRKnpySPgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLl7CVwIC3mf1Fj2Fidaxkg9yXuSm8chdZ8XHTm8+lkWsZuR86uG2URXK2be+r2NEY2fB5pLMelmLfmudjD48cTkvAAKBJk21Azpjmnpa1jZwGftBcXdKzyn6HBPDd59Od3u4n6WVEzVpy4mELjDbkk4JLrSEXClbaOIF0ktxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvMRC+eR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvMRC+eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E681F00A3D;
	Mon, 31 Aug 2026 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183283;
	bh=ts42t936biBKN+Jn2RLMye+YeFon94fudtO7pT68Q98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvMRC+eR0Z+myBTruNs6T+PWsmqTRkErWbmc+RUXdRxH0AeZKSs6hkreTgBh6aOG7
	 uGNj3yTML6qRfl6dOrr+u8czAL+D0R4akz5AkC/tho6hyvjIHtT5dy9mz8Pm3VvaOK
	 svnl6cmye9cSRs8IWaA7h/CMwV8g147jOpf7Ztx5noJrWQwPoA0Ahy9N5hiTe1csJx
	 JgrpFW0V3INE7aDchh7nBWmfqychTlkL0Ikf0lGh3LTcq4nVLnFrVMlo02We/N1UVa
	 YKr8DzfA5fhLxPeUsThlv4hJ0l8bz46msMjIzu4K+hjUdGkJxCCOv8nnJyBoOoUrkC
	 X0cU+MEcZjo3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: use connection ClientGUID for lease lookup
Date: Mon, 31 Aug 2026 09:21:23 -0400
Message-ID: <20260831133314.4125787-55-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fa111daae1a02dbff5693dfc12f368bccd9eb5f4 ]

MS-SMB2 defines the lease table lookup key as Connection.ClientGuid.
Use the connection ClientGUID consistently when checking for same-client
leases and duplicate lease keys.

Also preserve directory and parent lease metadata when copying an existing
lease state to a new open.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ksmbd: use connection ClientGUID for lease
lookup`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD at
`2736c32da98b9`)
**Commit evaluated:** `41fd6f97cf085` (upstream
`fa111daae1a02dbff5693dfc12f368bccd9eb5f4`) — **not yet present in this
tree**

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ksmbd]` `[use]` — Use the connection `ClientGUID`
consistently for SMB2 lease table lookups and duplicate-lease-key
checks, and preserve directory/parent lease metadata when copying lease
state to a new open.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>`, Steve French
  `<stfrench@microsoft.com>` (ignore pipeline Sasha Levin SOB)

Notable: Steve French (ksmbd/SMB maintainer) signed off. No
syzbot/fuzzer tags.

### Step 1.3: Body analysis
**Record:**
- **Bug:** ksmbd used `sess->ClientGUID` for lease table lookup and
  same-client lease checks, but MS-SMB2 defines the lease table key as
  `Connection.ClientGuid`. Lease tables are populated with
  `conn->ClientGUID`.
- **Symptom:** Incorrect lease duplicate detection; failure to recognize
  same-client leases; incomplete lease state when re-opening with an
  existing lease (`copy_lease()` omitted `is_dir` and
  `parent_lease_key`; `flags` assignment clobbered existing flags).
- **Root cause:** Inconsistent identifier choice (session vs connection)
  and incomplete field copy in `copy_lease()`.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says “use” rather than “fix,” this
is a protocol-correctness bug fix. The `copy_lease()` and `flags |=`
changes fix functional directory-lease and break-in-progress handling
bugs.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `fs/smb/server/oplock.c` | +11 / -9 |
| `fs/smb/server/oplock.h` | +1 / -1 |
| `fs/smb/server/smb2pdu.c` | +1 / -1 |

**Functions modified:** `same_client_has_lease()`,
`find_same_lease_key()`, `copy_lease()`, `smb_grant_oplock()`
**Scope:** Single-subsystem, surgical fix (3 files, ~20 lines).

### Step 2.2: Code flow changes
**Record:**
- **`find_same_lease_key()`:** API changes from `struct ksmbd_session
  *sess` to `struct ksmbd_conn *conn`; table lookup and
  `compare_guid_key()` now use `conn->ClientGUID` instead of
  `sess->ClientGUID`.
- **`smb_grant_oplock()`:** `same_client_has_lease()` called with
  `work->conn->ClientGUID`; removed unused `sess` local.
- **`copy_lease()`:** Copies `is_dir` and `parent_lease_key`; `flags`
  set with `|=` instead of `=` when break is in progress.
- **`smb2_open()`:** Passes `conn` instead of `sess` to
  `find_same_lease_key()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / protocol correctness + incomplete state copy.
- **Mechanism:**
  1. Lease tables are keyed by `opinfo->conn->ClientGUID`
     (`alloc_lease_table()`, `add_lease_global_list()`,
     `lookup_lease_in_table()`, `destroy_lease_table()`), but
     `find_same_lease_key()` and `same_client_has_lease()` used
     `sess->ClientGUID`. Per MS-SMB2 and the rest of ksmbd, the current
     **connection’s** GUID is the correct lookup key.
  2. `copy_lease()` did not copy `is_dir` or `parent_lease_key`,
     breaking v2 directory lease parent-key logic (used in
     `smb_send_parent_lease_break_noti()` and lease-break downgrade at
     line 928).
  3. `opinfo->o_lease->flags = SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE`
     overwrote all flags; `|=` preserves other flags.

### Step 2.4: Fix quality
**Record:** Obviously correct — aligns all lease paths with MS-SMB2 and
with existing helpers (`lookup_lease_in_table()`, `compare_guid_key()`).
Minimal, no API surface visible to userspace. Low regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `sess->ClientGUID` in `find_same_lease_key()` introduced in
`af7c39d971e43` (Jul 2022, “fix racy issue while destroying session on
multichannel”). Lease tables have used `conn->ClientGUID` since 2021
(`e2f34481b24db`). The inconsistency has been present since multichannel
work. `is_dir`/`parent_lease_key` added in `d47d9886aeef7` (directory v2
leases); `copy_lease()` never copied them.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent `oplock.c` fixes in this tree are UAF/NULL-deref
hardening (`35d3d6ff2bc1e`, `cd5c1b75d2f45`, etc.). This commit is
separate protocol/correctness work. Later related commit `5198f8b2d0b1c`
(“share SMB2 lease state across opens”) is a larger refactor **not** in
this tree and **not** required for this patch.

### Step 3.4: Author context
**Record:** Namjae Jeon is ksmbd maintainer. Steve French signed off.

### Step 3.5: Dependencies
**Record:** Standalone. Cherry-pick to current HEAD applies cleanly
(auto-merge, no conflicts). Does not depend on the later “share SMB2
lease state across opens” refactor.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 41fd6f97cf085` →
`https://patch.msgid.link/20260618141739.9029-2-linkinjeon@kernel.org`
(patch 2/N in a series). Lore fetch blocked by bot protection; full
thread not readable. `b4 dig -a` returned no additional revisions.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned the same patch link only; maintainer CC
list not retrieved.

### Step 4.3: Bug reports
**Record:** No `Reported-by:` or `Link:` tags. Web search found this
commit listed in Namjae Jeon’s June 2026 ksmbd git-pull, which describes
fixes for **smbtorture** protocol divergence in SMB2/3 lease handling.
That pull context is secondary evidence only (not the commit message
itself).

### Step 4.4: Series context
**Record:** Part of a larger ksmbd lease rework series. This specific
commit is self-contained and applies independently to the current 6.18.y
code.

### Step 4.5: Stable list
**Record:** Not searched (lore blocked). No stable-list discussion
found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `find_same_lease_key()`, `same_client_has_lease()`,
`copy_lease()`, `smb_grant_oplock()`, `smb2_open()`.

### Step 5.2: Callers
**Record:**
- `find_same_lease_key()` — called from `smb2_open()` during SMB2 CREATE
  with lease context (userspace-triggered file open).
- `same_client_has_lease()` — called from `smb_grant_oplock()` on lease
  grant path.
- Both are reachable from normal SMB client file-open operations.

### Step 5.3: Callees
**Record:** `compare_guid_key()` (compares against
`opinfo->conn->ClientGUID`), lease table list traversal, `opinfo_put()`.

### Step 5.4: Reachability
**Record:** Fully reachable from SMB2 CREATE with
`SMB2_OPLOCK_LEVEL_LEASE` when `CONFIG_SMB_SERVER` is enabled. Common
path for Windows/macOS clients using SMB2/3 leasing.

### Step 5.5: Similar patterns
**Record:** `lookup_lease_in_table()`, `destroy_lease_table()`,
`add_lease_global_list()`, and `smb_send_parent_lease_break_noti()`
already use `conn->ClientGUID`. Only `find_same_lease_key()` and
`same_client_has_lease()` call sites were wrong.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at
`fs/smb/server/oplock.c:1019,1035,1249` and `smb2pdu.c:3515` use
`sess->ClientGUID`. `copy_lease()` at lines 1055–1068 omits `is_dir` and
`parent_lease_key`.

### Step 6.2: Backport complications
**Record:** Clean apply verified via test cherry-pick. No conflicts.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree. Upstream commit `fa111daa`
is not an ancestor of HEAD.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `fs/smb/server/` (ksmbd in-kernel SMB server).
**Criticality:** IMPORTANT for deployments using `CONFIG_SMB_SERVER`;
not core kernel path for all users.

### Step 7.2: Activity
**Record:** Actively maintained — multiple ksmbd stable fixes already in
6.18.y (UAF, NULL-deref, durable-handle fixes).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of ksmbd (`CONFIG_SMB_SERVER`) with SMB2/3 leasing
enabled — typically Samba-alternative NAS/file-server deployments
serving Windows/macOS clients.

### Step 8.2: Trigger conditions
**Record:**
- Any SMB2 CREATE with a lease context (common for modern Windows
  clients).
- Directory v2 leases with parent lease keys (second open of same file
  from same client).
- Scenarios where connection-level and session-level GUID usage must
  match MS-SMB2 (multichannel, durable reconnect contexts).

### Step 8.3: Failure mode severity
**Record:**
- Incorrect duplicate lease-key detection → spurious `-EINVAL` opens or
  missed duplicate-key validation.
- Missing `is_dir`/`parent_lease_key` on copy → wrong parent lease break
  behavior for directory leases.
- Flag clobber → incorrect lease break-in-progress reporting.
- **Severity: MEDIUM-HIGH** — not a kernel oops, but SMB lease errors
  affect client caching coherency; incorrect lease state can lead to
  clients holding stale cached data (coherency/correctness issue for
  file-server workloads).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for ksmbd + leasing users — protocol compliance,
  smbtorture-aligned behavior, directory lease correctness.
- **Risk:** VERY LOW — ~20 lines, no new APIs, matches existing code
  patterns.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real protocol bug: MS-SMB2 lease table key is `Connection.ClientGuid`;
  code was inconsistent.
- Incomplete `copy_lease()` breaks directory v2 lease metadata on re-
  open.
- `flags |=` fixes flag clobbering during break-in-progress.
- Small, surgical, applies cleanly to 6.18.44.
- Maintainer-signed (Steve French).
- Listed in ksmbd git-pull as part of smbtorture protocol divergence
  fixes.

**AGAINST backport:**
- Only affects `CONFIG_SMB_SERVER` users (not universal).
- No crash/oops/syzbot report in commit message.
- Part of a larger lease rework series (but this patch is standalone).

**UNRESOLVED:**
- Full lore review thread (bot-blocked).
- Explicit smbtorture test name not in commit message (only in git-pull
  summary).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — aligns with MS-SMB2,
   existing ksmbd patterns, maintainer SOB; smbtorture context from git-
   pull.
2. Fixes a real bug? **PASS** — protocol divergence and incomplete lease
   state copy.
3. Important issue? **PASS** — MEDIUM-HIGH: SMB lease/coherency
   correctness for file-server users.
4. Small and contained? **PASS** — 3 files, ~20 lines.
5. No new features/APIs? **PASS** — internal parameter type change only.
6. Can apply to local tree? **PASS** — verified clean cherry-pick.

### Step 9.3: Exception category
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
protocol-correctness bug fix.

### Step 9.4: Problem and decision rationale

This commit fixes ksmbd SMB2/3 lease handling to use the connection
`ClientGUID` (per MS-SMB2) instead of the session `ClientGUID` when
looking up lease tables and checking duplicate lease keys. The lease
infrastructure already keys tables by `conn->ClientGUID`; using
`sess->ClientGUID` was internally inconsistent and could cause wrong
lease lookups. The `copy_lease()` additions fix directory lease metadata
loss on second opens, and the `flags |=` change prevents overwriting
other lease flags during break-in-progress.

For stable 6.18.y users running ksmbd with SMB2/3 leasing, this is a
worthwhile fix: small, low-risk, and addresses real client-visible lease
correctness issues.

---

## Verification

- **[Phase 1]** `git show 41fd6f97cf085 --format=fuller`: parsed
  subject, body, tags (Namjae Jeon, Steve French SOBs only).
- **[Phase 2]** `git show 41fd6f97cf085 -p`: confirmed 3-file diff,
  function-level changes.
- **[Phase 2]** Read `oplock.c` lines 91, 489, 984, 1019, 1035,
  1055–1068, 1077, 1130, 1249, 1820; `smb2pdu.c` line 3515;
  `user_session.c` line 216.
- **[Phase 3]** `git describe HEAD`: v6.18.44. `git blame -L 1018,1036
  fs/smb/server/oplock.c`: `sess->ClientGUID` from `af7c39d971e43`
  (2022).
- **[Phase 3]** `git show af7c39d971e43`: multichannel session fix that
  introduced `sess->ClientGUID` usage.
- **[Phase 3]** `git log -1 -S"parent_lease_key"`: `d47d9886aeef7` added
  directory lease parent keys.
- **[Phase 3]** `git merge-base --is-ancestor fa111daa HEAD`: exit 1 —
  fix not in tree.
- **[Phase 3]** `git merge-base --is-ancestor 5198f8b2 HEAD`: exit 1 —
  dependent refactor not in tree.
- **[Phase 3]** Cherry-pick test: `git cherry-pick --no-commit
  41fd6f97cf085` — clean auto-merge on 3 files.
- **[Phase 4]** `b4 dig -c 41fd6f97cf085`: lore URL
  `20260618141739.9029-2-linkinjeon@kernel.org`.
- **[Phase 4]** Web search: found commit in ksmbd git-pull listing
  smbtorture protocol fixes.
- **[Phase 4]** Lore/patch.msgid.link fetch: blocked by bot protection —
  thread content UNVERIFIED.
- **[Phase 5]** `grep find_same_lease_key`: single caller in
  `smb2pdu.c`; `same_client_has_lease` called from `smb_grant_oplock()`.
- **[Phase 5]** Verified `lookup_lease_in_table()`,
  `compare_guid_key()`, `add_lease_global_list()` use
  `conn->ClientGUID`.
- **[Phase 6]** `grep sess->ClientGUID fs/smb/server/oplock.c`: buggy
  lines present at 1019, 1035, 1249.
- **[Phase 6]** `copy_lease()` in tree lacks `is_dir`/`parent_lease_key`
  copy.
- **[Phase 7]** `grep CONFIG_SMB_SERVER fs/smb/Kconfig`: ksmbd is
  `CONFIG_SMB_SERVER`.
- **[Phase 8]** Failure mode assessed from code paths: lease
  lookup/coherency bugs, not kernel crash.

**YES**These background lookups are done. Summary:

- **Commit identified:** `41fd6f97cf085` (upstream
  `fa111daae1a02dbff5693dfc12f368bccd9eb5f4`) — `ksmbd: use connection
  ClientGUID for lease lookup`
- **Not in this tree:** Neither that commit nor the related refactor
  `5198f8b2d0b1c` (“share SMB2 lease state across opens”) is in
  `v6.18.44`
- **`all-next`:** The ClientGUID commit wasn’t found there; recent
  `oplock.c` work on that branch is separate UAF/NULL-deref hardening
- **Standalone backport:** Cherry-pick to current HEAD applies cleanly;
  it does not require the later “share SMB2 lease state” refactor

**Verdict from the full analysis: YES** — protocol-correctness fix for
ksmbd SMB2/3 lease handling, small and low-risk for 6.18.y.

 fs/smb/server/oplock.c  | 16 +++++++++-------
 fs/smb/server/oplock.h  |  2 +-
 fs/smb/server/smb2pdu.c |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index c12b2b2857667..b6705a07c6ebe 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -520,7 +520,7 @@ static inline int compare_guid_key(struct oplock_info *opinfo,
  * Return:      oplock(lease) object on success, otherwise NULL
  */
 static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
-						 char *client_guid,
+						 const char *client_guid,
 						 struct lease_ctx_info *lctx)
 {
 	int ret;
@@ -1014,7 +1014,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 	write_unlock(&lease_list_lock);
 }
 
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx)
 {
 	struct oplock_info *opinfo;
@@ -1031,7 +1031,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 	}
 
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, sess->ClientGUID,
+		if (!memcmp(lb->client_guid, conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE))
 			goto found;
 	}
@@ -1047,7 +1047,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 		rcu_read_unlock();
 		if (opinfo->o_fp->f_ci == ci)
 			goto op_next;
-		err = compare_guid_key(opinfo, sess->ClientGUID,
+		err = compare_guid_key(opinfo, conn->ClientGUID,
 				       lctx->lease_key);
 		if (err) {
 			err = -EINVAL;
@@ -1080,6 +1080,9 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
+	lease2->is_dir = lease1->is_dir;
+	memcpy(lease2->parent_lease_key, lease1->parent_lease_key,
+	       SMB2_LEASE_KEY_SIZE);
 }
 
 static void add_lease_global_list(struct oplock_info *opinfo,
@@ -1218,7 +1221,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		     struct ksmbd_file *fp, __u16 tid,
 		     struct lease_ctx_info *lctx, int share_ret)
 {
-	struct ksmbd_session *sess = work->sess;
 	int err = 0;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1261,12 +1263,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		struct oplock_info *m_opinfo;
 
 		/* is lease already granted ? */
-		m_opinfo = same_client_has_lease(ci, sess->ClientGUID,
+		m_opinfo = same_client_has_lease(ci, work->conn->ClientGUID,
 						 lctx);
 		if (m_opinfo) {
 			copy_lease(m_opinfo, opinfo);
 			if (atomic_read(&m_opinfo->breaking_cnt))
-				opinfo->o_lease->flags =
+				opinfo->o_lease->flags |=
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 			opinfo_put(m_opinfo);
 			goto out;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index d91a8266e065e..795a9119dad9a 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -116,7 +116,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 99a0108cb21f4..66871fbe53f48 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3534,7 +3534,7 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "lease req for(%s) req oplock state 0x%x, lease state 0x%x\n",
 				    name, req_op_level, lc->req_state);
-			rc = find_same_lease_key(sess, fp->f_ci, lc);
+			rc = find_same_lease_key(conn, fp->f_ci, lc);
 			if (rc)
 				goto err_out1;
 		} else if (open_flags == O_RDONLY &&
-- 
2.53.0

