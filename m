Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF9205AC1;
	Mon, 17 Mar 2025 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255514; cv=none; b=PYeu+G38D97coPGf6njHOOKCix2KZfyda6tc7apID+S4NTPI6VdvXwRmyIu1+w+887i24Kn7bGTt/J+c9Q7SHJyqb0G5VQ/zlVhmasNL/YcBR6a2uVOiNfdXRs7R2UEQPioiXAhmffWQp0Ibx5qL9QwKqBCyUl3yRUZRY/BLlFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255514; c=relaxed/simple;
	bh=W7JG7eJ2aWkeYlmK8iu4ChFEzLGDZwbcSCU58SnOqWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fTXnU3mHcq2ALGZRuA4SUa+wkGRvIqNDGHTNF5S2xih6rnTn5SlRqJ3yDF/HPKGNdV0K/xK2Sed8QNv3lgcNMiTdUH2959i7Wr/Ry/xjegUYWzDJ1avK3pMLVPyYg0SHIhI5izfozLEvOWkSEoR0Wt1IcRW9cNnGibqgJFHHz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iqtntytc; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iqtntytc"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-30beedb99c9so45546731fa.3;
        Mon, 17 Mar 2025 16:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742255511; x=1742860311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrBORXB5rVNSStbpGpwaCLo3Te5UtqGzW5H6VysXPyw=;
        b=IqtntytcCQsvAfBEbB6ilmh8t1q+q8I1c47vaIORbX4TIwMdhGPImvILxhBRH9HG3u
         Ti+2dCdv1BGROq2ObVibG6BUKb957wen+2OOologs88uZzlcOxkLVjHEyAlqGyAxMP3/
         jZL2NlndyYex/JXade1BOMEIaXzICtb6fvVuvR4bKI6M45f/1FexuqNOEfepwBedE+Yc
         MypAQajQyFpRGgDGWzcnBVLfg5/WZ8GmbfEjiT/m9tS/t4pcCJQF9JDk/vK6bi/0utIO
         rdCt3stjLLleOkZUOAy4flQ0DLXeaQiasHOIF36OrTFEETk8zd2kWH/bKRBsT7/SzOoj
         XQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742255511; x=1742860311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrBORXB5rVNSStbpGpwaCLo3Te5UtqGzW5H6VysXPyw=;
        b=XJopc8K0f4m6MSvJ/azdjhZlhpxu8coOcYVGcEwbBejokxq52vNbwncGQdtHE+Kawi
         KAs4GJK2rsPiYtz5XPAswm9KTwM7Xk3yfaAqJUs96lMKn4DbXmbbCiWJd9VJvuWatCKv
         MOPMlBKsAxBKN6OVfitddsIULRrwyZcrzDxNCmXleeFto4LmNxtvKxAH9VH28yJcKEBJ
         e53Mz1k5m00ncLMq+IPws+94Nh+Lc7xsMmlyPKMFEV0Aj8CuSfkLgVe6McgneMcDqAuB
         t4dElyvpnlpVX/EGHCRslMASV+8OUZ9dB+SdDFafhDJoEMbUTOOx1X/QesnhH90lSkaz
         NnMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1mIjEk/LctFdRm5lky9BxAF1JmFLGixhQAWc1PX5laIenNwy+I0lmaz5DVm4UWvfFSRaqnLouIgO/@vger.kernel.org, AJvYcCXcrxDbNZdCDc/SxOOEhS8DSPF+ZsS/QvMbV5e2BfadGUm2nALTv0dUVUB/Sx9bMxyLPRNsoirooB2VmgA9@vger.kernel.org
X-Gm-Message-State: AOJu0YybeKIiCfO2W5Gy9VJwd1not81H8U7okMEksUaaKlfk8CuROIle
	7uD/eEAdEWRfbicCnECnwqks1Zh90I3xiTuWSzrTZEb6w9cHQUPTNEkQwc6uhBBKBY20gPVbm+z
	TWRp509NZtjNPPozmjy2E6pHaMmQ=
X-Gm-Gg: ASbGncukTafKhdN7Av3auP6vzN++A8td6S9D1HaZLOnEpSFvK6p/9zCeCY+5G6vErFb
	V23auBmShg1nzRNnzlKkkgHTHNwov7m84r+eYYren8O7Eo8aKZ7i85dj6WKkS4TWPhZb1wlz5DF
	HuW2yCjEbT6BC2tZYegl5OFzlZnGGkDtweutzMUJE0y7CLSGNDMHgOcrGKJ8A=
X-Google-Smtp-Source: AGHT+IFJRlaXuYU5HaNxFuHLK4gwNm8IMoNUdEXbl+RJG0FG4H/1U6jGoe3AvVyP4HOsNboQlvozKZIcYSP5YLWR/28=
X-Received: by 2002:a05:6512:2345:b0:549:4d7d:b61b with SMTP id
 2adb3069b0e04-54a03cf4dddmr1782307e87.35.1742255510341; Mon, 17 Mar 2025
 16:51:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317083915.20004-1-chunjie.zhu@cloud.com>
In-Reply-To: <20250317083915.20004-1-chunjie.zhu@cloud.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Mar 2025 18:51:39 -0500
X-Gm-Features: AQ5f1JrEQ1Pw0sXu7tJidiw44xYb6j4T_MP9tYTExTR0x3vMnxdeX9ZVEj5cUQ8
Message-ID: <CAH2r5mt4ej2EtMHAc9Vro325XoMA++iktxcx28k1OGte_sxhVg@mail.gmail.com>
Subject: Re: [PATCH] open hardlink on deferred close file return EINVAL
To: Chunjie Zhu <chunjie.zhu@cloud.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, ross.lagerwall@cloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tried out the patch and it does fix getting STATUS_INVALID_PARAMETER
error from the server, but doesn't fix the issue of getting EINVAL

Traceback (most recent call last):
  File "/root/hl-test.py", line 15, in <module>
    newfd =3D os.open('new', os.O_RDONLY|os.O_DIRECT)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
OSError: [Errno 22] Invalid argument: 'new'

It is fixed by running with leases disable (via mount parm), but
wouldn't it be better to fix the error so apps don't break.  Ideas?

On Mon, Mar 17, 2025 at 3:41=E2=80=AFAM Chunjie Zhu <chunjie.zhu@cloud.com>=
 wrote:
>
> The following Python script results in unexpected behaviour when run on
> a CIFS filesystem against a Windows Server:
>
>     # Create file
>     fd =3D os.open('test', os.O_WRONLY|os.O_CREAT)
>     os.write(fd, b'foo')
>     os.close(fd)
>
>     # Open and close the file to leave a pending deferred close
>     fd =3D os.open('test', os.O_RDONLY|os.O_DIRECT)
>     os.close(fd)
>
>     # Try to open the file via a hard link
>     os.link('test', 'new')
>     newfd =3D os.open('new', os.O_RDONLY|os.O_DIRECT)
>
> The final open returns EINVAL due to the server returning
> STATUS_INVALID_PARAMETER. The root cause of this is that the client
> caches lease keys per inode, but the spec requires them to be related to
> the filename which causes problems when hard links are involved:
>
> From MS-SMB2 section 3.3.5.9.11:
>
> "The server MUST attempt to locate a Lease by performing a lookup in the
> LeaseTable.LeaseList using the LeaseKey in the
> SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
> Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the
> file name for the incoming request, the request MUST be failed with
> STATUS_INVALID_PARAMETER"
>
> The client side can return EINVAL directly without invoking server
> operations. This reduces client server network communication overhead.
>
> Signed-off-by: Chunjie Zhu <chunjie.zhu@cloud.com>
> ---
>  fs/smb/client/cifsproto.h |  2 ++
>  fs/smb/client/file.c      | 29 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 260a6299bddb..b563c227792e 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -157,6 +157,8 @@ extern int cifs_get_writable_path(struct cifs_tcon *t=
con, const char *name,
>  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, b=
ool);
>  extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *na=
me,
>                                   struct cifsFileInfo **ret_file);
> +extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *=
inode,
> +                                 struct file *file);
>  extern unsigned int smbCalcSize(void *buf);
>  extern int decode_negTokenInit(unsigned char *security_blob, int length,
>                         struct TCP_Server_Info *server);
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 4cbb5487bd8d..0a66cce6e0ff 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -751,6 +751,12 @@ int cifs_open(struct inode *inode, struct file *file=
)
>                 } else {
>                         _cifsFileInfo_put(cfile, true, false);
>                 }
> +       } else {
> +               /* hard link on the defeered close file */
> +               rc =3D cifs_get_hardlink_path(tcon, inode, file);
> +               if (rc) {
> +                       goto out;
> +               }
>         }
>
>         if (server->oplocks)
> @@ -2413,6 +2419,29 @@ cifs_get_readable_path(struct cifs_tcon *tcon, con=
st char *name,
>         return -ENOENT;
>  }
>
> +int
> +cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
> +                               struct file *file)
> +{
> +       struct cifsFileInfo *open_file =3D NULL;
> +       struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> +       int rc =3D 0;
> +
> +       spin_lock(&tcon->open_file_lock);
> +       spin_lock(&cinode->open_file_lock);
> +
> +       list_for_each_entry(open_file, &cinode->openFileList, flist) {
> +               if (file->f_flags =3D=3D open_file->f_flags) {
> +                       rc =3D -EINVAL;
> +                       break;
> +               }
> +       }
> +
> +       spin_unlock(&cinode->open_file_lock);
> +       spin_unlock(&tcon->open_file_lock);
> +       return rc;
> +}
> +
>  void
>  cifs_writedata_release(struct kref *refcount)
>  {
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
