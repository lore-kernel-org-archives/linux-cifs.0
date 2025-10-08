Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FAF285C84;
	Wed,  8 Oct 2025 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949321; cv=none; b=XVE/EOxwM2stjnFvoC4cJtEHAuRz5YsDavF+MGJqRYvskbzvF0OQpRq8kmGAscjZwboYD0FqG2VIjSWNanoeGeA9Ss36uCsrVrHOjGRM6WablXudfjs4HrQ9QSzhCz/8pYd39Sjv7T4flnEezVhotsaqJuNPm8UXaYgXUs8Utbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949321; c=relaxed/simple;
	bh=jvz4hQQprFERu8Y4QC48jKP2arg/YE818VdxU0LnC6A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VSNdzUNuyX8opdEcELm0uAwDuX6a5qaX6CcKYkck3PIWM7VCVEQ3rt40AqJnVS1Lbj+ewUkpbVGrx3RLrYSdHUFPO42TVzNs99wQdd6VsUo2EO82ptEoQ7zKzq27Xl1mRJoCHrON7BDDFDNEoM2hkd9l1gNfEnOs6U++CJQTk2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=gzpHl7fQ; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="gzpHl7fQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759949309; x=1760554109; i=markus.elfring@web.de;
	bh=s/iybpUxtWfOPWONHDwLJ5KBogRZkckz5wuixrswvgw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=gzpHl7fQ4O/mcU00JGyUCzpZp7KUTyh7MYhhjNtGSTkR6mjqIEZ/2HYw0fXQgmli
	 vMaa78QFjyubh42MTTwdtzg8F7ImkshMFN02yckJtDkEIi4HkaaVwLdSZs2dKQKhC
	 faDZnPvmYUOTSd+y7TRTJPW2SGeRJ3xntM9swFc5XZU26JHTedwCyWboTX7/BPJoB
	 UABNHUaR1fcmDR7OuOb1ATn4qRf7iqFUv9xOt7wTYRG+KkX0TuMXbLCQ6Z4gddRKS
	 J08Jwvq+0oDLxWRCQvo2qc7gTnzIhNEx8ploClYySxL+nCLcOVz+0raQBJpCEIhVT
	 bW1Zqkv9Yy9++XsJcw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1McIgY-1uYLNw42JA-00kMR8; Wed, 08
 Oct 2025 20:48:29 +0200
Message-ID: <7cf9389e-8290-4b53-9b5f-813061e28572@web.de>
Date: Wed, 8 Oct 2025 20:48:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/2] smb: client: Improve memory release in
 smb3_simple_fallocate_range()
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <98b5e2a8-4bc4-4282-987e-01cd6fcd8f00@web.de>
Content-Language: en-GB, de-DE
In-Reply-To: <98b5e2a8-4bc4-4282-987e-01cd6fcd8f00@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mRt4DQcLWQxFP7mTCxpGzKT4CK7tKie/4P09nFr9EsbWvnHUtsI
 Zls7BxNWNPfNbyl5GdLLOiL39kWuFsAXz4sRBxqXbTb7P/xVD7qWdVMAC/lQCqXOlyC1TLA
 whL6wndX+3PKp6W8U5ovMTQ4h2HVCB+claGUIDzflfSZF9auV4czw1Mk+F5t7JKYG6mPMXR
 6On69NR3PWDi4KXlZ/P4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2dI/FkvOGWM=;Hscco8QvudK6qcyMY/aE+Wzixgq
 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
 RWsJykrs30NMWht8SAzkQN/VkI=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 20:21:38 +0200

* Adjust jump targets so that kfree() functions will be called in
  a recommended order at the end of this function implementation.

* Delete an initialisation for the local variable =E2=80=9Cbuf=E2=80=9D
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ec188dedbf97..38cef1ff3826 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3557,7 +3557,7 @@ static int smb3_simple_fallocate_range(unsigned int =
xid,
 	buf =3D kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf =3D=3D NULL) {
 		rc =3D -ENOMEM;
-		goto out;
+		goto free_data;
 	}
=20
 	tmp_data =3D out_data;
@@ -3568,12 +3568,12 @@ static int smb3_simple_fallocate_range(unsigned in=
t xid,
 		if (out_data_len =3D=3D 0) {
 			rc =3D smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, len, buf);
-			goto out;
+			goto free_buf;
 		}
=20
 		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
 			rc =3D -EINVAL;
-			goto out;
+			goto free_buf;
 		}
=20
 		if (off < le64_to_cpu(tmp_data->file_offset)) {
@@ -3588,11 +3588,12 @@ static int smb3_simple_fallocate_range(unsigned in=
t xid,
 			rc =3D smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, l, buf);
 			if (rc)
-				goto out;
+				goto free_buf;
+
 			off =3D off + l;
 			len =3D len - l;
 			if (len =3D=3D 0)
-				goto out;
+				goto free_buf;
 		}
 		/*
 		 * We are at a section of allocated data, just skip forward
@@ -3608,10 +3609,10 @@ static int smb3_simple_fallocate_range(unsigned in=
t xid,
 		tmp_data =3D &tmp_data[1];
 		out_data_len -=3D sizeof(struct file_allocated_range_buffer);
 	}
-
- out:
-	kfree(out_data);
+free_buf:
 	kfree(buf);
+free_data:
+	kfree(out_data);
 	return rc;
 }
=20
=2D-=20
2.51.0


