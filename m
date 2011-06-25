From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Fri, 24 Jun 2011 20:46:17 -0500
Message-ID: <BANLkTinyA1xcdEgcHFuq8er9CavoCFJ-vA@mail.gmail.com>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
	<20110608164415.5b8cbf4b@tlielax.poochiereds.net>
	<7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local>
	<20110622163251.16499f4b@tlielax.poochiereds.net>
	<AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
	<6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local>
	<BANLkTi=T+=yaQ7MH7g+gmqjFgP2HX4iqJg@mail.gmail.com>
	<BCB6EBAD1FD74D7B91FBD8B0FA614384@dynamicsourcemfg.local>
	<20110623133759.2c3f4aab@barsoom.rdu.redhat.com>
	<8A647BDD88F1473AAE69C405E3C65EB1@dynamicsourcemfg.local>
	<20110623143000.62f882ed@tlielax.poochiereds.net>
	<4C4F2F3EB4B94403969BF63208AB0831@dynamicsourcemfg.local>
	<20110623153533.4adafcd6@tlielax.poochiereds.net>
	<9171CA638C0A474598851C87B7C92CC0@dynamicsourcemfg.local>
	<20110623171112.71cc4e98@tlielax.poochiereds.net>
	<20110623171442.22d13bec@tlielax.poochiereds.net>
	<AB1032AA058748FFA44899ED551710C6@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shane McColman <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AB1032AA058748FFA44899ED551710C6-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since MaxMpx is a per smb socket restriction, we probably want somethin=
g like:

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1a9fe7f..1957f5d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -453,6 +453,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses=
 *ses)
 		}
 		server->sec_mode =3D (__u8)le16_to_cpu(rsp->SecurityMode);
 		server->maxReq =3D le16_to_cpu(rsp->MaxMpxCount);
+		/* maxReq must be at least 2, almost all servers set to 50,
+		   some old non-MS servers set incorrectly so set to default
+		   (otherwise oplock break e.g. would fail */
+		if (server->maxReq < 2)
+			server->maxReq =3D CIFS_MAX_REQ; /* 50 */
 		server->maxBuf =3D min((__u32)le16_to_cpu(rsp->MaxBufSize),
 				(__u32)CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
 		server->max_vcs =3D le16_to_cpu(rsp->MaxNumberVcs);
@@ -560,6 +565,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses=
 *ses)
 	/* one byte, so no need to convert this or EncryptionKeyLen from
 	   little endian */
 	server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxCount);
+	/* maxReq must be at least 2, almost all servers set to 50,
+	   some old non-MS servers set incorrectly so set to default
+	   (otherwise oplock break e.g. would fail */
+	if (server->maxReq < 2)
+		server->maxReq =3D CIFS_MAX_REQ; /* 50 */
 	/* probably no need to store and check maxvcs */
 	server->maxBuf =3D min(le32_to_cpu(pSMBr->MaxBufferSize),
 			(__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c761935..3f8cf63 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -95,7 +95,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf =3D 0;

-	cFYI(1, "Reconnecting tcp session");
+	cERROR(1, "Reconnecting tcp session in flight %d",
atomic_read(&server->inFlight));  /* BB FIXME */

 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 147aa22..11c6585 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -264,7 +264,12 @@ static int wait_for_free_request(struct
TCP_Server_Info *server,

 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >=3D cifs_max_pending) {
+		/* We must check that don't exceed maxReq but on SMB Negotiate
+		   it is not initted yet (maxReq must be at least two) */
+		if ((atomic_read(&server->inFlight) >=3D cifs_max_pending) ||
+		    ((atomic_read(&server->inFlight) >=3D server->maxReq) &&
+		      (server->maxReq > 1))) {
 			spin_unlock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_STATS2
 			atomic_inc(&server->num_waiters);

On Fri, Jun 24, 2011 at 3:55 PM, Shane McColman
<smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
>
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
> Sent: Thursday, June 23, 2011 3:15 PM
> To: Shane McColman
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: CIFS VFS errors
>
> On Thu, 23 Jun 2011 17:11:12 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Thu, 23 Jun 2011 14:36:53 -0600
>> "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
>>
>> > Here you go.
>> >
>>
>>
>> (re-cc'ing linux-cifs)
>>
>> Ok, thanks. It's a little difficult to tell exactly what the problem=
 is
>> from the capture, but it looks like the server is frequently shuttin=
g
>> down the connection. For instance, in frame 9:
>>
>> =A0 9 =A019.088350 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds >=
 59101
> [RST, ACK] Seq=3D1 Ack=3D5843 Win=3D0 Len=3D0
>>
>> ...and then later in frame 109:
>>
>> 109 =A048.244414 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 5=
9108
> [RST, ACK] Seq=3D10556 Ack=3D18058 Win=3D0 Len=3D0
>>
>> ...etc...
>>
>> Most of the time, the client just reestablishes the connection and
>> keeps on going, but in some cases it looks like other calls are raci=
ng
>> in and being sent before the session and tcon get reestablished. Her=
e's
>> one such case (some names changed to protect the data):
>>
>> Server shuts down connection:
>>
>> 579 194.337478 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 593=
10
> [RST, ACK] Seq=3D10528 Ack=3D18028 Win=3D0 Len=3D0
>>
>> Client reestablishes connection:
>>
>> 580 194.337565 192.168.0.118 -> 192.168.0.177 TCP 41098 > microsoft-=
ds
> [SYN] Seq=3D0 Win=3D14600 Len=3D0 MSS=3D1460 SACK_PERM=3D1 TSV=3D1770=
50784 TSER=3D0 WS=3D7
>> 581 194.337756 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 410=
98
> [SYN, ACK] Seq=3D0 Ack=3D1 Win=3D65535 Len=3D0 MSS=3D1460 WS=3D0 TSV=3D=
0 TSER=3D0
> SACK_PERM=3D1
>> 582 194.337768 192.168.0.118 -> 192.168.0.177 TCP 41098 > microsoft-=
ds
> [ACK] Seq=3D1 Ack=3D1 Win=3D14720 Len=3D0 TSV=3D177050784 TSER=3D0
>>
>> Negotiate request gets sent and reply is received:
>>
>> 583 194.337819 192.168.0.118 -> 192.168.0.177 SMB Negotiate Protocol
> Request
>> 584 194.341931 192.168.0.177 -> 192.168.0.118 SMB Negotiate Protocol
> Response
>>
>> ...QPathInfo gets sent -- this shouldn't happen yet:
>>
>> 585 194.341953 192.168.0.118 -> 192.168.0.177 SMB Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\Nasdasdasdads8
> asdasdsd06.txt
>>
>> ...so the server sends back an error because there's been no session
> setup:
>>
>> 586 194.342145 192.168.0.177 -> 192.168.0.118 SMB Trans2 Response,
> QUERY_PATH_INFO, Error: Bad userid
>>
>> ...session and tcon get reestablished:
>>
>> 587 194.342159 192.168.0.118 -> 192.168.0.177 SMB Session Setup AndX
> Request, User: anonymous
>> 588 194.343149 192.168.0.177 -> 192.168.0.118 SMB Session Setup AndX
> Response
>> 589 194.343180 192.168.0.118 -> 192.168.0.177 SMB Tree Connect AndX
> Request, Path: \\asdfasdf1\Aasdsd_1 (F)
>> 590 194.343390 192.168.0.177 -> 192.168.0.118 SMB Tree Connect AndX
> Response
>>
>> ...and then things work fine until the server shuts down the connect=
ion
>> again. In this case, just the QPathInfo failed, but in a later case =
of
>> this, a number of calls race in before things get set back up again =
and
>> that's probably where you see the problems occurring.
>>
>> The above problem is a pretty clear condemnation of the whole
>> tcpStatus handling model in cifs. The checks we have to determine
>> whether something should get sent on the socket are racy. That's not=
 a
>> new bug though -- this code has been this way for a long, long time.
>>
>> I think though that this is at its root a server-inflicted wound. If
>> you can figure out why your server is shutting down the connection,
>> you'll probably fix the problems you're seeing.
>>
>> In the meantime, we probably need to overhaul the cifs code such tha=
t
>> the above problem can't occur, but that's not trivial and probably
>> isn't going to be fixed anytime soon.
>>
>
> Ahh, I think I might see the cause. In the server's Negotiate reply:
>
> =A0 =A0 Max Mpx Count: 10
>
> ...the client currently ignores this value from the server and uses a
> module parm (!?!) to set this. What you may want to do is set the
> cifs_max_pending module parm on cifs.ko to 10 and see if that makes
> things behave better.
>
>
> I verified that Windows XP only allows a max of 10 connections as set=
 by
> Microsoft. =A0This machine already has 5 connections from the 5 piece=
s of
> equipment here, so I'm left with 5. For this reason I set cifs_max_pe=
nding=3D4
> to stay on the safe side. =A0That was at 9:30 this morning and have n=
ot had an
> error since. =A0I'll check again on Monday and give you an update.
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
