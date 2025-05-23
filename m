Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815D62DCBE7;
	Fri, 23 May 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747967616; cv=none; b=WirXCYkeZ9OislhcyYDx3C/7v03pQ5KoqRbJ7qgSJPJbWHZvBmXJnaKfO+ROi9xnqvHRvH6HYdd9aRZ49wlbQzAJQTScQijeqg1fOJxt50IzwioDO1lPVC0wI0fcwKA2C2B4DNCWe3K7lSQFjmzMrPn7eyHrhii0H11I7rFr1+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747967616; c=relaxed/simple;
	bh=ZW12LtuT98vxP6z4Rf5zqaKgoIbXQUaaks0B5W9ntG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IQ/DcxUWqiaqLAb9iTxHRPz2zPBdF85slwhX9FnkTXZ4S7naNMLkEpl3II+PUHIUtMXNaM2oEtorRWBm2R7HSnGMamomxVDzUyWaEx0K5XdOyFSNIYvXKWA7vevSpJV6zmfguPFG6Fa2eXOP66hUJQGiWt27FVQqIP4kgIatKK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4b3Thg3gjDz1f1pl;
	Fri, 23 May 2025 10:32:35 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B6C38180044;
	Fri, 23 May 2025 10:33:30 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 May 2025 10:33:30 +0800
Message-ID: <3c49876d-e4ae-4f70-9944-86de1c8ce035@huawei.com>
Date: Fri, 23 May 2025 10:33:29 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
To: Steve French <smfrench@gmail.com>
CC: Paulo Alcantara <pc@manguebit.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
 <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
 <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
 <c1e693c6-573f-49d4-b6cf-cc308c339f06@huawei.com>
 <CAH2r5mvoS8Py_M95+i0hB2iP06Uqz5JQbb13schBfdmJ6NzL3g@mail.gmail.com>
 <f03b6422-eac8-4998-b516-a3ba34070f0d@huawei.com>
 <CAH2r5msPC3fE1tjkw_GA+sT-AMLmKM=R6BGLnt2pccjGXQHk6w@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5msPC3fE1tjkw_GA+sT-AMLmKM=R6BGLnt2pccjGXQHk6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemg500010.china.huawei.com (7.202.181.71)


> Since your patches both clearly fix problems, and look
> non-controversial (and reviewed by multiple people).  I plan to send
> them upstream today, let me know if any objections.
> 

Thank you for your confirmation and for sending the patches upstream.

Much appreciated!

Best regards,
Wang Zhaolong
