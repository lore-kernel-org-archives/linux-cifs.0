From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs dbench performance increased even over localhost mounts
Date: Tue, 25 Oct 2011 11:24:49 -0500
Message-ID: <CAH2r5mu39JJ+SH4EwrnLNuNDR81N-x7-x8AadooZ15ddzEWhwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In testing the cifs-2.6.git tree for 3.2-pre, I noticed that dbench
cifs dbench performance improved even over localhost mounts (to Samba)
by more than 5% (60 processes).   I don't know what part of that is
due to the improved byte range lock caching (Pavel's patch set) or
larger i/o sizes on read or better async read dispatch (Jeff's patch
set), but suspect that the latter helped more.   Relative performance
should improve even more with fewer dbench processes as better async
dispatch of large read requests helps utilize the Samba server more
efficiently.


-- 
Thanks,

Steve
