From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB3 Signing part 1
Date: Thu, 13 Jun 2013 17:49:58 -0500
Message-ID: <CADT32eLVtj+Ld624og-fcvKfORd1WyxVqjnnxNvMd7-3_x3SBw@mail.gmail.com>
References: <CAH2r5mvtOFqcqcdbXxcK8Ci0bqzznRmEfDjfYM0RZPfemobdsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvtOFqcqcdbXxcK8Ci0bqzznRmEfDjfYM0RZPfemobdsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, Thanks. But I think what we have here itself needed to
changed as per Jeff Layton's comments.  He is suggesting
and I do agree and was working on invoking respective crypto
algorithms per smb, smb2.1, and smb3 signing instead of
invoking all of them per any kind of signing.

Changing signing for smb2.1 and smb3 from per smb connection
to smb session is somewhat non-trivial but I do plan to work on that
piece of code once I am back.

Regards,

Shirish

On Thu, Jun 13, 2013 at 12:28 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Shirish,
> I updated your patch for current cifs for-next git tree, and split out
> the parts which Jeff noted need fixing (need to use a per-smb3-session
> vs. per-socket key to sign).    The 1/2 that is left looks pretty
> straightforward and builds fine.  I will check how easy it would be to
> fixup the other parts soon.  I would like to get this in for-next in
> time for the testing next two weeks with Microsoft.
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2906ee2..603f18a 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -10,6 +10,7 @@ config CIFS
>         select CRYPTO_ECB
>         select CRYPTO_DES
>         select CRYPTO_SHA256
> +       select CRYPTO_CMAC
>         help
>           This is the client VFS module for the Common Internet File System
>           (CIFS) protocol which is the successor to the Server Message Block
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 30bea6b..5a6c6bd 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -705,6 +705,9 @@ calc_seckey(struct cifs_ses *ses)
>  void
>  cifs_crypto_shash_release(struct TCP_Server_Info *server)
>  {
> +       if (server->secmech.cmacaes)
> +               crypto_free_shash(server->secmech.cmacaes);
> +
>         if (server->secmech.hmacsha256)
>                 crypto_free_shash(server->secmech.hmacsha256);
>
> @@ -714,6 +717,8 @@ cifs_crypto_shash_release(struct TCP_Server_Info *server)
>         if (server->secmech.hmacmd5)
>                 crypto_free_shash(server->secmech.hmacmd5);
>
> +       kfree(server->secmech.sdesccmacaes);
> +
>         kfree(server->secmech.sdeschmacsha256);
>
>         kfree(server->secmech.sdeschmacmd5);
> @@ -747,6 +752,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>                 goto crypto_allocate_hmacsha256_fail;
>         }
>
> +       server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> +       if (IS_ERR(server->secmech.cmacaes)) {
> +               cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> +               rc = PTR_ERR(server->secmech.cmacaes);
> +               goto crypto_allocate_cmacaes_fail;
> +       }
> +
>         size = sizeof(struct shash_desc) +
>                         crypto_shash_descsize(server->secmech.hmacmd5);
>         server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> @@ -777,8 +789,22 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>         server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
>         server->secmech.sdeschmacsha256->shash.flags = 0x0;
>
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.cmacaes);
> +       server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdesccmacaes) {
> +               cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> +               rc = -ENOMEM;
> +               goto crypto_allocate_cmacaes_sdesc_fail;
> +       }
> +       server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
> +       server->secmech.sdesccmacaes->shash.flags = 0x0;
> +
>         return 0;
>
> +crypto_allocate_cmacaes_sdesc_fail:
> +       kfree(server->secmech.sdeschmacsha256);
> +
>  crypto_allocate_hmacsha256_sdesc_fail:
>         kfree(server->secmech.sdescmd5);
>
> @@ -786,6 +812,9 @@ crypto_allocate_md5_sdesc_fail:
>         kfree(server->secmech.sdeschmacmd5);
>
>  crypto_allocate_hmacmd5_sdesc_fail:
> +       crypto_free_shash(server->secmech.cmacaes);
> +
> +crypto_allocate_cmacaes_fail:
>         crypto_free_shash(server->secmech.hmacsha256);
>
>  crypto_allocate_hmacsha256_fail:
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f13cbbe..9cacf37 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -125,9 +125,11 @@ struct cifs_secmech {
>         struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
>         struct crypto_shash *md5; /* md5 hash function */
>         struct crypto_shash *hmacsha256; /* hmac-sha256 hash function */
> +       struct crypto_shash *cmacaes; /* block-cipher based MAC function */
>         struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
>         struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
>         struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
> +       struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
>  };
>
>  /* per smb session structure/fields */
>
> --
> Thanks,
>
> Steve
