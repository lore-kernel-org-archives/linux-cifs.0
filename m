From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: setting allocation size in cifs/smb3
Date: Fri, 18 Jul 2014 01:15:07 -0500
Message-ID: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I created a patch to cifs.ko to add fallocate FALLOC_FL_KEEP_SIZE
support and did some tests against a Samba server (Samba 4.1.6 on ext4
on Ubuntu) and also a Windows 8.1 server (NTFS file system) and ran
into an obvious problem.  How to tell if the allocation size is
changed?  Neither stat on the Samba server local file system nor the
Windows 8.1 properties show the size on disk changing.

I am sending SMB3 SetInfo level 0x13 (set allocation size) and getting
success back from the Windows server and from Samba server.

If I set the length past the end of file I get no error, but the
properties of the file in Windows Explorer still show the same (e.g.
zero) as the file size.  If I try setting it to a size smaller than
the size of the file, the file shrinks (by the way this is an awkward
behavior to work around since on Linux fallocate can't shrink the file
- so if you have any ideas short of revalidating the file size before
deciding whether to send the fallocate request to Windows ...).

Any ideas why Samba shows success but doesn't actually call ext4 to
update the allocation size?

Also any ideas how to implement the normal fallocate behavior (mode =
0, grow the file if length past end of file,  but don't shrink file
length if you set it shorter than end of file) which is basically the
opposite of how the level 0x19 works.  I think mode=1 (keep size) is
going to be ok - if I can figure out why Samba ignores it and how to
make sure it is working to Windows.


-- 
Thanks,

Steve
