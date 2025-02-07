Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7197227735;
	Fri,  7 Feb 2025 01:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890511; cv=none; b=M71a3QKHZUsnX9ud4lEXmzNmDb4Ci1nao5I2lUz4vA9C3holMJGDRSciv/BZQZDlQH0FozPkNAPg3K382mLj7Lxysya2SN6qJd3djP2VyhIKVaEZgF0dwZAMwqmxzOhJy1R1+TmGotFi58Jh5TRROtM6IkZsgBB3te58p3ap+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890511; c=relaxed/simple;
	bh=MVLFbPv9nHm1Zt1Lb54xEtqzGjNNzQ452KFT1kn+hvQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ZahQPYQaVRyo9fC2/7psEKGoDbLFg4QY+B4ePsiswzxOpVwgdPZm+xez8SaaMHTaXeNx5imaL31XxK71NHQeJluwo5d8NPvjSxifwFXhBD42G+NQyrnI6bTv5kVvs2k1pYL2dmBvKR+Yy/Nxlm0zLXhqKTP98k/TQffHOCtytsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ypwk12hFnzbnrH;
	Fri,  7 Feb 2025 09:04:57 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 1802C180064;
	Fri,  7 Feb 2025 09:08:24 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Feb 2025 09:08:23 +0800
Message-ID: <be85923e-ab12-cd42-ae3b-1585ca8b71e0@huawei.com>
Date: Fri, 7 Feb 2025 09:08:22 +0800
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
To: "stable@vger.kernel.org" <stable@vger.kernel.org>, "sfrench@samba.org"
	<sfrench@samba.org>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, yangerkun
	<yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>
References: <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
In-Reply-To: <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Friendly ping.

Best Regards,
Wang Zhaolong
