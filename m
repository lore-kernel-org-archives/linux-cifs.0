From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Implementing some SMB2.2/3.0 features ...
Date: Sat, 28 Jul 2012 08:19:48 -0700
Message-ID: <CACyXjPz1fVUKADaan72krJCf-21e1QOrm2s1TEEAxR_S5mk0NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I have started looking at implementing some of the SMB3.0 features.
This is because, in order to do SMB Direct I need multi-connect.

In reading the latest version of the spec ([MS-SMB2] dated July 5,
2012 and available from msdn.microsoft.com) I notice that each session
should have a channel list, which is a list of objects containing a
connection reference and a signing key. It also should have a channel
sequence number.

This means that I will need to change the struct cifs_ses to have a
channel list rather than a struct TCP_Server_Info.

In addition, multi-connect allows multiple connections to the same
actual server, since it allows a session to use multiple TCP
connection on a GbE or 10GbE link. So, it seems that I will need to
introduce an explicit notion of a connection, which the code does not
currently have. This will definitely be needed for SMB Direct, because
the model is that you establish a connection to the server on TCP,
negotiate a protocol and then establish a session and then send an
=46SCTL to discover the (common) set of interfaces the server has. Afte=
r
that, if you notice that the client and server have an RDMA-capable
interface in common, you establish a connection via that interface,
negotiate protocol and then create a session (session setup) but bind
it to the existing session.

Does anyone have any comments at this stage? This seems like a
significant undertaking :-)

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
