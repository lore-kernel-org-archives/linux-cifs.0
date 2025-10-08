Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE952857E9;
	Wed,  8 Oct 2025 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759955107; cv=none; b=HTJ2YrQar123cSB/nP2HVjMNv9FIcMEFM3H4e/K/6u5THiURUnMx8oyjmBbGCC7ZEBf26Q+4/xXTibZ3MHBiOJuXd+F/RwSzn3fv25Ln5mkZvAeqgda9RHJ6RGOKs9U5QdX93lZv5sKDJ89EO/nZlsTy3L/3jjcATyrHEwmXK9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759955107; c=relaxed/simple;
	bh=Cf4uqEmEDg5eLUoPVw30DI7kswVXxMmTiwiPFPnJuNk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cG86lyt3Gm9+6eBAFugaTAwBmRmxnXH1xq/9YncRn9zxGvfkdx6qJ+uk2u39Eo42+4xcHIO8b6ZnWynvdl4TfbeY+h8d7+xCtpbHYRxYj6fpi81OK8jSP8x4kvMLSWIa6fVVopW5gjXAZVV7dRKvwjfjsTUI3jKpucUAfgOXFeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=KeF8//sc; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="KeF8//sc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759955092; x=1760559892; i=markus.elfring@web.de;
	bh=8KOpyCuLu7NRCnEauYvKAPC5UC9gog8ydIvIk3STNKY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=KeF8//scrO8kfnquCPMyvuTpfo9x9n/sOcWQyUsZ4hwx+rp8fZIM/Y9cPgFFyjNa
	 c/Gf6/RNrBUQldqOx+Xhw3SxeuIa4KOxrqu2tWDdYpy1LomaI6j5hSGenBiHCjBTN
	 rMJPHnria09rDllgIyDrkmKeePHf48cdLXmsK2zRxT4CkNZrIDbmx8/HsWO5Jj8pH
	 voCUPlzQTeKHdl5vvetYxE3uXg8oU797VALoG4MOPMtz8fmP9ht8YP2wJ+uEVeAHn
	 wwYKIo1gY316koQtSAwIM0eAZTRL/SGTGbzyn9vpXiMnu4qlDd0kTNxw3Pu78WxIj
	 M4tZJKkCwlGHRrIetA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgzeZ-1ud2mv0z6r-00p1El; Wed, 08
 Oct 2025 22:24:52 +0200
Message-ID: <91aeb350-89c6-44bb-8a2e-a629ee650c8b@web.de>
Date: Wed, 8 Oct 2025 22:24:50 +0200
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
Subject: [PATCH] smb: client: Use common code in smb3_notify()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9yJYHiyD7Mz62H3C+VGbbcA6hJV5z/iqp17nCrFoOUwA9QtGNZ3
 LJHHzW4uCsstYW+4Si0rYPoMoSlg0FR08BcbyTG0zhkqQv7sZZc5qu/tz9Y38mRESofIimJ
 dqMZU2fVE6TSTLrYUb0wiKxU9UnNlgpuGdSPCeCwruKfDoou8URezfbQY/GWxKiMGAaB9rw
 ZSYaqWYHGOTVep001JK/Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UNJ3+pqgGeg=;MgOczF33i8r+P8c1NNo92OujfPb
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 22:16:59 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c3e96260fd4..3a0fb4a4de86 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2369,15 +2369,12 @@ smb3_notify(const unsigned int xid, struct file *p=
file,
 	}
=20
 	if (return_changes) {
-		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify_info))) =
{
-			rc =3D -EFAULT;
-			goto notify_exit;
-		}
+		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify_info)))
+			goto e_fault;
 	} else {
-		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify))) {
-			rc =3D -EFAULT;
-			goto notify_exit;
-		}
+		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify)))
+			goto e_fault;
+
 		notify.data_len =3D 0;
 	}
=20
@@ -2417,6 +2414,10 @@ smb3_notify(const unsigned int xid, struct file *pf=
ile,
 	free_dentry_path(page);
 	kfree(utf16_path);
 	return rc;
+
+e_fault:
+	rc =3D -EFAULT;
+	goto notify_exit;
 }
=20
 static int
=2D-=20
2.51.0

