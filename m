Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA37E3277AA
	for <linux-cifs@vger.kernel.org>; Fri, 22 Aug 2025 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755874675; cv=none; b=J26s56oLGCmFhLm2NHj6pu+SMa8nPijDU6oEl/tBIZFSEjUUNw++XoCrozqg8eDtscS2uIUsTfqNCSlgq6dv/uOXICZh8FAZWhbd4fTCBeSrTHj6WZsPzAa/Q7UsiEOry2H8BnZ3u/OqPC1kxb/1K3DXPr274WZX2Ns9W8RKPJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755874675; c=relaxed/simple;
	bh=kNVHzisemVBBr2vQLNuxWt9AkYYycK1//x/CvKuQ0zY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSxy1WYRCZdNYBh2oBnaZGCP9I+hC53RrUEfjlrsTZGK3TcjHGkVcm8uhTUSeoL1jqR+iAOV7FUVkz1q45FcZ9b2bcn+3ORXKbGDytVK33vD9Tq8LzKlIlrKYM8jJJE6rWZwFHbtzH1JiGb3SlBH+NPSxHOLsoWQItHfQYAoGh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LT42/VSn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LT42/VSn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=kNVHzisemVBBr2vQLNuxWt9AkYYycK1//x/CvKuQ0zY=; b=LT42/VSnob81WGDaPoYBplXbfJ
	fa1GqYzsU3u1XQxdCyHcIP0kAUdzSeTeZjM79qN6bhbEFqgojQsMUBo7pG++2D+buUJqWVAW7FwVD
	6fYIFr0cDYNJIpo7ciZjSAM2H+/3JHmdK8LtdKQfMYwdmCQvfXa9OC4ar2Bin2LwNhIzzAV3BTswH
	k5OHsAbQQAQlPTdTlAT76LIK3xTzBClR/FEll/D1wA1CVaHUy5B087hYLq9BqQUiyQ/kO0YT5BMcb
	R4ZBiq5RXVXVHVjKbf681C1HqNA3l/QBbHUUI4Qh6R7HmIj+1ngEG/hLwPJtZenmnYUe/rViSDnnA
	o+9PQ3c544ir0qA9CESrbRY4HV3RwPZ/c8xNKcMUtuqZ/h7VMr/K47n00gNEzronkRt5ZtV+RgJhh
	t9JNKqUEFDVI17rhaz668m+wLHEzvVFDCRIqMfEPAPrKzQBa3l297OA7r8fvKO844jM3kIRWz/WnR
	yIwfDtBTPtWs8bydVLCAPBE9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1upTDD-000HSy-1U;
	Fri, 22 Aug 2025 14:57:51 +0000
Message-ID: <bff94baa-f71f-420b-b679-b4466e3d3c2e@samba.org>
Date: Fri, 22 Aug 2025 16:57:51 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current state of smbdirect patches
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
References: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
 <CAH2r5mu_Nm49VaLDvBA_n16MivzUojBBZHwQgS-JNbvL-UsMOg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mu_Nm49VaLDvBA_n16MivzUojBBZHwQgS-JNbvL-UsMOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

can you please remove my smbdirect related patches, which were in
for-next and ksmbd-for-next-next in the last days.

I'll post new patches (most likely) on Monday.

I'm currently at the point where struct smbd_connection and struct smb_direct_transport
are only used in very few places...

metze

