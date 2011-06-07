From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Mon, 6 Jun 2011 20:00:14 -0500
Message-ID: <BANLkTimkinsfojB0=Sf5=o5HBOfiTWTsAA@mail.gmail.com>
References: <4DE5385C.1030808@candelatech.com>
	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
	<4DE54561.1090906@candelatech.com>
	<20110531164408.178eeebf@tlielax.poochiereds.net>
	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
	<4DE55537.5040705@candelatech.com>
	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>
	<20110601140139.079287da@tlielax.poochiereds.net>
	<4DE67FFE.3040907@candelatech.com>
	<20110601150621.7b465941@tlielax.poochiereds.net>
	<4DE69041.5070802@candelatech.com>
	<4DE94B97.8090302@candelatech.com>
	<20110603214204.318602e8@corrin.poochiereds.net>
	<4DE9BCAF.10303@candelatech.com>
	<20110604071923.777c666f@corrin.poochiereds.net>
	<20110606094547.0c04d1c5@tlielax.poochiereds.net>
	<4DED04AC.7090508@candelatech.com>
	<20110606125143.56da1fdb@tlielax.poochiereds.net>
	<4DED0CCA.6090305@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DED0CCA.6090305-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Ben,
Thanks - this may be a very rare case - hard to prove without your test=
ing
but it looks like Jeff's patch makes sense.

On Mon, Jun 6, 2011 at 12:22 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> w=
rote:
> On 06/06/2011 09:51 AM, Jeff Layton wrote:
>>
>> On Mon, 06 Jun 2011 09:47:40 -0700
>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> =A0wrote:
>>
>>> On 06/06/2011 06:45 AM, Jeff Layton wrote:
>>>>
>>>> On Sat, 4 Jun 2011 07:19:23 -0400
>
>>>> [PATCH] cifs: don't allow cifs_reconnect to exit with NULL socket
>>>> =A0pointer
>>>>
>>>> It's possible for the following set of events to happen:
>>>>
>>>> cifsd calls cifs_reconnect which reconnects the socket. A userspac=
e
>>>> process then calls cifs_negotiate_protocol to handle the NEGOTIATE=
 and
>>>> gets a reply. But, while processing the reply, cifsd calls
>>>> cifs_reconnect again. =A0Eventually the GlobalMid_Lock is dropped =
and the
>>>> reply from the earlier NEGOTIATE completes and the tcpStatus is se=
t to
>>>> CifsGood. cifs_reconnect then goes through and closes the socket a=
nd
>>>> sets the
>>>> pointer to zero, but because the status is now CifsGood, the new s=
ocket
>>>> is not created and cifs_reconnect exits with the socket pointer se=
t to
>>>> NULL.
>>>>
>>>> Fix this by only setting the tcpStatus to CifsGood if the tcpStatu=
s is
>>>> CifsNeedNegotiate, and by making sure that generic_ip_connect is a=
lways
>>>> called at least once in cifs_reconnect.
>>>>
>>>> Note that this is not a perfect fix for this issue. It's still pos=
sible
>>>> that the NEGOTIATE reply is handled after the socket has been clos=
ed and
>>>> reconnected. In that case, the socket state will look correct but =
it no
>>>> NEGOTIATE was performed on it. In that situation though the server
>>>> should just shut down the socket on the next attempted send, rathe=
r
>>>> than causing the oops that occurs today.
>>>>
>>>> Reported-by: Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>>>> Signed-off-by: Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>> =A0 fs/cifs/connect.c | =A0 =A06 +++---
>>>> =A0 1 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>> index 84c7307..8bb55bc 100644
>>>> --- a/fs/cifs/connect.c
>>>> +++ b/fs/cifs/connect.c
>>>> @@ -152,7 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(mid_entry);
>>>> =A0 =A0 =A0 =A0}
>>>>
>>>> - =A0 =A0 =A0 while (server->tcpStatus =3D=3D CifsNeedReconnect) {
>>>> + =A0 =A0 =A0 do {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we should try only the port we c=
onnected to before */
>>>> @@ -167,7 +167,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ser=
ver->tcpStatus =3D CifsNeedNegotiate;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&Global=
Mid_Lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>> - =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 } while (server->tcpStatus =3D=3D CifsNeedReconnect)=
;
>>>>
>>>> =A0 =A0 =A0 =A0return rc;
>>>> =A0 }
>>>> @@ -3371,7 +3371,7 @@ int cifs_negotiate_protocol(unsigned int xid=
,
>>>> struct cifs_ses *ses)
>>>> =A0 =A0 =A0 =A0}
>>>> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus !=3D CifsExiti=
ng)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsNee=
dNegotiate)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->tcpStatus =3D=
 CifsGood;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
>>>
>>>
>>> This has some merge issues on 3.6.38.8:
>>>
>>>
>>> <<<<<<<
>>> =A0 =A0 =A0 =A0while ((server->tcpStatus !=3D CifsExiting)&&
>>> =A0 =A0 =A0 =A0(server->tcpStatus !=3D CifsGood)) {
>>> =3D=3D=3D=3D=3D=3D=3D
>>> =A0 =A0 =A0 =A0do {
>>> =A0>>>>>>>
>>>
>>> Should I keep your comparison for tcpStatus =3D=3D CifsNeedReconnec=
t
>>> instead of these !=3D comparisons above?
>>>
>>>
>>> Thanks,
>>> Ben
>>>
>>
>> No, I think you probably just want to take patch fd88ce9313 too, whi=
ch
>> should fix up the merge conflict.
>
> Ok, I've applied those two..we'll start testing with these patches
> today. =A0Might take a while before we are certain the fix works, as
> this isn't usually easy or fast to reproduce.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc =A0http://www.candelatech.com
>
>



--=20
Thanks,

Steve
