From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/8 Rev2] ntlmv2/ntlmssp generate secondary session key
 and ciphertext and send it if signing enabled
Date: Wed, 8 Sep 2010 14:18:15 -0500
Message-ID: <AANLkTinM5wkNK-qimKqUKnYWjysjnY8u8dcDjxGpBh4o@mail.gmail.com>
References: <1283965478-19009-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100908132540.4988e167@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100908132540.4988e167-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 8, 2010 at 12:25 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> =
wrote:
> On Wed, =A08 Sep 2010 12:04:38 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> A key is exchanged with the server if client indicates so in flags i=
n
>> type 1 messsage and server agrees in flag in type 2 message of ntlms=
sp
>> negotiation. =A0If both client and agree, a key sent by client in
>> type 3 message of ntlmssp negotiation in the session key field.
>> The key is a ciphertext generated off of secondary key, a nonce, usi=
ng
>> ntlmv2 hash via rc4/arc4. ciphertext is calculated within a mutex lo=
ck.
>>
>> If authentication is successful, the secondary key is the that clien=
t
>> uses to calculate cifs/smb signature in the messages that client sen=
ds
>> and to verify the messages sent by server.
>> This key stays with the smb connection for its life and is the key u=
sed
>> to generate (and verify) signatures for all the subsequent smb sessi=
ons
>> for this smb connection.
>>
>> So only for the first smb session on any smb connection, type 1 mess=
age
>> of ntlmssp negotiation selects the flag NTLMSSP_NEGOTIATE_KEY_XCH.
>> It is not used for subsequent smb sessions on this smb connection i.=
e.
>> no need to generate secondary key, create ciphertext and send it etc=
=2E
>>
>> After the very first successful smb session, sequence number gets se=
t
>> to 0 and =A0variable cphready is used to mark that the key calculati=
ons
>> are done, this is done within a mutex lock.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 52 ++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A01 +
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A01 +
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 24 +++++++++++++++++-----
>> =A04 files changed, 72 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index f9c140a..197fc85 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -470,6 +470,58 @@ void CalcNTLMv2_response(const struct cifsSesIn=
fo *ses,
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> =A0}
>>
>> +int
>> +calc_seckey(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct crypto_blkcipher *tfm_arc4;
>> + =A0 =A0 struct scatterlist sgin, sgout;
>> + =A0 =A0 struct blkcipher_desc desc;
>> +
>> + =A0 =A0 if (!server) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't determine ciphertext =
key\n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 mutex_lock(&server->srv_mutex);
>> + =A0 =A0 if (server->cphready) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 get_random_bytes(server->ntlmssp.sec_key, CIFS_NTLMV2_SESS=
KEY_SIZE);
>> +
>> + =A0 =A0 tfm_arc4 =3D crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO=
_ALG_ASYNC);
>> + =A0 =A0 if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate arc4 crypto =
function\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 desc.tfm =3D tfm_arc4;
>> +
>> + =A0 =A0 crypto_blkcipher_setkey(tfm_arc4, server->session_key.data=
=2Entlmv2.key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 CIFS_CPHTXT_SIZE);
>> +
>> + =A0 =A0 sg_init_one(&sgin, server->ntlmssp.sec_key, CIFS_CPHTXT_SI=
ZE);
>> + =A0 =A0 sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CPHTX=
T_SIZE);
>> +
>> + =A0 =A0 rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS=
_CPHTXT_SIZE);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt session key r=
c: %d\n", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 crypto_free_blkcipher(tfm_arc4);
>> +
>> + =A0 =A0 server->sequence_number =3D 0;
>> + =A0 =A0 server->cphready =3D true;
>> + =A0 =A0 mutex_unlock(&server->srv_mutex);
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0void
>> =A0cifs_crypto_shash_release(struct TCP_Server_Info *server)
>> =A0{
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index fbfdd8e..b78bb77 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -370,6 +370,7 @@ extern int setup_ntlmv2_rsp(struct cifsSesInfo *=
, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> +extern int calc_seckey(struct TCP_Server_Info *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool enc=
rypt, char *lnm_session_key);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 0621a72..e3883f3 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1587,6 +1587,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 tcp_ses->cphready =3D false;
>
> I see that you're setting this when you spawn a new tcp session. What
> about reconnects though? Don't you also need to set this to false whe=
n
> the socket needs to be reconnected?
>
>> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
>> =A0 =A0 =A0 tcp_ses->noautotune =3D volume_info->noautotune;
>> =A0 =A0 =A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nodela=
y;
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 68ea153..7c94d7b 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -444,10 +444,12 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> - =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED | S=
ECMODE_SIGN_ENABLED)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> - =A0 =A0 if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
>> - =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->cphready)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIA=
TE_KEY_XCH |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NE=
GOTIATE_EXTENDED_SEC;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>>
>> @@ -554,9 +556,19 @@ static int build_ntlmssp_auth_blob(unsigned cha=
r *pbuffer,
>> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>> =A0 =A0 =A0 tmp +=3D 2;
>>
>> - =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp - pb=
uffer);
>> - =A0 =A0 sec_blob->SessionKey.Length =3D 0;
>> - =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
>> + =A0 =A0 if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTIATE=
_KEY_XCH) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses->server))=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->ntlmssp.ciphertex=
t, CIFS_CPHTXT_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to_le1=
6(CIFS_CPHTXT_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_CPHTXT_SI=
ZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D CIFS_CPHTXT_SIZE;
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
>> + =A0 =A0 }
>>
>> =A0setup_ntlmv2_ret:
>> =A0 =A0 =A0 return tmp - pbuffer;
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Jeff, yes.  I think this patch should take care of that

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e3883f3..aa40f1a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -199,6 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
                        if (server->tcpStatus !=3D CifsExiting)
                                server->tcpStatus =3D CifsGood;
                        server->sequence_number =3D 0;
+                       server->cphready =3D false;
                        spin_unlock(&GlobalMid_Lock);
        /*              atomic_set(&server->inFlight,0);*/
                        wake_up(&server->response_q);

I will respin this patch (7/8) again with that change in.
