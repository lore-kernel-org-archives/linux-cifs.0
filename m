Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CC9C33CAF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 21:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0076F2064C
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 21:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBm1D8NK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbgAPVU7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 16:20:59 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38651 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgAPVU7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 16:20:59 -0500
Received: by mail-ot1-f65.google.com with SMTP id z9so18618827oth.5;
        Thu, 16 Jan 2020 13:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfcQ9021tMMuYp8SnnnjWWVgsxhlqB1io7+WMPi4zN4=;
        b=tBm1D8NKe+yw9V30l2d86RtxXEPBRMD7eTx02qcRq/No6wWiLNGd1eAXwdsm3DpMhs
         gtMMR/Car/rb0n4as/q9BlktPHWoh0JuJR4ofzRc0rqEhU54Gcs8Esg0qiuedD+bkmQr
         QujRv3FV7FexcxO3x5JilQ+gKnReATB+Fujk+oZ/xvnahQurgDtLKBgbV6LONCkVd4ig
         MGKsKJitywXo7KCAD+LY2GyUIv3BwpK25q4hKYzT0flgFZ0Jy0uGZbv12C7rb8SZcCQp
         1CfzN6C1T2survaj2Mw/9V3VffBJjjdHcGZEsJCH3aZKMD/rnsK4uETBWuwO8E8JLwdw
         LVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfcQ9021tMMuYp8SnnnjWWVgsxhlqB1io7+WMPi4zN4=;
        b=slG5vuwiuyMSQRZhnVK3DGAZvqn30xwG227wB4/Ft/iNXguekEakbYVGgzhhfTgLu/
         vSgjJ+Z/nZ2dnTzFUVAsP9+Iyg4orHqLGVI5nXrJKyb0lzzjSEscY9pny8YBEMVwFxmP
         wlpodn4divdPcxm6CyQyY6bIxDjtt2JQHVBjTiYisn70P4OaCZ72Ou5AIQd51c9U6iWc
         1wrcJnC6lbad40yhxXC8sXgTEo8YWpyY1cEt0hCFfBcJYLhkErcmK7jYdwvSQMVmRmYu
         Byv7QUFKrij5yts55DYkpBLQ+8SEiU0VykFGVDygsnaLDQIcIzvTH6aB3ix4SKEcNseb
         35kg==
X-Gm-Message-State: APjAAAVmSqmbDxZz6QfZgDZ10wWeH/v7CLzjvXGKnepByef7U3b1KKYm
        5e1FeLxQ96QnZKTEVXAW1OkTGSDVoJLGshtyARU=
X-Google-Smtp-Source: APXvYqxdRIuA3hdOTWNUJ9uiu6/84nXk+lZkHHVCoTYMuf1byhjPgZV+bAChh83j0s6r6CgKXqYnHARYCckR2Aq1iGo=
X-Received: by 2002:a9d:6544:: with SMTP id q4mr3745642otl.194.1579209658678;
 Thu, 16 Jan 2020 13:20:58 -0800 (PST)
MIME-Version: 1.0
References: <20191219165250.2875-1-bprotopopov@hotmail.com> <CAH2r5ms+7E8dSVb4NqgHyo927t8ynhCe_=M_1o3sHyqyO+pQFA@mail.gmail.com>
In-Reply-To: <CAH2r5ms+7E8dSVb4NqgHyo927t8ynhCe_=M_1o3sHyqyO+pQFA@mail.gmail.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Thu, 16 Jan 2020 16:20:47 -0500
Message-ID: <CAHhKpQ5jekFZMnnGpZnm23fJdzx6=JDSZrHvJDe_-2LkqsYVBg@mail.gmail.com>
Subject: Re: [PATCH] Add support for setting owner info, dos attributes, and
 create time
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, sblbir@amazon.com,
        Boris Protopopov <bprotopopov@hotmail.com>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

OK, Steve, I will look into it.

On Wed, Jan 15, 2020 at 4:18 PM Steve French <smfrench@gmail.com> wrote:
>
> lightly updated the description and merged into cifs-2.6.git for-next
>
> Boris,
> Might be helpful to add a small test (e.g. in the xfstest cifs subdir)
> for this, Ronnie had added a few small ones for automated testing that
> we use in the buildbot that are cifs specific and it is useful to
> reduce the chance of future regressions
>
> On Thu, Dec 19, 2019 at 10:53 AM Boris Protopopov
> <boris.v.protopopov@gmail.com> wrote:
> >
> > Add extended attribute "system.cifs_ntsd" (and alias "system.smb3_ntsd")
> > to allow for setting owner and DACL in the security descriptor. This is in
> > addition to the existing "system.cifs_acl" and "system.smb3_acl" attributes
> > that allow for setting DACL only. Add support for setting creation time and
> > dos attributes using set_file_info() calls to complement the existing
> > support for getting these attributes via query_path_info() calls.
> >
> > Signed-off-by: Boris Protopopov <bprotopopov@hotmail.com>
> > ---
> >  fs/cifs/xattr.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 117 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> > index 9076150758d8..c41856e6fa22 100644
> > --- a/fs/cifs/xattr.c
> > +++ b/fs/cifs/xattr.c
> > @@ -32,7 +32,8 @@
> >  #include "cifs_unicode.h"
> >
> >  #define MAX_EA_VALUE_SIZE CIFSMaxBufSize
> > -#define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
> > +#define CIFS_XATTR_CIFS_ACL "system.cifs_acl" /* DACL only */
> > +#define CIFS_XATTR_CIFS_NTSD "system.cifs_ntsd" /* owner plus DACL */
> >  #define CIFS_XATTR_ATTRIB "cifs.dosattrib"  /* full name: user.cifs.dosattrib */
> >  #define CIFS_XATTR_CREATETIME "cifs.creationtime"  /* user.cifs.creationtime */
> >  /*
> > @@ -40,12 +41,62 @@
> >   * confusing users and using the 20+ year old term 'cifs' when it is no longer
> >   * secure, replaced by SMB2 (then even more highly secure SMB3) many years ago
> >   */
> > -#define SMB3_XATTR_CIFS_ACL "system.smb3_acl"
> > +#define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
> > +#define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
> >  #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
> >  #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
> >  /* BB need to add server (Samba e.g) support for security and trusted prefix */
> >
> > -enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT };
> > +enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
> > +       XATTR_CIFS_NTSD };
> > +
> > +static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
> > +                          struct inode *inode, char *full_path,
> > +                          const void *value, size_t size)
> > +{
> > +       ssize_t rc = -EOPNOTSUPP;
> > +       __u32 *pattrib = (__u32 *)value;
> > +       __u32 attrib;
> > +       FILE_BASIC_INFO info_buf;
> > +
> > +       if ((value == NULL) || (size != sizeof(__u32)))
> > +               return -ERANGE;
> > +
> > +       memset(&info_buf, 0, sizeof(info_buf));
> > +       info_buf.Attributes = attrib = cpu_to_le32(*pattrib);
> > +
> > +       if (pTcon->ses->server->ops->set_file_info)
> > +               rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
> > +                               &info_buf, xid);
> > +       if (rc == 0)
> > +               CIFS_I(inode)->cifsAttrs = attrib;
> > +
> > +       return rc;
> > +}
> > +
> > +static int cifs_creation_time_set(unsigned int xid, struct cifs_tcon *pTcon,
> > +                                 struct inode *inode, char *full_path,
> > +                                 const void *value, size_t size)
> > +{
> > +       ssize_t rc = -EOPNOTSUPP;
> > +       __u64 *pcreation_time = (__u64 *)value;
> > +       __u64 creation_time;
> > +       FILE_BASIC_INFO info_buf;
> > +
> > +       if ((value == NULL) || (size != sizeof(__u64)))
> > +               return -ERANGE;
> > +
> > +       memset(&info_buf, 0, sizeof(info_buf));
> > +       info_buf.CreationTime = creation_time = cpu_to_le64(*pcreation_time);
> > +
> > +       if (pTcon->ses->server->ops->set_file_info)
> > +               rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
> > +                               &info_buf, xid);
> > +       if (rc == 0)
> > +               CIFS_I(inode)->createtime = creation_time;
> > +
> > +       return rc;
> > +}
> >
> >  static int cifs_xattr_set(const struct xattr_handler *handler,
> >                           struct dentry *dentry, struct inode *inode,
> > @@ -86,6 +137,23 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
> >
> >         switch (handler->flags) {
> >         case XATTR_USER:
> > +               cifs_dbg(FYI, "%s:setting user xattr %s\n", __func__, name);
> > +               if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
> > +                   (strcmp(name, SMB3_XATTR_ATTRIB) == 0)) {
> > +                       rc = cifs_attrib_set(xid, pTcon, inode, full_path,
> > +                                       value, size);
> > +                       if (rc == 0) /* force revalidate of the inode */
> > +                               CIFS_I(inode)->time = 0;
> > +                       break;
> > +               } else if ((strcmp(name, CIFS_XATTR_CREATETIME) == 0) ||
> > +                          (strcmp(name, SMB3_XATTR_CREATETIME) == 0)) {
> > +                       rc = cifs_creation_time_set(xid, pTcon, inode,
> > +                                       full_path, value, size);
> > +                       if (rc == 0) /* force revalidate of the inode */
> > +                               CIFS_I(inode)->time = 0;
> > +                       break;
> > +               }
> > +
> >                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                         goto out;
> >
> > @@ -95,7 +163,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
> >                                 cifs_sb->local_nls, cifs_sb);
> >                 break;
> >
> > -       case XATTR_CIFS_ACL: {
> > +       case XATTR_CIFS_ACL:
> > +       case XATTR_CIFS_NTSD: {
> >                 struct cifs_ntsd *pacl;
> >
> >                 if (!value)
> > @@ -106,12 +175,25 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
> >                 } else {
> >                         memcpy(pacl, value, size);
> >                         if (value &&
> > -                           pTcon->ses->server->ops->set_acl)
> > -                               rc = pTcon->ses->server->ops->set_acl(pacl,
> > -                                               size, inode,
> > -                                               full_path, CIFS_ACL_DACL);
> > -                       else
> > +                           pTcon->ses->server->ops->set_acl) {
> > +                               rc = 0;
> > +                               if (handler->flags == XATTR_CIFS_NTSD) {
> > +                                       /* set owner and DACL */
> > +                                       rc = pTcon->ses->server->ops->set_acl(
> > +                                                       pacl, size, inode,
> > +                                                       full_path,
> > +                                                       CIFS_ACL_OWNER);
> > +                               }
> > +                               if (rc == 0) {
> > +                                       /* set DACL */
> > +                                       rc = pTcon->ses->server->ops->set_acl(
> > +                                                       pacl, size, inode,
> > +                                                       full_path,
> > +                                                       CIFS_ACL_DACL);
> > +                               }
> > +                       } else {
> >                                 rc = -EOPNOTSUPP;
> > +                       }
> >                         if (rc == 0) /* force revalidate of the inode */
> >                                 CIFS_I(inode)->time = 0;
> >                         kfree(pacl);
> > @@ -179,7 +261,7 @@ static int cifs_creation_time_get(struct dentry *dentry, struct inode *inode,
> >                                   void *value, size_t size)
> >  {
> >         ssize_t rc;
> > -       __u64 * pcreatetime;
> > +       __u64 *pcreatetime;
> >
> >         rc = cifs_revalidate_dentry_attr(dentry);
> >         if (rc)
> > @@ -244,7 +326,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
> >                                 full_path, name, value, size, cifs_sb);
> >                 break;
> >
> > -       case XATTR_CIFS_ACL: {
> > +       case XATTR_CIFS_ACL:
> > +       case XATTR_CIFS_NTSD: {
> > +               /* the whole ntsd is fetched regardless */
> >                 u32 acllen;
> >                 struct cifs_ntsd *pacl;
> >
> > @@ -382,6 +466,26 @@ static const struct xattr_handler smb3_acl_xattr_handler = {
> >         .set = cifs_xattr_set,
> >  };
> >
> > +static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
> > +       .name = CIFS_XATTR_CIFS_NTSD,
> > +       .flags = XATTR_CIFS_NTSD,
> > +       .get = cifs_xattr_get,
> > +       .set = cifs_xattr_set,
> > +};
> > +
> > +/*
> > + * Although this is just an alias for the above, need to move away from
> > + * confusing users and using the 20 year old term 'cifs' when it is no
> > + * longer secure and was replaced by SMB2/SMB3 a long time ago, and
> > + * SMB3 and later are highly secure.
> > + */
> > +static const struct xattr_handler smb3_ntsd_xattr_handler = {
> > +       .name = SMB3_XATTR_CIFS_NTSD,
> > +       .flags = XATTR_CIFS_NTSD,
> > +       .get = cifs_xattr_get,
> > +       .set = cifs_xattr_set,
> > +};
> > +
> >  static const struct xattr_handler cifs_posix_acl_access_xattr_handler = {
> >         .name = XATTR_NAME_POSIX_ACL_ACCESS,
> >         .flags = XATTR_ACL_ACCESS,
> > @@ -401,6 +505,8 @@ const struct xattr_handler *cifs_xattr_handlers[] = {
> >         &cifs_os2_xattr_handler,
> >         &cifs_cifs_acl_xattr_handler,
> >         &smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
> > +       &cifs_cifs_ntsd_xattr_handler,
> > +       &smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
> >         &cifs_posix_acl_access_xattr_handler,
> >         &cifs_posix_acl_default_xattr_handler,
> >         NULL
> > --
> > 2.14.5
> >
>
>
> --
> Thanks,
>
> Steve
