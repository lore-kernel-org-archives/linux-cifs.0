From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: fix length vs. total_read confusion in cifs_demultiplex_thread
Date: Thu, 27 Jan 2011 18:35:18 +0300
Message-ID: <AANLkTi=_SYfkzzdPRKCM0McmvtNLaVwWw85DnMYk=Uqz@mail.gmail.com>
References: <1296132476-21948-1-git-send-email-jlayton@redhat.com>
	<AANLkTik1414JRSN5d2VJ1hYsbOYZpmQcdW8wH+F0LRCO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik1414JRSN5d2VJ1hYsbOYZpmQcdW8wH+F0LRCO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/27 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/1/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> length at this point is the length returned by the last kernel_recvm=
sg
>> call. total_read is the length of all of the data read so far. lengt=
h
>> is more or less meaningless at this point, so use total_read for
>> everything.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A07 +++----
>> =A01 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 47034af..12a3e04 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -581,11 +581,10 @@ incomplete_rcv:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (reconnect =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 length +=3D 4; /* account for rfc1002 =
hdr */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_read +=3D 4; /* account for rfc1=
002 hdr */
>>
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, length);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (checkSMB(smb_buffer, smb_buffer->M=
id, total_read+4)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, total_read);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (checkSMB(smb_buffer, smb_buffer->M=
id, total_read)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mem("Bad SM=
B: ", smb_buffer, 48);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> --
>> 1.7.3.4
>>
>
> Looks right.
>
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>

I've just noticed that you reject the second patch of this set. If
this one won't be changed you can feel free to leave above tag.

--=20
Best regards,
Pavel Shilovsky.
