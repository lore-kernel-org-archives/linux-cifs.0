Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B452E9EDF;
	Thu,  9 Oct 2025 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760018447; cv=none; b=nGPM9mkEhO8SbZBUiAPqsp6mRaZTDbBDbzWHLvEC0ix546yZ7FNM8a0hpsWyKAHIfMEWYdYSPx3ElVj0qW5qrKiRe/sq44zaTh69jFGZh+9/3XZG/e5cWUndrtTxyGLdZJf/TS8YPxh13B09jBcgEc8/sGY06dqNxksn7U6uxGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760018447; c=relaxed/simple;
	bh=pIudzvlZY6ugQMvDKUVUNK7SdC5TbTZtRKbzOeLqGxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2hWY7HcImoN9rqd63mi3jp8yTtBFz8XSOTaMg5xL7lOFrECd2G9lRMbEZa4W2PnJEVbKJ/4C8Hld46TWGAaCTivUTm8iZKTSed5m4H5uxfgYJRm7SgtDszqTQJbhSoqR2BcJKpDGyHRyzC/zUheknO3oR7IhnPxOlkInwNrsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=umwYGJCh; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="umwYGJCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760018441; x=1760623241; i=markus.elfring@web.de;
	bh=pIudzvlZY6ugQMvDKUVUNK7SdC5TbTZtRKbzOeLqGxU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=umwYGJChpg2JHC4Of+10QZKUyBn2WrLDfnwgSKutjWUX85S1JDR9IMplwqn2K2zL
	 n+9wBwyFSsHBLb10sE+KqK1ioqPe+Ra9nmRNdnNr9bokdEcUyEcPwzvNza2u/2Ciq
	 delqrFKAucUG8/imDQu0vi7I0TPRRSb8b9vMtlG+dTGVaGDnFv+j5Of+2XzXKHSE1
	 x3ImB1UspjSgsRDiEfZ8HQMtdT5oJ3XuQKUaow4KkuxR+HGIW44RFpjr6rnALNLE7
	 dVj+pQn0DGSh+KHPb7Iq5x5qTvyI6mXBOjY2e4ZbtWcRyy35MvSZ6qdmGy97NLdBi
	 4uHP8913oafRS3/RyA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N01Zk-1uId1r213e-014knV; Thu, 09
 Oct 2025 16:00:41 +0200
Message-ID: <5c09026e-3176-4dd3-abd8-e5ef3b2bf5c4@web.de>
Date: Thu, 9 Oct 2025 16:00:40 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: smb: client: Simplify a return statement in
 get_smb2_acl_by_path()
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Cc: Steve French <sfrench@samba.org>, LKML <linux-kernel@vger.kernel.org>
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
 <CAH2r5mtpoLscs9sodXcRMO3-dqMDBSTR+ncExdqy4dQR=4uE8A@mail.gmail.com>
 <bc8f02de-0cd5-475d-bb19-e44e202f7a58@web.de>
 <CAH2r5mtY8--9ccnm5aYfOYJ=kEBr7=y-Z_eROKDp7A6DGnxwcA@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAH2r5mtY8--9ccnm5aYfOYJ=kEBr7=y-Z_eROKDp7A6DGnxwcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:7Y105H4OyhJPcbtz22LwHlmMFPhh6M2CLnE5t1G8xOer/iEsUpp
 JhZ5/mae1YMpeYH/PAHeEXE1bIpp3wOp8N+bjIlUDgZ9fNUfGQzCIkqHEWhpgM3T3VLbrRo
 rjzJbPFO1JhRNMlIKuEdoZ2bYzo7H75jIXJCHjCrKDuElw8P27Cg94Q1QscoDzwTEIdsAxj
 MIUZRRYTUADV8gHq6vYhw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/5IVGVxAtnc=;dbHGZSEEhp5IxzPXS6DS+Fw3N16
 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
 ttj/zQMcAbmgWw==

> Three of the four you just sent today, grow the code slightly,

How much will this observation matter?


> and don't fix anything,

Do these change suggestions indicate possible improvements according to specific design aspects?


> the remaining one could be considered

I am curious how the patch reviews will be evolving further.

Regards,
Markus
