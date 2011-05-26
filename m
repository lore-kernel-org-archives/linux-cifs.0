From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: patches for 2.6.40
Date: Thu, 26 May 2011 10:10:55 +0400
Message-ID: <BANLkTimWUozj+P0VXU=JTPqwU1D8tRhnXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I updated a branch for-next with all my pending patches for 2.6.40:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-next.

The list of the patches:
CIFS: Fix memory leak in cifs_do_mount
CIFS: Migrate from prefixpath logic
CIFS: Migrate to shared superblock model
CIFS: Use pid saved in cifsFileInfo in writepages and set_file_size
CIFS: Add rwpidforward mount option

Could you review them, please?

-- 
Best regards,
Pavel Shilovsky.
