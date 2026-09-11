Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A107429CE6;
	Fri, 11 Sep 2026 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789154910; cv=none; b=LTITpFV/9ncfKkT6kBTnhoVw7qaEjQrJsfev9w1uKds2Aia/nmpXMy5XG3Jb4nc0clkrdTfzO9yqP3EJ70E3baxU2SBTbywJoyZIbbIp0r8R+137QYVlg51QjUs+4WvFRA/elSNIunzTZHyvFpYP2y4pKsMyzJos95YqJBuCnDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789154910; c=relaxed/simple;
	bh=5MIUT6Vhyy7KPRoS2r1tNcg/7CK6RivVtNvUuQ77BPw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fCPpsjaZx/yvqbV3fzlSf8BG5h9eiXzwq2pH7zV6B446nWCa6uZih4QH57FPnySocBWTjy5oNR5FECEWUVUJbV7dCA3KZ3T06FFJYMHDA1y3q+TtxbDo4RsBj+ICb7xKECTD1Sv9RVN1kMLvRBxsN3N+9lOFGx1m1q4eAgt1Xh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=MHP9R2gV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="MHP9R2gV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5MIUT6Vhyy7KPRoS2r1tNcg/7CK6RivVtNvUuQ77BPw=; b=MHP9R2gV6+jCk2RtAQ5avTaZMC
	eivbifxVFQcbrDHGWk28j5PXn4QK0py5qFniKcpe15fvTxt6dG6hJZt9yJdAvoUYl0PFYknhGYFD3
	zKfoyMnfE2HpXnFhy+nRFcvNwNWFyelK/b54+ky+9CNgIwwUqhN5UgKZsxofYRrw+5pMBHTjbCOeU
	k8fz4OhkwzaK/vLyggEAmyHd7CQNtOq5yMUHIr8/mwINm4gWcERkulzhoAR0pXX3+sgaQDSltoXsV
	d8chZcEWoTxaZ48FUjDAG6sxw9jj5zToCR7TxhNJYNvyXTngcJUahm+w5YznPVoaOYwxuLV3p/eTC
	S7XXMfRg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x56v6-00000001EkJ-0wWV;
	Fri, 11 Sep 2026 16:28:20 -0300
Message-ID: <744056887c4419bda8e49bf64f112e95@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: April Cardenas <april.cardenas@canonical.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, April Cardenas
 <april.cardenas@canonical.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb/client: send lease break ACKs thru correct session
 for multiuser mounts
In-Reply-To: <20260910051649.3806214-1-april.cardenas@canonical.com>
References: <20260910051649.3806214-1-april.cardenas@canonical.com>
Date: Fri, 11 Sep 2026 16:28:19 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

April Cardenas <april.cardenas@canonical.com> writes:

> Currently, when cifs_oplock_break handles a break request from the server
> it searches for the appropriate tlink to handle the request
> but incorrectly uses the current fsuid as the search key, eventually
> causing read errors for users with multiuser mounts on NetApp.
> Fix this by using the tlink from the cfile struct instead to respond
> through the correct session.
> ...

Applied.
