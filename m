Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3291B34E74D
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391058; cv=none; b=pDt7ZiqbMg3CpSGhBa62qeJBum23XdnGKvOWm34FtPNH/NkzEtNTYsCKlCrUzb+WUNye/5H8Ky2N063TaCJ5Q8pLWMmpDyIsbcZ3BanEF8S0WXcEZkBI+Ca2Tcbn7ug3IXK08LHp1g/V2/v/RH53nwx4pXrU5/IsVA1nwFTjN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391058; c=relaxed/simple;
	bh=QL+Ci8JNG4Jab+477SrUPaRyHlNgkrcnwkT3DNYVAYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n5NMS4Wtzg+vJCLktEDnWz7nNUgoTkDWwJS/U00JUCEgkYUveRZ4wj4POx7mZy7l/6FrCnvLEFqMQlu5MO5UYLOAna35HbwFSimdmaxYlaDxgPSu9FU+vNdVpA5bQ7t2D0kyHp6cEb9y1uQBCVFeUNKsXR0a4X/7JV+iABy2G78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gtx23/Az; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gtx23/Az"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=QL+Ci8JNG4Jab+477SrUPaRyHlNgkrcnwkT3DNYVAYM=; b=gtx23/AzHHoLA8NgOF1JGV50hI
	X4X7J8xN8g8oaBzBnI7rA+BPYYBNwbys8TbukTmd/Zjm/R7LeRo3WFSEnG/qvLNb9ieRo5q4lJXNK
	ownnXhSA+ZRtoRM/rtc2OTLTXamEuYjAPMxhFi4biBKmWElFj06aALvRo69Ds70q1VDaQbUTzHAkO
	ITPiexxpKy0yHLMz+Un68J0UWl7YucHGJrVFRR3frFf+SrGUOMzANqSu3EKZhxDLYo/wQ88pqUXtn
	cHpv2Xcpi1N85yKKCwsVFwod1hBAXomPFu3e4S9zDW0dfbqG8Ro2xosq+7qytsexb2FNSstMI7Fe9
	z4XcC6hojf4eRVrbrObaylukX8aVsnZXI8DTrhgnIhpkOnLm21s9L1W2K3GTdPj29ZbfrtCWT0AMd
	to5KW57udIzj+vZQuzTsBIBPt5sBPO7J1SKqrfb3E11j0ODK14dKw31yl5p5IOqbe6rLrTGuCfuBq
	HO/wapLtvq3Q55f4Wd0u1Gn2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1voNaS-00000004fKV-158U;
	Fri, 06 Feb 2026 15:17:36 +0000
Message-ID: <67457856-95af-4d24-a8cc-61c94b391e80@samba.org>
Date: Fri, 6 Feb 2026 16:17:35 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <cover.1770311507.git.metze@samba.org>
 <CAKYAXd8JgWAM-zc5CdNeuHOsKaBYKPp9NQBd9=Z8G-RNOLm9VA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd8JgWAM-zc5CdNeuHOsKaBYKPp9NQBd9=Z8G-RNOLm9VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 06.02.26 um 16:13 schrieb Namjae Jeon:
>> Namjae, can you please test in your setup?
> There are no issues in my testing,

Great thanks for testing!

> but since there are a lot of
> patches in this series, I need a few more days to review them.

Sure and thanks for doing it at all!

metze
