Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CDD24E4A1
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 03:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757562143; cv=none; b=FhhJdcN1l9s9659zi1gX+vjdvoB7aS7RVdWbHXMFjwGY8G0zJwe9EH2x8dB9TmIfRmR+wp/kOJ8WAQ17ConTQB9ym1Xi5dKaf6h5ZXZ9z76f9taEXiHVblqWOhhCDWXvroWoENYqWABYbRoMTG8e+SFZYn4uLb9FbHBi7alviA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757562143; c=relaxed/simple;
	bh=8l8H6NN0PmeumjN0x9G+NgdKdTnRfB1bifCudima6DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PBLfgkywupANxYmeSwogBjaJndXk/ZxN3Dsed28mUcITjJwx++ZZsef00flMyd5Yd5kDh+AVT+Uy0PDCkKP19/8YgaEFPfZAhW+rskbbGElzNJYPluWxTborMpQ/o03W08wyktirwu8vnhNrVA0G7Q/AGcndX+V/Rofgu0L/8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cMjTp0wTBz24hxX;
	Thu, 11 Sep 2025 11:19:42 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 83C651400F4;
	Thu, 11 Sep 2025 11:22:58 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 11:22:57 +0800
Message-ID: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
Date: Thu, 11 Sep 2025 11:22:57 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
To: <sfrench@samba.org>, <gregkh@linuxfoundation.org>, <pc@manguebit.com>,
	<lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<dhowells@redhat.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <stable@kernel.org>,
	<nspmangalore@gmail.com>, <ematsumiya@suse.de>
CC: <yangerkun@huaweicloud.com>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <20250911030120.1076413-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100006.china.huawei.com (7.202.181.220)

Hello,

In stable version 6.6, IO operations for CIFS cause system memory leaks 
shortly after starting; our test case triggers this issue, and other 
users have reported it as well [1].

This problem does not occur in the mainline kernel after commit 
3ee1a1fc3981 ("cifs: Cut over to using netfslib") (v6.10-rc1), but 
backporting this fix to stable versions 6.6 through 6.9 is challenging. 
Therefore, I have decided to address the issue with a separate patch.

Hi Greg,

I have reviewed [2] to understand the process for submitting patches to 
stable branches. However, this patch may not fit their criteria since it 
is not a backport from mainline. Is there anything else I should do to 
make this patch appear more formal?


[1]. 
https://lore.kernel.org/all/CANT5p=r+Ce0FD7yjzJU4kq3v0UyzFNjgTz0eZ_=54fTe_H6_BQ@mail.gmail.com/
[2]. https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

在 2025/9/11 11:01, Yang Erkun 写道:
> After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
> writepages for cifs will find all folio needed writepage with two phase.
> The first folio will be found in cifs_writepages_begin, and the latter
> various folios will be found in cifs_extend_writeback.
> 
> All those will first get folio, and for normal case, once we set page
> writeback and after do really write, we should put the reference, folio
> found in cifs_extend_writeback do this with folio_batch_release. But the
> folio found in cifs_writepages_begin never get the chance do it. And
> every writepages call, we will leak a folio(found this problem while do
> xfstests over cifs, the latter show that we will leak about 600M+ every
> we run generic/074).
> 
> echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> Active(file):      34092 kB
> Inactive(file):   176192 kB
> ./check generic/074 (smb v1)
> ...
> generic/074 50s ...  53s
> Ran: generic/074
> Passed all 1 tests
> 
> echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> Active(file):      35036 kB
> Inactive(file):   854708 kB
> 
> Besides, the exist path seem never handle this folio correctly, fix it too
> with this patch.
> 
> The problem does not exist in mainline since writepages path for cifs
> has changed to netfs(3ee1a1fc3981 ("cifs: Cut over to using netfslib")).
> It's had to backport all related change, so try fix this problem with this
> single patch.
> 
> Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
> Cc: stable@kernel.org # v6.6~v6.9
> Signed-off-by: Yang Erkun <yangerkun@huawei.com>
> ---
>   fs/smb/client/file.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> v2->v3:
> 
> rebase on top 6.6 stable since some new patches has been backported
> 
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 7a2b81fbd9cf..f97478626e9d 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -2884,17 +2884,21 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
>   	rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
>   	if (rc) {
>   		cifs_dbg(VFS, "No writable handle in writepages rc=%d\n", rc);
> +		folio_unlock(folio);
>   		goto err_xid;
>   	}
>   
>   	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
>   					   &wsize, credits);
> -	if (rc != 0)
> +	if (rc != 0) {
> +		folio_unlock(folio);
>   		goto err_close;
> +	}
>   
>   	wdata = cifs_writedata_alloc(cifs_writev_complete);
>   	if (!wdata) {
>   		rc = -ENOMEM;
> +		folio_unlock(folio);
>   		goto err_uncredit;
>   	}
>   
> @@ -3041,16 +3045,21 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
>   lock_again:
>   	if (wbc->sync_mode != WB_SYNC_NONE) {
>   		ret = folio_lock_killable(folio);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			folio_put(folio);
>   			return ret;
> +		}
>   	} else {
> -		if (!folio_trylock(folio))
> +		if (!folio_trylock(folio)) {
> +			folio_put(folio);
>   			goto search_again;
> +		}
>   	}
>   
>   	if (folio->mapping != mapping ||
>   	    !folio_test_dirty(folio)) {
>   		start += folio_size(folio);
> +		folio_put(folio);
>   		folio_unlock(folio);
>   		goto search_again;
>   	}
> @@ -3081,6 +3090,7 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
>   out:
>   	if (ret > 0)
>   		*_start = start + ret;
> +	folio_put(folio);
>   	return ret;
>   }
>   
