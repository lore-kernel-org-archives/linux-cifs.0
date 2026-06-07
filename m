Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D10D264A86
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780849222; cv=none; b=s+uK5k5UA95H3ycS/w79Ix7KSgG4pfo3nbQ92L2WI9hmyfJOg5ojvcG7uit50NFZGmXg6xr5kpljk3JyinOEQGyLmyTRs14kWW3+dqjHQvcMtUS7TqqeB/xcWIj29ybOMwjeJFoFTNz+ub2t7IxXTabYvsP0B8x+MT3xhoRK4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780849222; c=relaxed/simple;
	bh=BN5Oui5Q78Kz9fFBwyv2WgQY4856gNR41UsabjT4vgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYolF8rF8W7kUMHSuzpFovZ03oC4kgyCb8FVpizDg/4O/Kl9Jt8Z7OYrLUXRG0GsEfv47QJ7MTD4X34aqGPIWRjl99zcA9jhaub6JQp0XY732ZHQtV3FQeCeogst2UDYFqdo/9HtfUdVv2LOafY01mKJN97fmxJlbIYt6kHtw+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ijTpFT9G; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ijTpFT9G"
Message-ID: <a398b181-776b-4bf4-a916-1da4f82b0741@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780849219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EirrVa6IluyU9CiX/PwambCWObvrAvsOxInbg7ut9cc=;
	b=ijTpFT9GldhhNleIxCK2YRWHFVp3JOVxJDXlkyXna7/yhT8mCHL1IWDTgSCUSoz3uLOBUD
	AhYhZvR9LGmEiq+ZkQB6d7KhT7Hve+OsG5K1kTTZojXPo5cRF8dCnJz6JOwsKTXO+yBg6A
	itnBaK/RUcQoQHFcGGXHXb7YkHjp6TA=
Date: Mon, 8 Jun 2026 00:20:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] smb/client: refresh allocation size after
 fallocate
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
References: <20260605163519.169916-1-huiwen.he@linux.dev>
 <20260605163519.169916-4-huiwen.he@linux.dev>
 <CAH2r5ms=53YHR41Y9qWozAtSO5UP4yqDN4myp-pju7WpP2WLjg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5ms=53YHR41Y9qWozAtSO5UP4yqDN4myp-pju7WpP2WLjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

Thanks for testing.

This may be related to the fallocate patch now refreshing i_blocks from 
the server-reported AllocationSize. It seems generic/568 may have passed 
before because the client-side i_blocks estimate was too optimistic, 
rather than because the fallocated range was really allocated.

I need to verify this more carefully. I will look into it tomorrow.

Thanks,

Huiwen


在 2026/6/7 23:35, Steve French 写道:
> This regresses xfstests generic/568.
> 
> generic/568  1s ... - output mismatch (see
> /home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad)
>      --- tests/generic/568.out 2025-08-22 09:54:32.333796989 -0500
>      +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad
> 2026-06-07 10:32:28.896135808 -0500
>      @@ -1,4 +1,4 @@
>       QA output created by 568
>       wrote 2/2 bytes at offset block_size - 1
>       XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>      -OK: File did not grow.
>      +ERROR: File grew from 512 B to 1536 B when writing to the fallocated range.
>      ...
>      (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/568.out
> /home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad'  to
> see the entire diff)
> 
> On Fri, Jun 5, 2026 at 11:36 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> SMB3 fallocate extends EOF using FILE_END_OF_FILE_INFORMATION, but the
>> server may also update the file's AllocationSize.  If the client keeps
>> the old cached i_blocks value after fallocate, the swapfile hole check
>> can still see:
>>
>>          i_blocks * 512 < i_size
>>
>> and reject the file as sparse.
>>
>> This shows up in xfstests generic/496 as:
>>
>>          generic/496         [not run] fallocated swap not supported here
>>
>> After a successful EOF-extending fallocate, query FILE_ALL_INFORMATION on
>> the open handle and update i_blocks from the returned AllocationSize. If
>> the query fails, leave the fallocate result unchanged and force a later
>> attribute revalidation by setting cifsi->time to zero.
>>
>> With this client-side refresh, and with a server that really allocates the
>> fallocated range, for example Samba configured with:
>>
>>          [scratch_share]
>>          strict allocate = yes
>>
>> generic/496 can pass the swapfile hole check.
>>
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2ops.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index d4875f9532b4..89230141b5dd 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -3698,8 +3698,23 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>>                  rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>>                                    cfile->fid.volatile_fid, cfile->pid, new_eof);
>>                  if (rc == 0) {
>> +                       struct smb2_file_all_info file_inf;
>> +                       u64 asize;
>> +                       int qrc;
>> +
>>                          netfs_resize_file(&cifsi->netfs, new_eof, true);
>>                          cifs_setsize(inode, new_eof);
>> +
>> +                       qrc = SMB2_query_info(xid, tcon, cfile->fid.persistent_fid,
>> +                                             cfile->fid.volatile_fid, &file_inf);
>> +                       spin_lock(&inode->i_lock);
>> +                       if (qrc == 0) {
>> +                               asize = le64_to_cpu(file_inf.AllocationSize);
>> +                               inode->i_blocks = CIFS_INO_BLOCKS(asize);
>> +                       } else {
>> +                               cifsi->time = 0;
>> +                       }
>> +                       spin_unlock(&inode->i_lock);
>>                  }
>>                  goto out;
>>          }
>> --
>> 2.43.0
>>
> 
> 

