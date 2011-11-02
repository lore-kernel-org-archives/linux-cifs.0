From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] wait_event_freezekillable: use
	freezer_do_not_count/freezer_count
Date: Wed, 2 Nov 2011 18:53:27 +0100
Message-ID: <20111102175327.GA4446@redhat.com>
References: <20111101041337.39077229@tlielax.poochiereds.net> <20111101065958.50addab5@tlielax.poochiereds.net> <20111101163059.GR18855@google.com> <20111101175953.GB5358@redhat.com> <20111101180601.GV18855@google.com> <20111101181329.GA6739@redhat.com> <20111101182753.GW18855@google.com> <20111101193923.GA9444@redhat.com> <20111101194601.GB9444@redhat.com> <20111101215710.GA13803@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111101215710.GA13803-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fake_signal_wake_up() should not wake up the TASK_KILLABLE tasks,
we are going to fix this. This means that wait_event_freezekillable()
can't rely on wakeup from freezer. Reimplement it using
freezer_do_not_count/freezer_count. This is not really nice, just
a simple fix for now.

Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 include/linux/freezer.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -143,13 +143,9 @@ static inline void set_freezable_with_si
 #define wait_event_freezekillable(wq, condition)			\
 ({									\
 	int __retval;							\
-	for (;;) {							\
-		__retval = wait_event_killable(wq,			\
-				(condition) || freezing(current));	\
-		if (__retval || (condition))				\
-			break;						\
-		try_to_freeze();					\
-	}								\
+	freezer_do_not_count();						\
+	__retval = wait_event_killable(wq, (condition));		\
+	freezer_count();						\
 	__retval;							\
 })
 
