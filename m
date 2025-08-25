Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F6A28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155862; cv=none; b=Hq27vsHEORa+E10onzekboAL8pJZsr5AGcOyIzr16mWfIo4zOSQsMeflqjwtYZFPN7+Aujx6P1XApLTV/LxhWBVpNeUccpFjQo9haw3KchRcx0A5pVLGH0M+uQzMFHDJn3Xuut41m7FMEbzOgyCuYR8xiT1PJwXQYuYjXzuQwPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155862; c=relaxed/simple;
	bh=fNUKer9lB5d2dd+elnYFo/CgkmneuUKbsK+QrJzgb9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwsdVLtZceDsqKf1frXsiyZxJVKm9MB/Vks3rfvOV59qr2LiRM792+qPPOv27o8qsgElGNbU6qp5Z1aTCpluGCHRC9ZIBsfpuVD1x/Bvfda2iGa1qc+7K00xeJexAoN745yuvbLFEPOJX/eeCLV9L3O58kWNU8liAnRkOIzzPgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pzYokjg1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pzYokjg1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NwE3A7aTkkt91vL+xNeS400xd5NA6hbVr1fqdCj41oo=; b=pzYokjg1qNKSFdj9XiqfitMavR
	t+BniILcLjBy0wtlHeb44oiZfRKTmJQqs3/48ZSXNtb9rAbcJA4TPCaFCS4Ze0gybz9tAmg/wfUiJ
	hdlRSDW7nwndmI64I/9hkrkgNmlRaRO0ptp/g7/ffDvhO42u9d+FotCpW31X4klXy830+OYsishXb
	76OgF0bi7apVvWTTaNoXZ6HwBMVEUcjen0ShqEODjElfVujHUmhyXh/Fbn/0YxmL70BDNQHMdauA/
	Ul5CaKJ0p8w5LVNbEU+WDIkO45WthklwbAXWsDwunamtqoFzjmoJC3fsylIVsRY/3J5RSc6XhrTrU
	/vMG8QFL7sSYqCBMSUOz5kGJPV8r3CaB5os33jJwdW25JRayF83orJ1dScOIXrSJUOR5Ch26RGy+/
	McPwrAypauQ5TnCaM/8ePEOilVNEHLCH5+zqxdGOApAflYC+b9+7o8P5CuyoQTkWSsc3MNqNnTNaS
	BJKODLkcEZ59xG7Wdxl9w52M;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeMU-000niP-0S;
	Mon, 25 Aug 2025 21:04:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 135/142] smb: server: pass struct smbdirect_socket to calc_rw_credits()
Date: Mon, 25 Aug 2025 22:41:36 +0200
Message-ID: <3270445e0b43942129516dd8f52543cb530a46ec.1756139608.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e47ff55af2e0..da48b2ec6dd3 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -990,11 +990,9 @@ static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 				credits);
 }
 
-static int calc_rw_credits(struct smb_direct_transport *t,
+static int calc_rw_credits(struct smbdirect_socket *sc,
 			   char *buf, unsigned int len)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	return DIV_ROUND_UP(get_buf_page_count(buf, len),
 			    sc->rw_io.credits.num_pages);
 }
@@ -1390,7 +1388,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 			buf_len = 0;
 		}
 
-		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
+		credits_needed += calc_rw_credits(sc, desc_buf, desc_buf_len);
 		desc_buf += desc_buf_len;
 		buf_len -= desc_buf_len;
 		desc_num++;
-- 
2.43.0

