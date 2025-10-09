Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B464010F1;
	Thu,  9 Oct 2025 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760000732; cv=none; b=Jk0syL/kBynpxgGglmnDiyfzw6MttGeg9OlyNjD0XkkdjaE88xHZESnE5+hxOkkctqZQDCM3JkZFmbJ0XQjNtVp9nLw1hrq60L/cU8LWpjXCza2T89oti3Eo0/UUxWcphamGwvCKEt5YMmBSewTpQeJ7p5ZxAlHVMV2ujLxtrE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760000732; c=relaxed/simple;
	bh=j0S6FrbhqmAZd25BiVnvMA1Zdg3T7U1vb0uxU1VyaQo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PaePALdlvLl7KS9odEhzhdsccfH+JOPI2jtc7wSmZK7aaSv5F8gTGTA6uPvhTzno+lRft2cJ7t1hPf2ya6T/awca5Bmf6rMG0RrXQYqISgoq7odoIxqkT+FGhA+6pfi48N4Hoxwjw1Oo5ZHbXBgNaROOi/g+3FjaZ8tkiYxwz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=J6R54JwB; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="J6R54JwB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760000727; x=1760605527; i=markus.elfring@web.de;
	bh=HDwZ87AsWDyuCNMdgrC5nYt8UKKovgkB6EfjY1IBNNE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=J6R54JwBxmpsBjwUwuZJwbVNyKhcudgOSffEJ2Z5ZfbTl2jAPBOjI5EQf8NLG7Y/
	 xfm8YnX0gTyzDsSIZfNECQDQ8/6YUE4l4lGhwUvaUxtpS43poIdrzLjeEVrMwRSjd
	 fi+gnKMMngIvxUG1gbuPi/uGr8jDBvYqY765AnRO2yRRoCQgrbdfJzrPMb/MLGhh4
	 /PZKn01upoIeQowtV3b5e4JUgJ81bHtyiynqqMRbub1uqhik0ZoUKI0QALegymcF7
	 PLGwJgJ5ePtC5QvnVHoIkjzJZUPITtRly6knKNY9sP1E0T/zcG24oJDtuz2iBbo/g
	 BytwDnDwnjMjAH3i+Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MSqXM-1ugpBo40Mw-00JL6C; Thu, 09
 Oct 2025 11:05:27 +0200
Message-ID: <5ab09bf1-b71b-4c7d-9836-e75416db2446@web.de>
Date: Thu, 9 Oct 2025 11:05:25 +0200
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
 Sachin Prabhu <sprabhu@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Avoid redundant statements after a failed
 kmalloc() in SMB2_sess_auth_rawntlmssp_negotiate()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XGxPdWtYvXoTneV/Sa+ezJoxuMPslgucuxrP/8pXnoZp5iLpRim
 cypmFpJkPGACe1OtpiPiAKzzbSdXr3aBkiG/X/EY4WNLshozjhYrCf3Es8b02hZ6JTblgMZ
 otFmHZiCSwFMvRVtT8VT/VJ4SIEhytKKJ2YqlsRvwtm5dOxoDPpWVsrAfMWFN7eWMlTaDIj
 YSgL/QfR9WX2Kfspeoa4Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:riEdt7DACSk=;uhTeYg2jFVbGh8eGM6Pcf9IkqSW
 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
 ObAMi23/Lt851TpnU=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 10:55:16 +0200

Use an additional label so that statements (which are not useful after
a failed kmalloc() call) can be skipped in this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 42e2d4ea344d..ff83d672aa05 100644
=2D-- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1724,7 +1724,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess=
_data *sess_data)
 	ses->ntlmssp =3D kmalloc(sizeof(struct ntlmssp_auth), GFP_KERNEL);
 	if (!ses->ntlmssp) {
 		rc =3D -ENOMEM;
-		goto out_err;
+		goto out_set_result;
 	}
 	ses->ntlmssp->sesskey_per_smbsess =3D true;
=20
@@ -1793,6 +1793,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess=
_data *sess_data)
 out_err:
 	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp =3D NULL;
+out_set_result:
 	sess_data->result =3D rc;
 	sess_data->func =3D NULL;
 }
=2D-=20
2.51.0

