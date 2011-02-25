From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:15:02 -0800
Message-ID: <1298614502-4114-1-git-send-email-justinmattock@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d6c17a..ea4a146 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -722,7 +722,7 @@ multi_t2_fnd:
 		sock_release(csocket);
 		server->ssocket = NULL;
 	}
-	/* buffer usuallly freed in free_mid - need to free it here on exit */
+	/* buffer usually freed in free_mid - need to free it here on exit */
 	cifs_buf_release(bigbuf);
 	if (smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(smallbuf);
-- 
1.7.4.1
