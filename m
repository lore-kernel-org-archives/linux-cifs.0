Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D418DB1A
	for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257871; cv=none; b=BwF4RUV1+U2+yLtW6oo1wVIqnpWiXhrUCO69ssdGodypK0DNIRbwyrD5JfoIWxNH+lCDM7mUVw4b3scFQO+VkO8L2CpfZM+uuJOgtAaufh5WLO+cBL08OW5iKV3JmGnHnNcIwygXUBYt7emSztYuPdEBlUjJN8DI5WNbHvz55jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257871; c=relaxed/simple;
	bh=9bjvi+DtNN/Di7TA0B915pYv76qPLZo1AIqrQms2Djg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=rRqBclxL5oBSXWE6nXabPpgUIRM7y7Rfy+igxdEynTFs+mnR0l0ldHOP7WAyu1SmpC5Xvk/3sB6HSvfVpQsbqoSnbq3cyUkwTR/QBmlb93N+CmFI9wAl1zLQOGMM+w8uF+oFkbsJMIG6psW3s8qQCnLQUelodkZxYRnzcU1xmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7JUBSLnu; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7JUBSLnu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9bjvi+DtNN/Di7TA0B915pYv76qPLZo1AIqrQms2Djg=; b=7JUBSLnurpL3yglEzdCXHge4NE
	4K4B2Ip/GxRIgiSOu0GVcgRJDKdbxMZ/7P0T2TZq9HfYxNeVxOQKrdRPLCP9eLfJGlXE89TpLXHdg
	1AolvdyFW7HX4xfK44hcPu2YxMAdMcU18nUpqooHAotPnTF0/LYxTGEcDcFq8TNW9agdtmn3EW24A
	/chFI7lAWWkc0//hQ+E9pAs6NR4DslsBKoJj55JHiJDkyAUFjxaYfmnCzDaTajXjHPKQlSY/iThcd
	cStdb4nj5su9V6NubcPZtO0tpP2ogZJ7+J7gLuIcgrYYmBYe1M85e3WYfh56L5x6IjFlA2zFEk2Y9
	CmL7BO4A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9jqt-00000002C2N-3jbS;
	Thu, 24 Sep 2026 10:51:07 -0300
Message-ID: <6bff25748d26b4327eed7db64c6c117a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com, tom@talpey.com, Namjae Jeon
 <linkinjeon@kernel.org>
Subject: Re: [PATCH] cifs: use finish_no_open() for non-regular inodes
In-Reply-To: <20260923112549.21294-1-linkinjeon@kernel.org>
References: <20260923112549.21294-1-linkinjeon@kernel.org>
Date: Thu, 24 Sep 2026 10:51:07 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Namjae Jeon <linkinjeon@kernel.org> writes:

> An O_CREAT open can find an existing symlink or another non-regular
> inode. cifs_atomic_open() calls finish_open() on it and attaches a
> cifsFileInfo. Symlink inodes have no CIFS release operation, so the
> dentry reference held by cifsFileInfo is leaked. FMODE_OPENED also
> prevents the VFS from following the symlink.
>
> Track whether cifs_do_create() returned an open server handle. For
> non-regular inodes, close the handle if present, remove the pending
> open, and call finish_no_open() so the VFS can continue the lookup.
> Do not set FMODE_CREATED unless a regular file was opened. For
> O_NOFOLLOW with __O_REGULAR, return -ELOOP before the VFS's
> -EFTYPE check.
>
> Defer closing a legacy POSIX handle on a non-regular inode until
> after inode lookup. This avoids closing it again if lookup fails.
> ...

Applied.
