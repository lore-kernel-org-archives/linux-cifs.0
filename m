From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] NTLM auth and sign - Use appropriate server challenge
Date: Wed, 27 Oct 2010 16:18:06 -0500
Message-ID: <AANLkTikx7cPwtbHP=pe4nYqS2EGz-CMa2wNPjZoqgLFg@mail.gmail.com>
References: <1288210836-12380-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101027165619.512b50e8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101027165619.512b50e8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 27, 2010 at 3:56 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 27 Oct 2010 15:20:36 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Need to have cryptkey or server challenge in smb connection
>> (struct TCP_Server_Info) for ntlm and ntlmv2 auth types for which
>> cryptkey (Encryption Key) is supplied just once in Negotiate Protoco=
l
>> response during an smb connection setup for all the smb sessions ove=
r
>> that smb connection.
>>
>> For ntlmssp, cryptkey or server challenge is provided for every
>> smb session in type 2 packet of ntlmssp negotiation, the cryptkey
>> provided during Negotiation Protocol response before smb connection
>> does not count.
>>
>> Rename cryptKey to cryptkey and related changes.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 10 +++++++---
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 ++-
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 =A04 ++--
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A04 ++--
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 12 ++++++++----
>> =A05 files changed, 21 insertions(+), 12 deletions(-)
>>
>
> [...]
>
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 67d6a22..b736951 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -196,6 +196,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 int capabilities; /* allow selective disabling of caps b=
y smb sess */
>> =A0 =A0 =A0 int timeAdj; =A0/* Adjust for difference in server time =
zone in sec */
>> =A0 =A0 =A0 __u16 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - rota=
ting counter */
>> + =A0 =A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlm=
v2 etc */
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null =
*/
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL=
];
>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature =
*/
>> @@ -240,7 +241,7 @@ struct cifsSesInfo {
>> =A0 =A0 =A0 char userName[MAX_USERNAME_SIZE + 1];
>> =A0 =A0 =A0 char *domainName;
>> =A0 =A0 =A0 char *password;
>> - =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE];
>> + =A0 =A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlmssp */
>
> I'm trying to understand why we need ses->cryptkey at all. It holds t=
he
> cryptkey provided by the server only if we're using ntlmssp. It's
> only used once, and essentially it just holds the key until we have a
> auth_key.response field that we can stuff this in. Is that correct? I=
f
> so, wouldn't it make more sense to just allocate the auth_key.respons=
e
> field earlier and put this directly in there?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, we could do that.  We then have to allocate .response in function
decode_ntlmssp_challenge().  We have to worry about freeing it if there
are any errors between decode_ntlmssp_challenge() and setup_ntlmv2_resp=
onse().
In function setup_ntlmv2_rsp(), we have to allocate .response only if c=
alled
in case of ntlmv2 without extended security, so an extra if statement i=
n there.

I think current code is simpler for the price of 16 bytes of cryptkey s=
torage?
