Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF121257E;
	Tue,  9 Dec 2025 00:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765241144; cv=none; b=B7sRDFNCa1rP8/tPUsRp1WdCBeN15g4QxIA1tLKTWMfHEfPgq8FtWS89VbqRVTWG3IUGeajZA+2U5DBQT8hXScIMuBugmqLOFqbBse1LR12NREzqRyZX9npHEaiswBXNKUx4ccfe7mOsX6lgNzMgq8PNR5wLjDKkFw0GAE2JXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765241144; c=relaxed/simple;
	bh=HykdT2GKmjfex48gbsFpOPGzq0/kWkKwNe4qorAngn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ppYSiMjn/NmMxXc6eWP/EQyqkM2zQizeCoHV2ywep5iB0oFpxdjda5tCFi7t787gryBAE/ySwmTY05OkD+z7sOSc0IbTQlb0ae67KETEEOSsgLIB7rIuODF024E7li/Lp9vC6ErV387M20XoaagVq57yi/6UGw2uUe+5KDI3R24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 608bf190d49811f0a38c85956e01ac42-20251209
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:7901da74-56f1-468f-bb9e-4bd27280e90a,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:6cd7000c9c20df77e73fc262f3bda1bf,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 608bf190d49811f0a38c85956e01ac42-20251209
X-User: chenxiaosong@kylinos.cn
Received: from [10.42.20.206] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1477027136; Tue, 09 Dec 2025 08:45:36 +0800
Message-ID: <3a65cd8c-4e13-412d-933a-c4e451ec9658@kylinos.cn>
Date: Tue, 9 Dec 2025 08:45:33 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/30] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
To: Steve French <smfrench@gmail.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, linkinjeon@kernel.org,
 linkinjeon@samba.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, liuzhengyuan@kylinos.cn, huhai@kylinos.cn,
 liuyun01@kylinos.cn
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251208062100.3268777-2-chenxiaosong.chenxiaosong@linux.dev>
 <93da5441-e942-427c-aa7f-138d7e750ca5@kylinos.cn>
 <CAH2r5mtQPx3K20bsOrZFHHwQsy4yMGMTYJx1X0vJqXG=dYDwWA@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <CAH2r5mtQPx3K20bsOrZFHHwQsy4yMGMTYJx1X0vJqXG=dYDwWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

OK, I'll try to write a script in my spare time to compare these values 
with the documentation.

Thanks,
ChenXiaoSong.

On 12/9/25 08:29, Steve French wrote:
> These (return code, NT STATIUS code names) are unlikely to change much
> so probably would not need to regenerate, although wouldn't hurt to
> check every year or so.
> 
> On Mon, Dec 8, 2025 at 6:17 PM ChenXiaoSong <chenxiaosong@kylinos.cn> wrote:
>>
>> Hi Steve and Namjae,
>>
>> Some of these macro values seem to differ from the documentation
>> (possibly due to typos or updates in the docs). Should we, like Samba,
>> use a script to automatically regenerate these macro definitions on a
>> regular basis?
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 12/8/25 2:20 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>
>>> This was reported by the KUnit tests in the later patches.
>>>
>>> See MS-ERREF 2.3.1 STATUS_NO_DATA_DETECTED. Keep it consistent with the
>>> value in the documentation.
>>>
>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>> ---
>>>    fs/smb/client/nterr.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
>>> index 180602c22355..4fd79a82c817 100644
>>> --- a/fs/smb/client/nterr.h
>>> +++ b/fs/smb/client/nterr.h
>>> @@ -41,7 +41,7 @@ extern const struct nt_err_code_struct nt_errs[];
>>>    #define NT_STATUS_MEDIA_CHANGED    0x8000001c
>>>    #define NT_STATUS_END_OF_MEDIA     0x8000001e
>>>    #define NT_STATUS_MEDIA_CHECK      0x80000020
>>> -#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
>>> +#define NT_STATUS_NO_DATA_DETECTED 0x80000022
>>>    #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
>>>    #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
>>>    #define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
>>
> 
> 

