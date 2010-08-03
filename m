From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-cifs-client][PATCH] Enable signing for ntlmv2 within
	NTLMSSP using kernel crypto APIs
Date: Tue, 3 Aug 2010 16:33:30 +0800
Message-ID: <20100803083330.GA15074@gondor.apana.org.au>
References: <1280604866-9505-1-git-send-email-shirishpargaonkar@gmail.com> <20100802065508.GA8431@gondor.apana.org.au> <AANLkTimtgejfxW8P_GvGqD3muu2Wh6BfC-xPTpNtJb9+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	samba-technical@samba.org, linux-crypto@vger.kernel.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimtgejfxW8P_GvGqD3muu2Wh6BfC-xPTpNtJb9+@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Aug 02, 2010 at 11:46:07PM -0500, Shirish Pargaonkar wrote:
>
> I have compile issues with crypto_shash interfaces, no such issues
> with crypto_hash_ APIs,
> everything works fine.
> 
> When I have code like this, I have errors and warning and when I cast
> them as (char *),  module
> oopses.
> 
> struct session_key {
>         unsigned int len;
>         union {
>                 char ntlm[CIFS_SESS_KEY_SIZE + 16];
>                 char krb5[CIFS_SESS_KEY_SIZE + 16]; /* BB: length correct? */
>                 struct {
>                         char key[16];
>                         struct ntlmv2_resp resp;
>                 } ntlmv2;
>         } data;
> };
>         if (server->secType == RawNTLMSSP)
>                 crypto_shash_update(&desc, server->session_key.data.ntlmv2.key,
>                                 CIFS_NTLMV2_SESSKEY_SIZE);
>         else
>                 crypto_shash_update(&desc, server->session_key.data,
>           <----
>                                 server->session_key.len);
> 
> 
> And
>         len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
>         UniStrupr(user);
> 
>         crypto_shash_update(&desc, user, 2 * len);
>                          <----
> 
> No such issues and oops with crypto_hash_APIs.

Please post your entire patch with shash and the oops.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
