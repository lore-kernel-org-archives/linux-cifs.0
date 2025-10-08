Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563ED262D27;
	Wed,  8 Oct 2025 20:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759953773; cv=none; b=suaFAEDQ8FZ1gR8QTn+cr6vQyxMz4yiEksPuLUZLrFLCM58BqGDso45CDwezmxFO+nRc4/ah1UBAbYg40nD7tz7lZhoT3ac2Ihjae0Z+pEKwUpG84qB4yrjDtlPlD9Hm+fBPc91HO+P9gCAsFfk8hC21S0oiH/W76K0CaFOjIsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759953773; c=relaxed/simple;
	bh=SswkMmdp3zNndOeVw+rTQCHipSC7Nj/lBFFlALKmXjA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=IeXFpzzxpkuQruloK3r1J5C2PuNNsCJ8xsPs51XZJD3y7BP7DvIsujOgMMwzpLouVW4yZD1wdcgQuxeQbGTocXctk9t4IDIoryzfYWNmvU2O3F/628EnNm2yTceuUEsPgNfv8XbX7+qpfl7PJ8o81e0wX6vGl22pEsGffdLoO84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=YD2fmkYY; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="YD2fmkYY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759953745; x=1760558545; i=markus.elfring@web.de;
	bh=sIsn48drRhUgcHLxe7oUIbYEFzcJb9uZ7GmMUzqxJ74=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YD2fmkYYyEy6SLBPux5CKDi1UwWe8DkxLvClOr1pvzkOWnbV77g2XgfcKQ4U4bMJ
	 dEPcvx3EqKqPt8+KUNMUwEqjWm0bYY/lyr4Q0V2w956tfOp0hIOB2H8zWAVqFAAwm
	 /s46/lugVNdEFwJHeCnNU9PDHhr5GGHHz86Wm2JTFU55jpEJ1CTwLY0x+zBLAgw7v
	 NtLK50SRhsPq/u/TG6AhXblPR9/GWaZ+WujWyX601548+WSJRVydbv0YG2DHmO1au
	 G5lIy2sCmHkADwYRzjEPr4K9J+6n6EyVEJIesdPKvsjQzyVrJTesfs6Ni+5LfEG7O
	 W+6QOLKPDNXQuxz67Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MIc7b-1v1Pq015TZ-004iBV; Wed, 08
 Oct 2025 22:02:25 +0200
Message-ID: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
Date: Wed, 8 Oct 2025 22:02:24 +0200
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
Subject: [PATCH] smb: client: Simplify a return statement in
 get_smb2_acl_by_path()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MD5Ba395weSpRff2FuTMt5xQcMQjmVUtVHP1KfRduSERKgKhuV0
 r7MkMbzO79FgbZo2Jwj6IHh2fcrIPzoICLC/uHZk5Vif2S+rqpcGsubz74lNRqH1QXwMFdh
 dsBXZYYNzOoiMdYYNPa0oYO9ns5kBmhjgVHwczNjgOxvr2qGA+WsLhGzQW2WtuKsP9aIhTH
 24RLosG7LHvLOeksLjYhA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ofDhCY9k1/A=;DcXZ1Ecy/D+Pdbkqg3z3dKTLjSA
 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
 KV2oE+ubGVIkifxHq4sLBkAmWQ=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 21:56:34 +0200

Return an error pointer without referencing another local variable
in an if branch of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c3e96260fd4..bb5eda032aa4 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3216,9 +3216,8 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
=20
 	utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
-		rc =3D -ENOMEM;
 		free_xid(xid);
-		return ERR_PTR(rc);
+		return ERR_PTR(-ENOMEM);
 	}
=20
 	oparms =3D (struct cifs_open_parms) {
=2D-=20
2.51.0

