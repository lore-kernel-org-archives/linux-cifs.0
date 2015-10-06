From: Etienne Desautels <etienne.desautels-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Move file from one share to an other share, all under the same DFS
Date: Tue, 6 Oct 2015 14:12:30 -0400
Message-ID: <CAMFcbfoBZ4d8C8uiFD-7x+XAk8UZ9uO4sd3TwvL3ouXiXNoM7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On a Linux server where a DFS server is mounted I'm trying to move a
file from one share to an other share. Both shares are in the same DFS
and on the same SAN. It works but the file is copied and the original
is deleted, instead of doing a real move where only the reference to
the file is updated. This copy can take a long time for large files
(our case).

If I try the same thing on a Windows computer, the file is only moved,
so it's really fast.

Is it possible to really move the file from the Linux server? If yes,
how? What I'm doing wrong?

I'm mounting the DFS with this fstab line:
//interne.windowsserver.org/shares     /mnt/shares     cifs
credentials=/etc/cifs.credentials,domain=interne,iocharset=utf8,uid=1003,gid
=1003,rw,noexec,nosuid  0 0

shares is like this:
/mnt/shares/share1/
/mnt/shares/share2/

I'm trying to move a file from share1 to share2.

My Linux server run Ubuntu 10.04 (pretty old, I know).
Linux servername 2.6.32-51-server #113-Ubuntu SMP Wed Aug 21 20:01:09
UTC 2013 x86_64 GNU/Linux

Regards,
Etienne Desautels
