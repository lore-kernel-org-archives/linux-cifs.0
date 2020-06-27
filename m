Return-Path: <SRS0=/h7V=AI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE40C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Jun 2020 10:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2B220DD4
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Jun 2020 10:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgF0Kbn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Jun 2020 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgF0Kbm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Jun 2020 06:31:42 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A743AC03E979
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2020 03:31:41 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 57D43BC129;
        Sat, 27 Jun 2020 10:31:36 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     sfrench@samba.org, corbet@lwn.net, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: CIFS
Date:   Sat, 27 Jun 2020 12:31:25 +0200
Message-Id: <20200627103125.71828-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
          If both the HTTP and HTTPS versions
          return 200 OK and serve the same content:
            Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See https://lkml.org/lkml/2020/6/26/837

 Documentation/admin-guide/cifs/todo.rst            | 2 +-
 Documentation/admin-guide/cifs/usage.rst           | 6 +++---
 Documentation/admin-guide/cifs/winucase_convert.pl | 2 +-
 fs/cifs/cifsacl.c                                  | 4 ++--
 fs/cifs/cifsglob.h                                 | 2 +-
 fs/cifs/winucase.c                                 | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cifs/todo.rst b/Documentation/admin-guide/cifs/todo.rst
index 084c25f92dcb..25f11576e7b9 100644
--- a/Documentation/admin-guide/cifs/todo.rst
+++ b/Documentation/admin-guide/cifs/todo.rst
@@ -98,7 +98,7 @@ x) Finish support for SMB3.1.1 compression
 Known Bugs
 ==========
 
-See http://bugzilla.samba.org - search on product "CifsVFS" for
+See https://bugzilla.samba.org - search on product "CifsVFS" for
 current bug list.  Also check http://bugzilla.kernel.org (Product = File System, Component = CIFS)
 
 1) existing symbolic links (Windows reparse points) are recognized but
diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
index d3fb67b8a976..4abaea40dfd1 100644
--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -17,7 +17,7 @@ standard for interoperating between Macs and Windows and major NAS appliances.
 Please see
 MS-SMB2 (for detailed SMB2/SMB3/SMB3.1.1 protocol specification)
 http://protocolfreedom.org/ and
-http://samba.org/samba/PFIF/
+https://samba.org/samba/PFIF/
 for more details.
 
 
@@ -32,7 +32,7 @@ Build instructions
 
 For Linux:
 
-1) Download the kernel (e.g. from http://www.kernel.org)
+1) Download the kernel (e.g. from https://www.kernel.org)
    and change directory into the top of the kernel directory tree
    (e.g. /usr/src/linux-2.5.73)
 2) make menuconfig (or make xconfig)
@@ -831,7 +831,7 @@ the active sessions and the shares that are mounted.
 Enabling Kerberos (extended security) works but requires version 1.2 or later
 of the helper program cifs.upcall to be present and to be configured in the
 /etc/request-key.conf file.  The cifs.upcall helper program is from the Samba
-project(http://www.samba.org). NTLM and NTLMv2 and LANMAN support do not
+project(https://www.samba.org). NTLM and NTLMv2 and LANMAN support do not
 require this helper. Note that NTLMv2 security (which does not require the
 cifs.upcall helper program), instead of using Kerberos, is sufficient for
 some use cases.
diff --git a/Documentation/admin-guide/cifs/winucase_convert.pl b/Documentation/admin-guide/cifs/winucase_convert.pl
index 322a9c833f23..993186beea20 100755
--- a/Documentation/admin-guide/cifs/winucase_convert.pl
+++ b/Documentation/admin-guide/cifs/winucase_convert.pl
@@ -16,7 +16,7 @@
 #   GNU General Public License for more details.
 #
 #   You should have received a copy of the GNU General Public License
-#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 
 while(<>) {
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 6025d7fc7bbf..fcff14ef1c70 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -49,7 +49,7 @@ static const struct cifs_sid sid_unix_groups = { 1, 1, {0, 0, 0, 0, 0, 22},
 		{cpu_to_le32(2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
 
 /*
- * See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
+ * See https://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
  */
 
 /* S-1-5-88 MS NFS and Apple style UID/GID/mode */
@@ -825,7 +825,7 @@ unsigned int setup_authusers_ACE(struct cifs_ace *pntace)
 
 /*
  * Fill in the special SID based on the mode. See
- * http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
+ * https://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
  */
 unsigned int setup_special_mode_ACE(struct cifs_ace *pntace, __u64 nmode)
 {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fad37d61910a..f4b88cd02662 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -928,7 +928,7 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
  *
  * Citation:
  *
- * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
+ * https://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
  */
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
 #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
diff --git a/fs/cifs/winucase.c b/fs/cifs/winucase.c
index 1a23a1d2ebf9..59b6c577aa0a 100644
--- a/fs/cifs/winucase.c
+++ b/fs/cifs/winucase.c
@@ -9,7 +9,7 @@
  *
  * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
  *
- * http://msdn.microsoft.com/en-us/library/hh877830.aspx
+ * https://msdn.microsoft.com/en-us/library/hh877830.aspx
  * http://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=10921
  *
  * In particular, the table in "Windows 8 Upper Case Mapping Table.txt" was
-- 
2.27.0

