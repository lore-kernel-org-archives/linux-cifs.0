Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C322E339D
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 03:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650180; cv=none; b=By5OkByEM4lvpQhCrDEW/dAdC8e0aPQ4vbAfdw3+x8aowGG9SNf5f913S4Brf4yb1M33f/48/gsAccw0kTy2N+tOJF1BquKte7FZWBmIuFLp1bOb/u4r6Fbn7GXDGt06ZpcOhM6QzwTsSrEGFD2oUvw1lYp2HWiEIpMAP0Y4WNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650180; c=relaxed/simple;
	bh=sCEZ4a6VF3r3yhGhXIYN8S05UMd2vyujKlVLbbltbhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ux/q6/o0r2cum4NfqhcVIYp6okljOFtBjxCZx5KN3Px2VHJKpwiQx/FRcvT7UwerN0aI4Em+SxuTWWXKsNfnookt8HxQHm0J9pEK8M6sXiP+4/SWwm9Et2lNtADiFHFwPyJCK2PL5/tRiFx1TzpmSAg5OBvZrFQ3pvd/DkF5sJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZSmwX258mz2RTZt;
	Thu,  3 Apr 2025 11:11:24 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 777F9140259;
	Thu,  3 Apr 2025 11:16:13 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Apr 2025 11:16:12 +0800
Message-ID: <28287f44-ad1c-4ed2-bb60-ed9209b719b1@huawei.com>
Date: Thu, 3 Apr 2025 11:16:11 +0800
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
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Acked-by: Wang Zhaolong <wangzhaolong1@huawei.com>

> This reverts commit 4e7f1644f2ac6d01dc584f6301c3b1d5aac4eaef.
> 
> The commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> rmmod") is not only a bogus fix for LOCKDEP null-ptr-deref but also
> introduces a real issue, TCP sockets leak, which will be explained in
> detail in the next revert.
> 
> Also, CNA assigned CVE-2024-54680 to it but is rejecting it. [0]
> 
> Thus, we are reverting the commit and its follow-up commit 4e7f1644f2ac
> ("smb: client: Fix netns refcount imbalance causing leaks and
> use-after-free").
> 
> Link: https://lore.kernel.org/all/2025040248-tummy-smilingly-4240@gregkh/ #[0]
> Fixes: 4e7f1644f2ac ("smb: client: Fix netns refcount imbalance causing leaks and use-after-free")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>   fs/smb/client/connect.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 10a7c28d2d44..137a611c5ab0 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -300,7 +300,6 @@ cifs_abort_connection(struct TCP_Server_Info *server)
>   			 server->ssocket->flags);
>   		sock_release(server->ssocket);
>   		server->ssocket = NULL;
> -		put_net(cifs_net_ns(server));
>   	}
>   	server->sequence_number = 0;
>   	server->session_estab = false;
> @@ -3367,12 +3366,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   		/*
>   		 * Grab netns reference for the socket.
>   		 *
> -		 * This reference will be released in several situations:
> -		 * - In the failure path before the cifsd thread is started.
> -		 * - In the all place where server->socket is released, it is
> -		 *   also set to NULL.
> -		 * - Ultimately in clean_demultiplex_info(), during the final
> -		 *   teardown.
> +		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
> +		 * teardown.
>   		 */
>   		get_net(net);
>   
> @@ -3388,8 +3383,10 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	}
>   
>   	rc = bind_socket(server);
> -	if (rc < 0)
> +	if (rc < 0) {
> +		put_net(cifs_net_ns(server));
>   		return rc;
> +	}
>   
>   	/*
>   	 * Eventually check for other socket options to change from
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

