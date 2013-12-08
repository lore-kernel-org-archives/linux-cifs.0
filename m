From: Tim Gardner <timg@tpi.com>
Subject: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count check
Date: Sun,  8 Dec 2013 14:08:43 -0700
Message-ID: <1386536924-51726-4-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
Cc: Steve French <sfrench@samba.org>, Tim Gardner <timg@tpi.com>, Dean Gehnert <deang@tpi.com>, Jeff Layton <jlayton@redhat.com>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1386536924-51726-1-git-send-email-timg@tpi.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

The reference count on tlink can only be decremented if
cifs_sb_tlink(cifs_sb) was used to acquire it. That only
happens if open_file==NULL.

Cc: Steve French <sfrench@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Dean Gehnert <deang@tpi.com>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

V2 - this is a new patch in the V2 series.

 fs/cifs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3f710c6..e332038 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 			CIFSSMBClose(xid, tcon, netfid);
 		}
 	}
-	if (tlink)
+	if (!open_file)
 		cifs_put_tlink(tlink);
 
 set_size_out:
-- 
1.7.9.5
