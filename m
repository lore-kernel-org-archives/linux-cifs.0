Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90947E0E8;
	Mon, 25 May 2026 02:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779675420; cv=none; b=iA/vwK523bHPguVwFRMvqRzxDoZ5WQJmTCpO8F6HIZGwgE/BpmSP/b1hhCtNd6O9q6qBMPmNlp4wEsq/IfcG0KglFtlHq12Yh9NIbfbRPwybfqXAXLPRW3Gt7ForoNBgCHLkYaDCiw/8MkVYTv/3qR1qqxAL1DJQ8F1LxA8qNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779675420; c=relaxed/simple;
	bh=0MlUwNTZrSIk/2hjkGI0lBdXkuZUeaxuuO8v428bgSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r7mTlxjHCAaeYStg7En+b3lpw+6F3CXkyz/Ejbuvr+mXEgdrYHMWslavnGjlzAYlAMdWolU3e1exzu2Kqod8KuGvYI8zq49b6yvy2O/mJjLRMyNsvCGuX7gbbtxShDIou+KWhVA7z64xTt4kIpyJN8BCI65Odc07GsCI5XdgDE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gNzyB4ndLzYQtw5;
	Mon, 25 May 2026 10:16:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D1AC340576;
	Mon, 25 May 2026 10:16:54 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with SMTP id gCh0CgAX31oUsRNqqrklDg--.60230S3;
	Mon, 25 May 2026 10:16:54 +0800 (CST)
Message-ID: <dd1ee60d-f8b9-4019-991f-0fadf776694b@huaweicloud.com>
Date: Mon, 25 May 2026 10:16:51 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Steve French <smfrench@gmail.com>, Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com,
 dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>,
 stable@vger.kernel.org, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 yangerkun <yangerkun@huawei.com>, Zizhi Wo <wozizhi@huaweicloud.com>
References: <20260304124629.1616108-1-sprasad@microsoft.com>
 <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
 <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>
 <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz>
 <CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com>
 <CAH2r5mu-3cDEhQWnBwBATq4hv4tw9aoPtGdmaDuc1+PxeiTuxA@mail.gmail.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <CAH2r5mu-3cDEhQWnBwBATq4hv4tw9aoPtGdmaDuc1+PxeiTuxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAX31oUsRNqqrklDg--.60230S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy5CF1UuF1fKw15uw13CFg_yoW3Jr18pF
	WakasrKr4kGryfG3Z293W0qF10yw4xAa45Xr1Ygry7Arn0gryIqFs3JrWUKFyUZrs3Ww1j
	vF48Wry7ZFWDZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

Hi!

在 2026/3/15 6:03, Steve French 写道:
> On Sat, Mar 14, 2026 at 3:38 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>
>> On Sat, Mar 14, 2026 at 1:47 AM Henrique Carvalho
>> <henrique.carvalho@suse.com> wrote:
>>>
>>> On Fri, Mar 13, 2026 at 10:57:42AM +0530, Shyam Prasad N wrote:
>>>> On Fri, Mar 13, 2026 at 1:28 AM Henrique Carvalho
>>>> <henrique.carvalho@suse.com> wrote:
>>>>>
>>>>> On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wrote:
>>>>>> From: Shyam Prasad N <sprasad@microsoft.com>
>>>>>>
>>>>>> Today whenever we deal with a file, in addition to holding
>>>>>> a reference on the dentry, we also get a reference on the
>>>>>> superblock. This happens in two cases:
>>>>>> 1. when a new cinode is allocated
>>>>>> 2. when an oplock break is being processed
>>>>>>
>>>>>> The reasoning for holding the superblock ref was to make sure
>>>>>> that when umount happens, if there are users of inodes and
>>>>>> dentries, it does not try to clean them up and wait for the
>>>>>> last ref to superblock to be dropped by last of such users.
>>>>>>
>>>>>> But the side effect of doing that is that umount silently drops
>>>>>> a ref on the superblock and we could have deferred closes and
>>>>>> lease breaks still holding these refs.
>>>>>>
>>>>>> Ideally, we should ensure that all of these users of inodes and
>>>>>> dentries are cleaned up at the time of umount, which is what this
>>>>>> code is doing.
>>>>>>
>>>>>> This code change allows these code paths to use a ref on the
>>>>>> dentry (and hence the inode). That way, umount is
>>>>>> ensured to clean up SMB client resources when it's the last
>>>>>> ref on the superblock (For ex: when same objects are shared).
>>>>>>
>>>>>> The code change also moves the call to close all the files in
>>>>>> deferred close list to the umount code path. It also waits for
>>>>>> oplock_break workers to be flushed before calling
>>>>>> kill_anon_super (which eventually frees up those objects).
>>>>>>
>>>>>> Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cifsFileInfo objects are gone")
>>>>>> Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_break")
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>>>>>> ---
>>>>>
>>>>> Hi Shyam,
>>>>>
>>>>> So the side effect of the previous code is that the umount hangs until
>>>>> all the files are closed?
>>>>
>>>> Hi Henrique
>>>> Umount works. All it does is decrement refcount on sb.
>>>> When the last file is closed (or when the last cifs_oplock_break
>>>> processing completes) that's when cifs_kill_sb would get called.
>>>> Before that if there's another mount of the same share, it will reuse
>>>> the same session, tcon and open handles. As a result, an attempt to
>>>> delete files on the mount point may fail (which is one of first things
>>>> done by many xfstests).
>>>>
>>>
>>> Thank you for the explanation.
>>>
>>> I will wait for your v2.
>>
>> Hi Steve,
>>
>> I ran generic/694 to understand why it is failing with this change.
>> I think that this fix has just exposed a problem rather than caused it.
>>
>> The test does the following:
>> 1. either fallocates a file to 4G or pwrites to it
>> 2. calls sync
>> 3. runs stat to get number of blocks allocated for the file
>> 4. umounts the share
>> 5. mounts the share again
>> 6. runs stat to get number of blocks allocated for the file
>> 7. compares output of steps 3 and 6
> 
> Any chance of creating a small repro script for this that is easier to
> debug han the xfstest was?

I analyzed this issue and performed a simple local reproduction using
smb3/smb21:

mount /dev/sda /mnt
mount -t cifs //127.0.0.1/share /mnt/test_mnt -o vers=3.0,guest
# smb versions below 3 do not support fallocate;
# generic/694 replaces it with pwrite.
# xfs_io -ft -c "pwrite 0 4G" /mnt/test_mnt/aaa
xfs_io -ft -c "falloc 0 4M" /mnt/test_mnt/aaa
stat -c "%b" /mnt/test_mnt/aaa
umount /mnt/test_mnt
mount -t cifs //127.0.0.1/share /mnt/test_mnt -o vers=3.0,guest
stat -c "%b" /mnt/test_mnt/aaa

> 
>> Without this change, both step 3 and 6 would return 0, since even
>> through umount/mount, the same file would remain open (since
>> superblocks will be shared).
>> With this change, step 3 would return 0. Step 6 would return the right value.
>>
>> If you use nosharesock even after reverting this change, you'll see
>> the test failing.
>> Or even with this change if actimeo=0, then this test passes.
>>
>> The real question to ask is why aren't we updating i_blocks even after
>> sync succeeds?
>> My guess is that this has something to do with attribute caching when
>> the handle is kept open.
> 
> That sounds an important bug to fix.  Glad this test showed it.
> 
> 
> 

xfs_io -ft -c "falloc 0 4M" /mnt/test_mnt/aaa opens the file for
writing, which causes stat -> ... -> update_inode_info to skip updating
inode->i_blocks, because is_size_safe_to_change() returns false.

The file is only removed from the list in _cifsFileInfo_put(), but that
call is deferred, so the value obtained in step 3 doesn't match the
expected value. Step 6, however, does match — because after the remount
the file has not been opened for writing.

Before the patch was merged, both runs returned 0, because the second
mount reused the sb instance and the inode instance from the first
mount, and the interval between the two mounts was too short, causing
cifs_dentry_needs_reval() to return false.

SMB 2.1 behaves similarly: pwrite writes 4 GB and the size shows as
8388608. If the server-side backing filesystem is ext4, it also
initially shows 8388608(see ext4_file_getattr()), and only during the
writeback path — when it's discovered that the extent count is too
large and an additional ETB(extent tree block) is required — does it
become 8388616(ext4_do_writepages -> ... -> ext4_ext_new_meta_block).

On the client side, cifs_write_end() updates inode->i_blocks but doesn't
account for that metadata block. Although generic/694 issues a sync
before stat, and the server flushes to disk upon receiving it, so by
rights it should return 8388616 — it doesn't. This is because
cifs_revalidate_dentry_attr() -> cifs_dentry_needs_reval() returns false
directly, since CIFS_CACHE_READ evaluates to true; as a result, it
doesn't even go to the server to fetch stat.

The oplock is only cleared to 0 in _cifsFileInfo_put(), and that itself
is a deferred release, so the stat call never picks up the actual data
from the remote server before _cifsFileInfo_put() called.


On the other hand, why is there no problem with cifs/smb2, and the issue
only appears on smb21/smb3?

The difference is that prior to smb21, there was no concept of leases —
only oplocks:

smb2_set_oplock_level
   cinode->lease_granted = false

smb21_set_oplock_level
   cinode->lease_granted = true

This means that on cifs/smb2, cifs_close() invokes _cifsFileInfo_put()
immediately (rather than going through the deferred-close path), so the
problem described above doesn't occur.



I'm new to SMB, so this is very much a beginner's analysis. I hope it's
useful to others, and I'd really appreciate it if anyone could point out
mistakes or things I've gotten wrong.

Thanks,
Zizhi Wo





