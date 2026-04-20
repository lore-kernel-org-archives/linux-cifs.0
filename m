Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05A83A6B85;
	Mon, 20 Apr 2026 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691745; cv=none; b=Xv5za6DaJRitwFivitJWFzB6B4cv+2LljpjInlrYleE0oAQs+4cXLlY7+KrK50s7gYSQ4WvJK7tohIITuVYwtYwheEPHWdo73DeM+DWWUijCKfy44aHgJbdk855zgJALvIYmNoslkM7OZSE/dv2xs0NsUWObeT+xxDcAVUJGMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691745; c=relaxed/simple;
	bh=tDvRDyCiacZ3jLQdE3vE4klPYJfmns56c8zfBVG055w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS5UH+haTTiGvRLYNXSLXjK6x8Ax2FK+LOzl5F42oqWipNTLldnfRO8NqYzeX0xxzlA/uF4PW6gfyxND3/tz9MMCZl9Y7huu+o5+iW9Za6UXLxMkLp/+FbBg9qihglnjzHZ+Ez5ATcksADlsXxxwH1Fh1TPtzkFc5ia+saPp+PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXXXeqKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXXXeqKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA29FC19425;
	Mon, 20 Apr 2026 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691744;
	bh=tDvRDyCiacZ3jLQdE3vE4klPYJfmns56c8zfBVG055w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXXXeqKxi37cwEtk+qijbGno4y3FQqIRI97d4OQ4z2oSzy9CJuuOpypnoLiJYwOFa
	 13povOl/k5CB+7vDzznt1/sqj/nb0R2u/hDpVCnKNn02Xk20GyayozpE2pOn1IpQjX
	 iCNrjZekoaLDzC8faGIQQfnK8yyb8r94SYmrmnSAUb+/3KNq138cL/EKx0bccGLmPe
	 DV/4VSldXrSic5zJAHaUx1PdLwO3XzofX8CnwipBRLZZZmI48bEDt5hM79BnmMa8Wf
	 hEKS5NJJc+0W/qTZQi9ZBrqJiDAg4HkXrinyIsA9AMz8XbdobScI5uIsU5C272fSvO
	 2uJ2z7/OltLzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Mon, 20 Apr 2026 09:19:22 -0400
Message-ID: <20260420132314.1023554-168-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Fredric Cover <FredTheDude@proton.me>

[ Upstream commit 78ec5bf2f589ec7fd8f169394bfeca541b077317 ]

When cifs_sanitize_prepath is called with an empty string or a string
containing only delimiters (e.g., "/"), the current logic attempts to
check *(cursor2 - 1) before cursor2 has advanced. This results in an
out-of-bounds read.

This patch adds an early exit check after stripping prepended
delimiters. If no path content remains, the function returns NULL.

The bug was identified via manual audit and verified using a
standalone test case compiled with AddressSanitizer, which
triggered a SEGV on affected inputs.

Signed-off-by: Fredric Cover <FredTheDude@proton.me>
Reviewed-by: Henrique Carvalho <[2]henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index be82acacc41d6..f207c7cef0467 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -589,6 +589,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 	while (IS_DELIM(*cursor1))
 		cursor1++;
 
+	/* exit in case of only delimiters */
+	if (!*cursor1)
+		return NULL;
+
 	/* copy the first letter */
 	*cursor2 = *cursor1;
 
-- 
2.53.0

