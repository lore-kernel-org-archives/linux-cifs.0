Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0721E7C12;
	Wed,  8 Oct 2025 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759956080; cv=none; b=hsM54e0TTsHM3vUFKCbUQ2xZbZ45trXw1NvKn0Cd5Y912GoSManBUTZ6RYwNgFgWyTDODB5vOln8LrqTyxKTFKEFa+hyOFAQuRdEL0+p43i4ut61gFmnX+uLMqu81Fn+PLMKp+oVTuiLgqSuBhyTEu4HaT0Z6Kx1cQXKwedEHrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759956080; c=relaxed/simple;
	bh=beN3vK7ps7RCuCOupt7SkhsfP7v/uNyCfmZkmT79BDM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=hK4giafkZRj1+JEfwEXd818ladu2/ZBR2XQgHhx0K7/FMCbtRErn3jkAMoNMI/AiDHTRIyBAfNOadxEPcOgeDxLGtBSpndKSRsmG91JGI2tWTbeSmmRYrOCVoRw0FPyA6COdBjszJ2EQP+JjX/1IwPj8v3Dd/R0VFdHQ9dHJEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ZXFL5J8Z; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ZXFL5J8Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759956053; x=1760560853; i=markus.elfring@web.de;
	bh=6lTeIHoBUZkZrEUW1aK0fG/EIZX44Rf8fKn5ChXo+bk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ZXFL5J8Z0al7d5GIaCBf+YXJZx+y//3S1LNPuuB8jZUyL8eARBdcFD8O86dgTwx4
	 VypoEE3KOxuTEkHWfkDxywYr6vS/VEX4rUjciTDK8y3GAae82L9fl1h1HducQplIp
	 klmCjSBuJ18iAZ5Uy/UDXjAupFMqWo7dvnSs6YvjOR+WTXcIMrR4lquzYK1efAXvj
	 B40eC2bl2O6NbDdpEoneBgcWGG9Ag89uRov/PdmQRmrxShA1KY2OK/aBGcbZfClho
	 thANplf6BJsD+llHgmKPJMK3DDxCsH3/ZHV4c3u7PYTRElh4BtQxQmJJAAmBWRp4o
	 LNIxn3CokZ91x950OQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M28SB-1v93wS3Oun-0098BH; Wed, 08
 Oct 2025 22:40:53 +0200
Message-ID: <9bd9d534-d0a8-4058-a26e-622bf15b804c@web.de>
Date: Wed, 8 Oct 2025 22:40:52 +0200
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
Subject: [PATCH] smb: client: Use common code in smb3_enum_snapshots()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jlqoS+6ftKRes76C/ohf4DhF3wdoiP5/5Olt0UnEWdQsCeE+no1
 9awbYIT/KomL3YDd8XNRfNSIzemRPSn08wIQo20MyBUU+0JS+v4QNmYLEZh7HdVlBj+lMde
 A8cS4qvQJLV2cHS9Yzk3xW0Q5BgnFLI7GyyGPy13u7laKxScFMQmFaNQZfoM7cwfo46h9rY
 fdmWDQrVCHzelteZXw7OQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hhfLfCZJ+x0=;MxpxvN4WTB6nc4zJvnWROSZ9Sk/
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 22:35:48 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c3e96260fd4..6ca3046443c1 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2301,8 +2301,7 @@ smb3_enum_snapshots(const unsigned int xid, struct c=
ifs_tcon *tcon,
 		if (copy_from_user(&snapshot_in, ioc_buf,
 		    sizeof(struct smb_snapshot_array))) {
 			rc =3D -EFAULT;
-			kfree(retbuf);
-			return rc;
+			goto free_buf;
 		}
=20
 		/*
@@ -2329,7 +2328,7 @@ smb3_enum_snapshots(const unsigned int xid, struct c=
ifs_tcon *tcon,
 		if (copy_to_user(ioc_buf, retbuf, ret_data_len))
 			rc =3D -EFAULT;
 	}
-
+free_buf:
 	kfree(retbuf);
 	return rc;
 }
=2D-=20
2.51.0

