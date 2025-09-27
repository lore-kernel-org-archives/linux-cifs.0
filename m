Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F91B6CE9
	for <linux-cifs@vger.kernel.org>; Sat, 27 Sep 2025 01:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758935026; cv=none; b=r8Xg98Z98bKPtfZ+Fy3Vo+v+0nXO4V+oBzyJNb9TIfTIBIZxPM8VzeTFxTKJuD9etM+XJNNHFzCYU8QxPfzrg3oGJbC1pmQ82RF+XRM6wPbfnb+A2s1ql4VdZbY2yqpvWwfBP9O0vA+4krqUziR2ZkjB+0gVkjTeRYp5qZkdudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758935026; c=relaxed/simple;
	bh=crbJxPG7sUC9+ThropvW1wdYvXCkNdAGEkzpoGAspaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=isFlvvHt7aIX6gPk4/1LM/+Gq8jN0drtOCHH0NCMFYQQP8o3fL4UDW1FbTqSohTVBDazJMvDL9H8o7yE5RE5hdv0aWrGKRv4bcLy1fY+EmTMghzFYGaGjAbfzDpQqQL54PwSP0iiQ+/Mhlr/jc9+jguJzS1JfuuyeMnmXK/r+Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvx/ZwwZ; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvx/ZwwZ"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-36e4d00ebfdso576812fac.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Sep 2025 18:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758935023; x=1759539823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rClUBrjl/Oh1tHtmby04uMrH9jeyFYSGvihqed2N4FY=;
        b=jvx/ZwwZkhu4dTM/jq8clGbGcrgf58x15uhpPj0sEQ8rPlulLh69gT2Y2twkf//FNV
         7WxpFgG6jqdWC1dVJe1oSKDTUIEHz6uA0TJqto2ou3RFrNx0lXClJNPTgy/Koa0Uh/Ri
         KN94F9smhg65oFgU6n9LNqCZHk7DSdhKm8mrcwyXHycjnQdEwhM+o7YsPGQU36J5FqqG
         EUOO6fQUjF7kxtxpbv+vOmKfCKPyShi0QwJO0DFdiSkN8rxU0v/uglRc8R1yoRHi1aBw
         Fz+WAVJ5AEj/oiL4524Xn3j+39CpVi0r43p/gN4ryDAbK7SM/bSmjhfbB007W3/yB0Lq
         O21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758935023; x=1759539823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rClUBrjl/Oh1tHtmby04uMrH9jeyFYSGvihqed2N4FY=;
        b=dYN4K7byiPKd4eAlM11wzaEsI2yo0cydLHIIOVGFRZ5g988OsvRViT4J00sOPBJv99
         Hr8FrCOcocwZGCRmNB5S9MBDamqZb4LF9maJ/A7gnWvGufMlSb52KT5N5NKMx0qSiJ2l
         IOLLPObUZCGGoOe8srGAoKyyGAj2PGOgmAD01PMiJPGF8nTwicfI80+61O0gQcg/6MrM
         i1NoCts2SHIKijx62ZuXDQAtQ8rpqM/WX4NN7raf1xp6sffPwke6Rc+E61oH61F8RKTX
         1KzWM7ywDGW8zi5oaPDRzd8jZ4C108W94skBrgDHeyvlbbuduNEpWg1dJ32uBdWVs9y3
         0+6Q==
X-Gm-Message-State: AOJu0YyYrRUgKMhB9vrNrHYEadCVsWnrAQ6HhvcuovhiJXBSgI0CwD4J
	UW1khO856CA/sVeTFq662IgTMVrjRPVcvZ+lXEmkUA8+5X1SJlCFfXUReORpK2EGYi8E9e99ppz
	5r0vY68GA8n072jEr9Zvvo4iRjjET+T8=
X-Gm-Gg: ASbGnctcrAsZg8LuqIHzz2ttHeCOVgkKyKmX0FLe3QZ2nLYcObPRwKkwT+Y+/lXf+oP
	uKv6/xQRo6JdINwlVbx9ZuGEWbO6aE7/tgVmcgkVTfqbd3HhhyuHgZL3DnkdNYKP5hc93Z0maGC
	dcJh6lAY+grKpYEN+HV9K5vDhRQjzSN24jO8VnGp4/+/OAhoQ7+mdqxpg59Dcw1k/wTyjzZ4dLc
	0+vbiaQcv4VfK2R1NIil3ZDtQ==
X-Google-Smtp-Source: AGHT+IEXAmdEqxRJ4yRbZTkA3GBbCit9juDI6akAVAqfg+uCjVg4zTujawRPNXwSW8PhwG//9/5pwh4WJbm5TkjqyEg=
X-Received: by 2002:a05:6870:f603:b0:321:ef6d:c736 with SMTP id
 586e51a60fabf-35ebdfa149amr5216001fac.3.1758935022438; Fri, 26 Sep 2025
 18:03:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916133437.713064-1-ekffu200098@gmail.com> <20250916133437.713064-3-ekffu200098@gmail.com>
In-Reply-To: <20250916133437.713064-3-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 27 Sep 2025 10:03:30 +0900
X-Gm-Features: AS18NWDOh9qDOIUPIEikmS9Sjq8_OF14FNi-SIpc3hiZfMq0skYklLyS_6RVtmc
Message-ID: <CABFDxMFtZKSr5KbqcGQzJWYwT5URUYeuEHJ1a_jDUQPO-OKVGg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] smb: client: add directory change tracking via
 SMB2 Change Notify
To: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 10:35=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
>
> Implement directory change tracking using SMB2 Change Notify protocol
> to enable real-time monitoring of remote directories. Applications using
> inotify now receive immediate notifications when files are created,
> deleted, or renamed on SMB2+ shares.
>
> This implementation begins by detecting tracking opportunities during
> regular SMB operations. In the current version, the readdir() serves as
> the detection point - when directory contents are accessed on SMB2+
> servers, we check the inode's fsnotify_mask for active inotify watches.
> If watches exist and directory is not already being tracked, we obtain a
> new FiieId and send a SMB2_CHANGE_NOTIFY request that waits for changes.
>
> Based on the server's response status, we convert CHANGE_NOTIFY response
> to fsnotify events and deliver to application on success, mark for
> future reconnection on network errors, or discard the response and
> marked entries for broken. If tracking can continue, we resend
> SMB2_CHANGE_NOTIFY for continuous monitoring.
>
> Entries marked for reconnection are restored during SMB2 reconnection.
> In the current version, smb2_reconnect() serves as restoration point -
> when connection is reestablished, we obtain new FileIds and request
> Change Notify requests for these entries.
>
> Entries marked for unmount during unmount. In the current version,
> cifs_umount() serves as unmount marking point. Entries marked for clean
> are remove as soon as possible by the worker. Workers also run
> periodically; currently every 30s; to check and remove untracking
> directories.
>
> This feature is controlled by CONFIG_CIFS_DIR_CHANGE_TRACKING with
> experimental.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  fs/smb/client/Kconfig   |  17 ++
>  fs/smb/client/Makefile  |   2 +
>  fs/smb/client/connect.c |   6 +
>  fs/smb/client/notify.c  | 535 ++++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/notify.h  |  19 ++
>  fs/smb/client/readdir.c |   9 +
>  fs/smb/client/smb2pdu.c |   6 +
>  7 files changed, 594 insertions(+)
>  create mode 100644 fs/smb/client/notify.c
>  create mode 100644 fs/smb/client/notify.h
>
> diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
> index a4c02199fef4..0e3911936e0c 100644
> --- a/fs/smb/client/Kconfig
> +++ b/fs/smb/client/Kconfig
> @@ -218,4 +218,21 @@ config CIFS_COMPRESSION
>           Say Y here if you want SMB traffic to be compressed.
>           If unsure, say N.
>
> ++config CIFS_DIR_CHANGE_TRACKING

I also found a typo here and I'll fix them.

> +       bool "Directory change tracking (Experimental)"
> +       depends on CIFS && FSNOTIFY=3Dy
> +       default n
> +       help
> +          Enables automatic tracking of directory changes for SMB2 or la=
ter
> +          using the SMB2 Change Notify protocol. File managers and appli=
cations
> +          monitoring directories via inotify will receive real-time upda=
tes
> +          when files are created, deleted, or renamed on the server.
> +
> +          This feature maintains persistent connections to track changes=
.
> +          Each monitored directory consumes server resources and may inc=
rease
> +          network traffic.
> +
> +          Say Y here if you want real-time directory monitoring.
> +          If unsure, say N.
> +
>  endif
> diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
> index 4c97b31a25c2..85253bc1b4b0 100644
> --- a/fs/smb/client/Makefile
> +++ b/fs/smb/client/Makefile
> @@ -35,3 +35,5 @@ cifs-$(CONFIG_CIFS_ROOT) +=3D cifsroot.o
>  cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) +=3D smb1ops.o cifssmb.o cifst=
ransport.o
>
>  cifs-$(CONFIG_CIFS_COMPRESSION) +=3D compress.o compress/lz77.o
> +
> +cifs-$(CONFIG_CIFS_DIR_CHANGE_TRACKING) +=3D notify.o
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index dd12f3eb61dc..eebf729df16a 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -51,6 +51,9 @@
>  #endif
>  #include "fs_context.h"
>  #include "cifs_swn.h"
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +#include "notify.h"
> +#endif
>
>  /* FIXME: should these be tunable? */
>  #define TLINK_ERROR_EXPIRE     (1 * HZ)
> @@ -4154,6 +4157,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
>         cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
>
>         if (cifs_sb->master_tlink) {
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +               stop_track_sb_dir_changes(cifs_sb);
> +#endif
>                 tcon =3D cifs_sb->master_tlink->tl_tcon;
>                 if (tcon) {
>                         spin_lock(&tcon->sb_list_lock);
> diff --git a/fs/smb/client/notify.c b/fs/smb/client/notify.c
> new file mode 100644
> index 000000000000..e38345965744
> --- /dev/null
> +++ b/fs/smb/client/notify.c
> @@ -0,0 +1,535 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Directory change notification tracking for SMB
> + *
> + * Copyright (c) 2025, Sang-Heon Jeon <ekffu200098@gmail.com>
> + *
> + * References:
> + * MS-SMB2 "2.2.35 SMB2 CHANGE_NOTIFY Request"
> + * MS-SMB2 "2.2.36 SMB2 CHANGE_NOTIFY Response"
> + * MS-SMB2 "2.7.1 FILE_NOTIFY_INFORMATION"
> + * MS-SMB2 "3.3.5.19 Receiving and SMB2 CHANGE_NOTIFY Request"
> + * MS-FSCC "2.6 File Attributes"
> + */
> +
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/fsnotify.h>
> +#include "notify.h"
> +#include "cifsproto.h"
> +#include "smb2proto.h"
> +#include "cached_dir.h"
> +#include "cifs_debug.h"
> +#include "cifspdu.h"
> +#include "cifs_unicode.h"
> +#include "../common/smb2pdu.h"
> +#include "../common/smb2status.h"
> +
> +#define CLEANUP_INTERVAL (30 * HZ)
> +#define CLEANUP_IMMEDIATE 0
> +
> +enum notify_state {
> +       NOTIFY_STATE_RECONNECT =3D BIT(0),
> +       NOTIFY_STATE_UMOUNT =3D BIT(1),
> +       NOTIFY_STATE_NOMASK =3D BIT(2),
> +       NOTIFY_STATE_BROKEN_REQ =3D BIT(3),
> +       NOTIFY_STATE_BROKEN_RSP =3D BIT(4),
> +};
> +
> +struct notify_info {
> +       struct inode *inode;
> +       const char *path;
> +       __le16 *utf16_path;
> +       struct cifs_fid cifs_fid;
> +       atomic_t state;
> +       struct list_head list;
> +};
> +
> +static int request_change_notify(struct notify_info *info);
> +static void notify_cleanup_worker(struct work_struct *work);
> +
> +static LIST_HEAD(notify_list);
> +static DEFINE_SPINLOCK(notify_list_lock);
> +static DECLARE_DELAYED_WORK(notify_cleanup_work, notify_cleanup_worker);
> +
> +static bool is_resumeable(struct notify_info *info)
> +{
> +       return atomic_read(&info->state) =3D=3D NOTIFY_STATE_RECONNECT;
> +}
> +
> +static bool is_active(struct notify_info *info)
> +{
> +       return atomic_read(&info->state) =3D=3D 0;
> +}
> +
> +static void set_state(struct notify_info *info, int state)
> +{
> +       atomic_or(state, &info->state);
> +       if (!is_resumeable(info))
> +               mod_delayed_work(cifsiod_wq, &notify_cleanup_work,
> +                       CLEANUP_IMMEDIATE);
> +}
> +
> +static void clear_state(struct notify_info *info, int state)
> +{
> +       atomic_and(~state, &info->state);
> +}
> +
> +static int fsnotify_send(__u32 mask,
> +                        struct inode *parent,
> +                        struct file_notify_information *fni,
> +                        u32 cookie)
> +{
> +       char *name =3D cifs_strndup_from_utf16(fni->FileName,
> +                               le32_to_cpu(fni->FileNameLength), true,
> +                               CIFS_SB(parent->i_sb)->local_nls);
> +       struct qstr qstr;
> +       int rc =3D 0;
> +
> +       if (!name)
> +               return -ENOMEM;
> +
> +       qstr.name =3D (const unsigned char *)name;
> +       qstr.len =3D strlen(name);
> +
> +       rc =3D fsnotify_name(mask, NULL, FSNOTIFY_EVENT_NONE, parent,
> +                       &qstr, cookie);
> +       cifs_dbg(FYI, "fsnotify mask=3D%u, name=3D%s, cookie=3D%u, w/retu=
rn=3D%d",
> +               mask, name, cookie, rc);
> +       kfree(name);
> +       return rc;
> +}
> +
> +static bool is_fsnotify_masked(struct inode *inode)
> +{
> +       if (!inode)
> +               return false;
> +
> +       /* Minimal validation of file explore inotify */
> +       return inode->i_fsnotify_mask &
> +               (FS_CREATE | FS_DELETE | FS_MOVED_FROM | FS_MOVED_TO);
> +}
> +
> +static void handle_file_notify_information(struct notify_info *info,
> +                                          char *buf,
> +                                          unsigned int buf_len)
> +{
> +       struct file_notify_information *fni;
> +       unsigned int next_entry_offset;
> +       u32 cookie;
> +       bool has_cookie =3D false;
> +
> +       do {
> +               fni =3D (struct file_notify_information *)buf;
> +               next_entry_offset =3D le32_to_cpu(fni->NextEntryOffset);
> +               if (next_entry_offset > buf_len) {
> +                       cifs_dbg(FYI, "invalid fni->NextEntryOffset=3D%u"=
,
> +                               next_entry_offset);
> +                       break;
> +               }
> +
> +               switch (le32_to_cpu(fni->Action)) {
> +               case FILE_ACTION_ADDED:
> +                       fsnotify_send(FS_CREATE, info->inode, fni, 0);
> +                       break;
> +               case FILE_ACTION_REMOVED:
> +                       fsnotify_send(FS_DELETE, info->inode, fni, 0);
> +                       break;
> +               case FILE_ACTION_RENAMED_OLD_NAME:
> +                       if (!has_cookie)
> +                               cookie =3D fsnotify_get_cookie();
> +                       has_cookie =3D !has_cookie;
> +                       fsnotify_send(FS_MOVED_FROM, info->inode, fni, co=
okie);
> +                       break;
> +               case FILE_ACTION_RENAMED_NEW_NAME:
> +                       if (!has_cookie)
> +                               cookie =3D fsnotify_get_cookie();
> +                       has_cookie =3D !has_cookie;
> +                       fsnotify_send(FS_MOVED_TO, info->inode, fni, cook=
ie);
> +                       break;
> +               default:
> +                       /* Does not occur, so no need to handle */
> +                       break;
> +               }
> +
> +               buf +=3D next_entry_offset;
> +               buf_len -=3D next_entry_offset;
> +       } while (buf_len > 0 && next_entry_offset > 0);
> +}
> +
> +static void handle_smb2_change_notify_rsp(struct notify_info *info,
> +                                         struct mid_q_entry *mid)
> +{
> +       struct smb2_change_notify_rsp *rsp =3D mid->resp_buf;
> +       struct kvec rsp_iov;
> +       unsigned int buf_offset, buf_len;
> +       int rc;
> +
> +       switch (rsp->hdr.Status) {
> +       case STATUS_SUCCESS:
> +               break;
> +       case STATUS_NOTIFY_ENUM_DIR:
> +               goto proceed;
> +       case STATUS_USER_SESSION_DELETED:
> +       case STATUS_NETWORK_NAME_DELETED:
> +       case STATUS_NETWORK_SESSION_EXPIRED:
> +               set_state(info, NOTIFY_STATE_RECONNECT);
> +               return;
> +       default:
> +               set_state(info, NOTIFY_STATE_BROKEN_RSP);
> +               return;
> +       }
> +
> +       rsp_iov.iov_base =3D mid->resp_buf;
> +       rsp_iov.iov_len =3D mid->resp_buf_size;
> +       buf_offset =3D le16_to_cpu(rsp->OutputBufferOffset);
> +       buf_len =3D le32_to_cpu(rsp->OutputBufferLength);
> +
> +       rc =3D smb2_validate_iov(buf_offset, buf_len, &rsp_iov,
> +                               sizeof(struct file_notify_information));
> +       if (rc) {
> +               cifs_dbg(FYI, "stay tracking, w/smb2_validate_iov=3D%d", =
rc);
> +               goto proceed;
> +       }
> +
> +       handle_file_notify_information(info,
> +               (char *)rsp + buf_offset, buf_len);
> +proceed:
> +       request_change_notify(info);
> +       return;
> +}
> +
> +static void change_notify_callback(struct mid_q_entry *mid)
> +{
> +       struct notify_info *info =3D mid->callback_data;
> +
> +       if (!is_active(info))
> +               return;
> +
> +       if (!is_fsnotify_masked(info->inode)) {
> +               set_state(info, NOTIFY_STATE_NOMASK);
> +               return;
> +       }
> +
> +       if (!mid->resp_buf) {
> +               if (mid->mid_state !=3D MID_RETRY_NEEDED) {
> +                       cifs_dbg(FYI, "stop tracking, w/mid_state=3D%d",
> +                               mid->mid_state);
> +                       set_state(info, NOTIFY_STATE_BROKEN_RSP);
> +                       return;
> +               }
> +
> +               set_state(info, NOTIFY_STATE_RECONNECT);
> +               return;
> +       }
> +
> +       handle_smb2_change_notify_rsp(info, mid);
> +}
> +
> +static int request_change_notify(struct notify_info *info)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(info->inode->i_sb);
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +       struct smb_rqst rqst;
> +       struct kvec iov[1];
> +       unsigned int xid;
> +       int rc;
> +
> +       if (!tcon) {
> +               cifs_dbg(FYI, "missing tcon while request change notify")=
;
> +               return -EINVAL;
> +       }
> +
> +       memset(&rqst, 0, sizeof(struct smb_rqst));
> +       memset(&iov, 0, sizeof(iov));
> +       rqst.rq_iov =3D iov;
> +       rqst.rq_nvec =3D 1;
> +
> +       xid =3D get_xid();
> +       rc =3D SMB2_notify_init(xid, &rqst, tcon, tcon->ses->server,
> +               info->cifs_fid.persistent_fid, info->cifs_fid.volatile_fi=
d,
> +               FILE_NOTIFY_CHANGE_FILE_NAME | FILE_NOTIFY_CHANGE_DIR_NAM=
E,
> +               false);
> +       free_xid(xid);
> +       if (rc) {
> +               set_state(info, NOTIFY_STATE_BROKEN_REQ);
> +               return rc;
> +       }
> +
> +       rc =3D cifs_call_async(tcon->ses->server, &rqst, NULL,
> +               change_notify_callback, NULL, info, 0, NULL);
> +       cifs_small_buf_release(rqst.rq_iov[0].iov_base);
> +
> +       if (rc)
> +               set_state(info, NOTIFY_STATE_BROKEN_REQ);
> +       return rc;
> +}
> +
> +
> +static void free_notify_info(struct notify_info *info)
> +{
> +       kfree(info->utf16_path);
> +       kfree(info->path);
> +       kfree(info);
> +}
> +
> +static void cleanup_pending_mid(struct notify_info *info,
> +                               struct cifs_tcon *tcon)
> +{
> +       LIST_HEAD(dispose_list);
> +       struct TCP_Server_Info *server;
> +       struct mid_q_entry *mid, *nmid;
> +
> +       if (!tcon->ses || !tcon->ses->server)
> +               return;
> +
> +       server =3D tcon->ses->server;
> +
> +       spin_lock(&server->mid_queue_lock);
> +       list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead=
) {
> +               if (mid->callback_data =3D=3D info) {
> +                       mid->deleted_from_q =3D true;
> +                       list_move(&mid->qhead, &dispose_list);
> +               }
> +       }
> +       spin_unlock(&server->mid_queue_lock);
> +
> +       list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
> +               list_del_init(&mid->qhead);
> +               release_mid(mid);
> +       }
> +}
> +
> +static void close_fid(struct notify_info *info)
> +{
> +       struct cifs_tcon *tcon;
> +
> +       unsigned int xid;
> +       int rc;
> +
> +       if (!info->cifs_fid.persistent_fid && !info->cifs_fid.volatile_fi=
d)
> +               return;
> +
> +       tcon =3D cifs_sb_master_tcon(CIFS_SB(info->inode->i_sb));
> +       if (!tcon) {
> +               cifs_dbg(FYI, "missing master tcon while close");
> +               return;
> +       }
> +
> +       xid =3D get_xid();
> +       rc =3D SMB2_close(xid, tcon, info->cifs_fid.persistent_fid,
> +               info->cifs_fid.volatile_fid);
> +       if (rc) {
> +               cifs_dbg(FYI, "cleanup pending mid, w/SMB2_close=3D%d", r=
c);
> +               cleanup_pending_mid(info, tcon);
> +       }
> +       free_xid(xid);
> +}
> +
> +static int setup_fid(struct notify_info *info)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(info->inode->i_sb);
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +       struct cifs_open_parms oparms;
> +       __u8 oplock =3D 0;
> +       unsigned int xid;
> +       int rc =3D 0;
> +
> +       if (!tcon) {
> +               cifs_dbg(FYI, "missing master tcon while open");
> +               return -EINVAL;
> +       }
> +
> +       xid =3D get_xid();
> +       oparms =3D (struct cifs_open_parms) {
> +               .tcon =3D tcon,
> +               .path =3D info->path,
> +               .desired_access =3D GENERIC_READ,
> +               .disposition =3D FILE_OPEN,
> +               .create_options =3D cifs_create_options(cifs_sb, 0),
> +               .fid =3D &info->cifs_fid,
> +               .cifs_sb =3D cifs_sb,
> +               .reconnect =3D false,
> +       };
> +       rc =3D SMB2_open(xid, &oparms, info->utf16_path, &oplock,
> +                       NULL, NULL, NULL, NULL);
> +       free_xid(xid);
> +       return rc;
> +}
> +
> +static bool is_already_tracking(struct inode *dir_inode)
> +{
> +       struct notify_info *entry, *nentry;
> +
> +       spin_lock(&notify_list_lock);
> +       list_for_each_entry_safe(entry, nentry, &notify_list, list) {
> +               if (is_active(entry)) {
> +                       if (entry->inode =3D=3D dir_inode) {
> +                               spin_unlock(&notify_list_lock);
> +                               return true;
> +                       }
> +
> +                       /* Extra check since we must keep iterating */
> +                       if (!is_fsnotify_masked(entry->inode))
> +                               set_state(entry, NOTIFY_STATE_NOMASK);
> +               }
> +       }
> +       spin_unlock(&notify_list_lock);
> +
> +       return false;
> +}
> +
> +static bool is_tracking_supported(struct cifs_sb_info *cifs_sb)
> +{
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +
> +       if (!tcon->ses || !tcon->ses->server)
> +               return false;
> +       return tcon->ses->server->dialect >=3D SMB20_PROT_ID;
> +}
> +
> +int start_track_dir_changes(const char *path,
> +                           struct inode *dir_inode,
> +                           struct cifs_sb_info *cifs_sb)
> +{
> +       struct notify_info *info;
> +       int rc;
> +
> +       if (!is_tracking_supported(cifs_sb))
> +               return -EINVAL;
> +
> +       if (!is_fsnotify_masked(dir_inode))
> +               return -EINVAL;
> +
> +       if (is_already_tracking(dir_inode))
> +               return 1;
> +
> +       info =3D kzalloc(sizeof(*info), GFP_KERNEL);
> +       if (!info)
> +               return -ENOMEM;
> +
> +       info->path =3D kstrdup(path, GFP_KERNEL);
> +       if (!info->path) {
> +               free_notify_info(info);
> +               return -ENOMEM;
> +       }
> +       info->utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!info->utf16_path) {
> +               free_notify_info(info);
> +               return -ENOMEM;
> +       }
> +       info->inode =3D dir_inode;
> +
> +       rc =3D setup_fid(info);
> +       if (rc) {
> +               free_notify_info(info);
> +               return rc;
> +       }
> +       rc =3D request_change_notify(info);
> +       if (rc) {
> +               close_fid(info);
> +               free_notify_info(info);
> +               return rc;
> +       }
> +
> +       spin_lock(&notify_list_lock);
> +       list_add(&info->list, &notify_list);
> +       spin_unlock(&notify_list_lock);
> +       return rc;
> +}
> +
> +void stop_track_sb_dir_changes(struct cifs_sb_info *cifs_sb)
> +{
> +       struct notify_info *entry, *nentry;
> +
> +       if (!list_empty(&notify_list)) {
> +               spin_lock(&notify_list_lock);
> +               list_for_each_entry_safe(entry, nentry, &notify_list, lis=
t) {
> +                       if (cifs_sb =3D=3D CIFS_SB(entry->inode->i_sb)) {
> +                               set_state(entry, NOTIFY_STATE_UMOUNT);
> +                               continue;
> +                       }
> +
> +                       /* Extra check since we must keep iterating */
> +                       if (!is_fsnotify_masked(entry->inode))
> +                               set_state(entry, NOTIFY_STATE_NOMASK);
> +               }
> +               spin_unlock(&notify_list_lock);
> +       }
> +}
> +
> +void resume_track_dir_changes(void)
> +{
> +       LIST_HEAD(resume_list);
> +       struct notify_info *entry, *nentry;
> +       struct cifs_tcon *tcon;
> +
> +       if (list_empty(&notify_list))
> +               return;
> +
> +       spin_lock(&notify_list_lock);
> +       list_for_each_entry_safe(entry, nentry, &notify_list, list) {
> +               if (!is_fsnotify_masked(entry->inode)) {
> +                       set_state(entry, NOTIFY_STATE_NOMASK);
> +                       continue;
> +               }
> +
> +               if (is_resumeable(entry)) {
> +                       tcon =3D cifs_sb_master_tcon(CIFS_SB(entry->inode=
->i_sb));
> +                       spin_lock(&tcon->tc_lock);
> +                       if (tcon->status =3D=3D TID_GOOD) {
> +                               spin_unlock(&tcon->tc_lock);
> +                               list_move(&entry->list, &resume_list);
> +                               continue;
> +                       }
> +                       spin_unlock(&tcon->tc_lock);
> +               }
> +       }
> +       spin_unlock(&notify_list_lock);
> +
> +       list_for_each_entry_safe(entry, nentry, &resume_list, list) {
> +               if (setup_fid(entry)) {
> +                       list_del(&entry->list);
> +                       free_notify_info(entry);
> +                       continue;
> +               }
> +
> +               if (request_change_notify(entry)) {
> +                       list_del(&entry->list);
> +                       close_fid(entry);
> +                       free_notify_info(entry);
> +                       continue;
> +               }
> +
> +               clear_state(entry, NOTIFY_STATE_RECONNECT);
> +       }
> +
> +       if (!list_empty(&resume_list)) {
> +               spin_lock(&notify_list_lock);
> +               list_splice(&resume_list, &notify_list);
> +               spin_unlock(&notify_list_lock);
> +       }
> +}
> +
> +static void notify_cleanup_worker(struct work_struct *work)
> +{
> +       LIST_HEAD(cleanup_list);
> +       struct notify_info *entry, *nentry;
> +
> +       if (list_empty(&notify_list))
> +               return;
> +
> +       spin_lock(&notify_list_lock);
> +       list_for_each_entry_safe(entry, nentry, &notify_list, list) {
> +               if (!is_resumeable(entry) && !is_active(entry))
> +                       list_move(&entry->list, &cleanup_list);
> +       }
> +       spin_unlock(&notify_list_lock);
> +
> +       list_for_each_entry_safe(entry, nentry, &cleanup_list, list) {
> +               list_del(&entry->list);
> +               close_fid(entry);
> +               free_notify_info(entry);
> +       }
> +       mod_delayed_work(cifsiod_wq, &notify_cleanup_work, CLEANUP_INTERV=
AL);
> +}
> diff --git a/fs/smb/client/notify.h b/fs/smb/client/notify.h
> new file mode 100644
> index 000000000000..088efba4dce9
> --- /dev/null
> +++ b/fs/smb/client/notify.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Directory change notification tracking for SMB
> + *
> + * Copyright (c) 2025, Sang-Heon Jeon <ekffu200098@gmail.com>
> + */
> +
> +#ifndef _SMB_NOTIFY_H
> +#define _SMB_NOTIFY_H
> +
> +#include "cifsglob.h"
> +
> +int start_track_dir_changes(const char *path,
> +                           struct inode *dir_inode,
> +                           struct cifs_sb_info *cifs_sb);
> +void stop_track_sb_dir_changes(struct cifs_sb_info *cifs_sb);
> +void resume_track_dir_changes(void);
> +
> +#endif /* _SMB_NOTIFY_H */
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index 4e5460206397..455e5be37116 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -24,6 +24,9 @@
>  #include "fs_context.h"
>  #include "cached_dir.h"
>  #include "reparse.h"
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +#include "notify.h"
> +#endif
>
>  /*
>   * To be safe - for UCS to UTF-8 with strings loaded with the rare long
> @@ -1070,6 +1073,9 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>         if (rc)
>                 goto cache_not_found;
>
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +       start_track_dir_changes(full_path, d_inode(file_dentry(file)), ci=
fs_sb);
> +#endif
>         mutex_lock(&cfid->dirents.de_mutex);
>         /*
>          * If this was reading from the start of the directory
> @@ -1151,6 +1157,9 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>                 cifs_dbg(FYI, "Could not find entry\n");
>                 goto rddir2_exit;
>         }
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +       start_track_dir_changes(full_path, d_inode(file_dentry(file)), ci=
fs_sb);
> +#endif
>         cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n=
",
>                  num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
>         max_len =3D tcon->ses->server->ops->calc_smb_size(
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 4e922cb32110..58a1ddc39ee6 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -45,6 +45,9 @@
>  #include "cached_dir.h"
>  #include "compress.h"
>  #include "fs_context.h"
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +#include "notify.h"
> +#endif
>
>  /*
>   *  The following table defines the expected "StructureSize" of SMB2 req=
uests
> @@ -466,6 +469,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
>
>         atomic_inc(&tconInfoReconnectCount);
> +#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
> +       resume_track_dir_changes();
> +#endif
>  out:
>         /*
>          * Check if handle based operation so we know whether we can cont=
inue
> --
> 2.43.0
>

To Reviewers.

This is a gentle reminder on review requests.

I would be very grateful for your feedback and am more than willing to
revise or improve any parts as needed. And also, let me know if I
missed anything or made mistakes.

Best Regards,
Sang-Heon Jeon
