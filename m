Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC10AC432BE
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 10:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A272560F35
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 10:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhHQK2Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Aug 2021 06:28:16 -0400
Received: from mout.gmx.net ([212.227.17.22]:50947 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234093AbhHQK2P (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 17 Aug 2021 06:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1629196057;
        bh=I2J2SW/R8983FRWI3iQ+XXno6bttiS2cd9W3FEmVODw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=bpb7+uQteNcPrcP4RhqayGCqYbsPPa7ddU+X99U3lcAvArOlVlsI7pnwpAgnY4bY2
         lXNt/h/2q8WdyDgDj4gnaqqc91X1bca6BOYY/WPskrMD1KSBmTz8mlnrDH2GXmWIEf
         m58+83sW7pxEKbogDm578Rhd2Ua34sQmwzFd853A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx105 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1Mo6qp-1mqPnW2Fpr-00pcK2; Tue, 17 Aug 2021 12:27:37 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Steve French <sfrench@samba.org>, Jeff Layton <jlayton@kernel.org>,
        Suresh Jayaraman <sjayaraman@suse.de>
Cc:     Len Baker <len.baker@gmx.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH] CIFS: Fix a potencially linear read overflow
Date:   Tue, 17 Aug 2021 12:27:09 +0200
Message-Id: <20210817102709.15046-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3ZNYzJz5JHvN/PlriY02eWKfty6IRLAMJHJuFNlhqOGp2xwU0Kv
 sFsQ+QVlO8KjkZPRaqBrlrc9SJ+F4dMPHr1fP2XfTS5kak7Aaf6CHfShaqGwMFa7wRY+bmL
 L3cpvZAwgcOrmHtJBWtbQqimRrDPhCZrTmmeMZ4bFOZLakbE6T1IEYToQYyPhz0tkWVJHCH
 EY3zam0ab3XmAaKIIJYPA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CDCgeYTjVHs=:cYULzbo81kmMsPAddqFNl/
 bK3J4Oa0NxrqhGWf0BjCfSn5afm/dZONbQqC0SiCc71TUz2ebB+amK8N5FRPeAeilFK2bctEq
 ywfKpSji1HgxLwJoZoogrp4iGs5b8irdfJ2jsSevGCeiOSA+7TQyyY+c9bB2hP6XvTvB7cuKE
 dsxry5taq0VYSaEc9zoMszYQMAetBWWOSJjc+AMiSurweWF4QdUa4fLQogkoPqRDzNXOA+Ej6
 RX0rTepJXaHZNN/EG82MrCYuoXLmR9KGylxoq1KKzuicu7IjfSHXnDwSlBfWiWUcch8gWOjx7
 ttRfgWe6t5By3xj13AZAo9RgNX3pZ9+DReOvFoEkyI6ljKZSUxSaWpA5j2FWh2U/ebd+dBLxl
 IC2ZkqbnfDaZtiWkPoulpTxTlH3Vg2mYMFqwgUyk5xcjV2y8eMftI9bED1QOqmMa/HSWExEb0
 XsjgsuF1FtC+Y6AOa7OJGrtqrOFfgamYQW/NYJX0OEW1ngJPxzLh/0+EjG7oIIi9OU6R9aMhz
 Eggs1plfGZQ/t8GIl9Lts3ADd8JRGP4vImUsuRJOdDjGwT5jGTy29wmZgH1KG5PAMI5pgaLm+
 ybdmoJKrlnyh0pU2kZuVQIkgLr+11pv0v/O1GWTiiXwTDC/QyP20Ccqq0oR2jgVMSrdi3CCwe
 mi40JeI5yk54pdYzpUlh5nGD2n5zhSDIIsblXvCWGCQuSNTVDLsB8nU4BU33DcV9WvgwS079I
 QR3TagPcNexZ8U2KVTtX1vJ4kvuCPzwsYjgnwZH6+sERBex2WWjA04XoL7mcmeMViBMMh4n4+
 SGadaTV5vIjVPIBiw38p7Sb9h9NNgwo1g0IGmIOCJyULmBfQhccwBPywgnKKJXn0aiY8By0PX
 Ta0lf+jpXVla4nt/gMuPoUywLtPgOMR2780r0m/U4nFOdgZBGdeurS4Qt7covPr6MTl5hGWab
 pUc9IqeG0sD9WuKzI4Aw3N+eQXnx1Gc1pm4VVeK0xRNbq9daVBJQyVc9RScNc7V9EwKUF8kDZ
 j/816yUJl2u/TIYqNtRiEZE2nIP9ZpXz/TvZTpjsQqyXKAGWEihIAitiKFA8DtoYI/m3apJPu
 orcDx0WKVtbBUfUiKWnh/TFVt2x4yl98rkYbqhAzgvTYwLtHYD9ekSmng==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

strlcpy() reads the entire source buffer first. This read may exceed the
destination size limit. This is both inefficient and can lead to linear
read overflows if a source string is not NUL-terminated.

Also, the strnlen() call does not avoid the read overflow in the strlcpy
function when a not NUL-terminated string is passed.

So, replace this block by a call to kstrndup() that avoids this type of
overflow and does the same.

Fixes: 066ce6899484d ("cifs: rename cifs_strlcpy_to_host and make it use n=
ew functions")
Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 fs/cifs/cifs_unicode.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9bd03a231032..171ad8b42107 100644
=2D-- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -358,14 +358,9 @@ cifs_strndup_from_utf16(const char *src, const int ma=
xlen,
 		if (!dst)
 			return NULL;
 		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
-			       NO_MAP_UNI_RSVD);
+				NO_MAP_UNI_RSVD);
 	} else {
-		len =3D strnlen(src, maxlen);
-		len++;
-		dst =3D kmalloc(len, GFP_KERNEL);
-		if (!dst)
-			return NULL;
-		strlcpy(dst, src, len);
+		dst =3D kstrndup(src, maxlen, GFP_KERNEL);
 	}

 	return dst;
=2D-
2.25.1

