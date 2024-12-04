Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2EC221474;
	Wed,  4 Dec 2024 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331730; cv=none; b=tGxtB5+WX4sVqekQ9IaMQvk9FW9gby6+9NbfyzFvCzeay7geN7WJ8cYt2osEOP3CcCNQ0/12qICXUZAKe15LdkXPAvGBRJlE4JUHVXOQY+0R8ZOUn/xi0jk4qj0m0L2x2MC5WvtjIMy5bJBSy0MceWblaKv5jmnk1B2OYV8F4YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331730; c=relaxed/simple;
	bh=TAZkU2/9ASsYEjOO7G8MaU7/9Xway/EOa6HJfawrR2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFeCa0Ng++qvgybJGATFVnrHC9CUIPEWRlVqHIU8wicg8GimzxTx62GzKRzouHGgX5B9l8KnCE9JjuXnt+E4gGosKRaD83KNphi/RM7qWrtjNlmQZ0lkH1JS0wST/BzPm18VRTpZOTzSX89TnrEv0dcNPWrYa+afVC7OUSj5G9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMsekpcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMsekpcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B817BC4CECD;
	Wed,  4 Dec 2024 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331729;
	bh=TAZkU2/9ASsYEjOO7G8MaU7/9Xway/EOa6HJfawrR2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMsekpcWnkWReS46Tq5mr9vpdnYuTuXIex0vd0oR7WWX4BvmBORxyP+9iY4m8vfz0
	 dRar1MQnb/D3q3tc4DKzdrcrr/3bRAT3dBwmWjdeuNGJwMUe5CIp/JmEu1qZwrY29h
	 FkKRolfJi0rIkjLz169xVVrMI/MUPb4NZjukDDSjKA83VTRuyeRdMU3UgRQ+Ba5Edy
	 wme/tGOwF8HpRPmz8tCRge1+sXnPhMPeWfcPdTpaCk5i3Scenbh8G5dIR7lLGBa8da
	 5lRZeDY8GlY/jtBuD3ItBxukLmzWn+huDaOezJ5V+yvCN5PlWHiV/uunb71iKLqD92
	 B/vbgrtUwWdcg==
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
Subject: [PATCH AUTOSEL 6.6 23/24] smb: client: memcpy() with surrounding object base address
Date: Wed,  4 Dec 2024 10:49:43 -0500
Message-ID: <20241204155003.2213733-23-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155003.2213733-1-sashal@kernel.org>
References: <20241204155003.2213733-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
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
index 301189ee1335b..a34db419e46f7 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5364,7 +5364,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

