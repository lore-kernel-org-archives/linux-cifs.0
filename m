From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [2/4] NTLM authentication and signing - Make
 tiblob as part of session key (response)
Date: Fri, 15 Oct 2010 09:36:16 -0500
Message-ID: <AANLkTinAftYfvJs-MSN5zbO0ejEBkdT9fcgVzpuJ9eWU@mail.gmail.com>
References: <1286912719-22686-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101015100252.3960b34d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101015100252.3960b34d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 15, 2010 at 9:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 12 Oct 2010 14:45:19 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Have to move av_pair/ti blob to session key as part of ntlmv2 respon=
se.
>> This entire blob is part of the response and is use to calculate
>> signature for cases like ntlmv2 (without extended security) authenti=
cation.
>> The size of the blob is hard coded to 1024 byte which should be
>> sufficient to accomodate all 11 types of av pair types and their
>> lenghts/values.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> [...]
>
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 7d834b1..5dd5659 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -105,6 +105,7 @@ struct session_key {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char key[16];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ntlmv2_resp resp;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char tiblob[CIFS_=
MAX_NTLMV2_AVPAIR_SIZE];
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> Is this really the best way to do this? We're increasing the size of
> this struct substantially, thereby increasing the size of every
> TCP_Server_Info and cifsSesInfo struct by 1k.
>
> Would it be better to keep the tiblob dynamically allocated, and hand
> off the pointer to it? If it really is necessary to add this field to
> the session_key struct in this way, would it be better to change how
> session keys are managed? i.e. not embed them inside of TCP_Server_In=
fo
> and cifsSesInfo?

Jeff, we need to have a contiguous block of ntlmv2 client response i.e.
=46irst part of client response (CR1), the 16 bytes and the variable se=
cond part
of client response which consists of struct ntlmv2_resp and tiblob.
Without contiguous blob, i.e. if tiblob is a pointer pointing to a dyna=
mically
allocated memory, when it comes to calculating signature, this code,

        crypto_shash_update(&server->secmech.sdescmd5->shash,
                (char *)&server->session_key.data, len);

we end up copying incorrect contents.

I agree 1K is a lot but I can reduce it. av pair/target info blob can v=
ary
in size, we can only guestimate how large it could.

Perhaps I can keep the way it is, and do two updates, one update with f=
ixed
part, key + ntlmv2_resp structure and another with tiblob.
Let me try that, I think that will work and if it works, we do not
need this patch,
I can make that change as part of current 4/4 patch.


>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } ntlmv2;
>> =A0 =A0 =A0 } data;
>> =A0};
>> @@ -226,7 +227,6 @@ struct cifsSesInfo {
>> =A0 =A0 =A0 struct session_key auth_key;
>> =A0 =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> - =A0 =A0 unsigned char *tiblob; /* target info blob in challenge re=
sponse */
>> =A0 =A0 =A0 bool need_reconnect:1; /* connection reset, uid now inva=
lid */
>> =A0};
>> =A0/* no more than one of the following three session flags may be s=
et */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index b0f4b56..e778165 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -136,6 +136,11 @@
>> =A0#define CIFS_SESS_KEY_SIZE (24)
>>
>> =A0/*
>> + * Max expected size of an av pair blob in ntlmv2 auth exchange
>> + */
>> +#define CIFS_MAX_NTLMV2_AVPAIR_SIZE (1024)
>> +
>> +/*
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
