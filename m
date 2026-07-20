Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB98F42086A;
	Mon, 20 Jul 2026 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784552838; cv=none; b=gdNWleqYFaDQL1R+dpSmVOHjoYLz5GD2TiSWmUprCoa+SzzXPGraQhZebQsRDUWEcBeaNGyEG+vsl4W1IyZocGuV1fd8SBoj0EyJmRWWyoRyYiXi1dyqovs6POeNf5jsvhXJD4tUinJjolYRCxTTIHvPcYFty20eMFo0+lqsJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784552838; c=relaxed/simple;
	bh=Bg/MxqYkceHrlCdZVrf+I5hbhGLHZFb2bNd4+Uir3Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLlsJdS3pIm3OO0tiwxwc17zXOyGM8/dcJ83QXqeugX0pkQ168UxABW1nK+zLUVyuHky3ULiEz5k4J8xNv5qlyWFE3IF3DboGNE7rGYLbY6k8DrrHut5Gb9KidGN81xpH7N6T+3L8zXiRZj3FSwwnongl27pfnj5G4EHOFJpMcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e69e3470843b11f1aa26b74ffac11d73-20260720
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4531dc52-7d48-42f2-9d16-cba26d02663f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:4531dc52-7d48-42f2-9d16-cba26d02663f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5ed39ddf064058a5bd781f37c65b5f01,BulkI
	D:260720145755RHFN35RA,BulkQuantity:1,Recheck:0,SF:10|38|64|66|78|80|81|82
	|83|102|127|136|841|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e69e3470843b11f1aa26b74ffac11d73-20260720
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 237866722; Mon, 20 Jul 2026 21:07:03 +0800
Message-ID: <5fa257a4-456e-4917-9249-bb3457952335@kylinos.cn>
Date: Mon, 20 Jul 2026 21:06:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Ralph Boehme <slow@samba.org>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, sprasad@microsoft.com, tom@talpey.comm,
 senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <cover.1784258165.git.tanze@kylinos.cn>
 <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
 <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
Content-Language: en-US
From: tanze <tanze@kylinos.cn>
In-Reply-To: <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thanks for your question. When the CIFS client accesses user.EA, the 
name transmitted over the SMB protocol is simply EA instead of user.EA. 
ksmbd then prepends user. to convert it back to user.EA. If we pass 
every attribute name directly to the VFS unmodified, other types of 
extended attributes will return -EOPNOTSUPP due to missing handlers.

The current workflow works as follows:

Client request                                 --user.EA
↓ CIFS client strips off the "user."
prefix SMB EA layer receives:          --EA
↓ ksmbd adds back the "user."
prefix Server filesystem layer:         --user.EA

After ksmbd finishes mapping to the underlying extended attribute name, 
filesystem compatibility checks, value validation and all related 
operations should be delegated uniformly to |vfs_setxattr()|. This 
mapping logic is not meant to duplicate the full set of xattr namespaces 
supported by the VFS. Instead, it filters which SMB extended attribute 
names get parsed as native Linux xattr names.

I will revise the patch to enable native namespace mapping only when 
both of the following two conditions are satisfied:

   1.The request is sent with POSIX extended attribute parameters;
   2. The mapped server-side user account is root or an account with 
administrative privileges.

Thanks!


在 2026/7/20 14:57, Ralph Boehme 写道:
> On 7/17/26 5:39 AM, Ze Tan wrote:
>> +static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len)
>> +{
>> +    if (ksmbd_is_security_capability_ea_name(name, name_len))
>> +        return true;
>> +
>> +    return false;
>> +}
>> +
>> +static int ksmbd_map_ea_name_to_xattr(bool posix_extensions,
>> +                      const char *ea_name, size_t ea_name_len,
>> +                      char *attr_name)
>> +{
>> +    if (posix_extensions &&
>> +        ksmbd_is_posix_ea_name(ea_name, ea_name_len)) {
>
> why the check for allowed namespaces via ksmbd_is_posix_ea_name() at 
> all and not just pass through whatever the client sends us, pass it 
> down and let the xattr subsystem deal with it?
>
> Still wrapping my head around this so I might be missing something 
> obvious. :)
>
> Thanks!
> -slow
