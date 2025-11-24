Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6502BDC17
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764017793; cv=none; b=fGjBjYUUKKt0pHyvJB8MDWt6i5ZQH8g1/EDNQ5VnO0b31ab2dNLNYvaE/jftyZeZo2taGBx9zthnpLNkGRaJCnIhweb9TOJg+4/1ecUHTgF3uOnwv1OVJ5kama5nu71ezeQq7yM20FNqzV8TGcI4NY9Z9w47bCFlGCdVMKM2U94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764017793; c=relaxed/simple;
	bh=sqhw56bfFziAwf+zdyG2o6z0GBBBoX+RmhhZ7co75xA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NzalHHNHc7Q0WD2HSX5CLW3488Cs3xUUyo/+UeQ3q708q8A9d/3tnNNqJQUwNvlj0qnwrgLVOLklw6Z9YJMjW0iJ5dTPIxo9BLZGdpqs5G9VgnGY2/pFmQeuEEF/qQvg1IQhm7H3mkwo8FYUnoB/QaHqtagGpghk8s6wFgpt5M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=zRf00BbS; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="zRf00BbS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DzDaUiVAAH5BpoPNE9sTsPVTxgdbZhqrjVpE7NI2Pw4=; b=zRf00BbS0KJnh0SpRYhNJ3LLrV
	l3CoUu9jGvxNl5bUm5skRBhks/F1W4eEv4MYK7A+uFMGk0JIxUeQ7nV4HKij/naL2jXHfqhoUTn1l
	/1sJ98tCNPStU/GmiRhfh2+iQXPxL+pRMDdp0BCi9hmmq+aU+sxkk/u0FIcRB2qvAHc8mSyzddqCu
	ah61Wn5HPwn+8oRf3nYOkUApIA4vCMJuqxSD2raNgex7ee10uSPvmnR6uUHyo4C9fErXJGrtfY2nf
	o33BdbkuzbzqoBX4uJStaUaulJl9NBE6PBAitdpNcp2v0FgELI5xQ2J8I9XikVTfJ0IhNip5a1Jty
	Cn+Fvz6g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vNdbm-00000000R50-06ZM;
	Mon, 24 Nov 2025 17:56:27 -0300
Message-ID: <a5d65f2d2e7cb45bd47317b726f86568@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: metze@samba.org, Steve French <smfrench@gmail.com>, Tom Talpey
 <tom@talpey.com>, Long Li <longli@microsoft.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Subject: Re: [PATCH 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
In-Reply-To: <cover.1764016346.git.metze@samba.org>
References: <cover.1764016346.git.metze@samba.org>
Date: Mon, 24 Nov 2025 17:56:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> writes:

> The patches should relax the checks if an error happened before,
> they are intended for 6.18 final, as far as I can see the
> problem was introduced during the 6.18 cycle only.

Since we're late in the v6.18 cycle, I would suggest leave all this
churn (e.g. adding new helpers) for v6.19 and then provide a simple fix
for the problem instead.  This way it will get a higher chance to be
merged in next -rc.
