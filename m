Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E93FC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14662133D
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUZmprAV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfB0TQL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:16:11 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43323 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfB0TQL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 14:16:11 -0500
Received: by mail-lj1-f196.google.com with SMTP id z20so14878440ljj.10
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 11:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vb2XI+rcxVk4GxxhTa6bVmVVPa13QwUFazNx+pzyxcI=;
        b=eUZmprAVzKBWXu9O8CQfIoPKquYcLKhV3A6dDy5Fq3ZSnak/J8aHtVqsakHnAuylRf
         ZOuGYwmqmySObBMEXWbBM+zZHR2NJvGUM+YCdSTs1cGuD7WmcfU00A49wUyyI1wsgzWV
         40fdzUI+acGprsWR+cjmRJVSyW+sDV8s4dtuDbFksq5RzK72fl0DgLpBY+dvs2wwyi1v
         7xfkRLRmUig9+3u5RVxxvsnJXgRORNSkCz+xYMLfhg1xB59sBgNRpAoyMcMo/W16XW9/
         Yqe7npWO0YELO6FC3sLCjj2XcqklWNj0GR5H9VsdX3BPFLRmqE111PQmNGYZk7kXsTDg
         8Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vb2XI+rcxVk4GxxhTa6bVmVVPa13QwUFazNx+pzyxcI=;
        b=LT95afZDQ6qECASFEyCJ76yLIxuZgm2R1R8sp40ij9OAZ/CYzgiraQejD9CejyXKW7
         sJyKonObUMjMNCw0xsM9vEGxIpi46xKsSLYGgFIYtqC13UKYda7G+CyOJn4ZIeP5bes0
         080jFMBDJxN7MnbP+v+VwZgl2VMHAftCmajNc6/ugaXFN9/1IFmbrU0YJyNJIXxaS5xM
         BCp+ARkDYslzegDrpzbAbEB4NMIcLD8sNN9rKbnQur7SduJk24bygIwJd8hpqsMEzZZa
         ZQQxYcdb4i4qoxY+FEx3yjm80IDPg9ELT+n4a2YLycNj7Ut3GWc+gYK0j2BzvyGq+gMG
         Z8Bw==
X-Gm-Message-State: APjAAAW1iphUAlj3JxgG/peq73iFyZoKx7lxMQlm8yp2mdWI2PCUAhJk
        8wFvMW26l+M4CpHtPVA51+fNM8PE9bv2evbteSbH8FI=
X-Google-Smtp-Source: APXvYqyZbFU6QalFb8x4jLkejbIgjdmzM6tyWU6/eW33PehMb9tYWd4wTm+M5gJX4A2ecFDnIFA7/AD9ftibssWKaUk=
X-Received: by 2002:a2e:124e:: with SMTP id t75mr2417214lje.23.1551294968927;
 Wed, 27 Feb 2019 11:16:08 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muZ4EQuFSsBA8FtMuj7_fbtUz+LT62bArMS0O0T=0pk0w@mail.gmail.com>
In-Reply-To: <CAH2r5muZ4EQuFSsBA8FtMuj7_fbtUz+LT62bArMS0O0T=0pk0w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Feb 2019 11:15:57 -0800
Message-ID: <CAKywueR_qigDha60n48ofOSUBKNoF3bdY_7qbdAYJa423iERUQ@mail.gmail.com>
Subject: Re: [PATCH] add dynamic trace points for compounded query/setinfo paths
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:06, Steve=
 French <smfrench@gmail.com>:
>
> Add tracepoints for enter/exit (error or done without error)
> for compounded query_info and set_info
>
> Sample output (trace-cmd record -e smb3_*compound*):
>     touch-30074 [005] .... 33989.459514: smb3_set_info_compound_enter:
> xid=3D8 sid=3D0xbe534a7e tid=3D0x82c96a43
>     touch-30074 [005] .N.. 33989.471834: smb3_set_info_compound_done:
> xid=3D8 sid=3D0xbe534a7e tid=3D0x82c96a43
>     mkdir-30076 [007] .... 33999.239926:
> smb3_query_info_compound_enter: xid=3D10 sid=3D0xbe534a7e tid=3D0x82c96a4=
3
>     mkdir-30076 [007] .... 33999.247180:
> smb3_query_info_compound_done: xid=3D10 sid=3D0xbe534a7e tid=3D0x82c96a43
>

 case SMB2_OP_RENAME:
  case SMB2_OP_RMDIR:
  case SMB2_OP_SET_EOF:
+ if (rqst[1].rq_iov)
+ SMB2_set_info_free(&rqst[1]);
+ if (rqst[2].rq_iov)
+ SMB2_close_free(&rqst[2]);
+ break;
  case SMB2_OP_SET_INFO:
  if (rqst[1].rq_iov)
  SMB2_set_info_free(&rqst[1]);
  if (rqst[2].rq_iov)
  SMB2_close_free(&rqst[2]);
+ if (rc)
+ trace_smb3_set_info_compound_err(xid, tcon->tid,
+    ses->Suid, rc);
+ else
+ trace_smb3_set_info_compound_done(xid, tcon->tid,
+    ses->Suid);
  break;
  }

This approach will require to duplicate code:

+ if (rqst[1].rq_iov)
+ SMB2_set_info_free(&rqst[1]);
+ if (rqst[2].rq_iov)
+ SMB2_close_free(&rqst[2]);
+ break;

for all set_info commands once we start tracing them.

How about to create a helper function for it? Something like:

  case SMB2_OP_RENAME:
  case SMB2_OP_RMDIR:
  case SMB2_OP_SET_EOF:
  case SMB2_OP_SET_INFO:
+    trace_set_info_compound(command, xid, tcon->tid, ses->Suid, rc);
      if (rqst[1].rq_iov)
          SMB2_set_info_free(&rqst[1]);
      if (rqst[2].rq_iov)
          SMB2_close_free(&rqst[2]);
      break;
  }

and when gradually add more trace points once we implement them.

void trace_set_info_compound(xid, tcon->tid, ses->Suid, rc)
{
    switch (command) {
/*
 * BB - add the following trace points:
 * case SMB2_OP_HARDLINK:
 * case SMB2_OP_RENAME:
 * case SMB2_OP_RMDIR:
 * case SMB2_OP_SET_EOF:
 */
    case SMB2_OP_SET_INFO:
          if (rc)
              trace_smb3_set_info_compound_err(xid, tcon->tid, ses->Suid, r=
c);
         else
              trace_smb3_set_info_compound_done(xid, tcon->tid, ses->Suid);
         break;
    }
}

--
Best regards,
Pavel Shilovsky
