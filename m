Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9BD20D4ED;
	Tue, 18 Mar 2025 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742305707; cv=none; b=QxfXZClaoAADx7lB8dtmYGqRj3upV8nKLJGrcb3N/EmW+ct89aQ1RKkF/lHiXAq90fwZ4y47QuJ2tDmmPNXFkd2YL4q6nTsNcV8/KL0LRjkMCWdZU0mMe6AoL3baWrLdqqtreoJo9ooZe0DRxBazdMSjLS0MnxbZ89lYn7Z2eNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742305707; c=relaxed/simple;
	bh=0mYjFCPBsGGoajYFWug3qFwJ/+9OpDW3IARikl5KWI4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=f3YQtJPH9J9vL9CcxZ4wmYDSFBK5M7g5mxrjUGMqpSkHF9II6n+qWGOcalHLJ5+7LV1qLDdwOAaKYdFS7VyrLx8XdDzMy2yCTfn9FjEoGJHZlZ1yAevBIp1koX5ZbBsnAz7vva4DrFvHi/MRCuSMH9j8OyGCUIQgUA1KZzX8r/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZHCjg6hqPz2RV3L;
	Tue, 18 Mar 2025 21:43:51 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 435DA14022D;
	Tue, 18 Mar 2025 21:48:21 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Mar 2025 21:48:20 +0800
Message-ID: <6ae36cf1-a1a8-065e-d884-fe0810e607cf@huawei.com>
Date: Tue, 18 Mar 2025 21:48:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] smb: client: Fix netns refcount imbalance causing leaks
 and use-after-free
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: Steve French <smfrench@gmail.com>
CC: <tom@talpey.com>, <kuniyu@amazon.com>, <ematsumiya@suse.de>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
 <CAH2r5mstBkj5-aHcXLpb8YzrDHS+nWhW+i_Kf8eJK15sFmJx8A@mail.gmail.com>
 <c056ce12-2b02-fe11-5f61-ce913b6de5d9@huawei.com>
In-Reply-To: <c056ce12-2b02-fe11-5f61-ce913b6de5d9@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Friendly piug.

Best regards,
Wang Zhaolong
