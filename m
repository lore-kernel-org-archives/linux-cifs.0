Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9077330B2B
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769769212; cv=pass; b=ClSUor4q5bohrpZTz6ypi5F44QCZceUETKNgEN4E9e0k6MZnyJWySYuFhvTCKmsipn7PJwqKmcjED6u8dnN745jUNNaOxj0uP6GaLIOufa7oDN2R1f/ZEhAnCIYP3lt8I/mNuxIUpq7ZIy+23Y7CuvqJ8NcNktDKwNSFByCTKUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769769212; c=relaxed/simple;
	bh=Rg1kjqivbmynLBos675Qg+jATzukRjounwiViomLdjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L5cWEaGIEMGxi+SY6o2ba9U7reynR/V3AOI5fgpmai645y3lYHT4svd3zEOll4yhh3eWYPsokm18rRW03aqdRB0R7/MbCOrNShuCOgbIWOvXaSIpdeT2Rj5BRnO+t02uVXyT5n0L86ooXOiAa23nLQn5KhvR5KCAu9hvDtooutk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDld/Y1c; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDld/Y1c"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8860d6251bso267949166b.3
        for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 02:33:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769769209; cv=none;
        d=google.com; s=arc-20240605;
        b=jo4Ua5vHOdoc2Ky6vw4/wfBheP2fqbUA0FqjL7+nWmjJFm9wpRcxcPwaOOukFPmmA1
         lztjwZbcxcqk1MhuZUrYHPuhqG4LccuMeQrFmOiCoNyGHWMthzcADKC5kul+jZ1TzZdY
         1voaYi9WlspjAbfHcTgCs0FT9wEqDtQ8wVTT2CP6kk1VwyAi+yCQJSV1yFopEyF5O6/L
         pHB8DlP4pf7pGT0RxAW79owX8unmV94vsXl9DdR3C+Z35FIhLT9VELmNbp8yBdWvq+mn
         6gZ7AfbYxXr57PvCZQD3Qkaw7zsqBjPDpe/fXy2zmbsQ3PwJzZ45rIJ2Z31DUe3rWwmF
         pX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NamQttoN9RSjS2MzNgz6GdCc3Gy3qvURkH6yC/nyMgc=;
        fh=lKrabUzBUJXyos02jYZ0inVGDOaMZfpqqcy4WyMCYhQ=;
        b=LgdL86gVrXCS04L9khHDMj7TOUQDXLhRrn0G7ixFBtTiJ42IJX1kBTfShPGWFl2f0F
         aTfY/60IDzSZOjk0bpY0+GBhc2+ANxUvh2M1ZL+efbXAuMUlDgbsr/gQGd8qsquLmJB9
         XFwiWro3S7W78Sbx5cN8CD8GmF0veprUrkL1/7jBBAXjZFXB0LbeJJ9r9OHCO6eM1Z75
         xGgonJOuoHEQwCJMknyWcQnBUMSqtvteTKXrdeTHovK5fFhkDdFEoo933ZgNA43jgqAd
         3RQkisVXNrMvW9EOjDnXnrYboD3OebCYq+ssj1EljCvouOV165PVyDPoy5Vu1IwSTeES
         qP8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769769209; x=1770374009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NamQttoN9RSjS2MzNgz6GdCc3Gy3qvURkH6yC/nyMgc=;
        b=dDld/Y1cg8byFjsDH3rQK7TnvuPAiqlqNJDA9haUV+BTChF1Mmegu/Rag2pMkKQaxL
         71/e/Q5jQbtwaqbEvh2EcuMDHYB9yKWcgOxbVEorQ9W9M3LF1sHUUkQWxfdwXboWFHbp
         HRCpitb6/qenYBjPXYwkpi3tbuXf00ssHQ3NLT+rgxMWWm+4MYs4P/ARN12M2ww3f+Z4
         GIZ+2tH+CvMRLk2hsUrWa1N4PS2qNLcdrrevDfwITC5QePTUrKZuP+0sunW19MOIFmlz
         q/yJFcP9Vs9DPoX7uZ++HWkY4hx9qW0mI8YZnyP2VNILMrxt/tmqFQyn5YhXG5n9JtdR
         gJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769769209; x=1770374009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NamQttoN9RSjS2MzNgz6GdCc3Gy3qvURkH6yC/nyMgc=;
        b=Vo9eYGeT1p1z2iZy3o7dn4QJE4wMSLLrOg7LwNmMvYPC0LW48FlKQxlTbBVsj5uMpr
         ZlJrz7HJt2DK2lb7xJfY2yi8GbSXUHh+sg0rjpgMSAQ3OBjxgteGkbpvZX3M3IN2krWk
         kcyKpNH0yO8PmexE7KN9uUjejjHTuJVJo4EILJHTLmhATbUxKMMJCTAyjtRHcnWCot11
         3i7Ez71d6/qCC0P3Us7lGQolM/GnPE97c9q/gUtTD9UxHmbCztt06IS9QxP7HnMgcjPt
         RxSC2kUpcduDBCn8EepgRwKE7h37jJEpJbP7D5rkfm5Y01YLbgXIGMKbbVdpeqxHg0IO
         pMoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH5FvkPOeOCHYfXj7wTipd7Gi05hpAylSuAgNRhkMKthh0OY/Ncp+OSsBrwfXXfwoKiecn+zds87Dt@vger.kernel.org
X-Gm-Message-State: AOJu0YxFzY0MqKW1Bg0K2yPJlV5G4ZgK/IHct8fmTmEJKntY8nQl+pfX
	7PpNQGRTDKIjTA/5eCISZNYv6vV/LRyW+iNnNrdL1nqL/FWp8ZswyImueZLe+mFNFOd/DgZVebG
	/LQz0nItOBGtO80pxZaKJDO+jv6fQv5E=
X-Gm-Gg: AZuq6aLSDGWbkpUVghKi7Fe97b1Bm9bW46eek6loSckNefLpPDfR1SAY2YpC1m/mdlr
	taFeiXC+IfualmIklQ6kT2EGUPIQsIihZX2TCJENz0CkGyqRK20YJKKAjH4Ttt5wxxY8vMVEjOw
	WZW6T4ThjmktOitkhIgEUDZyvQKHOSmjTb/WxaBdgpOjCK5nym+lHHhOtk+FmCIT3n9eQ2ti/UF
	EOec62IsN+Ls8nFJVkad7XOMuFqLD7oXfwsY9qzjWB0rFl0XzlkxWqbbZQrczBMbDfd7A==
X-Received: by 2002:a17:906:eec5:b0:b88:5b21:b148 with SMTP id
 a640c23a62f3a-b8dff56f475mr127078766b.10.1769769208828; Fri, 30 Jan 2026
 02:33:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223124119.1383159-1-s.piyush1024@gmail.com>
In-Reply-To: <20251223124119.1383159-1-s.piyush1024@gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 30 Jan 2026 16:03:17 +0530
X-Gm-Features: AZwV_QgiL0gGu8gMzMnG_2HtLWuuUB_SCsDAJHD1FJjJdy-Zb4mjnKHRAXoKrDs
Message-ID: <CANT5p=qrSg7FH4SSG5EyFDwt8LsQ1ztKzJJYQOfPG18ROPTcqQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: close all files marked for deferred close immediately
To: Piyush Sachdeva <s.piyush1024@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sprasad@microsoft.com, bharathsm@microsoft.com, 
	msetiya@microsoft.com, rajasimandal@microsoft.com, psachdeva@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 6:21=E2=80=AFPM Piyush Sachdeva <s.piyush1024@gmail=
.com> wrote:
>
> From: Piyush Sachdeva <psachdeva@microsoft.com>
>
> SMB client has a feature to delay the close of a file on the server,
> expecting if an open call comes for the same file, the file doesn't
> need to be re-opened. The time duration of the deferred close is set
> by the mount option `closetimeo`.
> This patch lets a user list all handles marked for deferred close, by
> cat /proc/fs/cifs/close_deferred_closes.
> It also allow for force close of all files marked for deferred close,
> across all session by writing a non-zero value to the same procfs file.
>
> Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
> Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
> ---
>  fs/smb/client/cifs_debug.c | 137 +++++++++++++++++++++++++++++++++++++
>  fs/smb/client/cifsglob.h   |   5 ++
>  2 files changed, 142 insertions(+)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 7fdcaf9feb16..e149a403b16e 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -952,6 +952,7 @@ static const struct proc_ops traceSMB_proc_ops;
>  static const struct proc_ops cifs_security_flags_proc_ops;
>  static const struct proc_ops cifs_linux_ext_proc_ops;
>  static const struct proc_ops cifs_mount_params_proc_ops;
> +static const struct proc_ops close_all_deferred_close_ops;
>
>  void
>  cifs_proc_init(void)
> @@ -981,6 +982,8 @@ cifs_proc_init(void)
>
>         proc_create("mount_params", 0444, proc_fs_cifs, &cifs_mount_param=
s_proc_ops);
>
> +       proc_create("close_deferred_closes", 0644, proc_fs_cifs, &close_a=
ll_deferred_close_ops);
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         proc_create("dfscache", 0644, proc_fs_cifs, &dfscache_proc_ops);
>  #endif
> @@ -1021,6 +1024,7 @@ cifs_proc_clean(void)
>         remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
>         remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
>         remove_proc_entry("mount_params", proc_fs_cifs);
> +       remove_proc_entry("close_deferred_closes", proc_fs_cifs);
>
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         remove_proc_entry("dfscache", proc_fs_cifs);
> @@ -1317,6 +1321,139 @@ static const struct proc_ops cifs_mount_params_pr=
oc_ops =3D {
>         /* .proc_write  =3D cifs_mount_params_proc_write, */
>  };
>
> +static struct list_head *get_all_tcons(void)
> +{
> +       struct TCP_Server_Info *server;
> +       struct cifs_ses *ses;
> +       struct cifs_tcon *tcon;
> +       struct global_tcon_list *tree_con_list, *tmp_tree_con_list;
> +       struct list_head *tcon_head;
> +
> +       tcon_head =3D kmalloc(sizeof(struct list_head), GFP_KERNEL);
> +       if (tcon_head =3D=3D NULL)
> +               return NULL;
> +
> +       INIT_LIST_HEAD(tcon_head);
> +       spin_lock(&cifs_tcp_ses_lock);
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> +               list_for_each_entry(ses, &server->smb_ses_list, smb_ses_l=
ist) {
> +                       if (cifs_ses_exiting(ses))
> +                               continue;
> +                       list_for_each_entry(tcon, &ses->tcon_list, tcon_l=
ist) {
> +                               tree_con_list =3D
> +                                       kmalloc(sizeof(struct global_tcon=
_list),
> +                                               GFP_ATOMIC);
> +                               if (tree_con_list =3D=3D NULL)
> +                                       goto tcon_alloc_fail;
> +                               tree_con_list->tcon =3D tcon;
> +                               list_add_tail(&tree_con_list->list, tcon_=
head);
> +                       }
> +               }
> +       }
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       return tcon_head;
> +
> +tcon_alloc_fail:
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       list_for_each_entry_safe(tree_con_list, tmp_tree_con_list, tcon_h=
ead,
> +                                list) {
> +               list_del(&tree_con_list->list);
> +               kfree(tree_con_list);
> +       }
> +       kfree(tcon_head);
> +       return NULL;
> +}
> +
> +static ssize_t close_all_deferred_close_files(struct file *file,
> +                                         const char __user *buffer,
> +                                         size_t count, loff_t *ppos)
> +{
> +       char c;
> +       int rc;
> +       struct global_tcon_list *tmp_list, *tmp_next_list;
> +       struct list_head *tcon_head;
> +
> +       rc =3D get_user(c, buffer);
> +       if (rc)
> +               return rc;
> +       if (c =3D=3D '0')
> +               return -EINVAL;
> +
> +       tcon_head =3D get_all_tcons();
> +       if (tcon_head =3D=3D NULL)
> +               return count;
> +
> +       list_for_each_entry_safe(tmp_list, tmp_next_list, tcon_head, list=
) {
> +               cifs_close_all_deferred_files(tmp_list->tcon);
> +               list_del(&tmp_list->list);
> +               kfree(tmp_list);
> +       }
> +
> +       kfree(tcon_head);
> +       return count;
> +}
> +
> +static int show_all_deferred_close_files(struct seq_file *m, void *v)
> +{
> +       struct global_tcon_list *tmp_list, *tmp_next_list;
> +       struct list_head *tcon_head;
> +       struct cifs_tcon *tcon;
> +       struct cifsFileInfo *cfile;
> +
> +       seq_puts(m, "# Version:1\n");
> +       seq_puts(m, "# Format:\n");
> +       seq_puts(m, "# <tree id> <ses id> <persistent fid> <flags> <count=
> <pid> <uid>");
> +#ifdef CONFIG_CIFS_DEBUG2
> +       seq_puts(m, " <filename> <mid>\n");
> +#else
> +       seq_puts(m, " <filename>\n");
> +#endif /* CIFS_DEBUG2 */
> +
> +       tcon_head =3D get_all_tcons();
> +       if (tcon_head =3D=3D NULL)
> +               return 0;
> +
> +       list_for_each_entry_safe(tmp_list, tmp_next_list, tcon_head, list=
) {
> +               tcon =3D tmp_list->tcon;
> +               spin_lock(&tcon->open_file_lock);
> +               list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> +                       if (delayed_work_pending(&cfile->deferred)) {
> +                               seq_printf(
> +                                       m,
> +                                       "0x%x 0x%llx 0x%llx 0x%x %d %d %d=
 %pd",
> +                                       tcon->tid, tcon->ses->Suid,
> +                                       cfile->fid.persistent_fid,
> +                                       cfile->f_flags, cfile->count,
> +                                       cfile->pid,
> +                                       from_kuid(&init_user_ns, cfile->u=
id),
> +                                       cfile->dentry);
> +                       }
> +               }
> +               spin_unlock(&tcon->open_file_lock);
> +               list_del(&tmp_list->list);
> +               kfree(tmp_list);
> +       }
> +
> +       kfree(tcon_head);
> +       seq_putc(m, '\n');
> +
> +       return 0;
> +}
> +
> +static int show_all_deferred_close_proc_open(struct inode *inode,
> +                                             struct file *file)
> +{
> +       return single_open(file, show_all_deferred_close_files, NULL);
> +}
> +
> +static const struct proc_ops close_all_deferred_close_ops =3D {
> +       .proc_open =3D show_all_deferred_close_proc_open,
> +       .proc_read =3D seq_read,
> +       .proc_lseek =3D seq_lseek,
> +       .proc_release =3D single_release,
> +       .proc_write =3D close_all_deferred_close_files,
> +};
> +
>  #else
>  inline void cifs_proc_init(void)
>  {
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 203e2aaa3c25..56c987258c4b 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1806,6 +1806,11 @@ struct dfs_info3_param {
>         int ttl;
>  };
>
> +struct global_tcon_list {
> +       struct list_head list;
> +       struct cifs_tcon *tcon;
> +};
> +
>  struct file_list {
>         struct list_head list;
>         struct cifsFileInfo *cfile;
> --
> 2.52.0
>
>
Did an offline review of this patch with Piyush.
He noted that the lock ordering rules in cifsglob.h stopped him from
using code similar to open_files listing. (Thanks Piyush for bringing
it up)
I think this is an error in the lock ordering comment. I'll submit a
patch to fix that.
I've asked Piyush to submit a v2 patch based on that.

--=20
Regards,
Shyam
