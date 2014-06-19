From: Osmond Sun <osmond.sun@gmail.com>
Subject: [PATCH] cifs: set null to username and iocharset after being freed
Date: Thu, 19 Jun 2014 15:09:24 +0800
Message-ID: <CABJ8ys9OB_gUScf65hnDLNYURq+nvCAc=AgBzVdobO391QdU5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: sfrench@samba.org
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

In function 'expand_dfs_referral' the volume_info->iocharset and
volume_info->username was used after being freed by calling
cleanup_volume_info_contents. Set null to username and iocharset
after being freed.

Signed-off-by: Osmond Sun <osmond.sun@gmail.com>
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
