Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2C2D0631;
	Wed, 15 Oct 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760539958; cv=none; b=PxByWrZxcqApfwCjOgr0MrFQN/X24+dn4F/GDnlEPq/pf2cgcveECnHmvvonWX5TNl1tYO0Al3CtFvHqtDW00dj6BZ2y+pG1+DvY1mrAqpnhJ9RWyBTYigEhNBlUufvqGbWXoF9pCQcPSBOx8KhCkAn499+rw7RtmVGRl2CDVVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760539958; c=relaxed/simple;
	bh=ni5+muFAp41pDC+k/J3C5OC/b0SOtv/CgV0ImrDaL+o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=qYd/pMC0+pQfaCYvyQoKtjf0B3NJeIns+BNqD6Mn1lTSMQIwoQGepMtqLv/bG4dJwd+QzmN/dvIsRdMtFfvSyUNyjtxhaWb1ZZmLxI8Puqhs83j5ktxKxpRYaVdtZCaWUHjeFMqEVtKKBFu9q2Mk3LkWShZVZwqgR6H81EBElrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=L3ZxKn/6; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="L3ZxKn/6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760539952; x=1761144752; i=markus.elfring@web.de;
	bh=ba02iFFM2ySUZ/Z41M0BONX/BmkWN/myCw5BBp7A3YI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=L3ZxKn/6Ifsas0bAToRNyazwCG3hyV0NeUjrE1nwVk6pAyzFoAuWLJqQeMyLsI/N
	 wty9h/FyTEFTNGlh58Cm7W//er/PcYGAQPm/vzHvWYpzPW/NxtwTucddiQuVQ9KaR
	 cPCEYaWCLrfMBVzBNIoRrmjvvx3BNW4S8tfYesPA4vIoiKt1cHKpwI2TTObIdLFi7
	 jsjDUHXZ4+3T97sURkIsM9E7dxAsCP1Y2b9LpwiE5CYs+rY8vHXzr3iUoyjk3ZdEP
	 ATuL0PYphB4X26lH3rrwdmfNKY2LqNe/9hgy6W6+de5xCk1gGGrsW99meYLO7QwB4
	 ur/95ETV1OsuBDTwLA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.181]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Madzi-1uWyIE29EI-00cSFX; Wed, 15
 Oct 2025 16:52:32 +0200
Message-ID: <6599bf31-1099-426d-a8e5-902c3d98e032@web.de>
Date: Wed, 15 Oct 2025 16:52:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Shuhao Fu <sfual@cse.ust.hk>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <aOzRF9JB9VkBKapw@osx.local>
Subject: Re: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aOzRF9JB9VkBKapw@osx.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MfVHlBJp8Vpatck5RHb+37I5E6KuEwmbiM/jFv2E6pAQVqlYN6B
 a4Doxb5qQM+gvjRI7Zmo3/TdoQU1FHzcZd6wtnk8eqLMYeylBNhqJJbKaq8b1eZkxVji+PW
 DDjuM6OPguTMKfJKwrTQIHA/RGaKulPaSxyuQHnP1q8afqkPjA+4aR/yQlzHEnZpwqb05tw
 3C+ru1HwPaIttn6euGeWQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JHHffGBfVTM=;csqLyiTtNBkkXM+23nBnvNPSmZr
 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

> This patch fixes =E2=80=A6

* Will another imperative wording approach become more helpful for an impr=
oved
  change description?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.17#n94

* Would it be more helpful to use the label =E2=80=9Cput_tlink=E2=80=9D in=
stead of =E2=80=9Cout=E2=80=9D?

* Can a subject like =E2=80=9Csmb: client: Complete reference counting in =
three functions=E2=80=9D
  be nicer?


Regards,
Markus
