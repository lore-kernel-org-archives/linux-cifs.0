Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F031B130;
	Mon,  3 Nov 2025 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192988; cv=none; b=PuNDgkiyoLADpbz+axey8/7GikUUH9GgiHTbAyj43yJgMUydIpR7NPqqGYTIlTPokSFYkDj5x2E3mpi1RwWbxaDt4q6vb5mf0ZtTd75F4d0/AUCYx45aw3xyMIzJ82enTQvPgiWP3iszHKD4l6RTy5nBZhzPjlnrjn2OTbK4b2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192988; c=relaxed/simple;
	bh=XZg6tEDLa16EMaR5NtjP4niGslvahlCrI31g+m9bbfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=er9OBpWnDdYx2e472QTAcZRl5NnMl4LUM2LiL5bpubipTn/y1L1Wcf9wdJOektXMfmspykgF85mI6MPANF3FBtppYIFhwsURI+6S6GN35NiChc1PoeEm8AGgfzS7OfNXn03g0db607BkK5cE58TW0ki21N9ksBWPvBuqCZ2NBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwRXhMqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwRXhMqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F9EC116D0;
	Mon,  3 Nov 2025 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192985;
	bh=XZg6tEDLa16EMaR5NtjP4niGslvahlCrI31g+m9bbfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwRXhMqUrveCPLxX23Tqn0XFYZBQP/bFlWVIrvCYZoDW1vUnDgk9ig4QWYtQjMf5W
	 HL/j/GtVipBeK3opVX8sflhDAN7mthu+4iZdhncBesO9aBF1F9lmgUvw1wObvDpVCO
	 BpL39onooH6nXba/ddDpVYNlp4BvSafN/UBzO1c7v9cWSckYIiqPttI9/3GC3KAw9t
	 LjMP1kuttGc/lhsnbNLe45GS3/8+n6s5c4rU0VLE9C2QH2SmNT4f9E4V1X4g8rLPyh
	 yYmgb4wARVVX7DYdWaFnE9RB3hbgHJRlv/QxkI51ttGnzw3Q9gQiFiRa4yX/1se5O3
	 fd1vAoxfF4uTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Steve French <stfrench@microsoft.com>,
	Thomas Spear <speeddymon@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.17-6.1] cifs: fix typo in enable_gcm_256 module parameter
Date: Mon,  3 Nov 2025 13:02:22 -0500
Message-ID: <20251103180246.4097432-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

[ Upstream commit f765fdfcd8b5bce92c6aa1a517ff549529ddf590 ]

Fix typo in description of enable_gcm_256 module parameter

Suggested-by: Thomas Spear <speeddymon@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis using semantic code analysis tools
and git history examination, here is my determination:

## **Backport Status: YES**

### Analysis Summary

**1. Semantic Code Analysis Findings:**

Using `mcp__semcode__grep_functions` and `mcp__semcode__find_function`,
I identified that `enable_gcm_256` is used in the `build_encrypt_ctxt`
function (fs/smb/client/smb2pdu.c:643), which controls SMB encryption
cipher negotiation. Using `mcp__semcode__find_callers`, I found this
function is called by `assemble_neg_contexts`, which is part of the SMB2
protocol negotiation path.

**2. Historical Context (Critical Finding):**

Through git history analysis, I discovered this is actually the **second
fix** for this documentation bug:

- **April 2021** (commit fee742b50289): Changed `enable_gcm_256` default
  from `false` to `true`, but **forgot to update documentation** (left
  as "Default: n/N/0")

- **June 2024** (commit 8bf0287528da1): **Partial fix** - changed
  documentation from "n/N/0" to "y/Y/0"
  - This commit was **explicitly tagged with `Cc:
    stable@vger.kernel.org`**
  - Included `Fixes: fee742b50289` tag
  - **Was successfully backported to multiple stable trees**

- **October 2025** (commit f765fdfcd8b5b - the commit being analyzed):
  **Completes the fix** - changes "y/Y/0" to "y/Y/1"
  - Fixes the remaining typo left by the partial June 2024 fix
  - Already appears to be in backporting pipeline (commit 66b5c330b9223)

**3. Why This Should Be Backported:**

1. **Precedent**: The June 2024 partial fix was deemed important enough
   for stable backporting by maintainers, even though it was "just
   documentation"

2. **Incomplete Fix in Stable Trees**: Stable trees that received the
   June 2024 backport currently have **contradictory documentation**
   stating "Default: y/Y/0" where "y/Y" suggests true but "0" suggests
   false

3. **Security Context**: This affects user understanding of encryption
   settings for CIFS/SMB mounts. The variable controls whether 256-bit
   GCM encryption is offered during protocol negotiation
   (fs/smb/client/smb2pdu.c:643-648)

4. **User Impact**: Users running `modinfo cifs` on stable kernels with
   the partial fix see confusing/incorrect information about security-
   related defaults

5. **Zero Risk**: Single character change in a MODULE_PARM_DESC string -
   cannot cause regressions

6. **Completes Backported Work**: This is a continuation of fix
   8bf0287528da1 that was already backported to stable

**4. Code Impact Analysis:**

- **Files Changed**: 1 (fs/smb/client/cifsfs.c)
- **Lines Changed**: 1 (documentation string only)
- **Functional Changes**: None (pure documentation)
- **Actual Code Default**: `bool enable_gcm_256 = true;` (line 68) -
  unchanged since April 2021

### Recommendation

**YES - This commit should be backported** because it completes a
documentation fix that was already deemed worthy of stable backporting.
Stable trees currently have misleading documentation ("y/Y/0") that
contradicts itself, and this trivial, zero-risk change corrects user-
visible information about security-related module parameters. The
precedent for backporting documentation fixes for this specific
parameter was already established in June 2024.

 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e1848276bab41..984545cfe30b7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -133,7 +133,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/1");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
-- 
2.51.0

