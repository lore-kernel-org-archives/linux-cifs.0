Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665E1A83F9;
	Sat,  4 Oct 2025 11:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759577852; cv=none; b=ftnlU4tmtIPlB0F3HZS++SjTkUPsxx16c172SkX5GiQ27IjueJlyeV7zBqvfkOQf3MMhCr8MzZiXxthwY47nDzmyQxCXJ0lP1biUiZSc6UeVVBwrDoNYvwPw8s26OEfASdRVqqXg4clD0AjGZ7dLDqVo8K0ZdstOcZXET2FIvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759577852; c=relaxed/simple;
	bh=ZMwJ94JZSndxN2070LKEhVYMAa3Woj6Sfn6AMz7xuSc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=o2q60hACdynQURc+1ia9gadBhSErrf20Q92jH3gVfRx2DjxEZpYUzH1o2656U8MzE22kvXXLEk8b4Fs6L54VTmSRViNjN0vgNgEX/6GYe9QENsKwlvqKQsO+py46fGRRSy+KaIsoM7kl+UTvJAQ4Vq21jBY1btlbfAjr8IZ2DUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=JBmXJMwI; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JBmXJMwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759577825; x=1760182625; i=markus.elfring@web.de;
	bh=HKk/p/TS5yX8/Fbq0swMeIhFh6TV1S5qYhu0g+U1Mpc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JBmXJMwINu99OTPvhAVjSQKRasRj1qXvWWXSdMZw790J4GyKFC7JIJBozVqUTxYK
	 AZc0xG24a+Krfy943IsUgNxasufUIwOwJNPM+9dlxMsbkqhq18Q8RNoG/X2RFbg8L
	 4yrIpyM/D5yg9OcvZc0SPaNHH6YS74OFuQnR+JfGfWLPOPE8QgjpoH+Cxn9NDPxgy
	 bOVfpKJap4OvWFm+ThzqW1Ogp5OEX/cV9GIOzcAHQL0IDXeOnjMUDtoThCuy1goYG
	 f3yvZmnBWTzfbMN4psoA/Ph8gb0BYI8qDSPqxB0P/0Q/T8Kubqd/x0AO1HJSBpi0g
	 n1kN/wS5Carrxdt52w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MnG2C-1uOHI51smq-00iUvZ; Sat, 04
 Oct 2025 13:37:05 +0200
Message-ID: <1abbfe84-e3f1-4163-9789-6ec49a3ce821@web.de>
Date: Sat, 4 Oct 2025 13:36:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Neil Brown <neil@brown.name>, Stefan Metzmacher <metze@samba.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ksmbd: Use scope-based resource management in
 ksmbd_validate_name_reconnect()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:30zlWL/vsYH/8dKaHWL52jHbcZAoIA9hLosEgNIdMvBeSL7X3KC
 ++Ek5EuIzWXabCyhkIoN2j5HU+4ImJJUqiMYT93klvm+BjDrbEP01R/Sxi+w7jAT9JbytXj
 aGtELHQgWzg2v2CiWdyBz1QbxmJW7sk8d3NBbg+xYwd9elS7wEdSWkJNajiLpIJnETiaveE
 bX2sGfoyxmfbZRbr58DAA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EqOcctrBT5A=;IFzq6NNB+F05BvoWnAPH+jAhrBJ
 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
 0kxCWnwJEon1/MFX4=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Oct 2025 13:27:12 +0200

Scope-based resource management became supported for some
programming interfaces by contributions of Peter Zijlstra on 2023-05-26.
See also the commit 54da6a0924311c7cf5015533991e44fb8eb12773 ("locking:
Introduce __cleanup() based infrastructure").

* Thus use the attribute =E2=80=9C__free(kfree)=E2=80=9D.

* Reduce the scope for the local variable =E2=80=9Cab_pathname=E2=80=9D.

* Omit two kfree() calls accordingly.

* Return status codes directly without using an intermediate variable.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/vfs_cache.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce8904..af8a16879b88 100644
=2D-- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -933,27 +933,22 @@ void ksmbd_free_global_file_table(void)
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 				  struct ksmbd_file *fp, char *name)
 {
-	char *pathname, *ab_pathname;
-	int ret =3D 0;
+	char *pathname __free(kfree) =3D kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
=20
-	pathname =3D kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
 	if (!pathname)
 		return -EACCES;
=20
-	ab_pathname =3D d_path(&fp->filp->f_path, pathname, PATH_MAX);
-	if (IS_ERR(ab_pathname)) {
-		kfree(pathname);
+	char *ab_pathname =3D d_path(&fp->filp->f_path, pathname, PATH_MAX);
+
+	if (IS_ERR(ab_pathname))
 		return -EACCES;
-	}
=20
 	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
 		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret =3D -EINVAL;
+		return -EINVAL;
 	}
=20
-	kfree(pathname);
-
-	return ret;
+	return 0;
 }
=20
 int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *f=
p)
=2D-=20
2.51.0

