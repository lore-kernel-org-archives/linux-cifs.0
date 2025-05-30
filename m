Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF3BE5E
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748631827; cv=none; b=CvxIhNj136efaE95o5mydJGYFRK5Jk3NS+DgKiRV1JleQfiteqA9g/a8i8IfhZoYSatKZwONga1DPT3Fa0INpTXzKtxJyj/th54gnZVV0f3azbfYG538HAuztlrgX67wX/mQptxJwVzncA++HVo7BKNkd54oecERJQG8fcjZ9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748631827; c=relaxed/simple;
	bh=kgGgrC4ZnuDndaA3PXCSlMt2PBPwETEgtRHAzHxXl2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9s/TreEAAiUo120EMHBX7X7uv5QdEtkCw785X5NpL6Znkw4nQ3OYJGLsQdYFMBdG2gs59W5WoakDjN79sLA5ltxnSYC1Bonbvm6q8SUBSVLTQOTxIdRBjyf4iUIPGg3yPcm+rfjg1zbVJNnBwl5KDt/nArCQHt93HtCHl/ijVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xQRXJqli; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xQRXJqli"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=WDiOQTKL0PKOU24ytgRdpcQ8yDKwwKYO8DpOjSZC2r4=; b=xQRXJqliNvr8yaDiptNQqGjYR2
	ZKBnqB1JTHQ6i95tkEOHmDz5JOjO8mn+0P4o6Shn7Pknz0f+drxPI+ieqLo5tqDLAZa3+F/eXXc63
	jw8wwcvWW2pklA8P7Aa9AL71G0ZoGyexdyv2G7CJNPBMlbnVqiOvaKRPjoEHfXoG7w51qVdiyRe/6
	hdiOt7PYvuzyXrmAIXw4mLWM9bvJ2HFqB9UvZw7JquMxcz/c4DJdvBAxZfZc5Ka1o4aEvoWUMYW33
	JVUKvOllE1dBBsVEcPfR3b+D4wBmkMQA30zlI3stA5SU9GbO275ij4t3ApJpsPwI56v0HecM7NN6G
	x2BoG6vpsczLwRAeW0PNpginIc9Mf+R15ThRCNJrOup9WpNdcl1Uf/kFBrtdDkC1a/waQbQXMO5ky
	Jm8TOXZXcXW7JPUH4W1kIQWT8bDl95iLytdwWKVN4j6xMFLO/ntePT8+cl1xX5VWR1FBsy8XE9oVM
	r80oUElyzBe/jYyJeTaCFrvb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uL50y-0083yb-1C;
	Fri, 30 May 2025 19:03:36 +0000
Message-ID: <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
Date: Fri, 30 May 2025 21:03:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Hyunchul Lee <hyc.lee@gmail.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 samba-technical@lists.samba.org
References: <cover.1748446473.git.metze@samba.org>
 <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.05.25 um 01:28 schrieb Namjae Jeon:
> On Thu, May 29, 2025 at 1:02 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> This is just a start moving into a common smbdirect layer.
>>
>> It will be used in the next commits...
>>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Long Li <longli@microsoft.com>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
>> Cc: linux-cifs@vger.kernel.org
>> Cc: samba-technical@lists.samba.org
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> ---
>>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++++++++++
>>   1 file changed, 55 insertions(+)
>>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
>>
>> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbdirect/smbdirect_pdu.h
>> new file mode 100644
>> index 000000000000..ae9fdb05ce23
>> --- /dev/null
>> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
>> @@ -0,0 +1,55 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + *   Copyright (c) 2017 Stefan Metzmacher
> Isn't it 2025? It looks like a typo.

I took it from here:
https://git.samba.org/?p=metze/linux/smbdirect.git;a=blob;f=smbdirect_private.h;hb=284ad8ea768c06e3cc70d6f2754929a6abbd2719

> And why do you split the existing one into multiple header
> files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?

In the end smbdirect.h will be the only header used outside
of fs/smb/common/smbdirect, it will be the public api, to be used
by the smb layer.

smbdirect_pdu.h holds protocol definitions, while smbdirect_socket.h
will be some kind of internal header that holds structures shared between multiple .c files.

But we'll see I think this is a start in the correct direction.

I try to focus on doing tiny steps avoiding doing to much at the same time
or even try to avoid thinking about the next step already...

metze
