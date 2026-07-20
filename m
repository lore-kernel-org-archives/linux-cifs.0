Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413F23B6BFA;
	Mon, 20 Jul 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537672; cv=none; b=tRfeto591eYE0LRe8xl0P5MHi3tepG98SaO537nJzMzxSa2+AC2l1pZqyG+m+GUDWOG6b5ro/EeSwA6iCZ/759/UzGDztXJQvGtWwzDY9X0itV8KpUMypHMpT3pdNFa6yejrGZrU5tM3JQbk0I5M7OxzeoVkrwtnmVfZxmQZF60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537672; c=relaxed/simple;
	bh=cMLxNCFDkmJ+/8gmXF+kOrIXjGOh/qpdPwi7oVbcXBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OkxZDBJ7r1ah8aOeEO2S1QdPaWJdveAJ134hY18Ss4E8vLUb9WYK+MSZBbn77Yd5M4icrMeic+AsnFI9aXDKAukE82peTbQDHl4twrFdm7uhrYcf5AWU+GQd6yqN4Hr7R2z1DoqIncp32UPUuKEODRzMO1wuhLdQW0sTGfW5I5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 980def4e841811f1aa26b74ffac11d73-20260720
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:65a33d85-d6c6-4530-8f71-c83bbd772659,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:65a33d85-d6c6-4530-8f71-c83bbd772659,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:9b5be58c66efdea6743ff1b89196c4bf,BulkI
	D:260720165421GU79PTA9,BulkQuantity:0,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:ni
	l,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0
	,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 980def4e841811f1aa26b74ffac11d73-20260720
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 263768294; Mon, 20 Jul 2026 16:54:19 +0800
Message-ID: <3c9765b9-f3df-4f9c-a72d-4b385cb6fb85@kylinos.cn>
Date: Mon, 20 Jul 2026 16:54:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 9/9] ksmbd: avoid self oplock breaks for EA opens
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, pc@manguebit.org, sprasad@microsoft.com,
 tom@talpey.comm, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1784258165.git.tanze@kylinos.cn>
 <37f280818ac592b7e641d08325b4c10ae6bb7c99.1784258165.git.tanze@kylinos.cn>
 <CAKYAXd8A+A2OqOqgVVOdaTqC+hvu6kjQzgOtD40s55F9cwGJbQ@mail.gmail.com>
Content-Language: en-US
From: tanze <tanze@kylinos.cn>
In-Reply-To: <CAKYAXd8A+A2OqOqgVVOdaTqC+hvu6kjQzgOtD40s55F9cwGJbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

You are right, my handling here is flawed. The logic cannot rely solely 
on matching sessions, as a single SMB session can hold multiple 
independent file open handles.

I will remove the session-based special exception logic on the server 
side and rework the complete fix on the client side.


在 2026/7/20 13:34, Namjae Jeon 写道:
> On Fri, Jul 17, 2026 at 12:40 PM Ze Tan <tanze@kylinos.cn> wrote:
>> generic/093 writes to a file after setcap sets security.capability. The
>> CIFS client can reopen the file to query or update EAs while the same
>> session holds an oplock. ksmbd breaks this oplock and waits for the same
>> client, so the write can block.
>>
>> Skip the oplock break for same-session EA or metadata opens. Keep the
>> normal break when another session holds an oplock.
> A session can own multiple independent opens. Why is session identity
> sufficient to conclude that an EA/metadata-only open may bypass the
> existing exclusive or batch oplock break? Oplock state and break
> notifications are associated with an individual open, rather
> than the session as a whole. Could you point to the SMB specification text ?
