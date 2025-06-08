Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F29D6A33B;
	Sun,  8 Jun 2025 20:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749416260; cv=none; b=m6PtDCQrQ3JWFpAPnEX4w+ZClIbOfwc5cY3gKvws/t7RsXY2tg05ILQ52GRinOdpzxWQ4GEc1gdqz9EpYthUEVpkLMc4B8XyvpFv5QDG0UyCE6xEwQoJFLm/kKA8HqCG0x0XU3sNY0WbzEouVxxh/ISImY39jApIIVhHo4xxS7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749416260; c=relaxed/simple;
	bh=u2MZw3pClp1MRW4Nbk+nGm7LeEO/N3yqnbXgFKwLz+s=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=hkLbD1qFK7N8SiIfr/X8F0sHdJUtR8l6Ho/4jJj5nTQCs6fjoN7ZJ5IujRPUdWWjSgRTkTAEPb1swz9qO711LXPG2b2J7dYd9fS7FSpNdnEeLWRb/Pe4u5w7luZkLC4CmV4ldBEx0fXbGiVml1gENma/48VLLyyIDoxTsnkJPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=zSzv/iJd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="zSzv/iJd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Dq43dfN04jWbyKmSP11Ig+96MG5IrJm0+KB2nuqj4d0=; b=zSzv/iJdIAdNKK/d4QszXETQea
	3aX+cdBG8sza99Ay2BBfs5+r3sy2Acarjqn5koSnvpEymlft6g3wmabLgFN2BRSijElTzzHJIExY8
	G9aMcRjtNMFZf1j+DzF3MJDZsXi3Rvk0+iDZQz3I2aI8b5ADkSYFz8i7eMY6WSpP5OVEcT9Vt7M7d
	Hrl85BFo8ELwmx5nA0D/Y2NEu7Kcb18TpCwPmI9mAjj/tBtaJTr1iNG2ntmxpm8N1yzthiBPhad6/
	aMG114VTBFwtEY//M7Jh4Wd6e1fiNYWAg0rCgDde+OHZ+0j6qzbpnxh98oTkaWkiXpwV1sBx7P1sl
	QVjBXpgw==;
Authentication-Results: mx1.manguebit.org;
	iprev=fail smtp.remote-ip=143.255.12.172;
	auth=pass (LOGIN) smtp.auth=pc;
	dmarc=skipped
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uON5A-00000000500-374B;
	Sun, 08 Jun 2025 17:57:34 -0300
Message-ID: <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
In-Reply-To: <20250608164453.6699-1-pali@kernel.org>
References: <20250608164453.6699-1-pali@kernel.org>
Date: Sun, 08 Jun 2025 17:57:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: 1.1 (+)

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Before calling cifs_autodisable_serverino() function, show reason why it
> has to be called.
>
> This change allows to debug issues why cifs.ko decide to turn off server
> inode number support and hence disable support for detection of hardlinks.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/connect.c   | 2 ++
>  fs/smb/client/dfs_cache.c | 2 ++
>  fs/smb/client/inode.c     | 3 +++
>  fs/smb/client/readdir.c   | 3 +++
>  4 files changed, 10 insertions(+)

NACK.
