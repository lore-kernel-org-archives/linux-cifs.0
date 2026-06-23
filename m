Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4891FF1DA
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182726; cv=none; b=SaUz8fx7wkYrRtotGdGQJS4JsWRLZOtoMe9dIN0EvSZ1JkFlaWaTJYd0DcAY3pOPdDvOLfdd6m4mz7GAz1ac4rfOoRec4C3qg30pDlJvoCPlOp11Ck2c2zAKGmPw/jhWZo6+xpMrVHj/2yg44h/jqYqAiqJu8t36yfAn5kD9qmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182726; c=relaxed/simple;
	bh=JHzHlnqbTEjWT25jhP8eUHbMYcOFNmvt8wuxgSjsF6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1MCYsxAqipzfw1cZeYnROlm/qKDHzpt3lL60zSV60gEVSoQyZDeaArOV1wK4wmaG44eg4vCKxFUpxAxTeFlVKOqxRsonkM6WzUaWit89h8PATgy+d3Oa5hr+xbgDU9iXJaMz/fWDkALREd2ISSaUcFznnOrTWWVhPfeeZ8qtps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hRx/EdWl; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hRx/EdWl"
Message-ID: <3817100f-343c-40c6-bc67-5d71edbceeb2@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782182720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KM5uO5n4WIvCn9ZvbKmgMxfEiow+xTJLnlw7pSvbp6Y=;
	b=hRx/EdWlMEqG2ezg+Ra0QqvKbQgzguh5QXhCxkcbEYAU82UMLFe7dJ+Y+v4ep2usIGr3xC
	BjPCDDJ4diDcC0kY1a4Zbz9tiHgMNLtXKn9mLGd6H/WhhIGeFBOpEYxu8milJ/0sgTu2gE
	BYyt7yzrNSsX2sF/14AkIsCwImSEHXMpdyX8ZcxtUhgbI32hNCPgQ+hNVBNtyW+UHNxxj2
	j/x+QfAu8T/QU65TV16+z0oS80SXSehU1pu4z+bHXtSnDAMDlS4PzG5hiuWeFAScyDssAr
	vjqHJLmP2Q3YMH3+9EEr+EqTIfvnrs5GjRDSTt+MX1lJY0Z9AKOOMpryu5e//w==
Date: Tue, 23 Jun 2026 10:44:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] ksmbd: fix acl.sd_buf memory leak in
 ksmbd_vfs_get_sd_xattr
To: liuqiangneo@163.com, linkinjeon@kernel.org, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qiang Liu <liuqiang@kylinos.cn>
References: <20260623021240.34722-1-liuqiangneo@163.com>
 <20260623021240.34722-3-liuqiangneo@163.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260623021240.34722-3-liuqiangneo@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The label name `free_n_data` is used to free n.data. Please use a 
different label name.

On 6/23/26 10:12, liuqiangneo@163.com wrote:
> +
> +free_n_data:
>   	if (rc < 0) {
>   		kfree(acl.sd_buf);
>   		*pntsd = NULL;
>   	}
> -
> -free_n_data:
>   	kfree(n.data);
>   	return rc;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

