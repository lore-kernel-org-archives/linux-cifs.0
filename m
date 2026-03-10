Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF627B34D
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773105479; cv=none; b=OJfWgyq3t9BxD8ifP39r/rAkdm43Cb6bgrhfbdzqHv5W+zNy0OSIp+FYpGUMdGEbQyrvLP8VpXm/P5k6ZAmieTyJNu6GCrAFW5QZ5k0bZhAt5JRGnW1mkpZapNh5dBXNmmJKlsuuzl39cahItz3m6DBuFoEUr5DUpDNxNPHUuEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773105479; c=relaxed/simple;
	bh=6AiNCNfU31IEkvUGSKpCjQApDBVHzeAH2kDT0IdlQtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VLZ1ULekBpyJ2Eg2LBQ6Zgx0TFCupYKkHXwGIFC7ZIBvwNlPHmmbzoOHcOToRfNW2qVrb0t50t4HQX8ClvIUjVdy3olePSbtdKoRolFaaFXb2KC2nc1y6pFCRrkhQPP7Z66BloGOKd6d8UbnRnOjLu6EJuFczN1xKBarIggUccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZuryj9l; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZuryj9l"
Message-ID: <0858a9d3-f26d-4bb3-98cb-3e73abfa1399@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773105475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KyZdBl9iX2qwKpSWt7R5/WYfP7bc/EE6B/sFSrKpOEg=;
	b=RZuryj9lBWKqbqp/ROV+i6PEwi31twU25ThJiwVSsqmlxpFSMuxDnSc4QLJ4zwiHZHlQDl
	SfAAtLVRH8vfy6ikDm6+93j8VuJSVCKTz4NyLUgyn6fJZIpkFm7TItktWc2U2pWFrHpPp0
	oN1lKM3uAmQdLwQi+GtlUgvUQKe0ZxM=
Date: Tue, 10 Mar 2026 09:17:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 7/7] smb: introduce struct file_posix_info
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, chenxiaosong@kylinos.cn,
 chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
 <20260303151317.136332-8-zhang.guodong@linux.dev>
 <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

The client cannot use `SidBuffer[32]` because the size of `SidBuffer[]` 
on the client side is not necessarily 32.

在 2026/3/10 09:02, Namjae Jeon 写道:
>>          /* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
>>          u8 SidBuffer[32];
>>          __le32 name_len;
>>          u8 name[];
> These 3 fields should be removed and use flex array in struct file_posix_info.
> And why can't smb2_posix_info move to /smb/common?

