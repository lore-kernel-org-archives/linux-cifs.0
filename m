From: Colin King <colin.king@canonical.com>
Subject: [PATCH][cifs-next] CIFS: SMBD: make functions smbd_recv_buf and smbd_recv_page static
Date: Thu,  4 Jan 2018 13:35:55 +0000
Message-ID: <20180104133555.8449-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The functions smbd_recv_buf and smbd_recv_page are local to the source
and do not need to be in global scope, so make them static.

Cleans up sparse warnings:
symbol 'smbd_recv_buf' was not declared. Should it be static?
symbol 'smbd_recv_page' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smbdirect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 731577d4317f..0d0545ef735f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1855,7 +1855,8 @@ struct smbd_connection *smbd_get_connection(
  * consumed. But this will require more changes to upper layer code, and also
  * need to consider packet boundaries while they still being reassembled.
  */
-int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
+static int smbd_recv_buf(struct smbd_connection *info, char *buf,
+			 unsigned int size)
 {
 	struct smbd_response *response;
 	struct smbd_data_transfer *data_transfer;
@@ -1995,8 +1996,8 @@ int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
  * to_read: the length of data to read
  * return value: actual data read
  */
-int smbd_recv_page(struct smbd_connection *info,
-		struct page *page, unsigned int to_read)
+static int smbd_recv_page(struct smbd_connection *info,
+			  struct page *page, unsigned int to_read)
 {
 	int ret;
 	char *to_address;
-- 
2.14.1
