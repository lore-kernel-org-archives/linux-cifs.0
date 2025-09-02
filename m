Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA54D2E5B19
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 19:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756841956; cv=none; b=CgTnAoxN5ErT/SD1yWfDcVFz/DKSt5l+CNEL/WJY7FkDGBAOP98Bp9svBGM5pcUiA9OyOQUWvdRb/3jtcWNCDxSob/8SnW30svf7I/hkTnLYhKY8TqkzssetjqZ1x2EmDKjOlLe7JySTv24JtmaUPIMoUY+JWpfNlue3a7UfOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756841956; c=relaxed/simple;
	bh=vdMCkfcKF6tNERNxxBpmHwLIk/45k96IRsnj9GOZBWU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YrFOK4xNk9uGtGg914XJYw97HuVSomqV/PxSh3MdqRRsecygss5xAVUQoS53l4+Bwnx51EfMbQouz+jo15C+7o0VShgYg9vYhnw/0Pyv6nWi1NdA6qF1d/xygMiJ2Q21J0qH4xUaeLYDCej8JOyHxLQWzNRrye9WHendB8RVO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KrI0VEpn; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KrI0VEpn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u+dqfpN6oUk3CUie/KPGc6VEosh0jVHKKjH1dvfxLW0=; b=KrI0VEpnbK1dMi6NEAF/EHJTO3
	oCjVx6RIeyWUSgV97DIQ7qc6/ZzCh7Woqx5EqMgsJxtxlbADGWpD2Zg/pcxoSK8Im2DNUUzoRTw/r
	G2AWrI8bdppr1sqnQEn8VeU45uJQvhXEXFeiOCZr92dspQdhNf63QM9JVPmv5a/1dSummnC0yF9VL
	WXrgiqWF27qv/TOxgRueBsL5tQdIQ0QMGH3ba6zTHzGLJNUnZB+M3g+KeJ9+5ZWj4b3Yhek9DgaRB
	MOOsSTzDSQ5jsCxVhg0b4T26pcTN7/VR8hB7STg/yyxA1p7R72Oik7OnAR9pzuyCSt1DjfqQiH7wv
	8w+X9Rsg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utWqW-00000000iMP-2ItP;
	Tue, 02 Sep 2025 16:39:12 -0300
Message-ID: <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>, CIFS
 <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
Date: Tue, 02 Sep 2025 16:39:12 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> Likely? How? Does a Windows client also do this stuff when the rename 
> destination is open? All this additionaly complexity is only waiting for 
> bugs to happen and now that we have POSIX Extensions back we should 
> phase out this crap.

Claiming POSIX support and being unable to rename open files, that would
be even worse, no?
