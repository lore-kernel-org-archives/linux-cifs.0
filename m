From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cp --reflink and target file open flags
Date: Wed, 16 Oct 2013 18:36:19 -0500
Message-ID: <CAH2r5muRfQ6y1vzu_1icz4BGTqEPfgaOsHExbQay_yZiCOZQ_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cp --reflink opens the target file for O_WRONLY before invoking the
(BTRFS) ioctl for clone file, but for copy offload over the network
the SMB2 specification requires that the target file be open O_RDWR.

I may be able to upgrade the target file handle on the fly by
reopening it in cifs.ko, and of course I can write an SMB2/SMB3
specific copy command, but it would be preferable to allow use of cp
--reflink since so many people are familiar with it.

There is quite a bit of flexibility in server side copy offload  -
more than cp an offer, especially when using SMB3 or later dialects
(e.g. in number of chunks sent at one time, chunk size, attributes
copied, and even whether to use T10 style offload), but still it would
be nice to support "cp --reflink" over the network.  Any ideas on
this?

After looking at copy.c in coreutils for cp - I couldn't think of any
trivial way to force cp to open the target RW.

Ideas?

-- 
Thanks,

Steve
