Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED182395274;
	Thu, 26 Feb 2026 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772142076; cv=none; b=m2ic1Auh1B0ID3nIwqH/rFOiY2lObyWZKtGlYqoeVYr25F3PB/HlkiQS0RuE7T3nWwVI5n5apYHQm/2IZsyovCDgrBcS1NJcCu74/xn4sSskOrUjsLEcBqFPDusGbR2WzgPDqxI+8OfUda6dGQnzMmaL7tNme33JQEwiP6Mf0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772142076; c=relaxed/simple;
	bh=bjrQY/5YEHkk932/5+YfzU0/mm4cX89YjtImf6JCcTY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=KqqBMrS9n6cuSbbPCyfQjDRaQ12Gqby+7CtGogM275FutuiSPMlmw/kZPpj9kihX+KlplWUxgWaY0tTvrbk+IxhcAIhVNK0ar4QqRsOD69wX9RP2t9eSDJgA14+H/nh7Xldf/Q0C0IRSiWK7D2YHIjHFALyMqWYw4miWIqnTu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=C8lgxWNg; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="C8lgxWNg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Sj9a7yvXPZTsexmNw13k08Y6XmT9sbAg3WMWHrD1uuw=; b=C8lgxWNgIevTw8/MgOLsJ7NfEn
	YFgYXI5naYlPUV42o7wFB3UThCx8zGDrCWAlAilv4dwAjR0DKHwmU26azIE/O9axjkhSmpzVH8jWR
	f0ixW5s2JIt7VW2T9RI7nEvnI2kKVaLAmewiAd/gqh+5YAal+5TZk21s4G3vL6Oh04IYBLhjGo+RL
	qgXJs1jbuo27/Sam6NnkCT4iwuiycZ6VrQelwIQAXZCIns47dtva6J/AUr3thnAtsvSES8MRVgQk1
	eOT1347hmV2VJVThl++jJQzFVVHfWkxeC6ZqUQnXAl9dvDfAvaToqg2q8DaYbvV+SgiqLlhCZt3b4
	bHMoh/Vw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vvj6b-00000000tP2-3cV1;
	Thu, 26 Feb 2026 18:41:09 -0300
Message-ID: <03d69afbe9fa3ec36dc39d6864a97b35@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Thorsten Blum <thorsten.blum@linux.dev>, Steve French
 <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Jeff Layton <jlayton@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, stable@vger.kernel.org, Steve
 French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: Don't log plaintext credentials in
 cifs_set_cifscreds
In-Reply-To: <20260226212845.784172-2-thorsten.blum@linux.dev>
References: <20260226212845.784172-2-thorsten.blum@linux.dev>
Date: Thu, 26 Feb 2026 18:41:09 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thorsten Blum <thorsten.blum@linux.dev> writes:

> When debug logging is enabled, cifs_set_cifscreds() logs the key
> payload and exposes the plaintext username and password. Remove the
> debug log to avoid exposing credentials.
>
> Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/client/connect.c | 1 -
>  1 file changed, 1 deletion(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
