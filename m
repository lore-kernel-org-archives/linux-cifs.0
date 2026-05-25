Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1C71EE7C6;
	Mon, 25 May 2026 02:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779677214; cv=none; b=QPO8JGADuNjnu0+AO6f9OzWLrppVnY9Roz1KULqQk97+M/yIu0hs/0g4AhCrRGJP8TKEFGZx0o52Sf8wNiz6RQOnScm8yst4lkuhtuMQVKObbOrbeMEu/9AgPrN1+s6XwZfUF3LPxY50ZMp/S6SWeekKKTr67c8MH6TDZME0zfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779677214; c=relaxed/simple;
	bh=TnTBkWxk9JhRl1kKLD0U/1acCccno9j0NNxzquqm2hE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EE7KdyD8v1O9LzKViLynrxTHkWGmfz2P4yes/PF/HmncmaqK6n54MfDMPPA4RWuTwuivj3gf6dgurDlUVINK5jdfVJiXsKZwi3ZI2pD5T/jv0jSEURmN30Z1GBkQlemr3ESgBupvoy5zbxhNOR97TwRhRL4jTWKpxV6T/9hF1cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gP0dK6XLYzKHMNK;
	Mon, 25 May 2026 10:46:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B130440576;
	Mon, 25 May 2026 10:46:40 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sOuBNqUEIoDg--.62009S3;
	Mon, 25 May 2026 10:46:40 +0800 (CST)
Message-ID: <17890c94-23b8-47b9-91eb-bd586bdacd25@huaweicloud.com>
Date: Mon, 25 May 2026 10:46:38 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Zizhi Wo <wozizhi@huaweicloud.com>, Steve French <smfrench@gmail.com>,
 Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com,
 dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>,
 stable@vger.kernel.org, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 yangerkun <yangerkun@huawei.com>
References: <20260304124629.1616108-1-sprasad@microsoft.com>
 <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
 <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>
 <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz>
 <CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com>
 <CAH2r5mu-3cDEhQWnBwBATq4hv4tw9aoPtGdmaDuc1+PxeiTuxA@mail.gmail.com>
 <dd1ee60d-f8b9-4019-991f-0fadf776694b@huaweicloud.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <dd1ee60d-f8b9-4019-991f-0fadf776694b@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sOuBNqUEIoDg--.62009S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKryxtry8Ar4fuw1UZw17trb_yoW3Ww15pF
	Waka4jkr4kGryfGwn2v3WFqF10yw4xAa45Xr1Ygr17AF909r1IqF4fJrWUKFyUZrs7W3Wj
	qF4UWry7Zr1DZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/5/25 10:16, Zizhi Wo 写道:
> Hi!
> 
> 在 2026/3/15 6:03, Steve French 写道:
>> On Sat, Mar 14, 2026 at 3:38 AM Shyam Prasad N 
>> <nspmangalore@gmail.com> wrote:
>>>
>>> On Sat, Mar 14, 2026 at 1:47 AM Henrique Carvalho
>>> <henrique.carvalho@suse.com> wrote:
>>>>
>>>> On Fri, Mar 13, 2026 at 10:57:42AM +0530, Shyam Prasad N wrote:
>>>>> On Fri, Mar 13, 2026 at 1:28 AM Henrique Carvalho
>>>>> <henrique.carvalho@suse.com> wrote:
>>>>>>
>>>>>> On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com 
>>>>>> wrote:
>>>>>>> From: Shyam Prasad N <sprasad@microsoft.com>
>>>>>>>
>>>>>>> Today whenever we deal with a file, in addition to holding
>>>>>>> a reference on the dentry, we also get a reference on the
>>>>>>> superblock. This happens in two cases:
>>>>>>> 1. when a new cinode is allocated
>>>>>>> 2. when an oplock break is being processed
>>>>>>>
>>>>>>> The reasoning for holding the superblock ref was to make sure
>>>>>>> that when umount happens, if there are users of inodes and
>>>>>>> dentries, it does not try to clean them up and wait for the
>>>>>>> last ref to superblock to be dropped by last of such users.
>>>>>>>
>>>>>>> But the side effect of doing that is that umount silently drops
>>>>>>> a ref on the superblock and we could have deferred closes and
>>>>>>> lease breaks still holding these refs.
>>>>>>>
>>>>>>> Ideally, we should ensure that all of these users of inodes and
>>>>>>> dentries are cleaned up at the time of umount, which is what this
>>>>>>> code is doing.
>>>>>>>
>>>>>>> This code change allows these code paths to use a ref on the
>>>>>>> dentry (and hence the inode). That way, umount is
>>>>>>> ensured to clean up SMB client resources when it's the last
>>>>>>> ref on the superblock (For ex: when same objects are shared).
>>>>>>>
>>>>>>> The code change also moves the call to close all the files in
>>>>>>> deferred close list to the umount code path. It also waits for
>>>>>>> oplock_break workers to be flushed before calling
>>>>>>> kill_anon_super (which eventually frees up those objects).
>>>>>>>
>>>>>>> Fixes: 24261fc23db9 ("cifs: delay super block destruction until 
>>>>>>> all cifsFileInfo objects are gone")
>>>>>>> Fixes: 705c79101ccf ("smb: client: fix use-after-free in 
>>>>>>> cifs_oplock_break")
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>>>>>>> ---
>>>>>>
>>>>>> Hi Shyam,
>>>>>>
>>>>>> So the side effect of the previous code is that the umount hangs 
>>>>>> until
>>>>>> all the files are closed?
>>>>>
>>>>> Hi Henrique
>>>>> Umount works. All it does is decrement refcount on sb.
>>>>> When the last file is closed (or when the last cifs_oplock_break
>>>>> processing completes) that's when cifs_kill_sb would get called.
>>>>> Before that if there's another mount of the same share, it will reuse
>>>>> the same session, tcon and open handles. As a result, an attempt to
>>>>> delete files on the mount point may fail (which is one of first things
>>>>> done by many xfstests).
>>>>>
>>>>
>>>> Thank you for the explanation.
>>>>
>>>> I will wait for your v2.
>>>
>>> Hi Steve,
>>>
>>> I ran generic/694 to understand why it is failing with this change.
>>> I think that this fix has just exposed a problem rather than caused it.
>>>
>>> The test does the following:
>>> 1. either fallocates a file to 4G or pwrites to it
>>> 2. calls sync
>>> 3. runs stat to get number of blocks allocated for the file
>>> 4. umounts the share
>>> 5. mounts the share again
>>> 6. runs stat to get number of blocks allocated for the file
>>> 7. compares output of steps 3 and 6
>>
>> Any chance of creating a small repro script for this that is easier to
>> debug han the xfstest was?
> 
> I analyzed this issue and performed a simple local reproduction using
> smb3/smb21:
> 
> mount /dev/sda /mnt
> mount -t cifs //127.0.0.1/share /mnt/test_mnt -o vers=3.0,guest
> # smb versions below 3 do not support fallocate;
> # generic/694 replaces it with pwrite.
> # xfs_io -ft -c "pwrite 0 4G" /mnt/test_mnt/aaa
> xfs_io -ft -c "falloc 0 4M" /mnt/test_mnt/aaa
> stat -c "%b" /mnt/test_mnt/aaa
> umount /mnt/test_mnt
> mount -t cifs //127.0.0.1/share /mnt/test_mnt -o vers=3.0,guest
> stat -c "%b" /mnt/test_mnt/aaa
> 
>>
>>> Without this change, both step 3 and 6 would return 0, since even
>>> through umount/mount, the same file would remain open (since
>>> superblocks will be shared).
>>> With this change, step 3 would return 0. Step 6 would return the 
>>> right value.
>>>
>>> If you use nosharesock even after reverting this change, you'll see
>>> the test failing.
>>> Or even with this change if actimeo=0, then this test passes.
>>>
>>> The real question to ask is why aren't we updating i_blocks even after
>>> sync succeeds?
>>> My guess is that this has something to do with attribute caching when
>>> the handle is kept open.
>>
>> That sounds an important bug to fix.  Glad this test showed it.
>>
>>
>>
> 
> xfs_io -ft -c "falloc 0 4M" /mnt/test_mnt/aaa opens the file for
> writing, which causes stat -> ... -> update_inode_info to skip updating
> inode->i_blocks, because is_size_safe_to_change() returns false.
> 
> The file is only removed from the list in _cifsFileInfo_put(), but that
> call is deferred, so the value obtained in step 3 doesn't match the
> expected value. Step 6, however, does match — because after the remount
> the file has not been opened for writing.
> 
> Before the patch was merged, both runs returned 0, because the second
> mount reused the sb instance and the inode instance from the first
> mount, and the interval between the two mounts was too short, causing
> cifs_dentry_needs_reval() to return false.
> 
> SMB 2.1 behaves similarly: pwrite writes 4 GB and the size shows as
> 8388608. If the server-side backing filesystem is ext4, it also
> initially shows 8388608(see ext4_file_getattr()), and only during the
> writeback path — when it's discovered that the extent count is too
> large and an additional ETB(extent tree block) is required — does it
> become 8388616(ext4_do_writepages -> ... -> ext4_ext_new_meta_block).
> 
> On the client side, cifs_write_end() updates inode->i_blocks but doesn't
> account for that metadata block. Although generic/694 issues a sync
> before stat, and the server flushes to disk upon receiving it, so by
> rights it should return 8388616 — it doesn't. This is because
> cifs_revalidate_dentry_attr() -> cifs_dentry_needs_reval() returns false
> directly, since CIFS_CACHE_READ evaluates to true; as a result, it
> doesn't even go to the server to fetch stat.

Sorry, on the stable branch, cifs_write_end() is gone. It looks like the
update now happens in netfs_perform_write -> netfs_update_i_size
instead.

> 
> The oplock is only cleared to 0 in _cifsFileInfo_put(), and that itself
> is a deferred release, so the stat call never picks up the actual data
> from the remote server before _cifsFileInfo_put() called.
> 
> 
> On the other hand, why is there no problem with cifs/smb2, and the issue
> only appears on smb21/smb3?
> 
> The difference is that prior to smb21, there was no concept of leases —
> only oplocks:
> 
> smb2_set_oplock_level
>    cinode->lease_granted = false
> 
> smb21_set_oplock_level
>    cinode->lease_granted = true
> 
> This means that on cifs/smb2, cifs_close() invokes _cifsFileInfo_put()
> immediately (rather than going through the deferred-close path), so the
> problem described above doesn't occur.
> 
> 
> 
> I'm new to SMB, so this is very much a beginner's analysis. I hope it's
> useful to others, and I'd really appreciate it if anyone could point out
> mistakes or things I've gotten wrong.
> 
> Thanks,
> Zizhi Wo
> 
> 
> 
> 
> 
> 
> 

