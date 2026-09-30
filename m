Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99435516168;
	Wed, 30 Sep 2026 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787341; cv=none; b=is7vsH3S19bJeWXR0rkYgLRCuNGVINJMh3w+UJzM8+T2MNar0AowS3ImCjUIELngWfmEiJsUrkW3eP66LPlycv8ErOWxpUmO1O2Guc00zDHGmKYYRL5h6eyKhR2u1fqFBhxqnt1ox/7ms9ztJFIL0VayTZvT0uvKAwQtOUN+jdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787341; c=relaxed/simple;
	bh=kCyCgTsnlUEUtTx5XDzuYMRr9EEWi8O6pNK8ByDwi40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rv8EA1k0ZdK3TGEDwknHhVUgGt22Gy7w/XrdLqDpqvenauNsVevZGGp2ZFiB+fR+tpIk/eSCQFCifusMGvvQwC9n3KpiIqShJ9rbOICvf+TzPT6st2y0DPU7kjxxGp60ugPYfzdsuhaBehzU1M1eFu8402z4HwQi413ZwJEgAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgsmGb8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgsmGb8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA53E1F000FF;
	Wed, 30 Sep 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790787340;
	bh=WnrxsMlYbuNiN0sOt5cArC0YflbX16T5rrTid0gusO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AgsmGb8YkWjnWJvzYcKG3u1pK03luyLvOyYDVbjIei41K033UUJ2VlF00Jmc4nNCG
	 oaK/A/2YMI+sMzddNfsSoPiieoE7UmiSy3BspRMpebe2N25xPUO4IY52dsaL1dNO9r
	 DgDfB5fwwd0wbHmr2BgGXZY8nVvI8i5FQ46Q5DJeNwsrzFzVdU9o1MA0CrHHTsPum/
	 jUZ0ik0KMhF7pscIhKpduE/dLoYiurQ0XBEb8XppAki9RmuukkUBwu61m3wCCBLAm6
	 ZmxT/aTxLwxPrWWH3cDGMV19KCSiEkV89tqn6UCPUtdc6gpccIZo9u9aQSXHBiHKN1
	 X3GRINPVemvhg==
Date: Wed, 30 Sep 2026 09:55:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/3] lib/crypto: Provide functions for zeroizing SHA2
 hmac_sha* structures
Message-ID: <20260930165538.GB1904@sol>
References: <20260928083055.104266-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928083055.104266-1-thuth@redhat.com>

On Mon, Sep 28, 2026 at 10:30:52AM +0200, Thomas Huth wrote:
> This patch series has been split of my earlier zeroization patch
> series since there were some troubles left with the purgatory patch:
> 
>  https://lore.kernel.org/all/20260924145806.GA1949494@ax162/
> 
> As I've confirmed now, the fix for the problem is indeed to set
> -D__DISABLE_EXPORTS for the other files in the x86 purgatory, too,
> so the first patch here has now been changed accordingly.
> 
> Thomas Huth (3):
>   x86/purgatory: Compile purgatory with -D__NO_FORTIFY and
>     -D__DISABLE_EXPORTS
>   lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha*
>     structures
>   smb: client: Use hmac_sha256_zeroize_ctx function to clear
>     hmac_sha256_ctx
> 
>  arch/x86/purgatory/Makefile   |  3 +-
>  fs/smb/client/smb2transport.c |  3 +-
>  include/crypto/sha2.h         | 73 +++++++++++++++++++++++++++++++++++
>  3 files changed, 75 insertions(+), 4 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
