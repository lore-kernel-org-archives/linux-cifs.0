From: Jamie Bainbridge <jamie.bainbridge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Linux CIFS client interacts badly with SMB Transparent Failover and
 Windows Firewall Stealth Mode
Date: Mon, 12 Sep 2016 11:35:27 +1000
Message-ID: <CAAvyFNhLbnRKJ6AqtjmXAJQ8j-S231YMadMMy76=ZF8vAzt2Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've been able to identify a probable bug with SMB Transparent
Failover and Windows Firewall Stealth Mode which affects Linux CIFS
clients but not Windows.

SMB Transparent failover is a floating VIP between multiple Windows
SMB servers. It's nothing fancy from a CIFS protocol perspective (at
least not SMB v1.0 like the Linux CIFS client uses) it's just a close
of file handles by the server and TCP Reset to end the existing TCP
session, hence forcing the client to re-connect to a "new" server.

Stealth Mode is a setting which results in Windows servers not sending
TCP Resets in situations where they otherwise would, such as receiving
mid-stream traffic for an unknown TCP session. Any such traffic looks
to be silently discarded by the receiver. From what I read, this is on
by default in 2008R2 and later.

The combination of these results in interaction as follows:

1) Old SMB server closes existing client session with a TCP RST
2) Linux CIFS client re-establishes new TCP session instantly
3) Old SMB server closes its listening socket
4) Old SMB server silently ignores client's Protocol Negotiation
5) New SMB server takes over Transparent Failover VIP
6) New SMB server silently ignores client's Protocol Negotiation
7) Linux CIFS client waits entire TCP RTO (~15 minutes) before
establishing a new connection to new server, which succeeds

The Linux CIFS client mount appears to hang for this 15 minute duration.

This doesn't affect Windows clients because they wait 1 second in
between having their session disconnected and establishing a new
session (1 second gap between steps 1 and 2), during which time the
old SMB server closes its listening socket, so the Windows client's
new session is only established to the new server after VIP failover
(after step 5).

This appears to be a bug in the Windows SMB server's Transparent
Failover implementation because it shouldn't be forcibly disconnecting
clients while still having a listening socket open to accept new
connections.

This is further compounded by Stealth Mode's lack of TCP Resets.
Disabling Stealth Mode does allow the Linux CIFS client to terminate
the incorrectly-established new session and establish a new one.
Failover then occurs in 5-10 seconds like the Windows client.

Reading the MS-CIFS and MS-SMB documents I can't see we're doing
anything wrong here, these are both the wrong thing for the Windows
server to do. However my customer is having a hard time convincing
Microsoft support that this is a bug in Windows.

It seems possible to work around this in the Linux CIFS client by
introducing a 1 second sleep before re-establishing a session like so:

------------------------------------------------------------------------
--- linux-3.10.0-327.28.3.el7.x86_64.orig/fs/cifs/connect.c
2016-09-01 12:45:59.277249780 +1000
+++ linux-3.10.0-327.28.3.el7.x86_64/fs/cifs/connect.c  2016-09-02
17:03:41.901270778 +1000
@@ -588,6 +588,7 @@
                } else if (length <= 0) {
                        cifs_dbg(FYI, "Received no data or error:
expecting %d\n"
                                 "got %d", to_read, length);
+                       msleep(1000);
                        cifs_reconnect(server);
                        total_read = -ECONNABORTED;
                        break;
------------------------------------------------------------------------

I've only been able to test this by theoretically reproducing the
behaviour with the Linux Samba server, but it does result in Linux
client behaviour which mimics the Windows client. I haven't tested
this on latest upstream, only recent EL7.

However, the bug still exists in Windows and all clients are
vulnerable to it. If any client (Windows, Linux, other) just happens
to connect to the old server in the <1 second where the "old" SMB
server is disconnecting clients while still accepting connections,
that client's session will hang for the client's TCP Retransmission
Timeout.

1) Should the Linux CIFS client be modified to mimic the 1 second
sleep before reconnect that the Windows client does?

2) Is there anyone from Microsoft watching this who can address this
apparent bug in SMB Transparent Failover?

Jamie
