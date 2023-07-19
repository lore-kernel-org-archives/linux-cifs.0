Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B66EB64DA
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jul 2023 04:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjGSEhi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jul 2023 00:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjGSEhc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jul 2023 00:37:32 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1494B1993
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jul 2023 21:37:26 -0700 (PDT)
X-QQ-mid: bizesmtp77t1689741440ti5lsa2m
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Jul 2023 12:37:19 +0800 (CST)
X-QQ-SSF: 00400000000000F0H000000A0000000
X-QQ-FEAT: znfcQSa1hKYr3mJKQfoAB4ekI+yqKYmnbcgLhuU5/zCiZt6lbtGZmmyeoUhIf
        miy402ZkCzpb6AjIZm9zCiC6hyzz+I1ZLtXaNRSTlOAE52dJ1e6D2bbM+t5kPCBpGblL7Ie
        8e73KePJro3wsCP074ANHtQHQFfzxEBab/edyIjyK3bRX/dhKBfLuIOm47PbaT/elbCrMQY
        VS4Q97PvPTnl8B6hCeu2wNdTZOJtoq2KFca5vaZXdJAFGNOBRZ6d1r4BI/KnRFlzhgovscQ
        y6XnHRFJv4UFLVw6HnKEscZe95F+jPRXybU4sSlexMsRMGMNUlMHBqTN8hMZa8YPiS3k4Ny
        4jbQnwaYmvNJIDU7hQrrPiOiFypyWWFbYe4EhO7dx6t+lW7FPRwnwtkEf3Mo93LJdtQ/l37
        Rlp4S2z5LccMSqMEbb315w==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12093927619504151750
Date:   Wed, 19 Jul 2023 12:37:18 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH v2] cifs: fix charset issue in reconnection
Message-ID: <85303B7FD04FCF15+20230719123718.49f95d54@winn-pc>
In-Reply-To: <20230719123117.692feb89@winn-pc>
References: <20230718012437.1841868-1-wentao@uniontech.com>
        <CAH2r5mvPXwc4H_7bkcF_oqedLrKTSv4GKBhYkpYC9=H==d-G3g@mail.gmail.com>
        <20230719123117.692feb89@winn-pc>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+P.SM/3bH9vn+G1guFgAe5m"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--MP_/+P.SM/3bH9vn+G1guFgAe5m
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 19 Jul 2023 12:31:17 +0800
Winston Wen <wentao@uniontech.com> wrote:

> On Tue, 18 Jul 2023 10:42:27 -0500
> Steve French <smfrench@gmail.com> wrote:
>=20
> > I get compile warning:
> >=20
> > /home/smfrench/cifs-2.6/fs/smb/client/connect.c: In function
> > =E2=80=98cifs_get_smb_ses=E2=80=99:
> > /home/smfrench/cifs-2.6/fs/smb/client/connect.c:2293:49: warning:
> > passing argument 1 of =E2=80=98load_nls=E2=80=99 discards =E2=80=98cons=
t=E2=80=99 qualifier from
> > pointer target type [-Wdiscarded-qualifiers]
>=20
>=20
> >  2293 |         ses->local_nls =3D load_nls(ctx->local_nls->charset);
>=20
> Hi Steve,
>=20
> Sorry about the mistake I made. I updated the patch with a very small
> change:
>=20
> 	ses->local_nls =3D load_nls((char *)ctx->local_nls->charset);
>=20
> It works, but I'm not sure whether it's clean enough.=20
>=20
> Perhaps I should make a change to load_nls() to take a const char *
> instead of char *? If this make sense, I'll do it soon.
>=20
> Find the updated patch as attachment.
>=20

Sorry I picked the wrong version, updated.


--=20
Thanks,
Winston

--MP_/+P.SM/3bH9vn+G1guFgAe5m
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-cifs-fix-charset-issue-in-reconnection.patch

From f63be0e643f59a2dee119c3cf996f02b79b5e73c Mon Sep 17 00:00:00 2001
From: Winston Wen <wentao@uniontech.com>
Date: Mon, 17 Jul 2023 08:51:50 +0800
Subject: [PATCH] cifs: fix charset issue in reconnection

We need to specify charset, like "iocharset=utf-8", in mount options for
Chinese path if the nls_default don't support it, such as iso8859-1, the
default value for CONFIG_NLS_DEFAULT.

But now in reconnection the nls_default is used, instead of the one we
specified and used in mount, and this can lead to mount failure.

Signed-off-by: Winston Wen <wentao@uniontech.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifssmb.c  | 3 +--
 fs/smb/client/connect.c  | 5 +++++
 fs/smb/client/misc.c     | 1 +
 fs/smb/client/smb2pdu.c  | 3 +--
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index c9a87d0123ce..31cadf9b2a98 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1062,6 +1062,7 @@ struct cifs_ses {
 	unsigned long chans_need_reconnect;
 	/* ========= end: protected by chan_lock ======== */
 	struct cifs_ses *dfs_root_ses;
+	struct nls_table *local_nls;
 };
 
 static inline bool
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9dee267f1893..25503f1a4fd2 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -129,7 +129,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&server->srv_lock);
 
-	nls_codepage = load_nls_default();
+	nls_codepage = ses->local_nls;
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -200,7 +200,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		rc = -EAGAIN;
 	}
 
-	unload_nls(nls_codepage);
 	return rc;
 }
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5dd09c6d762e..7efae6f6f3b0 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1842,6 +1842,10 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			    CIFS_MAX_PASSWORD_LEN))
 			return 0;
 	}
+
+	if (strcmp(ctx->local_nls->charset, ses->local_nls->charset))
+		return 0;
+
 	return 1;
 }
 
@@ -2286,6 +2290,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	ses->sectype = ctx->sectype;
 	ses->sign = ctx->sign;
+	ses->local_nls = load_nls((char *)ctx->local_nls->charset);
 
 	/* add server as first channel */
 	spin_lock(&ses->chan_lock);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 70dbfe6584f9..d7e85d9a2655 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -95,6 +95,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 		return;
 	}
 
+	unload_nls(buf_to_free->local_nls);
 	atomic_dec(&sesInfoAllocCount);
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e04766fe6f80..a457f07f820d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -242,7 +242,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 	spin_unlock(&server->srv_lock);
 
-	nls_codepage = load_nls_default();
+	nls_codepage = ses->local_nls;
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -324,7 +324,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		rc = -EAGAIN;
 	}
 failed:
-	unload_nls(nls_codepage);
 	return rc;
 }
 
-- 
2.40.1


--MP_/+P.SM/3bH9vn+G1guFgAe5m--
