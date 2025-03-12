Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAEE12D758
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 01:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741742754; cv=none; b=eYPfXrnINJRTMlOriMU+ETujeYMxyI37fMA+gWbbTToHuB9ZxIXdB9A21qkN4BBdrxaxVqtzGgs9jBBsc98OHXCQQ6G0aNhJcYSRnbG+gT0FnApTWw3e1ngKlVXOkw1lP4v4n7p4+jOvgEzNUIpbm/y6ptlEE2bKFZt4HpbXvaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741742754; c=relaxed/simple;
	bh=KQe7z8GQTnMNvehMLcLhBax4NrkuBtbpmlS2PGoTFn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rNSp0WbQ6vZWPyt4vHyPdZu6DSxza+08sNV466KX1r2dAh/qlg2ET8MtHfBxerTlkrfiKJH0lc1CeQQYK8KgcrlYuGgmyEyMWKjIVj92W9cDbqaMlb0RF79mAApjfVKFaTOCCysSZwyuVO6cZUpKT0C4ahagpTuD6YSdG43ucCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZCCcn0rG0z1cyhS;
	Wed, 12 Mar 2025 09:25:45 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 157A51402C1;
	Wed, 12 Mar 2025 09:25:49 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 12 Mar 2025 09:25:48 +0800
Message-ID: <c9382853-f06f-48bb-bdbe-bbb18f518f23@huawei.com>
Date: Wed, 12 Mar 2025 09:25:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] nfs: Fix incorrect read-only status reporting in
 mountstats
To: Steve French <smfrench@gmail.com>
CC: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>,
	yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
	"yukuai (C)" <yukuai3@huawei.com>, Hou Tao <houtao1@huawei.com>
References: <20250303143355.3821411-1-lilingfeng3@huawei.com>
 <CAH2r5mtYrSd6c3mwUd3yg0FZPemFmV_MpmDVNdFGF1sAiMQJXw@mail.gmail.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <CAH2r5mtYrSd6c3mwUd3yg0FZPemFmV_MpmDVNdFGF1sAiMQJXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Apologies, I'm not well-versed in CIFS, but cifs_show_stats lacks the
intended implementation. From my understanding, altering the parameter
list of the show_stats callback does not affect CIFS.

Thanks.

在 2025/3/12 6:08, Steve French 写道:
> Do you have a repro scenario example of this for cifs.ko? the
> suggested change seems plausible, but wondering about how to recreate
> the case you mention where "mounting may generate multiple
> superblocks" (are there DFS examples that this would help?)
>
> On Mon, Mar 3, 2025 at 8:18 AM Li Lingfeng <lilingfeng3@huawei.com> wrote:
>> In the process of read-only mounting of NFS, only the first generated
>> superblock carries the ro flag passed from the user space.
>> However, NFS mounting may generate multiple superblocks, and the last
>> generated superblock is the one actually used. This leads to a situation
>> where the superblock of a read-only NFS file system may not have the ro
>> flag. Therefore, using s_flags to determine whether an NFS file system is
>> read-only is incorrect.
>>
>> Use mnt_flags instead of s_flags to decide whether the file system state
>> displayed by the /proc/self/mountstats interface is read-only or not.
>>
>> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
>> ---
>>   fs/nfs/internal.h      |  2 +-
>>   fs/nfs/super.c         | 12 ++++++------
>>   fs/proc_namespace.c    |  2 +-
>>   fs/smb/client/cifsfs.c |  2 +-
>>   include/linux/fs.h     |  2 +-
>>   5 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
>> index fae2c7ae4acc..14076fc9b1e8 100644
>> --- a/fs/nfs/internal.h
>> +++ b/fs/nfs/internal.h
>> @@ -565,7 +565,7 @@ int  nfs_statfs(struct dentry *, struct kstatfs *);
>>   int  nfs_show_options(struct seq_file *, struct dentry *);
>>   int  nfs_show_devname(struct seq_file *, struct dentry *);
>>   int  nfs_show_path(struct seq_file *, struct dentry *);
>> -int  nfs_show_stats(struct seq_file *, struct dentry *);
>> +int  nfs_show_stats(struct seq_file *, struct vfsmount *);
>>   int  nfs_reconfigure(struct fs_context *);
>>
>>   /* write.c */
>> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
>> index aeb715b4a690..62dfba216f7f 100644
>> --- a/fs/nfs/super.c
>> +++ b/fs/nfs/super.c
>> @@ -662,10 +662,10 @@ EXPORT_SYMBOL_GPL(nfs_show_path);
>>   /*
>>    * Present statistical information for this VFS mountpoint
>>    */
>> -int nfs_show_stats(struct seq_file *m, struct dentry *root)
>> +int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
>>   {
>>          int i, cpu;
>> -       struct nfs_server *nfss = NFS_SB(root->d_sb);
>> +       struct nfs_server *nfss = NFS_SB(mnt->mnt_sb);
>>          struct rpc_auth *auth = nfss->client->cl_auth;
>>          struct nfs_iostats totals = { };
>>
>> @@ -675,10 +675,10 @@ int nfs_show_stats(struct seq_file *m, struct dentry *root)
>>           * Display all mount option settings
>>           */
>>          seq_puts(m, "\n\topts:\t");
>> -       seq_puts(m, sb_rdonly(root->d_sb) ? "ro" : "rw");
>> -       seq_puts(m, root->d_sb->s_flags & SB_SYNCHRONOUS ? ",sync" : "");
>> -       seq_puts(m, root->d_sb->s_flags & SB_NOATIME ? ",noatime" : "");
>> -       seq_puts(m, root->d_sb->s_flags & SB_NODIRATIME ? ",nodiratime" : "");
>> +       seq_puts(m, (mnt->mnt_flags & MNT_READONLY) ? "ro" : "rw");
>> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_SYNCHRONOUS ? ",sync" : "");
>> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_NOATIME ? ",noatime" : "");
>> +       seq_puts(m, mnt->mnt_sb->s_flags & SB_NODIRATIME ? ",nodiratime" : "");
>>          nfs_show_mount_options(m, nfss, 1);
>>
>>          seq_printf(m, "\n\tage:\t%lu", (jiffies - nfss->mount_time) / HZ);
>> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
>> index e133b507ddf3..1310c655f33f 100644
>> --- a/fs/proc_namespace.c
>> +++ b/fs/proc_namespace.c
>> @@ -227,7 +227,7 @@ static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
>>          /* optional statistics */
>>          if (sb->s_op->show_stats) {
>>                  seq_putc(m, ' ');
>> -               err = sb->s_op->show_stats(m, mnt_path.dentry);
>> +               err = sb->s_op->show_stats(m, mnt);
>>          }
>>
>>          seq_putc(m, '\n');
>> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>> index 6a3bd652d251..f3bf2c62e195 100644
>> --- a/fs/smb/client/cifsfs.c
>> +++ b/fs/smb/client/cifsfs.c
>> @@ -836,7 +836,7 @@ static int cifs_freeze(struct super_block *sb)
>>   }
>>
>>   #ifdef CONFIG_CIFS_STATS2
>> -static int cifs_show_stats(struct seq_file *s, struct dentry *root)
>> +static int cifs_show_stats(struct seq_file *s, struct vfsmount *mnt)
>>   {
>>          /* BB FIXME */
>>          return 0;
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 2788df98080f..94ad8bdb409b 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2308,7 +2308,7 @@ struct super_operations {
>>          int (*show_options)(struct seq_file *, struct dentry *);
>>          int (*show_devname)(struct seq_file *, struct dentry *);
>>          int (*show_path)(struct seq_file *, struct dentry *);
>> -       int (*show_stats)(struct seq_file *, struct dentry *);
>> +       int (*show_stats)(struct seq_file *, struct vfsmount *);
>>   #ifdef CONFIG_QUOTA
>>          ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
>>          ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
>> --
>> 2.31.1
>>
>>
>
