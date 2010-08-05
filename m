From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-cifs-client][patch] Make NTLMv2 as auth mech withing
	NTLMSSP and enable signing using crypto shash APIs
Date: Thu, 5 Aug 2010 12:44:30 +0800
Message-ID: <20100805044430.GA11845@gondor.apana.org.au>
References: <1280975679-9096-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	samba-technical@samba.org, linux-crypto@vger.kernel.org,
	shirishpargaonkar@gmail.com
To: shirishpargaonkar@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1280975679-9096-1-git-send-email-shirishpargaonkar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

shirishpargaonkar@gmail.com wrote:
> Make ntlmv2 as an authentication mechanism within ntlmssp
> instead of ntlmv1.
> Parse type 2 response in ntlmssp negotiation to pluck
> AV pairs and use them to calculate ntlmv2 response token.
> Also, assign domain name from the sever response in type 2
> packet of ntlmssp and use that (netbios) domain name in
> calculation of response.
> 
> Enable cifs/smb signing using rc4 and md5.
> 
> Changed name of the structure mac_key to session_key to reflect
> the type of key it holds.
> 
> Use kernel crypto_shash_* APIs instead of the equivalent cifs functions.
> 
> 
> From 6ab552fd60804f3c708e1745ca936112fc9f9821 Mon Sep 17 00:00:00 2001
> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> Date: Wed, 4 Aug 2010 17:24:07 -0500
> Subject: [PATCH] Make ntlmv2 as auth mech and enable signing using crypto_shash APIs
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
