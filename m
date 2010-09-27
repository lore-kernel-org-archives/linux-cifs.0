From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB2 and CIFS progress at SNIA conference/plugfest
Date: Mon, 27 Sep 2010 17:30:12 -0500
Message-ID: <AANLkTimFqiM=bkqmPev+YJCiWfN_SyEMXyOi8YsC_CLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Lots of progress on cifs and smb2 kernel clients at the SNIA
conference/plugfest.  Some highlights:

- Jeff and I worked together to review various patchsets in more detail
- Merged Metze's "Minshall-French" (MacOS) symlink patchset.  We can
now create symlinks to servers which do not support the CIFS Unix
Extensions
- After various minor fixups merged the first half of Jeff's long
series of "multiuser mount" patches.  Expect to finish the review and
merge of the remainder this week
- Merged two of Shirish's NTLMv2/NTLMSSP auth and crypto patches.
- After discussions with Dr. Holder merged Ben's patch which allows
selecting the network interface at mount time
- Made three other minor fixes to cifs

On SMB2 -
- verified the huge speed improvement on writes.  Using the new smb2
kernel module, large file writes ranged from 12% to 125% faster (than
cifs) to very current Samba 3.6 server (and also to Windows server)
depending on network and disk speed.  This should be even larger still
when we use larger buffer sizes (and improved caching) which smb2
allows.  (interestingly using posix async i/o on the Samba server side
slows performance slightly, and we did not focus on read performance,
in part because of the lack of sendfile support on the Samba server
side yet).
- many patches merged - most obviously fixed some mount/umount/rmmod
stability issues
- fixed readdir, at least for small/medium sized directories
- began the improved oplock implementation
- created a "cifs_common" subdirectory so that common routines between
smb2.ko and cifs.ko can be placed in a new small helper module (I
estimate that this will end up about 5000 lines of code - so making
common code could reduce the size of the smb2 code base by 20-30%
eventually).  This will be a gradual process, but I have already
identified a subset of the connection establishment routines that can
be moved to common fairly easily.
- There were some good talks on smb2 - including ones discussing
metadata caching and the corresponding dramatic performance
improvements, and also on the early plans for SMB2 Unix Extensions

All in all a a very successful conference and plugfest.



-- 
Thanks,

Steve
