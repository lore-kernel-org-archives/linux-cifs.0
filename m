Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482F13C816
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748405519; cv=none; b=U62kj/TGTOJiF73Ny2kJGSls2exqTThRzbgNpB0onRdM4Uqk9LCaAXppgQI7LyDc0i8OwYDZgnSvAXuQf7Eomvg3l6tiz5nwxHTymJFc7pFIf736axygONF6Xb7YBmLfqA+s8zqStfNu2G5KR/NcxM/ZN3TlWBFgZkjbVgX+mmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748405519; c=relaxed/simple;
	bh=hlkY2UnwS2X9PoR6gQ2SIXXXnrL2PXxoo85bg6yIUbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ovo74Z7OE0GvPiX8VgS/ss8F6bBs0/fYPydimxSj/z0cB720SqF83Q7gg5mb+UJW15vmf3hI2hTBHUwmJ3XO3zl/G07zimsAwGrEfhuHjQuOk5M5gYYRcU8XXFoAYx6O65v+TeB1zzz7UGToTli1Z0t7K4Gf62VEoe6hqDIgMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpsz19t1748405343t0434c731
X-QQ-Originating-IP: NwjThKqgRnNipc/Nq5ZYdlUS87D/gsFjAfql9alCxk0=
Received: from [192.168.3.231] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 28 May 2025 12:09:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12572820072714361507
Message-ID: <01BDDAE323133ED0+e7d23f35-c6d8-48a3-8fe6-c23e3a9c64dc@chenxiaosong.com>
Date: Wed, 28 May 2025 12:09:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/client: use sock_create_kern() in
 generic_ip_connect()
To: Steve French <smfrench@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>,
 David Laight <david.laight.linux@gmail.com>,
 Wang Zhaolong <wangzhaolong1@huawei.com>, Enzo Matsumiya <ematsumiya@suse.de>
References: <20250528031531.171356-1-chenxiaosong@chenxiaosong.com>
 <CAH2r5mtAYV925FbL-5GPGvk3wMG5u0027_icNtUw6uZ9yOBqyw@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mtAYV925FbL-5GPGvk3wMG5u0027_icNtUw6uZ9yOBqyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: OAHLEV5KK0ozapOJgcP+Kg4iCibkRqwfuHdj3rCEY3AnqhLQTJw98D6r
	xd3VNTPViy4v67YE3bFWFiXJ/5k9lDOYLEMt1/4zTRrUIsHhBehaAreCDD6IwCIYOoqO7G+
	tvkgQmhyrehdWgnk5enmIHua/GKrrOGBRduVJItlyAJlMs5lDRwyXZoODXNxdh8wXDwaAGC
	avuILauA74Dw9cnAbkpnWvI0VUqqVOemiPWvIuprne8Oj3pacu6HKKzGtK0nYB1nHvusuW+
	DYdwy42ixbhAE1727NF0Qqmt9my4PbE3sN/rUyy9gIIPYhLnIyD2bjzEtduoYS0lvTciz9t
	pV2ku40LHK/nXp1uREEtOUi98NtTFcsJskMy31hHlhNNZO8Z07Ym7tj58PEpaJOlSxDnlki
	ntvW8rxc1Gtkyxpm+CA7XjhuWu55dtk5SeB+YVAXW4LE9ZlDYWXW7wO1GT8LzfQwpLTfR4F
	oye0464NIYE0p8zk8tHNzS/8KVfncPQQ9SlCPUbUgue/v+2Vke7xgnBeRyzpWE1a7jo2Lgl
	6iA38aRf9m+MpcNHRZNuHC5jQdhCrBla28lQyDrWpsYCsh/LKeNbq23zPx/NEH5iBl7RBVw
	JOGIhLE5iqvBXaEtT85cbc4dNakbMRLezwRf6wFOHzAA6A7PaxhN+nle4BtSKAF1hkhBODG
	z28lg47r2SXw1da+YFhSua0kxKvKuQC0VMqHlYUjIl35XLaq46T91sk3ZLkAhdA6+OkMIFK
	wsQyk78K68PhyEGsGFcU2ou/c0M0dN6Vqh7neD23HBLJLyXE4YIJChDrXfbVpOPdmc2GY7h
	3MIyTot0bMcsWi34Fax6V7ook1pt9zLbISMIvPhXBnFHY51g7squ9oRrSN+vyV7hI3A553t
	SIUdAcmkXCwsU4BnjFHoTMjA7T6CvIdMPrj08W2a3OV4VgdyVYIx6MD4cD0o6PMC5Ga5pLG
	qnDL+8YAL8jwZ3bKGmBa+O+JQ5w+8qisHS/Gq11sdmMam8/qaMVNcTcoMPLf4VyVBPg8=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

This patch is simply a cleanup that wraps the original code for 
explicitness, the last argument of __sock_create(..., 1) specifies that 
the socket is created in kernel space.

在 2025/5/28 11:39, Steve French 写道:
> Weren't there issues brought up earlier with using sock_create_kern
> due to network namespaces and refcounts?
> 
> On Tue, May 27, 2025 at 10:18 PM <chenxiaosong@chenxiaosong.com> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Change __sock_create() to sock_create_kern() for explicitness.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/connect.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> index 6bf04d9a5491..3275f2ff84cb 100644
>> --- a/fs/smb/client/connect.c
>> +++ b/fs/smb/client/connect.c
>> @@ -3350,8 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
>>                  struct net *net = cifs_net_ns(server);
>>                  struct sock *sk;
>>
>> -               rc = __sock_create(net, sfamily, SOCK_STREAM,
>> -                                  IPPROTO_TCP, &server->ssocket, 1);
>> +               rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
>>                  if (rc < 0) {
>>                          cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
>>                          return rc;
>> --
>> 2.34.1
>>
>>
> 
> 


