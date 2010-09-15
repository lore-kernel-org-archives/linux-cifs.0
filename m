From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v3 3/4 cifs] NTLMv2/NTLMSSP define crypto hash functions
 and create and send keys needed for key exchange
Date: Tue, 14 Sep 2010 22:38:14 -0500
Message-ID: <AANLkTik6DO7EVQ7cbG7Vnu3G=hw9kQBPDm5eqEqdVFWq@mail.gmail.com>
References: <1284405339-31226-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100914083358.45c05914@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100914083358.45c05914-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 14, 2010 at 7:33 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 13 Sep 2010 14:15:39 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Mark dependency on crypto modules in Kconfig.
>>
>> Defining per structures sdesc and cifs_secmech which are used to sto=
re
>> crypto hash functions and contexts. =A0They are stored per smb conne=
ction
>> and used for all auth mechs to genereate hash values and signatures.
>>
>> Allocate crypto hashing functions, security descriptiors, and respec=
tive
>> contexts when a smb/tcp connection is established.
>> Release them when a tcp/smb connection is taken down.
>>
>> md5 and hmac-md5 are two crypto hashing functions that are used
>> throught the life of an smb/tcp connection by various functions that
>> calcualte signagure and ntlmv2 hash, HMAC etc.
>>
>> structure ntlmssp_auth and filed cphready is defined as per smb conn=
ection.
>>
>> ntlmssp_auth holds secondary key which is a nonce that gets used as =
a key
>> to generate signatures, ciphertext is genereated by rc4/arc4 encrypt=
ion of
>> secondary key using ntlmv2 session key and sent in the session key f=
ield of
>> the type 3 message sent by the client during ntlmssp negotiation/exc=
hange
>> These are per session structures and secondary key and cipher text
>> get calculated only once per smb connection, during first smb sessio=
n setup
>> for that smb connection.
>>
>> Field cphready is used to mark such that once secondary keys and cip=
hertext
>> are calculated during very first smb session setup for a smb connect=
ion
>> and ciphertext is sent to the server, the same does not happen durin=
g
>> subsequent smb session setups/establishments.
>>
>> A key is exchanged with the server if client indicates so in flags i=
n
>> type 1 messsage and server agrees in flag in type 2 message of ntlms=
sp
>> negotiation. =A0If both client and agree, a key sent by client in
>> type 3 message of ntlmssp negotiation in the session key field.
>> The key is a ciphertext generated off of secondary key, a nonce, usi=
ng
>> ntlmv2 hash via rc4/arc4.
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
>> are done. cphready is reset when a reconnect of the smb connection
>> happens as sessions get set up again.
>>
>> Calculation of ciphertext and setting cphready, is done within
>> mutex lock to prevent race of smb session setups on a new smb connec=
tion.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig =A0 =A0 =A0 | =A0 =A03 +
>> =A0fs/cifs/cifsencrypt.c | =A0125 ++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 28 +++++++++++
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A03 +
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 18 ++++++-
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0125 ++++++++++++++++++++++++++=
+++++++++++-----------
>> =A07 files changed, 277 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 917b7d4..0ed2139 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -2,6 +2,9 @@ config CIFS
>> =A0 =A0 =A0 tristate "CIFS support (advanced network filesystem, SMB=
=46S successor)"
>> =A0 =A0 =A0 depends on INET
>> =A0 =A0 =A0 select NLS
>> + =A0 =A0 select CRYPTO
>> + =A0 =A0 select CRYPTO_MD5
>> + =A0 =A0 select CRYPTO_ARC4
>> =A0 =A0 =A0 help
>> =A0 =A0 =A0 =A0 This is the client VFS module for the Common Interne=
t File System
>> =A0 =A0 =A0 =A0 (CIFS) protocol which is the successor to the Server=
 Message Block
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 960c948..7fd3dcc 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -477,3 +477,128 @@ void CalcNTLMv2_response(const struct cifsSesI=
nfo *ses,
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> =A0}
>> +
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
>> + =A0 =A0 tfm_arc4 =3D crypto_alloc_blkcipher("ecb(arc4)",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 0, CRYPTO_ALG_ASYNC);
>> + =A0 =A0 if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto API a=
rc4\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(tfm_arc4);
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_blkcipher(tfm_arc4);
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto hmacm=
d5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(server->secmech.hmacmd5);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 server->secmech.md5 =3D crypto_alloc_shash("md5", 0, 0);
>> + =A0 =A0 if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto md5\n=
");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(server->secmech.md5);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto crypto_allocate_md5_fail;
>> + =A0 =A0 }
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto crypto_allocate_hmacmd5_sdesc_fail;
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto crypto_allocate_md5_sdesc_fail;
>> + =A0 =A0 }
>> + =A0 =A0 server->secmech.sdescmd5->shash.tfm =3D server->secmech.md=
5;
>> + =A0 =A0 server->secmech.sdescmd5->shash.flags =3D 0x0;
>> +
>> + =A0 =A0 return 0;
>> +
>> +crypto_allocate_md5_sdesc_fail:
>> + =A0 =A0 kfree(server->secmech.sdeschmacmd5);
>> +
>> +crypto_allocate_hmacmd5_sdesc_fail:
>> + =A0 =A0 crypto_free_shash(server->secmech.md5);
>> +
>> +crypto_allocate_md5_fail:
>> + =A0 =A0 crypto_free_shash(server->secmech.hmacmd5);
>> +
>> + =A0 =A0 return rc;
>> +}
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index c68f31c..c7da866 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -25,6 +25,9 @@
>> =A0#include <linux/workqueue.h>
>> =A0#include "cifs_fs_sb.h"
>> =A0#include "cifsacl.h"
>> +#include <crypto/internal/hash.h>
>> +#include <linux/scatterlist.h>
>> +
>> =A0/*
>> =A0 * The sizes of various internal tables and strings
>> =A0 */
>> @@ -109,6 +112,28 @@ struct session_key {
>> =A0 =A0 =A0 } data;
>> =A0};
>>
>> +/* crypto security descriptor definition */
>> +struct sdesc {
>> + =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 char ctx[];
>> +};
>> +
>> +/* crypto hashing related structure/fields, not speicific to a sec =
mech */
>> +struct cifs_secmech {
>> + =A0 =A0 struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
>> + =A0 =A0 struct crypto_shash *md5; /* md5 hash function */
>> + =A0 =A0 struct sdesc *sdeschmacmd5; =A0/* ctxt to generate ntlmv2 =
hash, CR1 */
>> + =A0 =A0 struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signa=
ture */
>> +};
>> +
>> +/* per smb connection structure/fields */
>> +struct ntlmssp_auth {
>> + =A0 =A0 __u32 client_flags; /* sent by client in type 1 ntlmsssp e=
xchange */
>> + =A0 =A0 __u32 server_flags; /* sent by server in type 2 ntlmssp ex=
change */
>> + =A0 =A0 unsigned char sec_key[CIFS_CPHTXT_SIZE]; /* a nonce client=
 generates */
>> + =A0 =A0 unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to ser=
ver */
>> +};
>> +
>> =A0struct cifs_cred {
>> =A0 =A0 =A0 int uid;
>> =A0 =A0 =A0 int gid;
>> @@ -187,6 +212,9 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> + =A0 =A0 struct cifs_secmech secmech; /* crypto sec mech functs, de=
scriptors */
>> + =A0 =A0 struct ntlmssp_auth ntlmssp; /* sec key, ciphertext, flags=
 */
>> + =A0 =A0 bool =A0 =A0cphready; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ciphe=
rtext is calculated */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* support=
s plain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* supports =
U2U Kerberos */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index b0f4b56..dc90a36 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -134,6 +134,13 @@
>> =A0 * Size of the session key (crypto key encrypted with the passwor=
d
>> =A0 */
>> =A0#define CIFS_SESS_KEY_SIZE (24)
>> +#define CIFS_CLIENT_CHALLENGE_SIZE (8)
>> +#define CIFS_SERVER_CHALLENGE_SIZE (8)
>> +#define CIFS_HMAC_MD5_HASH_SIZE (16)
>> +#define CIFS_CPHTXT_SIZE (16)
>> +#define CIFS_NTLMV2_SESSKEY_SIZE (16)
>> +#define CIFS_NTHASH_SIZE (16)
>> +
>>
>> =A0/*
>> =A0 * Maximum user name length
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index c155479..d89a87a 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -369,6 +369,9 @@ extern int cifs_calculate_session_key(struct ses=
sion_key *key, const char *rn,
>> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, char =
*);
>> =A0extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> +extern int calc_seckey(struct TCP_Server_Info *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool enc=
rypt, char *lnm_session_key);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index f8891a2..ffccd9f 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -199,6 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus !=3D=
 CifsExiting)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->=
tcpStatus =3D CifsGood;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sequence_number =
=3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->cphready =3D false=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 /* =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_set(&server->inFlig=
ht,0);*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->respons=
e_q);
>> @@ -1502,6 +1503,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *s=
erver)
>> =A0 =A0 =A0 server->tcpStatus =3D CifsExiting;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> + =A0 =A0 cifs_crypto_shash_release(server);
>> =A0 =A0 =A0 cifs_fscache_release_client_cookie(server);
>>
>> =A0 =A0 =A0 task =3D xchg(&server->tsk, NULL);
>> @@ -1556,12 +1558,19 @@ cifs_get_tcp_session(struct smb_vol *volume_=
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
>> + =A0 =A0 tcp_ses->cphready =3D false;
>> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
>> =A0 =A0 =A0 tcp_ses->noautotune =3D volume_info->noautotune;
>> =A0 =A0 =A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nodela=
y;
>> @@ -1600,7 +1609,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
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
>> @@ -1614,7 +1623,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
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
>> @@ -1626,6 +1635,9 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
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
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 8882012..50e8f75 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area,=
 int bleft,
>> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
struct cifsSesInfo *ses)
>> =A0{
>> + =A0 =A0 unsigned int tioffset; /* challenge message target info ar=
ea */
>> + =A0 =A0 unsigned int tilen; /* challenge message target info area =
length =A0*/
>> +
>> =A0 =A0 =A0 CHALLENGE_MESSAGE *pblob =3D (CHALLENGE_MESSAGE *)bcc_pt=
r;
>>
>> =A0 =A0 =A0 if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
>> @@ -405,6 +408,20 @@ static int decode_ntlmssp_challenge(char *bcc_p=
tr, int blob_len,
>> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp is =
populated then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 we must set the MIC field of the AUTHENT=
ICATE_MESSAGE */
>>
>> + =A0 =A0 ses->server->ntlmssp.server_flags =3D le32_to_cpu(pblob->N=
egotiateFlags);
>> +
>> + =A0 =A0 tioffset =3D cpu_to_le16(pblob->TargetInfoArray.BufferOffs=
et);
>> + =A0 =A0 tilen =3D cpu_to_le16(pblob->TargetInfoArray.Length);
>> + =A0 =A0 ses->tilen =3D tilen;
>> + =A0 =A0 if (ses->tilen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D kmalloc(tilen, GFP_KERNEL)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge targe=
t info allocation failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->tiblob, =A0bcc_ptr + tioffset,=
 ses->tilen);
>> + =A0 =A0 }
>> +
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> The scheme where you check for the presence of a tiblob by checking t=
o
> see if tilen is non-zero seems fragile. There are places (like the on=
e
> above) where you have no buffer, but the tilen is left non-zero.
>
> This code may be fine -- it may not be possible to NULL pointer
> dereference here, but I worry about later changes to it. The error
> handling is complex and the lifecycle of the tiblob is not terribly
> clear. For instance, you free tiblob in setup_ntlmv2_rsp in an error
> condition but the pointer isn't zeroed out. When there's no error, yo=
u
> free it in the caller. It also occasionally frees tiblob without
> checking to see whether tilen is 0 first.
>
> It would be very easy to get this wrong. If this is really what
> you want to do, it would be good to set the tilen to 0 whenever the
> tiblob allocation fails, and to make sure that you zero out the tiblo=
b
> pointer after you free it. A clearer lifecycle for this thing would
> really be better though.
>
> Maybe consider making the tiblob/tilen a kvec or something, and have =
an
> allocation and free routine to make sure it gets handled correctly.
>
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> @@ -425,12 +442,14 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
>> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use he=
re? */
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TARG=
ET |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTI=
ATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
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
>> @@ -451,10 +470,12 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s=
truct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c=
onst struct nls_table *nls_cp, bool first)
>> =A0{
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned int size;
>> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSAGE=
 *)pbuffer;
>> =A0 =A0 =A0 __u32 flags;
>> =A0 =A0 =A0 unsigned char *tmp;
>> - =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
>> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
>>
>> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
>> @@ -462,7 +483,7 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIA=
TE_TARGET_INFO |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTI=
ATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> @@ -477,19 +498,25 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
>>
>> - =A0 =A0 /* calculate session key, =A0BB what about adding similar =
ntlmv2 path? */
>> - =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_se=
ssion_key);
>> - =A0 =A0 if (first)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key(&ses->server->s=
ession_key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0ntlm_session_key, ses->password);
>> -
>> - =A0 =A0 memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
>> =A0 =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_le=
32(tmp - pbuffer);
>> - =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(CIFS_=
SESS_KEY_SIZE);
>> - =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le1=
6(CIFS_SESS_KEY_SIZE);
>> + =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls=
_cp);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during NTLMSSP authent=
ication", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_ret;
>> + =A0 =A0 }
>> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
>> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
>> + =A0 =A0 tmp +=3D size;
>> + =A0 =A0 if (ses->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->tiblob, ses->tilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->tilen;
>> + =A0 =A0 }
>>
>> - =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
>> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(size =
+ ses->tilen);
>> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le1=
6(size + ses->tilen);
>> + =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 ses->tilen =3D 0;
>>
>> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> @@ -501,7 +528,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->domainName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to_l=
e16(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D c=
pu_to_le16(len);
>> @@ -518,7 +544,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->userName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_le1=
6(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D cpu=
_to_le16(len);
>> @@ -530,9 +555,21 @@ static int build_ntlmssp_auth_blob(unsigned cha=
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
>> +
>> +setup_ntlmv2_ret:
>> =A0 =A0 =A0 return tmp - pbuffer;
>> =A0}
>>
>> @@ -546,15 +583,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETU=
P_ANDX *pSMB,
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
>> +static int setup_ntlmssp_auth_req(char *ntlmsspblob,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cons=
t struct nls_table *nls, bool first_time)
>> =A0{
>> =A0 =A0 =A0 int bloblen;
>>
>> - =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(&pSMB->req.SecurityBlo=
b[0], ses, nls,
>> + =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(ntlmsspblob, ses, nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 first_time);
>> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(bloblen);
>>
>> =A0 =A0 =A0 return bloblen;
>> =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> Isn't the above function now just a passthrough? Please just get rid
> of it and fix the callers.
>
>> @@ -729,12 +765,23 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(struc=
t ntlmv2_resp));
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
>> - =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: calculate MAC key */
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key, =
nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during=
 NTLMv2 authentication", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp=
));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->tiblo=
b,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tilen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr=
 =3D 0;
>> @@ -815,12 +862,33 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmNeg=
otiate) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_nt=
lmssp_neg_req(pSMB, ses);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_len =3D sizeof(NEGOTIATE_MESSAGE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D &pSMB->req.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D =
NtLmAuthenticate) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int blob=
_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D=
 setup_ntlmssp_auth_req(pSMB, ses,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *ntlm=
sspblob;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is an=
 empirical value, large enought to
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hold =
authenticate message, max 10 of
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av pa=
ris, doamin,user,workstation mames,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* flags=
 etc..
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspblo=
b =3D kmalloc(5 *
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sizeof(struct _AUTHENTICATE_MESSAGE),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 GFP_KERNEL);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^ w=
hen does this get freed?

Sorry, gave a wrong answer.

iov[1].iov_base =3D ntlmsspblob;  So it gets freed after SendReceive2()=
 call after
that assignment.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntlms=
spblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cERROR(1, "Can't allocate NTLMSSP");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D=
 setup_ntlmssp_auth_req(ntlmsspblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_len =3D blob_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D ntlmsspblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.=
SecurityBlobLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cpu_to_le16(blob_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Make =
sure that we tell the server that we
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a=
re using the uid that it just gave us back
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o=
n the response (challenge) */
>> @@ -830,7 +898,6 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
ENOSYS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sse=
tup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D &pSMB-=
>req.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* unicode strings must =
be word aligned */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((iov[0].iov_len + io=
v[1].iov_len) % 2) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr=
 =3D 0;
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
