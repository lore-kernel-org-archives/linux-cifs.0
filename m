Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4A9C4707A
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 19:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E4B613D9
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 19:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhEUTss (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 15:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhEUTsr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 15:48:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D44C061574
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 12:47:23 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e11so25252074ljn.13
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 12:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XUFlyf5t1aoQYeRdWmP2XtkXYf0b83vDLr8lxIhiUG0=;
        b=Z4Nqj0J+ZFgOdC7RQVTps74Bw+RbraTJipb6s/uCzvlQCV9ME1oYzk9s8GMedlYZtV
         Dt+zrL3g5JNF3SvMwZqN80/wSww0ZFH7hlTSzLTh4A58rXSnEgRuCRfqvwdfXPispZvO
         73d0aggwb3Jf6E1viO0KcAdhUEfbhnTJflsmUwpJuhBIO83zwY4FAYq0XIcCtLA8D4aD
         Cr7ngyJv1bSDfHZDmdaMKKcsaA8nCHR/fXhsBsHt/d+lV1vls4YKrVwaX0bEOBHtzoDq
         rmepIigd3fY5c8lhYp0u01ucL58/3KGusyZLegIvI+bM4Epw/MQBQ5W0Hz2eYRTQa51z
         7yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XUFlyf5t1aoQYeRdWmP2XtkXYf0b83vDLr8lxIhiUG0=;
        b=XLguSK9Z9sdX/H4lsQ82NVKR0KilY78/orR+9vX7EUMX2Ryj+2wkkyCSF3PznE5Nmo
         VFttStyGZA5NMuMgXtWKXzzqAR4xJYqGyUKrZFaJ0TCUb+AkDgow1QBAgwHwWokED94o
         1aHA3Gfcv4C9Hbvk+bp0qMXFEGEZD2wBiTHHcKXI+Mn0DKCtv6e0wt7j36cpVVOzq78u
         gBB1UMN8eK/FGcBAXP56wtOiOPSoIJ9nqMExr45wONKBE3Z40u61u1bSk8QIAjg2+uTs
         Sr4f8ZS3Y6fiyvW422DfSW5ty8fPU28k3Ni0OQDNdd8AE3YxQeIM8UGrJTXrx6PkxJEt
         1IcQ==
X-Gm-Message-State: AOAM533t8vSsneRootgwFpAB4GnwgBSFqLvCw5dBKW7O7gcY7zPpkuWV
        8w75w5lsoE+1B0IA6UlJuDJUQB/rHUI14t6u6lpY2P0Cw7Oykg==
X-Google-Smtp-Source: ABdhPJyUoEn3/gx+UsY7PjRqsf2bseikxBanOmDNBfuN3TgciF7kQm73VhB7GEhgk5kzHlwFC4cztrgEFy3SxcH0hhU=
X-Received: by 2002:a2e:7819:: with SMTP id t25mr7867713ljc.406.1621626441583;
 Fri, 21 May 2021 12:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210521151928.17730-1-aaptel@suse.com> <20210521151928.17730-3-aaptel@suse.com>
In-Reply-To: <20210521151928.17730-3-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 May 2021 14:47:10 -0500
Message-ID: <CAH2r5msMs=HL_39YU8SF+-Hk6jTSGnZBuP26BfiNUb+vKGxerQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] cifs: change format of CIFS_FULL_KEY_DUMP ioctl
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Two trivial checkpatch nits:

WARNING: Block comments should align the * on each line
#155: FILE: fs/cifs/cifs_ioctl.h:96:
+ * __u8 server_out_key[server_out_key_length];
+ */

ERROR: "foo* bar" should be "foo *bar"
#190: FILE: fs/cifs/ioctl.c:218:
+static int cifs_dump_full_key(struct cifs_tcon *tcon, struct
smb3_full_key_debug_info __user* i

On Fri, May 21, 2021 at 10:19 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Make CIFS_FULL_KEY_DUMP ioctl able to return variable-length keys.
>
> * userspace needs to pass the struct size along with optional
>   session_id and some space at the end to store keys
> * if there is enough space kernel returns keys in the extra space and
>   sets the length of each key via xyz_key_length fields
>
> This also fixes the build error for get_user() on ARM.
>
> Sample program:
>
>         #include <stdlib.h>
>         #include <stdio.h>
>         #include <stdint.h>
>         #include <sys/fcntl.h>
>         #include <sys/ioctl.h>
>
>         struct smb3_full_key_debug_info {
>                 uint32_t   in_size;
>                 uint64_t   session_id;
>                 uint16_t   cipher_type;
>                 uint8_t    session_key_length;
>                 uint8_t    server_in_key_length;
>                 uint8_t    server_out_key_length;
>                 uint8_t    data[];
>                 /*
>                  * return this struct with the keys appended at the end:
>                  * uint8_t session_key[session_key_length];
>                  * uint8_t server_in_key[server_in_key_length];
>                  * uint8_t server_out_key[server_out_key_length];
>                  */
>         } __attribute__((packed));
>
>         #define CIFS_IOCTL_MAGIC 0xCF
>         #define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct smb=
3_full_key_debug_info)
>
>         void dump(const void *p, size_t len) {
>                 const char *hex =3D "0123456789ABCDEF";
>                 const uint8_t *b =3D p;
>                 for (int i =3D 0; i < len; i++)
>                         printf("%c%c ", hex[(b[i]>>4)&0xf], hex[b[i]&0xf]=
);
>                 putchar('\n');
>         }
>
>         int main(int argc, char **argv)
>         {
>                 struct smb3_full_key_debug_info *keys;
>                 uint8_t buf[sizeof(*keys)+1024] =3D {0};
>                 size_t off =3D 0;
>                 int fd, rc;
>
>                 keys =3D (struct smb3_full_key_debug_info *)&buf;
>                 keys->in_size =3D sizeof(buf);
>
>                 fd =3D open(argv[1], O_RDONLY);
>                 if (fd < 0)
>                         perror("open"), exit(1);
>
>                 rc =3D ioctl(fd, CIFS_DUMP_FULL_KEY, keys);
>                 if (rc < 0)
>                         perror("ioctl"), exit(1);
>
>                 printf("SessionId      ");
>                 dump(&keys->session_id, 8);
>                 printf("Cipher         %04x\n", keys->cipher_type);
>
>                 printf("SessionKey     ");
>                 dump(keys->data+off, keys->session_key_length);
>                 off +=3D keys->session_key_length;
>
>                 printf("ServerIn Key   ");
>                 dump(keys->data+off, keys->server_in_key_length);
>                 off +=3D keys->server_in_key_length;
>
>                 printf("ServerOut Key  ");
>                 dump(keys->data+off, keys->server_out_key_length);
>
>                 return 0;
>         }
>
> Usage:
>
>         $ gcc -o dumpkeys dumpkeys.c
>
> Against Windows Server 2020 preview (with AES-256-GCM support):
>
>         # mount.cifs //$ip/test /mnt -o "username=3Dadministrator,passwor=
d=3Dfoo,vers=3D3.0,seal"
>         # ./dumpkeys /mnt/somefile
>         SessionId      0D 00 00 00 00 0C 00 00
>         Cipher         0002
>         SessionKey     AB CD CC 0D E4 15 05 0C 6F 3C 92 90 19 F3 0D 25
>         ServerIn Key   73 C6 6A C8 6B 08 CF A2 CB 8E A5 7D 10 D1 5B DC
>         ServerOut Key  6D 7E 2B A1 71 9D D7 2B 94 7B BA C4 F0 A5 A4 F8
>         # umount /mnt
>
>         With 256 bit keys:
>
>         # echo 1 > /sys/module/cifs/parameters/require_gcm_256
>         # mount.cifs //$ip/test /mnt -o "username=3Dadministrator,passwor=
d=3Dfoo,vers=3D3.11,seal"
>         # ./dumpkeys /mnt/somefile
>         SessionId      09 00 00 00 00 0C 00 00
>         Cipher         0004
>         SessionKey     93 F5 82 3B 2F B7 2A 50 0B B9 BA 26 FB 8C 8B 03
>         ServerIn Key   6C 6A 89 B2 CB 7B 78 E8 04 93 37 DA 22 53 47 DF B3=
 2C 5F 02 26 70 43 DB 8D 33 7B DC 66 D3 75 A9
>         ServerOut Key  04 11 AA D7 52 C7 A8 0F ED E3 93 3A 65 FE 03 AD 3F=
 63 03 01 2B C0 1B D7 D7 E5 52 19 7F CC 46 B4
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifs_ioctl.h |  25 ++++++--
>  fs/cifs/cifspdu.h    |   3 +-
>  fs/cifs/ioctl.c      | 143 +++++++++++++++++++++++++++++++------------
>  3 files changed, 126 insertions(+), 45 deletions(-)
>
> diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> index 4a97fe12006b..4b3d33b2838d 100644
> --- a/fs/cifs/cifs_ioctl.h
> +++ b/fs/cifs/cifs_ioctl.h
> @@ -72,15 +72,28 @@ struct smb3_key_debug_info {
>  } __packed;
>
>  /*
> - * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> - * is needed if GCM256 (stronger encryption) negotiated
> + * Dump variable-sized keys
>   */
>  struct smb3_full_key_debug_info {
> -       __u64   Suid;
> +       /* INPUT: size of userspace buffer */
> +       __u32   in_size;
> +
> +       /*
> +        * INPUT: 0 for current user, otherwise session to dump
> +        * OUTPUT: session id that was dumped
> +        */
> +       __u64   session_id;
>         __u16   cipher_type;
> -       __u8    auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> -       __u8    smb3encryptionkey[32]; /* SMB3_ENC_DEC_KEY_SIZE */
> -       __u8    smb3decryptionkey[32]; /* SMB3_ENC_DEC_KEY_SIZE */
> +       __u8    session_key_length;
> +       __u8    server_in_key_length;
> +       __u8    server_out_key_length;
> +       __u8    data[];
> +       /*
> +        * return this struct with the keys appended at the end:
> +        * __u8 session_key[session_key_length];
> +        * __u8 server_in_key[server_in_key_length];
> +        * __u8 server_out_key[server_out_key_length];
> +       */
>  } __packed;
>
>  struct smb3_notify {
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b53a87db282f..554d64fe171e 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -148,7 +148,8 @@
>  #define SMB3_SIGN_KEY_SIZE (16)
>
>  /*
> - * Size of the smb3 encryption/decryption keys
> + * Size of the smb3 encryption/decryption key storage.
> + * This size is big enough to store any cipher key types.
>   */
>  #define SMB3_ENC_DEC_KEY_SIZE (32)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 28ec8d7c521a..87b2f1309e6f 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -33,6 +33,7 @@
>  #include "cifsfs.h"
>  #include "cifs_ioctl.h"
>  #include "smb2proto.h"
> +#include "smb2glob.h"
>  #include <linux/btrfs.h>
>
>  static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
> @@ -214,48 +215,112 @@ static int cifs_shutdown(struct super_block *sb, u=
nsigned long arg)
>         return 0;
>  }
>
> -static int cifs_dump_full_key(struct cifs_tcon *tcon, unsigned long arg)
> +static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_k=
ey_debug_info __user* in)
>  {
> -       struct smb3_full_key_debug_info pfull_key_inf;
> -       __u64 suid;
> -       struct list_head *tmp;
> +       struct smb3_full_key_debug_info out;
>         struct cifs_ses *ses;
> +       int rc =3D 0;
>         bool found =3D false;
> +       u8 __user *end;
>
> -       if (!smb3_encryption_required(tcon))
> -               return -EOPNOTSUPP;
> +       if (!smb3_encryption_required(tcon)) {
> +               rc =3D -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       /* copy user input into our output buffer */
> +       if (copy_from_user(&out, in, sizeof(out))) {
> +               rc =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       if (!out.session_id) {
> +               /* if ses id is 0, use current user session */
> +               ses =3D tcon->ses;
> +       } else {
> +               /* otherwise if a session id is given, look for it in all=
 our sessions */
> +               struct cifs_ses *ses_it =3D NULL;
> +               struct TCP_Server_Info *server_it =3D NULL;
>
> -       ses =3D tcon->ses; /* default to user id for current user */
> -       if (get_user(suid, (__u64 __user *)arg))
> -               suid =3D 0;
> -       if (suid) {
> -               /* search to see if there is a session with a matching SM=
B UID */
>                 spin_lock(&cifs_tcp_ses_lock);
> -               list_for_each(tmp, &tcon->ses->server->smb_ses_list) {
> -                       ses =3D list_entry(tmp, struct cifs_ses, smb_ses_=
list);
> -                       if (ses->Suid =3D=3D suid) {
> -                               found =3D true;
> -                               break;
> +               list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_se=
s_list) {
> +                       list_for_each_entry(ses_it, &server_it->smb_ses_l=
ist, smb_ses_list) {
> +                               if (ses_it->Suid =3D=3D out.session_id) {
> +                                       ses =3D ses_it;
> +                                       /*
> +                                        * since we are using the session=
 outside the crit
> +                                        * section, we need to make sure =
it won't be released
> +                                        * so increment its refcount
> +                                        */
> +                                       ses->ses_count++;
> +                                       found =3D true;
> +                                       goto search_end;
> +                               }
>                         }
>                 }
> +search_end:
>                 spin_unlock(&cifs_tcp_ses_lock);
> -               if (found =3D=3D false)
> -                       return -EINVAL;
> -       } /* else uses default user's SMB UID (ie current user) */
> -
> -       pfull_key_inf.cipher_type =3D le16_to_cpu(ses->server->cipher_typ=
e);
> -       pfull_key_inf.Suid =3D ses->Suid;
> -       memcpy(pfull_key_inf.auth_key, ses->auth_key.response,
> -              16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
> -       memcpy(pfull_key_inf.smb3decryptionkey, ses->smb3decryptionkey,
> -              32 /* SMB3_ENC_DEC_KEY_SIZE */);
> -       memcpy(pfull_key_inf.smb3encryptionkey,
> -              ses->smb3encryptionkey, 32 /* SMB3_ENC_DEC_KEY_SIZE */);
> -       if (copy_to_user((void __user *)arg, &pfull_key_inf,
> -                        sizeof(struct smb3_full_key_debug_info)))
> -               return -EFAULT;
> +               if (!found) {
> +                       rc =3D -ENOENT;
> +                       goto out;
> +               }
> +       }
>
> -       return 0;
> +       switch (ses->server->cipher_type) {
> +       case SMB2_ENCRYPTION_AES128_CCM:
> +       case SMB2_ENCRYPTION_AES128_GCM:
> +               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
> +               out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM128_CRYPTKEY_SIZE;
> +               break;
> +       case SMB2_ENCRYPTION_AES256_CCM:
> +       case SMB2_ENCRYPTION_AES256_GCM:
> +               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
> +               out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM256_CRYPTKEY_SIZE;
> +               break;
> +       default:
> +               rc =3D -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       /* check if user buffer is big enough to store all the keys */
> +       if (out.in_size < sizeof(out) + out.session_key_length + out.serv=
er_in_key_length
> +           + out.server_out_key_length) {
> +               rc =3D -ENOBUFS;
> +               goto out;
> +       }
> +
> +       out.session_id =3D ses->Suid;
> +       out.cipher_type =3D le16_to_cpu(ses->server->cipher_type);
> +
> +       /* overwrite user input with our output */
> +       if (copy_to_user(in, &out, sizeof(out))) {
> +               rc =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       /* append all the keys at the end of the user buffer */
> +       end =3D in->data;
> +       if (copy_to_user(end, ses->auth_key.response, out.session_key_len=
gth)) {
> +               rc =3D -EINVAL;
> +               goto out;
> +       }
> +       end +=3D out.session_key_length;
> +
> +       if (copy_to_user(end, ses->smb3encryptionkey, out.server_in_key_l=
ength)) {
> +               rc =3D -EINVAL;
> +               goto out;
> +       }
> +       end +=3D out.server_in_key_length;
> +
> +       if (copy_to_user(end, ses->smb3decryptionkey, out.server_out_key_=
length)) {
> +               rc =3D -EINVAL;
> +               goto out;
> +       }
> +
> +out:
> +       if (found)
> +               cifs_put_smb_ses(ses);
> +       return rc;
>  }
>
>  long cifs_ioctl(struct file *filep, unsigned int command, unsigned long =
arg)
> @@ -371,6 +436,10 @@ long cifs_ioctl(struct file *filep, unsigned int com=
mand, unsigned long arg)
>                                 rc =3D -EOPNOTSUPP;
>                         break;
>                 case CIFS_DUMP_KEY:
> +                       /*
> +                        * Dump encryption keys. This is an old ioctl tha=
t only
> +                        * handles AES-128-{CCM,GCM}.
> +                        */
>                         if (pSMBFile =3D=3D NULL)
>                                 break;
>                         if (!capable(CAP_SYS_ADMIN)) {
> @@ -398,11 +467,10 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
>                         else
>                                 rc =3D 0;
>                         break;
> -               /*
> -                * Dump full key (32 bytes instead of 16 bytes) is
> -                * needed if GCM256 (stronger encryption) negotiated
> -                */
>                 case CIFS_DUMP_FULL_KEY:
> +                       /*
> +                        * Dump encryption keys (handles any key sizes)
> +                        */
>                         if (pSMBFile =3D=3D NULL)
>                                 break;
>                         if (!capable(CAP_SYS_ADMIN)) {
> @@ -410,8 +478,7 @@ long cifs_ioctl(struct file *filep, unsigned int comm=
and, unsigned long arg)
>                                 break;
>                         }
>                         tcon =3D tlink_tcon(pSMBFile->tlink);
> -                       rc =3D cifs_dump_full_key(tcon, arg);
> -
> +                       rc =3D cifs_dump_full_key(tcon, (void __user *)ar=
g);
>                         break;
>                 case CIFS_IOC_NOTIFY:
>                         if (!S_ISDIR(inode->i_mode)) {
> --
> 2.31.1
>


--=20
Thanks,

Steve
