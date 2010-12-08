From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP authentication
Date: Wed, 8 Dec 2010 12:53:15 -0600
Message-ID: <AANLkTikU1OhcT8FmyrOZfrLtgK-8NKnRnFNnczFvz2C_@mail.gmail.com>
References: <1291822865-26472-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101208110608.607a23e2@tlielax.poochiereds.net>
	<AANLkTi=WVaCDRHf5=DgnZr7crJByhH5r6F6S+_PVGY0F@mail.gmail.com>
	<AANLkTinehfVNbrC2gNnDEi5OHDtgjYYimUqYO=+y4Dy6@mail.gmail.com>
	<4CFFCB61.4090807@exx.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFFCB61.4090807-C1IQQP51G3M@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 8, 2010 at 12:16 PM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote=
:
> Also,
>
> Op 8-12-2010 18:28, Shirish Pargaonkar schreef:
>> On Wed, Dec 8, 2010 at 10:33 AM, Shirish Pargaonkar
>
>>>>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>>>>> index 7b01d3f..122ad31 100644
>>>>> --- a/fs/cifs/sess.c
>>>>> +++ b/fs/cifs/sess.c
>>>>> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsi=
gned char *pbuffer,
>
> (...)
>
>>>>> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned c=
har *pbuffer,
>
> The patch you sent me (and which I tested successfully) had an extra
> hunk in it:
>
> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned char
> *pbuffer,
> =A0 =A0 =A0 =A0flags =3D NTLMSSP_NEGOTIATE_56 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOT=
IATE_TARGET_INFO |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTI=
ATE_EXTENDED_SEC;
> =A0 =A0 =A0 =A0if (ses->server->secMode &
> =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>
> Is it your intent to leave out this hunk?

Yes, it does not matter whether that flag bit exists or not in ntlmssp
auth packet (type 3).

>
> Regards,
> Robbert
>
