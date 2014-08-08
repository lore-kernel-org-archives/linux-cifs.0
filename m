From: Steve French <smfrench@gmail.com>
Subject: Sparse files and Linux
Date: Fri, 8 Aug 2014 16:07:47 -0500
Message-ID: <CAH2r5msRaKBFHYpiES+vxTCwgyBDg-iV=ZjKpSrYhkHS99B2xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Tried a simple test to see about sparse file creation to Samba from Linux.

Results:
Local (ext4): both file1 and file2 are sparse
Remote over cifs to samba (unix extensions): file1 not sparse, file2 is
sparse
Remote over cifs to samba (unix extensions disabled): file1 and file2 not
sparse
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
