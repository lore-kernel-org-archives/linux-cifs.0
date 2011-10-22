From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs file copy performance much faster - more results
Date: Sat, 22 Oct 2011 13:25:16 -0500
Message-ID: <CAH2r5msd-9GzomOxxpY9GMhd8hw0YjUL2uyYJJgTiG5T3hbuyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Did some quick tests to Samba 3.6 from the current cifs git tree which
includes Jeff's async read performance improvements.   About a 4x
performance increase on GiGE, maxing the network adapter (slightly
slower writing to local disk file).

/* As expected, running earlier cifs (3.0 kernel), the network
utilization on single large file copy is 20-25% over GigE */
[stevef@smfhomegateway ~]$ dd of=/dev/zero
if=/mnt/target-file-1GB-size bs=8M count=125
^C85+0 records in
84+0 records out
704643072 bytes (705 MB) copied, 29.5827 s, 23.8 MB/s

/* try it again to make sure it is not a fluke - current cifs suffers
from synchronous
dispatch of read in single file copy case and also small read sizes */
[stevef@smfhomegateway ~]$ dd of=/dev/null
if=/mnt/target-file-1GB-size bs=8M count=125
125+0 records in
125+0 records out
1048576000 bytes (1.0 GB) copied, 43.4298 s, 24.1 MB/s

/* Load the current cifs-2.6.git module - backported to 2.6.40-FC */
[stevef@smfhomegateway ~]$ dd of=/dev/null
if=/mnt/target-file-1GB-size bs=8M count=125
125+0 records in
125+0 records out
1048576000 bytes (1.0 GB) copied, 9.06156 s, 116 MB/s

/* Writing to local file on this low end SATA drive instead of
dev/null slows things down a little but still close to wire speed
[stevef@smfhomegateway ~]$ dd of=foo if=/mnt/target-file-1GB-size
bs=8M count=125
125+0 records in
125+0 records out
1048576000 bytes (1.0 GB) copied, 11.4381 s, 91.7 MB/s


-- 
Thanks,

Steve
