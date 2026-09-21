Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A46C1FC0
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 00:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789950927; cv=none; b=sLp5u+x8OAL2y8wMzRyWWRB792lAwkRy+47P7WxN7gohBJw+IyT6th0vBuECCBKa6dEcoQB3Yi2KRzmis1KGPwdIw21qb6fJJw2b3/9XDKRA+Ny0Zrh8WN16AOxj/njZiSN6SdwEVD4zhoCdeKOQdRmh1WaJJVJ6iRoSgI6/5bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789950927; c=relaxed/simple;
	bh=2pvyrG7QUucWS7ATCd6iE/tMVCyElH3eDAzbSwZzvJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUanYJi3PcxESBujjVFdfQur+CPDEIsP3muFiOiSUPH/cRylYNBz2vZV6e2DRvRlQiRDDHvKozYkvNgAa8zRd67yE4+HjTC2K5ndXvBJwM2DrkHCd2KhozHZgp1Afw799f1ja8gjfLfACezNI8tdmgO8rT8j6Ufy3VZHyPYJVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aC8wn0SA; arc=none smtp.client-ip=95.215.58.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aC8wn0SA"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2pvyrG7QUucWS7ATCd6iE/tMVCyElH3eDAzbSwZzvJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789950923; v=1; x=1790555723;
 b=aC8wn0SAUs4qrjGexcZT0abswTQgbfrBExebEzfZxBjbyLlZTPRFZt+y0N/O9lKkhvaRL4Gs
 z10HzuWM6yCx0awR5F1ojKInE2hDPFs7wLJWnk59BAYzjLZYJ7mio3a81yVehGMRmlokm+J57r1
 JO0DkMIch0AEHz7+IRIHRBX8=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d0c77407e1d79bef;
	Mon, 21 Sep 2026 00:35:15 +0000
X-Mizu-Trace-ID: d0c77407e1d79bef
X-Migadu-Flow: FLOW_OUT
Message-ID: <3daa7227-4921-4851-b734-d99b1c4d8bd8@linux.dev>
Date: Mon, 21 Sep 2026 08:35:12 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] smb/server: update POSIX extension specification
 references
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260920055653.114794-1-zhang.guodong@linux.dev>
 <20260920055653.114794-2-zhang.guodong@linux.dev>
 <CAKYAXd8kkDh54n3R2GZX0HrsZEcBSDP2UoyD+ozwomEXSeObYw@mail.gmail.com>
Content-Language: en-US
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAKYAXd8kkDh54n3R2GZX0HrsZEcBSDP2UoyD+ozwomEXSeObYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

These members are already defined in the structure, so the comments can 
be removed.

On 9/20/26 22:03, Namjae Jeon wrote:
>>          /* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
>>          u8 SidBuffer[32];
>> +       /* End of POSIX Create Context Response */
>>          __le32 name_len;
>>          u8 name[];
>> -       /*
>> -        * var sized owner SID
>> -        * var sized group SID
>> -        * le32 filenamelength
>> -        * u8  filename[]
>> -        */
> Is there any reason to delete these?

