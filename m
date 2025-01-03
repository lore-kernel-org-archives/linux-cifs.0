Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872921BC9E6
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jan 2025 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735943565; cv=none; b=I0Is6Rb4/AMAod9r1SbA7/Mf56t51FBORNIGKyhEFnQJCDuNhVNZaAflzCwM3YC+gQj5j0Wg59QM9L2eRhWUJGzEu6+Tfgc2+obOgPgGfHlZJJZYmMr6L7F+YY6944BlUuYU7uhTQlVuuoW1ltMzvRzFHHj74Nv1VrfPKvWdj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735943565; c=relaxed/simple;
	bh=eWoXjFGqhqSCsBGkDECNclrej3ZAoypPI5Un/o3XM4k=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=FTvd5/UGOn7YF36quRL8D3IdnyqJq1aEh0U3d+vEAHnFpX4xI9clQRHVV2ltms/cKvwnvNG/xI7NXi12uQMdllBtwbgJVeBH9WWWwJZZ+HL4ZTWOfWWN8M69addJZpuVRWUs/wADAfXND67IcnAooQxnYQ4sR1a7YfVt3XM738M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fs92lHS7; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fs92lHS7"
Message-ID: <311888e014bc82d449c939875f751d5b@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1735943562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpOdXyuGus1+cCxmZ1P/uaGywLocUkVUWVzGiI7BmnY=;
	b=fs92lHS7mqLws0DdaXNBJqUoGA5CB70q5Id3Czfv2WABzjEkw+6gPn539UwDiRE0zslDi0
	Ej5djizEfmR/ZdrWmhhMGSuu9cgxZ6QCEQOIN9jBQNwaR1KSqLKbNp3DjnAQZ22k1JRtcX
	qXX8RY5CMElacKuIIXBtXV0eLf0GGdmReAUcC0jT8BuyIOUPEYh6CSfKDDXm4qJWv8ItTr
	Y9z2ESO0qdzGIZcTBriqt0VAXG38+P0WhRCkZ8wfzYBEbA+vhlZ8sFT5Pc3r30aKwLTsa0
	Yb15qCVZ10/dB+U71pYA+KyNrGzs/ZcyDM/hMOREjhNdjJXBJcD2zmOBlBFLag==
From: Paulo Alcantara <pc@manguebit.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 4/4] smb: client: parse DNS domain name from domain= option
In-Reply-To: <20250103222534.86744-4-pc@manguebit.com>
References: <20250103222534.86744-1-pc@manguebit.com>
 <20250103222534.86744-4-pc@manguebit.com>
Date: Fri, 03 Jan 2025 19:32:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> If the user specified a DNS domain name in domain= mount option, then
> use it instead of parsing it in NTLMSSP CHALLENGE_MESSAGE message.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/connect.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)

Please ignore this patch.  Resent the series [1].

[1] https://lore.kernel.org/r/20250103222858.87176-1-pc@manguebit.com
