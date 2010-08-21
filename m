From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [linux-cifs-client][patch] Make NTLMv2 as auth mech withing
	NTLMSSP and enable signing using crypto shash APIs
Date: Sat, 21 Aug 2010 09:23:11 -0500
Message-ID: <AANLkTi=79uJyM-i99KxrEmyECPoCPXPnsdY7HwGc9UtA@mail.gmail.com>
References: <1280975679-9096-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100821071441.3b9cbef5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: smfrench@gmail.com, samba-technical@samba.org, linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100821071441.3b9cbef5@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Aug 21, 2010 at 6:14 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Wed, =A04 Aug 2010 21:34:39 -0500
> shirishpargaonkar@gmail.com wrote:
>
>> Make ntlmv2 as an authentication mechanism within ntlmssp
>> instead of ntlmv1.
>> Parse type 2 response in ntlmssp negotiation to pluck
>> AV pairs and use them to calculate ntlmv2 response token.
>> Also, assign domain name from the sever response in type 2
>> packet of ntlmssp and use that (netbios) domain name in
>> calculation of response.
>>
>> Enable cifs/smb signing using rc4 and md5.
>>
>> Changed name of the structure mac_key to session_key to reflect
>> the type of key it holds.
>>
>> Use kernel crypto_shash_* APIs instead of the equivalent cifs functions.
>>
>>
>> From 6ab552fd60804f3c708e1745ca936112fc9f9821 Mon Sep 17 00:00:00 2001
>> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>> Date: Wed, 4 Aug 2010 17:24:07 -0500
>> Subject: [PATCH] Make ntlmv2 as auth mech and enable signing using crypt=
o_shash APIs
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>> ---
>> =A0fs/cifs/asn1.c =A0 =A0 =A0 =A0| =A0 =A06 +-
>> =A0fs/cifs/cifsencrypt.c | =A0416 ++++++++++++++++++++++++++++++++++----=
----------
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 18 ++-
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +-
>> =A0fs/cifs/cifsproto.h =A0 | =A0 12 +-
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 13 +-
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 13 ++-
>> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 13 ++
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0118 +++++++++++----
>> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
>> =A010 files changed, 450 insertions(+), 172 deletions(-)
>>
>
> Overall this looks like a good change, but this patch is rather large.
> That makes it tough to bisect for bugs and to review...
>
> Would it be possible to break it up some? Maybe a patch (or patches) to
> convert the existing code to using the crypto api's and then another
> set to fix up the NTLMSSP code?
>
> Also, with the conversion to the crypto API's can we remove some of the
> cifs private crypto routines in smbencrypt.c? That would be a nice
> follow-on patch. It seems like switching to use the crypto API's should
> mean a net reduction in code.
>
>> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
>> index cfd1ce3..21f0fbd 100644
>> --- a/fs/cifs/asn1.c
>> +++ b/fs/cifs/asn1.c
>> @@ -597,13 +597,13 @@ decode_negTokenInit(unsigned char *security_blob, =
int length,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_=
oid(oid, oidlen, MSKRB5_OID,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 MSKRB5_OID_LEN))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->sec_mskerberos =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (compa=
re_oid(oid, oidlen, KRB5U2U_OID,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_oi=
d(oid, oidlen, KRB5U2U_OID,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0KRB5U2U_OID_LEN))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->sec_kerberosu2u =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (compa=
re_oid(oid, oidlen, KRB5_OID,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_oi=
d(oid, oidlen, KRB5_OID,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0KRB5_OID_LEN))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->sec_kerberos =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (compa=
re_oid(oid, oidlen, NTLMSSP_OID,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_oi=
d(oid, oidlen, NTLMSSP_OID,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_OID_LEN))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->sec_ntlmssp =3D true;
>>
>
> Why change the above? If compare_oid returns true on any of them, then
> the others will return false. The else clauses ought to stay, IMO...

Jeff, with this the authentication mechanism always defaults to kerberos
(if server supports it) even if an user wants to use a different auth
mech this way
e.g. sec=3Dntlm/ntlmi or sec=3Dntlmv2/ntlmv2i.

>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 847628d..051d000 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -27,6 +27,7 @@
>> =A0#include "md5.h"
>> =A0#include "cifs_unicode.h"
>> =A0#include "cifsproto.h"
>> +#include "ntlmssp.h"
>> =A0#include <linux/ctype.h>
>> =A0#include <linux/random.h>
>>
>> @@ -42,21 +43,44 @@ extern void SMBencrypt(unsigned char *passwd, const =
unsigned char *c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>>
>> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const =
struct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *server=
, char *signature)
>> =A0{
>> - =A0 =A0 struct =A0MD5Context context;
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 =A0 =A0 =A0 char ctx[crypto_shash_descsize(server->ntlmssp=
.md5)];
>> + =A0 =A0 } sdesc;
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (signature =3D=3D NULL) || (key =
=3D=3D NULL))
>> + =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL || signature =
=3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> - =A0 =A0 cifs_MD5_init(&context);
>> - =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len);
>> - =A0 =A0 cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->smb_bu=
f_length);
>> + =A0 =A0 sdesc.shash.tfm =3D server->ntlmssp.md5;
>> + =A0 =A0 sdesc.shash.flags =3D 0x0;
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&sdesc.shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not initialize master crypto =
API hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (server->secType =3D=3D RawNTLMSSP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.data.ntlmv=
2.key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTLMV2_SESSKEY_SIZE);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&server->session_key.d=
ata,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len);
>> +
>> + =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_pdu->Protocol, cifs_pdu->=
smb_buf_length);
>> +
>> + =A0 =A0 rc =3D crypto_shash_final(&sdesc.shash, signature);
>>
>> - =A0 =A0 cifs_MD5_final(signature, &context);
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> +
>> =A0int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *s=
erver,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *pexpected_response_sequence_numbe=
r)
>> =A0{
>> @@ -78,8 +102,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TC=
P_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->mac_signing=
_key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sm=
b_signature);
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server, smb_signatur=
e);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySignature=
, 0, 8);
>> =A0 =A0 =A0 else
>> @@ -89,16 +112,36 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct =
TCP_Server_Info *server,
>> =A0}
>>
>> =A0static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct m=
ac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *server=
, char *signature)
>> =A0{
>> - =A0 =A0 struct =A0MD5Context context;
>> =A0 =A0 =A0 int i;
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 =A0 =A0 =A0 char ctx[crypto_shash_descsize(server->ntlmssp=
.md5)];
>> + =A0 =A0 } sdesc;
>>
>> - =A0 =A0 if ((iov =3D=3D NULL) || (signature =3D=3D NULL) || (key =3D=
=3D NULL))
>> + =A0 =A0 if (iov =3D=3D NULL || server =3D=3D NULL || signature =3D=3D =
NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> - =A0 =A0 cifs_MD5_init(&context);
>> - =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len);
>> + =A0 =A0 sdesc.shash.tfm =3D server->ntlmssp.md5;
>> + =A0 =A0 sdesc.shash.flags =3D 0x0;
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&sdesc.shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not initialize master crypto =
API hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (server->secType =3D=3D RawNTLMSSP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.data.ntlmv=
2.key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTLMV2_SESSKEY_SIZE);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&server->session_key.d=
ata,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len);
>> +
>> =A0 =A0 =A0 for (i =3D 0; i < n_vec; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[i].iov_len =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> @@ -111,18 +154,18 @@ static int cifs_calc_signature2(const struct kvec =
*iov, int n_vec,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len <=3D 8) /=
* cmd field at offset 9 */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break; /* no=
thing to sign or corrupt header */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_MD5_update(&context, iov[=
0].iov_base+4,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov=
_len-4);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.sha=
sh,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i].iov_bas=
e + 4, iov[i].iov_len - 4);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_MD5_update(&context, iov[=
i].iov_base, iov[i].iov_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.sha=
sh,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i].iov_bas=
e, iov[i].iov_len);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 cifs_MD5_final(signature, &context);
>> + =A0 =A0 rc =3D crypto_shash_final(&sdesc.shash, signature);
>>
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -
>> =A0int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Inf=
o *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *pexpected_response_sequence_nu=
mber)
>> =A0{
>> @@ -145,8 +188,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, stru=
ct TCP_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->mac_signing_k=
ey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sm=
b_signature);
>> + =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, server, smb_signature)=
;
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySignature=
, 0, 8);
>> =A0 =A0 =A0 else
>> @@ -156,14 +198,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, st=
ruct TCP_Server_Info *server,
>> =A0}
>>
>> =A0int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct mac_key *mac_=
key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *se=
rver,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expected_sequence_=
number)
>> =A0{
>> - =A0 =A0 unsigned int rc;
>> + =A0 =A0 int rc;
>> =A0 =A0 =A0 char server_response_sig[8];
>> =A0 =A0 =A0 char what_we_think_sig_should_be[20];
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (mac_key =3D=3D NULL))
>> + =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> =A0 =A0 =A0 if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
>> @@ -192,7 +234,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 cpu_to_le32(expected_sequence_number);
>> =A0 =A0 =A0 cifs_pdu->Signature.Sequence.Reserved =3D 0;
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, mac_key,
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_be);
>>
>> =A0 =A0 =A0 if (rc)
>> @@ -209,7 +251,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> =A0}
>>
>> =A0/* We fill in key by putting in 40 byte array which was allocated by =
caller */
>> -int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
>> +int cifs_calculate_session_key(struct session_key *key, const char *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *password)
>> =A0{
>> =A0 =A0 =A0 char temp_key[16];
>> @@ -223,63 +265,6 @@ int cifs_calculate_mac_key(struct mac_key *key, con=
st char *rn,
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nl=
s_table *nls_info)
>> -{
>> - =A0 =A0 char temp_hash[16];
>> - =A0 =A0 struct HMACMD5Context ctx;
>> - =A0 =A0 char *ucase_buf;
>> - =A0 =A0 __le16 *unicode_buf;
>> - =A0 =A0 unsigned int i, user_name_len, dom_name_len;
>> -
>> - =A0 =A0 if (ses =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> -
>> - =A0 =A0 E_md4hash(ses->password, temp_hash);
>> -
>> - =A0 =A0 hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
>> - =A0 =A0 user_name_len =3D strlen(ses->userName);
>> - =A0 =A0 if (user_name_len > MAX_USERNAME_SIZE)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> - =A0 =A0 if (ses->domainName =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; /* BB should we use CIFS_LINUX=
_DOM */
>> - =A0 =A0 dom_name_len =3D strlen(ses->domainName);
>> - =A0 =A0 if (dom_name_len > MAX_USERNAME_SIZE)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> -
>> - =A0 =A0 ucase_buf =3D kmalloc((MAX_USERNAME_SIZE+1), GFP_KERNEL);
>> - =A0 =A0 if (ucase_buf =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 unicode_buf =3D kmalloc((MAX_USERNAME_SIZE+1)*4, GFP_KERNEL);
>> - =A0 =A0 if (unicode_buf =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 kfree(ucase_buf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 for (i =3D 0; i < user_name_len; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ucase_buf[i] =3D nls_info->charset2upper[(int)=
ses->userName[i]];
>> - =A0 =A0 ucase_buf[i] =3D 0;
>> - =A0 =A0 user_name_len =3D cifs_strtoUCS(unicode_buf, ucase_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MA=
X_USERNAME_SIZE*2, nls_info);
>> - =A0 =A0 unicode_buf[user_name_len] =3D 0;
>> - =A0 =A0 user_name_len++;
>> -
>> - =A0 =A0 for (i =3D 0; i < dom_name_len; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ucase_buf[i] =3D nls_info->charset2upper[(int)=
ses->domainName[i]];
>> - =A0 =A0 ucase_buf[i] =3D 0;
>> - =A0 =A0 dom_name_len =3D cifs_strtoUCS(unicode_buf+user_name_len, ucas=
e_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MAX=
_USERNAME_SIZE*2, nls_info);
>> -
>> - =A0 =A0 unicode_buf[user_name_len + dom_name_len] =3D 0;
>> - =A0 =A0 hmac_md5_update((const unsigned char *) unicode_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 (user_name_len+dom_name_len)*2, &ctx);
>> -
>> - =A0 =A0 hmac_md5_final(ses->server->ntlmv2_hash, &ctx);
>> - =A0 =A0 kfree(ucase_buf);
>> - =A0 =A0 kfree(unicode_buf);
>> - =A0 =A0 return 0;
>> -}
>> -
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0void calc_lanman_hash(const char *password, const char *cryptkey, boo=
l encrypt,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *lnm_session_key)
>> @@ -324,21 +309,29 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *se=
s,
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 int len;
>> - =A0 =A0 char nt_hash[16];
>> - =A0 =A0 struct HMACMD5Context *pctxt;
>> + =A0 =A0 char nt_hash[CIFS_NTHASH_SIZE];
>> =A0 =A0 =A0 wchar_t *user;
>> =A0 =A0 =A0 wchar_t *domain;
>> -
>> - =A0 =A0 pctxt =3D kmalloc(sizeof(struct HMACMD5Context), GFP_KERNEL);
>> -
>> - =A0 =A0 if (pctxt =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 wchar_t *server;
>> + =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 =A0 =A0 =A0 char ctx[crypto_shash_descsize(ses->server->nt=
lmssp.hmacmd5)];
>> + =A0 =A0 } sdesc;
>>
>> =A0 =A0 =A0 /* calculate md4 hash of password */
>> =A0 =A0 =A0 E_md4hash(ses->password, nt_hash);
>>
>> - =A0 =A0 /* convert Domainname to unicode and uppercase */
>> - =A0 =A0 hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
>> + =A0 =A0 sdesc.shash.tfm =3D ses->server->ntlmssp.hmacmd5;
>> + =A0 =A0 sdesc.shash.flags =3D 0x0;
>> +
>> + =A0 =A0 crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTHASH_SI=
ZE);
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&sdesc.shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not initialize master crypto =
API hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* convert ses->userName to unicode and uppercase */
>> =A0 =A0 =A0 len =3D strlen(ses->userName);
>> @@ -347,7 +340,8 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_2;
>> =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->userName, len, nl=
s_cp);
>> =A0 =A0 =A0 UniStrupr(user);
>> - =A0 =A0 hmac_md5_update((char *)user, 2*len, pctxt);
>> +
>> + =A0 =A0 crypto_shash_update(&sdesc.shash, (char *)user, 2 * len);
>>
>> =A0 =A0 =A0 /* convert ses->domainName to unicode and uppercase */
>> =A0 =A0 =A0 if (ses->domainName) {
>> @@ -363,65 +357,243 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *s=
es,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Maybe converting the domain name earl=
ier makes sense */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* UniStrupr(domain); */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update((char *)domain, 2*len, pctxt);
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash, (char *)doma=
in, 2 * len);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(domain);
>> + =A0 =A0 } else if (ses->serverName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(ses->serverName);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 server =3D kmalloc(2 + (len * 2), GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)server, ses->s=
erverName, len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* the following line was removed since it did=
n't work well
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0with lower cased domain name that passe=
d as an option.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Maybe converting the domain name earlie=
r makes sense */
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* UniStrupr(domain); */
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash, (char *)serv=
er, 2 * len);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(server);
>> =A0 =A0 =A0 }
>> =A0calc_exit_1:
>> =A0 =A0 =A0 kfree(user);
>> =A0calc_exit_2:
>> =A0 =A0 =A0 /* BB FIXME what about bytes 24 through 40 of the signing ke=
y?
>> =A0 =A0 =A0 =A0 =A0compare with the NTLM example */
>> - =A0 =A0 hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
>> + =A0 =A0 rc =3D crypto_shash_final(&sdesc.shash, ses->server->ntlmv2_ha=
sh);
>>
>> - =A0 =A0 kfree(pctxt);
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_cp)
>> +static int
>> +find_domain_name(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned int attrsize;
>> + =A0 =A0 unsigned int type;
>> + =A0 =A0 unsigned char *blobptr;
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 if (ses->server->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->server->tiblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 while ((type =3D attrptr->type) !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance att=
r type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->length;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance att=
r size */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_NB_=
DOMAIN_NAME) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->doma=
inName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ses->domainName =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 kmalloc(attrptr->length + 1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 if (!ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 cifs_from_ucs2(ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 (__le16 *)blobptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 load_nls_default(), false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* adva=
nce attr =A0value */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_n=
ame *) blobptr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 2 * sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(ses->server->t=
ilen, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target in=
fo allocation failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(ses->server->tiblob, 0x0, ses->server->=
tilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->serv=
er->tiblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_T=
YPE);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> +static int
>> +CalcNTLMv2_response(const struct TCP_Server_Info *server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *v2_session_response)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> + =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 =A0 =A0 =A0 char ctx[crypto_shash_descsize(server->ntlmssp=
.hmacmd5)];
>> + =A0 =A0 } sdesc;
>> +
>> + =A0 =A0 sdesc.shash.tfm =3D server->ntlmssp.hmacmd5;
>> + =A0 =A0 sdesc.shash.flags =3D 0x0;
>> +
>> + =A0 =A0 crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv2_ha=
sh,
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_HMAC_MD5_HASH_SIZE);
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&sdesc.shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not initialize master crypto =
API hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
>> + =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 v2_session_response + CIFS_SERVER_CHALLENGE_SI=
ZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALL=
ENGE_SIZE);
>> +
>> + =A0 =A0 if (server->tilen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->tiblob, server->tilen);
>> +
>> + =A0 =A0 rc =3D crypto_shash_final(&sdesc.shash, v2_session_response);
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> +int
>> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_cp)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct ntlmv2_resp *buf =3D (struct ntlmv2_resp *)resp_buf;
>> - =A0 =A0 struct HMACMD5Context context;
>> + =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 =A0 =A0 =A0 char ctx[crypto_shash_descsize(ses->server->nt=
lmssp.hmacmd5)];
>> + =A0 =A0 } sdesc;
>>
>> =A0 =A0 =A0 buf->blob_signature =3D cpu_to_le32(0x00000101);
>> =A0 =A0 =A0 buf->reserved =3D 0;
>> =A0 =A0 =A0 buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
>> =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client_chal)=
);
>> =A0 =A0 =A0 buf->reserved2 =3D 0;
>> - =A0 =A0 buf->names[0].type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
>> - =A0 =A0 buf->names[0].length =3D 0;
>> - =A0 =A0 buf->names[1].type =3D 0;
>> - =A0 =A0 buf->names[1].length =3D 0;
>> +
>> + =A0 =A0 if (!ses->domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D find_domain_name(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get domai=
n/server name rc %d", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 rc =3D CalcNTLMv2_response(ses->server, resp_buf);
>> + =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d", rc)=
;
>> - =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->ntlmv2_hash, CIFS=
_HMAC_MD5_HASH_SIZE);
>> +
>> + =A0 =A0 sdesc.shash.tfm =3D ses->server->ntlmssp.hmacmd5;
>> + =A0 =A0 sdesc.shash.flags =3D 0x0;
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&sdesc.shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not initialize master crypto =
API hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 crypto_shash_update(&sdesc.shash, resp_buf, CIFS_HMAC_MD5_HASH=
_SIZE);
>>
>> - =A0 =A0 /* now calculate the MAC key for NTLMv2 */
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &contex=
t);
>> - =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
>> - =A0 =A0 hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.key, &=
context);
>> + =A0 =A0 rc =3D crypto_shash_final(&sdesc.shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key.data.ntlmv2.key);
>>
>> - =A0 =A0 memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_bu=
f,
>> - =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> - =A0 =A0 ses->server->mac_signing_key.len =3D 16 + sizeof(struct ntlmv2=
_resp);
>> + =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp));
>> + =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlmv2_res=
p);
>> +
>> + =A0 =A0 return rc;
>> =A0}
>>
>> -void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *v2_session_response)
>> +int
>> +calc_seckey(struct TCP_Server_Info *server)
>> =A0{
>> - =A0 =A0 struct HMACMD5Context context;
>> - =A0 =A0 /* rest of v2 struct already generated */
>> - =A0 =A0 memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &contex=
t);
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned char sec_key[CIFS_NTLMV2_SESSKEY_SIZE];
>> + =A0 =A0 struct crypto_blkcipher *tfm_arc4;
>> + =A0 =A0 struct scatterlist sgin, sgout;
>> + =A0 =A0 struct blkcipher_desc desc;
>> +
>> + =A0 =A0 get_random_bytes(sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
>> +
>> + =A0 =A0 tfm_arc4 =3D crypto_alloc_blkcipher("ecb(arc4)",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 0, CRYPTO_ALG_ASYNC);
>> + =A0 =A0 if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate " "master crypto=
 API arc4\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 crypto_blkcipher_setkey(tfm_arc4,
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.data.ntlmv2.key, CIFS_CPHT=
XT_SIZE);
>> + =A0 =A0 sg_init_one(&sgin, sec_key, CIFS_CPHTXT_SIZE);
>> + =A0 =A0 sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CPHTXT_SI=
ZE);
>> + =A0 =A0 rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPH=
TXT_SIZE);
>> +
>> + =A0 =A0 if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_key.data.ntlmv2.key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_key, CIFS_=
NTLMV2_SESSKEY_SIZE);
>>
>> - =A0 =A0 hmac_md5_update(v2_session_response+8,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp) - 8=
, &context);
>> + =A0 =A0 crypto_free_blkcipher(tfm_arc4);
>>
>> - =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> -/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
>> + =A0 =A0 return 0;
>> +}
>> +
>> +void
>> +cifs_crypto_shash_release(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 if (server->ntlmssp.md5)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->ntlmssp.md5);
>> +
>> + =A0 =A0 if (server->ntlmssp.hmacmd5)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->ntlmssp.hmacmd5);
>> +}
>> +
>> +int
>> +cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 server->ntlmssp.hmacmd5 =3D crypto_alloc_shash("hmac(md5)", 0,=
 0);
>> + =A0 =A0 if (!server->ntlmssp.hmacmd5 ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IS_ERR(server->ntlmssp.hmacmd5=
)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate master crypto AP=
I hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 server->ntlmssp.md5 =3D crypto_alloc_shash("md5", 0, 0);
>> + =A0 =A0 if (!server->ntlmssp.md5 || IS_ERR(server->ntlmssp.md5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->ntlmssp.hmacmd5);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate master crypto AP=
I md5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> =A0}
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 5990614..712fa56 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -25,6 +25,9 @@
>> =A0#include <linux/slow-work.h>
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
>> =A0 =A0 =A0 unsigned int len;
>> =A0 =A0 =A0 union {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 char ntlm[CIFS_SESS_KEY_SIZE + 16];
>> @@ -120,6 +123,14 @@ struct cifs_cred {
>> =A0 =A0 =A0 struct cifs_ace *aces;
>> =A0};
>>
>> +struct ntlmssp_auth {
>> + =A0 =A0 __u32 client_flags;
>> + =A0 =A0 __u32 server_flags;
>> + =A0 =A0 unsigned char ciphertext[CIFS_CPHTXT_SIZE];
>> + =A0 =A0 struct crypto_shash *hmacmd5;
>> + =A0 =A0 struct crypto_shash *md5;
>> +};
>> +
>> =A0/*
>> =A0 *****************************************************************
>> =A0 * Except the CIFS PDUs themselves all the
>> @@ -182,11 +193,14 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null */
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature */
>> - =A0 =A0 struct mac_key mac_signing_key;
>> + =A0 =A0 struct session_key session_key;
>> =A0 =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from this =
server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge respon=
se */
>> + =A0 =A0 struct ntlmssp_auth ntlmssp; /* various keys, ciphers, flags *=
/
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* supports pl=
ain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports lega=
cy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* supports U2U =
Kerberos */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index 14d036d..320e0fd 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -134,6 +134,12 @@
>> =A0 * Size of the session key (crypto key encrypted with the password
>> =A0 */
>> =A0#define CIFS_SESS_KEY_SIZE (24)
>> +#define CIFS_CLIENT_CHALLENGE_SIZE (8)
>> +#define CIFS_SERVER_CHALLENGE_SIZE (8)
>> +#define CIFS_HMAC_MD5_HASH_SIZE (16)
>> +#define CIFS_CPHTXT_SIZE (16)
>> +#define CIFS_NTLMV2_SESSKEY_SIZE (16)
>> +#define CIFS_NTHASH_SIZE (16)
>>
>> =A0/*
>> =A0 * Maximum user name length
>> @@ -663,7 +669,6 @@ struct ntlmv2_resp {
>> =A0 =A0 =A0 __le64 =A0time;
>> =A0 =A0 =A0 __u64 =A0client_chal; /* random */
>> =A0 =A0 =A0 __u32 =A0reserved2;
>> - =A0 =A0 struct ntlmssp2_name names[2];
>> =A0 =A0 =A0 /* array of name entries could follow ending in minimum 4 by=
te struct */
>> =A0} __attribute__((packed));
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 1f54508..1378d91 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -361,15 +361,15 @@ extern int cifs_sign_smb(struct smb_hdr *, struct =
TCP_Server_Info *, __u32 *);
>> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Ser=
ver_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *);
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struc=
t mac_key *mac_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_=
Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expect=
ed_sequence_number);
>> -extern int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
>> +extern int cifs_calculate_session_key(struct session_key *key, const ch=
ar *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const cha=
r *pass);
>> -extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *);
>> -extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
>> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_=
table *);
>> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> +extern int calc_seckey(struct TCP_Server_Info *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cryptk=
ey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool encrypt=
, char *lnm_session_key);
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index c65c341..4bda920 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -604,11 +604,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesI=
nfo *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINV=
AL;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_kerberos || se=
rver->sec_mskerberos)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->secTyp=
e =3D Kerberos;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->sec_ntlmssp)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->secTyp=
e =3D RawNTLMSSP;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D Ker=
beros) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->s=
ec_kerberos &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 !server->sec_mskerberos)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->secType =3D=
=3D RawNTLMSSP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->s=
ec_ntlmssp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>
> Ok this makes sense given that we set the secType in the big if/else if
> block above this.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPN=
OTSUPP;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 95c2ea6..b63da64 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1706,6 +1706,7 @@ cifs_put_smb_ses(struct cifsSesInfo *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBLogoff(xid, ses);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 _FreeXid(xid);
>> =A0 =A0 =A0 }
>> + =A0 =A0 cifs_crypto_shash_release(server);
>> =A0 =A0 =A0 sesInfoFree(ses);
>> =A0 =A0 =A0 cifs_put_tcp_session(server);
>> =A0}
>> @@ -1785,13 +1786,23 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,=
 struct smb_vol *volume_info)
>> =A0 =A0 =A0 ses->linux_uid =3D volume_info->linux_uid;
>> =A0 =A0 =A0 ses->overrideSecFlg =3D volume_info->secFlg;
>>
>> + =A0 =A0 rc =3D cifs_crypto_shash_allocate(server);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not setup hash structures rc =
%d", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto get_ses_fail;
>> + =A0 =A0 }
>> + =A0 =A0 server->tilen =3D 0;
>> + =A0 =A0 server->tiblob =3D NULL;
>> +
>> =A0 =A0 =A0 mutex_lock(&ses->session_mutex);
>> =A0 =A0 =A0 rc =3D cifs_negotiate_protocol(xid, ses);
>> =A0 =A0 =A0 if (!rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_setup_session(xid, ses, volume_i=
nfo->local_nls);
>> =A0 =A0 =A0 mutex_unlock(&ses->session_mutex);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_crypto_shash_release(ses->server);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ses_fail;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* success, put it on the list */
>> =A0 =A0 =A0 write_lock(&cifs_tcp_ses_lock);
>> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
>> index 49c9a4e..1db0f07 100644
>> --- a/fs/cifs/ntlmssp.h
>> +++ b/fs/cifs/ntlmssp.h
>> @@ -61,6 +61,19 @@
>> =A0#define NTLMSSP_NEGOTIATE_KEY_XCH =A0 0x40000000
>> =A0#define NTLMSSP_NEGOTIATE_56 =A0 =A0 =A0 =A00x80000000
>>
>> +/* Define AV Pair Field IDs */
>> +#define NTLMSSP_AV_EOL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>> +#define NTLMSSP_AV_NB_COMPUTER_NAME =A01
>> +#define NTLMSSP_AV_NB_DOMAIN_NAME =A0 =A02
>> +#define NTLMSSP_AV_DNS_COMPUTER_NAME 3
>> +#define NTLMSSP_AV_DNS_DOMAIN_NAME =A0 4
>> +#define NTLMSSP_AV_DNS_TREE_NAME =A0 =A0 5
>> +#define NTLMSSP_AV_FLAGS =A0 =A0 =A0 =A0 =A0 =A0 6
>> +#define NTLMSSP_AV_TIMESTAMP =A0 =A0 =A0 =A0 7
>> +#define NTLMSSP_AV_RESTRICTION =A0 =A0 =A0 =A0 =A0 =A0 =A0 8
>> +#define NTLMSSP_AV_TARGET_NAME =A0 =A0 =A0 =A0 =A0 =A0 =A0 9
>> +#define NTLMSSP_AV_CHANNEL_BINDINGS =A010
>> +
>> =A0/* Although typedefs are not commonly used for structure definitions =
*/
>> =A0/* in the Linux kernel, in this particular case they are useful =A0 =
=A0 =A0*/
>> =A0/* to more closely match the standards document for NTLMSSP from =A0 =
=A0 */
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 0a57cb7..41fc532 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int=
 bleft,
>> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct cifsSesInfo *ses)
>> =A0{
>> + =A0 =A0 unsigned int tioffset; /* challeng message target info area */
>> + =A0 =A0 unsigned int tilen; /* challeng message target info area lengt=
h =A0*/
>> +
>> =A0 =A0 =A0 CHALLENGE_MESSAGE *pblob =3D (CHALLENGE_MESSAGE *)bcc_ptr;
>>
>> =A0 =A0 =A0 if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
>> @@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, =
int blob_len,
>> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp is popu=
lated then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 we must set the MIC field of the AUTHENTICAT=
E_MESSAGE */
>>
>> + =A0 =A0 tioffset =3D cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
>> + =A0 =A0 tilen =3D cpu_to_le16(pblob->TargetInfoArray.Length);
>> + =A0 =A0 ses->server->tilen =3D tilen;
>> + =A0 =A0 if (tilen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(tilen, GFP_KER=
NEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target in=
fo allocation failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->tiblob, =A0bcc_ptr + tioff=
set, tilen);
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> @@ -451,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned char *=
pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 struct nls_table *nls_cp, bool first)
>> =A0{
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned int size;
>> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSAGE *)p=
buffer;
>> =A0 =A0 =A0 __u32 flags;
>> =A0 =A0 =A0 unsigned char *tmp;
>> - =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
>> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
>>
>> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
>> @@ -477,19 +494,25 @@ static int build_ntlmssp_auth_blob(unsigned char *=
pbuffer,
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
>>
>> - =A0 =A0 /* calculate session key, =A0BB what about adding similar ntlm=
v2 path? */
>> - =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_sessio=
n_key);
>> - =A0 =A0 if (first)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&ses->server->mac_signi=
ng_key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0ntlm_session_key, ses->password);
>> -
>> - =A0 =A0 memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
>> =A0 =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_le32(t=
mp - pbuffer);
>> - =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(CIFS_SESS=
_KEY_SIZE);
>> - =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CI=
FS_SESS_KEY_SIZE);
>> + =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp)=
;
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error rc: %d during ntlmssp ntlmv2 =
setup", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_ret;
>> + =A0 =A0 }
>> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
>> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
>> + =A0 =A0 tmp +=3D size;
>> + =A0 =A0 if (ses->server->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->tiblob, ses->server->=
tilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->server->tilen;
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0;
>>
>> - =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
>> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(size +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->t=
ilen);
>> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(size + ses->server->tilen);
>>
>> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cpu_to=
_le32(tmp - pbuffer);
>> @@ -501,7 +524,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pb=
uffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses->do=
mainName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_=
USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each */
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cpu_to=
_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to_le16(=
len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D cpu_t=
o_le16(len);
>> @@ -518,7 +540,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pb=
uffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses->us=
erName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_=
USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each */
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cpu_to_l=
e32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_le16(le=
n);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D cpu_to_=
le16(len);
>> @@ -530,9 +551,26 @@ static int build_ntlmssp_auth_blob(unsigned char *p=
buffer,
>> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>> =A0 =A0 =A0 tmp +=3D 2;
>>
>> - =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp - pbuffe=
r);
>> - =A0 =A0 sec_blob->SessionKey.Length =3D 0;
>> - =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
>> + =A0 =A0 if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTIATE_KEY=
_XCH) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses->server)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->ntlmssp.ciphertext, C=
IFS_CPHTXT_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_l=
e32(tmp - pbuffer);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to_le16(CI=
FS_CPHTXT_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_CPHTXT_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D CIFS_CPHTXT_SIZE;
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_l=
e32(tmp - pbuffer);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 ses->server->sequence_number =3D 0;
>> +
>> +setup_ntlmv2_ret:
>> + =A0 =A0 if (ses->server->tilen > 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->server->tiblob);
>> +
>> =A0 =A0 =A0 return tmp - pbuffer;
>> =A0}
>>
>> @@ -546,15 +584,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_AN=
DX *pSMB,
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
>> +static int setup_ntlmssp_auth_req(char *ntlmsspblob,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct c=
ifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const st=
ruct nls_table *nls, bool first_time)
>> =A0{
>> =A0 =A0 =A0 int bloblen;
>>
>> - =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(&pSMB->req.SecurityBlob[0]=
, ses, nls,
>> + =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(ntlmsspblob, ses, nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 first_time);
>> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(bloblen);
>>
>> =A0 =A0 =A0 return bloblen;
>> =A0}
>> @@ -580,6 +617,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo =
*ses,
>> =A0 =A0 =A0 struct key *spnego_key =3D NULL;
>> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed, is mu=
ltistage */
>> =A0 =A0 =A0 bool first_time;
>> + =A0 =A0 char *ntlmsspblob;
>>
>> =A0 =A0 =A0 if (ses =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> @@ -690,7 +728,7 @@ ssetup_ntlmssp_authenticate:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) /* should this be moved into=
 common code
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 with sim=
ilar ntlmv2 path? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&ses->s=
erver->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key(&se=
s->server->session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlm_session=
_key, ses->password);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy session key */
>>
>> @@ -729,12 +767,21 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(struct nt=
lmv2_resp));
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
>> - =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key, nls_=
cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: calculate MAC key */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->server->t=
iblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->t=
ilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->server->tile=
n;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr =3D=
 0;
>> @@ -765,15 +812,15 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->mac_signing_key.da=
ta.krb5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->session_key.data.k=
rb5)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos signing =
key too long (%u bytes)",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->sesskey=
_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->mac_signing_key.l=
en =3D msg->sesskey_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->mac_signin=
g_key.data.krb5,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key.len =
=3D msg->sesskey_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->session_ke=
y.data.krb5,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->data, m=
sg->sesskey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_SEC;
>> @@ -815,12 +862,26 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmNegotia=
te) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmss=
p_neg_req(pSMB, ses);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_l=
en =3D sizeof(NEGOTIATE_MESSAGE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_bas=
e =3D &pSMB->req.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D NtLm=
Authenticate) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int blob_len=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D s=
etup_ntlmssp_auth_req(pSMB, ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspblob =
=3D kmalloc(5 *
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 sizeof(struct _AUTHENTICATE_MESSAGE),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntlmsspbl=
ob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 cERROR(1, "Can't allocate NTLMSSP");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D s=
etup_ntlmssp_auth_req(ntlmsspblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_l=
en =3D blob_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_bas=
e =3D ntlmsspblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Secu=
rityBlobLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 cpu_to_le16(blob_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Make sure=
 that we tell the server that we
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0are u=
sing the uid that it just gave us back
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0on th=
e response (challenge) */
>> @@ -830,7 +891,6 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOS=
YS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_=
exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D &pSMB->req=
.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* unicode strings must be w=
ord aligned */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((iov[0].iov_len + iov[1]=
.iov_len) % 2) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr =3D=
 0;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 82f78c4..e0588cd 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsSesI=
nfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE_SIG=
N_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature=
(midQ->resp_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 ses->server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "U=
nexpected SMB signature");
>> @@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesIn=
fo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE_SIG=
N_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature=
(out_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 ses->server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "U=
nexpected SMB signature");
>> @@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, stru=
ct cifsTconInfo *tcon,
>> =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0S=
ECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature(out_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0ses->server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected SMB si=
gnature");
>
>
> --
> Jeff Layton <jlayton@samba.org>
>
