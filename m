From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 04 Dec 2010 14:17:41 -0600
Message-ID: <4CFAA1E5.5010306@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<4CF9BB65.2010307@samba.org>	<E1POnFL-00BKg9-JW@intern.SerNet.DE>	<20101204064452.46ac24c7@tlielax.poochiereds.net> <AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish Pargaonkar wrote:
:
> Is SMB Echo command the only way to determine whether to reconnect or not?

The SMB Echo can only be sent from the client to the server.  The server has
no mechanism, within the SMB protocol, to "ping" the client.

The Echo is used by the client as a way to test whether it is the connection
that has failed or if the server is simply taking a very long time to
respond to a particular request.

> The assumption here is SMB server is unresponsive.
> There could be other circumstances on the server box (or even client
> box) that are slowing down the SMB server responses such as slow
> network, slow network stack, memory pressure etc.

Right.  So how do you know whether it is the transport connection or the SMB
server that is having trouble?  In theory, the SMB server should answer the
Echo right away, even if it is having other problems.

> So server could be fine all along and yet client would ask for reconnection!

If the network is slow, that's a transport problem.  It's also why the 45
second timeout value is adaptable.  See the earlier message in which I
pointed to the sections in [MS-CIFS] that explain the 45 second timeout and
point at the related KB articles.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
