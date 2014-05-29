From: Denys Sobchyshak <denys.sobchyshak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question: mounted windows share suspends or hangs periodically
Date: Thu, 29 May 2014 18:02:27 +0200
Message-ID: <CAGiTGz8ryG+ALwN6pLCjXzqQEAgohWtpJJ4wyyc7L4D2THTrQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi cifs community,

Problem: periodically (meaning that I don't know how to reproduce it)
mounted windows share becomes inaccessible i.e. a simple ls -l command
takes hours to output anything (normally it outputs the contents in
the end though).

Environment: MS Hyper-V with Server 2012 as a host facilitating
communication between CentOS 6.4 and MS Server 2012 guests (everything
64-bit). On windows the folder was marked as public share. On CentOS
cift-utils was installed and fstab entry looks as follows:

//192.168.178.202/share /mnt/share          cifs
uid=504,username=myuser,dom=mydomain,password=mypassword,iocharset=utf8,noperm,ro
0 0

Note: Parallel to it there's also a network attached storage mounted
with linux installed on it and has never failed me even with enabled
suspend and hibernate modes. Also I can't find them now, but I've
noticed some warnings in centOS logs saying that it failed to open a
socket or something alike. Also I've asked this question before and
found a workaround which doesn't help anymore.
http://superuser.com/questions/678855/windows-share-is-not-accessible-from-time-to-time

Question: since I'm not much of a network guy I can't find where the
problem is located and am not even sure how to look for it so I would
appreciate any advises on how to diagnose the problem and/or identify
the source of error. Apart from that I'm wondering if this is a known
issue and how one can resolve it.

--
Cheers and best regards,
Denys Sobchyshak
