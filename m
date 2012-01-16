From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: packed attribute
Date: Mon, 16 Jan 2012 16:35:27 +0400
Message-ID: <CAKywueSu=S-VkqS5K7=PYpt0a2hxR8Q=tmQrTEXSOvrKe=__Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I noticed that when I run checkpatch.pl over my smb2 patches it fails on

struct example {
...
} __attribute__((packed));

and suggests to use

struct example {
...
} __packed;

Also we already have many such "style broken" structures in cifsdpu.h.

What do you think about it? Should we fix them all?

-- 
Best regards,
Pavel Shilovsky.
