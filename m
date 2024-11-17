Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7E133E1;
	Sun, 17 Nov 2024 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731843135; cv=none; b=BrkWjnlfD/Mq1y00rdkNGexBcjapdluPF5HPC+aXCTLNXfiStzAuxB5652YEuPx+dS2VtnbUhetAjsEwyXb7hrf2cY7yPoq2c4xewwVKl/GBfsn/Wt6XfC3AJzfFwfF1cIelXUHlYSRtcq1xh+e+50hWyAZtu7wdGw1WwvF8L0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731843135; c=relaxed/simple;
	bh=r4aVrfLDSvjj1c3JSbXfk7Bj/ja/pITaVG3yhnMeVGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iR8dJ8TxHggiA5H9lMi3US8cj8cGdXU4enGlT76kcyDzO8SiAhlYNhTZR0nebLEaa4ngfAyIxKS5GRH00qAgW+HwqdsfWZffPqeboDO0sIk18Zz1CzBwKPRda+4LV4OffSRZ3Lk7IRTl2lHpPttjQPWU+7NgJ8RYFJRtsU+lR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxvdEjPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxvdEjPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD9C4CECD;
	Sun, 17 Nov 2024 11:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731843133;
	bh=r4aVrfLDSvjj1c3JSbXfk7Bj/ja/pITaVG3yhnMeVGk=;
	h=From:To:Cc:Subject:Date:From;
	b=OxvdEjPqLZWUIxt9S4Z67aqoK7NkJMnEdjsOP/ZniihewZ6DKhrrb4EhJDWh2jGa1
	 u1K2qByyN1fHS3sUsB1stTA0Pn7pgfnso8CNENvr1hzS5C6mRlHrI5p2ltsZi2aaSO
	 TxXH1uis9qGeVY52CGdi4sx9e6FYvwa5AkEvCa7XxaCbaOSDet/MaGzb9kN0Cqyv92
	 GkWocHdhCToaK5pQpK1WDNY5xgTjQ1Bc/MLZLGaWDYMdNjWZd5QdX+Wsc2IUq5MrBd
	 Dq1VgkCxqKalg83luToqD6lKxi7sutBTWamRuzhAF8Iz7y+WJ2O5ly6BnUFLfBOKY7
	 zj+QxKf7GLmTA==
From: Kees Cook <kees@kernel.org>
To: Steve French <sfrench@samba.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] smb: client: memcpy() with surrounding object base address
Date: Sun, 17 Nov 2024 03:32:09 -0800
Message-Id: <20241117113204.work.419-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1950; i=kees@kernel.org; h=from:subject:message-id; bh=r4aVrfLDSvjj1c3JSbXfk7Bj/ja/pITaVG3yhnMeVGk=; b=owGbwMvMwCVmps19z/KJym7G02pJDOmWVyz+fZp7VebVSsOtPCvDQ1Mn9Fw5enzl61/M2TJFi T8N5myY1lHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRPgGG36xVZR9bItsrmLfo ei/e9Eu/5Oe7Q6H9OS/4Q33Wvn+yo43hf6jfNb3/mzYtCP7ysFDq2gvLUoM/DVFhIvnvigsemp7 8zAwA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

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
---
Cc: Steve French <sfrench@samba.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index b96ca9be5352..026d6b5f23a9 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5337,7 +5337,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel) - 4;
 	offset = param_offset + params;
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+	data_offset = (char *)pSMB + offsetof(typeof(*pSMB), hdr.Protocol) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->SetupCount = 1;
-- 
2.34.1

