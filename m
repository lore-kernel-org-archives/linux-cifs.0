From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] cifs: Add handling of blank password option
Date: Thu, 29 Nov 2012 17:31:16 +0100
Message-ID: <20121129163116.GP27196@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs@vger.kernel.org, sfrench@samba.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The option to have a blank "pass=" already exists, and with
a password specified both "pass=%s" and "password=%s" are supported.
Also, both blank "user=" and "username=" are supported, making
"password=" the odd man out.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c670b9..c83f5b65 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -186,6 +186,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_user, "user=%s" },
 	{ Opt_user, "username=%s" },
 	{ Opt_blank_pass, "pass=" },
+	{ Opt_blank_pass, "password=" },
 	{ Opt_pass, "pass=%s" },
 	{ Opt_pass, "password=%s" },
 	{ Opt_blank_ip, "ip=" },
-- 
1.8.0.rc0.18.gf84667d


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
