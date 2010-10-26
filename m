From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [2/3 -v4] NTLM auth and sign - Define crypto hash
 functions and create and send keys needed for key exchange
Date: Tue, 26 Oct 2010 09:21:57 -0500
Message-ID: <AANLkTin-nfK4P_6fDzP_MpM-VJLBd1Lk2=jgj5u0Qcx8@mail.gmail.com>
References: <1287689108-3611-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101026100414.1288fd25@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101026100414.1288fd25-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 26, 2010 at 9:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 21 Oct 2010 14:25:08 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>
> [...]
>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index cfb8f99..4d6fcd8 100644
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
>> @@ -102,6 +105,27 @@ struct session_key {
>> =A0 =A0 =A0 char *response;
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
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nit: specific
>
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
>> + =A0 =A0 unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to ser=
ver */
>> +};
>> +
>> =A0struct cifs_cred {
>> =A0 =A0 =A0 int uid;
>> =A0 =A0 =A0 int gid;
>> @@ -178,6 +202,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 struct session_key session_key;
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> + =A0 =A0 struct cifs_secmech secmech; /* crypto sec mech functs, de=
scriptors */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* support=
s plain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> @@ -220,6 +245,7 @@ struct cifsSesInfo {
>> =A0 =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> =A0 =A0 =A0 unsigned char *tiblob; /* target info blob in challenge =
response */
>> + =A0 =A0 struct ntlmssp_auth ntlmssp; /* ciphertext, flags */
>> =A0 =A0 =A0 bool need_reconnect:1; /* connection reset, uid now inva=
lid */
>> =A0};
>> =A0/* no more than one of the following three session flags may be s=
et */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index a152cd6..de36b09 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -140,6 +140,12 @@
>> =A0 */
>> =A0#define CIFS_SESS_KEY_SIZE (16)
>>
>> +#define CIFS_CLIENT_CHALLENGE_SIZE (8)
>> +#define CIFS_SERVER_CHALLENGE_SIZE (8)
>> +#define CIFS_HMAC_MD5_HASH_SIZE (16)
>> +#define CIFS_CPHTXT_SIZE (16)
>> +#define CIFS_NTHASH_SIZE (16)
>> +
>> =A0/*
>> =A0 * Maximum user name length
>> =A0 */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 8c2d0cf..1e4728b 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -368,6 +368,10 @@ extern void SMBNTencrypt(unsigned char *, unsig=
ned char *, unsigned char *);
>> =A0extern int setup_ntlm_response(struct cifsSesInfo *);
>> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *);
>> =A0extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nl=
s_table *);
>> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> +extern int calc_seckey(struct cifsSesInfo *);
>> +
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool enc=
rypt, char *lnm_session_key);
>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index c5807d3..a3cae2f 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1563,6 +1563,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *s=
erver)
>> =A0 =A0 =A0 server->tcpStatus =3D CifsExiting;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> + =A0 =A0 cifs_crypto_shash_release(server);
>> =A0 =A0 =A0 cifs_fscache_release_client_cookie(server);
>>
>> =A0 =A0 =A0 kfree(server->session_key.response);
>> @@ -1621,10 +1622,16 @@ cifs_get_tcp_session(struct smb_vol *volume_=
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
>> @@ -1668,7 +1675,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
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
>> @@ -1682,7 +1689,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
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
>> @@ -1694,6 +1701,9 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>>
>> =A0 =A0 =A0 return tcp_ses;
>>
>> +out_err2:
> =A0 ^^^^^^^^^
> =A0 =A0 =A0 =A0As a general rule, names like this should be avoided.
> =A0 =A0 =A0 =A0Maybe "out_crypto_release:" would be better?
>
>> + =A0 =A0 cifs_crypto_shash_release(tcp_ses);
>> +
>> =A0out_err:
>> =A0 =A0 =A0 if (tcp_ses) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!IS_ERR(tcp_ses->hostname))
>
>
> Other than the above nits (whihc aren't show stoppers), it looks
> reasonable overall. I'm not that well versed in the crypto routines o=
r
> in NTLMSSP negotiation specifically to do more than ACK here however.=
=2E.
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, Thanks.  Comments are noted. I have a minor cleanup patch in mind=
 and
will incorporate these changes in that patch.

Regards,

Shirish
