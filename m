From: Matthew DeLoera <mmdeloera-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Does smbfs use 1 socket per target?
Date: Thu, 15 Feb 2018 12:58:29 -0500
Message-ID: <CAMfosPGqMdRfTzEuALqq46PjKQN5AMhQovx-bFXJ=wa1qFVivg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm sorry if this is a vague question, but I hope someone can correct
or affirm my understanding of smbfs socket behavior.

I read in the mount.cifs manpage for the "port=" option that it will
use an existing connection to that port. So does this mean that
regardless of how many files might be concurrently open on a single
share, regardless how many processes are executing I/O requests, smbfs
multiplexes all associated I/O blocks through the same single TCP
connection?

Is it a persistent connection for as long as the mount exists? (i.e.
I'm using an fstab entry) Granted I know how to use netstat, but
hoping someone might note something authoritative.

Can I infer that if I have 5 fstab entries to unique hosts, and mount
-a, I'll have 5 outbound TCP connections?

Thanks!
- Matthew
