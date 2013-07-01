From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Limiting allocation of smb2 crypto structs to smb2 mounts
Date: Sun, 30 Jun 2013 22:55:23 -0500
Message-ID: <CADT32eL69Kms70ko-K7M_t=nPESv1i_E-2j+Nc2bWA+j+JA+Bw@mail.gmail.com>
References: <CAH2r5msin0gn6xDGgm9b7nejUY20wxJKcEFRakPc9QF0FR3r9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msin0gn6xDGgm9b7nejUY20wxJKcEFRakPc9QF0FR3r9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jun 30, 2013 at 2:10 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Updated patch to try to prevent allocation of smb2 or smb3 crypto
> secmech structures unless needed.  There is probably more updates that
> could be done to cleanup cifs - but the more important part is to get
> the smb2/smb3 part cleaned up.
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 3d8bf94..e0d94e1 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -745,20 +745,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>                 goto crypto_allocate_md5_fail;
>         }
>
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
>         size = sizeof(struct shash_desc) +
>                         crypto_shash_descsize(server->secmech.hmacmd5);
>         server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> @@ -779,45 +765,12 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>         server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
>         server->secmech.sdescmd5->shash.flags = 0x0;
>
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
>         return 0;
>
> -crypto_allocate_cmacaes_sdesc_fail:
> -       kfree(server->secmech.sdeschmacsha256);
> -
> -crypto_allocate_hmacsha256_sdesc_fail:
> -       kfree(server->secmech.sdescmd5);
> -
>  crypto_allocate_md5_sdesc_fail:
>         kfree(server->secmech.sdeschmacmd5);
>
>  crypto_allocate_hmacmd5_sdesc_fail:
> -       crypto_free_shash(server->secmech.cmacaes);
> -
> -crypto_allocate_cmacaes_fail:
> -       crypto_free_shash(server->secmech.hmacsha256);
> -
> -crypto_allocate_hmacsha256_fail:
>         crypto_free_shash(server->secmech.md5);
>
>  crypto_allocate_md5_fail:
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index afcb8a1..aa5bf23 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2108,14 +2108,15 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                 goto out_err;
>         }
>
> +       tcp_ses->ops = volume_info->ops;
> +       tcp_ses->vals = volume_info->vals;
> +
>         rc = cifs_crypto_shash_allocate(tcp_ses);
>         if (rc) {
>                 cifs_dbg(VFS, "could not setup hash structures rc %d\n", rc);
>                 goto out_err;
>         }
>
> -       tcp_ses->ops = volume_info->ops;
> -       tcp_ses->vals = volume_info->vals;
>         cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
>         tcp_ses->hostname = extract_hostname(volume_info->UNC);
>         if (IS_ERR(tcp_ses->hostname)) {
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 09b4fba..ca9d66e 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -39,6 +39,65 @@
>  #include "smb2status.h"
>  #include "smb2glob.h"
>
> +static int
> +smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +       unsigned int size;
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
> +       rc = smb2_crypto_shash_allocate(server);
> +       if (rc)
> +               return rc;
> +
> +       server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> +       if (IS_ERR(server->secmech.cmacaes)) {
> +               cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> +               kfree(server->secmech.sdeschmacsha256);
> +               crypto_free_shash(server->secmech.hmacsha256);
> +               return PTR_ERR(server->secmech.cmacaes);
> +       }
> +
> +       size = sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(server->secmech.cmacaes);
> +       server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> +       if (!server->secmech.sdesccmacaes) {
> +               cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> +               kfree(server->secmech.sdeschmacsha256);
> +               crypto_free_shash(server->secmech.hmacsha256);
> +               crypto_free_shash(server->secmech.cmacaes);
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
> @@ -52,6 +111,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>         memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>
> +       if (server->secmech.hmacsha256 == NULL)
> +               smb2_crypto_shash_allocate(server);
> +

I think we should check for error here

>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>         if (rc) {
> @@ -129,6 +191,10 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
>         memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
>         memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
>
> +       /* SMB3 essentially requires signing so no harm allocating it early */
> +       if (server->secmech.hmacsha256 == NULL)
> +               smb3_crypto_shash_allocate(server);
> +

This should be smb2_crypto_shash_allocate(sever), with error checked.

>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>         if (rc) {
> @@ -210,6 +276,9 @@ smb3_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>                 return rc;
>         }
>
> +       /* we already allocate sdesccmacaes when we init smb3 signing key,
> +          so unlike smb2 we do not have to check here if secmech
> +          are initialized */

I do not see code to allocate cmac-aes.  I think we should do it in
function smb3_calc_signature.  cmac-aes is not needed to generate the
smb3 signing key.
So there should be this call with error checked.

          if (server->secmech.cmacaes == NULL)
             smb3_crypto_shash_allocate(server);

>         rc = crypto_shash_init(&server->secmech.sdesccmacaes->shash);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
>
> On Sun, Jun 30, 2013 at 5:25 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Sat, 29 Jun 2013 23:06:12 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> if we setup a socket we send a negotiate protocol
>>> and decide on the smb version at that point.  If we mount a second
>>> user to the same server, he will use the same socket and thus the same
>>> dialect that we did the first mount on - i don't know a way to mix
>>> multiple dialects on the same socket and I don't think we should.
>>>
>> In any case...match_server does this:
>>
>>         if ((server->vals != vol->vals) || (server->ops != vol->ops))
>>                 return 0;
>>
>> ...which should make it impossible to share sockets when the versions
>> don't match. In principle, I guess we could probably share sockets
>> between (for instance) 2.1 and 2.002, but that's an optimization that
>> could be done later.
>
> I also don't think that that is a good idea to change the dialect of a user of
> the socket on the fly.   We will send the negotiate and decide on the dialect
> when connecting to the socket(s), and each subsequent user will
> create an new smb2/smb3 session on the same socket, thus with
> the same smb2 dialect. I don't think there is any case where you expect
> the server to change from smb2.1 to smb3 or to smb3.02 without
> dropping the tcp session) - although I am open to the idea of allowing
> "upgrading security on the fly" to mandate signing (or encryption) on the
> fly if security needs change due to an emergency.
>
>
>
>> The way the crypto is allocated is a serious wart. The algorithms are
>> being allocated too early. It would be preferable even to delay
>> allocating the crypto stuff at all until it's actually needed.
>
> Well - the patch I proposed at least allocates the smb2 ones
> when we have negotiated smb2 or smb2.1, and smb3 ones when
> smb3 or smb3.02 is negotiated.  The alternative is fine with me,
> but means checking on EVERY signing request (since you
> don't have to have signing on the first request(s) but then end
> up signing a later one - e.g. for the case of secure renogotiate)
>
>> If, for instance I mount with sec=krb5 and don't request signing,
>> there's no need to allocate any of this stuff. This is not harmless
>> either. We have at least one customer that boots their machines with
>> fips=1. They're basically unable to use cifs.ko at all currently
>> because the crypto allocations fail.
>
> OK - that is a good point.
>
>
> --
> Thanks,
>
> Steve
