From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (unknown)
Date: Wed, 15 Oct 2014 10:01:49 -0500
Message-ID: <CAH2r5mtMSzRaEwRz+TL3+Z1kcBoKq0y8nUHrG4Rf=rFYbz+r1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

smb3 also fails new xfstest generic/035 (as does nfs but for different
reasons) although cifs works.

Looks like need to implement a rename_pending_delete worker function
for smb2/smb2.1/smb3 (as cifs has).

-- 
Thanks,

Steve
