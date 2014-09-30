From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3.1
Date: Mon, 29 Sep 2014 22:34:45 -0500
Message-ID: <CAH2r5muUefL9-fyVbSX9LBOV1+ANTbY0qmLMOW=ngJaf9qwOvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Microsoft described the security/negotation improvements in progress
for the SMB3.1 protocol earlier this month. See

http://www.snia.org/sites/default/files2/SDC2014/presentations/SMB/Kruse-Kramer_Introduction_to_SMB_3-1.pdf

and  in

http://download.microsoft.com/download/C/6/C/C6C3C6F1-E84A-44EF-82A9-49BD3AAD8F58/Windows/%5BMS-SMB2-Diff%5D.pdf

I was glad we were able to make progress testing Samba and also Linux
support for this.  The patches for kernel client support aren't
complete yet (but at least with the experimental patch at
http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/smb3.1
the kernel client can mount with signing disabled).

When the Windows implementations become available I am looking forward
to seeing how this improves speed of signing (and encryption).

-- 
Thanks,

Steve
