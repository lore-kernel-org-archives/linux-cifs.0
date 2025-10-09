Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D6C2940D;
	Thu,  9 Oct 2025 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760020347; cv=none; b=MDwhsMNeUYuWSDsnDDxTcht5aAizwF6+VXCqeBfHy00hAUN+wex9Osn+OsIjDAKAeMb3xbWrc+19kE7cJ/mOOdtBnaniaH1VZf0da2DYEDGfkgHgqXO3M3Uvp5S0Zxx/IXeUpTO9vTfW+O+t0qdBXFHRUxAqsX8SVNqdXt9KcNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760020347; c=relaxed/simple;
	bh=MbTrAsKdJo+mCPSmalnVXdWjc21dQYiDC4Se1hfa3Q4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=L2GMEn2GoxMIhPC6Slg0gIZtkqcbLwPs4vSFrhN7pQKxKEnymLNaAjaDdOqBXfMrsEoS1niwVlEo++ennRhyD896PScOWXdz5kH3qG8GJcJJhc7nxz+HDs/XcAQLmyJCnlfaOR9WaXYcAHkXHs7s/c8AISug71ymzayFcNeNhzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=JAtHV1aI; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JAtHV1aI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760020331; x=1760625131; i=markus.elfring@web.de;
	bh=w+5ROqhH8CiaHrUzvkXJ8WGMp7ROKo1pLkBH8T+Ns3Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JAtHV1aIUJ6FDQZghAXwvW2R9DTENn7cPxib1Iw8bj6d7+3PPj8QJwP3u2g/Cg1c
	 tdgIw+GjGJTRys7b/4aomU1jkVaLdGRK/hwBXjgJB1uu7BheylsfTJfqV0Qhzx6bQ
	 pxW2d9eYslvp3oJIAVB3JpFdOSeS+NYx7c3BZ8WxQtea8MsF0J1yUJLeEYlbxw9e6
	 H1PumEDRxdwdVXuvqvJ5dcg4JYg0HfpVkNZh6eMakWKBFCJnXeI4ohf7SDZ9hd+oB
	 NLDCZ7+I234zvxYXocM3LcqHVKITyNYpAAaLuuxTlQ3dObKGkbYjkRyWnb64sa2AB
	 ZthaJ0huBqKy9RJlrA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N0qr9-1uItnq09NV-017pEf; Thu, 09
 Oct 2025 16:32:11 +0200
Message-ID: <dcb52df3-4179-4aab-b823-8bb2c4c46bdf@web.de>
Date: Thu, 9 Oct 2025 16:32:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Improve exception handling in
 smb2_setup_request()
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Enzo Matsumiya <ematsumiya@suse.de>, Paulo Alcantara <pc@manguebit.org>,
 Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O1+pw8P3/6y3n6bYhXahAIR8XEh+Fgzrs4FxsExSJYIYEQ/FIZh
 Fdr+b3HDcV+JInMdxY/HulFPId/8tb5YpYWWlNSZSCgw04g9yoxWp7vX3V+tVtm+SHETID3
 rg1zSo2+/ashnu8QahZx1d01vECQq76jIcv80cOj5Et6lIAdt+GrEy4sS7Mr2CSPJaKv9n5
 bFxlsWDPaBVyEYXzgWt+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MEHnwr8u4J8=;KTGfVYsy7+Zv10QEk45dffpt2Rv
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 16:24:17 +0200

Add a label so that a bit of exception handling can be better reused
from an if branch in this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bc0e92eb2b64..373c5309b54c 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -886,15 +886,14 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_=
Server_Info *server,
 	smb2_seq_num_into_buf(server, shdr);
=20
 	rc =3D smb2_get_mid_entry(ses, server, shdr, &mid);
-	if (rc) {
-		revert_current_mid_from_hdr(server, shdr);
-		return ERR_PTR(rc);
-	}
+	if (rc)
+		goto revert_current_mid_from_hdr;
=20
 	rc =3D smb2_sign_rqst(rqst, server);
 	if (rc) {
-		revert_current_mid_from_hdr(server, shdr);
 		delete_mid(mid);
+revert_current_mid_from_hdr:
+		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(rc);
 	}
=20
=2D-=20
2.51.0

