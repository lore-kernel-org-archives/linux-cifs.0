Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB7C4437A
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742215587; cv=none; b=gPvIYuBn+3EuQVjluOXZALuadsI6xr873/zoR9iKuA3VMbRxoTZMaX3EK3pGmI2PvW8CpU/ZVcNu9ZlWwt82WkiVjC9tPh5OP3m6xsn+7YROsJJkU4llmQXuWLKoxR4TNSwdgw5CCCOJarG+vURs7d5lmQJdaKAjOBACV9rGnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742215587; c=relaxed/simple;
	bh=fKG4bB0Fg/21DNCp76MIS0i+qesLHwzj2V5+ncQhPOs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=m5t110A4MwXmzc8k+l5HogdOrEuK6/QGVD7HVukT/nA0Fyz5PmsByDq4RQVR9xl5wpRZaNYfN00JvKX6miDsr7As6trqsQWezRuHv6iR2AJ2hbVXLIh2mRxORLFxm1F5to2zqsaoLb2wVoeSufgM+lFtpc9TiqB6TTWkuF40RvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=pR2/A9jE; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="pR2/A9jE"
Message-ID: <82d3130e3356b9250fe7c10ff3c36a32@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1742215578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GNIgbpauE5Lxn5ls4Oav5uyWlHp1qUCNTsBSjn+xEk=;
	b=pR2/A9jExJKMr11ju2TsajoVyDCOq+EjoUIj6DxJbLOduIrClymy6pshSIbE6M2jESs7dn
	IgTn2xRmNh788xn8ogBgydBr3WeRlILtJx7SXueJG9T4F7E9w8PJMj1Age6sNQGcUWZ7oY
	UdlbWzXLU4I5xFjA4WnlpGGvPInI6tdeP41a7oXZEGFmTfgq171Q175nP0Cceg/h8Izu+e
	GVJ2kAnBJDsAhOcUzaGee1k6lxep4NFu4h68Ulz7GCJHsyOX9me/kp58LLqJVMRPGCzvpj
	w2WwNSNvSzT2odYarh569/dlrwQIb6DfswOE2pD9hkysCVRTfdcgPivIeMwdlQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Adam Williamson
 <awilliam@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix regression with guest option
In-Reply-To: <CAFTVevVmp7f5Mv7CZhKhV9287ev0Wf9=7d3qakS6BNs2b4wayA@mail.gmail.com>
References: <20250312135131.628756-1-pc@manguebit.com>
 <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
 <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com>
 <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
 <9ef1d7140c93877011e7ca5fdcd13ec4@manguebit.com>
 <CAFTVevVmp7f5Mv7CZhKhV9287ev0Wf9=7d3qakS6BNs2b4wayA@mail.gmail.com>
Date: Mon, 17 Mar 2025 09:46:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Meetakshi Setiya <meetakshisetiyaoss@gmail.com> writes:

> Thanks Paulo, created a PR for cifs-utils based on your suggestion
> https://github.com/smfrench/smb3-utils/pull/14

LGTM.  Thanks!
