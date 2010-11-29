From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/14] cifs: overhaul request timeout behavior in CIFS
 (try #1)
Date: Sun, 28 Nov 2010 18:56:27 -0600
Message-ID: <AANLkTi=Z6spe6FU3Q62fmXbj-WuiVkNHs7eyouXEs7nJ@mail.gmail.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
	<AANLkTik67ugsfTapXHoRu-c7Rpra-wofdku2xioOQi6-@mail.gmail.com>
	<20101127113532.62d24bcf@tlielax.poochiereds.net>
	<AANLkTinZzxhcGR9m67+neem85SHU1YA+eOBb3NE9PO4Y@mail.gmail.com>
	<20101127201248.054ec58d@tlielax.poochiereds.net>
	<AANLkTin_8UKz3GFzMMRyGX8AAEEw16H2Y2aj3RGVvXXQ@mail.gmail.com>
	<20101128074309.12ca4e49@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101128074309.12ca4e49-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Nov 28, 2010 at 6:43 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sun, 28 Nov 2010 06:17:54 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sat, Nov 27, 2010 at 7:12 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Sat, 27 Nov 2010 11:38:26 -0600
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Sat, Nov 27, 2010 at 10:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
>> >> > On Sat, 27 Nov 2010 09:08:01 -0600
>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> On Sat, Nov 27, 2010 at 7:01 AM, Jeff Layton <jlayton@poochier=
eds.net> wrote:
>> >> >> > This patchset is intended to fix the unreliable behavior in =
CIFS in the
>> >> >> > face of a server that's taking a long time to process reques=
ts.
>> >> >> >
>> >> >> > In general, the current code sets a timeout for all requests=
 that are
>> >> >> > sent on the wire. If the server doesn't respond to the reque=
st within
>> >> >> > that timeout, the client performs a reconnect and retries th=
e request.
>> >> >> >
>> >> >> > This is dangerous and wasteful behavior for the client. Much=
 of the
>> >> >> > state of a CIFS mount is bound to the socket connection. Bre=
ak the
>> >> >> > socket connection and state is lost.
>> >> >> >
>> >> >> > I believe this the root cause of some data corruption issues=
 that have
>> >> >> > been reported to me. We had a partner report that when they =
copied a
>> >> >> > large file to a CIFS server and then compare the result to t=
he original,
>> >> >> > there is sometimes a mismatch. The problem is highly correla=
ted to
>> >> >> > messages in the ring buffer that indicate that the client re=
connected
>> >> >> > the socket during the test run.
>> >> >> >
>> >> >> > Another problem that I can reliably reproduce -- I have win2=
k8
>> >> >> > installed as a VM guest. When I run connectathon tests to th=
at server,
>> >> >> > it frequently fails on the test that writes 4GB past the EOF=
=2E The
>> >> >> > storage on this server is slow, and it can take longer than =
180s for
>> >> >> > it to zero-fill the output file.
>> >> >> >
>> >> >> > The intent of this patchset is to fundamentally change when =
the client
>> >> >> > decides to reconnect the socket. Instead of the old behavior=
, this
>> >> >> > patchset makes the client wait indefinitely for a response. =
Rather than
>> >> >> > waiting in TASK_UNINTERRUPTIBLE sleep however, the client wa=
its in
>> >> >> > TASK_KILLABLE sleep so that fatal signals will end the sleep=
 and
>> >> >> > return -ERESTARTSYS to the caller.
>> >> >> >
>> >> >> > In order to determine whether the server is completely dead =
or just
>> >> >> > taking a long time to process requests, this patchset has th=
e client
>> >> >> > do an asynchronous SMB echo request every 60s when the clien=
t hasn't
>> >> >> > gotten a reponse. If the server doesn't respond after 5 mins=
, the
>> >> >> > client will attempt to reconnect the socket.
>> >> >> >
>> >> >> > With this patchset, I can reliably run the connectathon test=
s against
>> >> >> > my slow server. Preliminary results using the proprietary te=
st that
>> >> >> > was seeing data corruption have also been promising.
>> >> >> >
>> >> >> > I'd like to see this set considered for inclusion into 2.6.3=
8.
>> >> >> >
>> >> >> > Comments and suggestions welcome.
>> >> >> >
>> >> >> > Jeff Layton (14):
>> >> >> > =A0cifs: move mid result processing into common function
>> >> >> > =A0cifs: wait indefinitely for responses
>> >> >> > =A0cifs: don't reconnect server when we don't get a response
>> >> >> > =A0cifs: clean up handle_mid_response
>> >> >> > =A0cifs: allow for different handling of received response
>> >> >> > =A0cifs: don't fail writepages on -EAGAIN errors
>> >> >> > =A0cifs: handle cancelled requests better
>> >> >> > =A0cifs: make wait_for_free_request take a TCP_Server_Info p=
ointer
>> >> >> > =A0cifs: add cifs_call_async
>> >> >> > =A0cifs: add ability to send an echo request
>> >> >> > =A0cifs: set up recurring workqueue job to do SMB echo reque=
sts
>> >> >> > =A0cifs: reconnect unresponsive servers
>> >> >> > =A0cifs: make hard mounts the default
>> >> >> > =A0cifs: remove code for setting timeouts on requests
>> >> >> >
>> >> >> > =A0fs/cifs/cifs_debug.c | =A0 =A08 +-
>> >> >> > =A0fs/cifs/cifsglob.h =A0 | =A0 19 ++--
>> >> >> > =A0fs/cifs/cifspdu.h =A0 =A0| =A0 15 +++
>> >> >> > =A0fs/cifs/cifsproto.h =A0| =A0 =A07 +
>> >> >> > =A0fs/cifs/cifssmb.c =A0 =A0| =A0 55 ++++++++-
>> >> >> > =A0fs/cifs/connect.c =A0 =A0| =A0128 +++++++++++++++----
>> >> >> > =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 48 ++------
>> >> >> > =A0fs/cifs/sess.c =A0 =A0 =A0 | =A0 =A02 +-
>> >> >> > =A0fs/cifs/transport.c =A0| =A0344 ++++++++++++++++++++++---=
-------------------------
>> >> >> > =A09 files changed, 355 insertions(+), 271 deletions(-)
>> >> >> >
>> >> >> > --
>> >> >> > 1.7.3.2
>> >> >> >
>> >> >> > --
>> >> >> > To unsubscribe from this list: send the line "unsubscribe li=
nux-cifs" in
>> >> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-i=
nfo.html
>> >> >> >
>> >> >>
>> >> >> General question, during all this process and wait, does user =
know
>> >> >> in any way (ideally without setting any debug flags/options) t=
hat a server is
>> >> >> unresponsive, perhaps everytime an echo does not come back wit=
hin
>> >> >> expected time, and then when it is back to normal i.e. respond=
ing?
>> >> >
>> >> > There's no feedback of that sort in the current patches, but so=
mething
>> >> > like that could be added...
>> >> >
>> >> > Note that the behavior here isn't quite analogous to NFS/RPC si=
nce we
>> >> > don't time out requests. So, we can't really base this on a "ma=
jor
>> >> > timeout" like we do there.
>> >> >
>> >> > What sort of behavior do you think would make the most sense he=
re? How
>> >> > often and under what conditions should we do a printk?
>> >> >
>> >> > --
>> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >
>> >>
>> >> I am not sure. =A0But user has to have some indication if a comma=
nd does not
>> >> return in expected time. =A0I think whenever cifs gets ready to s=
end SMB Echo,
>> >> command would perhaps be a time to log that server is not respond=
ing.
>> >> If that SMB Echo response comes back within expected time, server=
 is back
>> >> to normal timing and that can be logged.
>> >>
>> >
>> > I don't think so. Just because we're sending an echo doesn't mean =
that
>> > we should spam the logs. What exactly is an "expected time" anyway=
?
>> > That value is highly variable, dependent on many of different fact=
ors
>> > and often impossible to predict.
>> >
>> > OTOH, if the server isn't responding to echoes, then I think we pr=
obably
>> > are justified in doing a printk. CIFS Servers are expected to resp=
ond
>> > to an echo in a timely fashion even if they are busy.
>> >
>> >> I am not sure whether what gets logged =A0should be either at deb=
ug level
>> >> or error level, error level is preferrable at it would be visible=
 to
>> >> the user without
>> >> setting any debug flags.
>> >> But some test scenarios may want to run clean and if "server not =
responding",
>> >> "server responding" type of messages are logged, it may be flagge=
d or
>> >> deemed annoying.
>> >>
>> >> There are certain commands that can't be "hard mount" kind, they =
have to be
>> >> returned within certain time e.g. if we are unmounting a share an=
d server is
>> >> not responding.
>> >
>> > I'm afraid I have to disagree here. "timing out" certain commands =
is
>> > what has given us the problems we have today. CIFS currently falls=
 flat
>> > on its face when a server is slow to respond to certain command s.

I think these commands such as negotiate, session setup, tree connect,
logoff, non-blocking posix lock, and dfs referral are always soft.

>> >
>> > I'll submit that the best behavior to aim for is the one I'm propo=
sing.
>> > The client ought to wait indefinitely for responses from the serve=
r,
>> > and only give up if the server isn't responding to echoes. The wai=
t
>>
>> Is it possible that server is so slow that client can't even send an=
y
>> more commands such as smb echo? =A0This could be a temporary glitch
>> in the life of a server!
>>
>
> I think that would be indicative of a broken server. We need some
> metric to know whether the socket is dead and that it needs to be
> reconnected. If not SMB echoes, then what do you suggest?

Jeff, I have seen servers with these kind of delays.  If left to itself=
 i.e.
not reconnect socket etc. and just waited for response to arrive, tests
passed on the client against this server passed (i.e. ran the testsuite
without any errors such as data corruption) 72 hour runs.

 CIFS slow rsp: cmd 50 subcmd: 5 mid 10658 A: 0xd9 S: 0xd9 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 22908 A: 0x77 S: 0x77 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 20553 A: 0x74 S: 0x74 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 23332 A: 0x67 S: 0x67 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 28992 A: 0x7f S: 0x7f R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 29547 A: 0x326 S: 0x326 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 31037 A: 0x3ad S: 0x3ad R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 31419 A: 0x340 S: 0x340 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 5 mid 31420 A: 0x17e S: 0x17e R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 32275 A: 0x15f S: 0x15f R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 5 mid 29489 A: 0xd8 S: 0xd8 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 32772 A: 0x5ba S: 0x5ba R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 30114 A: 0xe8 S: 0xe8 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 37722 A: 0x67 S: 0x67 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 56677 A: 0xef S: 0xef R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 49279 A: 0x7c S: 0x7c R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 50051 A: 0x68 S: 0x68 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 8846 A: 0x6e S: 0x6e R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 9075 A: 0xac S: 0xac R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 9620 A: 0xa8 S: 0xa8 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 22769 A: 0x17b S: 0x17b R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 25783 A: 0xae S: 0xae R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 25973 A: 0x556 S: 0x556 R: 0x0

 CIFS slow rsp: cmd 47 subcmd: 0 mid 31016 A: 0x190 S: 0x190 R: 0x0
 CIFS slow rsp: cmd 47 subcmd: 0 mid 34380 A: 0x3e0 S: 0x3e0 R: 0x0
 CIFS slow rsp: cmd 47 subcmd: 0 mid 34381 A: 0x3e1 S: 0x3e1 R: 0x0
 CIFS slow rsp: cmd 46 subcmd: 0 mid 52365 A: 0x56e S: 0x56e R: 0x0
 CIFS slow rsp: cmd 47 subcmd: 0 mid 52366 A: 0x40c S: 0x40c R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 0 mid 34432 A: 0x4e3 S: 0x4e3 R: 0x0
 CIFS slow rsp: cmd 47 subcmd: 0 mid 34433 A: 0x4e3 S: 0x4e3 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 0 mid 54464 A: 0x4a5 S: 0x4a5 R: 0x0

 # dmesg | grep "cmd 50"
 CIFS slow rsp: cmd 50 subcmd: 6 mid 28610 A: 0x209 S: 0x209 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 31581 A: 0x4c2 S: 0x4c2 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 0 mid 57722 A: 0x446 S: 0x446 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 0 mid 37736 A: 0xa8 S: 0xa8 R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 43156 A: 0x19a S: 0x19a R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 0 mid 20926 A: 0x1de S: 0x1de R: 0x0
 CIFS slow rsp: cmd 50 subcmd: 6 mid 43164 A: 0x2e5 S: 0x2e5 R: 0x0

>
>> I am really concerned about a scenario where for example, smbds
>> on a Samba server are killed. =A0Would an user be able to unmount a =
share?
>> Because there will be no response from the server, reconnects are no=
t
>> going help, and user on client machine can only kill a command.
>>
>
> What's the exact scenario that you're concerned with here?
>
> For the purposes of argument, let's assume that the mount is idle -- =
no
> dirty data or open files. We issue a umount on the mountpoint and
> cifs_umount is eventually called. The tcon is put and a CIFSSMBTDis i=
s
> issued. The smbds on the server are down however, and the it isn't
> responding to echoes.
>
> The client will send the TDis and wait for the reply, no replies come
> and we start sending echoes. The echoes won't be responded to however
> and eventually cifs_reconnect is called.

Jeff, who and what will cause cifs_reconnect? Everything hinges on
cifs_reconnect being called right?
Would not client wait for a response to SMB Echo command without
any timeouts?

> The mid is marked
> MID_RETRY_NEEDED and the umount process is woken up. SendReceiveNoRsp
> returns -EAGAIN and CIFSSMBTDis returns 0 and the umount proceeds.
>
> So, it may take a little while but eventually the umount would procee=
d.
>
> If you're really concerned about that situation however, you could ma=
ke
> CIFSSMBTDis use an async call (support for that is added in this
> patchset). That would make the umount return even more quickly than i=
t
> does today.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
