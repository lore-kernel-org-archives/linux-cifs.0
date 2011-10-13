From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: async read patchset test results
Date: Thu, 13 Oct 2011 11:28:29 +0400
Message-ID: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I tested your current cifs-3.2 branch and faced with strange results
(assuming Windows 7 share is mounted to /mnt/share):

piastry@adventure:~$ dd if=test1.iso of=/mnt/share/test.iso bs=100000

piastry@adventure:~$ dd of=test.iso if=/mnt/share/test.iso bs=100000

piastry@adventure:~$ md5sum test.iso
5eee1675f46ac594dd7800c37e3ba944  test.iso

piastry@adventure:~$ md5sum /mnt/share/test.iso
5eee1675f46ac594dd7800c37e3ba944  /mnt/HOME-share/test.iso

piastry@adventure:~$ md5sum test1.iso
10d672583cab035e2b55048fbfbbf7ca  test1.iso

Then, I umounted and mounted it again with 3.1-rc9 cifs module -
everything was fine. Then, I load previous "buggy" one and everything
was fine too.

So, md5sums are not equal. Any ideas?

-- 
Best regards,
Pavel Shilovsky.
