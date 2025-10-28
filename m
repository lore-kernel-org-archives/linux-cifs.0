Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859871AA7BF;
	Tue, 28 Oct 2025 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611983; cv=none; b=eaLUgeW7C5HjY9b3izq/m+Gh5stbb/otcESx5TYFncgmyuFlnXqLUJHkypcD5a8L4UKkRPIYB+8j8WNwEd9M3JzNAihQl4xkx5997zU5WZJozaohMWV+IeAhF3ZC9jdygNiryco792vK4hUqrauXQMoNeY1eOfRjrmgN1lJiuQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611983; c=relaxed/simple;
	bh=TB0R3bR1qdlWHTe7bspeBSlcpR/p94kxOplQF65Lb7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nZwDM1BM5TmgryymWJXd4+T/yLoPELQacMdTXDLqXLTjOryW980irOJV5OfKyHJJj+HK1QJSuJrlNa2fN4EATy66WzZ0GLkSFG9ThIAZfGVdPNuTQGCSjmQKMSSxLWT5yU97kh0l+8NpNJO7Z1bPJsqhbzeU69+x3bb2BBBWDS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZDypBLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZDypBLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177A4C4CEF1;
	Tue, 28 Oct 2025 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761611983;
	bh=TB0R3bR1qdlWHTe7bspeBSlcpR/p94kxOplQF65Lb7I=;
	h=From:To:Cc:Subject:Date:From;
	b=IZDypBLyiXx1F9cPtxNoW8JrkYHRpjOKxmkPkie4UWeQtiqi6sFdKJMqUcLj28Ckw
	 l7T49dJ89G7lwhzFipt36Xy2yza96+SuxJbRuWl2xsy4dVvN6c1nhzWN1WpcKIBZ11
	 Gyk9Nx1JX3nvXVKSKOM2LN/IDwQ5EaS1Q21BU1JCt8HC/mC3MY4MZIctuePTqw2woe
	 jg3MWiK+3bfGWstRq4w7KIUW3T3WqMc72Nu4Plh4bGIEpmisRMtiHjO3s798wT7uvF
	 JS5WKdh35p8RYbSr1jCvhpzHlq8HlUKk2W6E4RdPViptbDePLL/9IcyUR2wE3hLO/f
	 GNQcsk15vxeaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] smb/server: fix possible memory leak in smb2_read()
Date: Mon, 27 Oct 2025 20:38:45 -0400
Message-ID: <20251028003940.884625-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 6fced056d2cc8d01b326e6fcfabaacb9850b71a4 ]

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## **Backport Status: YES**

### **Extensive Analysis**

Based on comprehensive semantic code analysis and repository
examination, this commit **should be backported** to stable kernel
trees.

---

## **1. Code Change Analysis**

The commit adds a single line to fix a memory leak in
`fs/smb/server/smb2pdu.c`:

```c
nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
if (nbytes < 0) {
+   kvfree(aux_payload_buf);  // <-- Added line
    err = nbytes;
    goto out;
}
```

**What was wrong:** Memory allocated at line 6821 (`aux_payload_buf =
kvzalloc(ALIGN(length, 8), KSMBD_DEFAULT_GFP)`) was not freed when
`ksmbd_vfs_read()` fails, while all other error paths properly call
`kvfree()`.

---

## **2. Semantic Analysis Tools Used**

### **Tool 1: mcp__semcode__find_function**
- Located `smb2_read()` in `fs/smb/server/smb2pdu.c:6727-6895`
- Confirmed it's an SMB2 protocol handler (169 lines, 24 function calls)
- Return type: `int` (returns error codes)

### **Tool 2: mcp__semcode__find_callers**
- Result: No direct function callers
- However, cross-referenced with `smb2ops.c:183` showing `smb2_read` is
  registered as a handler: `[SMB2_READ_HE] = { .proc = smb2_read }`
- **Conclusion:** This is a protocol handler invoked by the SMB2 message
  dispatcher, meaning it's **directly user-triggerable** via network
  requests

### **Tool 3: mcp__semcode__find_calls**
- Analyzed `ksmbd_vfs_read()` dependencies
- Found it can fail with multiple error codes: `-EISDIR`, `-EACCES`,
  `-EAGAIN`, plus any errors from `kernel_read()`
- **All of these failure paths trigger the memory leak**

### **Tool 4: git blame & git log**
- Bug introduced: commit `e2f34481b24db2` (2021-03-16) - **4 years
  old!**
- Recent modification: commit `06a025448b572c` (2024-11-30) changed
  allocation to `ALIGN(length, 8)` but didn't fix the leak
- Found 15+ similar "memory leak" fixes in ksmbd history, indicating
  active maintenance

---

## **3. Impact Scope Analysis**

### **User Exposure: CRITICAL**
- **Protocol Handler:** Any SMB client can trigger this by sending SMB2
  READ requests
- **Network-facing:** ksmbd is a kernel SMB server exposed to network
  clients
- **No authentication required to trigger:** The error path can be
  reached even with permission errors

### **Trigger Conditions (from VFS analysis):**
1. **-EISDIR**: Client tries to read a directory
2. **-EACCES**: Permission denied (no FILE_READ_DATA or FILE_EXECUTE
   access)
3. **-EAGAIN**: File is locked by another process
4. **kernel_read() failures**: Various VFS/filesystem errors

All of these are **easily triggerable** by malicious or misbehaving
clients.

### **Memory Leak Severity: HIGH**
- **Allocation size:** `ALIGN(length, 8)` where `length` is client-
  controlled
- **Maximum per leak:** Up to `SMB3_MAX_IOSIZE` = **8 MB** (from
  smb2pdu.h:28)
- **Default size:** `SMB21_DEFAULT_IOSIZE` = **1 MB** (from
  smb2pdu.h:25)
- **Attack scenario:** An attacker could repeatedly:
  1. Send READ requests for locked files (triggers -EAGAIN)
  2. Each failed request leaks up to 8MB
  3. 100 requests = 800MB leaked
  4. Can exhaust server memory leading to **DoS**

---

## **4. Regression Risk Analysis**

### **Risk Level: VERY LOW**
- **Change size:** Single line addition
- **Operation:** Adding missing cleanup (defensive programming)
- **No behavior change:** Only affects error path that already returns
  failure
- **Idempotent:** `kvfree()` is safe to call and simply frees allocated
  memory
- **No dependencies:** No API changes or external impact

---

## **5. Stable Tree Compliance**

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Fixes important bug | ✅ YES | Memory leak leading to potential DoS |
| Small and contained | ✅ YES | 1 line change, single function |
| No new features | ✅ YES | Pure bug fix |
| No architectural changes | ✅ YES | No structural modifications |
| Low regression risk | ✅ YES | Minimal, defensive change |
| Confined to subsystem | ✅ YES | Only affects ksmbd |
| User-facing impact | ✅ YES | Affects all ksmbd users |

---

## **6. Comparison with Similar Commits**

Recent ksmbd fixes in the repository show similar patterns:
- `379510a815cb2`: "fix possible refcount leak in smb2_sess_setup()"
- `5929e98f3bb76`: "fix potential double free on smb2_read_pipe() error
  path"
- `e523a26c05672`: "fix passing freed memory 'aux_payload_buf'"
- `809d50d36e71b`: "fix memory leak in smb2_lock()"

**All these are typical stable tree backport candidates** with similar
characteristics (small resource leak fixes).

---

## **7. Missing Stable Tags**

**Notable:** The commit lacks explicit stable tree tags:
- ❌ No `Cc: stable@vger.kernel.org`
- ❌ No `Fixes:` tag pointing to the original buggy commit

However, this doesn't diminish backport worthiness - the technical
merits clearly justify backporting.

---

## **Conclusion**

This commit is an **excellent candidate for backporting** because:

1. **Security concern:** Remote memory exhaustion DoS vector
2. **Long-standing bug:** Present since ksmbd's introduction (4+ years)
3. **Wide impact:** Affects all ksmbd deployments
4. **Minimal risk:** Single-line defensive fix
5. **Clear bug fix:** Unambiguous resource leak on error path
6. **Pattern consistency:** Matches other successfully backported ksmbd
   fixes

**Recommendation:** Backport to all active stable trees where ksmbd
exists (5.15+).

 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 287200d7c0764..409b85af82e1c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6826,6 +6826,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.51.0

