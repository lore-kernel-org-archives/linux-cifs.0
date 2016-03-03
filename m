From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ntfs.streams.list xattr and listing alternate data streams
Date: Thu, 3 Mar 2016 10:18:23 -0600
Message-ID: <CAH2r5muQ0pCoTAsWpjB5b5=1a7PYfKF68WLAZKfM-FOjaxbL3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have there been any suggestions on how to list alternate data streams
on a file other than using a pseudo-xattr as ntfs-3g does (querying
xattr ntfs.streams.list - see http://linux.die.net/man/8/ntfs-3g)?

I have a patch that can do this for SMB3.  If an xattr is preferred
(over an ioctl for example) - for CIFS/SMB3 should we use the same
xattr ("ntfs.streams.list") or a CIFS specific one "user.streams.list"
or "cifs.streams.list" or "smb3.streams.list" for example)?

Opinions?
-- 
Thanks,

Steve
