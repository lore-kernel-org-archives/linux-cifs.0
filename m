Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ECA209F35
	for <linux-cifs@vger.kernel.org>; Mon,  3 Feb 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597253; cv=none; b=cHyffOo4QitXPk32RTyxugPN94s+upjOAlLfa+dDFA7f+MMWaOsxlclXZxEGuE6Y+UK1k0ekYKhb1vCAv33fquSLHaVpnoLFnBVESi+O86OAmLqFejzP9FoqubTRaMkTHHJJRXheI5IFnTtv6J6z4bDOJOahlIe+tagXZAFlJhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597253; c=relaxed/simple;
	bh=ZyrBlemwC8ShllprdXDiJrOZhGlev/3aiFCu7lVtu6o=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=B/AEjxmkJHW03N+QhLw2NyGRiUh/WccXCUZhDTwrRCr6UDIW5iKcGuiU4Lm2auaXum+mgiEbyQyVdlHRlAIxSFXZDyISF33IY7/TJKerlaltWSQ7FqwAjJvhRmri6Bg3tpseL4pKkZ2yTOTqXSyoGWx38t1GgiXC7XyTl7F0Gl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=nWc/+KpD; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="nWc/+KpD"
Message-ID: <4b538b0c75d1cf736ef1f4f6211f1ea9@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1738596656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lZ2KuwS1SujvDouhFXTeEjV5+H3I9MyHKPHo6+zy9UE=;
	b=nWc/+KpDHm1cYSbq3LdsHe9eXYOYRqI+uVeMlFPcujIOYFHttcZacCc8CyBXUp8CmthcJo
	RLChAKCRE57Pk/fneZcaLk1pCJNw2BvZSAb2o6+aJ5k8U1wTytkqIwBBGhT39Kn/xHz0fM
	/ogHEx3XnajvHi76x7/F9lPk8iTFC2UCUVTWcmEZ8n5rhSrYdL8JiAdbh4INqHDm3VsHrT
	I4CCDtG2zY4cFetOW1Ly5n8KD4mvsEBGAxyluiu27OEgMy/u3EefPC3p0WAGinM+0ICxk7
	VgPgRSu/uO+2wieNG6qp1k9X9XEVpiZVolo+BpqFdk71dfELn2xUtQi0hCXU9w==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Subject: Re: parse_reparse_point confusing function name
In-Reply-To: <CAH2r5mvdyi_6OZQ69z5zhiNapJZ778K_ZraY9dVpmAjgr7czSw@mail.gmail.com>
References: <CAH2r5mvdyi_6OZQ69z5zhiNapJZ778K_ZraY9dVpmAjgr7czSw@mail.gmail.com>
Date: Mon, 03 Feb 2025 12:30:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Any thoughts on whether the use of two different parse_reparse_point()
> functions with the same name is confusing?  Should we change the name
> of one of them?

As long as you can understand its implementation, I really don't care
about the naming.  Feel free to change it.
