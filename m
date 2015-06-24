From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3 very fast file copy over the network with FSCTL_DUPLICATE_EXTENTS
Date: Wed, 24 Jun 2015 00:20:38 -0500
Message-ID: <CAH2r5ms9tzWXU_x4ycNwDQqTGk5nkL73tDQyyA-Miqs6njijSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I tried file copies similar to "cp --reflink" over the network (from
cifs.ko client) with the new SMB3.11 dialect and
FSCTL_DUPLICATE_EXTENTS.   As expected - spectacularly faster than
regular cp. Target file system was REFS in my tests at the SMB3 test
event this week.
Now that Samba is also adding SMB3.11 dialect support, looking forward
to when we
get this in Samba server too - it is a huge performance boost for
large file copy.

(The patch to cifs.ko is
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=8295c91bcb9d19f8fbb8885d135321ab6d18a781)

root@ubuntu:~/cifs-2.6# time cp /mnt/100MBfile /mnt/copy1

real    0m1.712s
user    0m0.002s
sys    0m0.840s
root@ubuntu:~/cifs-2.6# time cp --reflink /mnt/100MBfile /mnt/copy2

real    0m0.026s
user    0m0.001s
sys    0m0.013s
root@ubuntu:~/cifs-2.6# time cp --reflink /mnt/100MBfile /mnt/copy3

real    0m0.016s
user    0m0.001s
sys    0m0.005s


-- 
Thanks,

Steve
