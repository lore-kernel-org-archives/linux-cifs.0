From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Tue, 27 Sep 2011 16:36:22 -0500
Message-ID: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI - The cifs async write in 3.0 seems to exacerbate problems running
out of memory (apparently) on the Windows 7 system (running as a
server) after a large file copy to the server completes.   I have been
able to reproduce the same problem on Windows Vista Service Pack 2
(which is a good news/bad news story since my earlier testing on
Windows Vista showed hangs on some requests rather than returning out
of memory).  Does not seem to be a problem with any of the Windows
server versions just Windows 7 and Vista so far.

As Pavel noted in an earlier note, increasing MaxWorkItems to 4096 in
the Windows registry solves this.

The cifs async write code does increase large file copy speed
dramatically (more than 15% in most environments) - but we are working
through how to handle the Windows7/WindowsVista problem to see if
there are workarounds.

-- 
Thanks,

Steve
