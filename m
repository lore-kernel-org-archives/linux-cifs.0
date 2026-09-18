Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B52C3A874C
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 01:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789696336; cv=none; b=KOfXjx8XxGeK8sdR8SAogEmozKbmhhbw8K+JZVsWws9JPdZk8RlTWqZY1OILfK3wDLfAarbiX+FjOCvTJa5j/pl8BzRmME7T6OVgt3VZiQnDd4b8nykJ2VF9zcdXKYJCeK92s78PYTqhNRQiUUvnXoy0cEHbdG0etraxE+Iss+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789696336; c=relaxed/simple;
	bh=EH8CfcHsQa5i7e0wbGVp9WWRcntCMVYyE/AUyK//3Pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QFSghVguZkfl2iFUc8LvLHiVDYlBr8Q77ZsiFmyxCRZj2DtPbWlme0ySP1UGoAmHAxB6mLsdA6O8mEZY2h9bAZm4tDLzhkaNh4+RwEqAKPh6nJaimasBVlOApqce0BHgLi0x5jSpWXHlhefWPOrvwPNWLDopw5YZFSjlxiFskL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z3AHiDoP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QQosLLP8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3AHiDoP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QQosLLP8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696328;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRT56u7oa89lwXHln4d8jjC746ec/UQz4MnDVQXsKhk=;
	b=Z3AHiDoPvgcrbhYmfdW2+0kNdQOHDZ1sndhVsyCen2gu8Bi3xNyYsw+k+fN3tsdQFaKtZT
	e1XS1Rs2BW8vYb+ZzSSfHQLU+yjSKrGDn7c6BANlhbyOwsuVHYSoYEo8lMcgmlaIwOV8aO
	DIxSi9nd/Q3Pckr7pet4FCNCGiyI2rM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-dMwK7gOpPaOIs9JIbwYKXg-1; Thu, 17 Sep 2026 21:52:07 -0400
X-MC-Unique: dMwK7gOpPaOIs9JIbwYKXg-1
X-Mimecast-MFC-AGG-ID: dMwK7gOpPaOIs9JIbwYKXg_1789696326
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9393ac4961fso32483685a.2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 18:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789696326; x=1790301126; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QRT56u7oa89lwXHln4d8jjC746ec/UQz4MnDVQXsKhk=;
        b=QQosLLP86WGIyAtFhUKJmw+Kqbm7OqztjTYPxCqHvpY+a1nbQjJHnT9KbYls032AoJ
         rOVT0gCEdukwmuQAHdt1kw//yQB/cK/88Mn5Whr24bRq/P1jI5cv6KHnEBgiA0rqlESQ
         eFqa2doVOqxB1zYKk3LmuQktvpjfkIljKFp51DQA+OYhLTMtyCvvI5RR8b6wad5fOBNK
         FbRiC+N6rstLpCGwBASWwce4Q0Lk0JaM7Ha/Du+N43hDAqqwr72ypZ5DH6p3Lk9vPbzS
         74AT8V0U54Sp5uU6NzuY6u0ooPBu6ouvQL6Sp70oounoqxGj68n9y+1m3iB6sll6LlVm
         sW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789696326; x=1790301126;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QRT56u7oa89lwXHln4d8jjC746ec/UQz4MnDVQXsKhk=;
        b=DPPZk/Pd6vf1YrANs8AEK280x988hLGTRVVSEG6kjLDSdI3Zz7lc2CFcrstTLLJm3L
         9hYJ+uVOMimHOGq8SjL3AyK7XzogBp0L5ttJ2fx1TUe4Zx+z68jmayXuYXdqg6Pisdj1
         UXTXc/OW+zYc4ndgx+2TC5J3VcDqpSUgPTdL36YU2zDrONpMLaNHeFSDEht0BKSw+JrN
         FsivJjvl1IAt4wXRap579lb9POxtF9jWXXykUkNNZFdM+YeK/cqE1rgQ6TSR0oGNWABQ
         AYCzCuHBLJjC1Iu8qZNWFF/umXu9EV7UTT2mm0bPq+TUBopbZoYWazhz3E4A47bm1ifS
         AThQ==
X-Gm-Message-State: AFuF++n5Q0K/3imBIRTJveb9eL28xdmtwum7JTqzFoIsrzsokkROX5Sc
	kz4fETyxdCWH7ayX98iq+lq3dACK4dwbElhzMO+TDNnHrVpHnhYeF9ZC54LEHxIAOaZisNcTg3M
	3wMgNkBC745JXIuDtt6B2zxd7KZABOqA8ZymCxIuAGlyOp9S9P+l9yv5XrL5J9kA=
X-Gm-Gg: AYBFou2oOPkPGNDsBxXKVHVzWv35fX1z0x2xHCnTlIZjFsMXZC72iUvV9qMPpUzD0vS
	45fx//HIvGruN5EQuvdksUuExUlJsW+90xxIfMikS37Vv99KjBW8lBMOkAg8lwW1255Pnq5Bw42
	1O/3SXp6nKnoA1g8iiHDNtf3LFmgyl768tE7aTvBE1brpVRnMVlBwulkdabx/Mj91TCO/rcvDqP
	OrC1qaCAH/mqqETRiJhiL2op4PyoSo86dl2NydYJur9Obw1y9VWKUH4IvjmNn57s9AsTZJ5pS+y
	ujhiP3cnB1wvolDAd0oRFIpMu0u7Nti9NhNbmmI2ig7lKDeEVpIjvNg+NHUeD6xtXM5eUFCI7Zi
	EKQJCHa6thjMOnadnVgWKlV7lxnpI6h2FFwouOEvV
X-Received: by 2002:a05:620a:f10:b0:93a:2e8:5af1 with SMTP id af79cd13be357-93bdc9d5537mr128367185a.46.1789696326341;
        Thu, 17 Sep 2026 18:52:06 -0700 (PDT)
X-Received: by 2002:a05:620a:f10:b0:93a:2e8:5af1 with SMTP id af79cd13be357-93bdc9d5537mr128365385a.46.1789696325917;
        Thu, 17 Sep 2026 18:52:05 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0cc8ae4sm16695385a.2.2026.09.17.18.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 18:52:04 -0700 (PDT)
Message-ID: <c2dd4bc7-413e-4ebb-b94e-2c61e3fcee17@redhat.com>
Date: Thu, 17 Sep 2026 20:52:02 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH] smb: client: fix potential use-after-free with
 TCP_Server_Info->hostname
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
References: <20260918003327.2539470-1-sorenson@redhat.com>
 <CAKYAXd9UW34G21Xr6kUArCGsKUQZxz7ttkuCcdE9tVgyXNWTNA@mail.gmail.com>
Content-Language: en-US
From: Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <CAKYAXd9UW34G21Xr6kUArCGsKUQZxz7ttkuCcdE9tVgyXNWTNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/17/26 8:47 PM, Namjae Jeon wrote:
>> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> index dea05aeb53a1..bb30cfa156aa 100644
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -173,9 +173,8 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>>          unsigned int chan_index;
>>
>>          if (SERVER_IS_CHAN(server)) {
>> -               cifs_dbg(VFS,
>> -                       "server %s does not support multichannel anymore. Skip secondary channel\n",
>> -                        ses->server->hostname);
>> +               cifs_server_dbg(VFS,
>> +                               "server does not support multichannel anymore. Skip secondary channel\n");
> Since SERVER_IS_CHAN(server) means that server is a secondary channel,
> Is it intentional that this now logs the secondary hostname instead of
> the primary hostname?

No, not intentional... I missed that server != ses->server at this
point, so the patch is wrong.

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

