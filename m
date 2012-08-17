From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New work branches
Date: Fri, 17 Aug 2012 18:57:41 +0400
Message-ID: <CAKywueRJgeA2tQwCOe2e8OyjWyVC14aN8zEsSFH7x62vFN7NjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I prepared new branches:

1) for-linus - that consists of fixes for 3.6.
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-linus

Now they are:
CIFS: Protect i_nlink from being negative
CIFS: Fix log messages in packet checking for SMB2
cifs: print error code if smb signature verification fails
CIFS: Fix cifs_do_create error hadnling


2) for-next - my patches for 3.7 (renamed version of smb2-basic branch).
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-next

This is very close to Steve's current for-next branch with small changes.


3) smb2-dev - remaining smb2 patches that are not ready yet.
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev

-- 
Best regards,
Pavel Shilovsky.
