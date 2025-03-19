Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E6F224889;
	Wed, 19 Mar 2025 01:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742347560; cv=none; b=L5s1haucyhd0eyZK+/xNRhzOkK6ehE0F6EbGRwQi3b7jxxiiuj3d3+0TxcMrVi3fPrDCq5W001uHlzWFEVW2nI++ODzJs1CKShi23K/0awRr44yNnvIV8S8Cdczku+F4Mb61x7wVpab0qTAQrCi1nO6WwHdAaIw4Os98MvApqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742347560; c=relaxed/simple;
	bh=mjS5cN+X81H4fXdsTkqyF7Mt+ArgyzY9HRm+gUADz7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=c/Uanv/840WAc3wLlZo799ABDHw00lxH9aq4FNEa+BxPZqfIyeLYBPhMq9rwGgMIcyROcxpcENDl73aCBXAFLXsQ5jG9Cuqd3p2nBtQ1up0wDMsIOisZUN5r/SRzOBi+vAI5Pu3hVvR3KRf2L/i0Byb98Mj+2t6z8IkbofceVvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZHWCD319mzvWqy;
	Wed, 19 Mar 2025 09:22:00 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id EA6CC180116;
	Wed, 19 Mar 2025 09:25:53 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Mar 2025 09:25:44 +0800
Message-ID: <10823e8a-8569-80e9-cea0-d8d7ac32a54d@huawei.com>
Date: Wed, 19 Mar 2025 09:25:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [BUG REPORT] cifs: Deadlock due to network reconnection during
 file writing
To: Greg KH <gregkh@linuxfoundation.org>
CC: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
	<stable@vger.kernel.org>, <linux-cifs@vger.kernel.org>, yangerkun
	<yangerkun@huawei.com>, yi zhang <yi.zhang@huawei.com>, Paulo Alcantara
	<pc@manguebit.com>
References: <CAH2r5mv4N9zFOKTxwdvk6ahAyjgpYULQp8iw2NMu3eB6FEXh0A@mail.gmail.com>
 <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
 <3049256.1739192701@warthog.procyon.org.uk>
 <785a8d03-3ee6-4eb1-e72f-db05fc4fb49c@huawei.com>
 <ee68f83b-6bc1-7334-b7bf-19415ee7c453@huawei.com>
 <2025031821-ominous-sappy-18ad@gregkh>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <2025031821-ominous-sappy-18ad@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Apologies for the earlier context-less ping 🙏. Here's the
situation:

I have been tracking the latest progress on fixing an issue
involving a deadlock in the CIFS write file process caused by
a network interruption. This problem affects LTS Linux kernel
versions 5.4.y through 6.6.y. The reason it is limited to LTS
versions is that the issue was avoided in the mainline 6.9
version due to the netns-based code restructuring in the CIFS.

In my previous email, I provided the code call flow of the issue,
as well as the invasive method to modify the kernel for reproduction.
If there is anything else I can provide to help move this
forward, please let me know.

Thank you for your time and support!

Best regards,
Wang Zhaolong



> On Tue, Mar 18, 2025 at 09:50:25PM +0800, Wang Zhaolong wrote:
>> Friendly ping.
> 
> Empty pings with no context are not good :(

