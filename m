From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH 2/2] CIFS: Fix duplicate line introduced by
 clone_file_range patch
Date: Mon, 29 Feb 2016 18:11:45 -0600
Message-ID: <CAH2r5msmUBtWJ9S5x15KOyfArWQmEWvshZuYD7wb1OiJKfegJQ@mail.gmail.com>
References: <smfrench@gmail.com> <1456791058-92940-1-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456791058-92940-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git


---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Mon, Feb 29, 2016 at 6:10 PM
Subject: [PATCH 2/2] CIFS: Fix duplicate line introduced by
clone_file_range patch
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve French
<steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>


Commit 04b38d601239b4 ("vfs: pull btrfs clone API to vfs layer")
added a duplicated line (in cifsfs.c) which causes a sparse compile
warning.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
CC: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/cifs/cifsfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c48ca13..2eea403 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1013,7 +1013,6 @@ const struct file_operations cifs_file_strict_ops = {
        .llseek = cifs_llseek,
        .unlocked_ioctl = cifs_ioctl,
        .clone_file_range = cifs_clone_file_range,
-       .clone_file_range = cifs_clone_file_range,
        .setlease = cifs_setlease,
        .fallocate = cifs_fallocate,
 };
--
1.9.1



-- 
Thanks,

Steve
