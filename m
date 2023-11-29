Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315B219BF;
	Tue, 28 Nov 2023 21:46:50 -0800 (PST)
X-UUID: 7e2607461db54185a99458ffd65c0cda-20231129
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:96c9410c-7117-4f93-86ca-159676c708da,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-INFO: VERSION:1.1.33,REQID:96c9410c-7117-4f93-86ca-159676c708da,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-META: VersionHash:364b77b,CLOUDID:e3253273-1bd3-4f48-b671-ada88705968c,B
	ulkID:2311291131566H9M43EO,BulkQuantity:6,Recheck:0,SF:64|66|24|17|19|44|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 7e2607461db54185a99458ffd65c0cda-20231129
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <zhouzongmin@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1982014254; Wed, 29 Nov 2023 13:46:36 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id BB3B5E0080FF;
	Wed, 29 Nov 2023 13:46:36 +0800 (CST)
X-ns-mid: postfix-6566D03C-69019454
Received: from [172.20.12.156] (unknown [172.20.12.156])
	by mail.kylinos.cn (NSMail) with ESMTPA id 85AABE0080FF;
	Wed, 29 Nov 2023 13:46:35 +0800 (CST)
Message-ID: <a0ecf982-2205-48d0-9774-9edb88133821@kylinos.cn>
Date: Wed, 29 Nov 2023 13:46:35 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: initialize ar to NULL
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231120023950.667246-1-zhouzongmin@kylinos.cn>
 <328ad7a1-7c54-4028-ae79-eb25c8c7399b@kylinos.cn>
 <CAKYAXd_FtiMghZ=LCLmOmJer8dHQS-unnVH5cG+75dnAGjmVqA@mail.gmail.com>
Content-Language: en-US
From: Zongmin Zhou <zhouzongmin@kylinos.cn>
In-Reply-To: <CAKYAXd_FtiMghZ=LCLmOmJer8dHQS-unnVH5cG+75dnAGjmVqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Okay,got it.

Thanks

On 2023/11/29 12:47, Namjae Jeon wrote:
> 2023-11-29 12:31 GMT+09:00, Zongmin Zhou <zhouzongmin@kylinos.cn>:
>> Friendly ping. I think this patch was forgotten.
> Sorry for not sharing it, I have merged it into another patch from
> you("ksmbd: prevent memory leak on error return").
>
> Thanks.
>> Best regards!
>>
>> On 2023/11/20 10:39, Zongmin Zhou wrote:
>>> Initialize ar to NULL to avoid the case of aux_size will be false,
>>> and kfree(ar) without ar been initialized will be unsafe.
>>> But kfree(NULL) is safe.
>>>
>>> Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
>>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/smb/server/ksmbd_work.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
>>> index 44bce4c56daf..2510b9f3c8c1 100644
>>> --- a/fs/smb/server/ksmbd_work.c
>>> +++ b/fs/smb/server/ksmbd_work.c
>>> @@ -106,7 +106,7 @@ static inline void __ksmbd_iov_pin(struct ksmbd_work
>>> *work, void *ib,
>>>    static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int
>>> len,
>>>    			       void *aux_buf, unsigned int aux_size)
>>>    {
>>> -	struct aux_read *ar;
>>> +	struct aux_read *ar = NULL;
>>>    	int need_iov_cnt = 1;
>>>
>>>    	if (aux_size) {
>>
