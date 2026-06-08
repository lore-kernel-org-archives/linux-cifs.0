Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387463FFADD
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932506; cv=none; b=VM7/TyXcSMsM83ZuRbTfq+6l6uFGiKORNrj3WbXkuaarbgUUAahtMGVD1cyzxSjFbW3ayQI0OL0NiY1DGawcj9cEX+g/KRhPj0r27k5+RBHztTRTfAM4HilJv8uW0xYrkz3cmMYF1thDh7jhiU0CSv/a09g23uyawQzVoIA7V1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932506; c=relaxed/simple;
	bh=x79KDk6NSWtB5cfMj16IVzo+hdfESxLSlELF+yENTA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OCUL12BHLgpa3TvGwcKLtd8iF0SQkvEtIUY3N/A0OZwEWbPqzvlC4kSfnW3UW36RUST6FR94DoEQzWb57wCIV7mAP9EjlXT2ZUDMuPcgZtOO1xKAIXxuSMokU0eU8gPOovF8WnohIAhbnmHM96tS6Npq5mfxtnR3y9OPfdTVCCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p5h2YBf9; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p5h2YBf9"
Message-ID: <927ef661-e562-436e-aca2-a772463da73e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780932500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJcB6e7WxQbAU+zNxHC+qVifi9exCu8YTl2zj3w4vvQ=;
	b=p5h2YBf97zWEDwTvc7Vs2SHDrTfaz08BLJLxJPsP1jgoojHis9kUqHS1/BYDqZyx54r2qI
	VlP4x6thdIqsqhRRW84wOKsO+io7Ifyxpt7+9/FX12jwAreEtQYJLivNvi2pxTiSanurM4
	/oPVbPmVzPgvwhK7CVB5J4n2e1ijfXQ=
Date: Mon, 8 Jun 2026 23:28:05 +0800
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

Hi Steve:

Thanks for your feedback.

I've been tied up with other tasks today and haven't had a
chance to dig into the details yet. My current understanding
is that these failures(213/485/568/701) are mostly around
CIFS fallocate semantics.

My swap series changes CIFS i_blocks accounting so that we
no longer treat EOF extension as real allocation. That makes
the swapfile hole check more accurate, but it can also expose
existing fallocate behavior where the server reports success
without actually allocating the requested range.

generic/568 expects a later write into a fallocated range not to 
increase st_blocks, and generic/701 also depends on fallocate/truncate 
reporting allocation correctly.

I also checked generic/213.  It passes in my setup.  With Samba
"strict allocate = yes", the server attempts to reserve space during
fallocate, so an allocation larger than the available space fails with
ENOSPC, which is what the test expects.

For generic/568, I did a temporary local experiment where CIFS requests 
an AllocationSize update after EOF-extending fallocate and then 
refreshes the cached allocation size. With that, generic/568 can pass 
locally.

So I need more time to understand and verify how CIFS should preserve 
the semantics of all fallocate modes before sending an updated patch.

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

