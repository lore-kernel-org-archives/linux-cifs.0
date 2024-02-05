Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B91119C
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707121212; cv=none; b=MkHMshSoW0s/2vDtoMRBw8cHiqTHnZmAay8OBFCl2Ko6Tv0eP86+ALA4YMKDhK/lrG7hj1Gz7Z2iQUxFUAaS0+rLbU0PCUYxZl0W+TockJs6gs1jq7x1Igm3fNSQNsmZQCSQwdkbXWeRIBMP3A4zuO2ABXt+K3j3XtpnRdcvNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707121212; c=relaxed/simple;
	bh=qBR4iPwRUoTKUM1CpjZoz8NOOFLkkTsEDnkSDfR8308=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=B9XDf+NgZp86EZnMhe7cBejdS9QoT2XQY/FqFnQjroOFZrl390iuarDiO5WUg1ofG13IOKkyCC+MK18WpDK6ASEzMPinafDUkhcWBaIgQvpJl6NJOPc7NUhfVFLN/JIMYxmSy9JCnC4s1/6/Ma1H/GJFkZcxALQEh/Dm1OMIIRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=CItWrWDF; arc=none smtp.client-ip=188.68.61.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="CItWrWDF"
Received: from mors-relay-8405.netcup.net (localhost [127.0.0.1])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4TSzf94HjQz6xj1;
	Mon,  5 Feb 2024 09:13:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707120801; bh=qBR4iPwRUoTKUM1CpjZoz8NOOFLkkTsEDnkSDfR8308=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=CItWrWDFfdh9kVttYtsM16Lsd2QERIRqhv5O1p0NYWJuhBJrUSBaa5JaYTjgrKUIb
	 P/bsYBm9kyPtsqx/ANzVOqNIJ3HS72l1q4K44HHFrs9MU7SKsT0YE/YI7v8eM147tP
	 KWRnxeljHB6wxasneqJ229mxgA2EFZ65MaTPmR4hmI+i2BACNvn0IffX/xZylaHQv7
	 MvVdd63koLQyZA9cK+zCP3MeqCgIwa+hgfxVD/SNGcPMF52j0vDOskd5ZVMkfdvqwl
	 fSnEvYPpR2817sRM6JYY96XqF5cu+BtlsIIwKUGvQvYEZF1EKhMVp40YMt4Un1tAC1
	 dOHbC3FqTPHUw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4TSzf93cvxz6xhp;
	Mon,  5 Feb 2024 09:13:21 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TSzf91bVlz8sb0;
	Mon,  5 Feb 2024 09:13:21 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.251.92])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id B9A451007EB;
	Mon,  5 Feb 2024 09:13:16 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.251.92) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <e65136a3-8fbc-460e-99c3-ad9f9f7528a0@rd10.de>
Date: Mon, 5 Feb 2024 09:13:15 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Content-Language: en-GB
From: "R. Diez" <rdiez-2006@rd10.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <6a65b2d1-7596-438a-8ade-2f7526b15596@rd10.de>
In-Reply-To: <6a65b2d1-7596-438a-8ade-2f7526b15596@rd10.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170712079701.25235.10153374641100482863@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: B9A451007EB
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: uc/HvEwN+9Muacc8TxocxPONR2bJlumY2AyX8f2T

>> Do you know if this is also broken in current mainline e.g. 6.7 or
>> [...]

Matthew Ruffell has confirmed this bug with a different CIFS client and server, and has narrowed down further the affected Kernel versions, see the bug report I mentioned in my first post:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

Regards,
   rdiez

