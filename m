Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6745BF1
	for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 23:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pgbk6RCS"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50be24167efso1412162e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 15:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702682124; x=1703286924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eg2NoMpBOtEUIvY2c/w3EZbXyfydPcuUhT2G3GTFovY=;
        b=Pgbk6RCSqt1YoMMGXJjhC5d4/bOWlFQjg9yDzlLpLfYkEgKuwP580dxJlSVveINVX5
         HO4XXW+4JJHylx5ITgKpiLcGZ2et140X7nuHTNYtSTNfalOJtXcXOJU4qkNTmR3gLAm4
         b/Phprp/2AIvZyPFQ5WKqwmH2dBIIou4w7zjiRHqFgEqxXnOA6n+ICmwB6/d4G9e4Mju
         gSxQ5T2UdCk4dXz8hyMaZ1y/YtVrY8N8H7PVecE32e3sJzTstXCOLzN6xedB8QuqRmBc
         JEvwJOs/GOtKmnGrUGXgqtvKkV1bB0wxy1UEjz9tqiUre40tzGpBRnWu2OWGZj+qHPVi
         7Hpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702682124; x=1703286924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eg2NoMpBOtEUIvY2c/w3EZbXyfydPcuUhT2G3GTFovY=;
        b=deXIsovWQhKVmiNKUTBqbjhwgOKyEC1s9E/fwJ+qkhFy6cnefJJ0KZtbqQX/g9ZnsM
         wmo37jfMGNBM/SE8D/tsHi+EkW1HMnjHj8HFNhM9jkSDFVkJ3NtwnDZOkZgu+SFXpiIe
         t8h3jxytTixRIexsXqMY9PHcevctf8A5vnIpq3bPDXwzvDkDv5JfY5DpwZWjrwVx87VG
         R7ISmAUFxb712qAzVkJZBrMzREZOyQBI6VwCHP7sttUN0wOk/mgvNF+Fuj12tvaY8mLv
         riuEjdBh9PQ9quF1hsyJ24TtME20JXdcZyAbjnHETaeQyF7n8KRwyJ79TU3FWapL//6C
         nTaA==
X-Gm-Message-State: AOJu0Yxto/gOxyA9pbNYQqJt6ULQ25xpdymiUf3RwDej584d/PFcQ74Y
	Ugdjjyze8aKH89N6u6whWn/R3+kJUVIuwLoc9xQ=
X-Google-Smtp-Source: AGHT+IEUpoyt8RCk4+pq7FQod0ggPNYXjGWt2YbS3hwFyiJUJv3/bkpS67fnvQQd6aD44Zd/GFR4sFdv7GzwldU2oC4=
X-Received: by 2002:ac2:4e14:0:b0:50b:f62c:7f27 with SMTP id
 e20-20020ac24e14000000b0050bf62c7f27mr4094292lfr.24.1702682123564; Fri, 15
 Dec 2023 15:15:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215225914.20065-1-pc@manguebit.com>
In-Reply-To: <20231215225914.20065-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Dec 2023 17:15:12 -0600
Message-ID: <CAH2r5mtet6j=jJprtyszd7kBJ7YKDz8c1iAK4uh6ErPU5+n1zQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix OOB in smbCalcSize()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, j51569436@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.  updated cifs-2.6.git for-next with this patch and added Cc: st=
able

On Fri, Dec 15, 2023 at 4:59=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Validate @smb->WordCount to avoid reading off the end of @smb and thus
> causing the following KASAN splat:
>
>   BUG: KASAN: slab-out-of-bounds in smbCalcSize+0x32/0x40 [cifs]
>   Read of size 2 at addr ffff88801c024ec5 by task cifsd/1328
>
>   CPU: 1 PID: 1328 Comm: cifsd Not tainted 6.7.0-rc5 #9
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>   rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x4a/0x80
>    print_report+0xcf/0x650
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? __phys_addr+0x46/0x90
>    kasan_report+0xd8/0x110
>    ? smbCalcSize+0x32/0x40 [cifs]
>    ? smbCalcSize+0x32/0x40 [cifs]
>    kasan_check_range+0x105/0x1b0
>    smbCalcSize+0x32/0x40 [cifs]
>    checkSMB+0x162/0x370 [cifs]
>    ? __pfx_checkSMB+0x10/0x10 [cifs]
>    cifs_handle_standard+0xbc/0x2f0 [cifs]
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    cifs_demultiplex_thread+0xed1/0x1360 [cifs]
>    ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? lockdep_hardirqs_on_prepare+0x136/0x210
>    ? __pfx_lock_release+0x10/0x10
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? mark_held_locks+0x1a/0x90
>    ? lockdep_hardirqs_on_prepare+0x136/0x210
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? __kthread_parkme+0xce/0xf0
>    ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
>    kthread+0x18d/0x1d0
>    ? kthread+0xdb/0x1d0
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork+0x34/0x60
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork_asm+0x1b/0x30
>    </TASK>
>
> This fixes CVE-2023-6606.
>
> Reported-by: j51569436@gmail.com
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D218218
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/misc.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 35b176457bbe..c2137ea3c253 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -363,6 +363,10 @@ checkSMB(char *buf, unsigned int total_read, struct =
TCP_Server_Info *server)
>                         cifs_dbg(VFS, "Length less than smb header size\n=
");
>                 }
>                 return -EIO;
> +       } else if (total_read < sizeof(*smb) + 2 * smb->WordCount) {
> +               cifs_dbg(VFS, "%s: can't read BCC due to invalid WordCoun=
t(%u)\n",
> +                        __func__, smb->WordCount);
> +               return -EIO;
>         }
>
>         /* otherwise, there is enough to get to the BCC */
> --
> 2.43.0
>


--=20
Thanks,

Steve
