From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Current cifs code doubles file copy speed from server to Linux client
 - due to Jeff Layton's async read patch set
Date: Thu, 20 Oct 2011 12:58:58 -0500
Message-ID: <CAH2r5msNR2OZRdAtt_V5Z56RiSbyCguTte_XCF1LFj+dNMdrvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Did a quick check of the current cifs-2.6.git tree (in linux-next,
which I will be requesting to be merged into 3.2-pre).=A0 Thanks to Jef=
f
Layton's async read patch set, as expected the file copy performance
from server to Linux client is dramatically faster.

In a quick test copying a directory containing 144MB of movie trailers
from a typical Windows Vista desktop system (as desktop) using the
Linux cifs kernel client the speed more than doubled.=A0=A0 Performance
should be even better to Linux/Samba servers due to Samba's larger
maximum i/o sizes.

When you also consider that Pavel's byte range lock queueing and lock
batching patches should help some workloads a lot, and that his SMB2
code will allow oplock (lease) upgrades - the performance of 3.2 cifs
kernel client should be much better.

--
Thanks,

Steve
