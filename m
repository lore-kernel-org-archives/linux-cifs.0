Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FDE2EC095
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296268; cv=none; b=i7puXzW8WDoO5ZxGiw9BSucqnbF/aGhz7AjYamnce43FZeLvSNmOrnPLWK0kP10G4MMHWvQC2fKPoKeGV7j9I+zo53Pdjs0y66BzjbZP16K+UXGPXqGLL1zk4nh+bEwFk+dv5kvlT3hAVLOgNaL0SRJLXaa1Gj+9MUQUKL/Ng4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296268; c=relaxed/simple;
	bh=8XKJK30oZp3QklySs4AwKMFamBjq6gQNMIIDoYAOHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzsefG27+337/PgEHMQ+XxgMsnqpZtQsANiK7F/BCAzJumguEMfniMPe3RHuC97dw1HCvQT8oZd7LqmVP2cSdCwD1PzIubD3eBqGB9agVcUmct2WUnbZqP/a41DY8yanGgsGin8FZ5e0tD4EgbKIVsSsPLQpkMKTKQbpu1XZhjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Vh2CEsVG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Vh2CEsVG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=SDybIPq8SOlNbvN/Gg6Tj5xcXCIHombJl3CYZPtQvoA=; b=Vh2CEsVGt7hb06a1e10W0NaRqt
	rpgljH3Uh/bYo+3f0mC9/Nfy960I4SiRGfRDpp36NHqdwgLONdU32zgvaDWU6nVXsm9h+6UZfwpWr
	pQ2a/1vNNQ0LOO/0QV3CLIIE2rU5f3YS/MZzYdm8aA//Hs+K7IxDf7b9Y97No5NvUr2iQrk0fLaO+
	Sp1Gr5MkFN/+EmN85fkPVTPNmWH1Oit7VZkZ9hieHrMwoeiyTfpQDSCrW3TNMrWfVlm7qu40dpfxY
	Lev96pTh7LYMz1hD28eBxeijER1CldyWbWMpyralyM25guFob9wYscDC2DvD3LTnmrCaF4/uhRks4
	CaSx0NxMXldiGP8AOTvsbSHK86S7y+rvuc7TDR50p/V1NjGL5bDh57O8FpTWD1dRAovBMP+l+2EpG
	M/zd2cn6M4M44Su0QsH6v0CYoqN78xA+tSRWp0BW9MpQN79+PXlLScKXtWC38fscrACRqhCyXvha0
	FyyQYjD1pPMIdxEs4x5SW/rD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81TC-008o0A-2I;
	Sun, 12 Oct 2025 19:11:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 03/10] smb: client: let destroy_mr_list() call list_del(&mr->list)
Date: Sun, 12 Oct 2025 21:10:23 +0200
Message-ID: <59a58f3a53ccc1d0ac732d3a98986b995fc8e32a.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760295528.git.metze@samba.org>
References: <cover.1760295528.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This makes the code clearer and will make further changes easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a20aa2ddf57d..b7be67dacd09 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2363,6 +2363,7 @@ static void destroy_mr_list(struct smbdirect_socket *sc)
 				mr->sgt.nents, mr->dir);
 		ib_dereg_mr(mr->mr);
 		kfree(mr->sgt.sgl);
+		list_del(&mr->list);
 		kfree(mr);
 	}
 }
-- 
2.43.0

