Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3BE1E531
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712097812; cv=pass; b=tF/gZqh2UmSUZ/SWpFZPf/Vy/YVruGAiX/2+G8o4EYcI7cp3xIzlXm2z9jICRh2qdCnfrcuFNDwjksRb+k31u02D94e24vseS61F9pFCzBV72ThF/G6WEXQsOtpVjwjS24D+cywa8rS1UXGklZz/YO6BaiqzzTDRb2Qt6rDgnzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712097812; c=relaxed/simple;
	bh=VM3r/O5OyrsHU29EQ7mrBUmFCxSPXRT/pK7byFCgMyw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=GBrd7apY2IyXXnjuV8IMwxKFvKsc0Xjfw4Fxh7/wY3KkGZ5tTqNnSJbiBEcjjzcwqHGJKAwI1SM0tPuEdosqd9cO6d1XXZWrMsvyDpTR7Dn97KhBJ82YLcrvxVQ+IDElcL2ybWQ05Nadfm1D9Qe0Es8et2iKmfRzIE4vrFCO5Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=RuzNnZYV; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="RuzNnZYV"
Message-ID: <fc9e864c23c9eb08ee4f34d9dcb7e3a3@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712097809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t4pGpHbZJWaanDM4rjaLxbpwhpH+7Um4IMRuCiAJA7I=;
	b=RuzNnZYV0VWX44+JM2wEKei33hOuFqung6U0BYSWYQTcT/p5GThYek3WCH02uLCKWYfVtd
	GcVPZTBJfnTlX5iU6HEXb8cHOTUgtc1AUOiXmPi6ATUhk9qJGNo4n6P/tW0owcgTrUh+B7
	a9wc2Yxlwa7n25WCT7uh8iRlGuBjuut4hraj3uNEzMosC72oMis0g8H4nr95wkmcQKbrpu
	nic0E3Wukj9DnDSeEv3iYjLVCdcAvBV/QgTTkAu2GRNShZ9DGcCI5ULzi02m7S99K0VW+9
	K7TZj2ErSixpQkU0CMvJIBVctSQZNeJFB6zN1iJIPoRSYgk9R6WWTzLwgNu1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712097809; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4pGpHbZJWaanDM4rjaLxbpwhpH+7Um4IMRuCiAJA7I=;
	b=ScDWaeWswMfFpvXFcIMBsiO1uAr+pNcBRsHARtJity0PbFIBEqGZ3Yi1XAMBwW+8E+PpIA
	KfnNfpD8noLutV2a46tGfJUeAGmWqTbngZz7Jv1G7LxNlj3OPrd0vVF9mlvRlDjTOQJ6Yo
	FrZy+/JVisheumrs359+5/ADTPzvZDOd8Kivx8SF4xWrVFUGS7s+EEeMPJtAygxvbwyVVk
	gbS1gDQyhgyUefcnJ6UxXkXdn/Z9gZ2YOnXtFLgNsKMga2tJjbIHbzuqjsX/1EdoLRaIeM
	esnv2dvrlju4tErz0Uiv4NHAeoKl0stSCok34ipmG3XXaWylSz15MygJy2yC7A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712097809; a=rsa-sha256;
	cv=none;
	b=OPXdie6Za7ho42jvnx5M6uzm/azDrxYIf99fZ5ic97LQ4A1f29rcjDiUu319r47L635Tiw
	pk6zX55ibHEjp5jMcQG9MAJTOShQd+T/Df3qoJ/gqK4teoJMjEP6LSWM+lyl676wLaCzA2
	ACfQWR1DhUVbmR5gTpHLf++HZs8ru9yjZTdeXYyUWoXtyjw0tMcU/YOWTsQfTFRueVHjVY
	w8uQYaDe3rRDhpatDvTnB9w+l4ps5ZSP3norBXBN5hjhoElegXZ4L2wc7wY62/7lt5gE76
	FR9eNqIwlDu6z/u2NN25+H1xfGHuD38sov885o/4NHM2vycioiG1lYYyKQ52pg==
From: Paulo Alcantara <pc@manguebit.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 11/12] smb: client: fix potential UAF in smb2_get_enc_key()
In-Reply-To: <20240402193404.236159-11-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
 <20240402193404.236159-11-pc@manguebit.com>
Date: Tue, 02 Apr 2024 19:43:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> Skip sessions that are being teared down (status == SES_EXITING) to
> avoid UAF.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

As we can send encrypted session logoff when
SMB2_SESSION_FLAG_ENCRYPT_DATA is set, then please ignore this one and
patch 05/12.
