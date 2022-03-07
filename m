Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7595C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiCGBfg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiCGBff (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:35 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A0F3E0CB
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2244B210ED;
        Mon,  7 Mar 2022 01:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OyM4dNIElj3ftzvx7Skp56qIDauSPsWpul6l2EGUp5c=;
        b=znJukYGIDZawvbgByS8F93PYrq9abHUORUnQl4Rm/8/+cfv1VA41fuK2IMZrHHf9LdsEpI
        HqD6wM85TCi7ila5GaD3ct074xoWKwLWjTi26yoDb80ZtOJ11lQ/XDs8uJo/QsJFZJKVUs
        aRb5WJyX570j1eCbBPYoU1Pjx6tmLN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616879;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OyM4dNIElj3ftzvx7Skp56qIDauSPsWpul6l2EGUp5c=;
        b=+Ti9NU1k/Mf1KSIEJE+ICQqZEbdZnEJmXezdjZ7CdHWBHYHMdfFwHKyHzfYuW0xhL4/ro6
        Hwa7OLkVtB6VuBBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A79B1340A;
        Mon,  7 Mar 2022 01:34:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id grCkFy5hJWJMdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:38 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 9/9] README: change to markdown, updates for ksmbdctl
Date:   Sun,  6 Mar 2022 22:33:44 -0300
Message-Id: <20220307013344.29064-10-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change README to markdown format.

Includes instructions for openSUSE.

Updates instructions for ksmbdctl (single binary).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 README    | 100 ------------------------------------------------------
 README.md |  57 ++++++++++++++++---------------
 2 files changed, 30 insertions(+), 127 deletions(-)
 delete mode 100644 README

diff --git a/README b/README
deleted file mode 100644
index c64b75c58c2f..000000000000
--- a/README
+++ /dev/null
@@ -1,100 +0,0 @@
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
-ksmbd-tools.spec should serve as a base template for RPM packagers.
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
index 7156c2e20dee..1e8fceb11e23 100644
--- a/README.md
+++ b/README.md
@@ -5,16 +5,17 @@
 ##### Install prerequisite packages:
 
 - For Ubuntu:
-  - `sudo apt-get install autoconf libtool pkg-config libnl-3-dev libnl-genl-3-dev libglib2.0-dev`
+  - `sudo apt-get install autoconf libtool pkg-config libnl-3-dev libnl-genl-3-dev libglib2.0-dev libkrb5-dev`
 
 - For Fedora, RHEL:
-  - `sudo yum install autoconf automake libtool glib2-devel libnl3-devel`
+  - `sudo yum install autoconf automake libtool glib2-devel libnl3-devel krb5-devel`
 
 - For CentOS:
-  - `sudo yum install glib2-devel libnl3-devel`
+  - `sudo yum install glib2-devel libnl3-devel krb5-devel`
 
 - For openSUSE:
-  - `sudo zypper install glib2-devel libnl3-devel`
+  - `sudo zypper install glib2-devel libnl3-devel krb5-devel`
+
 
 ##### Building:
 
@@ -32,31 +33,31 @@ All administration tasks must be done as root.
 
 ##### Setup:
 
-- Install ksmbd kernel driver
+- Install ksmbd kernel driver (requires CONFIG_SMB_SERVER=y)
 	- `modprobe ksmbd`
 - Create user/password for SMB share
 	- `mkdir /etc/ksmbd`
-	- `ksmbd.adduser -a <username>`
-	- Enter password for SMB share access
+	- `ksmbdctl user add <username>`
+	- Enter password for user when prompted
 - Create `/etc/ksmbd/smb.conf` file
 	- Refer `smb.conf.example`
 - Add share to `smb.conf`
-	- This can be done manually or with `ksmbd.addshare`, e.g.:
-	- `ksmbd.addshare -a myshare -o "guest ok = yes, writable = yes, path = /mnt/data"`
+	- This can be done either manually or with `ksmbdctl`, e.g.:
+	- `ksmbdctl share add myshare -o "guest ok = yes, writable = yes, path = /mnt/data"`
 
 	- Note: share options (-o) must always be enclosed with double quotes ("...").
 - Start ksmbd user space daemon
-	- `ksmbd.mountd`
-- Access share from Windows or Linux using CIFS
+	- `ksmbdctl daemon start`
+- Access share from Windows or Linux
 
 
 ##### Stopping and restarting the daemon:
 
-First, kill user and kernel space daemon
-  - `ksmbd.control -s`
+First, kill user and kernel space daemon:
+  - `ksmbdctl daemon shutdown`
 
 Then, to restart the daemon, run:
-  - `ksmbd.mountd`
+  - `ksmbdctl daemon start`
 
 Or to shut it down completely:
   - `rmmod ksmbd`
@@ -64,25 +65,27 @@ Or to shut it down completely:
 
 ### Debugging
 
-- Enable all component prints
-  - `ksmbd.control -d "all"`
-- Enable a single component (see below)
-  - `ksmbd.control -d "smb"`
-- Run the command with the same component name again to disable it
+- Enable debugging all components
+  - `ksmbdctl daemon debug "all"`
+- Enable debugging a single component (see more below)
+  - `ksmbdctl daemon debug "smb"`
+- Run the commands above with the same component name again to disable it
 
 Currently available debug components:
 smb, auth, vfs, oplock, ipc, conn, rdma
 
 
-### More...
+### User management
 
-- ksmbd.adduser
-  - Adds (-a), updates (-u), or deletes (-d) a user from user database.
-  - Default database file is `/etc/ksmbd/users.db`
+- ksmbdctl user
+  - Adds, updates, deletes, or lists users from database.
+  - Default database file is `/etc/ksmbd/users.db`, but can be changed with '-d'
+    option.
 
-- ksmbd.addshare
-  - Adds (-a), updates (-u), or deletes (-d) a net share from config file.
-  - Default config file is `/etc/ksmbd/smb.conf`
+- ksmbdctl share
+  - Adds, updates, deletes, or lists net shares from config file.
+  - Default config file is `/etc/ksmbd/smb.conf`, but can be changed with '-c'
+    option.
 
-`ksmbd.addshare` does not modify `[global]` section in config file; only net
+`ksmbdctl share add` does not modify `[global]` section in config file; only net
 share configs are supported at the moment.
-- 
2.34.1

