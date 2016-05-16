From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: duplicate extents SMB3 fcntl and cp --reflink from cifs.ko
Date: Mon, 16 May 2016 11:54:21 -0500
Message-ID: <CAH2r5msHywioNENFjKROsz6Hq+h0Tjcz5tJPsc70vgR6VWie3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I just verified that cp --reflink (which for cifs.ko smb3 mounts
invokes the DUPLICATE_EXTENTS SMB3 fcntl) works to current Windows
Server 2016 (TP5) as long as the target share is on an REFS partition
(not NTFS).

Very cool - even faster than CopyChunk for server side copy.

-- 
Thanks,

Steve
