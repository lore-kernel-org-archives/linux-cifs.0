From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cp --reflink improves performance a lot
Date: Sun, 17 Nov 2013 21:23:59 -0600
Message-ID: <CAH2r5mtdZTgE42XBVTrAp3KJyUgTu-dbxpcj1oTpZg8v3c5+Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As expected initial performance tests of cp --reflink show a big improvement

To localhost, Samba master branch on btrfs Fedora 19.

2.2GB file copied in 12.1 seconds without reflink over an SMB3 mount
from the kernel client but took only 1.3 seconds with --reflink (with
the new cp --reflink patches)

To a windows 8.1 server I tried a few examples.  27MB file copy wias
over a 100 times faster (over my usual Wifi connection between
machines)

[sfrench@w530-smf cifs-2.6]$ time cp /mnt/Steven/Documents/27meg
/mnt/Steven/Documents/27megnorefcopy

real 0m14.529s
user 0m0.002s
sys 0m0.101s
[sfrench@w530-smf cifs-2.6]$ time cp --reflink
/mnt/Steven/Documents/27meg /mnt/Steven/Documents/27megrefcopy

real 0m0.132s
user 0m0.000s
sys 0m0.005s

For a 200MB file relatively performance was even better for reflink
[sfrench@w530-smf Documents]$ time cp file.txt file-no-reflink.txt

real 1m36.184s
user 0m0.009s
sys 0m0.409s
[sfrench@w530-smf Documents]$ time cp --reflink file.txt file-reflink.txt

real 0m0.510s
user 0m0.003s
sys 0m0.024s


-- 
Thanks,

Steve
