Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C27368277
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782202211; cv=none; b=bY46CWdFEmuEPj8vCH+rMHKXNkfI5c9/7YhthkKa9+0VvuqIE5LCSPjxBzzVfX5OKSTnKD/XwkPhXa7yBtp5sG2vH28SjMElrucz3MWpRtPnuqCWi3brwMGI5MsdR6PqOSGGnAm3tq2YDrQ9Eg37Gk4wqvPo96KkSCOvGci19Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782202211; c=relaxed/simple;
	bh=50ZIXkQi1U3A8I0CZEdA3m+A7p9/QhV8lr5Rks/M28Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwfdZBdjUXGcpjkb1NGTRLyj/TTO2WtWzxhCDg9V5ZOE0bi4Cmx9F3n0INAJ+jCuXlDkD1VRchl4dj4ZRZ0X7rC0tSg2xqK/BPQD0HqC3GQYiFTYIYCFWmx+9w3O74i5kDaPFnlp8TtY15tD1DDSNQ0HlKaVL2Ps3IRjmvyieLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=j1yO89D2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="j1yO89D2"
Message-ID: <7e8352ce-884e-4f05-9e19-a21055bbfada@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782202203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxrIxrGjcmXPR50xhQV7TzTonNdCDhtYmoxOxpad4yM=;
	b=j1yO89D2JA8mATbVuxcbiA2o3Oqb4gk46PJOd8zcRfRQe/hCpSYqlUpmtxCZ6nAfsIi1wj
	+3+JyzmV2O/8tOgXipcev4ahx8ugDVjngVY5Yqqbs1DjdiUb8EEOiumkJQOhfpS38N3JId
	Djfm39kSFBW0a0e9HlHWYIaEitK5PRHVXlYflA7LSXUbHfaqjhvdQ5NPsob7k6Cmp/qeRH
	T4A8aFUbpQmzlCrSJ2vAjHNjIwMF4Y7riGGpF5nbjNmEzA82UDARwbGPZGR9MYPAIuu2gt
	IK0j4t0nO09F/c1srmZb6vd7Q4KIXsLR4FlINoMZgj2BFTpqn18eoOLyr+Nrow==
Date: Tue, 23 Jun 2026 16:09:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: validate num_subauth when copying ACE in
 set_ntacl_dacl
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Haofeng Li <920484857@qq.com>, smfrench@gmail.com, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, linux-cifs@vger.kernel.org, Haofeng Li
 <13266079573@163.com>, Haofeng Li <lihaofeng@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
 <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
 <4747ff73-f57c-4c8f-9038-ee00c7561817@chenxiaosong.com>
 <CAKYAXd_3KmNbaUe5U-mp=vEOJQ0ovmnyxQxezY4fy_egcHJf+A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_3KmNbaUe5U-mp=vEOJQ0ovmnyxQxezY4fy_egcHJf+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Got it. Haofeng will send v2, he also has several other fix patches that 
will be sent together with this patch as a patchset.

On 6/23/26 16:04, Namjae Jeon wrote:
> We can properly use a goto statement to skip that.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

