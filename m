Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183B13515D3;
	Sun, 20 Sep 2026 04:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789878746; cv=none; b=Zf4oyFoTy9u6uyi3yp37piP9Cs1SCytE1ogi3c1Soq6ibdZyahQChWXndotGJSDxGxbEDXhc7S18Mg4xvxy2jHZj0PKxwCJy0b6SBfdoq/PJXcSGQl3Iu0BEFVFj+uaVzT6slOa7BkGObed/jNDZuoU+i0YjelxlbsqiEHu1upY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789878746; c=relaxed/simple;
	bh=LwGbH9Hx62Igu4E1fvtx+x6LAzFAWeu3zK1oiO71JW4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=krLYLXGFJdgX6h6iXaG8ILkYVA3pIpJ+vXSltJXF8XtaT9RdmvVurj0E8fWUzhjPCr0lnZHTDPwzgfrRpRiYq5ynroQYuE+XTYDwfc64JfznnCPowOxIqPtFF4CT/J1fgceMOWYffkrt8bouoBnQ8fIhC6Lz0WvLWlpV/2r/CfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hACjv9ch; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hACjv9ch"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LwGbH9Hx62Igu4E1fvtx+x6LAzFAWeu3zK1oiO71JW4=; b=hACjv9chCaA95yRLjD3OkRDQMj
	Wi1i0QTW3cSlBJvFffyf00WsipnJPXSnp9FGUlxCDpVP5jl8PLWu2NHffpJ1ojU/rOKDp9WMVUv7R
	WmaoAzZ+6n/x7F5ec2TPBvbWp4PFqB6x/qqPyvbVB9o0X5fM7aFCPp6uHvcv1oCBgTRRDUvwG/LC/
	CFaxzRmvXXtnKOTMO9GKFGs8YnybpIcVlQVKqacg1+MnXaIksbor+6PBpDPraqUwojSdlnLmrH4QE
	xgkiID/c+Kc7Jf4i2vcNRIIYY1R5esQ/8mX1J6rjcq26lUCJN2uxS51d4Act1ZXOppx2nhuiJeXaN
	oOjYvXrA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x89Dv-00000001pt0-043q;
	Sun, 20 Sep 2026 01:32:19 -0300
Message-ID: <1eee53f322920725d796cc45d7402623@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Adarsh Das <adarshdas950@gmail.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Adarsh Das <adarshdas950@gmail.com>,
 syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Subject: Re: [PATCH] smb: client: delete compound mids on send failure
 before unlock
In-Reply-To: <20260919105732.3041-1-adarshdas950@gmail.com>
References: <20260919105732.3041-1-adarshdas950@gmail.com>
Date: Sun, 20 Sep 2026 01:32:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Adarsh Das <adarshdas950@gmail.com> writes:

> When sending a compound request fails, smb_send_rqst() kicks off a
> reconnect. compound_send_recv() still has those mids on pending_mid_q,
> but it unlocks the server without removing them first.
>
> During reconnect, cifs_abort_connection() walks pending_mid_q and runs
> each mid callback. With no response yet, those callbacks return credits
> and drop in_flight. Then compound_send_recv()'s send-error path returns
> the same credits again. in_flight ends up decremented twice and
> smb2_add_credits() WARNs.
>
> syzbot hits this during SMB2_negotiate when the socket send fails.
>
> cifs_call_async() already calls delete_mid() before unlock on send
> failure. Do the same for compound chains and set cancelled_mid[] so the
> out: path does not delete them again.
> ...

Applied.
