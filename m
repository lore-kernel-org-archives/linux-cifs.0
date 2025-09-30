Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A529EEBB;
	Tue, 30 Sep 2025 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759239046; cv=none; b=Nx/K5+RGxJ6KZuDZIGnc3NQ8EJwQNRKxkPR+ynb7ggD2B6W6z8YgpNrbn4kFjbzRVTYnCRULC06c+62w3tkAchEgzC+pVhi9RH2Z/9zqzX4fZGYUOWNf/sn3zgKB+6mRvnVkRZPKPhwSghoLwBFnV5kgjS3NhF6A/L7cci0+KvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759239046; c=relaxed/simple;
	bh=1iB2rFiqSRzC86eR1XunIclm90qCjF+76ftrrbH6K0I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Z+kLCCy06bE34gyWdpIz2BWh/S5qkQNan82t+3fwOPw7g3dPjyag3ZFVEr89AikI28xCsjNuFqpQEtkXbafCsyLcvKwvBhQrxWayxb94hGZFxu22B1DNdDYW/IEZvpzhTD/W7MBPWyK8HBnTWx2naxfV4VcZyfMy/JieRGjDj1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=LQyUFAdr; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="LQyUFAdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759239035; x=1759843835; i=markus.elfring@web.de;
	bh=c/TDAFHTnlzFzOOfwrkJAqEibkW2/L4ATyHPWH7lbyc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LQyUFAdrRCtQ2jGndcfzrD8rlcpgT0xfEU7piFGKrEGuaYE27hTmc4VSx19cyR3M
	 4AatMvVU1KONtiVxQct8DEzAVGA6bc4FXXho6OiaGL8/F95+7u8Rgmw2V57L5BtU0
	 UtsLybep+5COmD1TD0h4WmB6K59CsyB2UsZ/r96bhjfwNerf+EpWcNSqy3Mnninku
	 laVFwGBWyG2nfZU7Rgtp2WJlxefkxISD+6aA5ZwbTerDIBFoaEAnvP4hQSDJyAccW
	 2jKHm+tJHNJHgTwRwbtTmIOOKWEdxfss4pluytQoi5NL8HDXJ/9uWMeIee8C8tS33
	 GGw+B8lOevbtQKH9ug==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.185]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N6Jxd-1uEW4Q118D-017Rik; Tue, 30
 Sep 2025 15:30:35 +0200
Message-ID: <84394500-a8c6-441b-8ad7-8dab2b3c1852@web.de>
Date: Tue, 30 Sep 2025 15:30:33 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org, Matvey Kovalev <matvey.kovalev@ispras.ru>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ksmbd: Use common code in smb2_get_info_filesystem()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Aqu8A/8E3pMPcIA1wJ9wdkSCWLyBrKQqViMrqzD4cyTzexcWFGR
 /rxUpDuBkuQ9ZjG0k7NBZkuoJLD+pM3PVObhes3qrknM7U3UeXneqP21oE4JbxP6LifJM1o
 rg7WTad25tBupJE59Y2WqfeaGJUI6kOpJ7YtddVm5BOUtLyyKyI6bGhcaoWopNU+a4eo0ul
 R67OZBTRdGyOnMCoz0wzQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZKrQ8f8rXN0=;+L4c3n133N23cLbRJqmMFaYio6+
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 30 Sep 2025 15:21:37 +0200

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/smb2pdu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebde..1d70278890e4 100644
=2D-- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5459,8 +5459,8 @@ static int smb2_get_info_filesystem(struct ksmbd_wor=
k *work,
 	rc =3D vfs_statfs(&path, &stfs);
 	if (rc) {
 		pr_err("cannot do stat of path %s\n", share->path);
-		path_put(&path);
-		return -EIO;
+		rc =3D -EIO;
+		goto put_path;
 	}
=20
 	fsinfoclass =3D req->FileInfoClass;
@@ -5629,8 +5629,7 @@ static int smb2_get_info_filesystem(struct ksmbd_wor=
k *work,
=20
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			path_put(&path);
-			return -EOPNOTSUPP;
+			goto e_opnotsupp;
 		} else {
 			info =3D (struct filesystem_posix_info *)(rsp->Buffer);
 			info->OptimalTransferSize =3D cpu_to_le32(stfs.f_bsize);
@@ -5645,11 +5644,13 @@ static int smb2_get_info_filesystem(struct ksmbd_w=
ork *work,
 		break;
 	}
 	default:
-		path_put(&path);
-		return -EOPNOTSUPP;
+e_opnotsupp:
+		rc =3D -EOPNOTSUPP;
+		goto put_path;
 	}
 	rc =3D buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      rsp, work->response_buf);
+put_path:
 	path_put(&path);
 	return rc;
 }
=2D-=20
2.51.0

