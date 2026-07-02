Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7815E2E1F06
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 03:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782962526; cv=none; b=EUoViBRfylgp5DURNV4t/LZ15VCr+wZaI2QzKXQPPIl22JwYyJWAQeWKNQrRXf2L2tTitR6UtvkWpmc/DGnVKYCQ/iAg+2dC+eve4V8cFBFOIhVS8YHQmZThESHH0Btb54OWxTc4Nv6wJsVX+9wPIEwqfrzvRLWCNRoeP4z5ao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782962526; c=relaxed/simple;
	bh=Px5GQimk+cqu98hjN5cEtjKDc3HugAoqHtQSFFnKifE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4yb6okucdS0u0XlRfuCCxONSNKbI5WVrvaBctB+6bvsWtQ5gVZ6IELu7z3+L0c7DhyPSMN8Weg7moJIyMjmi3G1TJ83n5KIlUUUFt9q3fU98s4YV+vwqw/MqwdG7YQS84vZnkSKrduLQZR4TuDR26klpmYA7cA4KTY/bznK+Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N/6Xtq6E; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N/6Xtq6E"
Message-ID: <88dd7e42-10c0-4f87-a310-0b85fc90a431@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782962522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSbIRoUoOv1lMmvLMneyRylUzezyok1YYUBHzFRkNgc=;
	b=N/6Xtq6E+YIDCRVPWeHyvluPPfoC51oLu7YfwzILFPtxCv8WoqTeHNtvonMOIaCXJO0wqC
	WEEhf4jg5Q5C2PwgpGaSTddXTq4syKejIdF4Te2vxU0pyzrZVKCIPLR2bd1nWRdkzFzEov
	LTI6v1bvDpjYeJn/rLuQVcXQ7kii0lE=
Date: Thu, 2 Jul 2026 11:21:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/5] smb/client: refresh allocation after EOF-extending
 fallocate
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn,
 linux-cifs@vger.kernel.org
References: <20260701152157.822207-1-huiwen.he@linux.dev>
 <20260701152157.822207-5-huiwen.he@linux.dev>
 <CAH2r5mvX5qdWyEszD2reWMHOaUYrqtMmk0RK9xgkrx+Wc-RdWA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5mvX5qdWyEszD2reWMHOaUYrqtMmk0RK9xgkrx+Wc-RdWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

I am not sure yet why generic/103 returns ENOSPC with Samba
"strict allocate = no". In my testing, generic/103 passes with
"strict allocate = no" and fails with "strict allocate = yes".

For generic/539, the test checks SEEK_DATA/SEEK_HOLE after
punching a hole. The expected layout is:

         [0, alloc_size)                  data
         [alloc_size, 2 * alloc_size)     hole
         [2 * alloc_size, 3 * alloc_size) data

So SEEK_DATA from alloc_size should return 2 * alloc_size.

The change from "seek sanity check failed" to NOTRUN may be
caused by the state left after the generic/103 ENOSPC failure.
If a previous test leaves the backend filesystem near full,
the _require_seek_data_hole probe can fail early and xfstests
reports:

         [not run] File system does not support llseek(2) SEEK_DATA/HOLE

In my testing, when I run generic/539 separately, it does not NOTRUN. It
reaches the real test and fails the punched-hole SEEK_DATA check instead.

xfstests generic/539 is a separate issue. This series does not change 
the punch-hole path, but I can reproduce the failure and will check 
whether we can fix it separately.

Thanks,
Huiwen


在 2026/7/2 05:19, Steve French 写道:
> With this patch I do see a difference in generic/103 which with the
> patch returns
> 
> generic/103  0s ... - output mismatch (see
> /home/smfrench/xfstests-dev/results//sambamfs/generic/103.out.bad)
>      --- tests/generic/103.out 2025-08-22 09:54:32.266754366 -0500
>      +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/103.out.bad
> 2026-07-01 16:13:02.220130644 -0500
>      @@ -1,2 +1,3 @@
>       QA output created by 103
>      +fallocate: No space left on device
>       Silence is golden.
> 
> but without that patch works.  Also is puzzling why the error changes
> for generic/539 with the four fallocate patches from:
> 
> generic/539  0s ... [failed, exit status 1]- output mismatch (see
> /home/smfrench/xfstests-dev/results//sambamfs/generic/539.out.bad)
>      --- tests/generic/539.out 2025-08-22 09:54:32.329794445 -0500
>      +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/539.out.bad
> 2026-06-30 20:27:26.739245628 -0500
>      @@ -1,2 +1,4 @@
>       QA output created by 539
>       Silence is golden
>      +seek sanity check failed!
>      +(see /home/smfrench/xfstests-dev/results//sambamfs/generic/539.full
> for details)
>      ...
> 
> to
>     generic/539  0s ... [not run] File system does not support
> llseek(2) SEEK_DATA/HOLE
> 
> Samba supports SEEK_DATA/SEEK_HOLE right?
> 
> On Wed, Jul 1, 2026 at 10:22 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> Before this change, xfstests generic/496 was not supported on ksmbd:
>>
>>          generic/496 ... [not run] fallocated swap not supported here
>>
>> ksmbd handles SetEOF as truncate, so EOF extension alone does not
>> allocate backing blocks. A fallocated swapfile can therefore still
>> look sparse to swapon.
>>
>> Request allocation for EOF-extending fallocate ranges that can be
>> represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
>> state afterwards.
>>
>> With this change, xfstests generic/496 and generic/701 pass on ksmbd.
>>
>> However, Samba "strict allocate = no" now exposes the real generic/701
>> failure: the old pass came from inflated local i_blocks, not from
>> server allocation. generic/213 also fails in that case because an
>> oversized allocation request may not return ENOSPC.
>>
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2ops.c   | 43 ++++++++++++++++++++++++++++++++++++---
>>   fs/smb/client/smb2pdu.c   | 19 +++++++++++++++++
>>   fs/smb/client/smb2proto.h |  3 +++
>>   fs/smb/common/fscc.h      |  5 +++++
>>   fs/smb/server/smb2pdu.h   |  4 ----
>>   5 files changed, 67 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index c75f55935b9b..698fce6feea3 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -3756,12 +3756,49 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>>                          smb2_set_sparse(xid, tcon, cfile, inode, false);
>>
>>                  new_eof = off + len;
>> +
>> +               qrc = SMB2_query_info(xid, tcon,
>> +                                     cfile->fid.persistent_fid,
>> +                                     cfile->fid.volatile_fid, &file_inf);
>> +               if (qrc == 0)
>> +                       asize = le64_to_cpu(file_inf.AllocationSize);
>> +
>> +               /*
>> +                * FILE_ALLOCATION_INFORMATION can only describe allocation up to
>> +                * new_eof. Some servers may accept it without allocating blocks,
>> +                * so refresh AllocationSize before updating i_blocks.
>> +                */
>> +               if (off == 0 || off == old_eof) {
>> +                       if (qrc || asize < new_eof) {
>> +                               rc = SMB2_set_allocation(xid, tcon,
>> +                                                        cfile->fid.persistent_fid,
>> +                                                        cfile->fid.volatile_fid,
>> +                                                        cfile->pid, new_eof);
>> +                               if (rc)
>> +                                       goto out;
>> +                       }
>> +               }
>> +
>>                  rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>>                                    cfile->fid.volatile_fid, cfile->pid, new_eof);
>> -               if (rc == 0) {
>> -                       netfs_resize_file(&cifsi->netfs, new_eof, true);
>> -                       cifs_setsize(inode, new_eof);
>> +               if (rc)
>> +                       goto out;
>> +
>> +               netfs_resize_file(&cifsi->netfs, new_eof, true);
>> +               cifs_setsize(inode, new_eof);
>> +
>> +               qrc = SMB2_query_info(xid, tcon,
>> +                                     cfile->fid.persistent_fid,
>> +                                     cfile->fid.volatile_fid, &file_inf);
>> +               spin_lock(&inode->i_lock);
>> +               if (qrc == 0) {
>> +                       asize = le64_to_cpu(file_inf.AllocationSize);
>> +                       if (asize >= new_eof)
>> +                               inode->i_blocks = CIFS_INO_BLOCKS(asize);
>> +               } else {
>> +                       cifsi->time = 0;
>>                  }
>> +               spin_unlock(&inode->i_lock);
>>                  goto out;
>>          }
>>
>> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> index d058584b8f05..1374bbae627f 100644
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -5947,6 +5947,25 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>                          0, 1, &data, &size);
>>   }
>>
>> +int
>> +SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
>> +                   u64 persistent_fid, u64 volatile_fid, u32 pid,
>> +                   loff_t allocation_size)
>> +{
>> +       struct smb2_file_alloc_info info;
>> +       void *data;
>> +       unsigned int size;
>> +
>> +       info.AllocationSize = cpu_to_le64(allocation_size);
>> +
>> +       data = &info;
>> +       size = sizeof(struct smb2_file_alloc_info);
>> +
>> +       return send_set_info(xid, tcon, persistent_fid, volatile_fid,
>> +                       pid, FILE_ALLOCATION_INFORMATION, SMB2_O_INFO_FILE,
>> +                       0, 1, &data, &size);
>> +}
>> +
>>   int
>>   SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>>                  u64 persistent_fid, u64 volatile_fid,
>> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
>> index 78a4e1c340f9..16a02c1eb0a1 100644
>> --- a/fs/smb/client/smb2proto.h
>> +++ b/fs/smb/client/smb2proto.h
>> @@ -204,6 +204,9 @@ void SMB2_query_directory_free(struct smb_rqst *rqst);
>>   int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
>>                   u64 persistent_fid, u64 volatile_fid, u32 pid,
>>                   loff_t new_eof);
>> +int SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
>> +                       u64 persistent_fid, u64 volatile_fid, u32 pid,
>> +                       loff_t allocation_size);
>>   int SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>>                         struct smb_rqst *rqst, u64 persistent_fid,
>>                         u64 volatile_fid, u32 pid, u8 info_class, u8 info_type,
>> diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
>> index 859849a42fec..941db5a95564 100644
>> --- a/fs/smb/common/fscc.h
>> +++ b/fs/smb/common/fscc.h
>> @@ -283,6 +283,11 @@ struct smb2_file_eof_info { /* encoding of request for level 10 */
>>          __le64 EndOfFile; /* new end of file value */
>>   } __packed; /* level 20 Set */
>>
>> +/* See MS-FSCC 2.4.4 */
>> +struct smb2_file_alloc_info { /* encoding of request for level 19 */
>> +       __le64 AllocationSize;
>> +} __packed;
>> +
>>   /* See MS-FSCC 2.4.15 */
>>   typedef struct {
>>          __le32 NextEntryOffset;
>> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
>> index c2512dbcdec8..aa06c8c905f1 100644
>> --- a/fs/smb/server/smb2pdu.h
>> +++ b/fs/smb/server/smb2pdu.h
>> @@ -212,10 +212,6 @@ struct smb2_file_ea_info {
>>          __le32 EASize;
>>   } __packed;
>>
>> -struct smb2_file_alloc_info {
>> -       __le64 AllocationSize;
>> -} __packed;
>> -
>>   struct smb2_file_disposition_info {
>>          __u8 DeletePending;
>>   } __packed;
>> --
>> 2.43.0
>>
> 
> 

