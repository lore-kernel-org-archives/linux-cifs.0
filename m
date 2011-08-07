From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference of
 noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
Date: Sun, 7 Aug 2011 11:22:51 -0500
Message-ID: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I noticed a series of sparse warnings (on all calls to cifs's GetXid
after building on a newly install fc15 system (yum installed a sparse
binary dated June 23).

fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression

Has sparse changed to add a new warning - I see (from quick search)
others getting this on other modules years ago, but I didn't see
anything obvious wrong with the definition of the function, and I
hadn't noticed sparse complaining about it before, and would like to
remove the 50+ new messages as they clutter the build output.
-- 
Thanks,

Steve
