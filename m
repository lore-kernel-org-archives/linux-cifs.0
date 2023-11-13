Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502EA3C065
	for <linux-cifs@vger.kernel.org>; Mon, 13 Nov 2023 22:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxHHWQ6t"
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9FDC;
	Mon, 13 Nov 2023 14:23:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-507ad511315so7144879e87.0;
        Mon, 13 Nov 2023 14:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699914203; x=1700519003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2lUqDXZqftceSAE/EIfmIXCfWy49ECBlUcQBJOXPgk=;
        b=KxHHWQ6tbKw7on611/3wJfYLYj1ku5ielIWjFfaG05Yr2W6xDTan6QvL1Ft/hL7nSQ
         uF4G4j5E+o/ZRLBA7Lyv/8dh1gEkRPYsqCsXpoSpx1YogZhpP2uOHctfdi/iac1aI2NS
         3M5NgE3QZMGrdCm760R/lsqz/fkoTNfthA3CnNQGQzeqP81ImHcnTgFjitPgSIIx3xKx
         VXCd2C/652jdP1oHnbwk/z1tIPoQscPTw0GiT5ADm0MXX5vc9SbV7Chu0rDcGJgUgUZn
         7VDJyidL9JPF1zGhDJcr2OPkmIdcfK8KbxJbK0BtT2PjieqjCPt3puuSUvrfXSbrQ+gp
         coTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699914203; x=1700519003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A2lUqDXZqftceSAE/EIfmIXCfWy49ECBlUcQBJOXPgk=;
        b=I9iJRcMHhOmQ/LzD/d8wd3GKm5NOIosiRxNZ/l2VoxlJLfPdWzR9GIGQEnXK/KS1Pw
         oV+7v5SCZMmuQJQdpumSg+HNRm5sJ+/6C+PlOW+UDHD3VYUoenal0O9IWqOw+e4wggE4
         8JmMqyGybbH5RoYi4r7ImbvP28B4KREgwV4grS0r6H47cbsRgSFq2h1ee2OJ9lI+JCPV
         TJeTN7iCLUWc2FA6LEUaqZvJADNOElGaKeqFM/gUMrOv8+LGs+fp4qot0K3Z6SCqLZnv
         Y5Q125gQqubESOyyJt2VpKxZhoKM91MXkDrkT5GLLgOU13KJfj1i8LzqI2WH/Oz1jRzp
         mZAg==
X-Gm-Message-State: AOJu0Ywr69YZLAytu/2kZPyISTC9a9zN2CmzljOnex9AvnVvBa9FCcEm
	D8O1QI2XCB0tuY7Lanvax8sG7kZuoFYxbV2gZQY=
X-Google-Smtp-Source: AGHT+IFr6X1XkLCqQA0hMWpN32lZWWNiSSsFNeVxo8xuLBlvHKHIMKV+WYspvbgfnHFpWcrYXaRyFd/HgvI3CP7hHyI=
X-Received: by 2002:a19:ae17:0:b0:506:926c:9b0d with SMTP id
 f23-20020a19ae17000000b00506926c9b0dmr4564696lfc.20.1699914202741; Mon, 13
 Nov 2023 14:23:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231113164241.32310-1-eesina@astralinux.ru>
In-Reply-To: <20231113164241.32310-1-eesina@astralinux.ru>
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Nov 2023 16:23:11 -0600
Message-ID: <CAH2r5mvSXmRx8j65hLZEpiHOs-72zDpUYF-uy4reR3R3vUzfZA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix check of rc in function generate_smb3signingkey
To: Ekaterina Esina <eesina@astralinux.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, Anastasia Belova <abelova@astralinux.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Nov 13, 2023 at 10:43=E2=80=AFAM Ekaterina Esina <eesina@astralinux=
.ru> wrote:
>
> Remove extra check after condition, add check after generating key
> for encryption. The check is needed to return non zero rc before
> rewriting it with generating key for decryption.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
> Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
> Co-developed-by: Anastasia Belova <abelova@astralinux.ru>
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> ---
>  fs/smb/client/smb2transport.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 84ea67301303..5a3ca62d2f07 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -458,6 +458,8 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                                   ptriplet->encryption.context,
>                                   ses->smb3encryptionkey,
>                                   SMB3_ENC_DEC_KEY_SIZE);
> +               if (rc)
> +                       return rc;
>                 rc =3D generate_key(ses, ptriplet->decryption.label,
>                                   ptriplet->decryption.context,
>                                   ses->smb3decryptionkey,
> @@ -466,9 +468,6 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                         return rc;
>         }
>
> -       if (rc)
> -               return rc;
> -
>  #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
>         cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func_=
_);
>         /*
> --
> 2.30.2
>
>


--=20
Thanks,

Steve
