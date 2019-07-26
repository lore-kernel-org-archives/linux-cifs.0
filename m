Return-Path: <SRS0=vxna=VX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CFAC7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 12:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E202238C
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564145529;
	bh=gFW2X0Do6LJBLJKAbfWELDXRxG8XLBhf0m7guSvf6Dg=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=uOq3EyWn5IbltjCLo4Ec4SSnHIfbQYEgrpvdIi3r3k/AiQuvligz8StegAGxSlpva
	 Fx55nVPKAWyI5e1ZKKRkKQ74Zd6rt8vzbW/UNuB8xLmMxHb3kMzAPc60mhp0QI3T7d
	 C13aOcbY+fXyQoNN4WJ7qHGRqwgR6kPOGzo+pShM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGZMwI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:52:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfGZMvo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jul 2019 08:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZHs44LbTcn1TFUdrMsWExNh80YCYgYwMA2ScBQx5rm0=; b=hb1ZpYydhcHUA6A/dkXVVJHRzr
        R0JEfsSqRToa2/HhlhLya6lh6SN5gmcZmXQHlGFFC3SX/arwACoFYCftMC0cMK5VPKEdGz3qLR1+Y
        O+38Wj4ygcXXlYJ+dFNCXIbBQOqZ/830WmAFZHE3PMkFSMa+6PJphz5BkWAtHmonTdVCvbaML+tT6
        Bjt+g/omZeiU7IYcobgCAnKHGbHquM7lXt4PyHJRWfUaDCZ8V844tEAc73WCuB0HtlgpX2Px2QazA
        XhOXvPe29l1gldlcaRC1X0P+jwsu3uOC1GKH9WnjIk/6NAHrusSBJE9AiUWvjCfmXS676fDyzriAj
        vX05pzuA==;
Received: from [179.95.31.157] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqzhE-0006AY-Hu; Fri, 26 Jul 2019 12:51:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hqzhC-0005bB-B8; Fri, 26 Jul 2019 09:51:38 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Steve French <sfrench@samba.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 16/26] docs: fs: cifs: convert to ReST and add to admin-guide book
Date:   Fri, 26 Jul 2019 09:51:26 -0300
Message-Id: <2e5f7e24646d999ac50dcd5e29315c1068aec724.1564145354.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1564145354.git.mchehab+samsung@kernel.org>
References: <cover.1564145354.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The filenames for cifs documentation is not using the same
convention as almost all Kernel documents is using. So,
rename them to a more appropriate name. Then, manually convert
the documentation files for CIFS to ReST.

By doing a manual conversion, we can preserve the original
author's style, while making it to look more like the other
Kernel documents.

Most of the conversion here is trivial. The most complex one was
the README file (which was renamed to usage.rst).

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../AUTHORS => admin-guide/cifs/authors.rst}  |  64 +-
 .../CHANGES => admin-guide/cifs/changes.rst}  |   4 +
 Documentation/admin-guide/cifs/index.rst      |  21 +
 .../cifs/introduction.rst}                    |   8 +
 .../cifs/TODO => admin-guide/cifs/todo.rst}   |  87 +--
 .../README => admin-guide/cifs/usage.rst}     | 560 +++++++++++-------
 .../cifs/winucase_convert.pl                  |   0
 Documentation/admin-guide/index.rst           |   1 +
 MAINTAINERS                                   |   2 +-
 9 files changed, 460 insertions(+), 287 deletions(-)
 rename Documentation/{filesystems/cifs/AUTHORS => admin-guide/cifs/authors.rst} (60%)
 rename Documentation/{filesystems/cifs/CHANGES => admin-guide/cifs/changes.rst} (91%)
 create mode 100644 Documentation/admin-guide/cifs/index.rst
 rename Documentation/{filesystems/cifs/cifs.txt => admin-guide/cifs/introduction.rst} (98%)
 rename Documentation/{filesystems/cifs/TODO => admin-guide/cifs/todo.rst} (58%)
 rename Documentation/{filesystems/cifs/README => admin-guide/cifs/usage.rst} (72%)
 rename Documentation/{filesystems => admin-guide}/cifs/winucase_convert.pl (100%)

diff --git a/Documentation/filesystems/cifs/AUTHORS b/Documentation/admin-guide/cifs/authors.rst
similarity index 60%
rename from Documentation/filesystems/cifs/AUTHORS
rename to Documentation/admin-guide/cifs/authors.rst
index 75865da2ce14..b02d6dd6c070 100644
--- a/Documentation/filesystems/cifs/AUTHORS
+++ b/Documentation/admin-guide/cifs/authors.rst
@@ -1,5 +1,10 @@
+=======
+Authors
+=======
+
 Original Author
-===============
+---------------
+
 Steve French (sfrench@samba.org)
 
 The author wishes to express his appreciation and thanks to:
@@ -12,7 +17,7 @@ side of the original CIFS Unix extensions and reviewing and implementing
 portions of the newer CIFS POSIX extensions into the Samba 3 file server. Thank
 Dave Boutcher of IBM Rochester (author of the OS/400 smb/cifs filesystem client)
 for proving years ago that very good smb/cifs clients could be done on Unix-like
-operating systems.  Volker Lendecke, Andrew Tridgell, Urban Widmark, John 
+operating systems.  Volker Lendecke, Andrew Tridgell, Urban Widmark, John
 Newbigin and others for their work on the Linux smbfs module.  Thanks to
 the other members of the Storage Network Industry Association CIFS Technical
 Workgroup for their work specifying this highly complex protocol and finally
@@ -20,33 +25,34 @@ thanks to the Samba team for their technical advice and encouragement.
 
 Patch Contributors
 ------------------
-Zwane Mwaikambo
-Andi Kleen
-Amrut Joshi
-Shobhit Dayal
-Sergey Vlasov
-Richard Hughes
-Yury Umanets
-Mark Hamzy (for some of the early cifs IPv6 work)
-Domen Puncer
-Jesper Juhl (in particular for lots of whitespace/formatting cleanup)
-Vince Negri and Dave Stahl (for finding an important caching bug)
-Adrian Bunk (kcalloc cleanups)
-Miklos Szeredi 
-Kazeon team for various fixes especially for 2.4 version.
-Asser Ferno (Change Notify support)
-Shaggy (Dave Kleikamp) for innumerable small fs suggestions and some good cleanup
-Gunter Kukkukk (testing and suggestions for support of old servers)
-Igor Mammedov (DFS support)
-Jeff Layton (many, many fixes, as well as great work on the cifs Kerberos code)
-Scott Lovenberg
-Pavel Shilovsky (for great work adding SMB2 support, and various SMB3 features)
-Aurelien Aptel (for DFS SMB3 work and some key bug fixes)
-Ronnie Sahlberg (for SMB3 xattr work, bug fixes, and lots of great work on compounding)
-Shirish Pargaonkar (for many ACL patches over the years)
-Sachin Prabhu (many bug fixes, including for reconnect, copy offload and security)
-Paulo Alcantara
-Long Li (some great work on RDMA, SMB Direct)
+
+- Zwane Mwaikambo
+- Andi Kleen
+- Amrut Joshi
+- Shobhit Dayal
+- Sergey Vlasov
+- Richard Hughes
+- Yury Umanets
+- Mark Hamzy (for some of the early cifs IPv6 work)
+- Domen Puncer
+- Jesper Juhl (in particular for lots of whitespace/formatting cleanup)
+- Vince Negri and Dave Stahl (for finding an important caching bug)
+- Adrian Bunk (kcalloc cleanups)
+- Miklos Szeredi
+- Kazeon team for various fixes especially for 2.4 version.
+- Asser Ferno (Change Notify support)
+- Shaggy (Dave Kleikamp) for innumerable small fs suggestions and some good cleanup
+- Gunter Kukkukk (testing and suggestions for support of old servers)
+- Igor Mammedov (DFS support)
+- Jeff Layton (many, many fixes, as well as great work on the cifs Kerberos code)
+- Scott Lovenberg
+- Pavel Shilovsky (for great work adding SMB2 support, and various SMB3 features)
+- Aurelien Aptel (for DFS SMB3 work and some key bug fixes)
+- Ronnie Sahlberg (for SMB3 xattr work, bug fixes, and lots of great work on compounding)
+- Shirish Pargaonkar (for many ACL patches over the years)
+- Sachin Prabhu (many bug fixes, including for reconnect, copy offload and security)
+- Paulo Alcantara
+- Long Li (some great work on RDMA, SMB Direct)
 
 
 Test case and Bug Report contributors
diff --git a/Documentation/filesystems/cifs/CHANGES b/Documentation/admin-guide/cifs/changes.rst
similarity index 91%
rename from Documentation/filesystems/cifs/CHANGES
rename to Documentation/admin-guide/cifs/changes.rst
index 1df7f4910eb2..71f2ecb62299 100644
--- a/Documentation/filesystems/cifs/CHANGES
+++ b/Documentation/admin-guide/cifs/changes.rst
@@ -1,3 +1,7 @@
+=======
+Changes
+=======
+
 See https://wiki.samba.org/index.php/LinuxCIFSKernel for summary
 information (that may be easier to read than parsing the output of
 "git log fs/cifs") about fixes/improvements to CIFS/SMB2/SMB3 support (changes
diff --git a/Documentation/admin-guide/cifs/index.rst b/Documentation/admin-guide/cifs/index.rst
new file mode 100644
index 000000000000..fad5268635f5
--- /dev/null
+++ b/Documentation/admin-guide/cifs/index.rst
@@ -0,0 +1,21 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+CIFS
+====
+
+.. toctree::
+   :maxdepth: 2
+
+   introduction
+   usage
+   todo
+   changes
+   authors
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/filesystems/cifs/cifs.txt b/Documentation/admin-guide/cifs/introduction.rst
similarity index 98%
rename from Documentation/filesystems/cifs/cifs.txt
rename to Documentation/admin-guide/cifs/introduction.rst
index 1be3d21c286e..0b98f672d36f 100644
--- a/Documentation/filesystems/cifs/cifs.txt
+++ b/Documentation/admin-guide/cifs/introduction.rst
@@ -1,3 +1,7 @@
+============
+Introduction
+============
+
   This is the client VFS module for the SMB3 NAS protocol as well
   as for older dialects such as the Common Internet File System (CIFS)
   protocol which was the successor to the Server Message Block
@@ -33,7 +37,9 @@
   tools (including smbinfo and setcifsacl) that can be obtained from
 
       https://git.samba.org/?p=cifs-utils.git
+
   or
+
       git://git.samba.org/cifs-utils.git
 
   mount.cifs should be installed in the directory with the other mount helpers.
@@ -41,5 +47,7 @@
   For more information on the module see the project wiki page at
 
       https://wiki.samba.org/index.php/LinuxCIFS
+
   and
+
       https://wiki.samba.org/index.php/LinuxCIFS_utils
diff --git a/Documentation/filesystems/cifs/TODO b/Documentation/admin-guide/cifs/todo.rst
similarity index 58%
rename from Documentation/filesystems/cifs/TODO
rename to Documentation/admin-guide/cifs/todo.rst
index 9267f3fb131f..95f18e8c9b8a 100644
--- a/Documentation/filesystems/cifs/TODO
+++ b/Documentation/admin-guide/cifs/todo.rst
@@ -1,3 +1,7 @@
+====
+TODO
+====
+
 Version 2.14 December 21, 2018
 
 A Partial List of Missing Features
@@ -8,6 +12,7 @@ for visible, important contributions to this module.  Here
 is a partial list of the known problems and missing features:
 
 a) SMB3 (and SMB3.1.1) missing optional features:
+
    - multichannel (started), integration with RDMA
    - directory leases (improved metadata caching), started (root dir only)
    - T10 copy offload ie "ODX" (copy chunk, and "Duplicate Extents" ioctl
@@ -16,45 +21,46 @@ a) SMB3 (and SMB3.1.1) missing optional features:
 b) improved sparse file support
 
 c) Directory entry caching relies on a 1 second timer, rather than
-using Directory Leases, currently only the root file handle is cached longer
+   using Directory Leases, currently only the root file handle is cached longer
 
 d) quota support (needs minor kernel change since quota calls
-to make it to network filesystems or deviceless filesystems)
+   to make it to network filesystems or deviceless filesystems)
 
 e) Additional use cases where we use "compoounding" (e.g. open/query/close
-and open/setinfo/close) to reduce the number of roundtrips, and also
-open to reduce redundant opens (using deferred close and reference counts more).
+   and open/setinfo/close) to reduce the number of roundtrips, and also
+   open to reduce redundant opens (using deferred close and reference counts
+   more).
 
 f) Finish inotify support so kde and gnome file list windows
-will autorefresh (partially complete by Asser). Needs minor kernel
-vfs change to support removing D_NOTIFY on a file.   
+   will autorefresh (partially complete by Asser). Needs minor kernel
+   vfs change to support removing D_NOTIFY on a file.
 
 g) Add GUI tool to configure /proc/fs/cifs settings and for display of
-the CIFS statistics (started)
+   the CIFS statistics (started)
 
 h) implement support for security and trusted categories of xattrs
-(requires minor protocol extension) to enable better support for SELINUX
+   (requires minor protocol extension) to enable better support for SELINUX
 
 i) Add support for tree connect contexts (see MS-SMB2) a new SMB3.1.1 protocol
    feature (may be especially useful for virtualization).
 
 j) Create UID mapping facility so server UIDs can be mapped on a per
-mount or a per server basis to client UIDs or nobody if no mapping
-exists. Also better integration with winbind for resolving SID owners
+   mount or a per server basis to client UIDs or nobody if no mapping
+   exists. Also better integration with winbind for resolving SID owners
 
 k) Add tools to take advantage of more smb3 specific ioctls and features
-(passthrough ioctl/fsctl for sending various SMB3 fsctls to the server
-is in progress, and a passthrough query_info call is already implemented
-in cifs.ko to allow smb3 info levels queries to be sent from userspace)
+   (passthrough ioctl/fsctl for sending various SMB3 fsctls to the server
+   is in progress, and a passthrough query_info call is already implemented
+   in cifs.ko to allow smb3 info levels queries to be sent from userspace)
 
 l) encrypted file support
 
 m) improved stats gathering tools (perhaps integration with nfsometer?)
-to extend and make easier to use what is currently in /proc/fs/cifs/Stats
+   to extend and make easier to use what is currently in /proc/fs/cifs/Stats
 
-n) allow setting more NTFS/SMB3 file attributes remotely (currently limited to compressed
-file attribute via chflags) and improve user space tools for managing and
-viewing them.
+n) allow setting more NTFS/SMB3 file attributes remotely (currently limited to
+   compressed file attribute via chflags) and improve user space tools for
+   managing and viewing them.
 
 o) mount helper GUI (to simplify the various configuration options on mount)
 
@@ -65,55 +71,56 @@ p) Add support for witness protocol (perhaps ioctl to cifs.ko from user space
    different servers, and the server we are connected to has gone down.
 
 q) Allow mount.cifs to be more verbose in reporting errors with dialect
-or unsupported feature errors.
+   or unsupported feature errors.
 
 r) updating cifs documentation, and user guide.
 
 s) Addressing bugs found by running a broader set of xfstests in standard
-file system xfstest suite.
+   file system xfstest suite.
 
 t) split cifs and smb3 support into separate modules so legacy (and less
-secure) CIFS dialect can be disabled in environments that don't need it
-and simplify the code.
+   secure) CIFS dialect can be disabled in environments that don't need it
+   and simplify the code.
 
 v) POSIX Extensions for SMB3.1.1 (started, create and mkdir support added
-so far).
+   so far).
 
 w) Add support for additional strong encryption types, and additional spnego
-authentication mechanisms (see MS-SMB2)
+   authentication mechanisms (see MS-SMB2)
+
+Known Bugs
+==========
 
-KNOWN BUGS
-====================================
 See http://bugzilla.samba.org - search on product "CifsVFS" for
 current bug list.  Also check http://bugzilla.kernel.org (Product = File System, Component = CIFS)
 
 1) existing symbolic links (Windows reparse points) are recognized but
-can not be created remotely. They are implemented for Samba and those that
-support the CIFS Unix extensions, although earlier versions of Samba
-overly restrict the pathnames.
+   can not be created remotely. They are implemented for Samba and those that
+   support the CIFS Unix extensions, although earlier versions of Samba
+   overly restrict the pathnames.
 2) follow_link and readdir code does not follow dfs junctions
-but recognizes them
+   but recognizes them
 
 Misc testing to do
 ==================
 1) check out max path names and max path name components against various server
-types. Try nested symlinks (8 deep). Return max path name in stat -f information
+   types. Try nested symlinks (8 deep). Return max path name in stat -f information
 
 2) Improve xfstest's cifs/smb3 enablement and adapt xfstests where needed to test
-cifs/smb3 better
+   cifs/smb3 better
 
-3) Additional performance testing and optimization using iozone and similar - 
-there are some easy changes that can be done to parallelize sequential writes,
-and when signing is disabled to request larger read sizes (larger than 
-negotiated size) and send larger write sizes to modern servers.
+3) Additional performance testing and optimization using iozone and similar -
+   there are some easy changes that can be done to parallelize sequential writes,
+   and when signing is disabled to request larger read sizes (larger than
+   negotiated size) and send larger write sizes to modern servers.
 
 4) More exhaustively test against less common servers
 
 5) Continue to extend the smb3 "buildbot" which does automated xfstesting
-against Windows, Samba and Azure currently - to add additional tests and
-to allow the buildbot to execute the tests faster. The URL for the
-buildbot is: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com
+   against Windows, Samba and Azure currently - to add additional tests and
+   to allow the buildbot to execute the tests faster. The URL for the
+   buildbot is: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com
 
 6) Address various coverity warnings (most are not bugs per-se, but
-the more warnings are addressed, the easier it is to spot real
-problems that static analyzers will point out in the future).
+   the more warnings are addressed, the easier it is to spot real
+   problems that static analyzers will point out in the future).
diff --git a/Documentation/filesystems/cifs/README b/Documentation/admin-guide/cifs/usage.rst
similarity index 72%
rename from Documentation/filesystems/cifs/README
rename to Documentation/admin-guide/cifs/usage.rst
index 4a804619cff2..d3fb67b8a976 100644
--- a/Documentation/filesystems/cifs/README
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -1,53 +1,61 @@
+=====
+Usage
+=====
+
 This module supports the SMB3 family of advanced network protocols (as well
 as older dialects, originally called "CIFS" or SMB1).
 
 The CIFS VFS module for Linux supports many advanced network filesystem
 features such as hierarchical DFS like namespace, hardlinks, locking and more.
-It was designed to comply with the SNIA CIFS Technical Reference (which 
-supersedes the 1992 X/Open SMB Standard) as well as to perform best practice 
-practical interoperability with Windows 2000, Windows XP, Samba and equivalent 
+It was designed to comply with the SNIA CIFS Technical Reference (which
+supersedes the 1992 X/Open SMB Standard) as well as to perform best practice
+practical interoperability with Windows 2000, Windows XP, Samba and equivalent
 servers.  This code was developed in participation with the Protocol Freedom
 Information Foundation.  CIFS and now SMB3 has now become a defacto
 standard for interoperating between Macs and Windows and major NAS appliances.
 
 Please see
-  MS-SMB2 (for detailed SMB2/SMB3/SMB3.1.1 protocol specification)
-  http://protocolfreedom.org/ and
-  http://samba.org/samba/PFIF/
+MS-SMB2 (for detailed SMB2/SMB3/SMB3.1.1 protocol specification)
+http://protocolfreedom.org/ and
+http://samba.org/samba/PFIF/
 for more details.
 
 
 For questions or bug reports please contact:
+
     smfrench@gmail.com
 
 See the project page at: https://wiki.samba.org/index.php/LinuxCIFS_utils
 
-Build instructions:
+Build instructions
 ==================
+
 For Linux:
+
 1) Download the kernel (e.g. from http://www.kernel.org)
-and change directory into the top of the kernel directory tree
-(e.g. /usr/src/linux-2.5.73)
+   and change directory into the top of the kernel directory tree
+   (e.g. /usr/src/linux-2.5.73)
 2) make menuconfig (or make xconfig)
 3) select cifs from within the network filesystem choices
 4) save and exit
 5) make
 
 
-Installation instructions:
+Installation instructions
 =========================
+
 If you have built the CIFS vfs as module (successfully) simply
-type "make modules_install" (or if you prefer, manually copy the file to
+type ``make modules_install`` (or if you prefer, manually copy the file to
 the modules directory e.g. /lib/modules/2.4.10-4GB/kernel/fs/cifs/cifs.ko).
 
 If you have built the CIFS vfs into the kernel itself, follow the instructions
 for your distribution on how to install a new kernel (usually you
-would simply type "make install").
+would simply type ``make install``).
 
 If you do not have the utility mount.cifs (in the Samba 4.x source tree and on
 the CIFS VFS web site) copy it to the same directory in which mount helpers
 reside (usually /sbin).  Although the helper software is not
-required, mount.cifs is recommended.  Most distros include a "cifs-utils"
+required, mount.cifs is recommended.  Most distros include a ``cifs-utils``
 package that includes this utility so it is recommended to install this.
 
 Note that running the Winbind pam/nss module (logon service) on all of your
@@ -57,13 +65,16 @@ found at cifs-utils.git on git.samba.org
 
 If cifs is built as a module, then the size and number of network buffers
 and maximum number of simultaneous requests to one server can be configured.
-Changing these from their defaults is not recommended. By executing modinfo
+Changing these from their defaults is not recommended. By executing modinfo::
+
 	modinfo kernel/fs/cifs/cifs.ko
+
 on kernel/fs/cifs/cifs.ko the list of configuration changes that can be made
 at module initialization time (by running insmod cifs.ko) can be seen.
 
 Recommendations
 ===============
+
 To improve security the SMB2.1 dialect or later (usually will get SMB3) is now
 the new default. To use old dialects (e.g. to mount Windows XP) use "vers=1.0"
 on mount (or vers=2.0 for Windows Vista).  Note that the CIFS (vers=1.0) is
@@ -72,156 +83,168 @@ many advanced security features such as downgrade attack detection
 and encrypted shares and stronger signing and authentication algorithms.
 There are additional mount options that may be helpful for SMB3 to get
 improved POSIX behavior (NB: can use vers=3.0 to force only SMB3, never 2.1):
-     "mfsymlinks" and "cifsacl" and "idsfromsid"
+
+     ``mfsymlinks`` and ``cifsacl`` and ``idsfromsid``
 
 Allowing User Mounts
 ====================
+
 To permit users to mount and unmount over directories they own is possible
 with the cifs vfs.  A way to enable such mounting is to mark the mount.cifs
-utility as suid (e.g. "chmod +s /sbin/mount.cifs). To enable users to 
+utility as suid (e.g. ``chmod +s /sbin/mount.cifs``). To enable users to
 umount shares they mount requires
+
 1) mount.cifs version 1.4 or later
 2) an entry for the share in /etc/fstab indicating that a user may
-unmount it e.g.
-//server/usersharename  /mnt/username cifs user 0 0
+   unmount it e.g.::
 
-Note that when the mount.cifs utility is run suid (allowing user mounts), 
-in order to reduce risks, the "nosuid" mount flag is passed in on mount to
+     //server/usersharename  /mnt/username cifs user 0 0
+
+Note that when the mount.cifs utility is run suid (allowing user mounts),
+in order to reduce risks, the ``nosuid`` mount flag is passed in on mount to
 disallow execution of an suid program mounted on the remote target.
 When mount is executed as root, nosuid is not passed in by default,
 and execution of suid programs on the remote target would be enabled
-by default. This can be changed, as with nfs and other filesystems, 
-by simply specifying "nosuid" among the mount options. For user mounts 
-though to be able to pass the suid flag to mount requires rebuilding 
+by default. This can be changed, as with nfs and other filesystems,
+by simply specifying ``nosuid`` among the mount options. For user mounts
+though to be able to pass the suid flag to mount requires rebuilding
 mount.cifs with the following flag: CIFS_ALLOW_USR_SUID
 
 There is a corresponding manual page for cifs mounting in the Samba 3.0 and
-later source tree in docs/manpages/mount.cifs.8 
+later source tree in docs/manpages/mount.cifs.8
 
 Allowing User Unmounts
 ======================
+
 To permit users to ummount directories that they have user mounted (see above),
-the utility umount.cifs may be used.  It may be invoked directly, or if 
+the utility umount.cifs may be used.  It may be invoked directly, or if
 umount.cifs is placed in /sbin, umount can invoke the cifs umount helper
 (at least for most versions of the umount utility) for umount of cifs
 mounts, unless umount is invoked with -i (which will avoid invoking a umount
 helper). As with mount.cifs, to enable user unmounts umount.cifs must be marked
-as suid (e.g. "chmod +s /sbin/umount.cifs") or equivalent (some distributions
+as suid (e.g. ``chmod +s /sbin/umount.cifs``) or equivalent (some distributions
 allow adding entries to a file to the /etc/permissions file to achieve the
 equivalent suid effect).  For this utility to succeed the target path
 must be a cifs mount, and the uid of the current user must match the uid
 of the user who mounted the resource.
 
-Also note that the customary way of allowing user mounts and unmounts is 
+Also note that the customary way of allowing user mounts and unmounts is
 (instead of using mount.cifs and unmount.cifs as suid) to add a line
 to the file /etc/fstab for each //server/share you wish to mount, but
 this can become unwieldy when potential mount targets include many
 or  unpredictable UNC names.
 
-Samba Considerations 
+Samba Considerations
 ====================
+
 Most current servers support SMB2.1 and SMB3 which are more secure,
 but there are useful protocol extensions for the older less secure CIFS
 dialect, so to get the maximum benefit if mounting using the older dialect
 (CIFS/SMB1), we recommend using a server that supports the SNIA CIFS
 Unix Extensions standard (e.g. almost any  version of Samba ie version
 2.2.5 or later) but the CIFS vfs works fine with a wide variety of CIFS servers.
-Note that uid, gid and file permissions will display default values if you do 
-not have a server that supports the Unix extensions for CIFS (such as Samba 
-2.2.5 or later).  To enable the Unix CIFS Extensions in the Samba server, add 
-the line: 
+Note that uid, gid and file permissions will display default values if you do
+not have a server that supports the Unix extensions for CIFS (such as Samba
+2.2.5 or later).  To enable the Unix CIFS Extensions in the Samba server, add
+the line::
 
 	unix extensions = yes
-	
-to your smb.conf file on the server.  Note that the following smb.conf settings 
-are also useful (on the Samba server) when the majority of clients are Unix or 
-Linux: 
+
+to your smb.conf file on the server.  Note that the following smb.conf settings
+are also useful (on the Samba server) when the majority of clients are Unix or
+Linux::
 
 	case sensitive = yes
-	delete readonly = yes 
+	delete readonly = yes
 	ea support = yes
 
 Note that server ea support is required for supporting xattrs from the Linux
-cifs client, and that EA support is present in later versions of Samba (e.g. 
+cifs client, and that EA support is present in later versions of Samba (e.g.
 3.0.6 and later (also EA support works in all versions of Windows, at least to
 shares on NTFS filesystems).  Extended Attribute (xattr) support is an optional
 feature of most Linux filesystems which may require enabling via
 make menuconfig. Client support for extended attributes (user xattr) can be
-disabled on a per-mount basis by specifying "nouser_xattr" on mount.
+disabled on a per-mount basis by specifying ``nouser_xattr`` on mount.
 
 The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba servers
-version 3.10 and later.  Setting POSIX ACLs requires enabling both XATTR and 
+version 3.10 and later.  Setting POSIX ACLs requires enabling both XATTR and
 then POSIX support in the CIFS configuration options when building the cifs
 module.  POSIX ACL support can be disabled on a per mount basic by specifying
-"noacl" on mount.
- 
-Some administrators may want to change Samba's smb.conf "map archive" and 
-"create mask" parameters from the default.  Unless the create mask is changed
+``noacl`` on mount.
+
+Some administrators may want to change Samba's smb.conf ``map archive`` and
+``create mask`` parameters from the default.  Unless the create mask is changed
 newly created files can end up with an unnecessarily restrictive default mode,
 which may not be what you want, although if the CIFS Unix extensions are
 enabled on the server and client, subsequent setattr calls (e.g. chmod) can
-fix the mode.  Note that creating special devices (mknod) remotely 
-may require specifying a mkdev function to Samba if you are not using 
+fix the mode.  Note that creating special devices (mknod) remotely
+may require specifying a mkdev function to Samba if you are not using
 Samba 3.0.6 or later.  For more information on these see the manual pages
-("man smb.conf") on the Samba server system.  Note that the cifs vfs,
-unlike the smbfs vfs, does not read the smb.conf on the client system 
-(the few optional settings are passed in on mount via -o parameters instead).  
+(``man smb.conf``) on the Samba server system.  Note that the cifs vfs,
+unlike the smbfs vfs, does not read the smb.conf on the client system
+(the few optional settings are passed in on mount via -o parameters instead).
 Note that Samba 2.2.7 or later includes a fix that allows the CIFS VFS to delete
-open files (required for strict POSIX compliance).  Windows Servers already 
+open files (required for strict POSIX compliance).  Windows Servers already
 supported this feature. Samba server does not allow symlinks that refer to files
 outside of the share, so in Samba versions prior to 3.0.6, most symlinks to
-files with absolute paths (ie beginning with slash) such as:
+files with absolute paths (ie beginning with slash) such as::
+
 	 ln -s /mnt/foo bar
-would be forbidden. Samba 3.0.6 server or later includes the ability to create 
-such symlinks safely by converting unsafe symlinks (ie symlinks to server 
+
+would be forbidden. Samba 3.0.6 server or later includes the ability to create
+such symlinks safely by converting unsafe symlinks (ie symlinks to server
 files that are outside of the share) to a samba specific format on the server
 that is ignored by local server applications and non-cifs clients and that will
 not be traversed by the Samba server).  This is opaque to the Linux client
 application using the cifs vfs. Absolute symlinks will work to Samba 3.0.5 or
 later, but only for remote clients using the CIFS Unix extensions, and will
 be invisbile to Windows clients and typically will not affect local
-applications running on the same server as Samba.  
+applications running on the same server as Samba.
 
-Use instructions:
+Use instructions
 ================
-Once the CIFS VFS support is built into the kernel or installed as a module 
+
+Once the CIFS VFS support is built into the kernel or installed as a module
 (cifs.ko), you can use mount syntax like the following to access Samba or
-Mac or Windows servers:
+Mac or Windows servers::
 
   mount -t cifs //9.53.216.11/e$ /mnt -o username=myname,password=mypassword
 
 Before -o the option -v may be specified to make the mount.cifs
-mount helper display the mount steps more verbosely.  
+mount helper display the mount steps more verbosely.
 After -o the following commonly used cifs vfs specific options
-are supported:
+are supported::
 
   username=<username>
   password=<password>
   domain=<domain name>
-  
+
 Other cifs mount options are described below.  Use of TCP names (in addition to
 ip addresses) is available if the mount helper (mount.cifs) is installed. If
 you do not trust the server to which are mounted, or if you do not have
 cifs signing enabled (and the physical network is insecure), consider use
-of the standard mount options "noexec" and "nosuid" to reduce the risk of 
+of the standard mount options ``noexec`` and ``nosuid`` to reduce the risk of
 running an altered binary on your local system (downloaded from a hostile server
 or altered by a hostile router).
 
 Although mounting using format corresponding to the CIFS URL specification is
 not possible in mount.cifs yet, it is possible to use an alternate format
 for the server and sharename (which is somewhat similar to NFS style mount
-syntax) instead of the more widely used UNC format (i.e. \\server\share):
+syntax) instead of the more widely used UNC format (i.e. \\server\share)::
+
   mount -t cifs tcp_name_of_server:share_name /mnt -o user=myname,pass=mypasswd
 
 When using the mount helper mount.cifs, passwords may be specified via alternate
-mechanisms, instead of specifying it after -o using the normal "pass=" syntax
+mechanisms, instead of specifying it after -o using the normal ``pass=`` syntax
 on the command line:
 1) By including it in a credential file. Specify credentials=filename as one
-of the mount options. Credential files contain two lines
-        username=someuser
-        password=your_password
+of the mount options. Credential files contain two lines::
+
+	username=someuser
+	password=your_password
+
 2) By specifying the password in the PASSWD environment variable (similarly
-the user name can be taken from the USER environment variable).
+   the user name can be taken from the USER environment variable).
 3) By specifying the password in a file by name via PASSWD_FILE
 4) By specifying the password in a file by file descriptor via PASSWD_FD
 
@@ -229,39 +252,47 @@ If no password is provided, mount.cifs will prompt for password entry
 
 Restrictions
 ============
-Servers must support either "pure-TCP" (port 445 TCP/IP CIFS connections) or RFC 
-1001/1002 support for "Netbios-Over-TCP/IP." This is not likely to be a 
+
+Servers must support either "pure-TCP" (port 445 TCP/IP CIFS connections) or RFC
+1001/1002 support for "Netbios-Over-TCP/IP." This is not likely to be a
 problem as most servers support this.
 
 Valid filenames differ between Windows and Linux.  Windows typically restricts
-filenames which contain certain reserved characters (e.g.the character : 
+filenames which contain certain reserved characters (e.g.the character :
 which is used to delimit the beginning of a stream name by Windows), while
 Linux allows a slightly wider set of valid characters in filenames. Windows
 servers can remap such characters when an explicit mapping is specified in
-the Server's registry.  Samba starting with version 3.10 will allow such 
+the Server's registry.  Samba starting with version 3.10 will allow such
 filenames (ie those which contain valid Linux characters, which normally
 would be forbidden for Windows/CIFS semantics) as long as the server is
 configured for Unix Extensions (and the client has not disabled
 /proc/fs/cifs/LinuxExtensionsEnabled). In addition the mount option
-"mapposix" can be used on CIFS (vers=1.0) to force the mapping of
+``mapposix`` can be used on CIFS (vers=1.0) to force the mapping of
 illegal Windows/NTFS/SMB characters to a remap range (this mount parm
-is the default for SMB3). This remap ("mapposix") range is also
+is the default for SMB3). This remap (``mapposix``) range is also
 compatible with Mac (and "Services for Mac" on some older Windows).
 
 CIFS VFS Mount Options
 ======================
 A partial list of the supported mount options follows:
-  username	The user name to use when trying to establish
+
+  username
+		The user name to use when trying to establish
 		the CIFS session.
-  password	The user password.  If the mount helper is
+  password
+		The user password.  If the mount helper is
 		installed, the user will be prompted for password
 		if not supplied.
-  ip		The ip address of the target server
-  unc		The target server Universal Network Name (export) to 
-		mount.	
-  domain	Set the SMB/CIFS workgroup name prepended to the
+  ip
+		The ip address of the target server
+  unc
+		The target server Universal Network Name (export) to
+		mount.
+  domain
+		Set the SMB/CIFS workgroup name prepended to the
 		username during CIFS session establishment
-  forceuid	Set the default uid for inodes to the uid
+  forceuid
+		Set the default uid for inodes to the uid
 		passed in on mount. For mounts to servers
 		which do support the CIFS Unix extensions, such as a
 		properly configured Samba server, the server provides
@@ -276,32 +307,39 @@ A partial list of the supported mount options follows:
 		extensions, the default uid (and gid) returned on lookup
 		of existing files will be the uid (gid) of the person
 		who executed the mount (root, except when mount.cifs
-		is configured setuid for user mounts) unless the "uid=" 
+		is configured setuid for user mounts) unless the ``uid=``
 		(gid) mount option is specified. Also note that permission
 		checks (authorization checks) on accesses to a file occur
 		at the server, but there are cases in which an administrator
 		may want to restrict at the client as well.  For those
 		servers which do not report a uid/gid owner
 		(such as Windows), permissions can also be checked at the
-		client, and a crude form of client side permission checking 
-		can be enabled by specifying file_mode and dir_mode on 
+		client, and a crude form of client side permission checking
+		can be enabled by specifying file_mode and dir_mode on
 		the client.  (default)
-  forcegid	(similar to above but for the groupid instead of uid) (default)
-  noforceuid	Fill in file owner information (uid) by requesting it from
+  forcegid
+		(similar to above but for the groupid instead of uid) (default)
+  noforceuid
+		Fill in file owner information (uid) by requesting it from
 		the server if possible. With this option, the value given in
 		the uid= option (on mount) will only be used if the server
 		can not support returning uids on inodes.
-  noforcegid	(similar to above but for the group owner, gid, instead of uid)
-  uid		Set the default uid for inodes, and indicate to the
+  noforcegid
+		(similar to above but for the group owner, gid, instead of uid)
+  uid
+		Set the default uid for inodes, and indicate to the
 		cifs kernel driver which local user mounted. If the server
 		supports the unix extensions the default uid is
 		not used to fill in the owner fields of inodes (files)
-		unless the "forceuid" parameter is specified.
-  gid		Set the default gid for inodes (similar to above).
-  file_mode     If CIFS Unix extensions are not supported by the server
+		unless the ``forceuid`` parameter is specified.
+  gid
+		Set the default gid for inodes (similar to above).
+  file_mode
+		If CIFS Unix extensions are not supported by the server
 		this overrides the default mode for file inodes.
-  fsc		Enable local disk caching using FS-Cache (off by default). This
-  		option could be useful to improve performance on a slow link,
+  fsc
+		Enable local disk caching using FS-Cache (off by default). This
+		option could be useful to improve performance on a slow link,
 		heavily loaded server and/or network where reading from the
 		disk is faster than reading from the server (over the network).
 		This could also impact scalability positively as the
@@ -310,18 +348,22 @@ A partial list of the supported mount options follows:
 		type workloads. So, you need to consider carefully your
 		workload/scenario before using this option. Currently, local
 		disk caching is functional for CIFS files opened as read-only.
-  dir_mode      If CIFS Unix extensions are not supported by the server 
+  dir_mode
+		If CIFS Unix extensions are not supported by the server
 		this overrides the default mode for directory inodes.
-  port		attempt to contact the server on this tcp port, before
+  port
+		attempt to contact the server on this tcp port, before
 		trying the usual ports (port 445, then 139).
-  iocharset     Codepage used to convert local path names to and from
+  iocharset
+		Codepage used to convert local path names to and from
 		Unicode. Unicode is used by default for network path
 		names if the server supports it.  If iocharset is
 		not specified then the nls_default specified
 		during the local client kernel build will be used.
 		If server does not support Unicode, this parameter is
 		unused.
-  rsize		default read size (usually 16K). The client currently
+  rsize
+		default read size (usually 16K). The client currently
 		can not use rsize larger than CIFSMaxBufSize. CIFSMaxBufSize
 		defaults to 16K and may be changed (from 8K to the maximum
 		kmalloc size allowed by your kernel) at module install time
@@ -333,10 +375,12 @@ A partial list of the supported mount options follows:
 		newer servers (e.g. Samba 3.0.26 or later) do. rsize can be
 		set from a minimum of 2048 to a maximum of 130048 (127K or
 		CIFSMaxBufSize, whichever is smaller)
-  wsize		default write size (default 57344)
+  wsize
+		default write size (default 57344)
 		maximum wsize currently allowed by CIFS is 57344 (fourteen
 		4096 byte pages)
-  actimeo=n	attribute cache timeout in seconds (default 1 second).
+  actimeo=n
+		attribute cache timeout in seconds (default 1 second).
 		After this timeout, the cifs client requests fresh attribute
 		information from the server. This option allows to tune the
 		attribute cache timeout to suit the workload needs. Shorter
@@ -345,49 +389,67 @@ A partial list of the supported mount options follows:
 		of calls to the server at the expense of less stricter cache
 		coherency checks (i.e. incorrect attribute cache for a short
 		period of time).
-  rw		mount the network share read-write (note that the
+  rw
+		mount the network share read-write (note that the
 		server may still consider the share read-only)
-  ro		mount network share read-only
-  version	used to distinguish different versions of the
+  ro
+		mount network share read-only
+  version
+		used to distinguish different versions of the
 		mount helper utility (not typically needed)
-  sep		if first mount option (after the -o), overrides
+  sep
+		if first mount option (after the -o), overrides
 		the comma as the separator between the mount
-		parms. e.g.
+		parms. e.g.::
+
 			-o user=myname,password=mypassword,domain=mydom
-		could be passed instead with period as the separator by
+
+		could be passed instead with period as the separator by::
+
 			-o sep=.user=myname.password=mypassword.domain=mydom
+
 		this might be useful when comma is contained within username
 		or password or domain. This option is less important
 		when the cifs mount helper cifs.mount (version 1.1 or later)
 		is used.
-  nosuid        Do not allow remote executables with the suid bit 
+  nosuid
+		Do not allow remote executables with the suid bit
 		program to be executed.  This is only meaningful for mounts
 		to servers such as Samba which support the CIFS Unix Extensions.
 		If you do not trust the servers in your network (your mount
 		targets) it is recommended that you specify this option for
 		greater security.
-  exec		Permit execution of binaries on the mount.
-  noexec	Do not permit execution of binaries on the mount.
-  dev		Recognize block devices on the remote mount.
-  nodev		Do not recognize devices on the remote mount.
-  suid          Allow remote files on this mountpoint with suid enabled to 
+  exec
+		Permit execution of binaries on the mount.
+  noexec
+		Do not permit execution of binaries on the mount.
+  dev
+		Recognize block devices on the remote mount.
+  nodev
+		Do not recognize devices on the remote mount.
+  suid
+		Allow remote files on this mountpoint with suid enabled to
 		be executed (default for mounts when executed as root,
 		nosuid is default for user mounts).
-  credentials   Although ignored by the cifs kernel component, it is used by 
+  credentials
+		Although ignored by the cifs kernel component, it is used by
 		the mount helper, mount.cifs. When mount.cifs is installed it
-		opens and reads the credential file specified in order  
+		opens and reads the credential file specified in order
 		to obtain the userid and password arguments which are passed to
 		the cifs vfs.
-  guest         Although ignored by the kernel component, the mount.cifs
+  guest
+		Although ignored by the kernel component, the mount.cifs
 		mount helper will not prompt the user for a password
 		if guest is specified on the mount options.  If no
 		password is specified a null password will be used.
-  perm          Client does permission checks (vfs_permission check of uid
+  perm
+		Client does permission checks (vfs_permission check of uid
 		and gid of the file against the mode and desired operation),
 		Note that this is in addition to the normal ACL check on the
-		target machine done by the server software. 
+		target machine done by the server software.
 		Client permission checking is enabled by default.
-  noperm        Client does not do permission checks.  This can expose
+  noperm
+		Client does not do permission checks.  This can expose
 		files on this mount to access by other users on the local
 		client system. It is typically only needed when the server
 		supports the CIFS Unix Extensions but the UIDs/GIDs on the
@@ -399,7 +461,8 @@ A partial list of the supported mount options follows:
 		Note that this does not affect the normal ACL check on the
 		target machine done by the server software (of the server
 		ACL against the user name provided at mount time).
-  serverino	Use server's inode numbers instead of generating automatically
+  serverino
+		Use server's inode numbers instead of generating automatically
 		incrementing inode numbers on the client.  Although this will
 		make it easier to spot hardlinked files (as they will have
 		the same inode numbers) and inode numbers may be persistent,
@@ -412,14 +475,16 @@ A partial list of the supported mount options follows:
 		or the CIFS Unix Extensions equivalent and for those
 		this mount option will have no effect.  Exporting cifs mounts
 		under nfsd requires this mount option on the cifs mount.
-		This is now the default if server supports the 
+		This is now the default if server supports the
 		required network operation.
-  noserverino   Client generates inode numbers (rather than using the actual one
+  noserverino
+		Client generates inode numbers (rather than using the actual one
 		from the server). These inode numbers will vary after
 		unmount or reboot which can confuse some applications,
 		but not all server filesystems support unique inode
 		numbers.
-  setuids       If the CIFS Unix extensions are negotiated with the server
+  setuids
+		If the CIFS Unix extensions are negotiated with the server
 		the client will attempt to set the effective uid and gid of
 		the local process on newly created files, directories, and
 		devices (create, mkdir, mknod).  If the CIFS Unix Extensions
@@ -427,9 +492,10 @@ A partial list of the supported mount options follows:
 		instead of using the default uid and gid specified on
 		the mount, cache the new file's uid and gid locally which means
 		that the uid for the file can change when the inode is
-	        reloaded (or the user remounts the share).
-  nosetuids     The client will not attempt to set the uid and gid on
-		on newly created files, directories, and devices (create, 
+		reloaded (or the user remounts the share).
+  nosetuids
+		The client will not attempt to set the uid and gid on
+		on newly created files, directories, and devices (create,
 		mkdir, mknod) which will result in the server setting the
 		uid and gid to the default (usually the server uid of the
 		user who mounted the share).  Letting the server (rather than
@@ -437,38 +503,49 @@ A partial list of the supported mount options follows:
 		Unix Extensions are not negotiated then the uid and gid for
 		new files will appear to be the uid (gid) of the mounter or the
 		uid (gid) parameter specified on the mount.
-  netbiosname   When mounting to servers via port 139, specifies the RFC1001
-		source name to use to represent the client netbios machine 
+  netbiosname
+		When mounting to servers via port 139, specifies the RFC1001
+		source name to use to represent the client netbios machine
 		name when doing the RFC1001 netbios session initialize.
-  direct        Do not do inode data caching on files opened on this mount.
+  direct
+		Do not do inode data caching on files opened on this mount.
 		This precludes mmapping files on this mount. In some cases
 		with fast networks and little or no caching benefits on the
 		client (e.g. when the application is doing large sequential
-		reads bigger than page size without rereading the same data) 
+		reads bigger than page size without rereading the same data)
 		this can provide better performance than the default
-		behavior which caches reads (readahead) and writes 
-		(writebehind) through the local Linux client pagecache 
+		behavior which caches reads (readahead) and writes
+		(writebehind) through the local Linux client pagecache
 		if oplock (caching token) is granted and held. Note that
 		direct allows write operations larger than page size
 		to be sent to the server.
-  strictcache   Use for switching on strict cache mode. In this mode the
+  strictcache
+		Use for switching on strict cache mode. In this mode the
 		client read from the cache all the time it has Oplock Level II,
 		otherwise - read from the server. All written data are stored
 		in the cache, but if the client doesn't have Exclusive Oplock,
 		it writes the data to the server.
-  rwpidforward  Forward pid of a process who opened a file to any read or write
+  rwpidforward
+		Forward pid of a process who opened a file to any read or write
 		operation on that file. This prevent applications like WINE
 		from failing on read and write if we use mandatory brlock style.
-  acl   	Allow setfacl and getfacl to manage posix ACLs if server
+  acl
+		Allow setfacl and getfacl to manage posix ACLs if server
 		supports them.  (default)
-  noacl 	Do not allow setfacl and getfacl calls on this mount
-  user_xattr    Allow getting and setting user xattrs (those attributes whose
-		name begins with "user." or "os2.") as OS/2 EAs (extended
+  noacl
+		Do not allow setfacl and getfacl calls on this mount
+  user_xattr
+		Allow getting and setting user xattrs (those attributes whose
+		name begins with ``user.`` or ``os2.``) as OS/2 EAs (extended
 		attributes) to the server.  This allows support of the
 		setfattr and getfattr utilities. (default)
-  nouser_xattr  Do not allow getfattr/setfattr to get/set/list xattrs 
-  mapchars      Translate six of the seven reserved characters (not backslash)
+  nouser_xattr
+		Do not allow getfattr/setfattr to get/set/list xattrs
+  mapchars
+		Translate six of the seven reserved characters (not backslash)::
+
 			*?<>|:
+
 		to the remap range (above 0xF000), which also
 		allows the CIFS client to recognize files created with
 		such characters by Windows's POSIX emulation. This can
@@ -477,39 +554,47 @@ A partial list of the supported mount options follows:
 		whose names contain any of these seven characters).
 		This has no effect if the server does not support
 		Unicode on the wire.
- nomapchars     Do not translate any of these seven characters (default).
- nocase         Request case insensitive path name matching (case
+  nomapchars
+		Do not translate any of these seven characters (default).
+  nocase
+		Request case insensitive path name matching (case
 		sensitive is the default if the server supports it).
-		(mount option "ignorecase" is identical to "nocase")
- posixpaths     If CIFS Unix extensions are supported, attempt to
+		(mount option ``ignorecase`` is identical to ``nocase``)
+  posixpaths
+		If CIFS Unix extensions are supported, attempt to
 		negotiate posix path name support which allows certain
 		characters forbidden in typical CIFS filenames, without
 		requiring remapping. (default)
- noposixpaths   If CIFS Unix extensions are supported, do not request
+  noposixpaths
+		If CIFS Unix extensions are supported, do not request
 		posix path name support (this may cause servers to
 		reject creatingfile with certain reserved characters).
- nounix         Disable the CIFS Unix Extensions for this mount (tree
+  nounix
+		Disable the CIFS Unix Extensions for this mount (tree
 		connection). This is rarely needed, but it may be useful
 		in order to turn off multiple settings all at once (ie
 		posix acls, posix locks, posix paths, symlink support
 		and retrieving uids/gids/mode from the server) or to
 		work around a bug in server which implement the Unix
 		Extensions.
- nobrl          Do not send byte range lock requests to the server.
+  nobrl
+		Do not send byte range lock requests to the server.
 		This is necessary for certain applications that break
 		with cifs style mandatory byte range locks (and most
 		cifs servers do not yet support requesting advisory
 		byte range locks).
- forcemandatorylock Even if the server supports posix (advisory) byte range
+  forcemandatorylock
+		Even if the server supports posix (advisory) byte range
 		locking, send only mandatory lock requests.  For some
 		(presumably rare) applications, originally coded for
 		DOS/Windows, which require Windows style mandatory byte range
 		locking, they may be able to take advantage of this option,
 		forcing the cifs client to only send mandatory locks
 		even if the cifs server would support posix advisory locks.
-		"forcemand" is accepted as a shorter form of this mount
+		``forcemand`` is accepted as a shorter form of this mount
 		option.
- nostrictsync   If this mount option is set, when an application does an
+  nostrictsync
+		If this mount option is set, when an application does an
 		fsync call then the cifs client does not send an SMB Flush
 		to the server (to force the server to write all dirty data
 		for this file immediately to disk), although cifs still sends
@@ -522,41 +607,50 @@ A partial list of the supported mount options follows:
 		crash.  If this mount option is not set, by default cifs will
 		send an SMB flush request (and wait for a response) on every
 		fsync call.
- nodfs          Disable DFS (global name space support) even if the
+  nodfs
+		Disable DFS (global name space support) even if the
 		server claims to support it.  This can help work around
 		a problem with parsing of DFS paths with Samba server
 		versions 3.0.24 and 3.0.25.
- remount        remount the share (often used to change from ro to rw mounts
-	        or vice versa)
- cifsacl        Report mode bits (e.g. on stat) based on the Windows ACL for
-	        the file. (EXPERIMENTAL)
- servern        Specify the server 's netbios name (RFC1001 name) to use
-		when attempting to setup a session to the server. 
+  remount
+		remount the share (often used to change from ro to rw mounts
+		or vice versa)
+  cifsacl
+		Report mode bits (e.g. on stat) based on the Windows ACL for
+		the file. (EXPERIMENTAL)
+  servern
+		Specify the server 's netbios name (RFC1001 name) to use
+		when attempting to setup a session to the server.
 		This is needed for mounting to some older servers (such
 		as OS/2 or Windows 98 and Windows ME) since they do not
 		support a default server name.  A server name can be up
 		to 15 characters long and is usually uppercased.
- sfu            When the CIFS Unix Extensions are not negotiated, attempt to
+  sfu
+		When the CIFS Unix Extensions are not negotiated, attempt to
 		create device files and fifos in a format compatible with
 		Services for Unix (SFU).  In addition retrieve bits 10-12
 		of the mode via the SETFILEBITS extended attribute (as
 		SFU does).  In the future the bottom 9 bits of the
 		mode also will be emulated using queries of the security
 		descriptor (ACL).
- mfsymlinks     Enable support for Minshall+French symlinks
+  mfsymlinks
+		Enable support for Minshall+French symlinks
 		(see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks)
 		This option is ignored when specified together with the
 		'sfu' option. Minshall+French symlinks are used even if
 		the server supports the CIFS Unix Extensions.
- sign           Must use packet signing (helps avoid unwanted data modification
+  sign
+		Must use packet signing (helps avoid unwanted data modification
 		by intermediate systems in the route).  Note that signing
 		does not work with lanman or plaintext authentication.
- seal           Must seal (encrypt) all data on this mounted share before
+  seal
+		Must seal (encrypt) all data on this mounted share before
 		sending on the network.  Requires support for Unix Extensions.
 		Note that this differs from the sign mount option in that it
 		causes encryption of data sent over this mounted share but other
 		shares mounted to the same server are unaffected.
- locallease     This option is rarely needed. Fcntl F_SETLEASE is
+  locallease
+		This option is rarely needed. Fcntl F_SETLEASE is
 		used by some applications such as Samba and NFSv4 server to
 		check to see whether a file is cacheable.  CIFS has no way
 		to explicitly request a lease, but can check whether a file
@@ -569,51 +663,73 @@ A partial list of the supported mount options follows:
 		will allow the cifs client to check for leases (only) locally
 		for files which are not oplocked instead of denying leases
 		in that case. (EXPERIMENTAL)
- sec            Security mode.  Allowed values are:
-			none	attempt to connection as a null user (no name)
-			krb5    Use Kerberos version 5 authentication
-			krb5i   Use Kerberos authentication and packet signing
-			ntlm    Use NTLM password hashing (default)
-			ntlmi   Use NTLM password hashing with signing (if
+  sec
+		Security mode.  Allowed values are:
+
+			none
+				attempt to connection as a null user (no name)
+			krb5
+				Use Kerberos version 5 authentication
+			krb5i
+				Use Kerberos authentication and packet signing
+			ntlm
+				Use NTLM password hashing (default)
+			ntlmi
+				Use NTLM password hashing with signing (if
 				/proc/fs/cifs/PacketSigningEnabled on or if
-				server requires signing also can be the default) 
-			ntlmv2  Use NTLMv2 password hashing      
-			ntlmv2i Use NTLMv2 password hashing with packet signing
-			lanman  (if configured in kernel config) use older
+				server requires signing also can be the default)
+			ntlmv2
+				Use NTLMv2 password hashing
+			ntlmv2i
+				Use NTLMv2 password hashing with packet signing
+			lanman
+				(if configured in kernel config) use older
 				lanman hash
-hard		Retry file operations if server is not responding
-soft		Limit retries to unresponsive servers (usually only
+  hard
+		Retry file operations if server is not responding
+  soft
+		Limit retries to unresponsive servers (usually only
 		one retry) before returning an error.  (default)
 
 The mount.cifs mount helper also accepts a few mount options before -o
 including:
 
+=============== ===============================================================
 	-S      take password from stdin (equivalent to setting the environment
-		variable "PASSWD_FD=0"
+		variable ``PASSWD_FD=0``
 	-V      print mount.cifs version
 	-?      display simple usage information
+=============== ===============================================================
 
 With most 2.6 kernel versions of modutils, the version of the cifs kernel
 module can be displayed via modinfo.
 
 Misc /proc/fs/cifs Flags and Debug Info
 =======================================
+
 Informational pseudo-files:
+
+======================= =======================================================
 DebugData		Displays information about active CIFS sessions and
 			shares, features enabled as well as the cifs.ko
 			version.
 Stats			Lists summary resource usage information as well as per
 			share statistics.
+======================= =======================================================
 
 Configuration pseudo-files:
+
+======================= =======================================================
 SecurityFlags		Flags which control security negotiation and
 			also packet signing. Authentication (may/must)
 			flags (e.g. for NTLM and/or NTLMv2) may be combined with
 			the signing flags.  Specifying two different password
-			hashing mechanisms (as "must use") on the other hand 
-			does not make much sense. Default flags are 
-				0x07007 
-			(NTLM, NTLMv2 and packet signing allowed).  The maximum 
+			hashing mechanisms (as "must use") on the other hand
+			does not make much sense. Default flags are::
+
+				0x07007
+
+			(NTLM, NTLMv2 and packet signing allowed).  The maximum
 			allowable flags if you want to allow mounts to servers
 			using weaker password hashes is 0x37037 (lanman,
 			plaintext, ntlm, ntlmv2, signing allowed).  Some
@@ -626,21 +742,21 @@ SecurityFlags		Flags which control security negotiation and
 			laintext passwords using the older lanman dialect
 			form of the session setup SMB.  (e.g. for authentication
 			using plain text passwords, set the SecurityFlags
-			to 0x30030):
- 
-			may use packet signing 				0x00001
-			must use packet signing				0x01001
-			may use NTLM (most common password hash)	0x00002
-			must use NTLM					0x02002
-			may use NTLMv2					0x00004
-			must use NTLMv2					0x04004
-			may use Kerberos security			0x00008
-			must use Kerberos				0x08008
-			may use lanman (weak) password hash  		0x00010
-			must use lanman password hash			0x10010
-			may use plaintext passwords    			0x00020
-			must use plaintext passwords			0x20020
-			(reserved for future packet encryption)		0x00040
+			to 0x30030)::
+
+			  may use packet signing			0x00001
+			  must use packet signing			0x01001
+			  may use NTLM (most common password hash)	0x00002
+			  must use NTLM					0x02002
+			  may use NTLMv2				0x00004
+			  must use NTLMv2				0x04004
+			  may use Kerberos security			0x00008
+			  must use Kerberos				0x08008
+			  may use lanman (weak) password hash		0x00010
+			  must use lanman password hash			0x10010
+			  may use plaintext passwords			0x00020
+			  must use plaintext passwords			0x20020
+			  (reserved for future packet encryption)	0x00040
 
 cifsFYI			If set to non-zero value, additional debug information
 			will be logged to the system error log.  This field
@@ -650,14 +766,19 @@ cifsFYI			If set to non-zero value, additional debug information
 			Some debugging statements are not compiled into the
 			cifs kernel unless CONFIG_CIFS_DEBUG2 is enabled in the
 			kernel configuration. cifsFYI may be set to one or
-			nore of the following flags (7 sets them all):
+			nore of the following flags (7 sets them all)::
+
+			  +-----------------------------------------------+------+
+			  | log cifs informational messages		  | 0x01 |
+			  +-----------------------------------------------+------+
+			  | log return codes from cifs entry points	  | 0x02 |
+			  +-----------------------------------------------+------+
+			  | log slow responses				  | 0x04 |
+			  | (ie which take longer than 1 second)	  |      |
+			  |                                               |      |
+			  | CONFIG_CIFS_STATS2 must be enabled in .config |      |
+			  +-----------------------------------------------+------+
 
-			log cifs informational messages			0x01
-			log return codes from cifs entry points		0x02
-			log slow responses (ie which take longer than 1 second)
-			  CONFIG_CIFS_STATS2 must be enabled in .config	0x04
-				
-				
 traceSMB		If set to one, debug information is logged to the
 			system error log with the start of smb requests
 			and responses (default 0)
@@ -671,24 +792,25 @@ LinuxExtensionsEnabled	If set to one then the client will attempt to
 			as support symbolic links. If you use servers
 			such as Samba that support the CIFS Unix
 			extensions but do not want to use symbolic link
-			support and want to map the uid and gid fields 
-			to values supplied at mount (rather than the 
+			support and want to map the uid and gid fields
+			to values supplied at mount (rather than the
 			actual values, then set this to zero. (default 1)
+======================= =======================================================
 
-These experimental features and tracing can be enabled by changing flags in 
-/proc/fs/cifs (after the cifs module has been installed or built into the 
-kernel, e.g.  insmod cifs).  To enable a feature set it to 1 e.g.  to enable 
-tracing to the kernel message log type: 
+These experimental features and tracing can be enabled by changing flags in
+/proc/fs/cifs (after the cifs module has been installed or built into the
+kernel, e.g.  insmod cifs).  To enable a feature set it to 1 e.g.  to enable
+tracing to the kernel message log type::
 
 	echo 7 > /proc/fs/cifs/cifsFYI
-	
+
 cifsFYI functions as a bit mask. Setting it to 1 enables additional kernel
 logging of various informational messages.  2 enables logging of non-zero
 SMB return codes while 4 enables logging of requests that take longer
-than one second to complete (except for byte range lock requests). 
+than one second to complete (except for byte range lock requests).
 Setting it to 4 requires CONFIG_CIFS_STATS2 to be set in kernel configuration
 (.config). Setting it to seven enables all three.  Finally, tracing
-the start of smb requests and responses can be enabled via:
+the start of smb requests and responses can be enabled via::
 
 	echo 1 > /proc/fs/cifs/traceSMB
 
@@ -700,10 +822,10 @@ server) SMB3 (or cifs) requests grouped by request type (read, write, close etc.
 Also recorded is the total bytes read and bytes written to the server for
 that share.  Note that due to client caching effects this can be less than the
 number of bytes read and written by the application running on the client.
-Statistics can be reset to zero by "echo 0 > /proc/fs/cifs/Stats" which may be
+Statistics can be reset to zero by ``echo 0 > /proc/fs/cifs/Stats`` which may be
 useful if comparing performance of two different scenarios.
-	
-Also note that "cat /proc/fs/cifs/DebugData" will display information about
+
+Also note that ``cat /proc/fs/cifs/DebugData`` will display information about
 the active sessions and the shares that are mounted.
 
 Enabling Kerberos (extended security) works but requires version 1.2 or later
@@ -725,19 +847,23 @@ space to ease network configuration and improve reliability.
 
 To use cifs Kerberos and DFS support, the Linux keyutils package should be
 installed and something like the following lines should be added to the
-/etc/request-key.conf file:
+/etc/request-key.conf file::
 
-create cifs.spnego * * /usr/local/sbin/cifs.upcall %k
-create dns_resolver * * /usr/local/sbin/cifs.upcall %k
+  create cifs.spnego * * /usr/local/sbin/cifs.upcall %k
+  create dns_resolver * * /usr/local/sbin/cifs.upcall %k
 
 CIFS kernel module parameters
 =============================
 These module parameters can be specified or modified either during the time of
-module loading or during the runtime by using the interface
+module loading or during the runtime by using the interface::
+
 	/proc/module/cifs/parameters/<param>
 
-i.e. echo "value" > /sys/module/cifs/parameters/<param>
+i.e.::
 
-1. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
-		    [Y/y/1]. To disable use any of [N/n/0].
+    echo "value" > /sys/module/cifs/parameters/<param>
 
+================= ==========================================================
+1. enable_oplocks Enable or disable oplocks. Oplocks are enabled by default.
+		  [Y/y/1]. To disable use any of [N/n/0].
+================= ==========================================================
diff --git a/Documentation/filesystems/cifs/winucase_convert.pl b/Documentation/admin-guide/cifs/winucase_convert.pl
similarity index 100%
rename from Documentation/filesystems/cifs/winucase_convert.pl
rename to Documentation/admin-guide/cifs/winucase_convert.pl
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index 99d84f5f80db..6e6c23b6193a 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -77,6 +77,7 @@ configure specific aspects of kernel behavior to your liking.
    blockdev/index
    ext4
    binderfs
+   cifs/index
    xfs
    pm/index
    thunderbolt
diff --git a/MAINTAINERS b/MAINTAINERS
index 2055887f07ef..b6b9d8c67987 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4099,7 +4099,7 @@ L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 T:	git git://git.samba.org/sfrench/cifs-2.6.git
 S:	Supported
-F:	Documentation/filesystems/cifs/
+F:	Documentation/admin-guide/cifs/
 F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
-- 
2.21.0

