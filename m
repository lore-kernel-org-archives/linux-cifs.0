From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smb2 testing progress
Date: Thu, 27 Oct 2011 12:31:22 -0500
Message-ID: <CAH2r5mtqMsdP4Fu7FcaGV+=vzOHWfMamadz8FVSEgg+KqEK+eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I did additional testing of Pavel's SMB2 tree with most current code,
and Samba 4 (server).   Basic testing went fine.   The current smb2
implementation passes most connectathon tests, with the obvious
exceptions (returning the right count on hardlinks is hard, and no
symlink support yet causes two of the 11 "basic" tests to fail, and
the lack of a piece of byte range lock emulation causes lock test 7 to
fail, in addition one of the "special" tests fails IIRC one of the
harder rename cases to deal with, the "general" tests all pass).

Pavel had suggested leaving it marked "broken" (at least for a few
weeks) until we clean up a few test case failures and do more testing
with most current kernel code, but he made good progress.

-- 
Thanks,

Steve
