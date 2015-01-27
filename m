From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New ioctl
Date: Tue, 27 Jan 2015 12:23:55 -0600
Message-ID: <CAH2r5mu4zB08avnUSig5b-DGBekgOHVGoUYNNosOpvfAfOYBoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Has anyone tried the new ioctl (MS-FSCC) defined in the most recent
update.  See section 2.3.7

Looks interesting for a new variant of copy offload

"A new File System Control (FSCTL) has been added to support the new
FSCTL_DUPLICATE_EXTENTS_TO_FILE operation in [MS-FSA]."

-- 
Thanks,

Steve
