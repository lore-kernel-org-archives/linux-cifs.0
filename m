Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26DC13FEE;
	Tue,  7 Oct 2025 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759855107; cv=none; b=AwRZPWEVqOEF1H3ob4vaW68oLO1AOc68XsVGxGBMX59OaP5MAvzVyhFNB0VncUsNxLb4uNyVSeKougo8d1HFN1MNhDfu6axAH/crSNraWzwBSTXrAih9YvVkSoBWLFsr0eBkuYLjz+2PXS6Fs2Yvkn+zJWt6j0LfKyUNxQwRH+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759855107; c=relaxed/simple;
	bh=nB//Y1zynX2fd+yj8PkBXW7qTKPguykOhkY36B+BIQU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nEKS2HM2M+slJpnue8f1tyc2QcccNrzVIsF8kEnzuefOAu2cxtXRv0Odq/AyYKsxmi0VpaFQE4nLlVv74pPzhaFrQAI++ksmRiU/5yqmCJ6cYczVaFBnv5B6PUEodnMrN2u6fqKLI3j8vGGUyWljtqoY8GkePMQ7WoQl+hbrbRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=FDcaFHa+; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="FDcaFHa+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759855093; x=1760459893; i=markus.elfring@web.de;
	bh=T1K6xj6QyUfPVrbt6sXT3rQHpJKo5jgkBVnOQIqypcY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FDcaFHa+aw4JqY8oy/ipldJok1TbKbGJHHZbcUFBnhautGvVbZkNKN8zPV/dqyGa
	 srOvQ9Ta0oUxywWita/5q1K7hftDnELjMoqfpzdX8QiZHAdBLofBKwa8VB757Ssb5
	 vKZfwDRtuy3o4X3DLyAsje7B9vpUmnSyXY/PjffTYIivxx8XekTuHoSZ8ROqPPPUe
	 +Y+V2N4zip5/DfUH6VXzIWiLmrmz89hvitzpUcJeEBrbteI8ZQXxfmw+Bjzk2gCfp
	 wyvYeIgGdkyFbSz6JY5KwyVQxCtzXzidVTCWlEZbVS2DcYij56V1tvi39lKl9j+Vm
	 uYTAuflS384/rIvpng==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MkVsg-1uQ0iY3pzq-00mOVI; Tue, 07
 Oct 2025 18:38:13 +0200
Message-ID: <c95bd00e-ae0f-4f52-b853-a92ae3cb150f@web.de>
Date: Tue, 7 Oct 2025 18:38:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Samuel Cabrero
 <scabrero@suse.de>, Shyam Prasad N <sprasad@microsoft.com>,
 Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Return directly after a failed genlmsg_new() in
 cifs_swn_send_register_message()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:N581YzV6VCtXTho+HwQqyo4sjFUETIA1Sl6yySAnH6Gy8wkRppC
 cJV6Rg7yNHh6VjZTUqWmHh6hCcl1uL2XMIgfW2/uZWMHd+jXNb+bPbEoOrrJBbbOI4cc6+6
 CJniWx/Ujcd/8JnjSMEf/6i6QoiPP2ri9i/tlvVE2wuDNjXbPN8qUb/FO9f6QGHlwOLfdxN
 3fCyQq/J7C9UXkwaamG3A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:16x/lBFn5hs=;3tAfF18gLBXOL72AqjGgyH0/KK0
 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
 9lP/2rdQLZ3nxbX0uuDFasRSV0=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 18:25:27 +0200
Subject: [PATCH] smb: client: Return directly after a failed genlmsg_new()=
 in cifs_swn_send_register_message()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

* Return directly after a call of the function =E2=80=9Cgenlmsg_new=E2=80=
=9D failed
  at the beginning.

* Delete the label =E2=80=9Cfail=E2=80=9D which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifs_swn.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 7233c6a7e6d7..9ac80ca6d06f 100644
=2D-- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -82,10 +82,8 @@ static int cifs_swn_send_register_message(struct cifs_s=
wn_reg *swnreg)
 	int ret;
=20
 	skb =3D genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb =3D=3D NULL) {
-		ret =3D -ENOMEM;
-		goto fail;
-	}
+	if (!skb)
+		return -ENOMEM;
=20
 	hdr =3D genlmsg_put(skb, 0, 0, &cifs_genl_family, 0, CIFS_GENL_CMD_SWN_R=
EGISTER);
 	if (hdr =3D=3D NULL) {
@@ -172,7 +170,6 @@ static int cifs_swn_send_register_message(struct cifs_=
swn_reg *swnreg)
 nlmsg_fail:
 	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
-fail:
 	return ret;
 }
=20
=2D-=20
2.51.0

