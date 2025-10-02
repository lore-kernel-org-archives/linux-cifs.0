Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D62F7ABE;
	Thu,  2 Oct 2025 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759409724; cv=none; b=N99aE+3Ip5M7H6aNMF3E8WB9lsO1H96ebG0sWLR817UI6r9fCUlaNAtoFWshjPLzD0TwPyqs1Qb7kBRAJKdV/+HC2VGudGp74EorYvbolt1iTM2UboqV6fd6Yu04SQ412/ZVmcx2JzVGNCNjnDEbTEuDvakTJ186uR2lxBA6Sc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759409724; c=relaxed/simple;
	bh=6wAvihgQzK8AvKH2fNKhvYOxdIHr7FvnG7G1jOQoXe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJFOS9KPLsNtf3gREJwXkvHraICDrXcL4DtlaXY81PWM/R3JcmiO6AYQBQFL2vrCeZLg/DDgoShMTgGJ8CSAPKVa+xPaeOS2DjfFi+Eon3KP/tIdn245YArO+UnbKwcxAtUjjIQuhGwR1ixtJF9wf7PWXKSmohXEmDp7EdhqDCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MMzYqUHn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MMzYqUHn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=QA2yKqxJ285XmLeLwA+tuY7Ii7jG+QwPztSsYxsi86Q=; b=MMzYqUHnhFRK+I/aQP/zyu80GC
	gy4SB97HP4CcmOu6Na7XVUpdc6ucDM0WelyQ5Q8ObzSqfKaWPlJS3YM0sNYuZ0u5ftmZrXs5pbXVN
	LPTjppyQnVTQJyjyGaSQ/eWjoPFLVPrqcUIqsKeAczMSn/zW5i+wwLX6/QOZ4WcgrqOCNylI06xMg
	Ry1E9l5dbN1XhD6Ro6HpC6u2QxsS1gRMKQXQxO9Oh4eonO1rXcXA+MSrAeAaGqngwwswDmLpYGdnh
	mqoKNwFKVE0S5Cbfyl2vryALTyw6NdqvZ68yTu0pS6HKIEnKDTrqhF+SWe9z/sr+oPpLJLoyMI7kA
	gzX4yXooW/DZ+2IfGmuXddn/0B1ATMotHSKrooBT5WkD6kVUTXaGSRVTXRg1CK1CKLGUtxW9/o7JT
	/KdRSoJYPCoDK91KH4InGpOWJ64JOprEeGSWZcZzJw6K04vFJvcCbCnOdZNy/PJ3tbbFBKpFnYhs2
	7xm6oeBVekSQK2utzJibBf/l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v4ISa-0073ec-2u;
	Thu, 02 Oct 2025 12:31:01 +0000
Message-ID: <a9518620-29cf-4994-a9f4-a6f862d8c214@samba.org>
Date: Thu, 2 Oct 2025 14:30:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: Use common error handling code in
 smb_direct_rdma_xmit()
To: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org,
 Hyunchul Lee <hyc.lee@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <7f956b3b-853b-4150-b2e0-ccd430adf9ac@web.de>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7f956b3b-853b-4150-b2e0-ccd430adf9ac@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Markus,

> Add two jump targets so that a bit of exception handling can be better
> reused at the end of this function implementation.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Stefan Metzmacher <metze@samba.org>

I'll add this to my for-6.19/fs-smb branch and rebase on top
of it as this function will move to another file there.

Namjae, Steve: this can also be pushed to 6.18 if you want.

Thanks!
metze

