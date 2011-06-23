From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Thu, 23 Jun 2011 17:11:12 -0400
Message-ID: <20110623171112.71cc4e98@tlielax.poochiereds.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9171CA638C0A474598851C87B7C92CC0-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Jun 2011 14:36:53 -0600
"Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:

> Here you go.
> 


(re-cc'ing linux-cifs)

Ok, thanks. It's a little difficult to tell exactly what the problem is
from the capture, but it looks like the server is frequently shutting
down the connection. For instance, in frame 9:

  9  19.088350 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 59101 [RST, ACK] Seq=1 Ack=5843 Win=0 Len=0

...and then later in frame 109:

109  48.244414 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 59108 [RST, ACK] Seq=10556 Ack=18058 Win=0 Len=0

...etc...

Most of the time, the client just reestablishes the connection and
keeps on going, but in some cases it looks like other calls are racing
in and being sent before the session and tcon get reestablished. Here's
one such case (some names changed to protect the data):

Server shuts down connection:

579 194.337478 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 59310 [RST, ACK] Seq=10528 Ack=18028 Win=0 Len=0

Client reestablishes connection:

580 194.337565 192.168.0.118 -> 192.168.0.177 TCP 41098 > microsoft-ds [SYN] Seq=0 Win=14600 Len=0 MSS=1460 SACK_PERM=1 TSV=177050784 TSER=0 WS=7
581 194.337756 192.168.0.177 -> 192.168.0.118 TCP microsoft-ds > 41098 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460 WS=0 TSV=0 TSER=0 SACK_PERM=1
582 194.337768 192.168.0.118 -> 192.168.0.177 TCP 41098 > microsoft-ds [ACK] Seq=1 Ack=1 Win=14720 Len=0 TSV=177050784 TSER=0

Negotiate request gets sent and reply is received:

583 194.337819 192.168.0.118 -> 192.168.0.177 SMB Negotiate Protocol Request
584 194.341931 192.168.0.177 -> 192.168.0.118 SMB Negotiate Protocol Response

...QPathInfo gets sent -- this shouldn't happen yet:

585 194.341953 192.168.0.118 -> 192.168.0.177 SMB Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\Nasdasdasdads8 asdasdsd06.txt

...so the server sends back an error because there's been no session setup:

586 194.342145 192.168.0.177 -> 192.168.0.118 SMB Trans2 Response, QUERY_PATH_INFO, Error: Bad userid

...session and tcon get reestablished:

587 194.342159 192.168.0.118 -> 192.168.0.177 SMB Session Setup AndX Request, User: anonymous
588 194.343149 192.168.0.177 -> 192.168.0.118 SMB Session Setup AndX Response
589 194.343180 192.168.0.118 -> 192.168.0.177 SMB Tree Connect AndX Request, Path: \\asdfasdf1\Aasdsd_1 (F)
590 194.343390 192.168.0.177 -> 192.168.0.118 SMB Tree Connect AndX Response

...and then things work fine until the server shuts down the connection
again. In this case, just the QPathInfo failed, but in a later case of
this, a number of calls race in before things get set back up again and
that's probably where you see the problems occurring.

The above problem is a pretty clear condemnation of the whole
tcpStatus handling model in cifs. The checks we have to determine
whether something should get sent on the socket are racy. That's not a
new bug though -- this code has been this way for a long, long time.

I think though that this is at its root a server-inflicted wound. If
you can figure out why your server is shutting down the connection,
you'll probably fix the problems you're seeing.

In the meantime, we probably need to overhaul the cifs code such that
the above problem can't occur, but that's not trivial and probably
isn't going to be fixed anytime soon.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
