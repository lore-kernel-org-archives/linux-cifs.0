From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Establishing connections in the presence of multi-connect ... should
 we be searching top down not bottom up?
Date: Sun, 19 Aug 2012 12:10:02 -0700
Message-ID: <CACyXjPyWm9SjiuF=nh1UwwsCNPwp_5sXiiVzvUDLnyeVEA-zcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

The SMB3.0 documentation refers to this model for multiple channels:

http://msdn.microsoft.com/en-us/library/cc246488%28v=3Dprot.13%29

This shows multiple sessions, each with a group of channels over
multiple connections. The connections are intended, I believe, to be
references to TCP connections and RDMACM connections. It seems
possible that two sessions to the same server could actually exist
over different connections to the same server.

Currently, in connect.c:cifs_mount we take a bottom up approach. We
search for a TCP session (cifs_get_tcp_session) and as a side effect,
return a new TCP connection if we don't find it.

Then we search for an SMB session on that connection, and, as a side
effect, create a new session if we don't find it.

It the multi-connect world, this *seems* wrong.

It seems to me that we should search for a TCON first, and if we don't
find one, establish a new on.

Establishing a new TCON will cause us to search for an existing
session that matches the credentials we have in hand (and possibly one
matching the transport type or the specific transport we were asked to
use), and if we don't find one, we need to create a new session with
those credentials.

Creating a new session will cause us to search for an existing
connection to the server, at which point we might come up with
multiple connections, and so we can perhaps use the one with the
fewest sessions bound to it or some other heuristic and start the
session. We will also then likely engage in multi-connect with one or
more of the remaining connections. However, if we do not find any
connections of the appropriate type, we will have to create a new
connection (and will want to create more connections if multi-connect
is supported by the server).

So, I am suggesting that the approach we take needs to be re-ordered.
=46ortunately, I think, it is all confined to cifs_mount.

Does anyone have any comments?

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
