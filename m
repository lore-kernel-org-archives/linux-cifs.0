From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: checkpatch warnings on your patch series
Date: Tue, 11 Oct 2011 22:46:31 -0500
Message-ID: <CAH2r5msXgCm44tY=wX8Ng0+xDGHRyaq804Qk33XvFOQkbK54ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewing the patches in your cifs-3.2 branch, I did run into one
checkpatch warning.

ERROR: need consistent spacing around '*' (ctx:WxV)
#231: FILE: fs/cifs/connect.c:2891:
+#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 *1024)


otherwise, the patch review is uneventful so far, and first few easy
ones are merged.

-- 
Thanks,

Steve
