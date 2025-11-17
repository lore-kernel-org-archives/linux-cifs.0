Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37613595D;
	Mon, 17 Nov 2025 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763341501; cv=none; b=ph3Kcwaw8v9kw9bxW6Kmh9iU7/i0MK8TYYNr3VdlNXHfvW1YTmvC7pMec1bdYB1WMGijLyV+BySW3336Qn/rIrlbkMSGjsIzhQX7wER68JgYxRIzjCTSEHd4QQjTACt+nJaUdbsMNOLZdwEzYMeylULNnoKCBb3Glhg31nan8Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763341501; c=relaxed/simple;
	bh=i8t2RCMRzGPc04Q3i/nG+oMbUVNWIDTGw5bA/6yhqDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=No93MYw2XLCZyxSCig/zU1itLpYj0T9Cec03tyyTZ7hmKNx6z95NymPb7bEbfiQhV0H/5WBumxED2q4tjQNDi/PubPKgQy9GbS2WimMaoAZEUhgADY1V9ptgu6FqE966q2XLNTp92QpG2X1v8DxIq/E84kEBfbxc5dJA1mz1vtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6b866b50c35111f0a38c85956e01ac42-20251117
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:04207a8d-e48b-4255-8c03-135c68644d09,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:3ee257784a6802761584d725a73bd6e6,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6b866b50c35111f0a38c85956e01ac42-20251117
X-User: chenxiaosong@kylinos.cn
Received: from [10.42.20.206] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1154420332; Mon, 17 Nov 2025 09:04:51 +0800
Message-ID: <a7ae1b5f-255a-40cb-96da-6f8495d4b7b3@kylinos.cn>
Date: Mon, 17 Nov 2025 09:04:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com
References: <20251116065213.282598-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251116065213.282598-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

I have confirmed that when FileSystemName uses flexible array member, 
fsAttrInfo in struct cifs_tcon does not include FileSystemName.

The following part in the CIFSSMBQFSAttributeInfo() function is correct, 
we cannot add MAX_FS_NAME_LEN to sizeof(FILE_SYSTEM_ATTRIBUTE_INFO).

```c
CIFSSMBQFSAttributeInfo()
{
...
	memcpy(&tcon->fsAttrInfo, response_data,
		sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)); // it's correct here
...
}
```

And in the following part of the SMB2_QFS_attr() function, we should 
change it to `memcpy(..., min_t(..., min_len))`.

```c
SMB2_QFS_attr()
{
...
     if (level == FS_ATTRIBUTE_INFORMATION)
             memcpy(&tcon->fsAttrInfo, offset
                     + (char *)rsp, min_t(unsigned int,
                     rsp_len, max_len)); // should use `min_len` here
...
}
```

Thanks,
ChenXiaoSong.

On 11/17/25 07:00, Namjae Jeon wrote:
> On Sun, Nov 16, 2025 at 3:53 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Modify the following places:
>>
>>    - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>>    - Remove MIN_FS_ATTR_INFO_SIZE definition
>>    - Introduce MAX_FS_NAME_LEN
>>    - max_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN
>>    - min_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
>>
>> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>>
>> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Did you check if it is being used here too?
> cifssmb.c:4866:        sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));

