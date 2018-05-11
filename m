From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH cifs] smb3: cifs_dir_fsync() can be static
Date: Fri, 11 May 2018 08:50:26 +0800
Message-ID: <20180511005026.GA57926@lkp-sb04>
References: <201805110802.lpBxehxn%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201805110802.lpBxehxn%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Fixes: c3d5c2a93abf ("smb3: directory sync should not return an error")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8e41186..62f1662 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1053,7 +1053,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
  * Directory operations under CIFS/SMB2/SMB3 are synchronous, so fsync()
  * is a dummy operation.
  */
-int cifs_dir_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+static int cifs_dir_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	cifs_dbg(FYI, "Sync directory - name: %pD datasync: 0x%x\n",
 		 file, datasync);
