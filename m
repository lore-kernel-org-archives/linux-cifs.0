Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C421EE02F;
	Fri, 10 Oct 2025 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760078919; cv=none; b=KX3DYIJjnQmmKMLjoYqeHbc3YkMXdO9fviC9SOjJb2ArCl4CQEGOzNv1OQUK4yoETDGRM3tlQpIaaW2IhkANK68/dTaoubvZ2OqnQEs/tGG3wNg1lbxMDTPgsBAueXXrQTSPRCa5pTNVK37OhdHkVZei7+zTPKPzGEOPNbqShsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760078919; c=relaxed/simple;
	bh=yGMJL4r/hPPWWsmbfgMDurf00zj1v+5RxJ6eKvcssl0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PpG6bUA1C+G3RdQnysJg8olbc0hD7B11JUXXPTkgk004M0Iy3RqOIh2Lj6RVtTyOqSeXuK3Yuz5sIMgQuVSzerVPymbHlm8zujHWG5DLzWwVDBEBB7ZTvtw3NdKE5BnIyr51UxXi8WD+NhnRBQ4dyr8PwaWs4kajsWmNYoDHbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=pim+eoUL; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="pim+eoUL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760078897; x=1760683697; i=markus.elfring@web.de;
	bh=vtlOIxV79j7jAKZ3KTd3T6J1uCqPjRG1lvZ9ZafTIXk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pim+eoUL/CiW4amHn/Cz+3q/tB3PbSBe57YYEArHrSBkn0dlGP05LwP+nbkPuKDp
	 Ko/NX6sMAu+RSS0g6Wfne3/yU4Q3QhjPYjmF2qQGGmlKMNh5izeAyqzkyC7aKrR9o
	 RUYCKMLMvosWx2WNuzcj+sMLG9cqHtADU3UcEB1O5JMtOh65yNwLEGxXuFwKWkVes
	 oG/ekGd8iVG1yvXjJtQhUXkXZRXSdJ/K54s8kBlbf5ilEGCT7XMhGSuQGJk6OVGMX
	 J/bVQVB13Lm7gH8ZhjNLtsU6XzLVf8uYUKqYOizuO7riqJZ1rTJJJeqb2akMYDmPm
	 xhvRlHLNLvfQinehHg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MpTxo-1uSFJs3Y1E-00qE45; Fri, 10
 Oct 2025 08:48:16 +0200
Message-ID: <ac955d29-54bf-4c02-8ff6-828331093b0e@web.de>
Date: Fri, 10 Oct 2025 08:48:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/3] smb: client: Return directly after a failed
 cifs_alloc_hash() in smb3_crypto_shash_allocate()
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Language: en-GB, de-DE
In-Reply-To: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Hly1mcRc7VJTGn5CNiKoyWkioXlwTa25P9lGt0G+DUE+EWP7+0O
 9YQNAGq5BG2SUGIz4K+zY2vMlWb4+VG5pBPHNx+itma/RRVoNaatv+P/3KB9YY+9R7lb4Pd
 JzgJa/eitQ7rdO5/bqxIP1cyJmNX8QfmYo7hBSMgQUAcTTQPqpd3YSfcxcG6EVUkYGLxKE6
 BdnjngUPipCEZoVqvvxYg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ftcd9FwjS6g=;9pRRixGgXh995XLh649btcP4pUd
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 18:44:53 +0200

Return directly after a call of the function =E2=80=9Ccifs_alloc_hash=E2=
=80=9D failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bc0e92eb2b64..499b00c2a001 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -34,7 +34,7 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *serve=
r)
=20
 	rc =3D cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
 	if (rc)
-		goto err;
+		return rc;
=20
 	rc =3D cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 	if (rc)
=2D-=20
2.51.0


