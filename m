Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550D1E89C
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745955698; cv=none; b=KObU6bAv0b0oAUz5Tw7creTvKc0JO0uirui6pjT8IlyRULHduWKyOw8JTC8b0D9wnE6I+D9ZItcjCEniulbgDO/2TBsrccN7QCQOfK6JGfAfavPR+W6xm7LhNtUUQCNWbKpegTfv+bKQnf44/wuMFXN9i647/18ebZnNWm9oyPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745955698; c=relaxed/simple;
	bh=N10zmqtuTAwGixRQlZCx6U8qVpMN86Zb+paSD905/Sw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fs4IUx2rzbRLuYIttrJmq2Mn3dYIAeFVXpNM2FhoL2kyI3ualS3g6WbnWYnC3Ed7gNy4fs74IEoEXjQ0Sioct5dXblxBfWQFcfqSTbj5J5KBpwts05li25f7cv0vNdnxxDw++kCUpL/C+ckeRV6bJYJcsX6n45vRuzaBYCLXSiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=lAIxudQ2; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="lAIxudQ2"
Message-ID: <bb39b314813864e05da846cbfbdfc3fc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745955695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N10zmqtuTAwGixRQlZCx6U8qVpMN86Zb+paSD905/Sw=;
	b=lAIxudQ2YYGlodkA78QSQe7SpBsafFE5QJPYRYxJx6pYZ6OXIhG+/Mym6nAYqYRa0m0olq
	M1Ylgxezh2xjhRXklsZodXTBZlW7uHtLw0QQwXM0jnETZGCAac4d9c0X3+ojl3zPhCeZij
	om1gs5EZhqVn/NzpnN0zFcYo6MwNSK+MH3AGbeOdYA8NY1bJZNSN9Ij3rqPaco1m3dq++h
	qlVgrzyRXChERhyUq55LsdhaaS5kSGNpya0J2rhXQgf18clRLfRPyNqZN7YW0QVoJ6Kr71
	lZ71lHmHbQU9ZBGn61A/Jpf7IwhtmXuo1PFPcKvJaw4QQplg6lYSa60TnDsA4w==
From: Paulo Alcantara <pc@manguebit.com>
To: Jethro Donaldson <devel@jro.nz>, linux-cifs@vger.kernel.org
Cc: sfrench@samba.org
Subject: Re: [PATCH] smb: client: fix zero length for mkdir POSIX create
 context
In-Reply-To: <20250430005915.5e1f3c82@deetop.local.jro.nz>
References: <20250430005915.5e1f3c82@deetop.local.jro.nz>
Date: Tue, 29 Apr 2025 16:41:29 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jethro Donaldson <devel@jro.nz> writes:

> smb: client: fix zero length for mkdir POSIX create context
>
> SMB create requests issued via smb311_posix_mkdir() have an incorrect
> length of zero bytes for the POSIX create context data. A ksmbd server
> rejects such requests and logs "cli req too short" causing mkdir to fail
> with "invalid argument" on the client side.
>
> Inspection of packets sent by cifs.ko using wireshark show valid data for
> the SMB2_POSIX_CREATE_CONTEXT is appended with the correct offset, but
> with an incorrect length of zero bytes. Fails with ksmbd+cifs.ko only as
> Windows server/client does not use POSIX extensions.
>
> Fix smb311_posix_mkdir() to set req->CreateContextsLength as part of
> appending the POSIX creation context to the request.
>
> Signed-off-by: Jethro Donaldson <devel@jro.nz>
> ---

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
