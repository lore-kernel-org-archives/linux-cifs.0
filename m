From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH linux-next] CIFS: SMBD: _smbd_get_connection() can be
 static
Date: Mon, 18 Dec 2017 21:30:06 +0800
Message-ID: <20171218133006.GA79761@cairo>
References: <201712182136.tWBuroDL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201712182136.tWBuroDL%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Fixes: 07495ff5d9bc ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 smbdirect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 2ecd5c1..62a5c3f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1462,7 +1462,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 }
 
 /* Create a SMBD connection, called by upper layer */
-struct smbd_connection *_smbd_get_connection(
+static struct smbd_connection *_smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
 {
 	int rc;
