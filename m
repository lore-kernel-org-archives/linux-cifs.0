Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400D1DC985
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784424519; cv=none; b=pv2xhmfz92QO5RoTEvdseXgBcNiVlL2lozSoqwnzWWcnwP4+XiWiBIZmc9J8wDMxg2lhdA32dB4KyJ/8yRlfbD1dTFbt+zfY4akhclyV3kieEvWotJOkFg/yxjFax0dvkNgh9OXHkfJ7NFAcdOtnlUaUyBlYc6aUoecNAU+1BY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784424519; c=relaxed/simple;
	bh=iwcA+UtzzfCwMYkObhEfH9Tc51fZkb40tB0POzUW3bQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIX/Dar3Chb4kyWfSmvMsLhjpZQd56+JGMzQa83uLmcZDeenW8YNdvveuxlx7n8O+Tb3/FwvEayy4wA/ljzS7OYHeaWGUhMoZ6ULspqox4egISUvWVq/xhR/o+uQF23bMypFbOV07FSunmd7KS1xUh1LHn9vLYG4ukfqv0+j86s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=F6YUd+9I; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="F6YUd+9I"
Message-ID: <44f9e30a-6420-4b02-b32e-18ee1086f3af@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784424512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1xgvIK/vScvgBBO1vaxWjyO8nrttEn3Q6YktkXZd3s=;
	b=F6YUd+9IfW43QXDfaQP4Q+/uoBemqwWMDZBjK340hjvBVob/yULVdHMbzVL4Qc6cz6Hsae
	9SFn8IN0r+xtyw0xaWL7CZ29I1LGjzDJ1K+nU5apu+cn7mT2qg8FMdXzUWJeJHgmFFrGH4
	eZ/g2Tf8cCU85Hqk1bimbLpZESOzF1O2kShBtdrpbpzm/bQXLnhBaws53OIbeneRWwApOt
	QIcf30h+t1pcnGhud81kTRTfB1813+ddsOvR7xIw4DD/S1x2Fwwqygkto/XJIxZHHR2CzD
	mf4YfnTa6LOFWRyefKk8MMcb1+EkNeRWBAoI+uQxOeAEHwoUrz9Sjyq580PlPQ==
Date: Sun, 19 Jul 2026 09:28:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] smb/server: fix some bugs in preparation for change
 notify support
To: =?UTF-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, andriy.shevchenko@linux.intel.com
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com>
 <CAKYAXd8-ZSbyU8NPCBYCVrExRJiRdn=y0mYbc71sSRqD4LoYAw@mail.gmail.com>
 <70B82D7E-4699-4C9F-A1F3-2B51C61BFD20@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <70B82D7E-4699-4C9F-A1F3-2B51C61BFD20@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

You can refer to my implementation:
https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/

在 2026/7/19 7:40, Gaël Blivet 写道:
> I have a draft for the follow-up patch that I am testing but I am not yet satisfied with it as live tests currently show workers being permanently wedged in smb2_notify().
> I'll need a bit more time before sending it.
> Thanks!

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

