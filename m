Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC90233D68;
	Wed,  4 Dec 2024 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331532; cv=none; b=KoXM0yNNaLEw7Z2koWqnnjAXZ88VcvaoXiVXt+lPUGgXGbjFqBxA0NkNsIw9GBJ5DODMKDf5QR3gp1kqSkOGYWC78aWJVG+8RcW4j1F4hXCy+FxeJaDWIgWnIvc0IkHn9QE1d5/sFJSXdSJQHtaWQaLdxTE+Ghz4esSG/Y2MyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331532; c=relaxed/simple;
	bh=nRp2boy3gqrralSZ0lweFfaRojSVHtUhRfYWWpxRuSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUB/g6atlJs0q/OVUJVoWfuWp9CWMTOqofhebZtrGAbSqjG5zMTTh0i/hCi18wagNGfOr7DB/Hle/L9Sym5atkUN0jUmTGRD+UvixvXBrWJxlhDeQsY+gg7p84ZWK7UNELtW89RB0R+3x5eCV9m74AvYdbWD79FGOg/rugLCj+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/6mSWbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/6mSWbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82C7C4CECD;
	Wed,  4 Dec 2024 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331531;
	bh=nRp2boy3gqrralSZ0lweFfaRojSVHtUhRfYWWpxRuSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/6mSWbBZ6NN7JCOU4LaqzW54UrKhGda18ru3LfGJUi/JDfhnt4WA6zijPaA8iDie
	 7pLT7s3irWEJ47IljNbthXMqGUU+pnko6YegJ2BNu+6DchDgONQ1wQaGn/QCEK2N8J
	 nuyVI+pxIuaTRUJuzH0KHyaTIuTKPNyQOLLCsBvY4FM3JYNuGe6ATb7V9DVTxOPssd
	 E6TPVRtjjkBQbYwahUUfo/TRNx+Oax7aGwsI4hsuPE4vouZB2LKVemAyy5g4vXqKXF
	 7S3H5/CYZIJwiNj2SsM+j/vXIHUNrlI2/iMRGPHqvlMPn+n6bMfzwfS9Pq4wWrFW8h
	 T6FTG0xaQUDfg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 32/36] smb: client: memcpy() with surrounding object base address
Date: Wed,  4 Dec 2024 10:45:48 -0500
Message-ID: <20241204154626.2211476-32-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit f69b0187f8745a7a9584f6b13f5e792594b88b2e ]

Like commit f1f047bd7ce0 ("smb: client: Fix -Wstringop-overflow issues"),
adjust the memcpy() destination address to be based off the surrounding
object rather than based off the 4-byte "Protocol" member. This avoids a
build-time warning when compiling under CONFIG_FORTIFY_SOURCE with GCC 15:

In function 'fortify_memcpy_chk',
    inlined from 'CIFSSMBSetPathInfo' at ../fs/smb/client/cifssmb.c:5358:2:
../include/linux/fortify-string.h:571:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  571 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c6f15dbe860a4..0eae60731c20c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5406,7 +5406,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel) - 4;
 	offset = param_offset + params;
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+	data_offset = (char *)pSMB + offsetof(typeof(*pSMB), hdr.Protocol) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->SetupCount = 1;
-- 
2.43.0

