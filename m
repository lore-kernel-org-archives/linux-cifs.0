Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679831DA4E;
	Tue, 19 Aug 2025 02:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571701; cv=none; b=kPYHq8ORZvXYjWksEAQI3IkR2WQ/VmnKYbVzQiUzemUyReZH2txTrdxpO7EF/ETO0f5ndNe5eAxy1XtYoxsPtRTGm5mK8zsTjvXlX8YbfBgb9S0r/ZM8yTd5WhBv9/cxEEMOy32ZtoNFl9nKyno6vgZ/vO/zrvcaEkzfESsNZZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571701; c=relaxed/simple;
	bh=DIHpUinyjnwiM1J+nYXRaCDItBY4mUGiNKQwpS3s+0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aNuauvJB3UfWqEu9x9LkTmYz3lJ1Z8nAfuKJvHFluZ5dDzbU2GM9fSBIcmY3dXG818Sz2FAwCxA21OzJLQRkQTf8i6aMKITgcD9or7kUiBCtKfMDi6fz7eVg+0lfy8iPxyNfgBnCvDBF/+ydnrnbKkNZzoOwj74tpcvUV2B3dZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c5Yn416Kyz2Cg9D;
	Tue, 19 Aug 2025 10:43:52 +0800 (CST)
Received: from kwepemk100003.china.huawei.com (unknown [7.202.194.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 52FD3180042;
	Tue, 19 Aug 2025 10:48:14 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemk100003.china.huawei.com (7.202.194.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 10:48:13 +0800
Message-ID: <3059e4f5-8ad7-44f0-80fa-61e3838ed54a@huawei.com>
Date: Tue, 19 Aug 2025 10:48:13 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] smb: client: Fix NULL vs ERR_PTR() returns in
 cifs_get_tcon_super()
To: Steve French <smfrench@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Paulo Alcantara <pc@manguebit.org>
CC: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>
References: <aKL5dUyf7UWcQNvW@stanley.mountain>
 <89a2023c-e383-4780-83e3-ba8f9e44c015@huaweicloud.com>
 <CAH2r5muVjS+Y_NFSWwYoisPGfynyTkmynjpQHi2_Kk6Z8AiG0w@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5muVjS+Y_NFSWwYoisPGfynyTkmynjpQHi2_Kk6Z8AiG0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk100003.china.huawei.com (7.202.194.51)

> Since Paulo pointed out a problem with v4 of this patch, an obvious
> question is Dan's patch "independent enough" to take or would it make
> the v5 of your patch harder.  Let me know when there is a v5 of the
> patch so we can do more testing and review
> 
> On Mon, Aug 18, 2025 at 8:30 AM Wang Zhaolong
> <wangzhaolong@huaweicloud.com> wrote:
>>
Hi Steve, Paulo, and Dan,

Thank you very much for your attention to this patch.

The NULL pointer issue has already been addressed in the V4
version of the patch. I have considered submitting a V5 version
of the patch, but I have not yet decided whether to proceed with it.

While further analyzing the code, I discovered the following
potential issues in the implementation of `cifs_tree_connect()` in
`dfs.c`, which calls `cifs_get_dfs_tcon_super()`:

1. `cifs_get_dfs_tcon_super()` only returns a single superblock reference.
    Using this superblock, it retrieves the associated `cifs_sb`. However,
    a single tcon is supposed to be associated with multiple `cifs_sb`
    instances. I am unsure whether there is a mechanism that guarantees a
    DFS tcon (where `tcon->origin_fullpath` is non-NULL) has exactly one
    associated `cifs_sb`. My current patch series only retrieves the first
    `cifs_sb` that satisfies the condition, which may not be sufficient.

2. The only purpose of retrieving the `cifs_sb` is to update the `prepath`
    field of the `cifs_sb` in `tree_connect_dfs_target()` by calling
    `cifs_update_super_prepath()`. No other information from the VFS-layer
    superblock is used. However, retrieving the superblock is also meant to
    pin it in memory to prevent it from being released. Therefore, I am
    considering whether to simplify the process of updating the prepath.

If I decide to submit a V5 version of the patch, I will need to fully investigate:
1. Whether a DFS tcon can be associated with multiple `cifs_sb` instances.
2. If multiple `cifs_sb` instances are associated with a DFS tcon, whether
    the `prepath` field of all associated `cifs_sb` instances needs to be
     updated.

Only after thoroughly understanding these two points can I come up with a
better implementation for the V5 patch.

Resolving these questions will take some time. If anyone can provide
guidance or assistance, I would greatly appreciate it.

Best regards,
Wang Zhaolong
Wang Zhaolong
