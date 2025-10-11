Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817161A4E70;
	Sat, 11 Oct 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760182190; cv=none; b=DSXjRrZ0Ck4n1pMnvis37OaHmDR7A3jwZXEcBoWOQ5U4FDYpPqpzKYQUGbeDvxZt1bh9qEnT8yPI72DXFptoE7GEyqULPRpTJpA8MKitVeS6DzHfevE07syrr3mjP+mNmw9WaPJnqYVt8CA1vwQsVrrXX371Ab2GCY4kajdLWOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760182190; c=relaxed/simple;
	bh=vQ8j//ib7mzyChqooGbkskld2hi3escz+VXHmjWvah8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=L9bNW/mVMmxOX72BFKzigdaXJpxCAVkpyqzavAZJo4hCqi+f5f4NvvD/ywiWQfG0JlFJzKEXgvYrudMuAl9hGLZ18B3PfuA3m3h6izEXk+IlTnZmy2VQykRVZAu/C2fF9WIhrrgNccSz/AKDqEGcn2T5O5XF8TgxBBbCBmi9Or4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=goTHad9G; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="goTHad9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760182152; x=1760786952; i=markus.elfring@web.de;
	bh=rxb08qbYXiU5CmAhgTnrcQeux9UBcFSnHk1sB/pva5Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=goTHad9Gad9T0F9KIESyAwHiHXij7J4Wh/DPIBcngMf/rOyaNdwF0iMWXZ//R3Qm
	 ZwtSAtmBwqJLDgnW4ZxBExW1BH5WCxmYxqNJ7c4bVdPwFahBndb6/kSWO2UAqhboP
	 DJqyB+GakTuP/s/w3qlg/FJWGTW5i/nhNvMIEWL1NENhZqipePRxWziddb19blY+N
	 WfzNUdVKOqXUyKxyZzPh2W6jAo0gUSa1A1VQGhUZjt8sJrxcJxIxlngAWrewP4w5U
	 9+yNBFsInpBtAcQ/2W+XSYzSuoceNenkbS7DT2oDUOvsm4hE6IyWZ/v1adTsaqfti
	 4uYJBPGOLx/O60W6Jw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.253]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mpl4z-1uTC2H0HpV-00px2r; Sat, 11
 Oct 2025 13:29:12 +0200
Message-ID: <42c711b8-2c96-4538-8415-f6fd82d080d1@web.de>
Date: Sat, 11 Oct 2025 13:29:01 +0200
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
 Sachin Prabhu <sprabhu@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Xiaoli Feng <xifeng@redhat.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Delete an unnecessary check before iput() in
 cifs_do_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:J/sItCB7jjJbCayJiqED+PEJGY7SgTzfTV8Jh6WOEyx5yhwvDRm
 gYfMxSNIUEVrfaF2d5a6Ae/JBoFWQ+TnGWmzyiKE6r2+fPOawKFX+vhLveZ8+SCIhCDtfZq
 MEOx0+2Chl7Hbt5VLEXdusOfYckvVTU0iCWL3/QHZjpi+eGO2HS9TEGdz66j8SRJdPkHu9q
 LXj2quSdt0FhQTdxAMpDQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3IaB2s/Von0=;EA/ILUJlF2f9/39Etmpxm3lAERP
 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
 tVLBSDvkSOyN6AmvXq2ODxCvo0=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 11 Oct 2025 13:20:10 +0200

It can be known that the function =E2=80=9Ciput=E2=80=9D performs a null p=
ointer check
for its input parameter.
It is therefore not needed to repeat such a check before its call.

Thus remove a redundant pointer check.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 694c362740a9..27dd20003976 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -450,8 +450,8 @@ static int cifs_do_create(struct inode *inode, struct =
dentry *direntry, unsigned
 out_err:
 	if (server->ops->close)
 		server->ops->close(xid, tcon, fid);
-	if (newinode)
-		iput(newinode);
+
+	iput(newinode);
 	goto out;
 }
=20
=2D-=20
2.51.0

