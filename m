From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v7 3/7] locks: Disable LOCK_MAND support for MS_SHARELOCK
 mounts
Date: Fri, 17 Jan 2014 14:07:08 +0400
Message-ID: <1389953232-9428-4-git-send-email-piastry@etersoft.ru>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, wine-devel@winehq.org
To: linux-kernel@vger.kernel.org
Return-path: <wine-devel-bounces@winehq.org>
In-Reply-To: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
List-Unsubscribe: <http://www.winehq.org/mailman/options/wine-devel>,
 <mailto:wine-devel-request@winehq.org?subject=unsubscribe>
List-Archive: <http://www.winehq.org/pipermail/wine-devel/>
List-Post: <mailto:wine-devel@winehq.org>
List-Help: <mailto:wine-devel-request@winehq.org?subject=help>
List-Subscribe: <http://www.winehq.org/mailman/listinfo/wine-devel>,
 <mailto:wine-devel-request@winehq.org?subject=subscribe>
Errors-To: wine-devel-bounces@winehq.org
Sender: "wine-devel" <wine-devel-bounces@winehq.org>
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/locks.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 7ecc511..c7e780a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1904,6 +1904,12 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 		goto out;
 	}
 
+	/* Disable LOCK_MAND support for FS mounted with MS_SHARELOCK */
+	if ((cmd & LOCK_MAND) && IS_SHARELOCK(f.file->f_path.dentry->d_inode)) {
+		error = -EPERM;
+		goto out;
+	}
+
 	can_sleep = !(cmd & LOCK_NB);
 	cmd &= ~LOCK_NB;
 	unlock = (cmd == LOCK_UN);
-- 
1.7.10.4
