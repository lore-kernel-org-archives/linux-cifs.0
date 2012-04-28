From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: setuids/setgids by default
Date: Sat, 28 Apr 2012 14:42:35 +0400
Message-ID: <CAKywueSQQfzwkWgE33+w=y2pnQQd4nxhvJX71NaAa0E_BLAcbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

Now CIFS client doesn't enforce uid and gid permission from the
process that create file by default (new files are created with mount
user permission) and it can be 'fixed' by setuids/setgids mount
option. Why this options should not be by default? I think it
contradict POSIX.

-- 
Best regards,
Pavel Shilovsky.
