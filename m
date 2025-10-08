Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CE120010A;
	Wed,  8 Oct 2025 18:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949080; cv=none; b=qP9unTJ8ifj3He4VjxqoQbuR9C2qEsO3C7bCy7EI41gOAKihSzRe1q60rz8QCy0CHwco0XHxRdGxoopPGsgvR7YGn1PTdktLHT0xr5VvUnq6XHFEPDRq+QGCH3Ln6695rldJBEF2tIpcbNtXnA4gim/KOhjrXfgIyhHXn+1M9Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949080; c=relaxed/simple;
	bh=fTYunW4t7t47MMRiUGCUVIF01pr+p18ctTZiu6aojnU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=DAc6ueporA3rachz6YkSMmilZ23lYQxHvhkj0GDdezL31pVkVM+kAwy3FeH0yMSJzd5Ya7aHnQatXUi5DoFJ+jKz58xelmdzvNDA5yuZRsQf36PDpgYqYDynNrq7nBEdu3tixEZQQm5CCS+FoDgn7hJnwHg2KGaJP5bqI4uxF+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=R4y8o+8l; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="R4y8o+8l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759949059; x=1760553859; i=markus.elfring@web.de;
	bh=2Mkgu0J9/upFgAVIGiaWO6c706dLU+k2IGYo2Y1t1Tw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=R4y8o+8l/Ria3JhccecWZAz72bWP/3sKBJ/1xGbibSb7rDCLrze2Atv+9sXs1BOi
	 s8Ky39BRkHMooipVoURTtZQC03QQuM+K4y0pn8gyaPcnY2aP07OhgCCDc0Lr47/wV
	 5qDIscNnHxWrmyQT4uNuy0N0NAviK34PixbnBweRWkUXlCSdY3IK0SIuddhoJxccZ
	 1fl1H1Jtarx+Dzt8uW9qd+YEEZ4/qR4n97VNrYtWxr8aTeUTEhOQpBv8qRxRe0Fo9
	 48NAQAbyPEoNl9IShpZakfraI581lHp14u6NPJM6Qmn91uDT/YM/2FYPcQVfj01Vz
	 +PFfdvjvjYqzqybqwA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mv3Yg-1uFhXn1wWW-012454; Wed, 08
 Oct 2025 20:44:19 +0200
Message-ID: <98b5e2a8-4bc4-4282-987e-01cd6fcd8f00@web.de>
Date: Wed, 8 Oct 2025 20:44:18 +0200
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
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/2] smb: client: Better exception handling in
 smb3_simple_fallocate_range()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LWoKGg2/DD7PR1sb+oR+OzIVRdLjRuiR8rZmgi23R4CtTQDrzbv
 7IdD6b4oIJUwm1KhDHG6KSG2pHgUuIsmDJrRR0ctD/7uCDyrEPtCFBEB6tXhDRFqOieco8i
 Rr28h3KNZvLc60aQBW2oIPog/WNumUTrKsWuXFioGXub6OJ0CEIEaXfMFiL5+8LwBQWQve5
 8iUCOj3DY5tmmhRGBfXqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PJaZ0hofEpM=;ORHhkRAXHmf+sZaprrOz+fGkQYm
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 20:36:40 +0200

Refine a few implementation details for further development considerations=
.

Markus Elfring (2):
  Return directly after a failed SMB2_ioctl()
  Improve memory release

 fs/smb/client/smb2ops.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

=2D-=20
2.51.0

