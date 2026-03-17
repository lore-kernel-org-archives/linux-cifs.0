Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D36397685;
	Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773735463; cv=none; b=Gq0ioaENcT2s92iRn8IUl6ivdyrG7RlJKJqXWu2YX/hLaFazx8zVwaYY/Nmm6U1YKOsJRvt85HF3VtcP/ymc+aeqy+R6mGNR6OtbVhAoZyTJVDKcF476H9BHcGceWvptThKws+ciWb3monFZKBMfbSS5pf4E9pBjVx055u8HAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773735463; c=relaxed/simple;
	bh=yYgEP8ZrrvgXzoQLTggph68gLGGFqK4sWeEyRtComu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFV9VDPcr9EOD/bX8Sr3JZw4QjDiuyEjHvHXPfoVKUS7kELSQtSYL/FJ5a5pXx5sqGrxMIWjIuxpMEMbuQYEbetXy5IWNjD0IpLR+AQELfKxa7DSmFJoMSCpDy19B1JOCbnHKzfStdhByKywxP33yrgfbCoTHM9c++jUPioBRz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=T9TSP0Hi; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="T9TSP0Hi"
Message-ID: <435dda9f-93f5-41db-9d21-70371d31857b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773735447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMi0Pkwm8oH432o355wyu1dAmkX7OHBK57yXE4/m8TA=;
	b=T9TSP0HiojO9cCYJ6g5IVHawoHY35KGKPyCmD6lNOVc2Gb0WIM+QdKmG5GyhRTn3qbrbnh
	hWUkDqICp90wrMTs8Fq4hO8VgF6nvjLCckpF8nc1Pmp2UM7lJIJQmybGWntzBEE3urxG9U
	9Knir49Xep3xxxg3fJnXZs7Ov696Kh7lStG2C67nxU0U06e6X9VyqQRHCVk9krF8v5W3LD
	zT53SzpIJ9T/HC5h08RdXRqNkztMZm2MBnNX1ULmT2N1ix1aSMwwi+qVhOiVoJRxkNuy35
	JN7Vx6V2zMIfNn7g9j1Ewx6EL/H8YU9zCfMMxB7kvd8EKO8V7bSwn1Q1aB+kvg==
Date: Tue, 17 Mar 2026 16:16:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
To: Werner Kasselman <werner@verivus.ai>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: "linkinjeon@kernel.org" <linkinjeon@kernel.org>,
 "smfrench@gmail.com" <smfrench@gmail.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317065253.1743552-1-werner@verivus.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260317065253.1743552-1-werner@verivus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Looks good to me so far. Others can continue the review.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 3/17/26 14:52, Werner Kasselman wrote:
> smb_grant_oplock() has two issues in the oplock publication sequence:
> 
> 1) opinfo is linked into ci->m_op_list (via opinfo_add) before
>     add_lease_global_list() is called.  If add_lease_global_list()
>     fails (kmalloc returns NULL), the error path frees the opinfo
>     via __free_opinfo() while it is still linked in ci->m_op_list.
>     Concurrent m_op_list readers (opinfo_get_list, or direct iteration
>     in smb_break_all_levII_oplock) dereference the freed node.
> 
> 2) opinfo->o_fp is assigned after add_lease_global_list() publishes
>     the opinfo on the global lease list.  A concurrent
>     find_same_lease_key() can walk the lease list and dereference
>     opinfo->o_fp->f_ci while o_fp is still NULL.
> 
> Fix by restructuring the publication sequence to eliminate post-publish
> failure:
> 
> - Set opinfo->o_fp before any list publication (fixes NULL deref).
> - Preallocate lease_table via alloc_lease_table() before opinfo_add()
>    so add_lease_global_list() becomes infallible after publication.
> - Keep the original m_op_list publication order (opinfo_add before
>    lease list) so concurrent opens via same_client_has_lease() and
>    opinfo_get_list() still see the in-flight grant.
> - Use opinfo_put() instead of __free_opinfo() on err_out so that
>    the RCU-deferred free path is used.
> 
> This also requires splitting add_lease_global_list() to take a
> preallocated lease_table and changing its return type from int to void,
> since it can no longer fail.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for oplock_info")
> Cc: stable@vger.kernel.org
> Signed-off-by: Werner Kasselman <werner@verivus.com>
