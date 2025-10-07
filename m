Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B6F1F3BA4;
	Tue,  7 Oct 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759848379; cv=none; b=UidOoWwPVlZjE9RQ2D3/R1Zjds3F7g3ycKZSfwxeLP8+idlK6ubH0t/8w3h8KP78/M1QBbCpN/Mj1SbMqgWmDSyGaxzp6izr/uvOezAqLf43sK5vEFcadKFm1AVqaloXshZX/eedLCPFR+2UBDhOWlKBM/bQmNVkz0iTZj6FaEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759848379; c=relaxed/simple;
	bh=qpNjxwNibw5NzkF2mH3vS3U8RFw1xUqdMXdg6vsThxc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=W5b/ZcsgxD6ZPSL6Yw5pFgZhVRRqDdhEpcPxxJfhVF/Mag6o6DGe4XWSQMt3zBxTX//NVtHfP3OIsvl+FCBiKASr1PTco265TvG2LP0n5qLEQJLJzI0yPIckCXZemZ+hhYxYXeaWxXaMG6Z2J139PGqRYF6G1uQ7FmXcOgI9tdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=sTUY4Hli; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="sTUY4Hli"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759848360; x=1760453160; i=markus.elfring@web.de;
	bh=QJEoOh3XKzsWVxo2yAKGwvITj7AmDQGSnoLkfhq1hJk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sTUY4HliqwthlI9k941J/icPh57B1FS1/1yzL3qkdjKzjYTgXmW98TXC/Uw2BvAo
	 kb4GQyOshr5z63jPIMcdZJEjvtKnvkxNhiBqqybiD11d+SOvIiqDSEGgD5eXNODo2
	 5YhIM3S/xowq30oNFwRDPiX05Uni9ush9aeqELR6/Y/5f5PIYCu6XT5gdJYPPwKB/
	 i1icxlAKr6n5RYL35Fgq0h6MijvBypJg+pF8oDf+oIQ5jLkkLKsgSBrVr/FYm7FFH
	 60gv5IiR5DgCIX7RsHO/E5czYiUjGw0Q5AcEDhTjtUQOKToUNuRgtYzXdwH5oXXOx
	 73GxKPjK7Qh+VtLxSw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MDMv4-1uwkkY0UuU-00Aqeu; Tue, 07
 Oct 2025 16:46:00 +0200
Message-ID: <6de9dea4-205b-4fb6-a785-498ce31636e3@web.de>
Date: Tue, 7 Oct 2025 16:45:58 +0200
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
Subject: [PATCH] smb: client: Return a status code only as a constant in
 cifs_spnego_key_instantiate()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:h7Rd8JrZwxJVGWDRQ5I8n0mqB6RSdzCrLILEHqC9V/WcQ0JVg+B
 huygjfVRaH/skFK5OT/V7oigFPMKnVSGIUJVhH2z/mhVRO7DzzGPVjxfCO38xQ3PyGh4xdC
 qmQB42NbBy9izV0oddJRv9htV55KeAdVj/qr4E1t7Iqvlxuf2z7dmXoujAfVTHUny0KNhZQ
 NCbZldWSaUHUZQp15U9PQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:g4VFSaTGvHY=;WNrPFoH6Olew0XrgoJGjFozZI/l
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 16:32:25 +0200

* Return a status code without storing it in an intermediate variable.

* Delete the local variable =E2=80=9Cret=E2=80=9D and the label =E2=80=9Ce=
rror=E2=80=9D
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifs_spnego.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 43b86fa4d695..9891f55bac1e 100644
=2D-- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -24,20 +24,14 @@ static const struct cred *spnego_cred;
 static int
 cifs_spnego_key_instantiate(struct key *key, struct key_preparsed_payload=
 *prep)
 {
-	char *payload;
-	int ret;
+	char *payload =3D kmemdup(prep->data, prep->datalen, GFP_KERNEL);
=20
-	ret =3D -ENOMEM;
-	payload =3D kmemdup(prep->data, prep->datalen, GFP_KERNEL);
 	if (!payload)
-		goto error;
+		return -ENOMEM;
=20
 	/* attach the data */
 	key->payload.data[0] =3D payload;
-	ret =3D 0;
-
-error:
-	return ret;
+	return 0;
 }
=20
 static void
=2D-=20
2.51.0

