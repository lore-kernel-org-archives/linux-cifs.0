From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New file attribute for integrity
Date: Mon, 1 Jul 2013 14:59:01 -0500
Message-ID: <CAH2r5mtvDv80R00QONf3WadSRASk9w46uju04oQB67mWrnWQVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

At the SMB3 test events over the last two weeks, we found out about a
new file attribute which Windows servers can return
"FILE_ATTRIBUTE_INTEGRITY_STREAM" (it can also be returned as an
fsinfo, volume, property - not just as a file attribute).

The flag is set by the server in responses to query information about
a file when the underlying file system does checksumming of the data
and metadata for the file (similarly if the volume always checksums
data and metadata this flag would be enabled on the fsinfo response).
 Apparently REFS when run in certain configurations (mirrored drives?)
or when formatted to require metadata/data integrity checksumming can
provide these extra guarantees.

btrfs seems to support both metadata and data checksumming by default
and presumably if "check_int" is compiled in and enabled this is the
equivalent.  What should Samba server use to check if data and
metadata integrity checksumming is enabled in btrfs?  Are there any
other in-kernel filesystems that support metadata/data integrity
checksumming and how would Samba server detect them.

SMB3 allows you (the app running on the client) to individually ask
the server's filesystem to enable or disable (metadata and data)
integrity checking on a directory or file - I don't know of any
equivalent on btrfs or any Linux file system.  Is there an example of
a Linux file system that lets you set this on per file or directory
basis?

-- 
Thanks,

Steve
