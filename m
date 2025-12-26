Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845D6277017
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766792817; cv=none; b=Yg4c4H+VMYuiaMWIrvj/iYP7vyDhqu0vbmWo0lUtmSv1zvkFPtpMZTHIJ0fixR1DMR05SG3w7c2SkkB1rALa0aPw1ZnloZ7GAHGbFIvANBY46HduCRPVeT5inF9YqgYtMEAdOywVXBQEV6gBX1C/nxgzeM4uSjFeurwPy0fgyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766792817; c=relaxed/simple;
	bh=Qs9x7lXT5MD60U0kEYGynWKP1KqiPmQuGE8Rcklc7WE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NvFcId7hr0TtB6WWZ6zlvlt0+7ZK16BGd3khXIJ41HQDUT1w5/MZXdzbdGsQ3VFLpHgSo9fzeiG4Sgq5IpKoE82ou3hLjPRgYDccblTL3FaHDp29YsjxQHnov/2+lslXjnleTY2QgptMA7+2YaOCuv4IvBrkyBFHmvkUluP2X/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fJHFZjjf; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fJHFZjjf"
Message-ID: <2feaf0ac-172d-431c-805c-7b3440f1ebd5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766792812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiQBe71aN5XuEa7sgZEhrdHKf2VWYhH5t23Vrnr8mQA=;
	b=fJHFZjjfMVjS5jO1NmGaQm6TGtI5wFL2YbPJQcBWf5vNfobfC0rBqWCXx1uEZGy4BMHFlt
	z7VdSb9SsGDbG3/AYVvn4vwUbR6Lcdd/ySQFe82+NeF6P6mqnqxxmso/fYEQpuJuSYK/uO
	Zg5vXFlpFO3jvjjrOn7f9GvEe2xMD/Y=
Date: Sat, 27 Dec 2025 07:46:35 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Steve French <smfrench@gmail.com>,
 Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Youling Tang <tangyouling@kylinos.cn>, Namjae Jeon
 <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
 <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
 <b75f093a-6546-4b90-b4d0-879aa81cd327@linux.dev>
 <7duojyv45sv3x65fmaggbhl2rydgisaqesedqqbrk2pg6jyo5m@2cwq23g2sw2v>
 <1afdefff-0ce5-4875-b480-0b3aba541d28@linux.dev>
 <CAH2r5mtaGgiWLnMebWeGNoyVKY81xj6DkZY5iTmWkJZ_gvyeLw@mail.gmail.com>
 <7919537a-d3b5-45cd-9032-0a5312b28dfb@linux.dev>
Content-Language: en-US
In-Reply-To: <7919537a-d3b5-45cd-9032-0a5312b28dfb@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/24/25 11:02 PM, Henrique Carvalho wrote:
> If a later iteration populates more
> chunks than a previous one, the stale smaller value trips UBSAN.

The commit message may also need to be updated, since the UBSAN error 
can be triggered on the first loop iteration.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/27/25 7:02 AM, ChenXiaoSong wrote:
> Hi Henrique,
> 
> Thanks for your patch.
> 
> You could resend the patch as a standalone email instead of an 
> attachment, and include some additional information, such as links to 
> the relevant mailing list discussions.
> 
> Additionally, please add my colleague's Tested-by: "Tested-by: Youling 
> Tang <tangyouling@kylinos.cn>".
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> On 12/27/25 6:51 AM, Steve French wrote:
>> It should bake in for-next for at least a few days so can send next to 
>> Linus Tuesday or Wednesday if reviews and tests ok
> 

