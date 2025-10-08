Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946181E32D3;
	Wed,  8 Oct 2025 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759943080; cv=none; b=qp7sHQumoEHWSitlOkMOIe58iXNEyJNIAyh9Y/2sbjMIGO2KXyxwKOv31nwuGMBFe6xV0S7ANASev8SAXhe0r8P6lHjd9H0ibHYPKG1maG345jTp/OhcbbzyDb1oP2HRrGG9ucbHRKEPtseiGdMJeM7G9hJ90bIYHXNbBu7uyE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759943080; c=relaxed/simple;
	bh=LVJzkZ8EpOQuSkHaKPhp4Sd2pW4AM/Oi7vkIUHXtXi0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cThAnT5oG3v/mejFeer3acyLnt516804MjFhZ0u70y2R09RAfe9x2FhlNgM9EpoDw3WIakheeRKu/kfUoBikIM2hsxn1TVy/cjL2nxylQGQWYR7FWcVtUriHOuXmioUgtYJ48zcbcBRFK42LBYZd3a2C8AoeGNMX47HA76mPZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=K1lcE83o; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="K1lcE83o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759943064; x=1760547864; i=markus.elfring@web.de;
	bh=+XNYs5h74fj6fgbPgkC9A454PZkLdmsPuZT3m2p6ppk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=K1lcE83oVpAqbTP2x9ZuAdIfp73E/D9XmzqQgNPvrUwKIPykTi3bOz7rzmZAoqy1
	 VKR+F+eJYXC+RyLwOyATI8n31v3cc/GA9Z9lEhG85a2Y5cyAHzh7wbxyTYstSI+1g
	 ASHt+/dlEsQOiFP3vhorAf9th3IXorlvz1jszVP0Dgm6iq7dryH0GNs3MUhjmr8JV
	 IxkovByUkP4H7n2vKmz3QOjVvH8iBnlhefeLnVRCRgGDDK5+P3jXO+tr9RvP6GD/9
	 MEu59BWBfl6OMaOBGlVsBjitRgBMRA3u1jxV4pJqhOOEfT9tw81EnoHAOQ8WDGj1C
	 1FNhR7uc1u5eZY01aw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8kAN-1vBCHW3ixl-00Fijq; Wed, 08
 Oct 2025 19:04:23 +0200
Message-ID: <02627021-da2f-41f8-9ea7-fd2da96e0503@web.de>
Date: Wed, 8 Oct 2025 19:04:21 +0200
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
 Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Move an error code assignment in
 smb3_init_transform_rq()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LhPCk31AG6sXOiYYeSCO54h8pMgJL4//gn73B7CY7VPNEA8V9bz
 7TtOCb7YvNsfdJpPmCeqLYKUJR7pXFPH7B8Mkdsx9lTlJMuztL8azf7VxTXqq57iM6b78wa
 CgbT2tn5zfdCpnjYYhRJx37YlyiLDHfD5Fddscts3VO8gDR07phSy14N/vcXZBnaXbOm5Zi
 KFWKy8UOypcrMhdcVd6bw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4H5cSDrdrCU=;uqcPkLc+EcMVYCpI0Nv1lSoAuZ3
 +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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 18:48:28 +0200

Convert an initialisation for the variable =E2=80=9Crc=E2=80=9D into an er=
ror code
assignment at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c3e96260fd4..2513270ac596 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4596,7 +4596,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *serve=
r, int num_rqst,
 {
 	struct smb2_transform_hdr *tr_hdr =3D new_rq[0].rq_iov[0].iov_base;
 	unsigned int orig_len =3D 0;
-	int rc =3D -ENOMEM;
+	int rc;
=20
 	for (int i =3D 1; i < num_rqst; i++) {
 		struct smb_rqst *old =3D &old_rq[i - 1];
@@ -4611,7 +4611,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *serve=
r, int num_rqst,
 		if (size > 0) {
 			buffer =3D cifs_alloc_folioq_buffer(size);
 			if (!buffer)
-				goto err_free;
+				goto e_nomem;
=20
 			new->rq_buffer =3D buffer;
 			iov_iter_folio_queue(&new->rq_iter, ITER_SOURCE,
@@ -4634,6 +4634,8 @@ smb3_init_transform_rq(struct TCP_Server_Info *serve=
r, int num_rqst,
=20
 	return rc;
=20
+e_nomem:
+	rc =3D -ENOMEM;
 err_free:
 	smb3_free_compound_rqst(num_rqst - 1, &new_rq[1]);
 	return rc;
=2D-=20
2.51.0

