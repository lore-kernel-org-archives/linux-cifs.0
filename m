Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653504432F5
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 23:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503999; cv=none; b=KBTuQGwolgISB9Skt9e/3zNFTn3QqjsTLb3sFJUr/lRTqFRUYnHTmDq8EAicJXqsvuj5cX48bLkfXm8TNFy0nI540K3UX27LwOxTVeAcl599sweAGjfhj7iZXz6AfHqHtexxL2JrnWwONqPORFA34RjZaUiPKS6Ms6uwVNuG9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503999; c=relaxed/simple;
	bh=3dfL9vEsYa5V/371N7xaIOki/ZQm27I3Z7M7tgzu9S4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=iAViIM4RvKrp8lX/qJcpVNFnqC+iRAljnvx89HNY4WNAXkftzXDxjQSCr2rfpmSjl59NE6T48AfZNVakkJasnE343E+HQ1mcTYtpV+Z1Ls86TRaoeO/R2sLB9+mDMIOIG55q22Nprohj/ZXep8X/9Nsr70vihtTGFEuTvLvTCFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=wI5paPcN; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="wI5paPcN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xvCx91FfC34uGLQvuXtrLtDjSEcXRbJg7fI+ATMiUxI=; b=wI5paPcNJi+IIb2efEcuUNpS4y
	QJn7SRELS2KgWmUl6QNJVHPmpyNhLxhDXUHSQUPDaciQwm6n+cJrfqlWJqsDgU+8ihzZO8i/udJXx
	WqfnM23gpR2qggBJN8c1piKOEiDGc0ZbkvF/IHTemzn1a39LMjfQlQ3g/jGzj2M1pw+715OsK0G1x
	Zkmsl+aDJ8CfCdY4aUUU7b5E1frjA3uPFDbAw7OrIMzCPViNnujAeHQKfi/he+8m8GFUCHIO+Fgdt
	1cdgB0vX/lrXT6bBAxEpXxke2NDZ78yNpLsInZk0MDqaYM25TE1Vnhh5Tdn2g8Ri0MHkUc2cdAgHC
	pDmo9aFg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEy1b-00000003DaK-1cXE;
	Thu, 08 Oct 2026 20:59:47 -0300
Message-ID: <b700cec95bb7ffdbd7b7a2f78a70d9c9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com, Enzo
 Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH v4 1/2] smb: client: fast fail sends if need to reconnect
In-Reply-To: <20261008182609.2208508-1-ematsumiya@suse.de>
References: <20261008182609.2208508-1-ematsumiya@suse.de>
Date: Thu, 08 Oct 2026 20:59:46 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> smb_send_kvec() keeps retrying when server needs to reconnect, which
> makes no sense as cifs_reconnect() will never run in parallel (because
> both need server mutex).
> IOW, retrying will never succeed, but only delay reconnects further.
>
> Bail out early from smb_send_kvec() when need to reconnect.
>
> Also shutdown socket queues when CifsNeedReconnect is first detected,
> so any sends/receives fails immediately (and don't wait for socket to
> timeout).
>
> Add TCP_Server_Info::need_sock_shutdown to ensure socket is shutdown
> only once -- even though socket/TCP API will prevent multiple shutdowns,
> we need to prevent, from cifs side, concurrent tasks from accidentally
> shutting down the socket again in case cifs_reconnect() is successful.
>
> kernel_sock_shutdown() will be called from whichever task detects it
> first;  cifsd (cifs_tcp_ses_needs_reconnect()), or sending tasks,
> through cifs_call_async() or compound_send_recv().
> ...

Applied.
