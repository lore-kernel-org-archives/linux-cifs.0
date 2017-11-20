From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v7 02/22] CIFS: SMBD: Introduce kernel config option
 CONFIG_CIFS_SMB_DIRECT
Date: Mon, 20 Nov 2017 00:28:51 -0500 (EST)
Message-ID: <1448269298.28433661.1511155731311.JavaMail.zimbra@redhat.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com> <20171107085514.12693-3-longli@exchange.microsoft.com>
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
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-3-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Acked-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Long Li" <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
To: "Steve French" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Tom Talpey" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Matthew Wilcox" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Stephen Hemminger" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "Long Li" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sent: Tuesday, 7 November, 2017 7:54:54 PM
Subject: [Patch v7 02/22] CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Build SMB Direct code when this option is set.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index f724361..8d05fff 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -191,6 +191,14 @@ config CIFS_SMB311
 	  This dialect includes improved security negotiation features.
 	  If unsure, say N
 
+config CIFS_SMB_DIRECT
+	bool "SMB Direct support (Experimental)"
+	depends on CIFS && INFINIBAND
+	help
+	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
+	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
+	  say N.
+
 config CIFS_FSCACHE
 	  bool "Provide CIFS client caching support"
 	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
