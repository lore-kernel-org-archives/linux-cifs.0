Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE162E1EE0;
	Mon, 20 Jul 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529423; cv=none; b=OFKfLR0xM1O8qjLc5QasWtxmMy6p9kJdw1eletjho0VFE4qawxRCLgrLo6nEhatxXlYySCJO3OoxOalVouzwUSNtWSZ+BdLQlILPqjRecLL7i462By8Y2+TL5fkC/CHSPL/Bw/If/xCBgQJUCuvpOu2sRGg5NXSYwna5vwJw8/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529423; c=relaxed/simple;
	bh=5QXqYpBg5LjozAt06CkM0asWX+14sSCCVhNutIJU+LQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdOJmEhwO95GLHU9v0GdmIsgQomcK6bcU2LRWad1f7MWAbd7unZSCCa01eLoByJcHoYhYnIb6dKXTLbT0mHlaNI5W5vZ2HMX6beHb0vjwfdN+ZMkbpYKL+kgkf834wJsaydBszlIm5iBcCJAzDEkGo9fPInWWCgYCabogEVD37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 66106930840511f1aa26b74ffac11d73-20260720
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ac795f40-2ec2-4293-a1a0-5f6b786cb3c7,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:ac795f40-2ec2-4293-a1a0-5f6b786cb3c7,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:78967a838c4b45716bd704c9870e1ea2,BulkI
	D:260720130420Z3XN6ZOS,BulkQuantity:2,Recheck:0,SF:10|66|78|81|82|83|102|1
	27|136|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 66106930840511f1aa26b74ffac11d73-20260720
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 8211124; Mon, 20 Jul 2026 14:36:54 +0800
Message-ID: <bfc0a735-d047-4a02-a47c-871eabdb1c41@kylinos.cn>
Date: Mon, 20 Jul 2026 14:36:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 7/9] ksmbd: support security.xfstests EAs
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, pc@manguebit.org, sprasad@microsoft.com,
 tom@talpey.comm, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1784258165.git.tanze@kylinos.cn>
 <a5a362d962c22a0f447c1398db5256be5399488c.1784258165.git.tanze@kylinos.cn>
 <CAKYAXd-iOpGsVBb3phdDVsNGf0doEzhHuKENB-cqHFc+AD8fFg@mail.gmail.com>
Content-Language: en-US
From: tanze <tanze@kylinos.cn>
In-Reply-To: <CAKYAXd-iOpGsVBb3phdDVsNGf0doEzhHuKENB-cqHFc+AD8fFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

That’s what I came to think later. My plan is to place it under the 
security.* extended EA namespace, and we can add more entries if further 
requirements arise. I will push a revised code version in a couple of days.

在 2026/7/20 13:03, Namjae Jeon 写道:
> Is it appropriate to special-case an xfstests-only xattr name in ksmbd?
> Could the security namespace support be implemented using a general,
> well-defined policy instead?
> Thanks.
