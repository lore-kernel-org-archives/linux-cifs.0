Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1972533507B
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712449; cv=none; b=ibTzAlblT+cN6duyT1Z4lFkvE31NWV3xJs3oohsNxWNF/NJP7gKlGIP4QN16u43mbY/oVoCC5ML+tG/7LUnBxI4CArEFM1W+k12nsAtLCxRrjht0h0V0yi6xs08tcgxjomPa0WSRtlammiiV9rIAYCfD2w5yr60F/5GdYizyYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712449; c=relaxed/simple;
	bh=L+SqctrKZRH5bxnDEQq/Te4HdgzDjNPlGDrY5UDIoIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H9eB6fisPet3how8+MlGU5S77f+m7r781lWn1teOa30dwUa/pzExuvyoC5vxlpZRsoiwWJsEQAN1B8DqoRCy+Ml+uE5Ixw06SgDtDapti6HiuicsDVjjSFvLml2vrKM2MiAMf5DVppOG4FvR+S65BOfqP5DoiiVcF3Ih1gRQl/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SUeToxhg; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SUeToxhg"
Message-ID: <87c0c457-de8f-48b5-81ce-b47481a66e11@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760712438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SucrcXRDBeepHvtpSolu9QDInT7r4kkfWjyD7KxyHc8=;
	b=SUeToxhgTIFNPcJa5i3IdWlD90/TmRHLURHRdEuwwtbJdicg6WfRLvSaYqmpFvjcMsSQ32
	znDwkato1usVb/2Ykm+0UdKvPpBtyk4Yaj/A8LHwnZWy3oUtUhh4+VrTZgatqksYzxzBbb
	ULCbrDKUIOHhsecBuN4gc/1oqL1xTw8=
Date: Fri, 17 Oct 2025 22:47:06 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] smb/server: fix return values of smb2_0_server_cmds
 proc
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_kq9T0bgUeX-dMD-OEu48tMDm5s+gRPPADkfOL+GH7vg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_kq9T0bgUeX-dMD-OEu48tMDm5s+gRPPADkfOL+GH7vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

v1 has typos, and I've already sent v2:

https://lore.kernel.org/all/20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev/

Thanks.

On 10/17/25 10:02 PM, Namjae Jeon wrote:
> On Fri, Oct 17, 2025 at 5:47 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> These functions should return error code when an error occurs,
>> then __process_request() will print the error messages.
>>
>> ChenXiaoSong (6):
>>    smb/server: fix return value of smb2_read()
>>    smb/server: fix return value of smb2_notify()
>>    smb/server: fix return value of smb2_query_dir()
>>    smb/server: fix return value of smb2_ioctl()
>>    smb/server: fix return value of smb2_oplock_break()
>>    smb/server: update some misguided comment of smb2_0_server_cmds proc
> Applied them to #ksmbd-for-next-next.
> Thanks!
>>
>>   fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
>>   1 file changed, 17 insertions(+), 13 deletions(-)
>>
>> --
>> 2.43.0
>>
> 

