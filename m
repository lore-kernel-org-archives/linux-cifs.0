Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2694047F2C6;
	Thu, 17 Sep 2026 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685343; cv=none; b=ZABFj80epDM0M6/q9BfwyYAXkgrkXPfqDP8G/NF/hqCy8gdQr/ZM+Qpvao4rs3krPVBKCF4L08lCXL40msRNZb80xysaNMVzXXYzJmgLHOEG0E7Wm5WIYmVzC0BDWM0w38kOi/xpSHpWt5Jw/7jW+pL3WmjrjQDhBdIaHFxhz24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685343; c=relaxed/simple;
	bh=cSv40zDCjUa6QLT0PGB7Irub/S8I7AeCF7NrtGbjeSs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=KRVKgi+DNmGKXf2hzsv920Sp19aOOWuE0qAvpIJqKr5v8ASvXGE/8JrCdgKokPQLB8ES5nfJdMmDXRJDoxnA6OdH4lRaKTawRepVYTKGQnAENuKg2Jvu2USYflMRbUCkRARgHJhJdT7eNmPeCj/5jMz/BHly4/lgfzeDxs1y+ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=X4YfLKac; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="X4YfLKac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cSv40zDCjUa6QLT0PGB7Irub/S8I7AeCF7NrtGbjeSs=; b=X4YfLKac+dzSzc5vDQkuBEH4eN
	2xHiblTQ/oYL3zPbIRqZlFx7FVxp2PiTiMUfyFVe7Q6sc+h0J+SjlCqac5erAseFy7RtioSaV4HzD
	3DzPj0kYWPmpO3dtPt0adv6RofItZ3ZbtAuqt8Bk8bHW1b6wHzHDp5YH6bqTHc8pVSpErYO2UOXVc
	m7IrZKEioyO/00OJqZ0SkcNTcBDmyNHuKLZteSbYh9I78CRBnV2QlvRyPKf4UYL361r2dRQb7Aulh
	+1DHMPIXATs8Br9fNuHejVGbHSmYMLAah3Fq7Bnoou+daOMn2PoZpn2MVocOIqYJuzvoE0eb8izAb
	U+jte1BA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x7KuV-00000001guf-3dzV;
	Thu, 17 Sep 2026 19:48:55 -0300
Message-ID: <9a0ffb5299163f5865eb8a805bddf4d6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Wentao Liang <vulab@iscas.ac.cn>, bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ronniesahlberg@gmail.com, samba-technical@lists.samba.org,
 sfrench@samba.org, sprasad@microsoft.com, tom@talpey.com, Wentao Liang
 <vulab@iscas.ac.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix server use-after-free in
 cifs_chan_skip_or_disable()
In-Reply-To: <20260917163439.2162539-1-vulab@iscas.ac.cn>
References: <20260917163439.2162539-1-vulab@iscas.ac.cn>
Date: Thu, 17 Sep 2026 19:48:55 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wentao Liang <vulab@iscas.ac.cn> writes:

> When a secondary channel is no longer supported by the server,
> cifs_chan_skip_or_disable() drops the channel reference with
> cifs_put_tcp_session() and then continues to use the server pointer by
> calling cifs_signal_cifsd_for_reconnect() on it and reading its
> primary_server pointer. cifs_put_tcp_session() can drop the last
> reference of the channel and tear it down, so both the channel and the
> primary server (whose reference is also dropped by
> cifs_put_tcp_session()) can be freed before they are signaled for
> reconnect.
>
> Signal the channel and the primary server and capture the primary
> server pointer before dropping the channel reference with
> cifs_put_tcp_session().
> ...

Applied.
