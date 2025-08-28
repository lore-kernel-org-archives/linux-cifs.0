Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ACE25782D
	for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756363584; cv=none; b=V8D36PUdozxRmVmfhCc8AHaQKR1C7gbR2ZP2vkblZTB1BNAH+Ri+Ta4ypUyd0vDjxTlv2RCaQklIhE2BrDUe640YMWnrKentAaEohDcmIcDqfgTw9ThVSsXhwe6V8dejreMIsbQcAkIzr3R81fwCBtYkJmXfHAmOpYMrPnpQ77o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756363584; c=relaxed/simple;
	bh=Meq0DLMQlQ/NhvVAEzqO2U1LXfOcKQo5aTRDHQhXc+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X31Q8e7x+3VNbVQliVsHfPodnDI1Zu9EUvdd70W5AJOMmdqD+LMvgt9QQc7dQd6dWISrRMG7iShLdOHGR5fSokJDdN6BLrUOcVfSy+0yzWbeF1r8K0IFewWmA06WEyWM232/9Anf9Kw1GtgyZfWPVcqCr3rSbIdeORXXDHlZ55s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Zsi/XC38; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Zsi/XC38"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Wdyh+5XUuUuMAxpuKUir7dJCepZRfLOjbQ1qWsTuVl8=; b=Zsi/XC386r7USVRPWayPqG1nm2
	KhdvAL8YOFzt2Ukflk5APSREoCChWUtlst50mRgi6b6TDaEf6RuUK4pNBLnX3nbrGy3GRyr2ksxh6
	jNhBK7euCucEa5ZmTEoAXBGgp6EKGB09rqni9+ApVcwrx2ordqX4x3G88PcjE8JuFSKX00HoSyC+H
	FXp6LF0sbTzMOVz/aFAwzcyPWbCT7V+km3B2bQOvp352bYkMhJsWiPiX4cCprzwTrCokMuwaWjKPS
	cnEX8Gq2fpeQLEtsb6D2OALd+Urx5PUYeY2U91iMvRt6dFg/0HSct5FEG50MztPSBqNN3ScNnYjMl
	HmANt8IxhGcK11zMkTKqUtjl+gqb1hVB8Mhb3G73gvmz5UnpPivIwPpb3exKTcTFI4z18Y/2Zxox8
	KNk1BV5w4WJ2452QaP66jRSQc77POQYBf5i6hiSj8eRk3Y9VZZmo/S36/8M8MB6QWI3L8nLlwbNaN
	fLcedvyuamKIvZCSBT/kV1Eu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1urWOh-001DIZ-2T;
	Thu, 28 Aug 2025 06:46:11 +0000
Message-ID: <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org>
Date: Thu, 28 Aug 2025 08:46:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: smbdirect patches for 6.18
To: Steve French <smfrench@gmail.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

> I have updated the cifs-2.6.git for-next-next branch with the 144
> smbdirect client and server changesets (on top of for-next which is
> 6.17-rc2 plus a few cifs.ko patches unrelated to RDMA/smbdirect)
> 
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next-next

Thanks!

> Metze,
> It also looks like there are at least two "Fixes" that qualify to be
> merged earlier.
> Do you want me to merge these two into for-next (so we can send it for
> rc4 or rc5?)
> 
> 8170223a650e smb: server: fix IRD/ORD negotiation with the client
> 5dd0894d057a smb: client: fix sending the iwrap custom IRD/ORD
> negotiation messages

Yes, they are intended for 6,17, but I'm waiting to hear from Tom if my explanations are ok for him.
I also didn't get a response from the rdma people on the u8 limit.

metze

