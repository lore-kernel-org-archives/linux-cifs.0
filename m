From: Alex Perez <quimicefa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Zero size and zero blocks mountpoint.
Date: Fri, 24 Sep 2010 13:18:45 +0200
Message-ID: <AANLkTinLwfXhcsAOPEK8reNRyWeyQnzGKm7uQOpYhM_5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've just found this thread on google, and I subscribed to the list.

http://www.spinics.net/lists/linux-cifs/msg00951.html

I'm experiencing the same problem. the mountpoint is showing a 4096
size, but when I mount a cifs resource, it shows a 0-size. Other
mountpoints that are not using cifs (nfs, ext2-3 ...) doesnt change
the size.

The problem is that the mount point belongs to a directory structure
that is accesed by an apache service (2.0.54). The mount point is
/opt/www/dir1, while the apache's directoryRoot is /opt/www. So, the
problem is that when a client is trying to access to "dir1" I get a
error in apache logs, like:

[Fri Sep 24 10:57:26 2010] [error] [client 192.0.2.147] (75)Value too
large for defined data type: access to /dir1 failed

And the client gets a 403 - forbidden error. It's very tricky because
if I dismount /opt/www/dir1, the client can access without any
problem.

Googling this error seem that is related to accessing files > 2Gb, but
I think that apache doesn't know how to handle a 0-size directory or
it's understanding that is a huge sized directory ...

how can I fix the directory-size that apache is receiving?

-- 
3rd Law of Computing:
Anything that can go wrSegmentation fault -- core dumped.
