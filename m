Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECB42D2384;
	Thu,  9 Oct 2025 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759999467; cv=none; b=tOSp0xuo3eVNwnpriJng3msCqSdtvY5HzQQO80Jdvh0cNsQ5QFrU+L9/IL6HC3TLIhcuugfJXmKVX7khGb0cI1KMv0wL8400rRzzhUyOIzPEXNYKbz2BguaKQs9Bh/EEPbx0IMGParNDbvaHqT8MpahMpp9gXwQd4UJH2F3ZVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759999467; c=relaxed/simple;
	bh=nS0VklyWmggx9tml8yZ/hjyLZGNcVaEaPkrDI1/VEVk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Q0ety0MNwWfGjIEnFR9BfSd28QMAbyc3v3UP/8lIEg+brs/MFgCS9hOygUmg6s6PEaEUyC0J5cppnj0p0wE1IEg8iNLqIBkodem4FMQ+NPGhHZ3mTPgQW2cCk68f6nAKYZnfX0L4SmVC3gUr/P1qgVkEE+jgUdZc84J9R8r2ELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=m0hH6LEk; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="m0hH6LEk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759999454; x=1760604254; i=markus.elfring@web.de;
	bh=fNBIIwMv6GcjghRR5B581wmObH0K2+D8Vo4AhT1OKdM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=m0hH6LEkqm1vwhgkSvWC3mBrFahVlBqpgxANGSIPgahNnHlYX0agvDUCngZjwRMt
	 D8xqux8r+sBdNuKwfKXcByJetSUXYkR7f/AjhTQf0aXrzf+0rmJ9mEbFF2W3b/Pv3
	 c8QULjbhU06E0QrjWzGOBVWGiK9oXkLJzGUua4QSSL1kHYvLSYb6MlkyOd/nMlQRy
	 Cx3pRdxeXDVy2oxEASQp+UfqP5cYZtCwijr5GAHApoaZAdUXpPvQdkjZcXhmOPoGs
	 OPPLq3rDZZMEHFTGPdoisg8JXWrsdom0cYQ4p6NM1l0i4hspR8feB0hOmpO5QLwGJ
	 x+qIVMvccvNUKVzdWQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M3Eut-1v7bbH1o5N-00AE6q; Thu, 09
 Oct 2025 10:44:14 +0200
Message-ID: <e06df807-e264-48ed-9f7b-0cfaefb296e7@web.de>
Date: Thu, 9 Oct 2025 10:44:12 +0200
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
Subject: [PATCH] smb: client: Use more common code in SMB2_tcon()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TknKbR8tGw+WcxxZw9WAiGptlcXfOhvRZ72RzYnY/ozDMpVdZST
 zv7H6Go3UFM6O5FvLM6ZX68BaMnvUgl0FKJxcT8RbWq0jhC7zKdpz1UNGhww39p+l4s6K2n
 93ykH0PUVRg6jft+rdusMDoymB2VDFfxuKz6XMs3SlqyJrGdbDgy8RZUM0HibzT8ExBhCnY
 rtDxskZBTAx4clBqNMatA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CA2LvekOFOU=;O+ZNKM13O5C86T8tBEwheF8gFzl
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 10:37:39 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2pdu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 42e2d4ea344d..fce755fb2b80 100644
=2D-- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2056,8 +2056,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *s=
es, const char *tree,
=20
 	unc_path_len =3D cifs_strtoUTF16(unc_path, tree, strlen(tree), cp);
 	if (unc_path_len <=3D 0) {
-		kfree(unc_path);
-		return -EINVAL;
+		rc =3D -EINVAL;
+		goto free_unc_path;
 	}
 	unc_path_len *=3D 2;
=20
@@ -2066,10 +2066,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *=
ses, const char *tree,
 	atomic_set(&tcon->num_remote_opens, 0);
 	rc =3D smb2_plain_req_init(SMB2_TREE_CONNECT, tcon, server,
 				 (void **) &req, &total_len);
-	if (rc) {
-		kfree(unc_path);
-		return rc;
-	}
+	if (rc)
+		goto free_unc_path;
=20
 	if (smb3_encryption_required(tcon))
 		flags |=3D CIFS_TRANSFORM_REQ;
@@ -2160,6 +2158,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *s=
es, const char *tree,
 tcon_exit:
=20
 	free_rsp_buf(resp_buftype, rsp);
+free_unc_path:
 	kfree(unc_path);
 	return rc;
=20
=2D-=20
2.51.0

