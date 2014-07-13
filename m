From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Additional performance data on Pavel's smb3 multi credit patch series
Date: Sun, 13 Jul 2014 14:23:14 -0500
Message-ID: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Performance of Pavel's multicredit i/o SMB3 patches continues to look
good.  Additional informal performance results below comparing cifs
mounts with smb3 mounts (vers=3.0) with and without Pavel's patch set.
I plan to do additional testing with large rsize/wsize (default with
Pavel's code is 1MB).

3.16-rc4 (Ubuntu) on client.  Server is Windows 8.1.  Both VMs on same
host (host disk is fairly fast SSD).

Copy to server performance increased about 20% percent
dd if=/dev/zero of=/mnt/targetfile bs=80M count=25
got similar results with or without conv=fdatasync

1st run copying to empty directory, 2nd run copying over targetfile,
(pattern repeated multiple times) averaging results

New code (with Pavel's patches)
---------------------------------------------
CIFS 167MB/s
SMB3 200MB/s

Existing code (without his patches)
------------------------------------------------
SMB3 166MB/s
CIFS 164.5MB/s

For large file reading SMB3 performance with Pavel's patches increased
76% over existing SMB3 code
dd of=/dev/null if=/mnt/targetfile bs=80M count=25
(mounting and unmounting between attempts to avoid caching effects on
the client)

New code (with Pavel's patches)
---------------------------------------------
CIFS 114MB/s
SMB3 216MB/s

Existing code (without his patches)
------------------------------------------------
SMB3 123MB/s
CIFS 110MB/s

-- 
Thanks,

Steve
