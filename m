Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045244AB95
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 02:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784686488; cv=none; b=q2KVNBA6k41labdD4qntPcOMJKQfUFspmNmywSOXt64rIlwl8NvBALXcJjiIfviXn6xaJRwCyryiDfhpEbUKpHcK7+lA6pDygzrLYYQnZ1gXDOYZtE+5urxM1fgRQMF5YTkYd6PnsZDZiTVXNyGV9z19SwQokbag30p4rcnicek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784686488; c=relaxed/simple;
	bh=Z2HvuwBEkuWCMOtjY6FXpmdY1EZPI4V2mqCYDKQuj+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvqlSBDoeXj5ozlchkRsm/KW+c2BZicHj/k5dh50XuXTDu5KKtS8fomxlk7lXU9XR/3lnrTluykM5TCXYPkfVb1YH9PCyvmmzIahdjS+Lg6EMSjPPhIRAYBOrf2s7TDxMCd29KpUkhuMWZh+oYdrxMKShUy11zAcj+fiMQCW8/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=obBgrez9; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="obBgrez9"
Message-ID: <2fb95851-8416-4c74-a0b3-4b682cff472a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784686481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nCdHzNAn8y06hSThSdNoe4iyMAZ6JQHrCFoKpa6XYUY=;
	b=obBgrez9F9HrU4iynystEYlSQ70GvTm150VMEQlO6o5+XlRqhDqDrdVXtwc0KY62/bZ6yd
	GPmIwv4n5/vEYSwKBPThd64PKIA4DYGgtg4fif3HNR2VK+0N6C+WrkeTMYijlpYt87QEv6
	AWLQHOMAhpKZiCieFQ9ooi9Pk70jK1RarvBC9VAPvqcg38QEeM8ccI1k58KTc/odBDEs+Z
	vWmIPL0ZcdYegJ7N+i+j9gGeIyJyIZsj7gCPFnP2Y54+0ncro8jkIKLZ+L8D+HFRQ7YkWV
	oFBvwy7md8tZ7Nqaow/KZaA9OlwV2LEYUlizUZeFtBTX4xiQluHV69nbZ1qcnA==
Date: Wed, 22 Jul 2026 10:14:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [BUG] null-ptr-deref on ksmbd-for-next-next branch
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 CIFS <linux-cifs@vger.kernel.org>
References: <1de1e19c-bd57-403c-b91f-70b2d3b51fe7@chenxiaosong.com>
 <CAKYAXd-p=8p6c4HTfH9Su1bRAUwZsxpU=PXtRm0Y+ycge81Zaw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-p=8p6c4HTfH9Su1bRAUwZsxpU=PXtRm0Y+ycge81Zaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, you are correct. Checking conn->ops->is_sign_req is OK.

I checked work->sess because signed_req is only used by the
session-dependent signing checks below.

在 2026/7/22 9:55, Namjae Jeon 写道:
>> -       signed_req = conn->ops->is_sign_req(work, command);
>> +       signed_req = work->sess &&
>> +                    conn->ops->is_sign_req(work, command);
> I don't understand why work->sess needs to be checked here. IIUC, the
> crash occurs because conn->ops->is_sign_req is NULL when Windows
> client sends an initial SMB1 negotiate request. If so, wouldn't
> checking the callback directly make the intent clearer?
> +       signed_req = conn->ops->is_sign_req &&
>                                 conn->ops->is_sign_req(work, command);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

