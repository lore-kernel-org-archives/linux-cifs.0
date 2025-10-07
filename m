Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BF92147E5;
	Tue,  7 Oct 2025 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852365; cv=none; b=MPDKpYYhws/iqZcJzSzYbyOb0l8fTugpAsQ9YEeTsgiIXa4ZBVnxPNMq6SoLubJrnM6S2Ke8Cdg9LA6TnIOAAHeTvN3NIOOgAEVlDNlPaXmeGwDzK8vkG6ge6ZU9rxeGThH2ohbq4po0GeUuSnaq28vbQvn1OITfWJTYAZy1Ra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852365; c=relaxed/simple;
	bh=ONJWRhKAMFw51AyXu//nTUTkQbiZhRa5nroe7YxXcTI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=bAixes5mKpPNhnYzfTrRofgEwiLvdc+mlfSE0sAjEuMqKqyil/zNl3Icu/SL9oQbsheG6623dRtd8t79EOiTdDt1DsAQiUp0Lj6f76Fk6y9OT1P4MtgVaFHF0Kk6yBBnR9yrn8uycMb7FKiVwmYDNARgDVEi8lt4NUMuQ5hzDgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=K0oOn/ne; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="K0oOn/ne"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759852344; x=1760457144; i=markus.elfring@web.de;
	bh=8P2Qj/3q4W4upRVJlyLhxsUesThb5N9DeEvK0H+Q3kM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=K0oOn/nektWc/ryHh+2veIN/2FVfcIXDI4OKQZB+r5F4ubtzgEOcurdmA1/b2W/y
	 2gsY+nF4wx4y6IpxCqT+uqV0gwFpOwg3NZmxBHkLGwoxYbRRJ36l4ZFIUdZ5NQVYe
	 M38v4bogufkVKzIAXalClOGBmXDi8Eonsk6jklsPz6jt9ZI2l0q7OcJyimCDz1Z04
	 72EWr/p7vdX7TKGTcdFaNeU9hLxsFBuN4oQbtIZkAEM8HY3bzxA2RdM/YawpU4RnC
	 R0BGw+7qn1qNRsv63X3OIBAdYPrz/cepnh2tEuIbq8SAQPBBovClR1ydVBEe/xHWm
	 Zf+H17QWDW/X2330Zw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M8kEP-1vAGaH1bV3-004TOC; Tue, 07
 Oct 2025 17:52:24 +0200
Message-ID: <acc5a7d5-80a3-4c4d-8a43-c44bd962d008@web.de>
Date: Tue, 7 Oct 2025 17:52:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Improve unlocking of a mutex in
 cifs_get_swn_reg()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ruI1XnQJ2PvNsVkyIRapd/X6hUY/hcYGnfgnpsju/Fl6RaXXr6t
 guYHUv6fb8SHRN+wCcXMp3RMsFhAc++z0sHCE0+kFzvVXQ5L6MKVs9hKRxtmWKLXxv+OzrT
 +qBNJcBf2Xt02h/xjUjOmYZbgZK+DyW91io3WpaXZhof776wxwUz8XrTrqX2Vq4H1dN7iAB
 n1FFkpAINRr1mcwytewcQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PW1fBbNYUT4=;TFSdDTNm1iCTVpZS8ThJPidmc4f
 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
 tK1oQNZNBnJye7fbXqOJRPHJpU=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 17:45:28 +0200

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifs_swn.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 7233c6a7e6d7..35a3e73c1958 100644
=2D-- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -313,17 +313,15 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct =
cifs_tcon *tcon)
 	reg =3D cifs_find_swn_reg(tcon);
 	if (!IS_ERR(reg)) {
 		kref_get(&reg->ref_count);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	} else if (PTR_ERR(reg) !=3D -EEXIST) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	}
=20
 	reg =3D kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
 	if (reg =3D=3D NULL) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ERR_PTR(-ENOMEM);
+		ret =3D -ENOMEM;
+		goto fail_unlock;
 	}
=20
 	kref_init(&reg->ref_count);
@@ -354,7 +352,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct ci=
fs_tcon *tcon)
 	reg->ip_notify =3D (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
=20
 	reg->tcon =3D tcon;
-
+unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
=20
 	return reg;
@@ -365,6 +363,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct ci=
fs_tcon *tcon)
 	idr_remove(&cifs_swnreg_idr, reg->id);
 fail:
 	kfree(reg);
+fail_unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	return ERR_PTR(ret);
 }
=2D-=20
2.51.0

