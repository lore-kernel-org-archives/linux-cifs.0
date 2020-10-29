Return-Path: <SRS0=/3sc=EE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BED1C4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Oct 2020 15:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36B5207DE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Oct 2020 15:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHfBuD5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgJ2Pnd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgJ2Pnd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Oct 2020 11:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603986212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=YaXyyA+3brfqc67uOQpcnXMgyyRvDxRCA0pUcywHw6k=;
        b=FHfBuD5ZYlQ4yZxYAYrq+4dfrGeu94RFyTOGqHxODq25mefjJqvGsn2Ub2kbTCRpHQXeCG
        Rryc6m/xe4LaatnmN4iV+Dd+TXfyHV3iCZQ+MT7NTUBmy7MZpwQIEUug+pp0AdNF/1Rxm2
        wEkxoGg7TdPyYuf5/8ANwnSQaPtv5Ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-wH1PFSzwNku7SY1hQxDGYw-1; Thu, 29 Oct 2020 11:43:25 -0400
X-MC-Unique: wH1PFSzwNku7SY1hQxDGYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B79C21009E47;
        Thu, 29 Oct 2020 15:43:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF3035E9D0;
        Thu, 29 Oct 2020 15:43:23 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F027181A86E;
        Thu, 29 Oct 2020 15:43:23 +0000 (UTC)
Date:   Thu, 29 Oct 2020 11:43:23 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     jra@samba.org, Ronnie Sahlberg <lsahlber@redhat.com>
Message-ID: <1397349053.55438877.1603986203418.JavaMail.zimbra@redhat.com>
In-Reply-To: <20262379.55437477.1603985286601.JavaMail.zimbra@redhat.com>
Subject: can't start smbd after install samba posix branch
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.28]
Thread-Topic: can't start smbd after install samba posix branch
Thread-Index: 5T2Pn1PSLXHmz+QEHgU8A/mvgWMIMQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello folks,

I try to install samba posix branch in RHEL8. But failed to start smbd daemon.
Does anyone know the reason? or what else do I miss?

#git clone git://git.samba.org/jra/samba
#git check -b posix remotes/origin/master-smb2
#./configure --prefix=/usr --enable-fhs
#make -j6
#make install
#smbd -D
# echo $?
1
# smbd -D -d 10
INFO: Current debug levels:
  all: 10
  tdb: 10
  printdrivers: 10
  lanman: 10
  smb: 10
  rpc_parse: 10
  rpc_srv: 10
  rpc_cli: 10
  passdb: 10
  sam: 10
  auth: 10
  winbind: 10
  vfs: 10
  idmap: 10
  quota: 10
  acls: 10
  locking: 10
  msdfs: 10
  dmapi: 10
  registry: 10
  scavenger: 10
  dns: 10
  ldb: 10
  tevent: 10
  auth_audit: 10
  auth_json_audit: 10
  kerberos: 10
  drs_repl: 10
  smb2: 10
  smb2_credits: 10
  dsdb_audit: 10
  dsdb_json_audit: 10
  dsdb_password_audit: 10
  dsdb_password_json_audit: 10
  dsdb_transaction_audit: 10
  dsdb_transaction_json_audit: 10
  dsdb_group_audit: 10
  dsdb_group_json_audit: 10
[root@hp-dl360g9-12 ~]# echo $?
1

I don't find any usefull log. Then I use systemd to start smbd services. Show this error:
-- Unit smb.service has begun starting up.
Oct 29 11:36:47 hp-dl360g9-12.rhts.eng.pek2.redhat.com systemd[1]: smb.service: Main process exited, code=exited, status=1/FAILURE
Oct 29 11:36:47 hp-dl360g9-12.rhts.eng.pek2.redhat.com systemd[1]: smb.service: Failed with result 'exit-code'.
-- Subject: Unit failed
-- Defined-By: systemd
-- Support: https://access.redhat.com/support
-- 
-- The unit smb.service has entered the 'failed' state with result 'exit-code'.
Oct 29 11:36:47 hp-dl360g9-12.rhts.eng.pek2.redhat.com systemd[1]: Failed to start Samba SMB Daemon.
-- Subject: Unit smb.service has failed



Thanks.



