From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Cleanup and thus reduce smb session structure and
 fields used during authentication
Date: Thu, 28 Oct 2010 15:07:09 -0500
Message-ID: <AANLkTin=q8YHjETGzoFy=GWM1U=N-F_NbbC4ePpojoZB@mail.gmail.com>
References: <1288277587-9262-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101028155810.5fb3ccdf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101028155810.5fb3ccdf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 28, 2010 at 2:58 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 28 Oct 2010 09:53:07 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Removed following fields from smb session structure
>> =A0cryptkey, ntlmv2_hash, tilen, tiblob
>> and ntlmssp_auth structure is allocated dynamically only if the auth=
 mech
>> in NTLMSSP.
>>
>> response field within a session_key structure is used to initially s=
tore the
>> target info (either plucked from type 2 challenge packet in case of =
NTLMSSP
>> or fabricated in case of NTLMv2 without extended security) and then =
to store
>> Message Authentication Key (mak) (session key + client response).
>>
>> Server challenge or cryptkey needed during a NTLMSSP authentication
>> is now part of ntlmssp_auth structure which gets allocated and freed
>> once authenticaiton process is done.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Ack, assuming that this is needed for the later NTLMSSP cleanup patch
> to merge.
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, Thanks.  Do you mean prior instead of later?

[PATCH] NTLM auth and sign - Use appropriate server challenge

should go in first. But it is not marked as either ack'ed or review'ed =
yet.

Regards,

Shirish
