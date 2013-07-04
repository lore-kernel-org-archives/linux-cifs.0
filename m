From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Limit allocation of crypto mechanisms to when we
 need it for a particular dialect [version 2]
Date: Thu, 4 Jul 2013 05:04:42 -0500
Message-ID: <CADT32eKurZHmb-T2rdMMBn2+Vm3aHLTLPy6yOoUW4skHomcMEw@mail.gmail.com>
References: <CAH2r5muf77vV9b4X+0U6Kv57XNPfxcCHAy7+hHtt_Fu96o+PzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muf77vV9b4X+0U6Kv57XNPfxcCHAy7+hHtt_Fu96o+PzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 3, 2013 at 11:57 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Updated patch based on Jeff's feedback
>
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Wed, 3 Jul 2013 23:52:11 -0500
> Subject: [PATCH] [CIFS] Limit allocation of crypto mechanisms to dialect
>  which requires it
>
> Updated patch to try to prevent allocation of cifs, smb2 or smb3 crypto
> secmech structures unless needed.  Currently cifs allocates all crypto
> mechanisms when the first session is established (4 functions and
> 4 contexts), rather than only allocating these when needed (smb3 needs
> two, the rest of the dialects only need one).
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c   | 195 +++++++++++++++++++++---------------------------
>  fs/cifs/cifsproto.h     |   1 -
>  fs/cifs/connect.c       |   6 --
>  fs/cifs/smb2transport.c |  92 ++++++++++++++++++++++-
>  4 files changed, 176 insertions(+), 118 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 3d8bf94..a95ee91 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -1,7 +1,7 @@
>  /*
>   *   fs/cifs/cifsencrypt.c
>   *
> - *   Copyright (C) International Business Machines  Corp., 2005,2006
> + *   Copyright (C) International Business Machines  Corp., 2005,2013
>   *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>   *
>   *   This library is free software; you can redistribute it and/or modify
> @@ -31,6 +31,36 @@
>  #include <linux/random.h>
>  #include <linux/highmem.h>
>
> +static int
> +cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
> +{
> +       int rc;
> +       unsigned int size;
> +
> +       if (server->secmech.sdescmd5 != NULL)
> +               return 0; /* already allocated */
> +
> +       server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> +       if (IS_ERR(server->secmech.md5)) {
> +               cifs_dbg(VFS, "could not allocate crypto md5\n");
> +               return PTR_ERR(server->secmech.md5);
> +       }
> +
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.md5);
> +       server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdescmd5) {
> +               rc = -ENOMEM;
> +               crypto_free_shash(server->secmech.md5);
> +               server->secmech.md5 = NULL;
> +               return rc;
> +       }
> +       server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> +       server->secmech.sdescmd5->shash.flags = 0x0;
> +
> +       return 0;
> +}
> +
>  /*
>   * Calculate and return the CIFS signature based on the mac key and SMB PDU.
>   * The 16 byte signature must be allocated by the caller. Note we only use the
> @@ -50,8 +80,11 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
>                 return -EINVAL;
>
>         if (!server->secmech.sdescmd5) {
> -               cifs_dbg(VFS, "%s: Can't generate signature\n", __func__);
> -               return -1;
> +               rc = cifs_crypto_shash_md5_allocate(server);
> +               if (rc) {
> +                       cifs_dbg(VFS, "%s: Can't alloc md5 crypto\n", __func__);
> +                       return -1;
> +               }
>         }
>
>         rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
> @@ -556,6 +589,33 @@ CalcNTLMv2_response(const struct cifs_ses *ses,
> char *ntlmv2_hash)
>         return rc;
>  }
>
> +static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
> +{
> +       unsigned int size;
> +
> +       /* check if already allocated */
> +       if (server->secmech.sdeschmacmd5)
> +               return 0;
> +
> +       server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
> +       if (IS_ERR(server->secmech.hmacmd5)) {
> +               cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
> +               return PTR_ERR(server->secmech.hmacmd5);
> +       }
> +
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.hmacmd5);
> +       server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdeschmacmd5) {
> +               crypto_free_shash(server->secmech.hmacmd5);
> +               server->secmech.hmacmd5 = NULL;
> +               return -ENOMEM;
> +       }
> +       server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
> +       server->secmech.sdeschmacmd5->shash.flags = 0x0;
> +
> +       return 0;
> +}
>
>  int
>  setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
> @@ -606,6 +666,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
>
>         memcpy(ses->auth_key.response + baselen, tiblob, tilen);
>
> +       rc = crypto_hmacmd5_alloc(ses->server);
> +       if (rc) {
> +               cifs_dbg(VFS, "could not crypto alloc md5 rc %d\n", rc);
> +               goto setup_ntlmv2_rsp_ret;
> +       }

This does not seem right.
1) The comment should be changed to state hmacmd5
2) We would fail ntlmv2/ntlmssp authentications for all subsequent
     sessions on this connection since hmac md5 crypto resource
     would have been allocated during first session.

> +
>         /* calculate ntlmv2_hash */
>         rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
>         if (rc) {
> @@ -705,123 +771,32 @@ calc_seckey(struct cifs_ses *ses)
>  void
>  cifs_crypto_shash_release(struct TCP_Server_Info *server)
>  {
> -       if (server->secmech.cmacaes)
> +       if (server->secmech.cmacaes) {
>                 crypto_free_shash(server->secmech.cmacaes);
> +               server->secmech.cmacaes = NULL;
> +       }
>
> -       if (server->secmech.hmacsha256)
> +       if (server->secmech.hmacsha256) {
>                 crypto_free_shash(server->secmech.hmacsha256);
> +               server->secmech.hmacsha256 = NULL;
> +       }
>
> -       if (server->secmech.md5)
> +       if (server->secmech.md5) {
>                 crypto_free_shash(server->secmech.md5);
> +               server->secmech.md5 = NULL;
> +       }
>
> -       if (server->secmech.hmacmd5)
> +       if (server->secmech.hmacmd5) {
>                 crypto_free_shash(server->secmech.hmacmd5);
> +               server->secmech.hmacmd5 = NULL;
> +       }
>
>         kfree(server->secmech.sdesccmacaes);
> -
> +       server->secmech.sdesccmacaes = NULL;
>         kfree(server->secmech.sdeschmacsha256);
> -
> +       server->secmech.sdeschmacsha256 = NULL;
>         kfree(server->secmech.sdeschmacmd5);
> -
> +       server->secmech.sdeschmacmd5 = NULL;
>         kfree(server->secmech.sdescmd5);
> -}
> -
> -int
> -cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
> -{
> -       int rc;
> -       unsigned int size;
> -
> -       server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
> -       if (IS_ERR(server->secmech.hmacmd5)) {
> -               cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
> -               return PTR_ERR(server->secmech.hmacmd5);
> -       }
> -
> -       server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> -       if (IS_ERR(server->secmech.md5)) {
> -               cifs_dbg(VFS, "could not allocate crypto md5\n");
> -               rc = PTR_ERR(server->secmech.md5);
> -               goto crypto_allocate_md5_fail;
> -       }
> -
> -       server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
> -       if (IS_ERR(server->secmech.hmacsha256)) {
> -               cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
> -               rc = PTR_ERR(server->secmech.hmacsha256);
> -               goto crypto_allocate_hmacsha256_fail;
> -       }
> -
> -       server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> -       if (IS_ERR(server->secmech.cmacaes)) {
> -               cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> -               rc = PTR_ERR(server->secmech.cmacaes);
> -               goto crypto_allocate_cmacaes_fail;
> -       }
> -
> -       size = sizeof(struct shash_desc) +
> -                       crypto_shash_descsize(server->secmech.hmacmd5);
> -       server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> -       if (!server->secmech.sdeschmacmd5) {
> -               rc = -ENOMEM;
> -               goto crypto_allocate_hmacmd5_sdesc_fail;
> -       }
> -       server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
> -       server->secmech.sdeschmacmd5->shash.flags = 0x0;
> -
> -       size = sizeof(struct shash_desc) +
> -                       crypto_shash_descsize(server->secmech.md5);
> -       server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
> -       if (!server->secmech.sdescmd5) {
> -               rc = -ENOMEM;
> -               goto crypto_allocate_md5_sdesc_fail;
> -       }
> -       server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> -       server->secmech.sdescmd5->shash.flags = 0x0;
> -
> -       size = sizeof(struct shash_desc) +
> -                       crypto_shash_descsize(server->secmech.hmacsha256);
> -       server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
> -       if (!server->secmech.sdeschmacsha256) {
> -               rc = -ENOMEM;
> -               goto crypto_allocate_hmacsha256_sdesc_fail;
> -       }
> -       server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
> -       server->secmech.sdeschmacsha256->shash.flags = 0x0;
> -
> -       size = sizeof(struct shash_desc) +
> -                       crypto_shash_descsize(server->secmech.cmacaes);
> -       server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> -       if (!server->secmech.sdesccmacaes) {
> -               cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> -               rc = -ENOMEM;
> -               goto crypto_allocate_cmacaes_sdesc_fail;
> -       }
> -       server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
> -       server->secmech.sdesccmacaes->shash.flags = 0x0;
> -
> -       return 0;
> -
> -crypto_allocate_cmacaes_sdesc_fail:
> -       kfree(server->secmech.sdeschmacsha256);
> -
> -crypto_allocate_hmacsha256_sdesc_fail:
> -       kfree(server->secmech.sdescmd5);
> -
> -crypto_allocate_md5_sdesc_fail:
> -       kfree(server->secmech.sdeschmacmd5);
> -
> -crypto_allocate_hmacmd5_sdesc_fail:
> -       crypto_free_shash(server->secmech.cmacaes);
> -
> -crypto_allocate_cmacaes_fail:
> -       crypto_free_shash(server->secmech.hmacsha256);
> -
> -crypto_allocate_hmacsha256_fail:
> -       crypto_free_shash(server->secmech.md5);
> -
> -crypto_allocate_md5_fail:
> -       crypto_free_shash(server->secmech.hmacmd5);
> -
> -       return rc;
> +       server->secmech.sdescmd5 = NULL;
>  }
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index c8ff018..f7e584d 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -433,7 +433,6 @@ extern int SMBNTencrypt(unsigned char *, unsigned
> char *, unsigned char *,
>                         const struct nls_table *);
>  extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
>  extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
> -extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>  extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>  extern int calc_seckey(struct cifs_ses *);
>  extern void generate_smb3signingkey(struct TCP_Server_Info *);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index afcb8a1..fa68813 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2108,12 +2108,6 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                 goto out_err;
>         }
>
> -       rc = cifs_crypto_shash_allocate(tcp_ses);
> -       if (rc) {
> -               cifs_dbg(VFS, "could not setup hash structures rc %d\n", rc);
> -               goto out_err;
> -       }
> -
>         tcp_ses->ops = volume_info->ops;
>         tcp_ses->vals = volume_info->vals;
>         cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 09b4fba..aef8ff4 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -39,6 +39,77 @@
>  #include "smb2status.h"
>  #include "smb2glob.h"
>
> +static int
> +smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +       unsigned int size;
> +
> +       if (server->secmech.sdeschmacsha256 != NULL)
> +               return 0; /* already allocated */
> +
> +       server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
> +       if (IS_ERR(server->secmech.hmacsha256)) {
> +               cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
> +               return PTR_ERR(server->secmech.hmacsha256);
> +       }
> +
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.hmacsha256);
> +       server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdeschmacsha256) {
> +               crypto_free_shash(server->secmech.hmacsha256);
> +               server->secmech.hmacsha256 = NULL;
> +               return -ENOMEM;
> +       }
> +       server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
> +       server->secmech.sdeschmacsha256->shash.flags = 0x0;
> +
> +       return 0;
> +}
> +
> +static int
> +smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +       unsigned int size;
> +       int rc;
> +
> +       if (server->secmech.sdesccmacaes != NULL)
> +               return 0;  /* already allocated */
> +
> +       rc = smb2_crypto_shash_allocate(server);
> +       if (rc)
> +               return rc;
> +
> +       server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> +       if (IS_ERR(server->secmech.cmacaes)) {
> +               cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> +               kfree(server->secmech.sdeschmacsha256);
> +               server->secmech.sdeschmacsha256 = NULL;
> +               crypto_free_shash(server->secmech.hmacsha256);
> +               server->secmech.hmacsha256 = NULL;
> +               return PTR_ERR(server->secmech.cmacaes);
> +       }
> +
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.cmacaes);
> +       server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdesccmacaes) {
> +               cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> +               kfree(server->secmech.sdeschmacsha256);
> +               server->secmech.sdeschmacsha256 = NULL;
> +               crypto_free_shash(server->secmech.hmacsha256);
> +               crypto_free_shash(server->secmech.cmacaes);
> +               server->secmech.hmacsha256 = NULL;
> +               server->secmech.cmacaes = NULL;
> +               return -ENOMEM;
> +       }
> +       server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
> +       server->secmech.sdesccmacaes->shash.flags = 0x0;
> +
> +       return 0;
> +}
> +
> +
>  int
>  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  {
> @@ -52,6 +123,12 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>         memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>
> +       rc = smb2_crypto_shash_allocate(server);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: shah256 alloc failed\n", __func__);
> +               return rc;
> +       }
> +
>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>         if (rc) {
> @@ -61,7 +138,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>
>         rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
>         if (rc) {
> -               cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
> +               cifs_dbg(VFS, "%s: Could not init sha256", __func__);
>                 return rc;
>         }
>
> @@ -129,6 +206,14 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
>         memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
>         memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
>
> +       /* SMB3 essentially requires signing so no harm making sure needed
> +          sechmech (hmacsha256 and aes) are allocated now */
> +       rc = smb3_crypto_shash_allocate(server);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
> +               goto smb3signkey_ret;
> +       }
> +
>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>         if (rc) {
> @@ -210,6 +295,11 @@ smb3_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>                 return rc;
>         }
>
> +       /*
> +        * we already allocate sdesccmacaes when we init smb3 signing key,
> +        * so unlike smb2 case we do not have to check here if secmech are
> +        * initialized
> +        */
>         rc = crypto_shash_init(&server->secmech.sdesccmacaes->shash);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
> --
> 1.7.11.7
>
>
> --
> Thanks,
>
> Steve
