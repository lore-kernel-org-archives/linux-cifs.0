From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/11] CIFS: Make wait_for_free_request interruptible
Date: Mon, 27 Feb 2012 17:54:03 -0600
Message-ID: <CAH2r5mt8pF=hoUp5YzHjOvabO5UJaB17Yf8=NfhsxHB-oCsn4g@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-6-git-send-email-piastry@etersoft.ru>
	<20120222141534.5512c3bf@samba.org>
	<CAKywueR7tggS99buChze5WHFY2=daoHUkO41F+WTNfqRT64Syw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR7tggS99buChze5WHFY2=daoHUkO41F+WTNfqRT64Syw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff's point makes sense.  With the suggested fix, seems like reasonabl=
e idea.

On Thu, Feb 23, 2012 at 12:18 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> 2012/2/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> On Wed, 22 Feb 2012 10:32:58 +0300
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> to let us interrupt the proccess if the session went down and echo
>>> is disabled.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =A0fs/cifs/transport.c | =A0 =A07 ++++++-
>>> =A01 files changed, 6 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> index fa93720..938d20b 100644
>>> --- a/fs/cifs/transport.c
>>> +++ b/fs/cifs/transport.c
>>> @@ -257,6 +257,8 @@ smb_send(struct TCP_Server_Info *server, struct=
 smb_hdr *smb_buffer,
>>> =A0static int
>>> =A0wait_for_free_request(struct TCP_Server_Info *server, const int =
long_op)
>>> =A0{
>>> + =A0 =A0 int rc;
>>> +
>>> =A0 =A0 =A0 spin_lock(&server->req_lock);
>>>
>>> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>>> @@ -271,8 +273,11 @@ wait_for_free_request(struct TCP_Server_Info *=
server, const int long_op)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->credits <=3D 0) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->re=
q_lock);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_inc(se=
rver);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->reques=
t_q, get_credits(server) > 0);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_event_interru=
ptible(server->request_q,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_credits(server) > 0);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_dec(se=
rver);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc=
;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&server->req_=
lock);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=
=3D CifsExiting) {
>>
>> In general, I think making this interruptible is a good idea. The
>> problem here though is that you're going to end up interrupting this=
 on
>> any signal. That includes stuff like SIGCHLD -- you don't necessaril=
y
>> want to interrupt this because the process forked off a child earlie=
r
>> and then that child exited...
>>
>> It's probably simpler to just make this a TASK_KILLABLE sleep for th=
at
>> reason, rather than trying to handle different signals differently.
>>
>
> Ok, good points - will change it.
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
