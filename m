Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF52D23BC
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773106307; cv=none; b=P/3gdJf8d/CY47CPIHzrzPG4pD7p6W3EIdzXw41mWrbapGK0SKDT5AHggZ1hbYnfnzUVfio2CXA6CroMq9kdLfP6NzWmgEPhgqoOvRLXg+8HK+4aL8AnL73oZFH4q4LmgFnJRxPuEHHCyCzZKye3l+If7H8xjXftp174wJnJQCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773106307; c=relaxed/simple;
	bh=lXlXIbU01wZxnZPrrAT5m3wGbzOsVd0jHuk6TMP6+bE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sLgHNYEvHKeuvAXS8oRn5NZug7T/GKatZkiUZlh7joXnBRLXjdjeqpuwQ6SvLGVYdK8xpTuksq7H46JAulAKAoux5xJNkEGE2mggFZi2v1cZUY9tm/03IJ4g1eTESx4THlRwtcMWHY0j7aL63tn4KhKtCFsacj8OlyngS7gXUxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QIRZlS4+; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QIRZlS4+"
Message-ID: <f3f960b9-534d-48b1-8f3f-b7d32bb5edf5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773106304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqT12nZ4PnsScP/pVkAUjjMYF/ZX74LueqNv7NXrRU4=;
	b=QIRZlS4+95tHVkl+cb6S+ar2BjSYmIlpat1qamQjkXEhjY7HLSpfKZ+cKqh5P1Rl2Xa/oI
	QpK1rNcR6vxyUp3e9MfVutaQIgiqk8TJ0nQuPfdMPRRWLydU59K6ln/iGf6g4JRW9+qqDs
	Uk9TiVH87THPiVFmwBWwD+1IdXsHObs=
Date: Tue, 10 Mar 2026 09:31:05 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 7/7] smb: introduce struct file_posix_info
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, chenxiaosong@kylinos.cn,
 chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
 <20260303151317.136332-8-zhang.guodong@linux.dev>
 <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
 <0858a9d3-f26d-4bb3-98cb-3e73abfa1399@linux.dev>
 <CAKYAXd-EoFM=t8oG6xtv=kofuqQ2pT+7Pyt4Abk2zqMCpz+Gnw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAKYAXd-EoFM=t8oG6xtv=kofuqQ2pT+7Pyt4Abk2zqMCpz+Gnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

C structure cannot have two flexible array members.

If we make `Sids[]` a flexible array member, then there cannot be any 
members after it. However, this structure still has `filenamelength` and 
`filename[]` after it. And `filename[]` is also a flexible array member.

Do you have any suggestions for this?

在 2026/3/10 09:25, Namjae Jeon 写道:
> I know, We need to change ksmbd to use flex arrays.

