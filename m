From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Big performance improvements seen with cifs async write patches even
 over localhost
Date: Fri, 27 May 2011 00:14:19 -0500
Message-ID: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Did some informal testing of Jeff Layton's cifs async_write patch set
tonight (recent kernel). Copying 700MB sequentially was 20% faster
from cifs kernel client to Samba 3.6 with his patches - even mounted
over localhost (where network latency is a much smaller issue) and
with a slow laptop drive!

I was simply doing

time dd if=/dev/zero of=/mnt/null bs=1M count=700

repeated 4 times each way (with old module, and with same code with
Jeff's cifs async write code builtin), deleting the target file in
between each run.

I am looking forward to trying this over GigE tomorrow to servers with
faster disks.



-- 
Thanks,

Steve
