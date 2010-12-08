From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP authentication
Date: Wed, 8 Dec 2010 11:28:53 -0600
Message-ID: <AANLkTinehfVNbrC2gNnDEi5OHDtgjYYimUqYO=+y4Dy6@mail.gmail.com>
References: <1291822865-26472-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101208110608.607a23e2@tlielax.poochiereds.net>
	<AANLkTi=WVaCDRHf5=DgnZr7crJByhH5r6F6S+_PVGY0F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robbert-C1IQQP51G3M@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=WVaCDRHf5=DgnZr7crJByhH5r6F6S+_PVGY0F-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 8, 2010 at 10:33 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Dec 8, 2010 at 10:06 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>> On Wed, =A08 Dec 2010 09:41:05 -0600
>> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>
>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>>
>>> Indicate to the server a capability of NTLM2 session security (NTLM=
2 Key)
>>> during ntlmssp protocol exchange in one of the bits of the flags fi=
eld.
>>> If server supports this capability, send NTLM2 key even if signing =
is not
>>> required on the server.
>>> If the server requires signing, the sesison keys exchanged for NTLM=
v2
>>> and NTLM2 session security in auth packet of the nlmssp exchange ar=
e same.
>>>
>>>
>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =A0fs/cifs/sess.c | =A0 =A07 ++++---
>>> =A01 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>>> index 7b01d3f..122ad31 100644
>>> --- a/fs/cifs/sess.c
>>> +++ b/fs/cifs/sess.c
>>> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsign=
ed char *pbuffer,
>>> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use h=
ere? */
>>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TAR=
GET |
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIA=
TE_UNICODE |
>>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIAT=
E_EXTENDED_SEC;
>>> =A0 =A0 =A0 if (ses->server->secMode &
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED =
| SECMODE_SIGN_ENABLED)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>>> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned cha=
r *pbuffer,
>>> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>>> =A0 =A0 =A0 tmp +=3D 2;
>>>
>>> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_X=
CH) &&
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
>>> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_=
XCH) ||
>>> + =A0 =A0 =A0 =A0 =A0 =A0 ((ses->ntlmssp->server_flags & NTLMSSP_NE=
GOTIATE_EXTENDED_SEC)))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You can (and should) eliminate a set =
of parenthesis here.
>
> Sure.
>
>>
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->ciphertext, C=
IFS_CPHTXT_SIZE);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D c=
pu_to_le32(tmp - pbuffer);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to_=
le16(CIFS_CPHTXT_SIZE);
>>
>> Other than that, it looks reasonable to me. I'll have to take your
>> word for it that this is the right thing to do as I find the NTLMSSP
>> spec really difficult to comprehend.
>>

Yes. It is very confusing.  One of these days, I am planning to go thro=
ugh
all the flags that cifs client sends during ntlmssp negotiation stage (=
type 1).
I think flags do not matter when client sends authentication request (t=
ype 3).
To verify, I set flags field to 0x0 in type 3 packet and both sec=3Dntl=
mssp and
sec=3Dntlmsspi, were successful on a Windows 2003 Server Windows 7, and
Windows 2008 Server.

So we just have to get flags right in ntlmssp negotiate packet (type 1)=
 that
client sends and send things according to capabilities that server retu=
rned in
flags in ntlmssp challenge packet (type 2), in ntlmssp authentication p=
acket
(type 3).

>> It also might be nice to add:
>>
>> =A0 =A0Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
>>
>> ...since he did help track this down.
>>
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>
> Sure, I will respin it. Sorry for the omission Robbert.
>
