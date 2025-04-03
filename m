Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE142459E9
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743674367; cv=none; b=g9Na9pMhsVdi4GoX6PxhkSj/BAk7jYvgQ+UjZM/Y6AtJfm26jQ5giyBwe0n51Rrj/VjRMVm+V7Ik+TJ+9+A1/8IxAXeqY45jDXG7wOr8XbbAKwPpGu1o5JpMVGxQq/DVxKFYNpFBEURCaHQvj28T5Yu4zPdoaSnkZro31sXLtmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743674367; c=relaxed/simple;
	bh=j9YjvJK5HzdN09AkouQsmu0xtYB7NEFeAVEeaLNymZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M+v5l8M/Cq9gZTKwVcgs6eo/w3EbHypbvkhumfKauleP3T/XvtAZeX8AXTak3VxYY1jnTZ/MSVbGq41N9xSV/vRgQVwbE0jokNY9nHMQWqTWuxQe0vYKh3VSndEEkR0t1WlUeBiBOWqt7dcOR/mpJBrLdRhNSRwOdbtHR1kZM9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZSxxd0b6TztRdf;
	Thu,  3 Apr 2025 17:57:57 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B7AC180103;
	Thu,  3 Apr 2025 17:59:22 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Apr 2025 17:59:21 +0800
Message-ID: <1e95b93f-7632-441a-a4ba-aecd7e640383@huawei.com>
Date: Thu, 3 Apr 2025 17:59:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Revert "smb: client: Fix netns refcount imbalance
 causing leaks and use-after-free"
To: Kuniyuki Iwashima <kuniyu@amazon.com>, Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo Matsumiya
	<ematsumiya@suse.de>, Kuniyuki Iwashima <kuni1840@gmail.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
References: <20250402200319.2834-1-kuniyu@amazon.com>
 <20250402200319.2834-2-kuniyu@amazon.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <20250402200319.2834-2-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Hi Kuniyuki,

When testing this patch on the latest mainline, I found that the following
snippet has a conflict:


> @@ -3444,6 +3441,9 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
>   		rc = ip_rfc1001_connect(server);
>   
> +	if (rc < 0)
> +		put_net(cifs_net_ns(server));
> +
>   	return rc;
>   }
>   

Specifically, it is this line:

>   	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))

In my code, it corresponds to the following snippet:

```
@@ -3333,10 +3330,13 @@ generic_ip_connect(struct TCP_Server_Info *server)
  	}
  	trace_smb3_connect_done(server->hostname, server->conn_id, &server->dstaddr);
  	if (sport == htons(RFC1001_PORT))
  		rc = ip_rfc1001_connect(server);
  
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
  	return rc;
  }
```

Looks like V3 needs to be sent?

Best regards,
Wang Zhaolong

