Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9015ADA6
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 22:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732314110; cv=fail; b=tvGv/VQbpWLQFLZbrZV71Vh7/VmeBnGPYE5ZaS+yt1ESHwKenL6ycvZxZH45kBYRFCpwcBYgMq10ouOo53A3d3aPE8knn4UYrE+q7smQz5Po2zEakF2WAXQZtpbQYSZ7j6lyHol93wWQF/fmtYFhuDjxPf6URjkvBL6m6JYRmes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732314110; c=relaxed/simple;
	bh=0e7Dzr+G+C1x0Dgw1WiFKU75LJeAve35EOu/WIEsNAU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=llNcg5k8pUAz0Qs37XM7wycezPdqJ+QCkyo0PtSyDpIUM8VkGzHujL+bAcTblti3YAgoaMCQjlXC4aq57quRZlbpWniAMBluwb1p0UN4oL9seChnY34hHU5JdAsuOi+yZHoxebFygKAZrnN2dQJFINEI3559B/sx3BpjiyQ8z0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ZSpR5NTR; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ZSpR5NTR"
Message-ID: <fcd13231517c600d7750ee0c9c8e5125@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732314106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gtDQ2cY4uveDpZ7UndvFafuvAhOWfE7RSij3yZCIoBo=;
	b=ZSpR5NTRyrUiw0RkCWMa5yQMnp3TFlh8ytUO80sf098JV8hoT82asTws+JUdB3L7/+eFrL
	7N3HWiwDNWcP0ld7ehGwHZosoAlSrRvJrrxVvuruhQN4E24cbc2AEhIl27hS5jQJzaBwae
	GbKUOCOYUr8l787DFQWRfXIIhuqfN1v/RZFn1Ky4opJzhfMsVRCyatFtBgr02q7HubRN8b
	QtgPBp82fYsZK7EX1sNTjoTu9xiWgv4owkajTqbUyuTjQ1QFFXT6YKMuvzV0OcQ6FdifSd
	lCxIQo72byOy9ZvkEvxsVCORzLsSjJ4qi4lDTHtstRR+xQWQLpU9LrbUAO76KQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1732314106; a=rsa-sha256;
	cv=none;
	b=JK9p3wyZVmL0PRDWAGavcdBHjrYJyZ+XVHKdPomviEHGv6Ckffcu5jgWgGysh7CytYIypC
	DNoap+HxEKBX4ymIMjkF7DPLWV4THRIn+chpDWcQhuYmexlzGtYk8+5QnkRkj5HKQO84VI
	iqOglfdhsP8ScRgirbqRgRjK36WaicqsK9A0Rf97rXNCGWDaYRWsN436Aqv0aSOEZdofhA
	DDgjxw1ltPxOx87GulpI7C6PRMzFsUwd8XZBN1skwlNFOjHObVKTqjGnSIkNPDPgMs+yO4
	dlWFcpnnu32RD6uGLA25JG+pNzDRAXDZtrRBqsF4zdNDuWO9qEAjJtPEPVRtbA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732314106; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtDQ2cY4uveDpZ7UndvFafuvAhOWfE7RSij3yZCIoBo=;
	b=cKiTc5gApD65s62dwZhjd1hNGTNkLkGBC5BRnvX66HbUmpo4QstUzJDLHp1emTFk5Ck5sB
	zabT22Kynts/6w0+uhh2q4bW01noz8CITXBVBrYwjaJaowh/eEaCgbWwPbsYROplI85vpN
	hfJAk4ZNJbGFXWnDIvHKsNfjA6WRIjSiCm5/7iUj1S3nVj/H9WAtZNgZxBtOk2LH8X6pA4
	5SbxaxmJ8m5TXb8OH9LOxS5WtTbPBMpUFXAwSRI1wYegJ/2VMJQzYvHs9GCZdiFshzjf8p
	HDzpLYektjucMEX7JddXxDzA9hU5tBWGqhGfNpMAxqDJFC6gC0nxLSWwGlir/Q==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: ematsumiya@suse.de, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 Henrique Carvalho <henrique.carvalho@suse.com>
Subject: Re: [PATCH 2/2] smb: client: remove unnecessary NULL check in
 open_cached_dir_by_dentry()
In-Reply-To: <20241122203901.283703-2-henrique.carvalho@suse.com>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <20241122203901.283703-2-henrique.carvalho@suse.com>
Date: Fri, 22 Nov 2024 19:21:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> The function open_cached_dir_by_dentry() is only called by
> cifs_dentry_needs_reval(), and it always passes dentry->d_parent as the
> argument to dentry.
>
> Since dentry->d_parent cannot be NULL, the check for dentry == NULL
> is unnecessary and can be removed.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cached_dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good,

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
