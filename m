From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: linux-next build break
Date: Tue, 25 Oct 2011 10:02:59 -0500
Message-ID: <CAH2r5mt=P9EpvEEN+ehJd61_QKpUxCcKKFz16RGNpboF3HpZCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Had a typo in my earlier proposed patch

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index a155561..5989883 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -203,6 +203,9 @@ static inline void set_freezable_with_signal(void) {}
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)

+#define wait_event_freezekillable(wq, condition)		\
+		wait_event_killable(wq, condition)
+
 #endif /* !CONFIG_FREEZER */

 #endif	/* FREEZER_H_INCLUDED */

-- 
Thanks,

Steve
