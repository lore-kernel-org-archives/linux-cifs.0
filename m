Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810116FBF;
	Sat,  4 Oct 2025 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759597781; cv=none; b=We93U+dhC+p2/Zt8KS80ZZKjTx2Sk6SbVuxIJa86ZzNyJeWNUzPWEsu7CEWpf0vZsv8DsyU5ogH0aVi0GO89i0fRZH9QKb1zjO2xgn6gOpTJzj14zBVAQg7oANSDu2mQjhjT6o0COyxzj1XkxMEPnawdy/r2zVwi8B7M762fxsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759597781; c=relaxed/simple;
	bh=u0uFHhHGkaicff2xYQDkrK0u0lxhTSaGvuaSuZtRPwo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=RN+SkJDa8NxM5FrFFK7VkrfSJh3z1afkeeGyRRyxaqAu4ODFeZt+Jxeb2No2op5NRcg9EEdpteCEgZYyN7+o/4chlpynm1bc7qBmeHYdtWmogMIPdT3G/oSc3+zzY7XCnnOUrdU3spUgOYFGCYbcaS1z0cjMvv6COrzunCW14nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=XiR4vU6/; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="XiR4vU6/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759597776; x=1760202576; i=markus.elfring@web.de;
	bh=uWbHEh5Nkg/VBCeJytcxcUjoooR1uA4nKMyhLUjWweo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XiR4vU6/bO07nFPebUVHRze1KOnSpi1nOoEiGRfR/xivZ72OdHsSB/BNZDmNzRyW
	 5ZG2y5ciejLwfkcwFr62Jsd4vz8y2dhhOpUggL13obYAosdLitlur6meyhVgyQ9HC
	 DXUtob/E6pLqBdz53zu5i3fxCED2Z8ozRATxAgQIusgBqYFherYexDDFC9TR1LIAO
	 S6VrmLOBUKmChTH+mkNrpGZrLsPAvad5kmRZOw1upa1pK91NHBUWvmo07G5MNePAh
	 0JGgqiE3sh8qFmvC3i0gXfAkCbPy5sVNmKfTR6UlaZf9HmMDRMFkWdclJChjj41gv
	 011yKTVEOxaXMr6vhg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MumNL-1uEdpj1Oh1-00uJTg; Sat, 04
 Oct 2025 19:09:36 +0200
Message-ID: <9394c1f6-24ef-4557-b9b8-4e3a96659ed3@web.de>
Date: Sat, 4 Oct 2025 19:09:35 +0200
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
Subject: [PATCH] ksmbd: Avoid duplicate variable assignment in
 ksmbd_vfs_path_lookup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BFY654/gsY6rgX/vCDCsabu+UOhHr0Q1A3TOqqT/ImV4tzcDrdS
 YExYymuVQ97H53x01heYwuPfi7rE3UdmaldIrszOF0NpUcOsKnKaBG3BM7/q6PJZ34z1orl
 Uy/FZZj3FHK+2Ds9217/ERzgwA4UJ5PP36PCJQu1M87wfoun6MXS/mIanKmREJdaZ4TKn0O
 Garip6NAox6rpy3C2c11A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Y5shToNdvkA=;F2l2fKD6MPwjBcRGD5KIvHdxwGh
 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
 /OZ3jtNL673lmrY9wtORIszeaI=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Oct 2025 18:56:18 +0200

Move a variable assignment into an else branch so that the variable
will not be reassigned in case an empty string was detected in
this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..bef6761760a4 100644
=2D-- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -73,7 +73,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_conf=
ig *share_conf,
 {
 	struct qstr last;
 	struct filename *filename __free(putname) =3D NULL;
-	const struct path *root_share_path =3D &share_conf->vfs_path;
+	const struct path *root_share_path;
 	int err, type;
 	struct dentry *d;
=20
@@ -82,6 +82,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_conf=
ig *share_conf,
 		root_share_path =3D NULL;
 	} else {
 		flags |=3D LOOKUP_BENEATH;
+		root_share_path =3D &share_conf->vfs_path;
 	}
=20
 	filename =3D getname_kernel(pathname);
=2D-=20
2.51.0

