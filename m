Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437EA4908CF
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784969271; cv=none; b=fxi8SgbRJt9FNfTuri0bcSImdEubFKc487vfDs4y987kNovzMJUOUui5RQ0jkvWE+4VPNWlg44k4GqFO/VFvmQz8wY9qeoXGWt1iC7QF1+tbDI0dRxxz4fKsXO9LrHR5rBhsReub5rGGW9PtO4hgEvN76eTz65HsaN2iMzWjZoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784969271; c=relaxed/simple;
	bh=LJWRTzbqkFO4sU/lfZI51bROMEa5Lm4aYO5uu5jEsOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZmzl5NUDsywj1ucxc5WmWDgsqR3z8hUXPEl38AuAqlcNLzgT04bFP/lGKxmG/+jWbvBaoQ5eB4iE64qD4lh+zw0kUxkbfbMlQoPOzF/mbYWxf32fnam0XkdoxNOsGpAkCzy/JXJhBGAzaFOx71VHkS6jCPdOcb94t2ZwfE248E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7f3eed60880511f1aa26b74ffac11d73-20260725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b219524a-8c06-4126-b76f-f2f7b9082a99,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:b219524a-8c06-4126-b76f-f2f7b9082a99,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:1d12b92980cd72ed8b9333b2547d9171,BulkI
	D:260724194959TZ2M46D4,BulkQuantity:3,Recheck:0,SF:10|64|66|78|80|81|82|83
	|101|102|127|136|841|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0
	,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7f3eed60880511f1aa26b74ffac11d73-20260725
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1948629357; Sat, 25 Jul 2026 16:47:41 +0800
Message-ID: <d680a27a-49f2-4214-8ad1-5718c95ed4f6@kylinos.cn>
Date: Sat, 25 Jul 2026 16:47:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
 "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
Content-Language: en-US
From: tanze <tanze@kylinos.cn>
In-Reply-To: <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I completely agree with you. Updating the protocol would make the rules 
clearer and the code simpler.

The patch set I am submitting now was written without changing the 
protocol and reflects my previous approach.

My original idea was to use this patch set to support some additional 
EAs without bumping the protocol version. Once the protocol design has 
been fully discussed and finalized, and the protocol version is bumped, 
the relevant code can then be updated accordingly to support the new 
protocol.



Thanks,
Ze


在 2026/7/25 16:24, Ralph Boehme 写道:
> thanks!
>
> I'm personally strongly leaning towards having a protocol design that 
> carries the namespace for *all* namespaces including user. Special 
> casing the user namespace just for the sake of avoiding a clean design 
> with a protocol version bump should be avoided.
>
> As said before, I'm happy to help and work on the protocol spec and 
> documentation side of things.
>
> I suggest we wait for more feedback on the design from others, 
> particularly Volker, metze, Jeremy and Tom.
>
> Thanks!
> -slow 
