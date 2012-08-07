From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: regression in connectathon test7
Date: Tue, 7 Aug 2012 15:28:22 -0400
Message-ID: <20120807152822.3bbe468f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If I mount up a SMB1 share without unix extensions, I get the following
error when I run connectathon test7 on it now:

# env NFSTESTDIR=/mnt/cifs/rawhide.test ./basic/test7
./basic/test7: link and rename
	./basic/test7: (/mnt/cifs/rawhide.test) file.0 has 2 links after unlink (expect 1) : No such file or directory

This does not fail on 3.5.0. Pavel, is this something you've noticed in
your testing? 

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
