Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96DE31CA48;
	Mon, 18 Aug 2025 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522233; cv=none; b=DvVSTE/fNPvAgj1eRbD2AKxVDcKV+aUwO8zeqWuoyMQVpV6D32kRMEXLlnISWEK0QnqhXkB0cbL98keNlVLzQjW+cLeXWDVY7wjCum2EkNU3tX42J5nrkoB5hkHZ0cWsa/SgwuCo4bhKWQDDMSQO4R3br2AK8adI//BysZ8kvro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522233; c=relaxed/simple;
	bh=3eSzentkqOibXZaENmGblqSTCJYk6IoR9S8VOJLZgsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8ToxDeH4+q+YBw3iI2E61Gh1q0d6pRPhtyCMjdOd6gaxnEIO3PI899aT7+nZSr7rO/n3IjYKGFgFlD3kNWsLJS/ceSnhepyBIMXEk8P5S1jvf6e6lGkYXI/YF4gL8h3a+5XccongXHgjDgUFbTkvSqDlbk0zAkycIOT9u5RdnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c5CZr3RglzKHMVL;
	Mon, 18 Aug 2025 21:03:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D97FB1A0875;
	Mon, 18 Aug 2025 21:03:47 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxCwJKNoY2JrEA--.45177S3;
	Mon, 18 Aug 2025 21:03:46 +0800 (CST)
Message-ID: <89a2023c-e383-4780-83e3-ba8f9e44c015@huaweicloud.com>
Date: Mon, 18 Aug 2025 21:03:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] smb: client: Fix NULL vs ERR_PTR() returns in
 cifs_get_tcon_super()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <aKL5dUyf7UWcQNvW@stanley.mountain>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <aKL5dUyf7UWcQNvW@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDHjxCwJKNoY2JrEA--.45177S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1kXF1fJryxXr43WF4Uurg_yoW8tr4UpF
	4Yk34UCFs8J3yDXw4xZFn5C3WF9w1DCFyDCrn5C3Wvvw45ZrWjqFyUK34jvF1SyrWUW348
	WFsFyasIv3y8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/



> The cifs_get_tcon_super() function returns NULL on error but the caller
> expect it to return error pointers instead.  Change it to return error
> pointers.  Otherwise it results in a NULL pointer dereference.
> 
> Fixes: 0938b093b1ae ("smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Hi Dan,

Thank you for your patch and for taking the time to address this issue.

I would like to mention that I have recently sent out the V4 version of
the patch series, which addresses the issues related to `cifs_get_tcon_super()`.
In the latest version, the issue of NULL pointer dereference has already
been resolved.

https://lore.kernel.org/all/CAH2r5msLMNdqdo6EBuTvrQ0hwrqSRC-LSZuN2WpwV+PkDwsCOw@mail.gmail.com/

I avoid null pointer dereferencing by performing a null pointer check on
the return value of cifs_get_dfs_tcon_super().


> ---
>   fs/smb/client/misc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 3b6920a52daa..d73c36862e97 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -1116,7 +1116,7 @@ static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
>   	struct cifs_sb_info *cifs_sb;
>   
>   	if (!tcon)
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>   
>   	spin_lock(&tcon->sb_list_lock);
>   	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
> @@ -1141,7 +1141,7 @@ static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
>   	}
>   	spin_unlock(&tcon->sb_list_lock);
>   
> -	return NULL;
> +	return ERR_PTR(-ENOENT);
>   }
>   
>   struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)

Additionally, I think it somewhat peculiar that in the current
implementation, cifs_get_tcon_super() returns -EINVAL.

I would greatly appreciate it if you could review my latest patch series to
confirm if it resolves the concerns. If there are any additional improvements, I
would be happy to collaborate further to ensure the best possible solution.

Best regards,
Wang Zhaolong

