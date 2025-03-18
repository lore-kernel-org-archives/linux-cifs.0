Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB320ADC9;
	Tue, 18 Mar 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742305830; cv=none; b=RD1MRQcETo6WLC3MyxHQW97tP4bglYeh6DiJadrSwuxfp79OgEpqv1gS/6YoEI/SH+sQEVfdsz5NJ8FRMujikefVw7wNFtQk8FYmz8MOIsZtD7rhWm744RdjP3MRjvr3MIwBgtjkmsxTdapr15KZSIBKfAYB28tAv8kIpFyvhLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742305830; c=relaxed/simple;
	bh=xxmlMwu6sJ7mBw2CjEUBQVzyZVvCb7lnQGV6nZEw9eE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=VEk/Ic5bevOLdDSljVgiSb/GAImuthqP3yih9UbD2JEKnjz9s9AbZprhnXcNjKJLonUUDAFWqObMt8WW/XP8rFNnJt5KKBUvOdbQwYJyEhEiNFIbuOC44hysOe3DWj9Jzr2PuZLcRZ/YpWU1aNWqZIJJK+CwjVQD2EIJfnDv9NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZHCnX6pCXz2Cd1y;
	Tue, 18 Mar 2025 21:47:12 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 775771A0188;
	Tue, 18 Mar 2025 21:50:26 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Mar 2025 21:50:25 +0800
Message-ID: <ee68f83b-6bc1-7334-b7bf-19415ee7c453@huawei.com>
Date: Tue, 18 Mar 2025 21:50:25 +0800
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
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>
CC: <stable@vger.kernel.org>, <linux-cifs@vger.kernel.org>, yangerkun
	<yangerkun@huawei.com>, yi zhang <yi.zhang@huawei.com>, Paulo Alcantara
	<pc@manguebit.com>
References: <CAH2r5mv4N9zFOKTxwdvk6ahAyjgpYULQp8iw2NMu3eB6FEXh0A@mail.gmail.com>
 <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
 <3049256.1739192701@warthog.procyon.org.uk>
 <785a8d03-3ee6-4eb1-e72f-db05fc4fb49c@huawei.com>
In-Reply-To: <785a8d03-3ee6-4eb1-e72f-db05fc4fb49c@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Friendly ping.

Best regards,
Wang Zhaolong
