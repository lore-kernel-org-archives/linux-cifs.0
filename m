From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Samba server problem with validate negotiate info fsctl?
Date: Mon, 18 Nov 2013 17:55:01 -0600
Message-ID: <CAH2r5mt6Qk7mZkmwtQk0ZO2L9emMc90-Zts-N2=o=1rx_YmGUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With the kernel patch I recently submitted to list for review,  tried
the validate negotiate info fsctl (unsigned) on an smb3.0 mount
against Windows 8.1 server and it failed, dropping the connection
immediately.  I repeated it with "sign" mount option and it worked
fine.

Trying the validate negotiate info fsctl against Samba though it
worked fine with signing disabled implying that the server is not
checking to make sure that that request is signed (the validate
negotiate info fsctl is always supposed to be signed right?)

-- 
Thanks,

Steve
