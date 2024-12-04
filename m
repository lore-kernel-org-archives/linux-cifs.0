Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC724213220;
	Wed,  4 Dec 2024 17:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331642; cv=none; b=Itwn1hYjUyWKIYKcaLc7KA2XwmjEvaZxcwma+Zy9Pane1fhDknR4A0ryAaJGVbp14o11ptJ3lvACSsahcQYyqzirrIE5xsBnWKYtwqQC0uD6nZf6v1vA+6WtePlFQvh3ta6vn6DGfKfCWDwIcWIIDF1aKRt61fFLbrvJhrGAYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331642; c=relaxed/simple;
	bh=XMBDRbZC6NrCOGtrUXtGA7GD4vyguq6o99A2dnhITns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcTIsmGYHyZWRXTZLpkd3ZAc6JPlvAtusX9n0oh0rkntJXRQOM+GfFrXIzPMCuG7IxyZfYIEJ4GKRyeQeAouM6QM1OpXmHrYl8iz15kX21W35isw51X0Yhq5LVdueIhwkT1ToduSn1z7dYShko8r43VH9eRHZSWicxS9hTPcMsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hv0ktALa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv0ktALa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB39C4CED1;
	Wed,  4 Dec 2024 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331642;
	bh=XMBDRbZC6NrCOGtrUXtGA7GD4vyguq6o99A2dnhITns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hv0ktALaxGP3aGJSQLgm0rhmg7wFoo8Vy7ufKxTiUEZwewINq62AyoXCfpw3A8ijt
	 Ybyy3+dppYURbxh7nbq3Y0h/UNKvKheklVxA2CJ7Srdz8UC0Sb2tL+uvGMOBfUR32y
	 3DURkMnHWHiasBYs1LtqSxze4KkWGt7riYvrexzQj2+gJ0EjHEjL8lxI/G3obDuwMK
	 Te4Qj7SbNFItcKc7KluXwZgNGHCpXJBhUb2qPI8MwIy51e3J4d0zabS5rGCZEQXkXi
	 yOYiG9MNoWTzhuRV1j+r72Zi69RjMaKkZqGHgJi5TnP+PcUvDo36A3/PV67IeBJXVX
	 YXtUaDayZc6mQ==
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
Subject: [PATCH AUTOSEL 6.11 30/33] smb: client: memcpy() with surrounding object base address
Date: Wed,  4 Dec 2024 10:47:43 -0500
Message-ID: <20241204154817.2212455-30-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154817.2212455-1-sashal@kernel.org>
References: <20241204154817.2212455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
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
index cfae2e9182099..b681024748fd0 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5407,7 +5407,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

