Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FB1C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 08:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CB22068E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 08:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ab5kjFCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUIOE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 03:14:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbfKUIOD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 03:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574324042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aIc45YtwjVnCd1V0W4dMVGSG0LjRYFCWzH1IueibHyw=;
        b=ab5kjFCNBQV1o+RE1+JBoMdT+qsqd/r/e9Fzx+/4tDxkt+57hZsN5sVqH1LD5KfN/DC+Mv
        8VBy+88QMPlDaKpVj1CP+M37aRxNfs61sM5Dh/adDJ5356ZNSPaAyToGXDadD92IzhmGbm
        1ptfRPRie1+wP9iB4GqV5mctESoIzKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-xusxswHsNzO8F9tJsU1n_w-1; Thu, 21 Nov 2019 03:14:01 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 075F9801E5D;
        Thu, 21 Nov 2019 08:14:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-161.rdu2.redhat.com [10.10.120.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C9276CE54;
        Thu, 21 Nov 2019 08:13:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] cifs: Don't use iov_iter::type directly
From:   David Howells <dhowells@redhat.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date:   Thu, 21 Nov 2019 08:13:58 +0000
Message-ID: <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: xusxswHsNzO8F9tJsU1n_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Don't use iov_iter::type directly, but rather use the new accessor
functions that have been added.  This allows the .type field to be split
and rearranged without the need to update the filesystems.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cifs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa7b0fa72bb3..526f2b95332d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2833,7 +2833,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struc=
t iov_iter *from,
 =09=09=09=09=09"direct_writev couldn't get user pages "
 =09=09=09=09=09"(rc=3D%zd) iter type %d iov_offset %zd "
 =09=09=09=09=09"count %zd\n",
-=09=09=09=09=09result, from->type,
+=09=09=09=09=09result, iov_iter_type(from),
 =09=09=09=09=09from->iov_offset, from->count);
 =09=09=09=09dump_stack();
=20
@@ -3044,7 +3044,7 @@ static ssize_t __cifs_writev(
 =09 * In this case, fall back to non-direct write function.
 =09 * this could be improved by getting pages directly in ITER_KVEC
 =09 */
-=09if (direct && from->type & ITER_KVEC) {
+=09if (direct && iov_iter_is_kvec(from)) {
 =09=09cifs_dbg(FYI, "use non-direct cifs_writev for kvec I/O\n");
 =09=09direct =3D false;
 =09}
@@ -3556,7 +3556,7 @@ cifs_send_async_read(loff_t offset, size_t len, struc=
t cifsFileInfo *open_file,
 =09=09=09=09=09"couldn't get user pages (rc=3D%zd)"
 =09=09=09=09=09" iter type %d"
 =09=09=09=09=09" iov_offset %zd count %zd\n",
-=09=09=09=09=09result, direct_iov.type,
+=09=09=09=09=09result, iov_iter_type(&direct_iov),
 =09=09=09=09=09direct_iov.iov_offset,
 =09=09=09=09=09direct_iov.count);
 =09=09=09=09dump_stack();
@@ -3767,7 +3767,7 @@ static ssize_t __cifs_readv(
 =09 * fall back to data copy read path
 =09 * this could be improved by getting pages directly in ITER_KVEC
 =09 */
-=09if (direct && to->type & ITER_KVEC) {
+=09if (direct && iov_iter_is_kvec(to)) {
 =09=09cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
 =09=09direct =3D false;
 =09}

