From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Sparse files and Linux
Date: Fri, 8 Aug 2014 16:31:32 -0500
Message-ID: <CAH2r5mtgUz3tuy1zRDCrxCSV-q7xyGe=tfkdzeQgxMqz2qUiAQ@mail.gmail.com>
References: <CAH2r5msRaKBFHYpiES+vxTCwgyBDg-iV=ZjKpSrYhkHS99B2xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msRaKBFHYpiES+vxTCwgyBDg-iV=ZjKpSrYhkHS99B2xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Aug 8, 2014 at 4:07 PM
Subject: Sparse files and Linux
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>


Tried a simple test to see about sparse file creation to Samba from Linux.

Results:
Local (ext4): both file1 and file2 are sparse
Remote over cifs to samba (unix extensions): file1 not sparse, file2 is sparse
Remote over cifs to samba (unix extensions disabled): file1 and file2 not sparse
Remove over smb3 to samba: file1 and file2 not sparse

Presumably can fix it with explicit set sparse.

#!/usr/bin/env python
#
# Test sparse file support

import os, struct, stat, sys

file1 = open("test_file1", "w")
file1.seek(200000000L)
file1.write("Hello")
file1.close

file2 = open("test_file2", "w")
file2.truncate(205000000L)
file2.write("Hello")
file2.close

-- 
Thanks,

Steve



-- 
Thanks,

Steve
