Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C1842EEDF;
	Fri, 27 Feb 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772204594; cv=none; b=tZEJH9zPTxTV4dsohTAmQvle3UjDqFU5s/f2/hOOTyg8VzVBL59e66R175B2zizTqojo3ZeZUTQrkE3+KjqZZl+OD2yvyLaFcM00vs2vnffQ7ieAEMCT/xHwghHVWdZSoK/mdI+aYycxNqnTGMdrR2Eialp/wwFaKYNHmZ/d8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772204594; c=relaxed/simple;
	bh=YiAtO/x8uiVH8bacHya4O3OaXPXfPIjBtyCptbb9DnM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Cu8wVYe/RmVtS+YrLESW1Em6bR+URAA0FAAhZNDZ5Vu81XqhLIfec116w+GCUmW2ihrmfb9ZKFGw/lVRNok2xzNk9ULX3VNUFf3VCaKknP5+Gz7HsRcWvJ5N+yPXnMJtwMOwMuCZw4YCmj6v2gMwBTvxAKjYZKtsu0HPATUSaYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=0PJT4aRF; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="0PJT4aRF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uwQBlM0B4ycxktmb2urmXhx9yD5hlvk1f/Uk1iHjtf0=; b=0PJT4aRFw6OYsAuYJ1FmLx+m6q
	o9ZBBGRn+ADxvFNjJhFDxD9efJvswMhbVFVSWA/wcNFDKWzTs2o7AgNiOLwD391zNVJAbDL3e7x5V
	oHxn+8+oQ2vgB6lGXKsIHhztWPoehX0kkJwEBrhN1tNeKzRoYEOsLDvDEOhRLgngXVdz0A3vjYzQA
	3Fr9uT2JX0UxGbD4HC540QvjU7AJSiiTpeTs3E0j/qU1IJC3mP1Tbinha4jHMQfzc8cw2mNcl1b1o
	QCJIi6bTpCh58WLVq0uOC3cq3FKP6lfvz3ephJ3HT6Iin4c9QDJFbNX0CZegXTaPkNulyUhb6kFln
	vie/MMhg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vvzMr-00000000wOO-0ory;
	Fri, 27 Feb 2026 12:03:01 -0300
Message-ID: <be77b89f71b05754469c8e6945e907bc@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Thorsten Blum <thorsten.blum@linux.dev>, Steve French
 <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: Use snprintf in cifs_set_cifscreds
In-Reply-To: <20260226221522.796394-2-thorsten.blum@linux.dev>
References: <20260226221522.796394-2-thorsten.blum@linux.dev>
Date: Fri, 27 Feb 2026 12:03:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thorsten Blum <thorsten.blum@linux.dev> writes:

> Replace unbounded sprintf() calls with the safer snprintf(). Avoid using
> magic numbers and use strlen() to calculate the key descriptor buffer
> size. Save the size in a local variable and reuse it for the bounded
> snprintf() calls. Remove CIFSCREDS_DESC_SIZE.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/client/connect.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
