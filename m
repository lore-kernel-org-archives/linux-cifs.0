From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [2/4] NTLM authentication and signing - Make
 tiblob as part of session key (response)
Date: Fri, 15 Oct 2010 10:19:50 -0500
Message-ID: <AANLkTi=xsrNnryw8mP_snGyMitJ21ian_sehYaN4mzBE@mail.gmail.com>
References: <1286912719-22686-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101015100252.3960b34d@tlielax.poochiereds.net>
	<AANLkTinAftYfvJs-MSN5zbO0ejEBkdT9fcgVzpuJ9eWU@mail.gmail.com>
	<AANLkTimEKGZgzBW+V_UdL3dVa1HNwjHWaYhcT=PHxKra@mail.gmail.com>
	<20101015110847.2ebf4469@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101015110847.2ebf4469-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 15, 2010 at 10:08 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Fri, 15 Oct 2010 09:51:59 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Oct 15, 2010 at 9:36 AM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Fri, Oct 15, 2010 at 9:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
>> >> On Tue, 12 Oct 2010 14:45:19 -0500
>> >> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >>
>> >>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>>
>> >>>
>> >>> Have to move av_pair/ti blob to session key as part of ntlmv2 re=
sponse.
>> >>> This entire blob is part of the response and is use to calculate
>> >>> signature for cases like ntlmv2 (without extended security) auth=
entication.
>> >>> The size of the blob is hard coded to 1024 byte which should be
>> >>> sufficient to accomodate all 11 types of av pair types and their
>> >>> lenghts/values.
>> >>>
>> >>>
>> >>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >> [...]
>> >>
>> >>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> >>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32=
); */
>> >>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >>> index 7d834b1..5dd5659 100644
>> >>> --- a/fs/cifs/cifsglob.h
>> >>> +++ b/fs/cifs/cifsglob.h
>> >>> @@ -105,6 +105,7 @@ struct session_key {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char key[16];
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ntlmv2_resp r=
esp;
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char tiblob[C=
IFS_MAX_NTLMV2_AVPAIR_SIZE];
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
>> >> Is this really the best way to do this? We're increasing the size=
 of
>> >> this struct substantially, thereby increasing the size of every
>> >> TCP_Server_Info and cifsSesInfo struct by 1k.
>> >>
>> >> Would it be better to keep the tiblob dynamically allocated, and =
hand
>> >> off the pointer to it? If it really is necessary to add this fiel=
d to
>> >> the session_key struct in this way, would it be better to change =
how
>> >> session keys are managed? i.e. not embed them inside of TCP_Serve=
r_Info
>> >> and cifsSesInfo?
>> >
>> > Jeff, we need to have a contiguous block of ntlmv2 client response=
 i.e.
>> > First part of client response (CR1), the 16 bytes and the variable=
 second part
>> > of client response which consists of struct ntlmv2_resp and tiblob=
=2E
>> > Without contiguous blob, i.e. if tiblob is a pointer pointing to a=
 dynamically
>> > allocated memory, when it comes to calculating signature, this cod=
e,
>> >
>> > =A0 =A0 =A0 =A0crypto_shash_update(&server->secmech.sdescmd5->shas=
h,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char *)&server->session_key.data, =
len);
>> >
>> > we end up copying incorrect contents.
>> >
>> > I agree 1K is a lot but I can reduce it. av pair/target info blob =
can vary
>> > in size, we can only guestimate how large it could.
>> >
>> > Perhaps I can keep the way it is, and do two updates, one update w=
ith fixed
>> > part, key + ntlmv2_resp structure and another with tiblob.
>> > Let me try that, I think that will work and if it works, we do not
>> > need this patch,
>> > I can make that change as part of current 4/4 patch.
>>
>> In which case we have to keep tiblob and tilen for the life of the s=
mb
>> connection.
>> This is an issue for ntlmv2 authentication without extended security=
 only
>> since the entire client response is used in signature calculation.
>> For ntlmv2 in ntlmssp, only first 16 bytes of the client response ar=
e needed for
>> signature calculation.
>>
>
>
> We only need to keep one of these for the life of the connection,
> right? After the initial authentication is done, only the first
> session_key established on the socket will ever be used again.
>

Jeff, yes.

> Instead of memcpy'ing this key around between embedded session_key
> structs, wouldn't it make more sense to allocate them dynamically, an=
d
> "hand off" the first session key to the socket. Then you could just
> free the others.
>
> It also sort of sucks that this session_key is a union instead of
> having its size dynamically determined. That's quite a bit of wasted
> space for the other cases that don't need a session_key this large.
>
> Maybe the session key should just be a pointer and a length field, th=
at
> gets set up whenever the thing is created?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
