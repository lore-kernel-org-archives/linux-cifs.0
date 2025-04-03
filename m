Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282F71F12EF;
	Thu,  3 Apr 2025 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743675274; cv=none; b=oP8M8OevmPv5/JLqx0dIuQEdY0O3XWrm2A7jrwPHIf1Mzy/fiYkZSgpPt4KHG/S5Zi1WlyenZZRKKDniXsF3wXTnGjXUKjdu3JZlnhhMAs2gRlz+pLf1odYUsCWdbNb1XGMoWNjHzMvMS14MA92BFQYJ3dIiguf/J0l/9FbGvI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743675274; c=relaxed/simple;
	bh=sjeoKwvNnAErTTB2TVWghFi+HJtqzrkEia5y2ZVSlwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LVABq1Ejug2yl6Rt3OYlr+kfpQ5wZjSxZ0g/UWLuRgQ80aqOadx451DAjDHgwYPtcmMdfGApMB7MRQMJ+7lVYNLWXk/uiCD56skgLjfJy295naZAEJzxiZmEY4KxIUjgUEKgqD1OrlulRL1RuEKTIG1pK1fGk4kAsaLeZAswqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZSyCx604bzvWql;
	Thu,  3 Apr 2025 18:10:21 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A73B1800E4;
	Thu,  3 Apr 2025 18:14:22 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Apr 2025 18:14:21 +0800
Message-ID: <0520d98d-8289-4cd8-bf37-57bf00750e63@huawei.com>
Date: Thu, 3 Apr 2025 18:14:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its
 followup commit.
To: Steve French <smfrench@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>
CC: <bharathsm@microsoft.com>, <ematsumiya@suse.de>, <kuni1840@gmail.com>,
	<linux-cifs@vger.kernel.org>, <pc@manguebit.com>,
	<samba-technical@lists.samba.org>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<linux-net@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <CAH2r5mt68AFyJGdBcPB+eqzdAdbx=0QXC_U8MY-te26Wb0ye5w@mail.gmail.com>
 <20250403021927.53033-1-kuniyu@amazon.com>
 <CAH2r5mu7Wf0n9ZmnhAAWetKRiUczHv+odYHj5bBg6a=G1y2kcQ@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5mu7Wf0n9ZmnhAAWetKRiUczHv+odYHj5bBg6a=G1y2kcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)



> For a complex issue like this it is important to have at least some
> Tested-by or Reviewed-by for these two, because I was having trouble
> reproducing the various reported problems on Ubuntu (or our Fedora
> test VMs), and the refcount issues are more complicated they seem.
> Let me know if anyone has reviewed these two patches or tested them.
> 

Hi Steve,

I can confirm these issues on my test environment. I'm currently using
Debian Testing (Trixie) for my development work. I've also observed the
unexpected phenomenon on Ubuntu 16.04 LTS when running the test cases.

I suspect the difficulty in reproducing might be related to rootfs image
versions - particularly with older distros like Ubuntu 16.04, as the
test case involves numerous dependent packages.

The issue of net_ns reference count leakage is not fully resolved yet.
Based on that use case, the net_ns count leakage problem can still be
constructed by adding various network faults.

I'm currently modernizing my development environment and working on
automating it. In the future, I will try to provide more comprehensive
reproduction steps when reporting problems, including detailed
instructions for setting up the environment.

Best regards,
Wang Zhaolong
