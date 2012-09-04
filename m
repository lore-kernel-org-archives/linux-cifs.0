From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: new for-3.6/for-next branches
Date: Tue, 4 Sep 2012 16:25:05 +0400
Message-ID: <CAKywueS9Y+Lv_-_pDXRguGVS5jp0CVOqZJc67+GHoS8+y-gtvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I recreated my branches - created for-3.6 branch with two patches on
top of Steve's master, deleted extra smb2-* ones and pushed all
for-3.7 patches to for-next branch (that is on top of for-3.6 branch):

http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-3.6
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-next

Also, note that for-next branch has patches from Jeff's cifs-next
branch (r/wsize limit related).

-- 
Best regards,
Pavel Shilovsky.
