Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07845A2BC;
	Fri, 11 Sep 2026 21:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789160503; cv=none; b=R6/CqWpXFlCmWFrzRFixyLNF4gZTlJzi6weTdPcejy5V8VG/PvZMKANfveLtdgEQ0JIET/Zxl9LD1snkHQO3YAmt8Tx6MGKHO+uHBH0XNSAWELoix4KE9nzUgCUDuoHO6chIgsvA6iksR6zn55PagVVOSOCV3HoeCcwOBSbugRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789160503; c=relaxed/simple;
	bh=eXQ768PlcEiR8FufbLDybpAOhCs6pN2hAvpYtcc1YsE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=sWf+T0J6jdMvGRmhukiU9GBYty+XzPwzCZtkob4KebN+jEJJoz5JHbI295ZC2/16cJ4yVKX0vnL5ACjrrsWfRTdDGEMSGPydcXPhnKjg+BuZBUNvkEZhti17a+mRCnACGPVHLW0DQFVtI6S5jM4EzaP3pnWKjM9cEOOqTFhQDfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=lJt+5mbj; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="lJt+5mbj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U7JVJfmnGb9C9LzwHXhPTT8coOGAHU/ighbNR4pt5Ng=; b=lJt+5mbjx3lzGvnvLQHhD8907P
	OeqafLRuoCvbXeEu54omuZAax0sHP5S7FINZOOeFEZfp5iIuQN4wA35tBylTXBdhQ7MNk+2hxlB7G
	nulwvat5ZMHoZ4E2yb2Hh74QpRBPgcKyx246Ea67iINYsALOwJS6S84w4xCc1leYpxRKXNUVmQHoP
	ojMF6womEFU8TsPY5NvObeAHDe1C9fV1vOYx9nBU3YqtYb2EtcjVYXdJz1FMMqk3zxS1wB58wW5tr
	/v5MqiMS9meY8XNpm2epZDtZHgRcaKiH6+nENeT5i9yoVLfs+sFo/YxHaVevdcndS7PtCyAvuU5zz
	SA7671ZQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x58NP-00000001F6t-2XXg;
	Fri, 11 Sep 2026 18:01:39 -0300
Message-ID: <7499c045fa340a8e11d1fa0e662ad0b2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix rlist race and missing initialization
In-Reply-To: <20260911204446.1719356-1-pc@manguebit.org>
References: <20260911204446.1719356-1-pc@manguebit.org>
Date: Fri, 11 Sep 2026 18:01:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
> and ->prev to NULL instead of pointing to itself, making list_empty()
> always return false and list_add() dereference a NULL ->prev pointer.
>
> Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
> from multiple cifsd threads, allowing the same server's rlist node to
> be added twice into the local list, corrupting it.
>
> Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecting channels")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org

Please ignore it.  Sashiko found out a potential issue with this patch.

I'll rework it and then post v2 soon.
