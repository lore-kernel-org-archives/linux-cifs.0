Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C6EC48BE5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Jun 2021 16:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 880DB6191A
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Jun 2021 16:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOQq3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Jun 2021 12:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhFOQq2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Jun 2021 12:46:28 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A21C061574;
        Tue, 15 Jun 2021 09:44:23 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c5so5463547qka.4;
        Tue, 15 Jun 2021 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2R5nivCzpISn1Pts0wo4OZf5lGwIGE9nnTlbS7Biqw=;
        b=fKdDh0a8DQG4/NJxLk9kKndAbGAXAgRHHj0yH/texVnfmH2oj6ZY1YkqSULhubarC1
         ii9LZmOmJX5dm6Fk1wzpXKUfHaQaAt1kYSvfPrggjggRt/b/rr6OnNNjD+5LXLmCrq4l
         2vj3lFs4jwt+Vvs+oH7zEUsLl/GRYEOFM9oa8wK2xngcJVujK2R6wEJj99PvQxVxrXMM
         YnfFi7RIN2TFLIFudr1WHM84wgjvzZfRB/re4OMQPw5HJrTmQCPqeqAxjRGgx+KWyNti
         eFqd+kxmvsKDfHWLayhOaqpbt/i40h1d6xxYYk7GouMA6fZsDhBuML5zMlHIs7+4qiVJ
         mEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2R5nivCzpISn1Pts0wo4OZf5lGwIGE9nnTlbS7Biqw=;
        b=fW09Jj5yq22X75Dvk+8fxbHZzY7KfgWla+w5AGU/Wg6D9Y4vUMZk2OgjXm/EALpD8f
         Hfu5OvU/3DVSK/akmBVsQiTCm4Kz1fVgKQtPGTwQxdU+nA/mzilB2IwCOUIxpaGKY0ws
         o+jRVXBY1kYGfh9ux296HF6NOhJtd4zLmTujBG0ZpzvO2UZaXXQiDbGjFzPKI/A5pEjA
         mM6/4hd1yI77Y7TG+s56OHuCZhLpI6XFktdSEfoho166l8MzOQtpIdao4xtGOy+7KbNH
         VRck5IvyZH0jJRQVXv5PSoLw+/qNq9GVDOwxr75KyVmTp276c0lxwoRVk++9zjmhgdQh
         /lEQ==
X-Gm-Message-State: AOAM533uKqfYo0S37egO9ThreWRrcf/wmgRg7lY6nB9FKdmh5KsQPoqU
        66oSVzvxjdh7MkaQ+62nokmAcCQbApJtVg==
X-Google-Smtp-Source: ABdhPJx0SgEC5s3jQaBVO2he4SBEY+lb8UnyhLl/cxqxHjPE5ms6d9BM+SlETXWWMhXdbIEI0KvPzQ==
X-Received: by 2002:ae9:c112:: with SMTP id z18mr531126qki.41.1623775461919;
        Tue, 15 Jun 2021 09:44:21 -0700 (PDT)
Received: from nyarly.redhat.com ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id b189sm12667327qkc.91.2021.06.15.09.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:44:21 -0700 (PDT)
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thiago Rafael Becker <trbecker@gmail.com>
Subject: [PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
Date:   Tue, 15 Jun 2021 13:42:56 -0300
Message-Id: <20210615164256.173715-1-trbecker@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

According to the investigation performed by Jacob Shivers at Red Hat,
cifs_lookup and cifs_readdir leak EAGAIN when the user session is
deleted on the server. Fix this issue by implementing a retry with
limits, as is implemented in cifs_revalidate_dentry_attr.

Reproducer based on the work by Jacob Shivers:

  ~~~
  $ cat readdir-cifs-test.sh
  #!/bin/bash

  # Install and configure powershell and sshd on the windows
  #  server as descibed in
  # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
  # This script uses expect(1)

  USER=dude
  SERVER=192.168.0.2
  RPATH=root
  PASS='password'

  function debug_funcs {
  	for line in $@ ; do
  		echo "func $line +p" > /sys/kernel/debug/dynamic_debug/control
  	done
  }

  function setup {
  	echo 1 > /proc/fs/cifs/cifsFYI
  	debug_funcs wait_for_compound_request \
                smb2_query_dir_first cifs_readdir \
                compound_send_recv cifs_reconnect_tcon \
                generic_ip_connect cifs_reconnect \
                smb2_reconnect_server smb2_reconnect \
                cifs_readv_from_socket cifs_readv_receive
  	tcpdump -i eth0 -w cifs.pcap host 192.168.2.182 & sleep 5
  	dmesg -C
  }

  function test_call {
  	if [[ $1 == 1 ]] ; then
  		tracer="strace -tt -f -s 4096 -o trace-$(date -Iseconds).txt"
  	fi
        # Change the command here to anything apropriate
  	$tracer ls $2 > /dev/null
  	res=$?
  	if [[ $1 == 1 ]] ; then
  		if [[ $res == 0 ]] ; then
  			1>&2 echo success
  		else
  			1>&2 echo "failure ($res)"
  		fi
  	fi
  }

  mountpoint /mnt > /dev/null || mount -t cifs -o username=$USER,pass=$PASS //$SERVER/$RPATH /mnt

  test_call 0 /mnt/

  /usr/bin/expect << EOF
  	set timeout 60

  	spawn ssh $USER@$SERVER

  	expect "yes/no" {
  		send "yes\r"
  		expect "*?assword" { send "$PASS\r" }
  	} "*?assword" { send "$PASS\r" }

  	expect ">" { send "powershell close-smbsession -force\r" }
  	expect ">" { send "exit\r" }
  	expect eof
  EOF

  sysctl -w vm.drop_caches=2 > /dev/null
  sysctl -w vm.drop_caches=2 > /dev/null

  setup

  test_call 1 /mnt/
  ~~~

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 fs/cifs/dir.c     | 4 ++++
 fs/cifs/smb2ops.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6bcd3e8f7cda..7c641f9a3dac 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -630,6 +630,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct inode *newInode = NULL;
 	const char *full_path;
 	void *page;
+	int retry_count = 0;
 
 	xid = get_xid();
 
@@ -673,6 +674,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
 		 full_path, d_inode(direntry));
 
+again:
 	if (pTcon->posix_extensions)
 		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
 	else if (pTcon->unix_ext) {
@@ -687,6 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
+	} else if (rc == -EAGAIN && retry_count++ < 10) {
+		goto again;
 	} else if (rc == -ENOENT) {
 		cifs_set_time(direntry, jiffies);
 		newInode = NULL;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 21ef51d338e0..d241e6af8fe4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2325,6 +2325,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_rsp *qd_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
+	int retry_count = 0;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
@@ -2372,10 +2373,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	smb2_set_related(&rqst[1]);
 
+again:
 	rc = compound_send_recv(xid, tcon->ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
 
+	if (rc == -EAGAIN && retry_count++ < 10)
+		goto again;
+
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
-- 
2.31.1

