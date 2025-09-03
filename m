Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910EA322C78
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756926808; cv=none; b=Pl/M6WM19vLYGqE3caC+YwbQQnUT24+5rFVEikqIfPWtOGhCa5d0EuCBv2HnMK2L1Jwk0REZ5AbGYxPXv9r/LaiIjNRbp2UeOhvyAj38+Di4YB7ndjEEfd5E8W9owZuAGramXl0E2tQ3TMuJ1TI/b2cTyonWzDqCKXRptzqKNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756926808; c=relaxed/simple;
	bh=/HKTrwuD853aFZ87WaQeG7YeT1vzCN2BRFtaM6EdXeA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=oZg8vVHOYz2HIjSXdXQfmURO81dQUtiKL3Re/Grhjclsl1bgI0BjrGQEFz7Lwt6zii65wYFdYR+3BHyLR9VWBIH//aAErRKe6YSvaL37iJ3fxNv39dWAL0erMTLwH+730f0IN33QvLBhPlq7C2eEuCw5/FpJh3d+X1s6xRYyrzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=WtF4sTRO; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="WtF4sTRO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1JC7+IYudWzAFLyN6TAWeIi9q0oQ+famFh+4ouXVhKI=; b=WtF4sTRO6eWOUUMqD72ID6g5Ql
	FB6OSV5Rt0+rnNDAFRAckuW1SmQ9ln2/manVNCCGAJ33QnianpXCK93SMf3btDF4s92fU148e9NjT
	Ded7Ah4Nwh6Ri4zSY5LFhu3civm8jFXDMlJM+U89d+DLhNZAY1upeyJMkvdeL2gSfy5LN64p8oK76
	/tPqmdO1lmrgIGnDRBLZLCeXMdbnTImVmghgt35y9JUVo8CIdSpVizG9JEY/BMRYtZstjhq4Kk/EZ
	MwHW4nODTfOHhdYZN8oRj4G/neHBZiQmmdtCcpwMcYISZ/vemAK0pjQ8IdJtz/jQIc6zkS3u4MWZS
	pzrJwU/A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utsv6-00000000mHf-2mok;
	Wed, 03 Sep 2025 16:13:24 -0300
Message-ID: <a8e805840001614d864fb4185b91e7ff@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
 <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
Date: Wed, 03 Sep 2025 16:13:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> where DIR is the directory all of the above was performed inside, the 
> rmdir will fail with ENOTEMPTY and *now* the user is confused.

BTW, it is not only a CIFS problem as AFS and NFS that have been doing
these silly renames forever, they would also fail with -ENOTEMPTY.

If you know a way to resolve that without expecting the server to
support unliked file retention, then please let me know.
