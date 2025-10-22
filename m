Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA5E350A0E
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 07:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116576; cv=none; b=X6IZ3GzwIx3qLWJ61rWNn0dJR9GODOchLYsOh2Y5+gZJ+VGExCEmAGsh2uJXhcpdjzbQXYsVmfKnRvea0oqzhaGoU1dZe6jt55FrCrY55lauiPmoW8kBXd0dyVD546kTYPn34nIMo9wI+4cAJQ7mOsOx4JkPphmtjJwgxwepHK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116576; c=relaxed/simple;
	bh=hAoUoD39KokCTIlzyRlQVre2lyFFzG0UJ7UnjAshzWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amCfCl/D+rB2WbGbWkmbqfnraVdT4v3QsLjHKUHjVCGug8bqJLjxNWD2EvMgFXMYuJGezy+KoPK3iAQjxsginUgEQtbp1HJ3MKrPVPzwEji+zVTFDzQahH15FdhDDvQJoW9JtNLiY46GGdQ2jQT/ZCFvyBhVTFJj3EEVQNTlV9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cZ7FnpH9; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cZ7FnpH9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bhABinivBrGBVX3EGWSfyWLUQAaX9P1OfxoW826NLdY=; b=cZ7FnpH9r/p+RFZbEEZPV0ekzb
	E1iLcKEa/CdJKQJDQEVpHQvalJdezk9AVjlieRSe1GkT6lmyjeeSDxklrpNUDLkQv1hvZvwWJokGi
	+fLMO49JkYnR3Nd+Z4Cn7qhktlz7ksqJ+WWVzs8i1E2YY4JWUF6ngFLLhfeemnBKTjD6dlLyxA2u6
	5UAQD2mSmuFC2nBIUj8P9ihLgc3uj3OntG2i4N47niwLFAvVLcuxk77GEpMXJmp41ZywaF5YbU/Gd
	uHpcOwo6i5e8VGRLPPUDOlFXJ+PJwwGOUdtfEFA8z1+AudM9z8apQ8281jSXRELGEWQNkqmhdGBmQ
	Pdw+menUKkUAQZwSgz90OyI3+hz6+u09PEIsUD9COz0JDnLVsyfPVmenlv/un13uhzDkAtW/C2dAA
	ACbthIBzfxmFnnH4MspyjSZJ1DE08XL3yuUowiJi4/P5MSoqy+2vxpyawVqawfW/LyB8AFmx3OhaA
	Znft8ssxYlz2ApWTeJd/SOuV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vBSrt-00ATax-1v;
	Wed, 22 Oct 2025 07:02:45 +0000
From: Andreas Schneider <asn@samba.org>
To: Thomas Spear <speeddymon@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject:
 Re: mount.cifs fails to negotiate AES-256-GCM but works when enforced via
 sysfs or modprobe options
Date: Wed, 22 Oct 2025 09:02:44 +0200
Message-ID: <5023741.vXUDI8C0e8@magrathea>
In-Reply-To:
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
References:
 <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Tuesday, 21 October 2025 19:45:17 Central European Summer Time Steve French 
via samba-technical wrote:
> Good catch - this looks very important.
> 
> Do you remember if Samba support gcm256 signing?

We support AES-128-GMAC signing.

AES256-GCM is for encryption not signing.

-- 
Andreas Schneider                      asn@samba.org
Samba Team                             www.samba.org
GPG-ID:     8DFF53E18F2ABC8D8F3C92237EE0FC4DCC014E3D


