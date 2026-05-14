Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778683B5F59
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765116; cv=none; b=Yg1A1V+mwTgxIwrR/GquJzGvOzBWjsfBrkDIOcnllLhAltODrsJ3Lq/JaWNhzhZUQFtidD0qblI1zGnC8GNEEN2gmCn+TjNC1VMh5x+uLiYlPqOaagAsxu2yVxLryCWfF/VRO3aIO04eTE5srRIUNihISFnOrXDyFM3EoIM1f3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765116; c=relaxed/simple;
	bh=XSulnla55KrlB7u3eUhylZgk9jZxOiOcStCASQUNHyQ=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Zeu9Y6EWJVE49+kw+Dko0Sw0YjRsDrGmJngcUuYawXXELm5guhJPRigJ4q86e+mHp0boeVZdiSZp4/9Qop0N8w535zL6YRnp6DBQy/ALSot9P1yu8uNYwWDFiyR0Wmg2oy3mMTc7KwtmeXfz6AAVUqsaiJ8wCgozQLJw3DnqvCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGWJ76d53zKHLxt
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 21:24:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A024440562
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 21:25:03 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgAHz1otzQVqkewaCQ--.49550S3;
	Thu, 14 May 2026 21:25:03 +0800 (CST)
Subject: Re: [PATCH] smb/client: fix possible infinite loop and oob read in
 symlink_data()
To: Steve French <smfrench@gmail.com>, Ye Bin <yebin10@huawei.com>
References: <20260513081205.1018080-1-yebin10@huawei.com>
 <CAH2r5mv8X_1QoMHnRg-r1+uLFvH+W-rh+t93Ne1Xj40wFtmShA@mail.gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, linux-cifs@vger.kernel.org, tom@talpey.com,
 bharathsm@microsoft.com, samba-technical@lists.samba.org,
 chenxiaosong@kylinos.cn
From: yebin <yebin@huaweicloud.com>
Message-ID: <6A05CD2D.6010106@huaweicloud.com>
Date: Thu, 14 May 2026 21:25:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAH2r5mv8X_1QoMHnRg-r1+uLFvH+W-rh+t93Ne1Xj40wFtmShA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHz1otzQVqkewaCQ--.49550S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1UGF13Jw1rZFyUXF1fJFb_yoW8uF1fpF
	4rG3WDCr45Jw1Uuw1kt34jvw13KrW0yFn5Krn8Ka43XF9xGrn5Kryktr9Igryv9a4rXw4S
	kr1qvFWIyFWayFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

Hi Steve,
I have simplified the patch according to the review comments from Sashiko
and sent the V2 version. Please pay attention to it.


On 2026/5/14 1:58, Steve French wrote:
> merged into cifs-2.6.git for-next
>
> On Wed, May 13, 2026 at 3:15 AM Ye Bin <yebin10@huawei.com> wrote:
>>
>> On 32-bit architectures, the infinite loop is as follows:
>>
>>    len = p->ErrorDataLength == 0xfffffff8
>>    u8 *next = p->ErrorContextData + len
>>    next == p
>>
>> On 32-bit architectures, the out-of-bounds read is as follows:
>>
>>    len = p->ErrorDataLength == 0xfffffff0
>>    u8 *next = p->ErrorContextData + len
>>    next == (u8 *)p - 8
>>
>> Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2file.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
>> index b292aa94a593..9d6f342b3f82 100644
>> --- a/fs/smb/client/smb2file.c
>> +++ b/fs/smb/client/smb2file.c
>> @@ -31,7 +31,7 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
>>          u32 len;
>>
>>          if (err->ErrorContextCount) {
>> -               struct smb2_error_context_rsp *p;
>> +               struct smb2_error_context_rsp *p, *next;
>>
>>                  len = (u32)err->ErrorContextCount * (offsetof(struct smb2_error_context_rsp,
>>                                                                ErrorContextData) +
>> @@ -49,7 +49,10 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
>>                                   __func__, le32_to_cpu(p->ErrorId));
>>
>>                          len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
>> -                       p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
>> +                       next = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
>> +                       if (next <= p)
>> +                               return ERR_PTR(-EINVAL);
>> +                       p = next;
>>                  }
>>          } else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
>>                     iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
>> --
>> 2.34.1
>>
>>
>
>

