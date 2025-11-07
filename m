Received: from mail-10624.protonmail.ch (mail-10624.protonmail.ch [79.135.106.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3282330C61C
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762528971; cv=none; b=nwJcq1HJ+jj0w4jSSD+guKcJnIOXmwhdN29uzfw1m2gF1RawaEjQNV+E/HX1ZaHzcSfga+Tnj3YbCfXXElNoBZussRk/a9BXmJstmJZjs8UyFhtShj6s8Bt+rlSgu+9tXoXClHTaOjBTgFd6z/CCZcIedyA7zCABhxFTrH49MlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762528971; c=relaxed/simple;
	bh=J31rQg4Kju4A/KMFxzeF/8w0oMhQL89IXBB/8W0p+To=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G49ibnv05F7CABBQ5stdD3HY4jB8vR9oA6NiHITumuRem6HulduLOh/Xw4qGlJeC/yjfi8KMPdzOx8CHqbwPDBYbjaadJC0vXr3AYYBKQWlv6ANyaQqjuTvx3KH20z3DQ19R7Xx9LIAcRCCak4ylZXCfUoiPmdiW+fzr5bOtEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=joshua.hu; spf=pass smtp.mailfrom=joshua.hu; dkim=pass (2048-bit key) header.d=joshua.hu header.i=@joshua.hu header.b=mfvgTfB8; arc=none smtp.client-ip=79.135.106.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=joshua.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshua.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshua.hu header.i=@joshua.hu header.b="mfvgTfB8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=joshua.hu;
	s=protonmail2; t=1762528958; x=1762788158;
	bh=J31rQg4Kju4A/KMFxzeF/8w0oMhQL89IXBB/8W0p+To=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mfvgTfB8SIrtBY553fl4QeYVuYgcGI7ZF5wjEKLqwVMHYHDAny24LKDtvDotvpZkO
	 8b0Ah1Y6IwQB4FTenncPTqGm21FtnFAOZCK6Y3UoPmyDpWxybzrtA0mkVQjWn7QNBC
	 wMxbU5Sfgb1P+lpnbiPBQzmoYuFe7iZRSstZDkG0LCoPJbyH3BasiO21TBhnXZRCSm
	 HVm6IFsFkVb88I7cA80/ZjeDyY14D1ogtUHn2C1klb5ovVXC0jHCDTxfpPNNRqgmlz
	 dPuKlnie5kHadjnygGpjY0nNxZOdUM7AEsw2UwSrQolKxHs7sHek3LrglJKSICoQdX
	 Y35601bEfSvHA==
Date: Fri, 07 Nov 2025 15:22:32 +0000
To: Steve French <smfrench@gmail.com>
From: Joshua Rogers <reszta@joshua.hu>
Cc: CIFS <linux-cifs@vger.kernel.org>, Joshua Rogers <linux@joshua.hu>
Subject: Re: [PATCH] smb: client: validate change notify buffer before copy
Message-ID: <ONR9GWFvdJx39b1jAUTFBGjhqlY1LgZhwHECF_OroUZSCW0dGQHjcNSBDtiLfxdP1-Ly3UufUTo17bw5Kea5LTglBll2vZjWw9V8aGnMKvg=@joshua.hu>
In-Reply-To: <CAH2r5mtLBAwfk7YbgRkCnA4S7uNyiTGs7kDssa697pci=rCYDw@mail.gmail.com>
References: <CAH2r5mtLBAwfk7YbgRkCnA4S7uNyiTGs7kDssa697pci=rCYDw@mail.gmail.com>
Feedback-ID: 126372902:user:proton
X-Pm-Message-ID: 83f03e34d038b433b7047f26419fbd435c8627fc
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Is it possible to slightly change the commit msg to include "Found with Zer=
oPath"? As this bug was, indeed, found with a tool called ZeroPath.

Thank you.


On Friday, 7 November 2025 at 11:23, Steve French <smfrench@gmail.com> wrot=
e:

>=20
>=20
> SMB2_change_notify called smb2_validate_iov() but ignored the return
> code, then kmemdup()ed using server provided OutputBufferOffset/Length.
>=20
> Check the return of smb2_validate_iov() and bail out on error.
>=20
> See attached (lightly updated to fix checkpatch warnings from Joshua's
> original patch)
>=20
>=20
>=20
> --
> Thanks,
>=20
> Steve
