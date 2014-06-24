From: Osmond Sun <osmond.sun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: set null to username and iocharset after being freed
Date: Tue, 24 Jun 2014 15:31:41 +0800
Message-ID: <CABJ8ys8VxRwgges=bfFCXN51rQQQM3kgdfRP-TtZuOrP+UrcgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In function 'expand_dfs_referral' the volume_info->iocharset and
volume_info->username was used after being freed by calling
cleanup_volume_info_contents. Set null to username and iocharset
after being freed.

Signed-off-by: Osmond Sun <osmond.sun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20d75b8..2586a34 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3251,10 +3251,12 @@ static void
 cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
  kfree(volume_info->username);
+ volume_info->username = NULL;
  kzfree(volume_info->password);
  kfree(volume_info->UNC);
  kfree(volume_info->domainname);
  kfree(volume_info->iocharset);
+ volume_info->iocharset = NULL;
  kfree(volume_info->prepath);
 }

-- 
1.9.0
