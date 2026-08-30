Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730E770808
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788123412; cv=none; b=FJQCcCahm3x7zSIODU/ULok9MPqhnKvp/ZuF2zCZ5vfJihaTWTFkucokVZmi8G32lXQrTQdu3qq2Id85HlZvlf3xoo1+xyM3yQHSd7CB3I+x+7bF9HDfKx9EKjLTCKf2+7ptbF7eYXouHbaV0LDDnEA5Pl5y2XfOalSdVNp2bzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788123412; c=relaxed/simple;
	bh=RrKzt59JGKF94P48bf33E7+fiF5P1DpXJS9YOsBbHUE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=OvhvEa9BZ39z0SewEakcX7BbmL80rwvXSX1WEnW5RMkGHe+4hT+MsFS/Pmw7T0FnUOpZFlvyk5w+6tKQX7uv4AVoWRgLiECWH0nvFaI3JoUQfWK2b5HO8okorVvE1u0QveJ0hIwCcEkRFB3JXk8Ty2bsgUJ0Ne4DX0qEFR3KTTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=haVIVfWB; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="haVIVfWB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RrKzt59JGKF94P48bf33E7+fiF5P1DpXJS9YOsBbHUE=; b=haVIVfWBdxIiHYAnfXEExlcLfi
	8krGY0nywwdZ3slcJU/4IGwxsqlYjRv/U264CQb9iA1m/knS5883GCTBIS44APWAlnCmcBaWID//U
	3VAMlSnIi4ObpkbDW19ESYalwKVyRiVOgENauuLcrmuJXQr5VCU6my0b5S66IN7RSxwsxzXHzteHY
	1PRDIDKvmZYHuOCZ+Pmr7poHwnqIpc1uEk2Kq0t//HzQxVjrAMSJyS5Bc4CUZWKKXwy6JxqZ1fGXK
	RnH0Sre30DV/S8Z0t2m3Wl8ExCQe03WH5Ovx8J7h/h8qBXBTsiBymdofXyqMElZbWM8ItzztG2JRm
	5Z8yVEYA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x0mZy-00000000I3W-29RP;
	Sun, 30 Aug 2026 17:56:38 -0300
Message-ID: <3295d5af704d274d37b08d8e59fb7449@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] smb/client: fix fallocate range operation issues
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
Date: Sun, 30 Aug 2026 17:56:38 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> This series fixes several issues in SMB3 fallocate range operations,
> including insert range, collapse range, zero range, and punch hole.
> ...

Applied.
