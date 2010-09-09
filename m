From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH 4/8] ntlmv2/ntlmssp define, declare, and use crypto hash functions
Date: Thu, 9 Sep 2010 11:13:45 -0500
Message-ID: <AANLkTinAA+5aXp0mO=h4f3TiLrL6PR4Uu_DHw2Ched3J@mail.gmail.com>
References: <1283921151-13090-1-git-send-email-shirishpargaonkar@gmail.com>
	<4C88CC52.7080303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <4C88CC52.7080303@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Sep 9, 2010 at 7:00 AM, Suresh Jayaraman <sjayaraman@suse.de> w=
rote:
> On 09/08/2010 10:15 AM, shirishpargaonkar@gmail.com wrote:
>> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>>
>>
>> Allocate crypto hashing functions, ecurity descriptiors, and respect=
ive
>> contexts when a smb/tcp connection is established.
>> Release them when a tcp/smb connection is taken down.
>>
>> md5 and hmac-md5 are two crypto hashing functions that are used
>> throught the life of an smb/tcp connection by various functions that
>> calcualte signagure and ntlmv2 hash, HMAC etc.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 71 ++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 16 +++++++++--
>> =A03 files changed, 86 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 4bdcf13..4772c4d 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -369,3 +369,74 @@ void CalcNTLMv2_response(const struct cifsSesIn=
fo *ses,
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> =A0}
>> +
>> +void
>> +cifs_crypto_shash_release(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 if (server->secmech.md5)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->secmech.md5);
>> +
>> + =A0 =A0 if (server->secmech.hmacmd5)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->secmech.hmacmd5)=
;
>> +
>> + =A0 =A0 kfree(server->secmech.sdeschmacmd5);
>> +
>> + =A0 =A0 kfree(server->secmech.sdescmd5);
>> +}
>> +
>> +int
>> +cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned int size;
>> +
>> + =A0 =A0 server->secmech.hmacmd5 =3D crypto_alloc_shash("hmac(md5)"=
, 0, 0);
>> + =A0 =A0 if (!server->secmech.hmacmd5 ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IS_ERR(server->secmech.hma=
cmd5)) {
>
> crypto_alloc_hash() seems to return a pointer to struct crypto_shash.
> Would it be sufficient to use IS_ERR() to check?

Suresh, not sure I understand, I check for NULL value of what
crypto_alloc_shash()
returns.  IS_ERR() is what crypto code is using.
Copying crypto folks on the this thread.

>
> Also, instead of returning 1, we should use PTR_ERR() to propagate th=
e
> appropriate error back. Otherwise, rc will always be 1 which gives
> little clue in case of error..

Done.

>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto hmacm=
d5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 server->secmech.md5 =3D crypto_alloc_shash("md5", 0, 0);
>> + =A0 =A0 if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto md5\n=
");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
>
> ditto here..

Done here too.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret1;
>
> nit: the goto labels could use better names..?

OK, will make them more meaningful in the next iteration.

>
>> + =A0 =A0 }
>
>> +
>> + =A0 =A0 size =3D sizeof(struct shash_desc) +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_descsize(serv=
er->secmech.hmacmd5);
>> + =A0 =A0 server->secmech.sdeschmacmd5 =3D kmalloc(size, GFP_KERNEL)=
;
>> + =A0 =A0 if (!server->secmech.sdeschmacmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: can=
't alloc hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret2;
>> + =A0 =A0 }
>> + =A0 =A0 server->secmech.sdeschmacmd5->shash.tfm =3D server->secmec=
h.hmacmd5;
>> + =A0 =A0 server->secmech.sdeschmacmd5->shash.flags =3D 0x0;
>> +
>> +
>> + =A0 =A0 size =3D sizeof(struct shash_desc) +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_descsize(serv=
er->secmech.md5);
>> + =A0 =A0 server->secmech.sdescmd5 =3D kmalloc(size, GFP_KERNEL);
>> + =A0 =A0 if (!server->secmech.sdescmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: can=
't alloc md5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret3;
>> + =A0 =A0 }
>> + =A0 =A0 server->secmech.sdescmd5->shash.tfm =3D server->secmech.md=
5;
>> + =A0 =A0 server->secmech.sdescmd5->shash.flags =3D 0x0;
>> +
>> + =A0 =A0 return 0;
>> +
>> +cifs_crypto_shash_allocate_ret3:
>> + =A0 =A0 kfree(server->secmech.sdeschmacmd5);
>> +
>> +cifs_crypto_shash_allocate_ret2:
>> + =A0 =A0 crypto_free_shash(server->secmech.md5);
>> +
>> +cifs_crypto_shash_allocate_ret1:
>> + =A0 =A0 crypto_free_shash(server->secmech.hmacmd5);
>> +
>> + =A0 =A0 return rc;
>> +}
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index eadf78c..fa3716c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -368,6 +368,8 @@ extern int cifs_calculate_mac_key(struct session=
_key *key, const char *rn,
>> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, char =
*);
>> =A0extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool enc=
rypt, char *lnm_session_key);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 0ea52e9..f5369e7 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1520,6 +1520,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *s=
erver)
>> =A0 =A0 =A0 server->tcpStatus =3D CifsExiting;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> + =A0 =A0 cifs_crypto_shash_release(server);
>> =A0 =A0 =A0 cifs_fscache_release_client_cookie(server);
>>
>> =A0 =A0 =A0 task =3D xchg(&server->tsk, NULL);
>> @@ -1574,10 +1575,16 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 rc =3D cifs_crypto_shash_allocate(tcp_ses);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not setup hash structures=
 rc %d", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 tcp_ses->hostname =3D extract_hostname(volume_info->UNC)=
;
>> =A0 =A0 =A0 if (IS_ERR(tcp_ses->hostname)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(tcp_ses->hostname);
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
>> @@ -1618,7 +1625,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 if (rc < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error connecting to socket. A=
borting operation");
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /*
>> @@ -1632,7 +1639,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(tcp_ses->tsk);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d create cifsd thread"=
, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 module_put(THIS_MODULE);
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* thread spawned, put it on the list */
>> @@ -1644,6 +1651,9 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>>
>> =A0 =A0 =A0 return tcp_ses;
>>
>> +out_err2:
>> + =A0 =A0 cifs_crypto_shash_release(tcp_ses);
>> +
>> =A0out_err:
>> =A0 =A0 =A0 if (tcp_ses) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!IS_ERR(tcp_ses->hostname))
>
>
> --
> Suresh Jayaraman
>
