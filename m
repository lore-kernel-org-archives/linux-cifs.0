From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v5 2/4] cifs NTLMv2/NTLMSSP ntlmv2 within ntlmssp
 autentication code
Date: Wed, 15 Sep 2010 22:42:48 -0500
Message-ID: <AANLkTik5vCyfT39UFhtZ7miAFS+QYQr4gaD+mxS8d4j2@mail.gmail.com>
References: <1284590224-5596-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100915191309.36414a56@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100915191309.36414a56-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 15, 2010 at 6:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 15 Sep 2010 17:37:04 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Attribue Value (AV) pairs or Target Info (TI) pairs are part of
>> ntlmv2 authentication.
>> Structure ntlmv2_resp had only definition for two av pairs.
>> So removed it, and now allocation of av pairs is dynamic.
>> For servers like Windows 7/2008, av pairs sent by server in
>> challege packet (type 2 in the ntlmssp exchange/negotiation) can
>> vary.
>>
>> Server sends them during ntlmssp negotiation. So when ntlmssp is use=
d
>> as an authentication mechanism, type 2 challenge packet from server
>> has this information. =A0Pluck it and use the entire blob for
>> authenticaiton purpose. =A0If user has not specified, extract
>> (netbios) domain name from the av pairs which is used to calculate
>> ntlmv2 hash. =A0Servers like Windows 7 are particular about the AV p=
air
>> blob.
>>
>> Servers like Windows 2003, are not very strict about the contents
>> of av pair blob used during ntlmv2 authentication.
>> So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntl=
mssp),
>> there is no negotiation and so genereate a minimal blob that gets
>> used in ntlmv2 authentication as well as gets sent.
>>
>> Fields tilen and tilbob are session specific. =A0AV pair values are =
defined.
>>
>> To calculate ntlmv2 response we need ti/av pair blob.
>>
>> For sec mech like ntlmssp, the blob is plucked from type 2 response =
from
>> the server. =A0From this blob, netbios name of the domain is retriev=
ed,
>> if user has not already provided, to be included in the Target Strin=
g
>> as part of ntlmv2 hash calculations.
>>
>> For sec mech like ntlmv2, create a minimal, two av pair blob.
>>
>> The allocated blob is freed in case of error. =A0In case there is no=
 error,
>> this blob is used in calculating ntlmv2 response (in CalcNTLMv2_resp=
onse)
>> and is also copied on the response to the server, and then freed.
>>
>> The type 3 ntlmssp response is prepared on a buffer,
>> 5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value large
>> enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
>> 10 values as part of ntlmv2 response and lmv2 keys and domain, user,
>> workstation =A0names etc.
>>
>> Also, kerberos gets selected as a default mechanism if server suppor=
ts it,
>> over the other security mechanisms.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0125 ++++++++++++++++++++++++++++++++++=
++++++++++++--
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 16 ++++---
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
>> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 15 ++++++
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0114 ++++++++++++++++++++++++++=
++++---------------
>> =A08 files changed, 224 insertions(+), 53 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index eed70ca..ab0533a 100644
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
>> @@ -262,6 +263,92 @@ void calc_lanman_hash(const char *password, con=
st char *cryptkey, bool encrypt,
>> =A0}
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>>
>> +/* This is just a filler for ntlmv2 type of security mechanisms.
>> + * Older servers are not very particular about the contents of av p=
airs
>> + * in the blob and for sec mechs like ntlmv2, there is no negotiati=
on
>> + * as in ntlmssp, so unless domain and server =A0netbios and dns na=
mes
>> + * are specified, there is no way to obtain name. =A0In case of ntl=
mssp,
>> + * server provides that info in type 2 challenge packet
>> + */
>> +static int
>> +build_avpair_blob(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
>> + =A0 =A0 ses->tiblob =3D kzalloc(ses->tilen, GFP_KERNEL);
>> + =A0 =A0 if (!ses->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target info allocatio=
n failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->tiblob;
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +/* Server has provided av pairs/target info in the type 2 challenge
>> + * packet and we have plucked it and stored within smb session.
>> + * We parse that blob here to find netbios domain name to be used
>> + * as part of ntlmv2 authentication (in Target String), if not alre=
ady
>> + * specified on the command line.
>> + * If this function returns without any error but without fetching
>> + * domain name, authentication may fail against some server but
>> + * may not fail against other (those who are not very particular
>> + * about target string i.e. for some, just user name might suffice.
>> + */
>> +static int
>> +find_domain_name(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 unsigned int attrsize;
>> + =A0 =A0 unsigned int type;
>> + =A0 =A0 unsigned char *blobptr;
>> + =A0 =A0 unsigned char *blobend;
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 if (!ses->tilen || !ses->tiblob)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (ses->tilen < sizeof(struct ntlmssp2_name))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 blobend =3D ses->tiblob + ses->tilen;
>> + =A0 =A0 blobptr =3D ses->tiblob;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 while (blobptr <=3D blobend) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 type =3D le16_to_cpu(attrptr->type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_EOL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D le16_to_cpu(attrptr->length);
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr size */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (blobptr + attrsize > blobend) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Invalid att=
ribute size: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, attrsize);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAME)=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->domai=
nName =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 kmalloc(attrsize + 1, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->=
domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_=
ucs2(ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (__le16 *)blobptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 load_nls_default(), false);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I'll a=
lso ask again...what's the point
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0of con=
tinuing to parse the buffer
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0once y=
ou reach this point? Why not
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break =
out of the loop at this point and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
?

yes, added break at this point.  No need to traverse any further.

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* advance attr =A0=
value */
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobp=
tr;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
