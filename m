Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151DF2475CF
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782264441; cv=none; b=FeNcfBcq3gNwZ6vKDvbAhea+EQYqLF0ipV2fd5+pGqjRm36NI4D2IvTq3D48WGa+Pkn1GYNDIi7tFJxSwlqC7eRPZRpb+qgVGF6DpAictaJ9vOCbFbYlvLghJSWQzjLqHZWDPyU5Smx2yepS/eFpwhV4yEpWl1O2DePqZaohGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782264441; c=relaxed/simple;
	bh=Q1Ntu4b4Xuq1WdMImYuxToUtWK3ACq2WpH/R5gGJY1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOnRFiYXz35DjIeMFZuoLQl9MijQ0NuAqePGrFPDLt8y/IGXuMqLX0d5q1iFrywZWXumbQ1HNnmIkH37bfPCWDwLXxOihNeCAWO5xknRC7b3G7ehLcudxMHpCTXrrf6utgxn6GDjFov86tA7YKhlqpbb9cLGD/rVl6QEV5+BqUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oZy29mm0; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oZy29mm0"
Message-ID: <498534d3-e82e-40ce-bc7d-230580b2fcae@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782264432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sPCUWs7mHJKIZA6Vk5luHtPpJHH3uCtDf5jLZP++nqQ=;
	b=oZy29mm0l6+98aj6qiT/ASJPgdMeXY92GdaO5GYS/BOjIfXYlFURfZ8y2qLW3NhKAYWrxA
	ltWfd8AnPE/3Q8s8LeSWEiITasK4hjvkZJLYuouabe4RhijIePacbPcGAkQBRxcTm8mkkr
	bNkfbiqOEmbMGdba5lXoQlWTytQ5WPPxmX5UfYFwZvAuzchwEjsVFeYUDK0NHQCLl/tEQ7
	0smZ+FTLf0oNbMaqMKixWtOnr4Cv/K53o+y6eumPnu2KcLn6jW9FTdtBgPFFU91Eh6XuGT
	kKQVcsM+8QMXTPxkAExbG9/P0azWQOaWr7UYGFPw+PaKgoi/v/sGlcpGhNVmnQ==
Date: Wed, 24 Jun 2026 09:26:10 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] netfs: Fix UAF in netfs_unbuffered_write() on failed
 preparation
To: David Howells <dhowells@redhat.com>, hongao <hongao@uniontech.com>
Cc: Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <33cc8eb4-8831-49b0-80d6-b06544a37920@chenxiaosong.com>
 <FA1EF9EEE4C1415E+20260530011403.1686344-1-hongao@uniontech.com>
 <2912807.1782231053@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2912807.1782231053@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi David and hongao,

Please refer to my blog for the tracing log and reproduction steps:
https://chenxiaosong.com/en/netfs-uaf-in-netfs_unbuffered_write.html (I 
will make sure this link is always accessible)

I would appreciate it if you could continue debugging and fixing this 
issue. As I have many SMB features to implement and review tasks to do.

On 6/24/26 00:10, David Howells wrote:
> ChenXiaoSong <chenxiaosong@chenxiaosong.com> wrote:
> 
>> After applying this patch, I can still reproduce the use-after-free issue.
> 
> Can you get some tracing?  I have a suspicion it's a refcount bug.
> 
> The following tracepoints would be useful:
> 
> echo 1 > /sys/kernel/tracing/events/netfs/netfs_read/enable
> echo 1 > /sys/kernel/tracing/events/netfs/netfs_write/enable
> echo 1 > /sys/kernel/tracing/events/netfs/netfs_rreq/enable
> echo 1 > /sys/kernel/tracing/events/netfs/netfs_sreq/enable
> echo 1 > /sys/kernel/tracing/events/netfs/netfs_failure/enable
> echo 1 > /sys/kernel/tracing/events/error_report/enable
> 
> And if you can capture this, can you compress the resulting trace and send it
> to me?
> 
> Thanks,
> David
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

