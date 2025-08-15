Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161DE1D95A3;
	Fri, 15 Aug 2025 02:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226540; cv=none; b=HTJ21TEPYz1+tTGd1nTm/WT65qTBiNE2QOIt7kuEuANAZ1hY8cGJ0QOZ5ANvIfIj07Zu+nCk+fk1JJu0stJreOcrwYs8OVPnHAs7kEc69X6cfhRTRr4v5oKSl6NBrDFqgZnQrMI/u6RqRy3Oblrh4UfeMMH32RL6pV5lhCEafy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226540; c=relaxed/simple;
	bh=lNWBFGi+MGy24oqlQurhAWMuwv+M8/9YUENYe3SZ8Rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kG+bq3LkkGxqB/9cJ2E1jrV9AuALl/tJqcX2ekTbesihQ5FR11mo7R/nxhLJ0o1ARDe8yilhphINkSR3hpIIazKRnv4MxaGX4WoSzCul0z+duxyU6YFeU6HsnMKdDwlQutemQmmoJq2kJwCDHwbz+ScWbAML9KCFa2A2pd16sI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c36DP6491zYQv2n;
	Fri, 15 Aug 2025 10:55:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 742A51A0B73;
	Fri, 15 Aug 2025 10:55:32 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgBn4hKioZ5ouQfmDg--.51856S3;
	Fri, 15 Aug 2025 10:55:32 +0800 (CST)
Message-ID: <66cf50aa-0a8e-4589-9c59-6fa7b714d1a7@huaweicloud.com>
Date: Fri, 15 Aug 2025 10:55:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] smb: client: Fix mount deadlock by avoiding super
 block iteration in DFS reconnect
To: Paulo Alcantara <pc@manguebit.org>, sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, chengzhihao1@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
References: <20250813013208.1564486-1-wangzhaolong@huaweicloud.com>
 <f0490a5be0ebe2eac03be48ec787e1ec@manguebit.org>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <f0490a5be0ebe2eac03be48ec787e1ec@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBn4hKioZ5ouQfmDg--.51856S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1xGFW3WF1rWFy8JFWxXrb_yoW5Jr1UpF
	W5ta9IvrWDAry8Ga97Ja4kXw1DZaykKa43uF93Ka48Za9Fv3s7WFs2yr1Yg3ZxKrWkXFW8
	Ga1jkrWkCF4kJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/


> 
> $ ./scripts/faddr2line --list fs/smb/client/cifs.o cifs_tree_connect+0x23c
> cifs_tree_connect+0x23c/0xc10:
> 
> CIFS_SB at /home/pc/g/linux/fs/smb/client/cifsglob.h:1624
>   1619   }
>   1620
>   1621   static inline struct cifs_sb_info *
>   1622   CIFS_SB(struct super_block *sb)
>   1623   {
>> 1624<          return sb->s_fs_info;
>   1625   }
>   1626
>   1627   static inline struct cifs_sb_info *
>   1628   CIFS_FILE_SB(struct file *file)
>   1629   {
> 
> (inlined by) cifs_tree_connect at /home/pc/g/linux/fs/smb/client/dfs.c:435
>   430                    goto out;
>   431            }
>   432
>   433            sb = cifs_get_dfs_tcon_super(tcon);
>   434            if (!IS_ERR(sb))
>> 435<                   cifs_sb = CIFS_SB(sb);
>   436
>   437            /* Tree connect to last share in @tcon->tree_name if no DFS referral */
>   438            if (!server->leaf_fullpath ||
>   439                dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
>   440                    rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name,
> 
> You can reproduce with the following:
> 
> $ kinit administrator@ZELDA.TEST
> $ su testuser -c 'kinit administrator@ZELDA.TEST'
> $ mount.cifs //w22-dc1.zelda.test/dfstest/link2 /mnt/1 -o sec=krb5,multiuser,echo_interval=10
> $ mount -t cifs
> //w22-dc1.zelda.test/dfstest/link2 on /mnt/1 type cifs (rw,relatime,vers=3.1.1,sec=krb5,cruid=0,cache=strict,upcall_target=app,multiuser,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.124.33,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,noperm,reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,bsize=1048576,retrans=1,echo_interval=10,actimeo=1,closetimeo=1)
> $ su testuser -c 'ls /mnt/1'
> dir1  dir10  dir3  dir5  dir6  dir8  dir9  target1_file.txt  tsub
> # disconnect target server 192.168.124.33 and then wait for oops...
> 
> The problem seems related to the tcon created for testuser not having a
> link to the CIFS superblock, hence the oops when reconnecting the tcon.
> 
> Could you please verify?  Thanks.


Thanks for your detailed feedback and for pointing out the issue

In my current implementation, I assumed that sb->s_fs_info was already
initialized during this process, which led to the issue. I will carefully
address this problem and ensure the link to the CIFS superblock is properly
established. I'll revise the patch accordingly and send out a V4 version as
soon as possible.

Thanks again for your review and support!

Best regards,
Wang Zhaolong

