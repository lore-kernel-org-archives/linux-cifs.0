From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Incorrect error returned on setting file compressed on SMB2
Date: Mon, 18 Aug 2014 22:33:06 -0500
Message-ID: <CAH2r5muLY2X17Gdg-VyMX=3X-Dg-xtQ_LozMDrsvWFqPYQ+jZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the server (for an SMB2 or SMB3 mount) doesn't support
an ioctl (such as setting the compressed flag
on a file) we were incorrectly returning EIO instead
of EOPNOTSUPP, this is confusing e.g. doing chattr +c to a file
on a non-btrfs Samba partition, now the error returned is more
intuitive to the user.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index a689514..af59d03 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -298,7 +298,7 @@ static const struct status_to_posix_error
smb2_error_map_table[] = {
     {STATUS_INVALID_PARAMETER, -EINVAL, "STATUS_INVALID_PARAMETER"},
     {STATUS_NO_SUCH_DEVICE, -ENODEV, "STATUS_NO_SUCH_DEVICE"},
     {STATUS_NO_SUCH_FILE, -ENOENT, "STATUS_NO_SUCH_FILE"},
-    {STATUS_INVALID_DEVICE_REQUEST, -EIO, "STATUS_INVALID_DEVICE_REQUEST"},
+    {STATUS_INVALID_DEVICE_REQUEST, -EOPNOTSUPP,
"STATUS_INVALID_DEVICE_REQUEST"},
     {STATUS_END_OF_FILE, -ENODATA, "STATUS_END_OF_FILE"},
     {STATUS_WRONG_VOLUME, -EIO, "STATUS_WRONG_VOLUME"},
     {STATUS_NO_MEDIA_IN_DEVICE, -EIO, "STATUS_NO_MEDIA_IN_DEVICE"},

-- 
Thanks,

Steve
