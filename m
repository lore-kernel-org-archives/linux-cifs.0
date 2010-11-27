From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/14] cifs: overhaul request timeout behavior in CIFS
 (try #1)
Date: Sat, 27 Nov 2010 11:38:26 -0600
Message-ID: <AANLkTinZzxhcGR9m67+neem85SHU1YA+eOBb3NE9PO4Y@mail.gmail.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
	<AANLkTik67ugsfTapXHoRu-c7Rpra-wofdku2xioOQi6-@mail.gmail.com>
	<20101127113532.62d24bcf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101127113532.62d24bcf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Nov 27, 2010 at 10:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Sat, 27 Nov 2010 09:08:01 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sat, Nov 27, 2010 at 7:01 AM, Jeff Layton <jlayton-vpEMnDpepFvY2uhgrK1nQg@public.gmane.org=
t> wrote:
>> > This patchset is intended to fix the unreliable behavior in CIFS i=
n the
>> > face of a server that's taking a long time to process requests.
>> >
>> > In general, the current code sets a timeout for all requests that =
are
>> > sent on the wire. If the server doesn't respond to the request wit=
hin
>> > that timeout, the client performs a reconnect and retries the requ=
est.
>> >
>> > This is dangerous and wasteful behavior for the client. Much of th=
e
>> > state of a CIFS mount is bound to the socket connection. Break the
>> > socket connection and state is lost.
>> >
>> > I believe this the root cause of some data corruption issues that =
have
>> > been reported to me. We had a partner report that when they copied=
 a
>> > large file to a CIFS server and then compare the result to the ori=
ginal,
>> > there is sometimes a mismatch. The problem is highly correlated to
>> > messages in the ring buffer that indicate that the client reconnec=
ted
>> > the socket during the test run.
>> >
>> > Another problem that I can reliably reproduce -- I have win2k8
>> > installed as a VM guest. When I run connectathon tests to that ser=
ver,
>> > it frequently fails on the test that writes 4GB past the EOF. The
>> > storage on this server is slow, and it can take longer than 180s f=
or
>> > it to zero-fill the output file.
>> >
>> > The intent of this patchset is to fundamentally change when the cl=
ient
>> > decides to reconnect the socket. Instead of the old behavior, this
>> > patchset makes the client wait indefinitely for a response. Rather=
 than
>> > waiting in TASK_UNINTERRUPTIBLE sleep however, the client waits in
>> > TASK_KILLABLE sleep so that fatal signals will end the sleep and
>> > return -ERESTARTSYS to the caller.
>> >
>> > In order to determine whether the server is completely dead or jus=
t
>> > taking a long time to process requests, this patchset has the clie=
nt
>> > do an asynchronous SMB echo request every 60s when the client hasn=
't
>> > gotten a reponse. If the server doesn't respond after 5 mins, the
>> > client will attempt to reconnect the socket.
>> >
>> > With this patchset, I can reliably run the connectathon tests agai=
nst
>> > my slow server. Preliminary results using the proprietary test tha=
t
>> > was seeing data corruption have also been promising.
>> >
>> > I'd like to see this set considered for inclusion into 2.6.38.
>> >
>> > Comments and suggestions welcome.
>> >
>> > Jeff Layton (14):
>> > =A0cifs: move mid result processing into common function
>> > =A0cifs: wait indefinitely for responses
>> > =A0cifs: don't reconnect server when we don't get a response
>> > =A0cifs: clean up handle_mid_response
>> > =A0cifs: allow for different handling of received response
>> > =A0cifs: don't fail writepages on -EAGAIN errors
>> > =A0cifs: handle cancelled requests better
>> > =A0cifs: make wait_for_free_request take a TCP_Server_Info pointer
>> > =A0cifs: add cifs_call_async
>> > =A0cifs: add ability to send an echo request
>> > =A0cifs: set up recurring workqueue job to do SMB echo requests
>> > =A0cifs: reconnect unresponsive servers
>> > =A0cifs: make hard mounts the default
>> > =A0cifs: remove code for setting timeouts on requests
>> >
>> > =A0fs/cifs/cifs_debug.c | =A0 =A08 +-
>> > =A0fs/cifs/cifsglob.h =A0 | =A0 19 ++--
>> > =A0fs/cifs/cifspdu.h =A0 =A0| =A0 15 +++
>> > =A0fs/cifs/cifsproto.h =A0| =A0 =A07 +
>> > =A0fs/cifs/cifssmb.c =A0 =A0| =A0 55 ++++++++-
>> > =A0fs/cifs/connect.c =A0 =A0| =A0128 +++++++++++++++----
>> > =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 48 ++------
>> > =A0fs/cifs/sess.c =A0 =A0 =A0 | =A0 =A02 +-
>> > =A0fs/cifs/transport.c =A0| =A0344 ++++++++++++++++++++++---------=
-------------------
>> > =A09 files changed, 355 insertions(+), 271 deletions(-)
>> >
>> > --
>> > 1.7.3.2
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> General question, during all this process and wait, does user know
>> in any way (ideally without setting any debug flags/options) that a =
server is
>> unresponsive, perhaps everytime an echo does not come back within
>> expected time, and then when it is back to normal i.e. responding?
>
> There's no feedback of that sort in the current patches, but somethin=
g
> like that could be added...
>
> Note that the behavior here isn't quite analogous to NFS/RPC since we
> don't time out requests. So, we can't really base this on a "major
> timeout" like we do there.
>
> What sort of behavior do you think would make the most sense here? Ho=
w
> often and under what conditions should we do a printk?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I am not sure.  But user has to have some indication if a command does =
not
return in expected time.  I think whenever cifs gets ready to send SMB =
Echo,
command would perhaps be a time to log that server is not responding.
If that SMB Echo response comes back within expected time, server is ba=
ck
to normal timing and that can be logged.

I am not sure whether what gets logged  should be either at debug level
or error level, error level is preferrable at it would be visible to
the user without
setting any debug flags.
But some test scenarios may want to run clean and if "server not respon=
ding",
"server responding" type of messages are logged, it may be flagged or
deemed annoying.

There are certain commands that can't be "hard mount" kind, they have t=
o be
returned within certain time e.g. if we are unmounting a share and serv=
er is
not responding.
