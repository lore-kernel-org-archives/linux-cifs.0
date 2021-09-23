Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB26C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3532861107
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhIWPDm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 11:03:42 -0400
Received: from p3plsmtpa06-01.prod.phx3.secureserver.net ([173.201.192.102]:37833
        "EHLO p3plsmtpa06-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241798AbhIWPDm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 11:03:42 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id TQEjm4xSn4WSLTQEjm4eXA; Thu, 23 Sep 2021 08:02:10 -0700
X-CMAE-Analysis: v=2.4 cv=U75Xscnu c=1 sm=1 tr=0 ts=614c96f2
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=1zX3VhXPAAAA:20 a=VwQbUJbxAAAA:8
 a=hGzw-44bAAAA:8 a=snJOV3bznqlS8ygfWOQA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=HvKuF1_PTVFglORKqfwH:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3] ksmbd: add validation in smb2_ioctl
To:     Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210922022811.654412-1-linkinjeon@kernel.org>
 <CAN05THQGvRqAsej02b6uje8duTAoOv_tdnT9dLHyWg1pDrsXJA@mail.gmail.com>
 <CAN05THQxkVzGXZXunqdb-ZpQe+KA0YXjL7tTMKOeEhd_Cv8=Lg@mail.gmail.com>
 <CAKYAXd-q+6WDZF=stGd+TzmbumTbS7djONqjPUU79EBLUHhzjw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <c2e0be72-87b9-3b8d-4f96-cae908acb71a@talpey.com>
Date:   Thu, 23 Sep 2021 11:02:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-q+6WDZF=stGd+TzmbumTbS7djONqjPUU79EBLUHhzjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfA91J2AZ5qa2uc2VypNmSM3/ebyfYgGMnT8noTZsDN0uFtFisvYHdTtsPDipX9MUJXaCeHU2WpkHFp+mpdvfNYrhCi3CYC5E1B54ZNKtrNOcQdnSJFaK
 subagDvng+VM3eRUzhKzznBPKahB5hVABUQHDXJ2l8vFbno60TNNi+LVmTDoi9+f1F5JIbCe6V0VRxpnKvkd63KPlJFxVwq9ILEVppkIMyqCdWI4lWLbpp8X
 xuiLxBV1qJfbt6Fx8pik31ErmOLQOu+GeE83PFkWZGU8MRdGAEICzTDDA56cUQgpxtnXihLCbQGnP36tTLGidg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/22/2021 12:13 AM, Namjae Jeon wrote:
> 2021-09-22 13:08 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
>> Ignore.  Looking at the wrong code.
> To avoid confusion,  I have pushed all in-flight patches to my github
> to review correctly.
> Please check this branch.
> https://github.com/namjaejeon/smb3-kernel/tree/ksmbd-for-next

I don't understand where to look for patches. You continue to send
the git diffs to email, and that's the generally preferred method
for review.

I have comments on the code below. Do I have to go review on github?

Tom.


> 
> Thanks!
> 
>>
>> On Wed, Sep 22, 2021 at 1:48 PM ronnie sahlberg
>> <ronniesahlberg@gmail.com> wrote:
>>>
>>> I hope I look at the right patches/branches, appologies if not.
>>>
>>> Do you have a branch where you have all these patches applied?
>>>
>>> On Wed, Sep 22, 2021 at 12:28 PM Namjae Jeon <linkinjeon@kernel.org>
>>> wrote:
>>>>
>>>> Add validation for request/response buffer size check in smb2_ioctl and
>>>> fsctl_copychunk() take copychunk_ioctl_req pointer and the other
>>>> arguments
>>>> instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
>>>> argument of fsctl_validate_negotiate_info.
>>>>
>>>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>>> Cc: Ralph Böhme <slow@samba.org>
>>>> Cc: Steve French <smfrench@gmail.com>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>   v2:
>>>>     - fix warning: variable 'ret' is used uninitialized ret.
>>>>   v3:
>>>>     - fsctl_copychunk() take copychunk_ioctl_req pointer and the other
>>>> arguments
>>>>       instead of smb2_ioctl_req structure.
>>>>     - remove an unused smb2_ioctl_req argument of
>>>> fsctl_validate_negotiate_info.
>>>>   fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
>>>>   1 file changed, 68 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>>> index aaf50f677194..e96491c9ab92 100644
>>>> --- a/fs/ksmbd/smb2pdu.c
>>>> +++ b/fs/ksmbd/smb2pdu.c
>>>> @@ -6986,24 +6986,26 @@ int smb2_lock(struct ksmbd_work *work)
>>>>          return err;
>>>>   }
>>>>
>>>> -static int fsctl_copychunk(struct ksmbd_work *work, struct
>>>> smb2_ioctl_req *req,
>>>> +static int fsctl_copychunk(struct ksmbd_work *work,
>>>> +                          struct copychunk_ioctl_req *ci_req,
>>>> +                          unsigned int cnt_code,
>>>> +                          unsigned int input_count,
>>>> +                          unsigned long long volatile_id,
>>>> +                          unsigned long long persistent_id,
>>>>                             struct smb2_ioctl_rsp *rsp)
>>>>   {
>>>> -       struct copychunk_ioctl_req *ci_req;
>>>>          struct copychunk_ioctl_rsp *ci_rsp;
>>>>          struct ksmbd_file *src_fp = NULL, *dst_fp = NULL;
>>>>          struct srv_copychunk *chunks;
>>>>          unsigned int i, chunk_count, chunk_count_written = 0;
>>>>          unsigned int chunk_size_written = 0;
>>>>          loff_t total_size_written = 0;
>>>> -       int ret, cnt_code;
>>>> +       int ret = 0;
>>>>
>>>> -       cnt_code = le32_to_cpu(req->CntCode);
>>>> -       ci_req = (struct copychunk_ioctl_req *)&req->Buffer[0];
>>>>          ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>>>>
>>>> -       rsp->VolatileFileId = req->VolatileFileId;
>>>> -       rsp->PersistentFileId = req->PersistentFileId;
>>>> +       rsp->VolatileFileId = cpu_to_le64(volatile_id);
>>>> +       rsp->PersistentFileId = cpu_to_le64(persistent_id);
>>>>          ci_rsp->ChunksWritten =
>>>>                  cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>>>>          ci_rsp->ChunkBytesWritten =
>>>> @@ -7013,12 +7015,13 @@ static int fsctl_copychunk(struct ksmbd_work
>>>> *work, struct smb2_ioctl_req *req,
>>>>
>>>>          chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>>>>          chunk_count = le32_to_cpu(ci_req->ChunkCount);
>>>> +       if (chunk_count == 0)
>>>> +               goto out;
>>>>          total_size_written = 0;
>>>>
>>>>          /* verify the SRV_COPYCHUNK_COPY packet */
>>>>          if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
>>>> -           le32_to_cpu(req->InputCount) <
>>>> -            offsetof(struct copychunk_ioctl_req, Chunks) +
>>>> +           input_count < offsetof(struct copychunk_ioctl_req, Chunks)
>>>> +
>>>>               chunk_count * sizeof(struct srv_copychunk)) {
>>>>                  rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>>>>                  return -EINVAL;
>>>> @@ -7039,9 +7042,7 @@ static int fsctl_copychunk(struct ksmbd_work
>>>> *work, struct smb2_ioctl_req *req,
>>>>
>>>>          src_fp = ksmbd_lookup_foreign_fd(work,
>>>>
>>>> le64_to_cpu(ci_req->ResumeKey[0]));
>>>> -       dst_fp = ksmbd_lookup_fd_slow(work,
>>>> -                                     le64_to_cpu(req->VolatileFileId),
>>>> -
>>>> le64_to_cpu(req->PersistentFileId));
>>>> +       dst_fp = ksmbd_lookup_fd_slow(work, volatile_id,
>>>> persistent_id);
>>>>          ret = -EINVAL;
>>>>          if (!src_fp ||
>>>>              src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1]))
>>>> {
>>>> @@ -7116,8 +7117,8 @@ static __be32 idev_ipv4_address(struct in_device
>>>> *idev)
>>>>   }
>>>>
>>>>   static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>>>> -                                       struct smb2_ioctl_req *req,
>>>> -                                       struct smb2_ioctl_rsp *rsp)
>>>> +                                       struct smb2_ioctl_rsp *rsp,
>>>> +                                       int out_buf_len)
>>>>   {
>>>>          struct network_interface_info_ioctl_rsp *nii_rsp = NULL;
>>>>          int nbytes = 0;
>>>> @@ -7200,6 +7201,8 @@ static int fsctl_query_iface_info_ioctl(struct
>>>> ksmbd_conn *conn,
>>>>                          sockaddr_storage->addr6.ScopeId = 0;
>>>>                  }
>>>>
>>>> +               if (out_buf_len < sizeof(struct
>>>> network_interface_info_ioctl_rsp))
>>>> +                       break;
>>>>                  nbytes += sizeof(struct
>>>> network_interface_info_ioctl_rsp);
>>>>          }
>>>>          rtnl_unlock();
>>>> @@ -7220,11 +7223,16 @@ static int fsctl_query_iface_info_ioctl(struct
>>>> ksmbd_conn *conn,
>>>>
>>>>   static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>>>>                                           struct
>>>> validate_negotiate_info_req *neg_req,
>>>> -                                        struct
>>>> validate_negotiate_info_rsp *neg_rsp)
>>>> +                                        struct
>>>> validate_negotiate_info_rsp *neg_rsp,
>>>> +                                        int in_buf_len)
>>>>   {
>>>>          int ret = 0;
>>>>          int dialect;
>>>>
>>>> +       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
>>>> +                       le16_to_cpu(neg_req->DialectCount) *
>>>> sizeof(__le16))
>>>> +               return -EINVAL;
>>>> +
>>>>          dialect = ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>>>>                                               neg_req->DialectCount);
>>>>          if (dialect == BAD_PROT_ID || dialect != conn->dialect) {
>>>> @@ -7400,7 +7408,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>          struct smb2_ioctl_req *req;
>>>>          struct smb2_ioctl_rsp *rsp, *rsp_org;
>>>>          int cnt_code, nbytes = 0;
>>>> -       int out_buf_len;
>>>> +       int out_buf_len, in_buf_len;
>>>>          u64 id = KSMBD_NO_FID;
>>>>          struct ksmbd_conn *conn = work->conn;
>>>>          int ret = 0;
>>>> @@ -7430,6 +7438,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>          cnt_code = le32_to_cpu(req->CntCode);
>>>>          out_buf_len = le32_to_cpu(req->MaxOutputResponse);
>>>>          out_buf_len = min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
>>>> +       in_buf_len = le32_to_cpu(req->InputCount);
>>>
>>> Do you check if you have these many bytes remaining in the buffer?
>>>
>>> Also earlier in this function, where you assign req.
>>> If this is not a component in a compound, then you assign req =
>>> work->request_buf
>>> which starts with 4 bytes for the length and the smb2_hdr starts at
>>> offset 4, right?
>>>
>>> But if the ioctl is inside a compound, you assign req =
>>> ksmbd_req_buf_next()
>>> which just returns the offset to wherever NextCommand is?
>>> There are two problems here.
>>> Now req points to something where teh smb2 header starts at offset 0
>>> instead of 4.
>>> I unfortunately do not have any code to create Create/Ioctl/Close
>>> compounds to test this,
>>> but it looks like this is a problem.
>>>
>>> The second is that there is no check I can see that we validate that
>>> req now points to valid data,
>>> which means that when we dereference req just a few lines later
>>> (req->VolatileFileId)
>>> we might read random data beyond the end of request_buf   or we might
>>> oops.
>>>
>>>
>>> The same might be an issue in other functions as well.
>>>
>>>
>>>>
>>>>          switch (cnt_code) {
>>>>          case FSCTL_DFS_GET_REFERRALS:
>>>> @@ -7465,9 +7474,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                          goto out;
>>>>                  }
>>>>
>>>> +               if (in_buf_len < sizeof(struct
>>>> validate_negotiate_info_req))
>>>> +                       return -EINVAL;
>>>> +
>>>> +               if (out_buf_len < sizeof(struct
>>>> validate_negotiate_info_rsp))
>>>> +                       return -EINVAL;
>>>> +
>>>>                  ret = fsctl_validate_negotiate_info(conn,
>>>>                          (struct validate_negotiate_info_req
>>>> *)&req->Buffer[0],
>>>> -                       (struct validate_negotiate_info_rsp
>>>> *)&rsp->Buffer[0]);
>>>> +                       (struct validate_negotiate_info_rsp
>>>> *)&rsp->Buffer[0],
>>>> +                       in_buf_len);
>>>>                  if (ret < 0)
>>>>                          goto out;
>>>>
>>>> @@ -7476,7 +7492,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                  rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
>>>>                  break;
>>>>          case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>>>> -               nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp);
>>>> +               nbytes = fsctl_query_iface_info_ioctl(conn, rsp,
>>>> out_buf_len);
>>>>                  if (nbytes < 0)
>>>>                          goto out;
>>>>                  break;
>>>> @@ -7503,15 +7519,33 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                          goto out;
>>>>                  }
>>>>
>>>> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
>>>> +                       ret = -EINVAL;
>>>> +                       goto out;
>>>> +               }
>>>> +
>>>>                  if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
>>>>                          ret = -EINVAL;
>>>>                          goto out;
>>>>                  }
>>>>
>>>>                  nbytes = sizeof(struct copychunk_ioctl_rsp);
>>>> -               fsctl_copychunk(work, req, rsp);
>>>> +               rsp->VolatileFileId = req->VolatileFileId;
>>>> +               rsp->PersistentFileId = req->PersistentFileId;
>>>> +               fsctl_copychunk(work,
>>>> +                               (struct copychunk_ioctl_req
>>>> *)&req->Buffer[0],
>>>> +                               le32_to_cpu(req->CntCode),
>>>> +                               le32_to_cpu(req->InputCount),
>>>> +                               le64_to_cpu(req->VolatileFileId),
>>>> +                               le64_to_cpu(req->PersistentFileId),
>>>> +                               rsp);
>>>>                  break;
>>>>          case FSCTL_SET_SPARSE:
>>>> +               if (in_buf_len < sizeof(struct file_sparse)) {
>>>> +                       ret = -EINVAL;
>>>> +                       goto out;
>>>> +               }
>>>> +
>>>>                  ret = fsctl_set_sparse(work, id,
>>>>                                         (struct file_sparse
>>>> *)&req->Buffer[0]);
>>>>                  if (ret < 0)
>>>> @@ -7530,6 +7564,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                          goto out;
>>>>                  }
>>>>
>>>> +               if (in_buf_len < sizeof(struct
>>>> file_zero_data_information)) {
>>>> +                       ret = -EINVAL;
>>>> +                       goto out;
>>>> +               }
>>>> +
>>>>                  zero_data =
>>>>                          (struct file_zero_data_information
>>>> *)&req->Buffer[0];
>>>>
>>>> @@ -7549,6 +7588,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                  break;
>>>>          }
>>>>          case FSCTL_QUERY_ALLOCATED_RANGES:
>>>> +               if (in_buf_len < sizeof(struct
>>>> file_allocated_range_buffer)) {
>>>> +                       ret = -EINVAL;
>>>> +                       goto out;
>>>> +               }
>>>> +
>>>>                  ret = fsctl_query_allocated_ranges(work, id,
>>>>                          (struct file_allocated_range_buffer
>>>> *)&req->Buffer[0],
>>>>                          (struct file_allocated_range_buffer
>>>> *)&rsp->Buffer[0],
>>>> @@ -7589,6 +7633,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                  struct duplicate_extents_to_file *dup_ext;
>>>>                  loff_t src_off, dst_off, length, cloned;
>>>>
>>>> +               if (in_buf_len < sizeof(struct
>>>> duplicate_extents_to_file)) {
>>>> +                       ret = -EINVAL;
>>>> +                       goto out;
>>>> +               }
>>>> +
>>>>                  dup_ext = (struct duplicate_extents_to_file
>>>> *)&req->Buffer[0];
>>>>
>>>>                  fp_in = ksmbd_lookup_fd_slow(work,
>>>> dup_ext->VolatileFileHandle,
>>>> --
>>>> 2.25.1
>>>>
>>
> 
