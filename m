Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="axsVKUVH"
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5524BF4
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 09:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=d1V+Y7dJncXQ9Ctk/pTkzup2pAVzspT42o3Qu1BUGCk=; b=axsVKUVHJUBH7h556Usf2cm6Pm
	YR42fiSqFSSomRHXUWP0/3eFWXSS06HvzKtUU+cSxfC1colvLBKZZXR41iLGzDIffuGryjbCiFbS0
	LAZBXsri3cSK0gCqWMNDwNbvV1H9ACOb6h9MT2MGNBnssvLiAyeW+xsVMbnHQV12TrXkADaDpFtXz
	RAoVolUmXfSQTMxTnNvV/4IjrFdP/GtrT3rD2ixd6qP8fuz/+wpbM67Ws2R8QCSJstVxcphBAx08L
	AxYatdD0nhmQAtU+hwZyYwaF4lnsCq83rDku0uO5kWphctpeSVQpxySGAKwYsdUMiNhS1erfseh7W
	kpSmTwbyhSnVMjT2kDr1XT9HkTIWZ9lkI+9GSZV7OyWIcAuGNOMpwBvcXQOkUMECcuJ0XcA3R8XTY
	mVdzHOsGXQSv2KP+zoEqBQl15izuE2CfHKZgU1Amf8p2pSXyX9yJt3+TKJu9HLfB1KQwOHK352dBQ
	1iKfA9HwOVlY3MKhXd2hdJK6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rBeut-002dUW-0z;
	Fri, 08 Dec 2023 17:45:35 +0000
Date: Fri, 8 Dec 2023 09:45:31 -0800
From: Jeremy Allison <jra@samba.org>
To: Tom Talpey <tom@talpey.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>,
	Paulo Alcantara <pc@manguebit.com>, meetakshisetiyaoss@gmail.com,
	linux-cifs@vger.kernel.org, smfrench@gmail.com,
	bharathsm.hsk@gmail.com, lsahlber@redhat.com,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
Message-ID: <ZXNWO3hkP46959hE@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com>
 <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
 <9980a249-043c-4140-a5ee-bc06cf156747@talpey.com>
 <CANT5p=p0Fk5j73Hu50DeywQdBSffKo8TNvZhSjQaj+-LtrNOTA@mail.gmail.com>
 <f67c5e4e-8c0f-4755-b974-0b76a044433e@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f67c5e4e-8c0f-4755-b974-0b76a044433e@talpey.com>

On Fri, Dec 08, 2023 at 09:02:45AM -0500, Tom Talpey wrote:
>So, this next statement makes an incorrect assumption:
>
>>Hard links are in-fact pointing to the same file. So I would've
>>assumed that the server would have treated both links to have the same
>>lease.
>
>Not at all - the lease key is chosen by the *client*, not the server,
>and the key can only look up one actual lease. So the protocol enforces
>it, meaning the server must verify the path.

IMHO this was a big mistake in the protocol design.

The server has complete knowledge of what paths map
to what files, so the lease key really should have
been a server created token.

Well, too late now :-).
