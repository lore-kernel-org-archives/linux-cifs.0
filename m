Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC073815E4;
	Fri,  2 Oct 2026 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790931113; cv=none; b=ri1/aLhuqeXJ0bBj4FQOadiZpHBHDjGLRqXUk9OXUJR64p/EOEF2mkywDjo1Ke3mjoCUERmPpl5fcR3s8RhTsGGFeMFB4wyVFmW9Ez33KnRP8lwbVYgLoPNw2z2k842b0KdMrmjj4nUHHrtPCDfOx+xCTczq9eGKRWhMvffeuIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790931113; c=relaxed/simple;
	bh=/2VOdhIoDIWMkOAjIvMqep/xz4y0Iivv5oOAb13egi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obrY9afzV4Zn8fvQDPegEeAlguB+LV3D4I7O94np87fDorq1Nkd8PSkhcNg+qthpEV3OHPUxdET+ARv6Kdjz6YBlSasac9N4pUnVjtXGxxrhcuzelPWdHnzoxxMVoD3KxgvPnWGLGrJIc1D3AnJbaVof+rILThfWLhSxl1MeKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=S5+eBqZ8; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="S5+eBqZ8"
Received: from localhost (unknown [10.10.165.9])
	by mail.ispras.ru (Postfix) with ESMTPSA id 0BF3D406C750;
	Fri,  2 Oct 2026 08:51:43 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 0BF3D406C750
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1790931103;
	bh=Q6uermtlktZ0VkU5nIBo3CGNejxKsRw8bTF/OeHXl4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S5+eBqZ8M9jOyOU0zzBnJ8xhqxC58KFLAFPS3CZzz8wXveaWDwAoBTl9WFmHyb4l3
	 jZsajb6u3q1Y1Vd31vBePOOqO7brAGpggTx+qxuv9pJMugDo0SIeTJ2+FU79h+6LzF
	 kjA5H4mnvvPCmrDU9HGI4BfIPCpCcbjz97bc7Iss=
Date: Fri, 2 Oct 2026 11:51:42 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Mikhail Mirkin <mmirkin@nppct.ru>
Cc: Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, "Paulo Alcantara (Red Hat)" <pc@manguebit.org>, 
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, 
	Steve French <stfrench@microsoft.com>, lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.12.y] cifs: Fix handling of a beyond-EOF DIO/unbuffered
 read over SMB1
Message-ID: <20261002114828-a0c191e9851a3e2487ada3a0-pchelkin@ispras>
References: <20260930120532.5436-1-mmirkin@nppct.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260930120532.5436-1-mmirkin@nppct.ru>

On Wed, 30. Sep 15:05, Mikhail Mirkin wrote:
> From: David Howells <dhowells@redhat.com>
> 
> commit c61af12157ef9fe480ab84b4923e8ca3d8f86a62 upstream.

That's not the hash of upstream commit.  It should be
9d85ac939d52e93d80efb01a299c6f0bedb30487.

