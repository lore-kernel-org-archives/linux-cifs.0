Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE5F8288C;
	Sun, 15 Sep 2024 21:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434925; cv=none; b=rPhdT+6mItu94nuRN3OzGlY1LbQzhlGD1/Uh49w4cyPHjck5ziX1M83o3QwApFWuF32lx375Uh3S2z2hAP0yc8//VkVXTbOnUwwTMw9H+gFtGplhX/T2TexVYpiCXKuT79BgWDgsVaESLb3L5CYSr/BqPGRTb6oFLCjy63p/LzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434925; c=relaxed/simple;
	bh=vQMtRSs+jpvAfBuzqxe/hvpEUCP4OlVV/oR+iN9ofMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z5oa/v3IntPpWylLxK/3WIsv8m51N09DuNTHZUNqrnfQv7k1stMKFqqpAgjk9uZgCIadKm5T47gsI4u+iRE2InX8VThg9+BXA4MmP0QE4aZAfgf8j5HTJflNasgasT20oUMvpJaz5XbXt+yfc6iiySLgfr1t/A2Hpmk7QHYTy8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoOs/4LB; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoOs/4LB"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5365d3f9d34so2755434e87.3;
        Sun, 15 Sep 2024 14:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726434921; x=1727039721; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d95oEThEVkujmDQUzsxGtKvqJEre2Z3NGdOos2tHiUY=;
        b=NoOs/4LBC4S2ohxCU5lTPdQ2k7F+/zfSDPWru2qWynZu7Zbs2PbhR0xQN/7GyhSOj0
         dFlsermgqjR3flOWMlG5CbAL+htyUGy4Sj02jdJefpTVP+IQpRl+HG8ElNxKMFpMNVkw
         nsHZ95y73g/ZNQczHye8YTPHOrg0r1YUM2YZLJ8qAet0H8sm9oVrQnz/M8V3EKpPjavY
         Jc8cHa+tw18BZeX3Te5XhhFpxZqjSnI213RiIWudcGhns3NHOE3pA93V4A+3dC9IqrdC
         5gqqBPv9AbKwfMj8OYj8lN2B1H23fO/m0DYaRpK6FkmfXg4DVDppRUjf8WjyoPPcGRgw
         b0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726434921; x=1727039721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d95oEThEVkujmDQUzsxGtKvqJEre2Z3NGdOos2tHiUY=;
        b=O0jsp/iKB4R39LpLebHXeLmuR0EudoylFK0QWZYN47r8h/5xKypuIhOZwryg9t5ul/
         Km4o+of55lALcS3ix+DDrMfwtY483BQsqEMNU4hBU3qHYClH7AOanfmLPijYATaTQDUU
         5mUqHo41LSkFSeMvT69kBEj5roE2CH/0A4o3V9XWXB8soP7i0XafPh5nWSib8gTvHT89
         PvLMxJOJn5XYkDciSO0MDVXZvTxOvqsKc6WA6Lp9i7Iq9r9nClyEasXVtYPGfDzb+1V5
         aCUIbGaXZE8PZPvtMS85dibMYFr+0mwqWhYMBXbXIKgu7CUBzDiLNx2CB2gkLhVoveRV
         mVCA==
X-Forwarded-Encrypted: i=1; AJvYcCUvw6fsPBSI3aZu0+c5mShjkbtchVIBUVYsxn5RwatRDk1eNKoq3SLHP3SQWAP0U3enKc/rziiAOb73AdB6@vger.kernel.org, AJvYcCWrSzf38qpSmtYIAbqfgHFrtdxZ4lhHC/fxqVMS6NIDo273E/WZVMeKx89FkEk9LjhqMEoSH9rORzjZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx14HSzGKaYqrNKbuFmRlrvL1/GX295BVzRw7MUg8bL+fimxJhy
	4lJ2jwozo2AiZAX4kAlGTbgmVRDbOly+DaCJVAH/UgF1vYYYEmcc88WWH7gGeLKgsLWIqNQ1sFu
	ejl0jbW7YjK7iM0rCKXXck3S5ecE=
X-Google-Smtp-Source: AGHT+IH6Dq7y1FonhesDJ4aStQNF++311mosVMYWshj8vFfQ9m0hRRzvwgrMH6mjzlK2//kODQKKB0QxThwdY+NidI0=
X-Received: by 2002:a05:6512:124e:b0:534:3cdc:dbfe with SMTP id
 2adb3069b0e04-5367fee526cmr3547821e87.28.1726434920338; Sun, 15 Sep 2024
 14:15:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-7-pali@kernel.org> <20240915194545.14779-1-pali@kernel.org>
 <20240915194545.14779-2-pali@kernel.org>
In-Reply-To: <20240915194545.14779-2-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 15 Sep 2024 16:15:09 -0500
Message-ID: <CAH2r5msn4JgezFNPmgfWA6Ti1SzorvfhXXkk747bQ4R4QjNkCQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: Add support for creating SFU symlinks
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending review/testing

On Sun, Sep 15, 2024 at 2:46=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Linux cifs client can already detect SFU symlinks and reads it content
> (target location). But currently is not able to create new symlink. So
> implement this missing support.
>
> When 'sfu' mount option is specified and 'mfsymlinks' is not specified th=
en
> create new symlinks in SFU-style. This will provide full SFU compatibilit=
y
> of symlinks when mounting cifs share with 'sfu' option. 'mfsymlinks' opti=
on
> override SFU for better Apple compatibility as explained in fs_context.c
> file in smb3_update_mnt_flags() function.
>
> Extend __cifs_sfu_make_node() function, which now can handle also S_IFLNK
> type and refactor structures passed to sync_write() in this function, by
> splitting SFU type and SFU data from original combined struct win_dev as
> combined fixed-length struct cannot be used for variable-length symlinks.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifspdu.h    |  6 ---
>  fs/smb/client/cifsproto.h  |  4 ++
>  fs/smb/client/fs_context.c | 13 ++++---
>  fs/smb/client/link.c       |  3 ++
>  fs/smb/client/smb2ops.c    | 80 +++++++++++++++++++++++++++++---------
>  5 files changed, 77 insertions(+), 29 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index a2072ab9e586..c3b6263060b0 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -2573,12 +2573,6 @@ typedef struct {
>  } __attribute__((packed)) FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp =
data */
>
>
> -struct win_dev {
> -       unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO or LnxSOC=
K */
> -       __le64 major;
> -       __le64 minor;
> -} __attribute__((packed));
> -
>  struct fea {
>         unsigned char EA_flags;
>         __u8 name_len;
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 497bf3c447bc..791bddac0396 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -676,6 +676,10 @@ char *extract_sharename(const char *unc);
>  int parse_reparse_point(struct reparse_data_buffer *buf,
>                         u32 plen, struct cifs_sb_info *cifs_sb,
>                         bool unicode, struct cifs_open_info_data *data);
> +int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> +                        struct dentry *dentry, struct cifs_tcon *tcon,
> +                        const char *full_path, umode_t mode, dev_t dev,
> +                        const char *symname);
>  int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
>                        struct dentry *dentry, struct cifs_tcon *tcon,
>                        const char *full_path, umode_t mode, dev_t dev);
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index bc926ab2555b..2f0c3894b0f7 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1896,14 +1896,17 @@ void smb3_update_mnt_flags(struct cifs_sb_info *c=
ifs_sb)
>         if (ctx->mfsymlinks) {
>                 if (ctx->sfu_emul) {
>                         /*
> -                        * Our SFU ("Services for Unix" emulation does no=
t allow
> -                        * creating symlinks but does allow reading exist=
ing SFU
> -                        * symlinks (it does allow both creating and read=
ing SFU
> -                        * style mknod and FIFOs though). When "mfsymlink=
s" and
> +                        * Our SFU ("Services for Unix") emulation allows=
 now
> +                        * creating new and reading existing SFU symlinks=
.
> +                        * Older Linux kernel versions were not able to n=
either
> +                        * read existing nor create new SFU symlinks. But
> +                        * creating and reading SFU style mknod and FIFOs=
 was
> +                        * supported for long time. When "mfsymlinks" and
>                          * "sfu" are both enabled at the same time, it al=
lows
>                          * reading both types of symlinks, but will only =
create
>                          * them with mfsymlinks format. This allows bette=
r
> -                        * Apple compatibility (probably better for Samba=
 too)
> +                        * Apple compatibility, compatibility with older =
Linux
> +                        * kernel clients (probably better for Samba too)
>                          * while still recognizing old Windows style syml=
inks.
>                          */
>                         cifs_dbg(VFS, "mount options mfsymlinks and sfu b=
oth enabled\n");
> diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> index 80099bbb333b..47ddeb7fa111 100644
> --- a/fs/smb/client/link.c
> +++ b/fs/smb/client/link.c
> @@ -606,6 +606,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *i=
node,
>         /* BB what if DFS and this volume is on different share? BB */
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
>                 rc =3D create_mf_symlink(xid, pTcon, cifs_sb, full_path, =
symname);
> +       } else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> +               rc =3D __cifs_sfu_make_node(xid, inode, direntry, pTcon,
> +                                         full_path, S_IFLNK, 0, symname)=
;
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>         } else if (pTcon->unix_ext) {
>                 rc =3D CIFSUnixCreateSymLink(xid, pTcon, full_path, symna=
me,
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 9c2d065d3cc4..2c251e9a3a30 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5055,9 +5055,10 @@ static int smb2_next_header(struct TCP_Server_Info=
 *server, char *buf,
>         return 0;
>  }
>
> -static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> +int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
>                                 struct dentry *dentry, struct cifs_tcon *=
tcon,
> -                               const char *full_path, umode_t mode, dev_=
t dev)
> +                               const char *full_path, umode_t mode, dev_=
t dev,
> +                               const char *symname)
>  {
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         struct cifs_open_parms oparms;
> @@ -5065,30 +5066,64 @@ static int __cifs_sfu_make_node(unsigned int xid,=
 struct inode *inode,
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct cifs_fid fid;
>         unsigned int bytes_written;
> -       struct win_dev pdev =3D {};
> -       struct kvec iov[2];
> +       u8 type[8];
> +       int type_len =3D 0;
> +       struct {
> +               __le64 major;
> +               __le64 minor;
> +       } __packed pdev =3D {};
> +       __le16 *symname_utf16 =3D NULL;
> +       u8 *data =3D NULL;
> +       int data_len =3D 0;
> +       struct kvec iov[3];
>         __u32 oplock =3D server->oplocks ? REQ_OPLOCK : 0;
>         int rc;
>
>         switch (mode & S_IFMT) {
>         case S_IFCHR:
> -               memcpy(pdev.type, "IntxCHR\0", 8);
> +               type_len =3D 8;
> +               memcpy(type, "IntxCHR\0", type_len);
>                 pdev.major =3D cpu_to_le64(MAJOR(dev));
>                 pdev.minor =3D cpu_to_le64(MINOR(dev));
> +               data =3D (u8 *)&pdev;
> +               data_len =3D sizeof(pdev);
>                 break;
>         case S_IFBLK:
> -               memcpy(pdev.type, "IntxBLK\0", 8);
> +               type_len =3D 8;
> +               memcpy(type, "IntxBLK\0", type_len);
>                 pdev.major =3D cpu_to_le64(MAJOR(dev));
>                 pdev.minor =3D cpu_to_le64(MINOR(dev));
> +               data =3D (u8 *)&pdev;
> +               data_len =3D sizeof(pdev);
> +               break;
> +       case S_IFLNK:
> +               type_len =3D 8;
> +               memcpy(type, "IntxLNK\1", type_len);
> +               symname_utf16 =3D cifs_strndup_to_utf16(symname, strlen(s=
ymname),
> +                                                     &data_len, cifs_sb-=
>local_nls,
> +                                                     NO_MAP_UNI_RSVD);
> +               if (!symname_utf16) {
> +                       rc =3D -ENOMEM;
> +                       goto out;
> +               }
> +               data_len -=3D 2; /* symlink is without trailing wide-nul =
*/
> +               data =3D (u8 *)symname_utf16;
>                 break;
>         case S_IFSOCK:
> -               strscpy(pdev.type, "LnxSOCK");
> +               type_len =3D 8;
> +               strscpy(type, "LnxSOCK");
> +               data =3D (u8 *)&pdev;
> +               data_len =3D sizeof(pdev);
>                 break;
>         case S_IFIFO:
> -               strscpy(pdev.type, "LnxFIFO");
> +               type_len =3D 8;
> +               strscpy(type, "LnxFIFO");
> +               data =3D (u8 *)&pdev;
> +               data_len =3D sizeof(pdev);
>                 break;
>         default:
> -               return -EPERM;
> +               rc =3D -EPERM;
> +               goto out;
>         }
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
> @@ -5098,17 +5133,26 @@ static int __cifs_sfu_make_node(unsigned int xid,=
 struct inode *inode,
>
>         rc =3D server->ops->open(xid, &oparms, &oplock, NULL);
>         if (rc)
> -               return rc;
> +               goto out;
>
> -       io_parms.pid =3D current->tgid;
> -       io_parms.tcon =3D tcon;
> -       io_parms.length =3D sizeof(pdev);
> -       iov[1].iov_base =3D &pdev;
> -       iov[1].iov_len =3D sizeof(pdev);
> +       if (type_len + data_len > 0) {
> +               io_parms.pid =3D current->tgid;
> +               io_parms.tcon =3D tcon;
> +               io_parms.length =3D type_len + data_len;
> +               iov[1].iov_base =3D type;
> +               iov[1].iov_len =3D type_len;
> +               iov[2].iov_base =3D data;
> +               iov[2].iov_len =3D data_len;
> +
> +               rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> +                                            &bytes_written,
> +                                            iov, ARRAY_SIZE(iov)-1);
> +       }
>
> -       rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> -                                    &bytes_written, iov, 1);
>         server->ops->close(xid, tcon, &fid);
> +
> +out:
> +       kfree(symname_utf16);
>         return rc;
>  }
>
> @@ -5120,7 +5164,7 @@ int cifs_sfu_make_node(unsigned int xid, struct ino=
de *inode,
>         int rc;
>
>         rc =3D __cifs_sfu_make_node(xid, inode, dentry, tcon,
> -                                 full_path, mode, dev);
> +                                 full_path, mode, dev, NULL);
>         if (rc)
>                 return rc;
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
