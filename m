From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix crash due to race in hmac(md5) handling
Date: Wed, 20 Jul 2016 10:54:06 -0500
Message-ID: <CAH2r5msyGELA5k1Xa++eJZxtqctvnwfPOPb0ygShd5eBRxTyqA@mail.gmail.com>
References: <1468913181-28163-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468913181-28163-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

pushed to cifs-2.6.git for-next

added cc: stable

On Tue, Jul 19, 2016 at 2:26 AM, Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org> wrote:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>
> The secmech hmac(md5) structures are present in the TCP_Server_Info
> struct and can be shared among multiple CIFS sessions.  However, the
> server mutex is not currently held when these structures are allocated
> and used, which can lead to a kernel crashes, as in the scenario below:
>
> mount.cifs(8) #1                                mount.cifs(8) #2
>
> Is secmech.sdeschmaccmd5 allocated?
> // false
>
>                                                 Is secmech.sdeschmaccmd5 allocated?
>                                                 // false
>
> secmech.hmacmd = crypto_alloc_shash..
> secmech.sdeschmaccmd5 = kzalloc..
> sdeschmaccmd5->shash.tfm = &secmec.hmacmd;
>
>                                                 secmech.sdeschmaccmd5 = kzalloc
>                                                 // sdeschmaccmd5->shash.tfm
>                                                 // not yet assigned
>
> crypto_shash_update()
>  deref NULL sdeschmaccmd5->shash.tfm
>
>  Unable to handle kernel paging request at virtual address 00000030
>  epc   : 8027ba34 crypto_shash_update+0x38/0x158
>  ra    : 8020f2e8 setup_ntlmv2_rsp+0x4bc/0xa84
>  Call Trace:
>   crypto_shash_update+0x38/0x158
>   setup_ntlmv2_rsp+0x4bc/0xa84
>   build_ntlmssp_auth_blob+0xbc/0x34c
>   sess_auth_rawntlmssp_authenticate+0xac/0x248
>   CIFS_SessSetup+0xf0/0x178
>   cifs_setup_session+0x4c/0x84
>   cifs_get_smb_ses+0x2c8/0x314
>   cifs_mount+0x38c/0x76c
>   cifs_do_mount+0x98/0x440
>   mount_fs+0x20/0xc0
>   vfs_kern_mount+0x58/0x138
>   do_mount+0x1e8/0xccc
>   SyS_mount+0x88/0xd4
>   syscall_common+0x30/0x54
>
> Fix this by locking the srv_mutex around the code which uses these
> hmac(md5) structures.  All the other secmech algos already have similar
> locking.
>
> Fixes: 95dc8dd14e2e84cc ("Limit allocation of crypto mechanisms to dialect which requires")
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 6aeb8d4..8347c90 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -743,24 +743,26 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>
>         memcpy(ses->auth_key.response + baselen, tiblob, tilen);
>
> +       mutex_lock(&ses->server->srv_mutex);
> +
>         rc = crypto_hmacmd5_alloc(ses->server);
>         if (rc) {
>                 cifs_dbg(VFS, "could not crypto alloc hmacmd5 rc %d\n", rc);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         /* calculate ntlmv2_hash */
>         rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
>         if (rc) {
>                 cifs_dbg(VFS, "could not get v2 hash rc %d\n", rc);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         /* calculate first part of the client response (CR1) */
>         rc = CalcNTLMv2_response(ses, ntlmv2_hash);
>         if (rc) {
>                 cifs_dbg(VFS, "Could not calculate CR1 rc: %d\n", rc);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         /* now calculate the session key for NTLMv2 */
> @@ -769,13 +771,13 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
>                          __func__);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> @@ -783,7 +785,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>                 CIFS_HMAC_MD5_HASH_SIZE);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
> -               goto setup_ntlmv2_rsp_ret;
> +               goto unlock;
>         }
>
>         rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
> @@ -791,6 +793,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>         if (rc)
>                 cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
>
> +unlock:
> +       mutex_unlock(&ses->server->srv_mutex);
>  setup_ntlmv2_rsp_ret:
>         kfree(tiblob);
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
