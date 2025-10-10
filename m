Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB856215077;
	Fri, 10 Oct 2025 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760099303; cv=none; b=cqNuob2QgnbOx4MMpJ55q26tfdgwINiUJhuUaG73zYniYMhEKaGfmo6iS0D3pyrNN9iBXFNTzu3NNEbXbGZr35torU+3Dem7QUixgK9yz9h4UhQWJJ2+TmpoBBAte8qVC4T/UQJMv1B+/fTfuT3GrvXIZgpxY1sIuSRK8NJDceE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760099303; c=relaxed/simple;
	bh=K7WAWXnuIkVDhAdy4GZZ456NqOYZQpGLUFGaZhM7YdA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YQT1YT3ubMWe9NRYTPhbb7YDpgnpaUZ1HRBEFr7RN+0NBOdc+okdPfgcV2UO/DI2+M33Ojp0IxV3JszERtQKrSPsG5PrMnJIzwpfiqnA9LMqhAuRfDpg5gTy+KEOnVV8yrq2rJ9r1rawuqq88qVupusSNmez4LLYPtMw38mHavo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=pRBF4v/1; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="pRBF4v/1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760099295; x=1760704095; i=markus.elfring@web.de;
	bh=qgiLphkHctI4om6fZBl0hhcpDQgzybIDQu3oVYqySfo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pRBF4v/1pAp1u3br/jps2KGU75sVdgyDXZQhfHqz/sbg35tV5YmB3KcdNJKCLyG8
	 oOoxtZW8ABapVx6ilJfi89XUUL5cBFz3Z2qWVSm48ZaKjQtkhL0kfM3bcTm6BUpHH
	 7vQ162pHC4xUSFZLRQvFhszwgRuuEvBlVB4KMfkVNItlXaOksK1/1Yf5uCIqv/Iul
	 f+IRrzltFU/57uDlUFtDx3IPkqbdO2x2/d3TdoclXOpr1QnQHuy5IiEQUoB4hZzP4
	 CHWToocb9peLtpIGwojatBSZNfZQrXI4kPP/LwlVJ6XzMd/a1qpgK6aG42iEH83m3
	 6Fc4u7mD//aQQlCrjA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MQPdl-1uuBW216HZ-00M0Gf; Fri, 10
 Oct 2025 14:28:15 +0200
Message-ID: <ecbc86ff-4556-4446-8205-066b633dbe40@web.de>
Date: Fri, 10 Oct 2025 14:28:13 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>,
 Boris Protopopov <bprotopopov@hotmail.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Delete duplicate error code assignments in
 cifs_xattr_set()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:o5vBfZv/0gceNE/VWRz/dYaTOSy/7ovaYit4J6U/qHE+hIz6PBK
 79AkK2yUZdUP4NcRoJBJDsyF5jiZ84+cLrf7qGg0C8/I6DYBYy50pnfQrAQ7wEBINV55d2E
 F7JOJnMoYFko33kfTUq69VMvpoEaP7kYEVEk3zRueTvP0OxYLyt81dSpNKvczRFOLMWZdsH
 5urGtOwJv+BW0wx1XxvQA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bOT5wsygbLo=;4OwWzk2Yu0o7steuKXIP8CVN2s+
 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
 eCOaDJO6Z34C1WMwm6yxPjG+vY=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 14:10:22 +0200

The local variable =E2=80=9Crc=E2=80=9D is initialised with an error code.
Thus omit two repeated assignment statements according to this value.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/xattr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index b88fa04f5792..a74d12d36176 100644
=2D-- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -127,7 +127,6 @@ static int cifs_xattr_set(const struct xattr_handler *=
handler,
 		returns as xattrs */
 	if (size > MAX_EA_VALUE_SIZE) {
 		cifs_dbg(FYI, "size of EA value too large\n");
-		rc =3D -EOPNOTSUPP;
 		goto out;
 	}
=20
@@ -206,8 +205,6 @@ static int cifs_xattr_set(const struct xattr_handler *=
handler,
=20
 				rc =3D pTcon->ses->server->ops->set_acl(pacl,
 					size, inode, full_path, aclflags);
-			} else {
-				rc =3D -EOPNOTSUPP;
 			}
 			if (rc =3D=3D 0) /* force revalidate of the inode */
 				CIFS_I(inode)->time =3D 0;
=2D-=20
2.51.0

