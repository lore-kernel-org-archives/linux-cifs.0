From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fix BUG() in calc_seckey()
Date: Tue, 18 Oct 2016 09:57:28 -0400
Message-ID: <1476799048.8356.2.camel@redhat.com>
References: <1476736822-30098-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476736822-30098-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2016-10-17 at 16:40 -0400, Sachin Prabhu wrote:
> Andy Lutromirski's new virtually mapped kernel stack allocations moves
> kernel stacks the vmalloc area. This triggers the bug
>  kernel BUG at ./include/linux/scatterlist.h:140!
> at calc_seckey()->sg_init()
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 8347c90..5eb0412 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -808,7 +808,11 @@ calc_seckey(struct cifs_ses *ses)
>  	struct crypto_skcipher *tfm_arc4;
>  	struct scatterlist sgin, sgout;
>  	struct skcipher_request *req;
> -	unsigned char sec_key[CIFS_SESS_KEY_SIZE]; /* a nonce */
> +	unsigned char *sec_key;
> +
> +	sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
> +	if (sec_key == NULL)
> +		return -ENOMEM;
>  
>  	get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
>  
> @@ -816,7 +820,7 @@ calc_seckey(struct cifs_ses *ses)
>  	if (IS_ERR(tfm_arc4)) {
>  		rc = PTR_ERR(tfm_arc4);
>  		cifs_dbg(VFS, "could not allocate crypto API arc4\n");
> -		return rc;
> +		goto out;
>  	}
>  
>  	rc = crypto_skcipher_setkey(tfm_arc4, ses->auth_key.response,
> @@ -854,7 +858,8 @@ calc_seckey(struct cifs_ses *ses)
>  
>  out_free_cipher:
>  	crypto_free_skcipher(tfm_arc4);
> -
> +out:
> +	kfree(sec_key);
>  	return rc;
>  }
>  

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
