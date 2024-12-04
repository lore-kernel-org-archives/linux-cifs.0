Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD652251C1;
	Wed,  4 Dec 2024 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331774; cv=none; b=mXjuHuim2nZqupDn8NO/yVIjplQZMPMzMI8QdBLB7gSDNd8OpD4fi3dmA+DRFZfKIkCYCOteBuTKBWfG2m8woVqhMucqaqSlqe0+qB6pvmu+ukaYRQQOS+jx320oLyvs9ujNSGDucLR02GYAFUbSm7TFA/zA801MWkvpFh0oBw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331774; c=relaxed/simple;
	bh=uk4wdUmdwzt9KGwhiq+XwZHaY3wVvPrKAOZc1qX0dCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETEl1mZqKmkTossVLnvxnCjC+PcTcBnM7GtcwIi9eqgK2GKBmdDqk/yofXRSn3hXVAHS8++XHDUD1xa8aG3YnFOhDS9qyMo2Y2P605ZKlf19fPmihdA9fuf9wk+PR7QASAotcL2x0Lglz6HuMqa4WEviiATNX7aVlJi2U7WpENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2xJUSFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2xJUSFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CB0C4CECD;
	Wed,  4 Dec 2024 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331773;
	bh=uk4wdUmdwzt9KGwhiq+XwZHaY3wVvPrKAOZc1qX0dCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2xJUSFBmijAQXgwGtydN7ZDLh4f3Z/NEtuSDWmA7ndPOhKOgFzCyhPKRcC7BmDOt
	 3lyfGKeTNJz/Xz57kmV2pT8WGVuwGyClO/Meci0JuHFcwBtC/3U/7zDTmK/ETtq0/9
	 QzH51TKR8d8lpApRABOKZoVfcVvAQZEjxICW16O45hwhXF+Ac1tjwkF9hICC58H58Q
	 yXNDgeemLUitY4I1hd87mOM7VDw2I6yaHGa/ehr3QTLHQKlabFnzrndhxRHyGd2JHj
	 VdNTrYItf6Yez7LtHvYTlYSI1Pj3657ypSUT7TZ2Q7tGdjRyB7m3r45K0DDuSTaEns
	 QMN57c8+TbryA==
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
Subject: [PATCH AUTOSEL 6.1 14/15] smb: client: memcpy() with surrounding object base address
Date: Wed,  4 Dec 2024 10:50:53 -0500
Message-ID: <20241204155105.2214350-14-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155105.2214350-1-sashal@kernel.org>
References: <20241204155105.2214350-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
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
index 67c5fc2b2db94..6077fe1dcc9ce 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5349,7 +5349,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

