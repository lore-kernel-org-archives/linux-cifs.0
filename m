Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3154C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 18:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A4D610D1
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhIVSqD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:46:03 -0400
Received: from p3plsmtpa06-07.prod.phx3.secureserver.net ([173.201.192.108]:46073
        "EHLO p3plsmtpa06-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhIVSqC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 14:46:02 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id T7ENmvxMSC8uoT7ENmk7Eh; Wed, 22 Sep 2021 11:44:32 -0700
X-CMAE-Analysis: v=2.4 cv=d6AwdTvE c=1 sm=1 tr=0 ts=614b7990
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8
 a=2TLz6fa85pcNRDTGuLUA:9 a=QEXdDO2ut3YA:10 a=HvKuF1_PTVFglORKqfwH:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
To:     Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
References: <20210922012651.513888-1-hyc.lee@gmail.com>
 <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <8e1f9be3-23fb-5fce-2489-25935d6bd704@talpey.com>
Date:   Wed, 22 Sep 2021 14:44:32 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfEz2FuvojnuD0mHqEZPC4RzlaHXN7igqtdWhAECQOYRHPVxNIwbnsxmXnNYjSoDrr2+EBGlXhqmMNanbqop70+Q1ZLNLLtFg1znt9mAkQPxuBWXmF1VJ
 RZjMdxawAbPpM0A5lX9BnmtqqP0N/J3u7X2zL3yuQmXDAEyZhjwwfKf0W/n1yX1SZA8CfqUIEh2181NmOBg01bLQbJ/TR8Kh46GlVvtI0CoYv+7F5t/NWGCH
 P8oFId48PZlVsgmLyszKoBoLVwr3wKyugnhhVkrLPr2e8OtfpuMPj+c3kLa8YnAZI4j/kok9dIfyWHdwLE/CH5JdMW5o8f9kvSFH70Jz5tUXZIKCqhI2TlK8
 0yj9266o
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ralph's overflow check comments are spot-on, and should
be addressed even though he adds "?" to them. :)

Tom.

On 9/22/2021 9:08 AM, Ralph Boehme wrote:
> Hi Hyunchul,
> 
> patch looks excellent, few more nitpicks below.
> 
> Am 22.09.21 um 03:26 schrieb Hyunchul Lee:
>> Add buffer validation for SMB2_CREATE_CONTEXT.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph Boehme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>> Changes from v2:
>>   - check struct create_context's fields more in smb2_find_context_vals
>>     (suggested by Ralph Boehme).
>>
>>   fs/ksmbd/oplock.c  | 34 ++++++++++++++++++++++++----------
>>   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
>>   fs/ksmbd/smbacl.c  |  9 ++++++++-
>>   3 files changed, 56 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> index 16b6236d1bd2..8f743913b1cf 100644
>> --- a/fs/ksmbd/oplock.c
>> +++ b/fs/ksmbd/oplock.c
>> @@ -1451,26 +1451,40 @@ struct lease_ctx_info *parse_lease_state(void 
>> *open_req)
>>    */
>>   struct create_context *smb2_find_context_vals(void *open_req, const 
>> char *tag)
>>   {
>> -    char *data_offset;
>> +    struct smb2_create_req *req = (struct smb2_create_req *)open_req;
>>       struct create_context *cc;
>> -    unsigned int next = 0;
>> +    char *data_offset, *data_end;
>>       char *name;
>> -    struct smb2_create_req *req = (struct smb2_create_req *)open_req;
> 
> this line is only moved, not changed. Can we remove this change from the 
> diff?
> 
>> +    unsigned int next = 0;
>> +    unsigned int name_off, name_len, value_off, value_len;
>>       data_offset = (char *)req + 4 + 
>> le32_to_cpu(req->CreateContextsOffset);
>> +    data_end = data_offset + le32_to_cpu(req->CreateContextsLength);
> 
> do we need overflow checks here? At least on 32-bit arch this could 
> easily overflow.
> 
>>       cc = (struct create_context *)data_offset;
>>       do {
>> -        int val;
>> -
>>           cc = (struct create_context *)((char *)cc + next);
>> -        name = le16_to_cpu(cc->NameOffset) + (char *)cc;
>> -        val = le16_to_cpu(cc->NameLength);
>> -        if (val < 4)
>> +        if ((char *)cc + offsetof(struct create_context, Buffer) >
>> +            data_end)
>>               return ERR_PTR(-EINVAL);
>> -        if (memcmp(name, tag, val) == 0)
>> -            return cc;
>>           next = le32_to_cpu(cc->Next);
>> +        name_off = le16_to_cpu(cc->NameOffset);
>> +        name_len = le16_to_cpu(cc->NameLength);
>> +        value_off = le16_to_cpu(cc->DataOffset);
>> +        value_len = le32_to_cpu(cc->DataLength);
> 
> same here: possible overflow checks needed?
> 
>> +
>> +        if ((next & 0x7) != 0 ||
>> +            name_off != 16 ||
>> +            name_len < 4 ||
>> +            (char *)cc + name_off + name_len > data_end ||
>> +            (value_off & 0x7) != 0 ||
>> +            (value_off && value_off < name_off + name_len) ||
> 
> I guess this must be
> 
>          (value_off && (value_off < name_off + name_len)) ||
> 
>> +            (char *)cc + value_off + value_len > data_end)
>> +            return ERR_PTR(-EINVAL);
>> +
>> +        name = (char *)cc + name_off;
>> +        if (memcmp(name, tag, name_len) == 0)
>> +            return cc;
>>       } while (next != 0);
>>       return NULL;
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index c86164dc70bb..976490bfd93c 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2377,6 +2377,10 @@ static int smb2_create_sd_buffer(struct 
>> ksmbd_work *work,
>>       ksmbd_debug(SMB,
>>               "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
>>       sd_buf = (struct create_sd_buf_req *)context;
>> +    if (le16_to_cpu(context->DataOffset) +
>> +        le32_to_cpu(context->DataLength) <
>> +        sizeof(struct create_sd_buf_req))
>> +        return -EINVAL;
>>       return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
>>                   le32_to_cpu(sd_buf->ccontext.DataLength), true);
>>   }
>> @@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
>>               goto err_out1;
>>           } else if (context) {
>>               ea_buf = (struct create_ea_buf_req *)context;
>> +            if (le16_to_cpu(context->DataOffset) +
>> +                le32_to_cpu(context->DataLength) <
>> +                sizeof(struct create_ea_buf_req)) {
>> +                rc = -EINVAL;
>> +                goto err_out1;
>> +            }
>>               if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE) {
>>                   rsp->hdr.Status = STATUS_ACCESS_DENIED;
>>                   rc = -EACCES;
>> @@ -2615,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
>>               } else if (context) {
>>                   struct create_posix *posix =
>>                       (struct create_posix *)context;
>> +                if (le16_to_cpu(context->DataOffset) +
>> +                    le32_to_cpu(context->DataLength) <
>> +                    sizeof(struct create_posix)) {
>> +                    rc = -EINVAL;
>> +                    goto err_out1;
>> +                }
>>                   ksmbd_debug(SMB, "get posix context\n");
>>                   posix_mode = le32_to_cpu(posix->Mode);
>> @@ -3019,9 +3035,16 @@ int smb2_open(struct ksmbd_work *work)
>>               rc = PTR_ERR(az_req);
>>               goto err_out;
>>           } else if (az_req) {
>> -            loff_t alloc_size = le64_to_cpu(az_req->AllocationSize);
>> +            loff_t alloc_size;
>>               int err;
>> +            if (le16_to_cpu(az_req->ccontext.DataOffset) +
>> +                le32_to_cpu(az_req->ccontext.DataLength) <
>> +                sizeof(struct create_alloc_size_req)) {
>> +                rc = -EINVAL;
>> +                goto err_out;
>> +            }
>> +            alloc_size = le64_to_cpu(az_req->AllocationSize);
>>               ksmbd_debug(SMB,
>>                       "request smb2 create allocate size : %llu\n",
>>                       alloc_size);
>> diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
>> index 0a95cdec8c80..f67567e1e178 100644
>> --- a/fs/ksmbd/smbacl.c
>> +++ b/fs/ksmbd/smbacl.c
>> @@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace 
>> *user_ns,
>>           return;
>>       /* validate that we do not go past end of acl */
>> -    if (end_of_acl <= (char *)pdacl ||
>> +    if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
>>           end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
>>           pr_err("ACL too small to parse DACL\n");
>>           return;
>> @@ -434,6 +434,10 @@ static void parse_dacl(struct user_namespace 
>> *user_ns,
>>           ppace[i] = (struct smb_ace *)(acl_base + acl_size);
>>           acl_base = (char *)ppace[i];
>>           acl_size = le16_to_cpu(ppace[i]->size);
> 
> overflow check needed?
> 
>> +
>> +        if (acl_base + acl_size > end_of_acl)
>> +            break;
>> +
>>           ppace[i]->access_req =
>>               smb_map_generic_desired_access(ppace[i]->access_req);
>> @@ -807,6 +811,9 @@ int parse_sec_desc(struct user_namespace *user_ns, 
>> struct smb_ntsd *pntsd,
>>       if (!pntsd)
>>           return -EIO;
>> +    if (acl_len < sizeof(struct smb_ntsd))
>> +        return -EINVAL;
>> +
>>       owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
>>               le32_to_cpu(pntsd->osidoffset));
>>       group_sid_ptr = (struct smb_sid *)((char *)pntsd +
>>
> 
> Thanks!
> -slow
> 
