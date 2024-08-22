Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EB41D1316;
	Thu, 22 Aug 2024 01:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724288515; cv=none; b=mK+uv+wL+W52JfKky/DvwsmKFuVLx2VnVaQi4r8z1Qo1xofsOh/Qy8tw0CS/LZhArqKZDHrbhHn1aADN/wjqAH0ZflpOnWOvqwrGh/EmFoRYdGjrsme7NdHC2fLd24bELcA+BG7v54f/GGemqiJ/2pRG77Y47vqL3FFHgK1ftdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724288515; c=relaxed/simple;
	bh=GrWUXGZxAo3zB05ftoSwm5wCxyAwLv2N24W6lfKi7ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ravb2ZhOLM0gZ8CH/wSWqCyhACaHViOu9MNqJCJr0iIHzt4SLu5s50DZnC7ZCmJahGpFEzqa9nOk7fWSelXNgucxNSka7F8m5gPZqELD9azha2dsCqAzbmrJCGTlVm4Te31E0HVS2qU2j+eOx0npKPphShfXpgqOmOELpDLDc3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz4t1724288385ti5jdib
X-QQ-Originating-IP: D/Uhbekbc7o4Swvn8dI4oKjkVNdBoIpmYCFKMlCzgds=
Received: from [192.168.3.231] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 08:59:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13306384276286975094
Message-ID: <F9BB72E1C6B6AFFD+37b5bda8-2488-439a-8203-e0c376fae679@chenxiaosong.com>
Date: Thu, 22 Aug 2024 08:59:42 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] smb/server: fix potential null-ptr-deref of
 lease_ctx_info in smb2_open()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn,
 liuyun01@kylinos.cn
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
 <20240820143319.274033-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_N2Hgba2EsDkem7mmGrWxxpXOtz4L_ReXwqUCG_BRU=w@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_N2Hgba2EsDkem7mmGrWxxpXOtz4L_ReXwqUCG_BRU=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

Thanks for your reply. I will send v2 patchset soon based on your 
suggestions.

在 2024/8/22 08:41, Namjae Jeon 写道:
> On Tue, Aug 20, 2024 at 11:35 PM <chenxiaosong@chenxiaosong.com> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
>> and parse_lease_state() return NULL.
>>
>> Fix this by returning error pointer on parse_lease_state() and checking
>> error.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> We intended for it to return null. We shouldn't handle the error even
> if it fails.
> All places check if lc is null except the one.
> We can fix it like the following one. please send this patch if you are okay.
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index b6c5a8ea3887..884e21992c92 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3404,7 +3404,7 @@ int smb2_open(struct ksmbd_work *work)
>                          goto err_out1;
>                  }
>          } else {
> -               if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
> +               if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
>                          if (S_ISDIR(file_inode(filp)->i_mode)) {
>                                  lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
>                                  lc->is_dir = true;
> 
> 
>> ---
>>   fs/smb/server/oplock.c  | 11 +++++++----
>>   fs/smb/server/smb2pdu.c | 17 ++++++++++++-----
>>   2 files changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
>> index a8f52c4ebbda..e8591686a037 100644
>> --- a/fs/smb/server/oplock.c
>> +++ b/fs/smb/server/oplock.c
>> @@ -1510,7 +1510,8 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
>>    * parse_lease_state() - parse lease context containted in file open request
>>    * @open_req:  buffer containing smb2 file open(create) request
>>    *
>> - * Return:  oplock state, -ENOENT if create lease context not found
>> + * Return: allocated lease context object on success, otherwise error pointer.
>> + *        -ENOENT pointer if create lease context not found.
>>    */
>>   struct lease_ctx_info *parse_lease_state(void *open_req)
>>   {
>> @@ -1519,12 +1520,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
>>          struct lease_ctx_info *lreq;
>>
>>          cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
>> -       if (IS_ERR_OR_NULL(cc))
>> -               return NULL;
>> +       if (!cc)
>> +               return ERR_PTR(-ENOENT);
>> +       if (IS_ERR(cc))
>> +               return ERR_CAST(cc);
>>
>>          lreq = kzalloc(sizeof(struct lease_ctx_info), GFP_KERNEL);
>>          if (!lreq)
>> -               return NULL;
>> +               return ERR_PTR(-ENOMEM);
>>
>>          if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
>>                  struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>> index d8a827e0dced..119c1ba5f255 100644
>> --- a/fs/smb/server/smb2pdu.c
>> +++ b/fs/smb/server/smb2pdu.c
>> @@ -2767,8 +2767,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
>>                                  }
>>                          }
>>
>> -                       if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
>> -                            req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
>> +                       if ((!IS_ERR_OR_NULL(lc) > 0 &&
>> +                            (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
>> +                           req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
>>                                  dh_info->CreateGuid =
>>                                          durable_v2_blob->CreateGuid;
>>                                  dh_info->persistent =
>> @@ -2788,8 +2789,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
>>                                  goto out;
>>                          }
>>
>> -                       if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
>> -                            req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
>> +                       if ((!IS_ERR_OR_NULL(lc) &&
>> +                            (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
>> +                           req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
>>                                  ksmbd_debug(SMB, "Request for durable open\n");
>>                                  dh_info->type = dh_idx;
>>                          }
>> @@ -2935,8 +2937,13 @@ int smb2_open(struct ksmbd_work *work)
>>                          ksmbd_put_durable_fd(fp);
>>                          goto reconnected_fp;
>>                  }
>> -       } else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
>> +       } else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
>>                  lc = parse_lease_state(req);
>> +               if (IS_ERR(lc)) {
>> +                       rc = PTR_ERR(lc);
>> +                       goto err_out2;
>> +               }
>> +       }
>>
>>          if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
>>                  pr_err("Invalid impersonationlevel : 0x%x\n",
>> --
>> 2.34.1
>>
> 
