Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E673CC4727C
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82136208B8
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgnDM58T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgI2RIS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2RIS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Sep 2020 13:08:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD239C061755
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:08:17 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v60so4148619ybi.10
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xI0BuAK+U0cN8XReY9WHEesp5MjH5D5qb4yhis/59bI=;
        b=fgnDM58T0XoGIGgfaV7pEmitlbpljta+/sPeAesk4LvdySjG3IUhsb1DXSdyZCKUvG
         1H4XtBBCpM+cFnLZ7TD2Vgb7ePcyHvU0A44uZszpcPaH+BrHA6zlJa88S7hpuV5r6NWO
         wrjQ55943eEoVSymzR/9SbUmYKsrKYxVK7EjSMfnx1GWKQH9dgkmRmnriuBHgDdCOOy7
         MHQLOKBABtdi3b3/NJSZ4fBHN0UuGxoVmeyw+vJdHmjl+VD76moxJxxQyQe4p26kIpBF
         d8iNAz5dhwVYkVwJh46ri04lhlYsyixgIYOouSMOdk0C+V+o3RDqha6S06MCWqpAcaCO
         Stdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=xI0BuAK+U0cN8XReY9WHEesp5MjH5D5qb4yhis/59bI=;
        b=O4SQR88RbocvIS/BDYVCnypXXmKeqb3h0FOLysltjkH+pO1Gk2/LQ95hcAsffzDiB3
         RkK3RUuReFsIYGcZBg8LNYNR7BSMSaMiaXWqGVkBMu0DI3GiYw7boaKL+Z5nx7J6Ud5f
         q3k4seKM54cpQC4+v/cINN5ItyGvPwqwWcRTK1rB7HSZQSexDoQM+fBV65L3KxzefZA6
         f5CZThQ4oiobtzWshqdoUbWASWlYb7XT3X4F98LVD9OmbUkxwTpHKQTa3fA7JmsVUanL
         gnRruKz9gdzOvlfh8jJuipqHx/hZKFxt7JA/YIqHLASS/TSQd+8DtUQqngdYBniMcrvt
         h7JA==
X-Gm-Message-State: AOAM533MwrXaP5daMzwrP/0ZOZAwjREfofW4afTqlhgkyXm9sCN97Ta9
        e12iUqV25eMyR6aXyGscIEQ8Hr/Sp1KzdwfrXJkSHFUn7C0jGg==
X-Google-Smtp-Source: ABdhPJwkwuivPLeigPMvLnKfuTK4h+qaHPiaTYhc4PqG9v8rKuJM9W8CNtcFl8aXffsTz9599Emm/lpO25vjPPMn8Gk=
X-Received: by 2002:a25:d848:: with SMTP id p69mr7383065ybg.414.1601399297095;
 Tue, 29 Sep 2020 10:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200924003638.2668-1-pboris@amazon.com>
In-Reply-To: <20200924003638.2668-1-pboris@amazon.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Tue, 29 Sep 2020 13:08:06 -0400
Message-ID: <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
Subject: Fwd: [PATCH] Convert trailing spaces and periods in path components
To:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Testing:

Prior to the patch:

% mount -v
=E2=80=A6
//host/share/home on /tmp/diry type cifs (rw,relatime,vers=3Ddefault,...
% ls -l /tmp/diry/tmp
total 0
% mkdir /tmp/diry/tmp/DirWithTrailingDot.
% ls -l  /tmp/diry/tmp/DirWithTrailingDot.
total 0
% touch  /tmp/diry/tmp/DirWithTrailingDot./file
touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingDot./file=E2=80=
=99: No such
file or directory
% mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
mkdir: cannot create directory
=E2=80=98/tmp/diry/tmp/DirWithTrailingDot./dir=E2=80=99: No such file or di=
rectory
% find  /tmp/diry/tmp/DirWithTrailingDot.
/tmp/diry/tmp/DirWithTrailingDot.
% find  /tmp/diry/tmp/DirWithTrailingSpace\
find: `/tmp/diry/tmp/DirWithTrailingSpace ': No such file or directory
% mkdir  /tmp/diry/tmp/DirWithTrailingSpace\
% ls -l  /tmp/diry/tmp/DirWithTrailingSpace\
total 0
% touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingSpace /file=E2=80=
=99: No
such file or directory
% mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
mkdir: cannot create directory =E2=80=98/tmp/diry/tmp/DirWithTrailingSpace
/dir=E2=80=99: No such file or directory

After the patch:

% umount /tmp/diry
% modprobe -r cifs
# load the fix
% modprobe cifs
% mount -t cifs -o...  //host/share/home /tmp/diry
...
% mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
% touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
% mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
% touch  /tmp/diry/tmp/DirWithTrailingDot./file
% find  /tmp/diry/tmp/
/tmp/diry/tmp/
/tmp/diry/tmp/DirWithTrailingDot.
/tmp/diry/tmp/DirWithTrailingDot./dir
/tmp/diry/tmp/DirWithTrailingDot./file
/tmp/diry/tmp/DirWithTrailingSpace
/tmp/diry/tmp/DirWithTrailingSpace /dir
/tmp/diry/tmp/DirWithTrailingSpace /file
% rm -rf /tmp/diry/tmp/*
% find  /tmp/diry/tmp/
/tmp/diry/tmp/

---------- Forwarded message ---------
From: Boris Protopopov <pboris@amazon.com>
Date: Wed, Sep 23, 2020 at 8:39 PM
Subject: [PATCH] Convert trailing spaces and periods in path components
To:
Cc: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
Boris Protopopov <pboris@amazon.com>


When converting trailing spaces and periods in paths, do so
for every component of the path, not just the last component.
If the conversion is not done for every path component, then
subsequent operations in directories with trailing spaces or
periods (e.g. create(), mkdir()) will fail with ENOENT. This
is because on the server, the directory will have a special
symbol in its name, and the client needs to provide the same.

Signed-off-by: Boris Protopopov <pboris@amazon.com>
---
 fs/cifs/cifs_unicode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 498777d859eb..9bd03a231032 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char
*source, int srclen,
                else if (map_chars =3D=3D SFM_MAP_UNI_RSVD) {
                        bool end_of_string;

-                       if (i =3D=3D srclen - 1)
+                       /**
+                        * Remap spaces and periods found at the end of eve=
ry
+                        * component of the path. The special cases of '.' =
and
+                        * '..' do not need to be dealt with explicitly bec=
ause
+                        * they are addressed in namei.c:link_path_walk().
+                        **/
+                       if ((i =3D=3D srclen - 1) || (source[i+1] =3D=3D '\=
\'))
                                end_of_string =3D true;
                        else
                                end_of_string =3D false;
--
2.18.4
