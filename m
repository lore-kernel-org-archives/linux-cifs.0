Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D73D6CBA;
	Mon, 11 May 2026 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537977; cv=none; b=bp3xYlffbUgj4YmeBR/gWD/H8TEO0ONbp4DuP004QSPtHecP4x05NBl/qYoMZ9XYLpJjSZ9NxtRmZxwlW3J899+YSIPpgnfdKpzGEA5FfBSXQpZJ5lM4LXJ7vLXBAg3xUaWmg/zW9BocDRXnw/NoMwHD4+PpIBnA6O2ecEMnt5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537977; c=relaxed/simple;
	bh=y7cNncbCu1vNSCV4AZgZcWG7u3cQ333RocDy4eM+aHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5soYdCirc7405MJYYdcOixbBnj5RH69EzstR16HRJbxK1zShp567DMVYLXIfdQOo6TBhPOdKqNrEdga/KF4G2fEq9tk8MHZ62ykRGmH0NU3f0gfvlZOq95hldbWmO9lVhRiXsyQEndk4Mqqrjlctz7uiNQW+ydV2Vhwk0YMDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYEMNb00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYEMNb00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1879C2BCF5;
	Mon, 11 May 2026 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537977;
	bh=y7cNncbCu1vNSCV4AZgZcWG7u3cQ333RocDy4eM+aHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYEMNb00KLs5NTn3j/IO3AAWDrA8uj6Moo3tr+zMNvpe9adF9ohWP3GdS7fr8KCHQ
	 +Q/Q+PMg3Gua1B+QZfQK1mVg1glW4ZSIirbcLdGQBYoIgUx/9iIav2GgNfKCQQlNO+
	 NF4o8wvATZp7MWpzjVlP5mM/2tbkuysljJFywYoiOyliCnRoXg+K/nfZFh1rc9M4o2
	 MSJKvy/z0lyERVbwYdTNzjUYFvhkRTQIb2nb3MCBHPzDPCMUxgvztfjERH/1TKIyQC
	 btBWa9xmdGXSzeWFYirZSstY6e39TNbViYDNvdhJwhlx42P6NelY4D7q4/MSDcQmt8
	 VnKtf/8/G308A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Piyush Sachdeva <s.piyush1024@gmail.com>,
	Piyush Sachdeva <psachdeva@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] smb: client: Zero-pad short GSS session keys per MS-SMB2
Date: Mon, 11 May 2026 18:19:03 -0400
Message-ID: <20260511221931.2370053-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Piyush Sachdeva <s.piyush1024@gmail.com>

[ Upstream commit 8cb6fc3231500233ddaf63cb7fd5435008d9ed5f ]

Per MS-SMB2 section 3.2.5.3, Session.SessionKey is the first 16 bytes
of the GSS cryptographic key, right-padded with zero bytes if the key
is shorter than 16 bytes.

SMB2_auth_kerberos() copies the GSS session key from the cifs.upcall
response using kmemdup(msg->data, msg->sesskey_len, ...) and stores
the GSS-reported length verbatim in ses->auth_key.len. generate_key()
reads SMB2_NTLMV2_SESSKEY_SIZE bytes from this buffer when feeding the
HMAC-SHA256 KDF for signing key derivation. If a GSS mechanism returns
a session key shorter than 16 bytes (e.g. a deprecated single-DES
Kerberos enctype with an 8-byte session key), the KDF call performs an
out-of-bounds slab read and derives keys that do not match the server,
which pads per the spec.

Modern KDCs disable short-key enctypes by default, so this is latent
rather than reachable in production, but it is still a kernel heap
over-read.

Allocate auth_key.response with kzalloc() at a length of
max(msg->sesskey_len, SMB2_NTLMV2_SESSKEY_SIZE), copy the GSS key in,
and rely on kzalloc()'s zero initialization for the spec-mandated
padding. Set ses->auth_key.len to the padded length. Larger GSS keys
(e.g. the 32-byte aes256-cts-hmac-sha1-96 session key) continue to be
stored at their natural length, preserving the FullSessionKey path.

Emit a cifs_dbg(VFS, ...) message when a short key is encountered to
surface deprecated-enctype usage.

NTLMv2 and NTLMSSP code paths produce a 16-byte session key by
construction and are unaffected.

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record 1.1: subsystem `smb: client`; action verb `Zero-pad`; intent is
to make short GSS session keys comply with MS-SMB2 and avoid short-
buffer use in SMB2 key derivation.

Record 1.2: tags present are:
- `Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>`
- `Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>`
- `Signed-off-by: Steve French <stfrench@microsoft.com>`

No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Link:`, or `Cc: stable@vger.kernel.org` tag was present in the supplied
commit message.

Record 1.3: the commit describes a real memory-safety bug:
`SMB2_auth_kerberos()` allocates exactly `msg->sesskey_len` bytes, but
SMB2 key derivation later consumes `SMB2_NTLMV2_SESSKEY_SIZE` bytes,
which is `16`. If `msg->sesskey_len < 16`, the kernel reads past the
allocated buffer and also derives a non-spec-compliant key. MS-SMB2 says
`Session.SessionKey` is the first 16 bytes of the cryptographic key,
right-padded with zeros if shorter.

Record 1.4: this is not just cleanup. It is a hidden memory-safety and
protocol-correctness fix: short allocation plus fixed 16-byte HMAC key
input creates an out-of-bounds read.

### Phase 2: Diff Analysis
Record 2.1: one file changed: `fs/smb/client/smb2pdu.c`, one hunk in
`SMB2_auth_kerberos()`, roughly 18 insertions and 5 deletions from the
supplied diff. Scope is a single-file surgical fix.

Record 2.2: before, `ses->auth_key.response = kmemdup(msg->data,
msg->sesskey_len, GFP_KERNEL)` and `ses->auth_key.len =
msg->sesskey_len`. After, the code sets `ses->auth_key.len =
max(msg->sesskey_len, 16)`, allocates a zeroed buffer of that size,
copies only the original GSS key, and leaves zero padding if the key was
short.

Record 2.3: bug category is memory safety / out-of-bounds read plus
protocol correctness. The verified consumer is `generate_key()` in
`fs/smb/client/smb2transport.c`, which calls
`hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
SMB2_NTLMV2_SESSKEY_SIZE)`. The HMAC helper copies `raw_key_len` bytes
from the pointer, so a shorter allocation is a real over-read.

Record 2.4: fix quality is good: it preserves larger keys, fixes only
Kerberos/GSS key storage, does not change the security blob pointer, and
uses zeroed allocation to implement the spec padding. Regression risk is
low; the only behavior change for short keys is from invalid over-
read/wrong key material to zero-padded spec behavior. It adds one VFS
debug message for short keys.

### Phase 3: Git History Investigation
Record 3.1: `git blame` on current `fs/smb/client/smb2pdu.c` shows the
current `kmemdup(msg->data, msg->sesskey_len)` lines came from
`d9d1e319b39e` (`smb: client: fix broken multichannel with
krb5+signing`), first contained in local tags starting at `v7.0`. The
fixed-size 16-byte HMAC use in current `generate_key()` came from
`4b4c6fdb25de`, first contained in local tags starting at `v6.18`.

Record 3.2: no `Fixes:` tag is present, so there was no tagged
introducing commit to follow.

Record 3.3: recent local history for `smb2pdu.c` includes related
Kerberos/multichannel work (`d9d1e319b39e`). Recent `smb2transport.c`
history includes crypto-library conversion commits. The candidate itself
is standalone for current `v7.0.y` context.

Record 3.4: local `git log master --author='Piyush Sachdeva' -10 --
fs/smb/client fs/cifs` found no matching prior local commits. `Steve
French` is listed in `MAINTAINERS` as maintainer for `COMMON INTERNET
FILE SYSTEM CLIENT (CIFS and SMB3)`, and he signed off this patch.

Record 3.5: no functional dependency was found for the current `v7.0.y`
file: `git apply --check` of the supplied patch against this checkout
succeeded. Older stable trees need path/context adjustments because
older releases use `fs/cifs/` and some have the allocation inside an `if
(!is_binding)` / `if (!ses->binding)` block.

### Phase 4: Mailing List and External Research
Record 4.1: no candidate commit hash was available locally. `git log
master`, `pending-7.0`, and `for-greg/7.0-200` with the exact subject
found no commit. `b4 dig -c '<subject>'`, `b4 dig -a`, and `b4 dig -w`
failed because `b4 dig` needs a commitish.

Record 4.2: reviewer/recipient data could not be obtained from `b4 dig`
for this candidate. The only maintainer signal verified is Steve
French’s signoff and MAINTAINERS entry.

Record 4.3: no `Link:` or `Reported-by:` tags exist. Lore web queries
were blocked by Anubis, so no bug-report thread was verified.

Record 4.4: no series context was verified. No local subject match was
found in searched branches.

Record 4.5: stable-list search via lore was blocked by Anubis; no
stable-specific discussion was verified.

### Phase 5: Code Semantic Analysis
Record 5.1: modified function: `SMB2_auth_kerberos()`.

Record 5.2: caller path verified locally: `connect.c` calls
`server->ops->sess_setup()`, SMB2/SMB3 ops point that to
`SMB2_sess_setup()`, `SMB2_select_sec()` selects `SMB2_auth_kerberos()`
for Kerberos, and `SMB2_sess_setup()` runs the selected auth function.

Record 5.3: key callees are `cifs_get_spnego_key()`,
`SMB2_sess_sendreceive()`, and `SMB2_sess_establish_session()`.
`SMB2_sess_establish_session()` calls
`server->ops->generate_signingkey()`, which reaches
`generate_smb3signingkey()` and then `generate_key()` for SMB3 dialects.

Record 5.4: reachability is from a user-requested CIFS/SMB mount using
Kerberos, with `CONFIG_CIFS_UPCALL` enabled. `Kconfig` says
`CIFS_UPCALL` enables Kerberos/SPNEGO advanced session setup and is used
for Kerberos tickets needed to mount secure servers.

Record 5.5: similar short allocation plus 16-byte consumer patterns
exist across stable tags. I verified the same `kmemdup(msg->data,
msg->sesskey_len)` and 16-byte key use in `v5.4`, `v5.10`, `v5.15`,
`v6.1`, `v6.6`, `v6.12`, `v6.18`, `v6.19`, and `v7.0`, with path changes
from `fs/cifs/` to `fs/smb/client/`.

### Phase 6: Cross-Referencing and Stable Tree Analysis
Record 6.1: buggy code exists in multiple stable-era tags. `v5.4`
through `v6.1` use `fs/cifs/`; `v6.6+` uses `fs/smb/client/`. The
relevant allocation and 16-byte key consumption pattern is present in
those checked tags.

Record 6.2: expected backport difficulty is clean for current `v7.0.y`
because `git apply --check` succeeded. Older stable trees need minor
backporting for path and context differences; pre-`d9d1e319b39e` trees
should preserve their existing binding conditional unless that
multichannel Kerberos fix is also backported.

Record 6.3: local searches for the exact subject, `short GSS session
key`, and related `MS-SMB2` terms did not find an existing local fix.

### Phase 7: Subsystem and Maintainer Context
Record 7.1: subsystem is CIFS/SMB3 client filesystem/network filesystem
code. Criticality is important: it affects users mounting SMB shares
with Kerberos/SPNEGO.

Record 7.2: subsystem is active; recent `master` history under
`fs/smb/client` includes multiple SMB client fixes and refactors. The
maintained subsystem is marked `Supported` in `MAINTAINERS`.

### Phase 8: Impact and Risk Assessment
Record 8.1: affected population is config- and workload-specific:
CIFS/SMB2+ Kerberos users with `CONFIG_CIFS_UPCALL`, especially where
the GSS session key returned to the kernel is shorter than 16 bytes.

Record 8.2: trigger condition is a Kerberos/SPNEGO session setup where
`msg->sesskey_len < SMB2_NTLMV2_SESSKEY_SIZE`. The mount path is user
reachable, but whether unprivileged users can trigger it depends on
mount permissions and local configuration, which I did not verify.

Record 8.3: failure mode is a kernel heap out-of-bounds read during HMAC
key setup and incorrect SMB key derivation. Severity is high for memory
safety, though likely low-frequency because it requires a short GSS
session key.

Record 8.4: benefit is high for affected users because it removes a
kernel heap over-read and implements the protocol-required padding. Risk
is low because the patch is small, local, and preserves behavior for
keys of length 16 or greater.

### Phase 9: Final Synthesis
Record 9.1: evidence for backporting:
- Verified short allocation in `SMB2_auth_kerberos()`.
- Verified fixed 16-byte read in `generate_key()`.
- Verified HMAC helper copies the specified key length.
- Verified MS-SMB2 requires right-zero-padding short session keys.
- Verified bug pattern exists across multiple stable-era tags.
- Fix is small, local, and cleanly applies to current `v7.0.y`.

Evidence against / concerns:
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Fixes`, or `Link` tag
  was supplied.
- No lore review discussion could be verified.
- Older stable trees need minor path/context backport adjustments.
- Trigger appears specific to short GSS keys; I did not independently
  verify real-world frequency.

Unresolved:
- No upstream commit hash was available locally, so `b4 dig` could not
  retrieve the original thread.
- Lore web searches were blocked.
- I did not compile-test the patch.

Record 9.2 stable rules:
1. Obviously correct and tested: obviously correct by code inspection;
   external testing not verified.
2. Fixes a real bug: yes, verified out-of-bounds read when `sesskey_len
   < 16`.
3. Important issue: yes, kernel heap over-read and broken key
   derivation.
4. Small and contained: yes, one function in one file.
5. No new feature/API: yes, no new API or userspace interface.
6. Can apply to stable: yes for current `v7.0.y`; minor backport work
   needed for older trees.

Record 9.3: no automatic exception category applies. This is not a
device ID, quirk, DT, build, or documentation-only change.

Record 9.4: decision is to backport. The memory-safety fix is small and
technically well justified; the limited trigger scope reduces urgency
but not suitability.

## Verification
- [Phase 1] Parsed the supplied subject and tags; no `Fixes`, `Reported-
  by`, `Tested-by`, `Reviewed-by`, `Link`, or stable Cc was present.
- [Phase 2] Read `SMB2_auth_kerberos()` in `fs/smb/client/smb2pdu.c`;
  verified current exact-size `kmemdup()` allocation and
  `ses->auth_key.len = msg->sesskey_len`.
- [Phase 2] Read `generate_key()` in `fs/smb/client/smb2transport.c`;
  verified it passes `SMB2_NTLMV2_SESSKEY_SIZE` bytes from
  `ses->auth_key.response`.
- [Phase 2] Read `lib/crypto/sha256.c`; verified HMAC raw-key setup
  copies `raw_key_len` bytes from the supplied pointer.
- [Phase 2] Verified `SMB2_NTLMV2_SESSKEY_SIZE` is `16` in
  `fs/smb/common/smb2pdu.h`.
- [Phase 3] `git blame` identified local current-line history for the
  allocation and HMAC key setup.
- [Phase 3] `git show` inspected `d9d1e319b39e` and `4b4c6fdb25de`.
- [Phase 3] `git tag --contains` showed `d9d1e319b39e` starts at local
  `v7.0` tags and `4b4c6fdb25de` at local `v6.18` tags.
- [Phase 4] `b4 dig` attempts by subject failed because no local
  commitish exists; lore WebFetch searches were blocked by Anubis.
- [Phase 5] `rg` and `ReadFile` traced `connect.c -> SMB2_sess_setup()
  -> SMB2_auth_kerberos() -> SMB2_sess_establish_session() ->
  generate_key()`.
- [Phase 6] Checked `v5.4`, `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`,
  `v6.18`, `v6.19`, and `v7.0` for the allocation and 16-byte consumer
  pattern.
- [Phase 6] `git apply --check` confirmed the supplied patch applies
  cleanly to current `v7.0.y`.
- [Phase 7] Verified CIFS/SMB3 client maintainership and supported
  status in `MAINTAINERS`.
- [Phase 8] Verified `CONFIG_CIFS_UPCALL` Kconfig text describes
  Kerberos/SPNEGO upcall support for secure SMB mounts.
- UNVERIFIED: original mailing-list review, patch revisions, explicit
  stable discussion, compile-test results, and real-world frequency of
  short GSS session keys.

**YES**

 fs/smb/client/smb2pdu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5188218c25be4..0792e0c38b44f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1714,17 +1714,30 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	is_binding = (ses->ses_status == SES_GOOD);
 	spin_unlock(&ses->ses_lock);
 
+	/*
+	 * Per MS-SMB2 3.2.5.3, Session.SessionKey is the first 16 bytes of the
+	 * GSS cryptographic key, right-padded with zero bytes if shorter.
+	 * Allocate at least SMB2_NTLMV2_SESSKEY_SIZE bytes (zeroed) so the KDF
+	 * input buffer is always valid for HMAC-SHA256 even with deprecated
+	 * Kerberos enctypes that return a short session key.
+	 */
+	if (unlikely(msg->sesskey_len < SMB2_NTLMV2_SESSKEY_SIZE))
+		cifs_dbg(VFS,
+			 "short GSS session key (%u bytes); zero-padding per MS-SMB2 3.2.5.3\n",
+			 msg->sesskey_len);
+
 	kfree_sensitive(ses->auth_key.response);
-	ses->auth_key.response = kmemdup(msg->data,
-					 msg->sesskey_len,
-					 GFP_KERNEL);
+	ses->auth_key.len = max_t(unsigned int, msg->sesskey_len,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
+	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
 		cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
-			 __func__, msg->sesskey_len);
+			 __func__, ses->auth_key.len);
+		ses->auth_key.len = 0;
 		rc = -ENOMEM;
 		goto out_put_spnego_key;
 	}
-	ses->auth_key.len = msg->sesskey_len;
+	memcpy(ses->auth_key.response, msg->data, msg->sesskey_len);
 
 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
 	sess_data->iov[1].iov_len = msg->secblob_len;
-- 
2.53.0

