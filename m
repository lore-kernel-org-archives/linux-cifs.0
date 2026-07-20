Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E71C84BB;
	Mon, 20 Jul 2026 06:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529249; cv=none; b=VYHpYN1se55BaLxscmNKmmxPSIAsEMFweZozSxOtfIP7jVeYUEUW19XU6qy/f14vL2yhP9XpDPdf1P73iJSLHBOMvktiwcw8v32ls/ea5AnL2t6nq5k+pQaCawpwEU6wcby7q7mPWN+bPjGeR/9DpSfs02XZJUlWaQnNANwOmFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529249; c=relaxed/simple;
	bh=VSMitZEvOosRiG+h4omrNsPldp1p5trnsXqNREXP9Yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nD14Z8DIKJXe4K6Yv7a7rZSorb3a6eIAuxC+7Qo5YlHfbTNTCxX5Gm3O9wG+l3qqDzMI8fCBxqynXf6js3ApYEHugQVF0jxQ6aIkgD4+l+GUf7xFEcplIEFHy+2XlnTEKqJv7X7kq/Ef0cMEUHWjghX+Fhx8kcFyw76EdsmRxJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ff297d92840411f1aa26b74ffac11d73-20260720
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:34d5fcfc-c38f-4bc1-92e4-38be1300bc2e,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:34d5fcfc-c38f-4bc1-92e4-38be1300bc2e,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:b8471de0a1ecbe378e35ce4612439d20,BulkI
	D:260720130420Z3XN6ZOS,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ff297d92840411f1aa26b74ffac11d73-20260720
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1157534180; Mon, 20 Jul 2026 14:34:02 +0800
Message-ID: <3ade9257-ef47-4bd9-8178-113c7d86c417@kylinos.cn>
Date: Mon, 20 Jul 2026 14:33:44 +0800
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

This is how the current version works, but I believe there is an issue 
with it. Three days ago, I sent a private email to you and Steve 
outlining my proposal for improvement, which leverages the SMB3 POSIX 
extensions to implement this feature. However, your email system blocks 
messages from me, so I was unable to forward the email to you successfully.

在 2026/7/20 13:03, Namjae Jeon 写道:
>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>> index 2159b45c80a6..da3d5c217577 100644
>> --- a/fs/smb/server/smb2pdu.c
>> +++ b/fs/smb/server/smb2pdu.c
>> @@ -2650,11 +2650,21 @@ static bool ksmbd_is_security_capability_ea_name(const char *name,
>>                 !strncmp(name, XATTR_NAME_CAPS, name_len);
>>   }
>>
>> +static bool ksmbd_is_security_xfstests_ea_name(const char *name,
>> +                                              size_t name_len)
>> +{
>> +       return name_len == sizeof(XATTR_SECURITY_PREFIX "xfstests") - 1 &&
>> +              !strncmp(name, XATTR_SECURITY_PREFIX "xfstests", name_len);
> Is it appropriate to special-case an xfstests-only xattr name in ksmbd?
> Could the security namespace support be implemented using a general,
> well-defined policy instead?
> Thanks.
