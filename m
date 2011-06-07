From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New sparse error
Date: Mon, 6 Jun 2011 20:08:40 -0500
Message-ID: <BANLkTi=DxeeQ6SU8dG8YMAEotSbAyYYDOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just noticed this warning - when I get time tomorrow I want to look at
it more - unless someone already knows what is going on:

stevef@stevef-laptop:~/cifs-2.6$ make modules C=1 M=fs/cifs
CF=-D__CHECK_ENDIAN__
  CHECK   fs/cifs/cifsfs.c
fs/cifs/cifsfs.c:64:1: error: Syntax error in unary expression
fs/cifs/cifsfs.c:68:1: error: Syntax error in unary expression
fs/cifs/cifsfs.c:72:1: error: Syntax error in unary expression
fs/cifs/cifsfs.c:76:1: error: Syntax error in unary expression
fs/cifs/cifsfs.c:80:1: error: Syntax error in unary expression


complaining about longstanding usage of module_param(cifs_min_rcv, int, 0);  ?

-- 
Thanks,

Steve
