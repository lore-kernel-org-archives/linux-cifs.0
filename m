Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3663314286;
	Fri, 10 Oct 2025 06:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079027; cv=none; b=UHKQ6I53WduxonVjfES7opNmnJTB7X2WZNNBpRrLsnRA/qYLaIvwU6mKVTV07oLsHPOJOr4dgbgr1rFfhhBl6cHSdh7mKcWukbgyRzadiRAaEkfA3mk8JvYouMDFA7d8n5miqFiwqcFOpL5KpuwAaIi0jGljyI9LoWbgGW3AdD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079027; c=relaxed/simple;
	bh=9oTPT80KQtHoFr6byfd8IwnqAmN6PH7Gro2/SaO5Vzg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gs6mYf2prTMLkLvrJ5++OjxC1st8lCaWtQaOp1Oteh5UIuUner8M5QMBW3M+cZA+th6K5vsJru+OWRBvGoQgLokki5KAmcQEl5k0i6d9D1TCqc62lr/PKWY4JZutom3+WJOAtov/bnpDH2xD4kpB/J6NPeTVwC5tZXs9RKMC2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Rc7XYu31; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Rc7XYu31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760079016; x=1760683816; i=markus.elfring@web.de;
	bh=nT1IPHJT6pYJk+zo8hpAp+JC7qYfjTYKx8JEeow5mjI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Rc7XYu31BNZS8fZA6bbuhuENscAj2EwVZL53w87XgPJ3LGrduxh/EfcEGOjqBVE2
	 OnxzSHmNxlhqeR/dcukTVRpw2dktGDAxBLB/X4dlQirovENnrCYdMfqtLHAvmvbl7
	 qXvfZNLcCQESD3p5zn/nRWLCrR3VtfyL2GjUoHmnohWJLEM8u4z/4FKRajWF1XBXu
	 8sOznwaLEUVVgNdmF1V0fB7A7qAufRcgQMuq4nYStrG00UPv/GY3r6SvvjVtVmj8b
	 IEpzJJ1QNGwTjDs4v0pnOXFqvMBEnza+A+lGcNbYDb4AC1hQ4vhNKD/9m66APrHgk
	 YnNY6kfSjuI7tRz9fA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MumNL-1uH4dH0nSt-00rV86; Fri, 10
 Oct 2025 08:50:16 +0200
Message-ID: <1b57a6e2-1169-4eff-8a08-34a7d1263a51@web.de>
Date: Fri, 10 Oct 2025 08:50:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/3] smb: client: Improve resource release in
 smb311_crypto_shash_allocate()
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
X-Provags-ID: V03:K1:4dLrL6U2CFwfH9aygiJJ+30x3DIJGutBcfSROSae/yJN4KWVm43
 6SAKXGcWP78NYqRo9yQVUYAdOo/rpV9R9dKVdWVrQ3mCqkdtu6FUUG6Vk7ST28ZEx2s2foF
 4RFxIzZPJPHIFy9JlO4ZbHq4afC5ANBZWVg+c1mxtHCxKq4Tu/EQxxFmHq6Jf5BWJqX7Fmw
 TeTvcYM777rw9/oCNVWjw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oKzSr23bjXk=;ph98ANHz8JYfgt9ZYn4nN39YkSy
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 19:00:11 +0200

Adjust jump targets so that cifs_free_hash() functions will be called
in a recommended order at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 499b00c2a001..b790f6b970a9 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -58,16 +58,17 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *s=
erver)
=20
 	rc =3D cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 	if (rc)
-		goto err;
+		goto free_hmacsha256;
=20
 	rc =3D cifs_alloc_hash("sha512", &p->sha512);
 	if (rc)
-		goto err;
+		goto free_aes_cmac;
=20
 	return 0;
=20
-err:
+free_aes_cmac:
 	cifs_free_hash(&p->aes_cmac);
+free_hmacsha256:
 	cifs_free_hash(&p->hmacsha256);
 	return rc;
 }
=2D-=20
2.51.0


