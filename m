Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEFDC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 12:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5126101A
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 12:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJDMtB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:49:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40472 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhJDMtA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Oct 2021 08:49:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4FC261FDE4;
        Mon,  4 Oct 2021 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633351631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SoOqLW1X+Iq4MDGFhD2Lq321ygi5vVzLuBYSOccGbSU=;
        b=1gM6edeJWUuqGUPlhImhcLExge+QHPvYYcI1/H8AFgo+GTG0P9mm5yx+5o3/uEtvB++BJO
        Y+qVQUPYylgU/GH2CAl4IkJZl5gU2eAGVzgm/objBpprfGUiCz9BHfoR073ofx0kYgCqev
        hVKMnd64bLVFHD11SFEQpzBQ4G08zPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633351631;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SoOqLW1X+Iq4MDGFhD2Lq321ygi5vVzLuBYSOccGbSU=;
        b=2DmrLw2YbueYoq0eNMzBBQ9JhKrryJSjSI/zYna/czfOLProzOEpSF8Hlg6Xy7Dq5LSiIr
        IXzuUw0sGqWGWKAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CA77313CEE;
        Mon,  4 Oct 2021 12:47:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mFl7Jc73WmEILwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 04 Oct 2021 12:47:10 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] ksmbd-tools: Add ksmbd-tools.spec template
Date:   Mon,  4 Oct 2021 09:47:04 -0300
Message-Id: <20211004124704.17616-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd-tools.spec should serve as a base template for RPM packagers.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 README           |  2 ++
 ksmbd-tools.spec | 63 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 ksmbd-tools.spec

diff --git a/README b/README
index 3dce3bb41c6e..c64b75c58c2f 100644
--- a/README
+++ b/README
@@ -13,6 +13,8 @@ Install preprequisite packages:
 	For CentOS:
 	sudo yum install glib2-devel libnl3-devel
 
+ksmbd-tools.spec should serve as a base template for RPM packagers.
+
 Build steps:
         - cd into the ksmbd-tools directory
         - ./autogen.sh
diff --git a/ksmbd-tools.spec b/ksmbd-tools.spec
new file mode 100644
index 000000000000..901ca6e6cb76
--- /dev/null
+++ b/ksmbd-tools.spec
@@ -0,0 +1,63 @@
+#
+# spec file for package ksmbd-tools
+#
+# Copyright (c) 2021 SUSE LLC
+#
+# All modifications and additions to the file contributed by third parties
+# remain the property of their copyright owners, unless otherwise agreed
+# upon. The license for this file, and modifications and additions to the
+# file, is the same license as for the pristine package itself (unless the
+# license for the pristine package is not an Open Source License, in which
+# case the license is the MIT License). An "Open Source License" is a
+# license that conforms to the Open Source Definition (Version 1.9)
+# published by the Open Source Initiative.
+#
+# Please submit bugfixes or comments via https://bugs.opensuse.org/
+#
+
+Name:           ksmbd-tools
+Version:        3.4.2
+Release:        0
+Summary:        cifsd/ksmbd kernel server userspace utilities
+License:        GPL-2.0-or-later
+Group:          System/Filesystems
+Url:            https://github.com/namjaejeon/ksmbd-tools
+Source:         %{name}-%{version}.tar.bz2
+
+# ksmbd kernel module was only added in kernel 5.15
+BuildRequires:  kernel-default >= 5.15
+BuildRequires:  glib2-devel
+BuildRequires:  libnl3-devel
+BuildRequires:  autoconf
+BuildRequires:  automake
+BuildRequires:	libtool
+
+Requires(pre):	kernel-default >= 5.15
+
+%description
+Set of utilities for creating and managing SMB3 shares for the ksmbd kernel
+module.
+
+%prep
+%setup -q
+
+%build
+./autogen.sh
+%configure
+make %{?_smp_mflags}
+
+%install
+mkdir -p %{buildroot}/%{_sysconfdir}/ksmbd
+
+%make_install
+install -m 644 -p smb.conf.example %{buildroot}%{_sysconfdir}/ksmbd
+
+%files
+%{_sbindir}/ksmbd.addshare
+%{_sbindir}/ksmbd.adduser
+%{_sbindir}/ksmbd.control
+%{_sbindir}/ksmbd.mountd
+%dir %{_sysconfdir}/ksmbd
+%config %{_sysconfdir}/ksmbd/smb.conf.example
+
+%changelog
-- 
2.33.0

