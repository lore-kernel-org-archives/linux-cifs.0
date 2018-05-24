From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH cifs] smb3: smb3_fs_type can be static
Date: Thu, 24 May 2018 16:53:36 +0800
Message-ID: <20180524085336.GA120833@lkp-ib03>
References: <201805241613.jA5dMoyL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <stfrench@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201805241613.jA5dMoyL%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Fixes: 64a051adf591 ("smb3: add module alias for smb3 to cifs.ko")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 645bb88..f0a68e9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -900,7 +900,7 @@ struct file_system_type cifs_fs_type = {
 };
 MODULE_ALIAS_FS("cifs");
 
-struct file_system_type smb3_fs_type = {
+static struct file_system_type smb3_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "smb3",
 	.mount = cifs_do_mount,
