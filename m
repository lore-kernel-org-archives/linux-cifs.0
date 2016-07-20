From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix crash due to race in hmac(md5) handling
Date: Wed, 20 Jul 2016 14:57:29 +0100
Message-ID: <1469023049.4942.21.camel@redhat.com>
References: <1468913181-28163-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468913181-28163-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-07-19 at 09:26 +0200, Rabin Vincent wrote:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>=20
> The secmech hmac(md5) structures are present in the TCP_Server_Info
> struct and can be shared among multiple CIFS sessions.=C2=A0=C2=A0How=
ever, the
> server mutex is not currently held when these structures are
> allocated
> and used, which can lead to a kernel crashes, as in the scenario
> below:
>=20
> mount.cifs(8) #1				mount.cifs(8) #2
>=20
> Is secmech.sdeschmaccmd5 allocated?
> // false
>=20
> 						Is
> secmech.sdeschmaccmd5 allocated?
> 						// false
>=20
> secmech.hmacmd =3D crypto_alloc_shash..
> secmech.sdeschmaccmd5 =3D kzalloc..
> sdeschmaccmd5->shash.tfm =3D &secmec.hmacmd;
>=20
> 						secmech.sdeschmaccmd5 =3D
> kzalloc
> 						// sdeschmaccmd5-
> >shash.tfm
> 						// not yet assigned
>=20
> crypto_shash_update()
> =C2=A0deref NULL sdeschmaccmd5->shash.tfm
>=20
> =C2=A0Unable to handle kernel paging request at virtual address 00000=
030
> =C2=A0epc=C2=A0=C2=A0=C2=A0: 8027ba34 crypto_shash_update+0x38/0x158
> =C2=A0ra=C2=A0=C2=A0=C2=A0=C2=A0: 8020f2e8 setup_ntlmv2_rsp+0x4bc/0xa=
84
> =C2=A0Call Trace:
> =C2=A0 crypto_shash_update+0x38/0x158
> =C2=A0 setup_ntlmv2_rsp+0x4bc/0xa84
> =C2=A0 build_ntlmssp_auth_blob+0xbc/0x34c
> =C2=A0 sess_auth_rawntlmssp_authenticate+0xac/0x248
> =C2=A0 CIFS_SessSetup+0xf0/0x178
> =C2=A0 cifs_setup_session+0x4c/0x84
> =C2=A0 cifs_get_smb_ses+0x2c8/0x314
> =C2=A0 cifs_mount+0x38c/0x76c
> =C2=A0 cifs_do_mount+0x98/0x440
> =C2=A0 mount_fs+0x20/0xc0
> =C2=A0 vfs_kern_mount+0x58/0x138
> =C2=A0 do_mount+0x1e8/0xccc
> =C2=A0 SyS_mount+0x88/0xd4
> =C2=A0 syscall_common+0x30/0x54
>=20
> Fix this by locking the srv_mutex around the code which uses these
> hmac(md5) structures.=C2=A0=C2=A0All the other secmech algos already =
have
> similar
> locking.
>=20
> Fixes: 95dc8dd14e2e84cc ("Limit allocation of crypto mechanisms to
> dialect which requires")
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>

Looks correct.=C2=A0

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Rabin, do you have a reliable reproducer for this case? If yes, can you
please point me to it.

Sachin Prabhu
> ---
> =C2=A0fs/cifs/cifsencrypt.c | 16 ++++++++++------
> =C2=A01 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 6aeb8d4..8347c90 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -743,24 +743,26 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0
> =C2=A0	memcpy(ses->auth_key.response + baselen, tiblob, tilen);
> =C2=A0
> +	mutex_lock(&ses->server->srv_mutex);
> +
> =C2=A0	rc =3D crypto_hmacmd5_alloc(ses->server);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "could not crypto alloc hmacmd5 rc
> %d\n", rc);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	/* calculate ntlmv2_hash */
> =C2=A0	rc =3D calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "could not get v2 hash rc %d\n", rc);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	/* calculate first part of the client response (CR1) */
> =C2=A0	rc =3D CalcNTLMv2_response(ses, ntlmv2_hash);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "Could not calculate CR1 rc: %d\n",
> rc);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	/* now calculate the session key for NTLMv2 */
> @@ -769,13 +771,13 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a
> key\n",
> =C2=A0			=C2=A0__func__);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	rc =3D crypto_shash_init(&ses->server->secmech.sdeschmacmd5-
> >shash);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "%s: Could not init hmacmd5\n",
> __func__);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	rc =3D crypto_shash_update(&ses->server->secmech.sdeschmacmd5-
> >shash,
> @@ -783,7 +785,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0		CIFS_HMAC_MD5_HASH_SIZE);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "%s: Could not update with
> response\n", __func__);
> -		goto setup_ntlmv2_rsp_ret;
> +		goto unlock;
> =C2=A0	}
> =C2=A0
> =C2=A0	rc =3D crypto_shash_final(&ses->server->secmech.sdeschmacmd5-
> >shash,
> @@ -791,6 +793,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0	if (rc)
> =C2=A0		cifs_dbg(VFS, "%s: Could not generate md5 hash\n",
> __func__);
> =C2=A0
> +unlock:
> +	mutex_unlock(&ses->server->srv_mutex);
> =C2=A0setup_ntlmv2_rsp_ret:
> =C2=A0	kfree(tiblob);
> =C2=A0
