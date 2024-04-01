Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87022576B
	for <linux-cifs@vger.kernel.org>; Mon,  1 Apr 2024 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711996949; cv=none; b=D6TtzqGGD4qHO0ZzROLO/I5GRmMafNzeS7R4B/33ZSy/0TeA0j1aQVMcyHOX1T0A/Rg8RmFjoPzG83pvPkGfM8fXJq8nyCnrf7I0316qilmqpVF5T9tlld8dEO3//zdDvZwG/zsIhu8wErbQsiwpQufy5fT8rL+1zyKkennOhnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711996949; c=relaxed/simple;
	bh=qr4zccKNF8OtnPIfq6dmjq8WrXOxgmnWYV5Hf5WAdgk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VzeipGpKQX4sQk6j3ND/3+IGcIAy/jZFkxRnWGAfNV0a/fS6bdWLw2U4K5iv5bDv0KsbAHNrbpyfJCiRXtpAwFzO6Vm03srZ4B0fB5m9rHwILAzL/o1eYKuWzxmayczRRoWy7+cZxq6H8Bk245b0Zh0488N141YQ0FSBkbrwNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVMpmhDE; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVMpmhDE"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d6ee81bc87so38522301fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 01 Apr 2024 11:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711996946; x=1712601746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMs3OnFs5QNra0270wiAsp82GCtS/TvXo/CMBRsiEuw=;
        b=BVMpmhDEZ/KE8ujbwf/sI7q/cJCZUnREJ38j/5KZmFPHuEXRCvRlD6QTikS2PPVoVS
         AHTZ344+h1hpWhPl5p8EcmjH32ZAjoOOSBnoIXz/mS7DExBdfa3IBjpF/fXahgRWHbl1
         sjJT0iWRCCxkTaGip1wDsZnFQPO3OlMJUYBb6l60HJsYk1LjpeWmDxXXVIiAIL/sFfXH
         j4ZcZRydAfjo61eCESBQ5AFEWmRwhEMQUFUNXJe5vyOaLdHYo4hO2+c+GP5nKB3ZU8IR
         Ii0QiV6XkAyGY58e+YZMdNXI6V2xQZAn4ukMtQBMP5pepFj3AAKh0CcPegi3zP+hcv0A
         Tgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711996946; x=1712601746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMs3OnFs5QNra0270wiAsp82GCtS/TvXo/CMBRsiEuw=;
        b=c75qQEhx+DE0Qf1kdgR4OyQKuImimZpbU96m70SJSwYTKj47nv6NN27+nbK21uPbh4
         2+p/7G8rfyXg2RvYYhPXMTe9Jap9g2jZejgrII9rnPwPRamoPsVNwjyik9a4vd6T34Ta
         tLur9dnMSXb+yTFV7GEbY1X27OMj7MZ718g3mJXpx5Q0pDkvA0rkQ0rPwFblAO7v9Npl
         PXMHX0vf6+ayQYgs66N3C6XcV0gHKUidy8DVdiE3Z8F5Swn3moinoTZ+mI2MXgL8CwpA
         PiBt9B2OrZY58xI2WUM0Uau1XTQm3cNjMi0cojtOcZj96JSPRgd/EtdAHPj5P9oAhB3X
         ecgA==
X-Gm-Message-State: AOJu0YxioZ8fUk8X4X7v55iL0p9dh0wKa3RoRXKMVuBPeTlzMhriKF8K
	IgEKCHnkYJBMRpaAwjsYefzUHt/eAmOmI8be5FmiBJTrJtacsrGsgkVCK64qkxZTbfIpgeT7hTL
	VE5MfQdsJU3zcMMm7aDPyz+vKFgjjW3S5
X-Google-Smtp-Source: AGHT+IEmoGAWQfHUw87ni6QBXo76ngF8g35S8yhGQoESNCfL/noxUj67XS6VkNTc9u6ZjS6K/opZkxQ9YDUrU9+sq3M=
X-Received: by 2002:a2e:8009:0:b0:2d8:b2e:7c09 with SMTP id
 j9-20020a2e8009000000b002d80b2e7c09mr3767141ljg.1.1711996944866; Mon, 01 Apr
 2024 11:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401170044.86991-1-pc@manguebit.com> <20240401171310.88213-1-pc@manguebit.com>
In-Reply-To: <20240401171310.88213-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 1 Apr 2024 13:42:13 -0500
Message-ID: <CAH2r5mtS4azO=qL-v+KVOVDq7CUSCEgzGapw16U0CVv8YUpU8A@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix UAF in smb2_reconnect_server()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending additional
testing and review

On Mon, Apr 1, 2024 at 12:13=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> The UAF bug is due to smb2_reconnect_server() accessing a session that
> is already being teared down by another thread that is executing
> __cifs_put_smb_ses().  This can happen when (a) the client has
> connection to the server but no session or (b) another thread ends up
> setting @ses->ses_status again to something different than
> SES_EXITING.
>
> To fix this, we need to make sure to unconditionally set
> @ses->ses_status to SES_EXITING and prevent any other threads from
> setting a new status while we're still tearing it down.
>
> The following can be reproduced by adding some delay to right after
> the ipc is freed in __cifs_put_smb_ses() - which will give
> smb2_reconnect_server() worker a chance to run and then accessing
> @ses->ipc:
>
> kinit ...
> mount.cifs //srv/share /mnt/1 -o sec=3Dkrb5,nohandlecache,echo_interval=
=3D10
> [disconnect srv]
> ls /mnt/1 &>/dev/null
> sleep 30
> kdestroy
> [reconnect srv]
> sleep 10
> umount /mnt/1
> ...
> CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> CIFS: VFS: \\srv Send error in SessSetup =3D -126
> CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> CIFS: VFS: \\srv Send error in SessSetup =3D -126
> general protection fault, probably for non-canonical address
> 0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc2 #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39
> 04/01/2014
> Workqueue: cifsiod smb2_reconnect_server [cifs]
> RIP: 0010:__list_del_entry_valid_or_report+0x33/0xf0
> Code: 4f 08 48 85 d2 74 42 48 85 c9 74 59 48 b8 00 01 00 00 00 00 ad
> de 48 39 c2 74 61 48 b8 22 01 00 00 00 00 74 69 <48> 8b 01 48 39 f8 75
> 7b 48 8b 72 08 48 39 c6 0f 85 88 00 00 00 b8
> RSP: 0018:ffffc900001bfd70 EFLAGS: 00010a83
> RAX: dead000000000122 RBX: ffff88810da53838 RCX: 6b6b6b6b6b6b6b6b
> RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc02f6878 RDI: ffff88810da53800
> RBP: ffff88810da53800 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810c064000
> R13: 0000000000000001 R14: ffff88810c064000 R15: ffff8881039cc000
> FS: 0000000000000000(0000) GS:ffff888157c00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe3728b1000 CR3: 000000010caa4000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? die_addr+0x36/0x90
>  ? exc_general_protection+0x1c1/0x3f0
>  ? asm_exc_general_protection+0x26/0x30
>  ? __list_del_entry_valid_or_report+0x33/0xf0
>  __cifs_put_smb_ses+0x1ae/0x500 [cifs]
>  smb2_reconnect_server+0x4ed/0x710 [cifs]
>  process_one_work+0x205/0x6b0
>  worker_thread+0x191/0x360
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xe2/0x110
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x34/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
> v1 -> v2: add missing comments in reproducer
>
>  fs/smb/client/connect.c | 87 +++++++++++++++++------------------------
>  1 file changed, 36 insertions(+), 51 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 9b85b5341822..ee29bc57300c 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -232,7 +232,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Ser=
ver_Info *server,
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_s=
es_list) {
> -               /* check if iface is still active */
> +               spin_lock(&ses->ses_lock);
> +               if (ses->ses_status =3D=3D SES_EXITING) {
> +                       spin_unlock(&ses->ses_lock);
> +                       continue;
> +               }
> +               spin_unlock(&ses->ses_lock);
> +
>                 spin_lock(&ses->chan_lock);
>                 if (cifs_ses_get_chan_index(ses, server) =3D=3D
>                     CIFS_INVAL_CHAN_INDEX) {
> @@ -1963,31 +1969,6 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_f=
s_context *ctx)
>         return rc;
>  }
>
> -/**
> - * cifs_free_ipc - helper to release the session IPC tcon
> - * @ses: smb session to unmount the IPC from
> - *
> - * Needs to be called everytime a session is destroyed.
> - *
> - * On session close, the IPC is closed and the server must release all t=
cons of the session.
> - * No need to send a tree disconnect here.
> - *
> - * Besides, it will make the server to not close durable and resilient f=
iles on session close, as
> - * specified in MS-SMB2 3.3.5.6 Receiving an SMB2 LOGOFF Request.
> - */
> -static int
> -cifs_free_ipc(struct cifs_ses *ses)
> -{
> -       struct cifs_tcon *tcon =3D ses->tcon_ipc;
> -
> -       if (tcon =3D=3D NULL)
> -               return 0;
> -
> -       tconInfoFree(tcon);
> -       ses->tcon_ipc =3D NULL;
> -       return 0;
> -}
> -
>  static struct cifs_ses *
>  cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context=
 *ctx)
>  {
> @@ -2019,48 +2000,52 @@ cifs_find_smb_ses(struct TCP_Server_Info *server,=
 struct smb3_fs_context *ctx)
>  void __cifs_put_smb_ses(struct cifs_ses *ses)
>  {
>         struct TCP_Server_Info *server =3D ses->server;
> +       struct cifs_tcon *tcon;
>         unsigned int xid;
>         size_t i;
> +       bool do_logoff;
>         int rc;
>
> -       spin_lock(&ses->ses_lock);
> -       if (ses->ses_status =3D=3D SES_EXITING) {
> -               spin_unlock(&ses->ses_lock);
> -               return;
> -       }
> -       spin_unlock(&ses->ses_lock);
> -
> -       cifs_dbg(FYI, "%s: ses_count=3D%d\n", __func__, ses->ses_count);
> -       cifs_dbg(FYI,
> -                "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon=
_ipc->tree_name : "NONE");
> -
>         spin_lock(&cifs_tcp_ses_lock);
> -       if (--ses->ses_count > 0) {
> +       spin_lock(&ses->ses_lock);
> +       cifs_dbg(FYI, "%s: id=3D0x%llx ses_count=3D%d ses_status=3D%u ipc=
=3D%s\n",
> +                __func__, ses->Suid, ses->ses_count, ses->ses_status,
> +                ses->tcon_ipc ? ses->tcon_ipc->tree_name : "none");
> +       if (ses->ses_status =3D=3D SES_EXITING || --ses->ses_count > 0) {
> +               spin_unlock(&ses->ses_lock);
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 return;
>         }
> -       spin_lock(&ses->ses_lock);
> -       if (ses->ses_status =3D=3D SES_GOOD)
> -               ses->ses_status =3D SES_EXITING;
> -       spin_unlock(&ses->ses_lock);
> -       spin_unlock(&cifs_tcp_ses_lock);
> -
>         /* ses_count can never go negative */
>         WARN_ON(ses->ses_count < 0);
>
> -       spin_lock(&ses->ses_lock);
> -       if (ses->ses_status =3D=3D SES_EXITING && server->ops->logoff) {
> -               spin_unlock(&ses->ses_lock);
> -               cifs_free_ipc(ses);
> +       spin_lock(&ses->chan_lock);
> +       cifs_chan_clear_need_reconnect(ses, server);
> +       spin_unlock(&ses->chan_lock);
> +
> +       do_logoff =3D ses->ses_status =3D=3D SES_GOOD && server->ops->log=
off;
> +       ses->ses_status =3D SES_EXITING;
> +       tcon =3D ses->tcon_ipc;
> +       ses->tcon_ipc =3D NULL;
> +       spin_unlock(&ses->ses_lock);
> +       spin_unlock(&cifs_tcp_ses_lock);
> +
> +       /*
> +        * On session close, the IPC is closed and the server must releas=
e all
> +        * tcons of the session.  No need to send a tree disconnect here.
> +        *
> +        * Besides, it will make the server to not close durable and resi=
lient
> +        * files on session close, as specified in MS-SMB2 3.3.5.6 Receiv=
ing an
> +        * SMB2 LOGOFF Request.
> +        */
> +       tconInfoFree(tcon);
> +       if (do_logoff) {
>                 xid =3D get_xid();
>                 rc =3D server->ops->logoff(xid, ses);
>                 if (rc)
>                         cifs_server_dbg(VFS, "%s: Session Logoff failure =
rc=3D%d\n",
>                                 __func__, rc);
>                 _free_xid(xid);
> -       } else {
> -               spin_unlock(&ses->ses_lock);
> -               cifs_free_ipc(ses);
>         }
>
>         spin_lock(&cifs_tcp_ses_lock);
> --
> 2.44.0
>


--=20
Thanks,

Steve
