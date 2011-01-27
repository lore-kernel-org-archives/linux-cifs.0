From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: More crypto cleanup, replace md4 functions local
 to cifs
Date: Thu, 27 Jan 2011 08:17:45 -0500
Message-ID: <20110127081745.752e293d@barsoom.rdu.redhat.com>
References: <1296069133-24772-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296069133-24772-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 26 Jan 2011 13:12:13 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Replaced md4 hasing function local to cifs with kernel crypto APIs.
> As a result, md4 hashing function and its supporting functions in
> file md4.c are not needed anymore.
> 
> Cleaned up function declarations, removed forward function declarations,
> and removed a header file that is being deleted from being included.
> 
> Verified that sec=ntlm/i, sec=ntlmv2/i, and sec=ntlmssp/i work correctly.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/Makefile      |    2 +-
>  fs/cifs/cifsencrypt.c |   27 +++++--
>  fs/cifs/cifsencrypt.h |   33 --------
>  fs/cifs/cifsproto.h   |    9 ++-
>  fs/cifs/connect.c     |    6 +-
>  fs/cifs/md4.c         |  205 -------------------------------------------------
>  fs/cifs/smbdes.c      |    1 -
>  fs/cifs/smbencrypt.c  |   91 ++++++++++++++++------
>  8 files changed, 94 insertions(+), 280 deletions(-)
>  delete mode 100644 fs/cifs/cifsencrypt.h
>  delete mode 100644 fs/cifs/md4.c
> 

[...]

>  
> -/*The following definitions come from  libsmb/smbencrypt.c  */
> +/* produce a md4 message digest from data of length n bytes */
> +int
> +mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
> +{
> +	int rc;
> +	unsigned int size;
> +	struct crypto_shash *md4;
> +	struct sdesc *sdescmd4;
> +
> +	md4 = crypto_alloc_shash("md4", 0, 0);
> +	if (!md4 || IS_ERR(md4)) {
> +		rc = PTR_ERR(md4);
		   ^^^
		If md4 is NULL at this point, I don't believe this will
		do what you want. I don't think you need the !md4
		check?

		Come to think of it, you need the same fix in
		cifs_crypto_shash_allocate in a couple of places. Want
		to roll up a patch for those too?

> +		cERROR(1, "%s: Crypto md4 allocation error %d\n", __func__, rc);
> +		return rc;
> +	}
> +	size = sizeof(struct shash_desc) + crypto_shash_descsize(md4);
> +	sdescmd4 = kmalloc(size, GFP_KERNEL);
> +	if (!sdescmd4) {
> +		rc = -ENOMEM;
> +		cERROR(1, "%s: Memory allocation failure\n", __func__);
> +		goto mdfour_err;
> +	}
> +	sdescmd4->shash.tfm = md4;
> +	sdescmd4->shash.flags = 0x0;
> +
> +	rc = crypto_shash_init(&sdescmd4->shash);
> +	if (rc) {
> +		cERROR(1, "%s: Could not init md4 shash\n", __func__);
> +		goto mdfour_err;
> +	}
> +	crypto_shash_update(&sdescmd4->shash, link_str, link_len);
> +	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
>  
> -void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
> -		unsigned char *p24);
> -void E_md4hash(const unsigned char *passwd, unsigned char *p16);
> -static void SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
> -		   unsigned char p24[24]);
> -void SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24);
> +mdfour_err:
> +	crypto_free_shash(md4);
> +	kfree(sdescmd4);
> +
> +	return rc;
> +}
> +


Other than the minor problem noted above this looks fine to me. Once you
fix that you can add my:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Nice work!
