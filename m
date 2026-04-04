Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769472BE7AC
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775314856; cv=none; b=rggDpQ3kuAlKjiPz+u6WLhAmk2q+lkYPiDDvnT7cS0k0AbGGK0U7mMW+Bx34eEmdUkItYtUqO22jSD8xwJv5OO14ygDpL4GdvHFRWT9n3jfYcpFChPQsMfKVzfdy/CyWuZO/IOeXMtLL0nb6B+IrwZxNUy7h4shWb3RMvmykBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775314856; c=relaxed/simple;
	bh=V4XnIePq7Gn9DlSSDTyJyCYOunjXqVD0zDyhcNI7n3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECjgz1sTFyfLKy2sDkbjKwpXvLvdWpV9mnCSXe9/Lcj6r4k0hrEvEN2PN1Sk4wriSbZNAapZHX21DSXeKnyS7V2adg94rt1jnoDT1+X2sVV2NgjX7uMEGCttyN6JCnT+MkQgerMR4pdu7SGmqVLcaviLnOlH6xuxtGnFfcGdzwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NE8NvrbW; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NE8NvrbW"
Message-ID: <0c6e5209-fd66-45d1-b018-a38b09f5ed80@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775314841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wgl30kh7l87lJQQB+ZSLWWPZAIAZEq8WmNjcBcYCYB8=;
	b=NE8NvrbWAGJM/W/NVmMhMk9pGBlRXWSFkj4IEkKhbxVzhSdJtHiD+fwHJ7CRXJjnFYyocM
	yskZI4uqTvtiKdVI+y4EV0fFEneClDQnUdxyFBscOl9Fb+13It6sS4eSWZhgTL4O28jtEr
	s8D9sM7HsCXhKGZWgDNWC4zK5nF3tcIT12IsCfkt2zaClvBR2ZHcAyJ24HUJmFJo2hjIF6
	RU1rr3Hsdl7EoRq+V3S2PEMmQs2UcTXc2bM5+cP7Vk/a6+2k+woesYRP0mQh8f1mQ9y56e
	VJ5MHkLERzwnDXVAkVh8nOb2rpwFKocu097jd35Y/exBduj3i/kOoBWBvaPmLQ==
Date: Sat, 4 Apr 2026 22:59:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix use-after-free in __ksmbd_close_fd() lock
 cleanup
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: munan Huang <munanevil@gmail.com>, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260402083912.457676-1-munanevil@gmail.com>
 <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
 <904cb9a8-2ff5-4725-8ce2-f70c4f98791e@chenxiaosong.com>
 <CAKYAXd-izPxXKFuzEPYPknwUFG_jQ37yW90D1zCpO_zWxCNJQg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-izPxXKFuzEPYPknwUFG_jQ37yW90D1zCpO_zWxCNJQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Looks good to me. Feel free to add:
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2026/4/4 22:28, Namjae Jeon wrote:
> I have updated the patch. Please check it.
> https://github.com/smfrench/smb3-kernel/commit/38bf2f4ac44b0848677fd4d539404b8c0de15b98
> 
> Thanks for the review!
