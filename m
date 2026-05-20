Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9933E5EF2
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 14:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779285644; cv=none; b=Wqv3ClARtxxpOTVQD887NO9etGWf02YwR0WLVHbW1nG60vnlbP7RZTZeFJRqZLIzaIoolwdTpf7M8D2b626L01mK2x5m0hdQ6MUujBh6UOFRr89RBHnmX5vzTiJL8Tjmv0UYfu7Wzm/71hGoyjsd/wSPqInNj3+dU5TNvaygL0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779285644; c=relaxed/simple;
	bh=GOh8GbqrVb2NHqG8331/APpQkh+ybZFp0S08gqnmc7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IRq0fUGV5l1jGnSTQecS/OLK31tj494HE+ViAl6bfVKory3w5JdTZ2f4WJBvV705CYQUfIIrzl7niA0r4SdPu35UrJ31skUBvsULrVnTo9vC5svhF3GNZ+yKmypXqa5hdIAbrhFt1vJfcyX20Cxh19E7DSNTQgvK+CybUFuuC00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oggwHU1u; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oggwHU1u"
Message-ID: <2aa547c3-d8ba-4d67-8b91-c7bddd132da0@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779285636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swGhn7n0U57vB/EzVH05ND9JuHpTcOD6AYS739mynrA=;
	b=oggwHU1uqfh+mMVf6eniidwSkZhMMBq1kKiJ0h25dqvQi0WVBUoR5QRhMvvkniPOj2/2Gd
	8TKqxmRsCxV6SE3Oep+Iv5i6i439cwRcTR6OHhsZyz26v9dFKFPrKLjYmVS1qA9+hnkvF/
	7sepEzhN1ugaNhghzj/55Rf2INtpcjXkyB1736dRZC8LK+SmIE76r9TnlGMaOSbbvrl33l
	JECy2vthyJG4qRxH2mqRAPP0KQa8oDtfpFbaQ+4anol0wDmlgzdZKHKr/3uyuU3kJ4e3lr
	rmKctqibYE8T+9SYRqlerTyk3CF3Uzm86QLdyN9hbnebb5gxthXvjl0c3s1MDA==
Date: Wed, 20 May 2026 22:00:03 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: Stefan Metzmacher <metze@samba.org>, chenxiaosong@chenxiaosong.com,
 smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <0cedd361-1774-442e-8196-a9fcd881531b@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <0cedd361-1774-442e-8196-a9fcd881531b@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Stefan,

Yes, you are correct. `sig_state.cancelled` should be checked before 
`cli_notify_send()`, because `changes` needs to be freed.

I have already made the changes and created a merge request on GitLab: 
https://gitlab.com/samba-team/samba/-/merge_requests/4530

But I cannot run pipelines because I cannot verify my account, as GitLab 
does not support phone number verification in China. Should I send the 
v2 to the mailing list?

On 2026/5/20 18:25, Stefan Metzmacher wrote:
> And sig_state.cancelled should be checked before the next cli_notify_send
