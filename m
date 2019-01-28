From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 3.18 51/61] cifs: check ntwrk_buf_start for NULL before dereferencing it
Date: Mon, 28 Jan 2019 11:26:13 -0500
Message-ID: <20190128162623.59854-51-sashal@kernel.org>
References: <20190128162623.59854-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128162623.59854-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 59a63e479ce36a3f24444c3a36efe82b78e4a8e0 ]

RHBZ: 1021460

There is an issue where when multiple threads open/close the same directory
ntwrk_buf_start might end up being NULL, causing the call to smbCalcSize
later to oops with a NULL deref.

The real bug is why this happens and why this can become NULL for an
open cfile, which should not be allowed.
This patch tries to avoid a oops until the time when we fix the underlying
issue.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/readdir.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 707d8cf95348..116985335cc1 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -645,7 +645,14 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		/* scan and find it */
 		int i;
 		char *cur_ent;
-		char *end_of_smb = cfile->srch_inf.ntwrk_buf_start +
+		char *end_of_smb;
+
+		if (cfile->srch_inf.ntwrk_buf_start == NULL) {
+			cifs_dbg(VFS, "ntwrk_buf_start is NULL during readdir\n");
+			return -EIO;
+		}
+
+		end_of_smb = cfile->srch_inf.ntwrk_buf_start +
 			server->ops->calc_smb_size(
 					cfile->srch_inf.ntwrk_buf_start);
 
-- 
2.19.1
