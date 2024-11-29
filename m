Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1686F305
	for <linux-cifs@vger.kernel.org>; Fri, 29 Nov 2024 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732896122; cv=none; b=nfwwsdb2XOMu2gJvqVgtBCdj5f/doNsF6uA88sMGcI2lO1zGUuWG9+uW1zUizJ5uaER0wOVow9x2qD4SnFWG4CDIGiJrxfxGrh6JSvgmLtyQzsotgPwmFw6GlWr17BT5lBnUsl7KMDjaeoCDZ3ToFghfufqTamas/BJeBSSs+no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732896122; c=relaxed/simple;
	bh=C1g0Zuq1IQbnGAi+0FIPLOPj6ELudGRrzliN5EjuU+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxqrwe7HcMqQMlroeBuUCAQLCZnaHmWEU6slurLqUuaKRimRLqxB1FpcV28GpRU4OeUHdHRWn0+m4hkfGEBwXPBOY0cs7W4K9fKpgxvbUgeuOv/wQ+6eAL3PjSGUvQU95u8Fv9lXCAcU3rpTJDDAFDjs2GHHUshwPe1mwascq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IDEzUlXt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IDEzUlXt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=/LICCurPQpI4PPYsuaKWAFi2J7OjXDHQqNLWnkYUIqA=; b=IDEzUlXtu6AB3abbsB8tc9UzAl
	T8KQ/vx0ZJoBa8TxziF5AAwDK2Ff8OdcJvO+kESk3PFSgsbByPPRj5nnyUgPL3jCyabNjclzX7sKC
	UUoPDvXp2EHlb+rTIxx1BDy788uozyKpCDU03uDjna6NrpnPBQwhiPFQBTgVGAUTVTC5G73JydvU2
	JxzCXgargN1IA2tCU7sHT4dntMyUklV4Nt+Cq4aThbPwYnTWKwcJ9rJzTqGO/4MXjBwShPgPHTAMv
	0CsVuRIYbHS+IenlK/Tn+Z7lp/mGrN5ugfXsR5Z52ugtWjCX6q5inUR7IPRpiVkfzHUGcDjPWkpVR
	m8n8f5Am0bx8XdN9vW6mxhhjENFUUILw95Wc24lcAqSSimR7MwImmNAxk+Ixku3LWe4aenOUSwz3U
	/qh+6btkRatWyPFKkJfh03UF3SqMzMynlq56SZxRlPQYRJbasMiE8Y/Yr+WufOEpS872wITnI9SuY
	THFJThM0MvQDnAmOb1wpyiqS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tH3RG-00228U-2E;
	Fri, 29 Nov 2024 16:01:50 +0000
Message-ID: <68d390a5-8919-4fc1-84cd-7c10707ce25c@samba.org>
Date: Fri, 29 Nov 2024 17:01:49 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: samba-technical <samba-technical@lists.samba.org>
Cc: vl@samba.org, Steve French <smfrench@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, Jeremy Allison <jra@samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
 <7932bad1-8bc5-48e7-9561-60029d5a6056@samba.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
In-Reply-To: <7932bad1-8bc5-48e7-9561-60029d5a6056@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi folks,

coming back to this...

Remember, this talks about POSIX append behaviour.

I have drafted a spec and implemented it in the Samba server:

https://gitlab.com/samba-team/samba/-/merge_requests/3863

At some point I'd add the spec to out POSIX spec docs, given we agree on 
some design. :)

Thanks!
-slow
