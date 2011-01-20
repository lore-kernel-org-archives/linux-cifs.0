From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: set up recurring workqueue job to do SMB echo requests
Date: Thu, 20 Jan 2011 11:51:59 -0600
Message-ID: <AANLkTikm7wx097fm-u05ZB9P1fpCsK4=WNM0i5-7nToq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have merged this patch, but I agree with the hint in the comment
below - given all of the complaints about "chattiness" of Windows cifs
behavior, we need to allow this to be tuned for slow WANs in
subsequent patch.

+/* SMB echo "timeout" -- FIXME: tunable? */
+#define SMB_ECHO_INTERVAL (60 * HZ)

Had you made a patch for that?  If not, I can easily put something
together.   Problem is it is a link issue not a "system-wide" issue so
probably needs to be mount option (and we have a lot of these, and
this would not be a commonly used one)

-- 
Thanks,

Steve
