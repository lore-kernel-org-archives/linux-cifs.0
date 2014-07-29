From: Kyle Harrigan <kwharrigan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: "CIFS VFS: Server requires packet signing to be enabled" with a krb5i mount
Date: Tue, 29 Jul 2014 10:21:10 -0400
Message-ID: <CAFknXfCta1aj2=8GqxK6PN5ryprL6AsJ2HNDY+ToaufBnvvgbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have a number of mounts to WS2008 using krb5i and multiuser.

/etc/fstab:
//mountname /location cifs sec=krb5i,multiuser,user=MACHINE$ 0 0

Is this expected behavior?  Can the message be safely ignored or is it
indicative of an underlying issue?  I thought krb5i would be
sufficient indication that I intend for packet signing to be enabled.

I have played around with modifying /proc/fs/cifs/SecurityFlags
(0x9009) in /etc/rc.local, but doesn't seem to help.

Kernel is 2.6.32-358.

Thanks.



-- 
-Kyle
