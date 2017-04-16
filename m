From: Alastair Rankine <alastair-cr5PMK9k0NKsTnJN9+BGXg@public.gmane.org>
Subject: SMB2_ECHO Flags2
Date: Sun, 16 Apr 2017 16:54:10 -0400
Message-ID: <1492376050.8438.7.camel@yahoo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi, CIFS newbie here, please excuse my inevitable gaffes. Also the
mailing list archives are down so I can't tell if this is an active
issue or not. Again, my apologies.

I'm connecting to a MacOS (10.11.6) server from a Linux client (kernel
4.9.18, debian testing). It connects fine and seems to work, but after
a while the server log gets flooded with messages like this:

4/16/17 2:36:20.987 PM smbd[86828]: 192.168.1.12 SMB client not
supported - Unicode strings are required
4/16/17 2:36:20.989 PM smbd[86828]: 192.168.1.12 SMB client not
supported - Unicode strings are required
4/16/17 2:36:20.989 PM smbd[86828]: 192.168.1.12 SMB client not
supported - Unicode strings are required
4/16/17 2:36:20.990 PM smbd[86828]: 192.168.1.12 SMB client not
supported - Unicode strings are required
4/16/17 2:36:20.991 PM smbd[86828]: 192.168.1.12 SMB client not
supported - Unicode strings are required

Using Wireshark I traced this to the SMB Echo request being issued from
the client:

SMB (Server Message Block Protocol)
=C2=A0=C2=A0=C2=A0=C2=A0SMB Header
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Server Component: SMB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Response in: 197]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SMB Command: Echo (0x2b)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Error Class: Success (0x00)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Reserved: 00
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Error Code: No Error
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Flags: 0x00
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Flags2: 0x0001, Long Names =
Allowed
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Process ID High: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Signature: 0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Reserved: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Tree ID: 65535=C2=A0=C2=A0(=
\\192.168.1.10\IPC$)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Pa=
th: \\192.168.1.10\IPC$]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Ma=
pped in: 26]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Process ID: 45
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0User ID: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Multiplex ID: 0
=C2=A0=C2=A0=C2=A0=C2=A0Echo Request (0x2b)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Word Count (WCT): 1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Echo Count: 1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Byte Count (BCC): 1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Echo Data: 61

The server responds thusly:

SMB (Server Message Block Protocol)
=C2=A0=C2=A0=C2=A0=C2=A0SMB Header
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Server Component: SMB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Response to: 195]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Time from request: 0.00063=
2456 seconds]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SMB Command: Echo (0x2b)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NT Status: STATUS_NOT_SUPPO=
RTED (0xc00000bb)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Flags: 0x80, Request/Respon=
se
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Flags2: 0xc841, Unicode Str=
ings, Error Code Type, Extended
Security Negotiation, Long Names Used, Long Names Allowed
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Process ID High: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Signature: 0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Reserved: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Tree ID: 65535=C2=A0=C2=A0(=
\\192.168.1.10\IPC$)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Pa=
th: \\192.168.1.10\IPC$]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Ma=
pped in: 26]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Process ID: 45
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0User ID: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Multiplex ID: 0
=C2=A0=C2=A0=C2=A0=C2=A0Echo Response (0x2b)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Word Count (WCT): 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Byte Count (BCC): 0

This corresponds with a server log entry at the same time on an
otherwise idle session. My theory is that the echo request header
Flags2 field does not have the Unicode Strings flag enabled, and hence
the server is rejecting it.

So the problems really start after about an hour - the client decides
to increase the frequency at which it sends echo requests. Again from
looking at the wireshark logs I can see it decreasing the echo interval
 from 1 minute down to about 20 seconds. But the server reacts poorly
to this - probably triggering a message reject rate limit. After about
another minute at the increased echo rate, the server decides to
terminate the connection.

So then we go into a tight loop where the client reconnects, sends an
echo request, and is instantly disconnected by the server, which in
turn triggers an instant reconnect. Meanwhile the server logs are
filling up and the machine is actually struggling to keep up.

I can provide packet captures for all of the above if required.

It seems to me that not setting the Flags2 field correctly for the echo
request is at the heart of this problem. Looking at the code for
SMB2_echo I see that the request header is initialized via a call to
small_smb2_init. This in turn calls header_assemble to initialize the
header, which can set the relevant Flags2 flags, but only if it is
provided with a cifs_tcon pointer as a function parameter.
Unfortunately in this case the SMB2_echo function passes NULL. So one
possible fix here would be to populate this parameter, although it's
not immediately obvious how this could be done.

Hope this all makes sense, please let me know if not.
