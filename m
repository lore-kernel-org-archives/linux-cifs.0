Received: from mta1.migadu.com (out-87.mta1.migadu.com [95.215.58.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05DC33F5BC
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684406; cv=none; b=pCb/2TcVx6mTjIUzPrNFDLKzIAQUgl+qOZRMnAczSVbIZb/gFOM6d47wsVG0jq9iWZLGFESlm/6TOWLZZnilCeMb7jjeKMywk0+uaAYjTX6nTQt6YEJH3AXCDBey3OKJqYRmeWrq9dYGBHZ4PBouKqvVEgTl+BIfGaqHW8ek8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684406; c=relaxed/simple;
	bh=Av5110lbJIjtIf/7O+ORHu+aovfK9tTa3WLe0kYpvxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLJoWqsk+j5A9KZJOV94i8ulCSiL6CHk5qakrtIMsKdklYN1RXDNyBhq6NoFUwqiWl0YemgwwBvUOHg9DZkY3BZErjlXjZhoi9mbYX9q3b2V7A+qbs1BOo5imTgqjAvOoo9+InxOsbnBlj0l68l/oKcWkIFm1B5Xxf5yB9k8PEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=dgWP+HVW; arc=none smtp.client-ip=95.215.58.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="dgWP+HVW"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Av5110lbJIjtIf/7O+ORHu+aovfK9tTa3WLe0kYpvxs=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786684400; v=1; x=1787289200;
 b=dgWP+HVWz1RgHB1FlH94OwahPxAfLk3B13s3AOibe1XtJUVQtieNShp8S+2ZUz4OvIMAQeBS
 3m99bmQiAhKxZu5a8Bu6dUcbTs+dOWYHiC3v3BZYeSmR+bKtuzxIWsZUQQy40r0vT8uUq/IATpM
 I1uYJ7qbg8YCEV9r/+M3yLbWtl189aXghgmOA0rEjNG+Zb2o27E3RhO8y3E7H2HFbonMaEGKe6C
 rFlncuq1AqXTCOxiLa+dbmWz8pjRlCWXNBTtQKlgVzUmVt349goZH0Ldzcf9XJuse1Mh0489Lsg
 HHzkVusWpd4pTlFn+vfKTFvHzQYGV43VTI9nLs2BrixNg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 19f6650c53c93a5e;
	Fri, 14 Aug 2026 05:13:10 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
Date: Fri, 14 Aug 2026 13:13:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Namjae Jeon <linkinjeon@kernel.org>, Blue bird <obnred@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae and Kyenghwan,

Namjae's patch can fix the BUG_ON issue.

Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On ksmbd-for-next-next, to reproduce this issue, the following patch 
needs to be reverted first:
("ksmbd: implement the command sequence window"):
https://github.com/smfrench/smb3-kernel/commit/15ab73a0feed2aaadde8e7ac3c216f5c0d1d024e

I am still analyzing why this patch needs to be reverted to reproduce 
the issue.

On 8/14/26 12:21, Namjae Jeon wrote:
> Can you check if an attached patch fixes this issue ?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

