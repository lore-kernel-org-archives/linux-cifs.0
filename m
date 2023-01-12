Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06934C54EBC
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Jan 2023 13:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjALNKw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Jan 2023 08:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjALNKv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Jan 2023 08:10:51 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D268FE1D
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 05:10:45 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bq39so28384732lfb.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 05:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j7TK7cjPkED9mgcHYYDsWQwR+sPcFm37fkjp8tzp2/c=;
        b=ZcJwBlCtVzXQX41UflINIBqMvFUOr5eKYeyxZQRXjIvIcjNGVl88iJC4yHkuqZxRWk
         +HBy1Ih6NdAHs92huFsGtHvZVEwO5LuQa9jA3R7G+amwlP3fgtsOXrXf1a8h//36hRfX
         vgx4yQ5LtiLupBwz1OYIxEfSLvcBCGglnmSYAlp1B5kLJiYoVcOcepRAILLL9/MXQue1
         tshgwVBNN0KzL2CgcARfn+3qsrLgI07n0Mj3uyiY0L/aO0jU2IFGguuxHh29NKHPetWF
         SYC7ek06WfrFmhhaAYGBf3mi3qFtAL/KaKk+7FZgPFlP8fZBAXe3k+148jVWZRf+esaD
         etXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7TK7cjPkED9mgcHYYDsWQwR+sPcFm37fkjp8tzp2/c=;
        b=CksH1Cu/CgP38hWqL9IBXqfg54wRsoHRlQ0+0usiOUFK+/L+jR/cqMeHGemuurOpP2
         DHM3ezLrgnvSyAp4AWHKoQ7Dk8+xTdk97JWZLZIE+cTPvdDajc8vDecOawjapMgIv4f8
         vLi9awp3nE2prMvNsbQNSAvy5HjlgS51j8kg3epxUTYVWJZetvqFlYxq5y9JThaopZuy
         RsVKPJLr1ObHbwe7ccv8MfIp+eAZMFc0AsGCQRNLyv3YN7aNOvAQq3lQ9wEwcophnMVl
         ZMNC5HakDCoqvmlkEper3CnjjU6b6irdF/oCOES29UUHKddMtfTyx5Tk+zI3h3iY3TEc
         q1yw==
X-Gm-Message-State: AFqh2krvXqk2tFMLFlXU5+xrAEUK1T35Bea1hL/JX2kRIJ7pcUAw1xlN
        /vVso5NJpCPbmF+2NEsfl0ML1SJyvv+bwTnuBvK3v9gRTAyej3rB
X-Google-Smtp-Source: AMrXdXsX6u3yLq+vzLrEA+0EaQA2GACl7iE3OvovUVkZ5DtPCe6ZeIrNNMfOl3xX1UJ2qMsbJnqb5tlGo959aOmdz5U=
X-Received: by 2002:ac2:4c24:0:b0:4b1:4933:d0de with SMTP id
 u4-20020ac24c24000000b004b14933d0demr3136632lfq.10.1673529044084; Thu, 12 Jan
 2023 05:10:44 -0800 (PST)
MIME-Version: 1.0
References: <20230111163901.2030281-1-mmakassikis@freebox.fr> <962d5749-f541-a078-9ac1-b33a9395fd16@talpey.com>
In-Reply-To: <962d5749-f541-a078-9ac1-b33a9395fd16@talpey.com>
From:   Marios Makassikis <mmakassikis@freebox.fr>
Date:   Thu, 12 Jan 2023 14:10:32 +0100
Message-ID: <CAF6XXKWZu1SVRGVnSucEuY=JA=QLYyN0ewdndYPjGBm9gZYorA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: do not sign response to session request for guest login
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jan 12, 2023 at 3:36 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/11/2023 11:39 AM, Marios Makassikis wrote:
> > If ksmbd.mountd is configured to assign unknown users to the guest account
> > ("map to guest = bad user" in the config), ksmbd signs the response.
> >
> > This is wrong according to MS-SMB2 3.3.5.5.3:
> >     12. If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
> >     field, and Session.IsAnonymous is FALSE, the server MUST sign the
> >     final session setup response before sending it to the client, as
> >     follows:
> >      [...]
> >
> > This fixes libsmb2 based applications failing to establish a session
> > ("Wrong signature in received").
>
> I can definitely see why! The reason for requiring the SESSION_IS_GUEST
> flag to be false is because with guest there's no secret, and therefore
> no key to use for signing!
>
> But, I'd expect the code in smb3_set_sign_rsp to determine this. Before
> signing it checks the following:
>
>         if (conn->binding == false &&
>             le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
>                 signing_key = work->sess->smb3signingkey;
>         } else {
>                 read_lock(&work->sess->chann_lock);
>                 chann = lookup_chann_list(work->sess, work->conn);
>                 if (!chann) {
>                         read_unlock(&work->sess->chann_lock);
>                         return;
>                 }
>                 signing_key = chann->smb3signingkey;
>                 read_unlock(&work->sess->chann_lock);
>         }
>
>         if (!signing_key)
>                 return;
>
> So, the work->sess->smb3signingkey is obviously non-null.

smb3signingkey is a u8 array rather than a pointer, so the condition
is never true. Additionally, a signing key is always generated even
if signing is disabled.

>
> What value is being set? Addressing that seems to be the more
> general and appropriate fix here.
>
> Tom.

How about something like this ?

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ebad5008ec05..d650292739ef 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1540,7 +1540,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
         }
     }

-    if (conn->ops->generate_signingkey) {
+    if (sess->sign && conn->ops->generate_signingkey) {
         rc = conn->ops->generate_signingkey(sess, conn);
         if (rc) {
             ksmbd_debug(SMB, "SMB3 signing key generation failed\n");
@@ -1626,7 +1626,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
         }
     }

-    if (conn->ops->generate_signingkey) {
+    if (sess->sign && conn->ops->generate_signingkey) {
         retval = conn->ops->generate_signingkey(sess, conn);
         if (retval) {
             ksmbd_debug(SMB, "SMB3 signing key generation failed\n");
@@ -8423,6 +8423,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
  */
 void smb3_set_sign_rsp(struct ksmbd_work *work)
 {
+    struct ksmbd_session *sess = work->sess;
     struct ksmbd_conn *conn = work->conn;
     struct smb2_hdr *req_hdr, *hdr;
     struct channel *chann;
@@ -8432,6 +8433,9 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
     size_t len;
     char *signing_key;

+    if (!sess->sign)
+        return;
+
     hdr = smb2_get_msg(work->response_buf);
     if (work->next_smb2_rsp_hdr_off)
         hdr = ksmbd_resp_buf_next(work);
@@ -8462,9 +8466,6 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
         read_unlock(&work->sess->chann_lock);
     }

-    if (!signing_key)
-        return;
-
     if (req_hdr->NextCommand)
         hdr->NextCommand = cpu_to_le32(len);
