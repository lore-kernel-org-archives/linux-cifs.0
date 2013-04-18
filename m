From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CMAC moving to crypto
Date: Thu, 18 Apr 2013 12:23:38 -0500
Message-ID: <CAH2r5msejqQkp=Wkbkim6RyBGrBp5h5neS+cjrJC_W543OY-YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I see that cmac.c is now in Linux crypto directory, presumably
destined for 3.11 kernel.  Presumably would allow hardware
acceleration for new processors which support it in internally ?!

Has anyone looked at whether and how we could use this (in either
kernel or samba)

See:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/crypto/cmac.c

--
Thanks,

Steve
