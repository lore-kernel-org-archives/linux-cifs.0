Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F25680
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 03:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754882017; cv=none; b=rnUhxKoaXxEEHaYJ6JIon95SI1ano7pkX8SUAc+yqnqjy5SZXFZFJmWjuHmrCkZmeHljm8jvAuxxuTYJkGMFrJqWuAdsJr1/8iBLgVjUrTgVVzFnVDtE4ng9uR1jQZPj/T2BvxhHVmOPVhGHUjXOj3YqH2ELmGElaPA376KUMgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754882017; c=relaxed/simple;
	bh=ynNzpkgalWWCXkG4v6mfwOlJyKuWmqtNN6ayfsNlKdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wfdj6LwUneuwn7v3SgcSZ2ebQ4YIJkWpQ6bDYZi93rUj406TSKS0eKxQATA6OXDiF9dTOftsE+vDic+KPxinLL9CdHVYBaxAEkU8GgNH9yfOMJka9EQZoESBUpaU1mkh2ebU9+pcpA/vJJEg3f1/Ex3VIga6aNquNsI/6m0OZmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c0fq03XKDzKHMTH
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 11:13:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AE90C1A1EF4
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 11:13:31 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgBn4hLZX5lo0eggDQ--.45698S3;
	Mon, 11 Aug 2025 11:13:30 +0800 (CST)
Message-ID: <81441b6f-a094-44ac-a4de-36782b0c8911@huaweicloud.com>
Date: Mon, 11 Aug 2025 11:13:28 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: generic/023 failure to Samba
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mv3xMgFfvioie17HmUBhU0ZqDQzMV6UMFBTF+9giK2pNQ@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <CAH2r5mv3xMgFfvioie17HmUBhU0ZqDQzMV6UMFBTF+9giK2pNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBn4hLZX5lo0eggDQ--.45698S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw1Dtry5uFWftF4xXF4xJFb_yoWDZwc_Zw
	s7trykA345XanxAwn8Ja1UJ390k3srWry8JFyFgwnrZrnFyw4kK3ZakF17Xw1DKrZ8Jr9I
	qF1kZwnavwsa9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0264kExVAvwVAq07x20xyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jrxhLUUUUU=
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/



> Do you also see generic/023 now fail to Samba with current mainline
> (looks like symlink issue)?
> 
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/69/steps/54/logs/stdio
> 

Hi Steve,

I've tested with the latest mainline kernel and the most recent
xfstests, but I'm not seeing the generic/023 failure with smbd or ksmbd
— it's passing cleanly on my end.

One thing I noticed: the failure logs don't include any MOUNT_OPTIONS output,
Usually, we'd see something like:

```
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 client 6.17.0-rc1 #63 SMP Mon Aug 11 10:16:12 CST 2025
MKFS_OPTIONS  -- //xxx.xxx.xxx.xxx/SCRATCH
MOUNT_OPTIONS -- -o mfsymlinks,seal,vers=3.1.1 //xxx.xxx.xxx.xxx/SCRATCH /tmp/scratch

generic/023 2s ...  2s
Ran: generic/023
Passed all 1 tests
```

Given that the issue might be related to specific mount options and since
I'am currently using default or commonly used options, it’s possible the
test did not correctly trigger the issue.

Best regards,
Wang Zhaolong

