Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A46C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D9B61131
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhJFQQi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:16:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37284 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbhJFQQi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 12:16:38 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7838C224DA;
        Wed,  6 Oct 2021 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633536885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=nsA9rea+NHfYSIQAM+6A8NvYLyJX0BGNgFUJuKfGwu4=;
        b=awDOp9cFChAf3ndEj3AUlROdaWiYPmEJAi1pKQBkCH7XroEw6tTDa1YRaUbT3drK3//889
        sOZlh69BJ5urjbPbzB5lJEMQtpEzRAHqvfi+50XWVZo5AhVRydJair/QDY8ZUUbHwef8+9
        YeW7H75KgM9sNPM4bXIrWjD9mLh56ng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633536885;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=nsA9rea+NHfYSIQAM+6A8NvYLyJX0BGNgFUJuKfGwu4=;
        b=GZ+MnVvg6YswGrvc1n6zDFEfFOiLURHmLcYrLh0CFCnd5/gj8oiTaPsFBPghUuatwu1rsi
        5gZlmC42Y4XvaPAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C67F13E60;
        Wed,  6 Oct 2021 16:14:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CYNmMnTLXWGHOgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 06 Oct 2021 16:14:44 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org
Subject: [PATCH] ksmbd-tools: update README
Date:   Wed,  6 Oct 2021 13:14:42 -0300
Message-Id: <20211006161442.4724-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Prettify README with markdown and fix some typos/commands.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 README    | 98 -------------------------------------------------------
 README.md | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 98 deletions(-)
 delete mode 100644 README
 create mode 100644 README.md

diff --git a/README b/README
deleted file mode 100644
index 3dce3bb41c6e..000000000000
--- a/README
+++ /dev/null
@@ -1,98 +0,0 @@
-________________________
-BUILDING KSMBD TOOLS
-________________________
-
-Install preprequisite packages:
-	For Ubuntu:
-	sudo apt-get install autoconf libtool pkg-config libnl-3-dev \
-	libnl-genl-3-dev libglib2.0-dev
-
-	For Fedora, RHEL:
-	sudo yum install autoconf automake libtool glib2-devel libnl3-devel
-
-	For CentOS:
-	sudo yum install glib2-devel libnl3-devel
-
-Build steps:
-        - cd into the ksmbd-tools directory
-        - ./autogen.sh
-        - ./configure
-        - make
-        - make install
-
-_____________________
-USING KSMBD TOOLS
-_____________________
-
-Setup steps:
-	- install smbd kernel driver
-		modprobe ksmbd
-	- create user/password for SMB share
-		mkdir /etc/ksmbd/
-		ksmbd.adduser -a <Enter USERNAME for SMB share access>
-		Enter password for SMB share access
-	- create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
-		Refer smb.conf.example
-	- start smbd user space daemon
-		ksmbd.mountd
-	- access share from Windows or Linux using CIFS
-
-_____________________
-RESTART KSMBD
-_____________________
-
-steps:
-	- kill user and kernel space daemon
-		sudo ksmbd.control -s
-	- restart user space daemon
-		ksmbd.mountd
-
-_____________________
-Shutdown KSMBD
-_____________________
-
-steps:
-	- kill user and kernel space daemon
-		sudo ksmbd.control -s
-	- unload ksmbd module
-		rmmod ksmbd
-
-
-_____________________
-Enable debug prints
-_____________________
-
-steps:
-	- Enable all component prints
-		sudo ksmbd.control -d "all"
-	- Enable one of components(smb, auth, vfs, oplock, ipc, conn, rdma)
-		sudo ksmbd.control -d "smb"
-	- Disable prints:
-		If you try the selected component once more, It is disabled without brackets.
-
-
---------------------
-ADMIN TOOLS
---------------------
-
-- ksmbd.adduser
-	Adds, updates or removes (-a/-u/-d) a user from ksmbd pwd file.
-
-- ksmbd.addshare
-	Adds, updates or removes (-a/-u/-d) a net share from smb.conf file.
-
-Usage example:
-
-Creating a new share:
-
-ksmbd.addshare -a files -o "\
-		     path=/home/users/files \
-		     comment=exported files \
-		     writeable=yes \
-		     read only = no \
-		     "
-
-Note that share options (-o) must always be enquoted ("...").
-
-ksmbd.addshare tool does not modify [global] smb.conf section; only net
-share configs are supported at the moment.
diff --git a/README.md b/README.md
new file mode 100644
index 000000000000..b6e4915dc6ff
--- /dev/null
+++ b/README.md
@@ -0,0 +1,86 @@
+# ksmbd-tools
+
+### Building
+
+##### Install prerequisite packages:
+
+- For Ubuntu:
+  - `sudo apt-get install autoconf libtool pkg-config libnl-3-dev libnl-genl-3-dev libglib2.0-dev`
+
+- For Fedora, RHEL:
+  - `sudo yum install autoconf automake libtool glib2-devel libnl3-devel`
+
+- For CentOS:
+  - `sudo yum install glib2-devel libnl3-devel`
+
+- For openSUSE:
+  - `sudo zypper install glib2-devel libnl3-devel`
+
+##### Building:
+
+- clone this repository
+- `cd ksmbd-tools`
+- `./autogen.sh`
+- `./configure`
+- `make`
+- `make install`
+
+
+### Usage
+
+All administration tasks must be done as root.
+
+##### Setup:
+
+- Install ksmbd kernel driver
+	- `modprobe ksmbd`
+- Create user/password for SMB share
+	- `mkdir /etc/ksmbd`
+	- `ksmbd.adduser -a <username>`
+	- Enter password for SMB share access
+- Create `/etc/ksmbd/smb.conf` file
+	- Refer `smb.conf.example`
+- Add share to `smb.conf`
+	- This can be done manually or with `ksmbd.addshare`, e.g.:
+	- `ksmbd.addshare -a myshare -o "guest ok = yes, writable = yes, path = /mnt/data"`
+
+	- Note: share options (-o) must always be enclosed with double quotes ("...").
+- Start ksmbd user space daemon
+	- `ksmbd.mountd`
+- Access share from Windows or Linux using CIFS
+
+
+##### Stopping and restarting the daemon:
+
+- Kill user and kernel space daemon
+  - `ksmbd.control -s`
+- To restart user space daemon
+  - `ksmbd.mountd`
+- To shut it down
+  - `rmmod ksmbd`
+
+
+### Debugging
+
+- Enable all component prints
+  - `ksmbd.control -d "all"`
+- Enable a single component (see below)
+  - `ksmbd.control -d "smb"`
+- Run the command with the same component name again to disable it
+		
+Currently available debug components:
+smb, auth, vfs, oplock, ipc, conn, rdma
+
+
+### More...
+
+- ksmbd.adduser
+  - Adds (-a), updates (-u), or deletes (-d) a user from user database.
+  - Default database file is `/etc/ksmbd/users.db`
+
+- ksmbd.addshare
+  - Adds (-a), updates (-u), or deletes (-d) a net share from config file.
+  - Default config file is `/etc/ksmbd/smb.conf`
+
+`ksmbd.addshare` does not modify `[global]` section in config file; only net
+share configs are supported at the moment.
-- 
2.33.0

