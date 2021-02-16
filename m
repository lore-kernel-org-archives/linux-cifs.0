Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F97C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 18:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E9A64D73
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 18:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBPSij (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 13:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhBPSie (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 13:38:34 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E8DC061574
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 10:37:54 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id y26so18093580eju.13
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 10:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nzL+phVSDYeQWeVHvoGULeqFMdtTDm6JAuBhnAFEhX4=;
        b=cvLsjrZ+oZb3ZoAMZD3p8gab24gTW4Lf4uMjhex722KeS/FC+AOOmgT1+D/IeTANXF
         rNymC7C222vfh3r5AKEcVszLjwHzV/nIBJVhNjQSmpodXDA6mwFoxmShl5vI1IwnNzAq
         +eaGp4b3x48spugXp6IJuSC184cjMMxhCALOQzc+auYZdmUxKIf0/0W5wtlaesG+FJtc
         1n62SQOUCh2A2KLi14fJnkEkp45X7OGl4sZTDbCCFvXVmgh3W/U1N6pb3RmNzRcU2vLN
         Wtno8hnOg2xjFa0CvWZQA0P6Hm6dcnYsQdJL7EBTDN3VTDrOcb+ajpNt9rQymjqTFeUL
         SsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nzL+phVSDYeQWeVHvoGULeqFMdtTDm6JAuBhnAFEhX4=;
        b=K892Dzyn+Ewph0xYKwI+kOHGzWalkHonBNdwqA31iQXN2DbOXbrAtQiJCUx+5i9TLM
         f6nEeCi5bkgbHIqZE8U8oO1yl3DeJc3Mf1WmCd2IZRNXLtIgQjfWoo5SW5vSHRamZFUQ
         IS0k8Z2SarctY//Oo8Ce3BfwGsuIp3KYD/WuTBsqHr3BioaYqGsf7V2MOyo613fTE+Tk
         VWM8ieNtqqtuGQKEGEwGoZN69gx3QMyiRoMKGLM+QmQoZ4/I9QUoiqekVWAXURlNkGJu
         SGVuWL65oQDGeQ1R0Tse/MT63CKWfC5cmSqZPy5GSlDjZ/P2myHU/pFpKp46uCAWtR5Z
         G9uQ==
X-Gm-Message-State: AOAM531cc+9Xv2rvZCdPtI1R36YLKfmj6ddfynb+SbLLTIt3jsdU0t9E
        ISAbgH9bw/h2JSLVXM/8sIpI7QpjZFt5C3beig==
X-Google-Smtp-Source: ABdhPJwyaupAYfukKZmvYYtYevwoLHNk0LwCqZRr7A2wVdNB/iEtIt2SRRizTSk/DMd91iHvy8S1FkFHPteGsafC8pw=
X-Received: by 2002:a17:906:90d9:: with SMTP id v25mr19683125ejw.271.1613500672927;
 Tue, 16 Feb 2021 10:37:52 -0800 (PST)
MIME-Version: 1.0
References: <1A318EB9-A257-4A11-B319-EA3F2628C8B7@hxcore.ol>
In-Reply-To: <1A318EB9-A257-4A11-B319-EA3F2628C8B7@hxcore.ol>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 16 Feb 2021 10:37:41 -0800
Message-ID: <CAKywueROT6yAn6Eer4sncxsaZZyih3kApKmLacb3xsxDJfWfMQ@mail.gmail.com>
Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
To:     Rohith <rohiths.msft@gmail.com>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "sribhat.msa@outlook.com" <sribhat.msa@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50fcb65920e8..fe99fb7307b2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -504,6 +504,8 @@ struct smb_version_operations {
  loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
  /* Check for STATUS_IO_TIMEOUT */
  bool (*is_status_io_timeout)(char *buf);
+ /* Check for STATUS_NETWORK_NAME_DELETED */
+ void (*mark_tcon_reconnect) (char *buf, struct TCP_Server_Info *);
              ^^^
Let's follow the above style and name it

is_network_name_deleted()

 };

 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 10fe6d6d2dee..d4ffe2564e07 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -993,6 +993,8 @@ cifs_demultiplex_thread(void *p)
  if (mids[i] !=3D NULL) {
  mids[i]->resp_buf_size =3D server->pdu_size;

+ server->ops->mark_tcon_reconnect(bufs[i],
+                  server);

How about SMB1? It doesn't have the callback, so it may fail here.

Btw, I think is_status_io timeout should be called in this loop for
every mid not outside the loop (sorry, missed that in the original
review). Could you please fix that separately?


  if (!mids[i]->multiRsp || mids[i]->multiEnd)
  mids[i]->callback(mids[i]);

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f19274857292..23d238c0017a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2418,6 +2418,37 @@ smb2_is_status_io_timeout(char *buf)
  return false;
 }

+static void
+smb2_mark_tcon_reconnect(char *buf, struct TCP_Server_Info *server)
+{
+ struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)buf;
+ struct list_head *tmp, *tmp1;
+ struct cifs_ses *ses;
+ struct cifs_tcon *tcon;
+ bool   find_tcon =3D false;
+
+ spin_lock(&cifs_tcp_ses_lock);
+ list_for_each(tmp, &server->smb_ses_list) {

Why looking for the TCON if in most cases Status is not
STATUS_NETWORK_NAME_DELETED?
If it is not, then the function should become a no-op and exit immediately.

+ ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
+ list_for_each(tmp1, &ses->tcon_list) {
+ tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
+ if (tcon->tid =3D=3D shdr->TreeId) {
+ find_tcon =3D true;
+ spin_unlock(&cifs_tcp_ses_lock);
+ goto reconnect;
+ }
+ }
+ }
+ spin_unlock(&cifs_tcp_ses_lock);
+
+reconnect:
+ if (find_tcon && (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED)) {
+ tcon->need_reconnect =3D true;

this should happen under the locks - there is no guarantee that tcon
is still valid outside the loop unless you take a reference which is
not needed here.


+ pr_warn_once("Server share %s deleted.\n",
+      tcon->treeName);

so, just printing logs should happen outside the locks.

+ }
+}
+
 static int
 smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
       struct cifsInodeInfo *cinode)
@@ -4605,6 +4636,8 @@ static void smb2_decrypt_offload(struct work_struct *=
work)
 #ifdef CONFIG_CIFS_STATS2
  mid->when_received =3D jiffies;
 #endif
+ dw->server->ops->mark_tcon_reconnect(dw->buf,
+                      dw->server);
  mid->callback(mid);
  } else {
  spin_lock(&GlobalMid_Lock);
@@ -5072,6 +5105,7 @@ struct smb_version_operations smb20_operations =3D {
  .fiemap =3D smb3_fiemap,
  .llseek =3D smb3_llseek,
  .is_status_io_timeout =3D smb2_is_status_io_timeout,
+ .mark_tcon_reconnect =3D smb2_mark_tcon_reconnect,
 };

 struct smb_version_operations smb21_operations =3D {
@@ -5173,6 +5207,7 @@ struct smb_version_operations smb21_operations =3D {
  .fiemap =3D smb3_fiemap,
  .llseek =3D smb3_llseek,
  .is_status_io_timeout =3D smb2_is_status_io_timeout,
+ .mark_tcon_reconnect =3D smb2_mark_tcon_reconnect,
 };

 struct smb_version_operations smb30_operations =3D {
@@ -5286,6 +5321,7 @@ struct smb_version_operations smb30_operations =3D {
  .fiemap =3D smb3_fiemap,
  .llseek =3D smb3_llseek,
  .is_status_io_timeout =3D smb2_is_status_io_timeout,
+ .mark_tcon_reconnect =3D smb2_mark_tcon_reconnect,
 };

 struct smb_version_operations smb311_operations =3D {
@@ -5399,6 +5435,7 @@ struct smb_version_operations smb311_operations =3D {
  .fiemap =3D smb3_fiemap,
  .llseek =3D smb3_llseek,
  .is_status_io_timeout =3D smb2_is_status_io_timeout,
+ .mark_tcon_reconnect =3D smb2_mark_tcon_reconnect,
 };

 struct smb_version_values smb20_values =3D {
--=20
2.25.1

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 16 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 02:54, Rohit=
h <rohiths.msft@gmail.com>:
>
> Hi All,
>
>
>
> During migration or soft delete/undelete, Application doing recursive IO=
=E2=80=99s will fail until tcon is reconnected or session is established ag=
ain.
>
>
>
> Attached patch addresses above mentioned issue. So, applications will rec=
over automatically once share is undeleted.
>
>
>
> Regards,
>
> Rohith
>
>
>
> Sent from Mail for Windows 10
>
>
