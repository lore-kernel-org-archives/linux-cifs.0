From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ntlmssp auth/sign - define data structures
Date: Tue, 7 Sep 2010 07:35:06 -0500
Message-ID: <AANLkTiniwc8303qSwqQqwerJuhtsO6_dJ21vaQtRwe-t@mail.gmail.com>
References: <1283830296-24967-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907071529.27023425@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907071529.27023425-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 7, 2010 at 6:15 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, =A06 Sep 2010 22:31:36 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> A better description would be nice here. "define data structures"
> doesn't tell me much. What are these data structures you're defining
> and how will they be used?
>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 13 +++++++------
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 25 +++++++++++++++++++++++--
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++++++
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A04 ++--
>> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 13 +++++++++++++
>> =A05 files changed, 52 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 847628d..86e33cc 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -42,7 +42,8 @@ extern void SMBencrypt(unsigned char *passwd, cons=
t unsigned char *c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>>
>> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pd=
u,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct session_key *key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 char *signature)
>> =A0{
>> =A0 =A0 =A0 struct =A0MD5Context context;
>>
>> @@ -89,7 +90,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct=
 TCP_Server_Info *server,
>> =A0}
>>
>> =A0static int cifs_calc_signature2(const struct kvec *iov, int n_vec=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const stru=
ct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const stru=
ct session_key *key, char *signature)
>> =A0{
>> =A0 =A0 =A0 struct =A0MD5Context context;
>> =A0 =A0 =A0 int i;
>> @@ -156,14 +157,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec=
, struct TCP_Server_Info *server,
>> =A0}
>>
>> =A0int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct mac_key *=
mac_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct session_k=
ey *session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expected_seque=
nce_number)
>> =A0{
>> =A0 =A0 =A0 unsigned int rc;
>> =A0 =A0 =A0 char server_response_sig[8];
>> =A0 =A0 =A0 char what_we_think_sig_should_be[20];
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (mac_key =3D=3D NULL))
>> + =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (session_key =3D=3D NULL))
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^ extra parens aren't needed here
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> =A0 =A0 =A0 if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
>> @@ -192,7 +193,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le32(expected_sequence_number);
>> =A0 =A0 =A0 cifs_pdu->Signature.Sequence.Reserved =3D 0;
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, mac_key,
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_be);
>>
>> =A0 =A0 =A0 if (rc)
>> @@ -209,7 +210,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0}
>>
>> =A0/* We fill in key by putting in 40 byte array which was allocated=
 by caller */
>> -int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
>> +int cifs_calculate_mac_key(struct session_key *key, const char *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *passw=
ord)
>> =A0{
>> =A0 =A0 =A0 char temp_key[16];
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 0cdfb8c..6e35655 100644
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
>> @@ -97,7 +100,7 @@ enum protocolEnum {
>> =A0 =A0 =A0 /* Netbios frames protocol not supported at this time */
>> =A0};
>>
>> -struct mac_key {
>> +struct session_key {
>
> =A0 =A0 =A0 =A0^^^ why rename this to "session_key"? The rationale fo=
r this
> =A0 =A0 =A0 =A0ought to be in the patch description.
>
>> =A0 =A0 =A0 unsigned int len;
>> =A0 =A0 =A0 union {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 char ntlm[CIFS_SESS_KEY_SIZE + 16];
>> @@ -120,6 +123,20 @@ struct cifs_cred {
>> =A0 =A0 =A0 struct cifs_ace *aces;
>> =A0};
>>
>> +struct sdesc {
>> + =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 char ctx[];
>> +};
>> +
>> +struct ntlmssp_auth {
>> + =A0 =A0 __u32 client_flags; /* sent by client in type 1 ntlmsssp e=
xchange */
>> + =A0 =A0 __u32 server_flags; /* sent by server in type 2 ntlmssp ex=
change */
>> + =A0 =A0 unsigned char sec_key[CIFS_CPHTXT_SIZE]; /* nonce client g=
enerates */
>> + =A0 =A0 unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to ser=
ver */
>> + =A0 =A0 struct crypto_shash *hmacmd5; /* to generate ntlmv2 hash, =
CR1 etc. */
>> + =A0 =A0 struct crypto_shash *md5; /* to generate cifs/smb signatur=
e */
>> +};
>> +
>> =A0/*
>> =A0 ****************************************************************=
*
>> =A0 * Except the CIFS PDUs themselves all the
>> @@ -182,11 +199,15 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null =
*/
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL=
];
>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature =
*/
>> - =A0 =A0 struct mac_key mac_signing_key;
>> + =A0 =A0 struct session_key mac_signing_key;
>> =A0 =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge re=
sponse */
>> + =A0 =A0 struct ntlmssp_auth ntlmssp; /* various keys, ciphers, fla=
gs */
>> + =A0 =A0 bool =A0 =A0cphready; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ciphe=
rtext is calculated */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* support=
s plain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* supports =
U2U Kerberos */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index 14d036d..f5c78fb 100644
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
>> index 1f54508..8d63406 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -361,9 +361,9 @@ extern int cifs_sign_smb(struct smb_hdr *, struc=
t TCP_Server_Info *, __u32 *);
>> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP=
_Server_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *);
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct mac_key *mac_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct session_key *session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ex=
pected_sequence_number);
>> -extern int cifs_calculate_mac_key(struct mac_key *key, const char *=
rn,
>> +extern int cifs_calculate_mac_key(struct session_key *key, const ch=
ar *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 char *pass);
>> =A0extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *=
);
>> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
>> index 49c9a4e..3c8c6c1 100644
>> --- a/fs/cifs/ntlmssp.h
>> +++ b/fs/cifs/ntlmssp.h
>> @@ -61,6 +61,19 @@
>> =A0#define NTLMSSP_NEGOTIATE_KEY_XCH =A0 0x40000000
>> =A0#define NTLMSSP_NEGOTIATE_56 =A0 =A0 =A0 =A00x80000000
>>
>> +/* Define AV Pair Field IDs */
>> +#define NTLMSSP_AV_EOL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>> +#define NTLMSSP_AV_NB_COMPUTER_NAME =A0 =A01
>> +#define NTLMSSP_AV_NB_DOMAIN_NAME =A0 =A0 =A02
>> +#define NTLMSSP_AV_DNS_COMPUTER_NAME =A0 3
>> +#define NTLMSSP_AV_DNS_DOMAIN_NAME =A0 =A0 4
>> +#define NTLMSSP_AV_DNS_TREE_NAME =A0 =A0 =A0 5
>> +#define NTLMSSP_AV_FLAGS =A0 =A0 =A0 =A0 =A0 =A0 =A0 6
>> +#define NTLMSSP_AV_TIMESTAMP =A0 =A0 =A0 =A0 =A0 7
>> +#define NTLMSSP_AV_RESTRICTION =A0 =A0 =A0 =A0 8
>> +#define NTLMSSP_AV_TARGET_NAME =A0 =A0 =A0 =A0 9
>> +#define NTLMSSP_AV_CHANNEL_BINDINGS =A0 =A010
>> +
>> =A0/* Although typedefs are not commonly used for structure definiti=
ons */
>> =A0/* in the Linux kernel, in this particular case they are useful =A0=
 =A0 =A0*/
>> =A0/* to more closely match the standards document for NTLMSSP from =
=A0 =A0 */
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Defining per smb connection structures, sdesc, ntlmssp, tilen, and tilb=
ob.
sdesc holds security descriptor, ntlmssp hold secondary key which is a =
nonce
that gets used as a key to generate signatures, ciphertext is genereate=
d by
rc4/arc4 encryption of secondary key using ntlmv2 session key and sent =
in the
session key field of the type 3 message sent by the client during
ntlmssp exchange
if key exchange is negotiated between client and server, hmacmd5 and md=
5 hold
respective crypto function algorithm functions and tilen and tiblob hol=
d the
length and blob that is target info, which is part of the authenticatio=
n blob.

Various defines are defined such as values used in AV pairs/Target Info=
 pairs.
And various key and hash sizes are also defined.


The reason mac_key was changed to session key is, this structure does n=
ot hold
message authentication code, it holds the session key (for ntlmv2, ntlm=
v1 etc.).
mac is generated as a signature in cifs_calc* functions.
