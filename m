From: =?UTF-8?B?5ZGo5Lyf5p2w?= <zhou.weijie-9ato6ouKlQJBDgjK7y7TUQ@public.gmane.org>
Subject: A problem of cifs performance
Date: Sat, 27 Jul 2013 09:57:46 +0800
Message-ID: <CALBiAX=iEAff6q-zhtW_hxDVYGFMzPmr0QDVMztW6JevNi4CAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear Sir:

  Situation=EF=BC=9A
  I create a share folder on windows 7,then I mount it via Linux.
  I copy a file from the folder to Linux,but the max read rate is
28MB/s and the write rate can be 110MB/s .
  I try to mount cifs by changing rsize ,but it can't be faster.
  I don't know why the read rate is unusual?

  Environment=EF=BC=9A
  1.RHEL 6.2=EF=BC=9A2.6.32-220.el6.x86_64
  2.CIFS version=EF=BC=9A1.68
  3.mount.cifs version=EF=BC=9A4.8.1

Sincerely
