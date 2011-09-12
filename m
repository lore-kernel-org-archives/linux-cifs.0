From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Intermittent file corruption problems with cifs driver?
Date: Mon, 12 Sep 2011 10:36:55 +0200
Message-ID: <20110912083654.GA3338@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

Recently at $customer I've been tasked into looking into a problem they
are intermittently having with corrupt file transfers from linux servers
to a windows share.  

Little info on the servers:

	Ubuntu Lucid 10.04
	Stock and up to date Linux 2.6.32-33-server distro package
	Stock cifs-utils 4.5-2 packages

Description of behavior:

	The servers are all part of a distributed service where each server
	regularly uploads 100-200MB zipfiles to the windows share.  Intermittently
	the resulting files will be corrupted.  On the client that performs
	the upload, the corrupted file will appear to have the correct checksum,
	but any other remote client will see it as corrupted.

	The problem used to be much more frequent, and mounting with -o directio
	seems to have greatly reduced, but not eliminated, the recurrence of the
	corruption.  But recently (perhaps due to higher reates of uploads?),
	the problem has started recurring.  It doesn't seem uniformly occuring,
	but rather in spurts where a couple files will be corrupted in one day,
	and then a week will go by with no corruptions.

	I do see occasional errors in the kernel logs, though I'm not sure if
	they are relevant or not (note that they're at substantially different
	times, and at present I have no way to correlate them with corruption,
	though I'm working on that):

	[170873.721023]  CIFS VFS: Error -104 sending data on socket to server
	[170873.728747]  CIFS VFS: Error -32 sending data on socket to server
	[515039.940104]  CIFS VFS: No response to cmd 115 mid 32714
	[515039.947933]  CIFS VFS: Send error in SessSetup = -11
	[521901.595381]  CIFS VFS: No response to cmd 46 mid 37426
	[521901.603422]  CIFS VFS: Send error in read = -11
	[2097744.571138]  CIFS VFS: No response for cmd 50 mid 48502
	[2097849.771138]  CIFS VFS: No response for cmd 114 mid 48519


Reading through the archives along with the rest of teh internetz I've found 
very little info.  Someone posted here back in february about a similar
sounding problem, though I do not see the wsize-len blocks of NULL bytes in
the resulting files like they did.

I've written a small python script that right now is running on a pair of
these servers, which with a couple dozen threads is uploading similarly sized
files of arbitrary data, and comparing the upload results of each other.
after a few hours I haven't seen it yet, but will keep it runnign for
a couple days to see if it shows up.

I've also found a couple suggestions out there to "disable linux
extensions" and "disable oplocks" when searching on the above kernel error
messages, but am hesitant to try them unless there's a strong indication
that they will help, and i'm not entirely sure if/whether they will.


does this ring a bell with anyone?  at this point i can't just do a
blanket "try the latest" upgrade of these servers because they're part
of a production application, at least without any further indication that
there was a fix for this problem between the current and latest versions.
If I can repro the problem, however, and can then take it to a non-prod
machine, then I might have a bit more flexibility, but in the meantime
thought I'd field the question here on the off chance...


thanks!
	sean
