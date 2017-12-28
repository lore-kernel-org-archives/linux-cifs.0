From: =?UTF-8?q?Andr=C3=A9s=20Souto?= <kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: add .splice_write
Date: Thu, 28 Dec 2017 14:23:08 +0100
Message-ID: <20171228132308.5709-1-kai670@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        =?UTF-8?q?Andr=C3=A9s=20Souto?= <kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

add splice_write support in cifs vfs using iter_file_splice_write

Signed-off-by: Andrés Souto <kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8c8b75d3..ba2986bd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1068,6 +1068,7 @@ const struct file_operations cifs_file_ops = {
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
@@ -1086,6 +1087,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
@@ -1105,6 +1107,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl  = cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
 	.clone_file_range = cifs_clone_file_range,
@@ -1122,6 +1125,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
@@ -1139,6 +1143,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
@@ -1157,6 +1162,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl  = cifs_ioctl,
 	.copy_file_range = cifs_copy_file_range,
 	.clone_file_range = cifs_clone_file_range,
-- 
2.14.1
