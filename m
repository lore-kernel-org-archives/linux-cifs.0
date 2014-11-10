From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH 2/2] [CIFS] Update MAINTAINERS entry
Date: Mon, 10 Nov 2014 13:09:24 -0800
Message-ID: <1415653764-22162-2-git-send-email-cernekee@gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Update link to point to Steve's current tree on git.samba.org.  Remove
link to the old patchwork instance which shows no new patches since 2010.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b36a4f0..4d8154d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2519,8 +2519,7 @@ M:	Steve French <sfrench@samba.org>
 L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
-Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git://git.samba.org/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs/
 F:	fs/cifs/
-- 
2.1.1
