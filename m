Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E686B213E9C
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005647; cv=none; b=UQ8U/eK8TZVjDU2qLGjcmL9tAAiz8MjgVHEDlhzM7YQJgNoy2Rw0y9QRFS9Y0w9sqSpMaYQF1uSBGL8ofpQKImdOsEpXKBaaMJAfgvF1E4v8zSYP1u02k5KnXeE3zdZTyAygIhBJ1+RbS7K7sebje2ED6UshGFHwEq9LkYD9r6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005647; c=relaxed/simple;
	bh=7egwWkm+FwYAAMQ4LDtnQqPzAWZQb/jfxtgyOUtIFRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1pBZtqiR9h6QiLx6muoHtBUZe4iwmP5sV44GYRrFVVeYZtNA63LFNPuBRY9Pmo9c1fHt4PpFwOmyk/WsHKbqJpD10NSGeKzNsQGLKyIyj1d3c+F28DEIe0X3Rq5o4+quNqWAB8t4jf2IvlstQvt6jHJNd4jjCES9CK8dG4cEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bvoCB5c+; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bvoCB5c+"
Message-ID: <da8a7d66-a97c-4d81-8e92-20a810fd2dde@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783005642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3+vEywivr0Kc9e7MwxAOsY1QEBMuWqRP+PodNjweESg=;
	b=bvoCB5c+7jbkhNuH3EtFFU8WYezdwUrjg7lCzNEpH63p+CzSgv59+AI9p5jnci/YszC3pR
	6fDJq/N8X6af9gqVq3EJ37MeC/KYoHYzolgSx1n4qvXO0sFSrylcR/Ajk/dYYmsQGKscd1
	ZAYvy2SaEq2I5JIZ9DtBzVlkJ8mDIoo=
Date: Thu, 2 Jul 2026 23:20:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 1/5] smb/client: refresh allocation size after
 duplicate extents
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn,
 linux-cifs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20260701152157.822207-1-huiwen.he@linux.dev>
 <20260701152157.822207-2-huiwen.he@linux.dev>
 <CAH2r5mudB4xBQnPvuSZo5SiYkRn0UEs9YZi9rbUGBh3G3GBqZg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5mudB4xBQnPvuSZo5SiYkRn0UEs9YZi9rbUGBh3G3GBqZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

Yes, patch 1 adds one extra roundtrip after each successful 
duplicate-extents request.

I think that query is needed if we want i_blocks to be correct 
immediately after the server-side clone. The client only knows the byte 
range that was cloned. It does not know how many blocks the server 
actually allocated for that range, especially when the cloned range 
contains holes.

I agree this may affect workloads that use cp/reflink heavily, but it is
still one metadata query per successful server-side clone, not extra 
work in the SMB2_READ/SMB2_WRITE path. So I think the cost is acceptable 
for the correctness fix.

I found that the v6 version could cause duplicate revalidation after
the AllocationSize refresh. I updated patch 1 in v7 to keep the 
QueryInfo result valid in the inode cache, so a following stat does not 
immediately query the same attributes again.

I also updated patch 3 based on Shashiko's comment. Small fallocate 
ranges at or beyond EOF are now zero-written directly instead of first 
querying
FSCTL_QUERY_ALLOCATED_RANGES.

Thanks,
Huiwen



在 2026/7/2 05:47, Steve French 写道:
> This does lead to an extra roundtrip (common operations like cp will
> use duplicate extents in some Samba and Windows server
> configurations).  Any worries about performance hit?
> 
> On Wed, Jul 1, 2026 at 10:22 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> FSCTL_DUPLICATE_EXTENTS_TO_FILE changes the target file extents on the
>> server, but the client does not refresh the target AllocationSize/i_blocks.
>> Callers can observe or use the wrong st_blocks value immediately after the
>> clone, before a later attribute revalidation corrects it.
>>
>> For example, create a reflinked file with a leading hole:
>>
>>          xfs_io -f -c "pwrite -S 0x61 0 64k" src
>>          touch dst
>>          chmod 600 dst
>>          xfs_io -c "reflink src 0 1m 64k" dst
>>          mkswap dst
>>          swapon dst
>>
>> The file still has a hole after mkswap:
>>
>>          /mnt/scratch/dst:
>>            [0..7]:       allocated
>>            [8..2047]:    hole
>>            [2048..2175]: allocated
>>
>> The server also reports only the allocated ranges:
>>
>>          server dst size=1114112 blocks=144
>>
>> but the client reported EOF-derived blocks:
>>
>>          client dst size=1114112 blocks=2176
>>
>> and swapon succeeded:
>>
>>          swapon_result=success
>>          /mnt/scratch/dst 1.1M 0B -1
>>
>> So EOF-derived i_blocks can let a sparse reflinked file pass the CIFS
>> swapfile hole check.
>>
>> Fix this by querying FILE_ALL_INFORMATION on the target handle after a
>> successful duplicate extents request and updating i_blocks from the
>> returned AllocationSize. If the query fails, invalidate the cached
>> inode attributes so a later getattr can refresh them.
>>
>> This also fixes the xfstests generic/370 regression introduced by the
>> i_blocks accounting change, as tested on a Samba "vfs objects = btrfs"
>> share.
>>
>> Fixes: 99cd0a6eeb6c ("smb/client: do not account EOF extension as allocation")
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2ops.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index 06e9322a762a..cc8e0595e504 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -2193,10 +2193,13 @@ smb2_duplicate_extents(const unsigned int xid,
>>                          u64 len, u64 dest_off)
>>   {
>>          int rc;
>> +       int qrc;
>>          unsigned int ret_data_len;
>>          struct inode *inode;
>> +       struct smb2_file_all_info file_inf;
>>          struct duplicate_extents_to_file dup_ext_buf;
>>          struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
>> +       u64 asize;
>>
>>          /* server fileays advertise duplicate extent support with this flag */
>>          if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
>> @@ -2232,6 +2235,19 @@ smb2_duplicate_extents(const unsigned int xid,
>>          if (ret_data_len > 0)
>>                  cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
>>
>> +       if (rc == 0) {
>> +               qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
>> +                                     trgtfile->fid.volatile_fid, &file_inf);
>> +               spin_lock(&inode->i_lock);
>> +               if (qrc == 0) {
>> +                       asize = le64_to_cpu(file_inf.AllocationSize);
>> +                       inode->i_blocks = CIFS_INO_BLOCKS(asize);
>> +               } else {
>> +                       CIFS_I(inode)->time = 0; /* force reval */
>> +               }
>> +               spin_unlock(&inode->i_lock);
>> +       }
>> +
>>   duplicate_extents_out:
>>          if (rc)
>>                  trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,
>> --
>> 2.43.0
>>
> 
> 

