From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3 security upgrade -fix warning messages on CIFS mount when
 mounting to older servers
Date: Fri, 1 Sep 2017 00:38:19 -0500
Message-ID: <CAH2r5msZwRsdHLu8dEfh6g=A9XmR3R-MDfWUxJJNOQb5KEhsjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There have been some questions about the upgrade of the default client
dialect for cifs.ko from CIFS (SMB1) to SMB3 (discussed in earlier
email threads), but also requests for clarification of some of the
warning messages relating to the default dialect upgrade.  While
additional changes can be made in mount.cifs to make the warnings
clearer, this patch adds additional warnings to the kernel cifs.ko
code, and clarifies the kernel log message when the server does not
support the requested dialect.  See

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=7e682f766f289887c5cbf7c0a1e4970103f01ac4

Additional changes are planned in 4.14 to make this easier, and to
improve the SMB3.1.1 support which is important for multiple reasons,
not just for security improvements but also for the proposed POSIX
extensions.
-- 
Thanks,

Steve
