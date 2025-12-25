Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F0310957;
	Thu, 25 Dec 2025 02:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766628035; cv=none; b=ZtKXYpCzjXt8o1nxZbCf0SRlQXtrI9ggpyCcUdgUrVENvq//6w/iS/sBP1VavQzByl8asaSP3PKJbl+3oFrGUKAbd2Ojtrs1uzvWP5AzvYnYamYbwKaMpemtwtR4HlRQcYo2HnS0QuTx9TWAsSkP6aH9bKqSWwZyQ7X2cpLepUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766628035; c=relaxed/simple;
	bh=r//pqSspGIKG2+kEvz8ET6AA70qLDjxAjMDGHQH4CX0=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SHZYvqgboBzqpUOsqLHmjKCwap6hNbJuJ/48Cb47mK+Skb+APmIMmNxx0BSRtkGMWYE/Z3Y6CxZoIXFUnr6P4XUAscbo+j8k130f9dl/CuAsIMoaEkIWmw5JU2O0Hbq4x27JTroepFFgEYF/+HgrhIVRiFdoC2r0T5+0jX2hFPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dcBl40x28zYQtfq;
	Thu, 25 Dec 2025 09:59:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B2A194056D;
	Thu, 25 Dec 2025 10:00:23 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPi1mkxp4PGJBQ--.44629S3;
	Thu, 25 Dec 2025 10:00:23 +0800 (CST)
Subject: Re: [PATCH] ksmbd: Fix memory leak in get_file_all_info()
To: Zilin Guan <zilin@seu.edu.cn>, linkinjeon@kernel.org
References: <20251224142016.250752-1-zilin@seu.edu.cn>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 jianhao.xu@seu.edu.cn
From: yebin <yebin@huaweicloud.com>
Message-ID: <694C9AB5.9000009@huaweicloud.com>
Date: Thu, 25 Dec 2025 10:00:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251224142016.250752-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBHqPi1mkxp4PGJBQ--.44629S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZF17Kw4UGr47ZrWDtFyDAwb_yoWkXFc_Xr
	Z2vrn7try5Xr42qr43Xry5trnagw1UXr93WFs3tFn3Aa98Kwn7Zws2v3s5G3ySgrWagr9I
	krn8ZF92v3srujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHD
	UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2025/12/24 22:20, Zilin Guan wrote:
> In get_file_all_info(), if vfs_getattr() fails, the function returns
> immediately without freeing the allocated filename, leading to a memory
> leak.
>
> Fix this by freeing the filename before returning in this error case.
>
> Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>   fs/smb/server/smb2pdu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 8aa483800014..4472638ab11a 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -4923,8 +4923,10 @@ static int get_file_all_info(struct ksmbd_work *work,
>
>   	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
>   			  AT_STATX_SYNC_AS_STAT);
> -	if (ret)
> +	if (ret) {
		goto out;
> +		kfree(filename);
>   		return ret;
> +	}
>
out:
          kfree(filename);
          return ret;

Maybe we can add 'out' label.

>   	ksmbd_debug(SMB, "filename = %s\n", filename);
>   	delete_pending = ksmbd_inode_pending_delete(fp);
>

