From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v6 07/22] CIFS: SMBD: Implement function to create a SMB
 Direct connection
Date: Mon, 20 Nov 2017 02:38:50 -0500 (EST)
Message-ID: <1711300759.28570763.1511163530669.JavaMail.zimbra@redhat.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com> <20171105054404.23886-8-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105054404.23886-8-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Long Li" <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
To: "Steve French" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Tom Talpey" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Matthew Wilcox" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Stephen Hemminger" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "Long Li" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sent: Sunday, 5 November, 2017 4:43:49 PM
Subject: [Patch v6 07/22] CIFS: SMBD: Implement function to create a SMB Direct connection

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

The upper layer calls this function to connect to peer through SMB Direct.
Each SMB Direct connection is based on a RDMA RC Queue Pair.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smbdirect.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 7af49cd..47d999f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1652,3 +1652,20 @@ struct smbd_connection *_smbd_get_connection(
 	kfree(info);
 	return NULL;
 }
+
+struct smbd_connection *smbd_get_connection(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
+{
+	struct smbd_connection *ret;
+	int port = SMBD_PORT;
+
+try_again:
+	ret = _smbd_get_connection(server, dstaddr, port);
+
+	/* Try SMB_PORT if SMBD_PORT doesn't work */
+	if (!ret && port == SMBD_PORT) {
+		port = SMB_PORT;
+		goto try_again;
+	}
+	return ret;
+}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
