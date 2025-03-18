Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6261A3178
	for <linux-cifs@vger.kernel.org>; Tue, 18 Mar 2025 04:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742271576; cv=none; b=VTrTjRPOI9PxUkYvrDe2hn/03rIbCQA1ky2HSJdY/CsrEJ4fAzUO1inOV1cmDvcVG7yMDlBUW1hbRRvTjmJrXrVg1ed1UOcqwnWVzGsoLkOkI25T4oEKxVWuEN8uwWM0nsk+Vvw926lS40mjokDHqmrYN1u4QxJyJJFX5usUYdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742271576; c=relaxed/simple;
	bh=n6ibhkTa8qohJz0kOTvrszotQl5KJnYrEqCXiNFqTK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hL2mg6KOrgzpoLaIWvPrTYgWvrjDQWEdDCo7PG48GYZu62fVQsVBnRVOOSpleYuqF1dPyttNlBKy4neeMVq/KMPexTxdwhuwyW4m/xzdz7LGOVwWUeoQt7y35DDUfCHKjTJt6T0h5XYN18QtHymLe9934/4Oanp0VU2OlDiP/ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=g4yLozHi; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="g4yLozHi"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff80290debso4267250a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 21:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1742271574; x=1742876374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXGRKBO6OOqziz7wYr6boX6M47WYGmCz6Md3kdfNEak=;
        b=g4yLozHiLc71ji2eF59zK7PeOkAnkWs+wThbJLNRnZsjCP6OO2DFzQTKZKGD1iIfN6
         qOxPP5urLYzCY1MwrvqiBfKBdsX662oWru9Kq6r3bhhaAkxGrzhrmDSNt0hFPj7iw3O1
         5o3iSXxFusH3lAL0akee2B8o51XdtzI3rDxSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742271574; x=1742876374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sXGRKBO6OOqziz7wYr6boX6M47WYGmCz6Md3kdfNEak=;
        b=GJcKdEqNJ827qjadPGaaC11VCRIhY/73mVw05C8lVG7eYkemMaQfKjZiVEbPxCrJVb
         Q1xIBiuxkHgUk+sqT+WqOgLaNKkimBnngpmN9hiAuTfLe4Eg9ektf+4EcYh/b1QqDDcO
         R1z4EUWHXveDxIxu2iH5ilOOFN3GM2cfrGSqrQb9nbDGEYMIhAbbbgCcCrSV9Ymsi2wo
         3ewE4Xh9+b7CecxvyJhbFpmETtT3YLdWnUfbkY4cp4n3ppf+nmp8AwVO7K15tG2lN0Ue
         I9/XfHtCkjE9ViB4+6/fOJyt0wLbtFB5Vu3VNjOjyRMCwnEA02WtTKNjUnkgpSLMk834
         36vg==
X-Forwarded-Encrypted: i=1; AJvYcCUvD93VA7y1gyW3U22kPYt3ep++2TObd3HLQBipXGB7iKOhng+/Pm6lzcfQrpwRKl7AR7BooTZ5uiEp@vger.kernel.org
X-Gm-Message-State: AOJu0YyQB/2Q+K/zj6EHg5UaY2iumji4xAzmh4iHi0FZ6l5MRcQ3unCS
	u0bmFSoEqPtYL6WxWl6SAS5iKpNZKWrUKC8z58gO3zIm0S2xWICNFksOQQvWMAQ=
X-Gm-Gg: ASbGncv54pJfRd6pCxfkw9WUYKzjHc0mSv7T6Fspwds8Uy/QrEnbcDAZ6nckXDMtF5b
	GjhjPf++ELIAnpbs4WyDYNKtBlNozVhfgLxzQ/l+eWV1VrlQpy8DEjOsvr3dHyMyrFPnI3OYz0b
	xHBnMQ+mF5SaTARywRgqgcWOSGLV6ZCYWGCq75BLAXs/g/UKbVhzN1eCFb9Mvg7UNn4u6gxqGpf
	gGfayK9hM/z/fGoDMOLibXo6RccUA3f/a4mN+dZOboWZJeW/6MdlffScCrFTBlyB69YPcTUgf18
	7TMfNfwtNyY7aodfG331j6Eo1SOQYicIVzn/tLgDOAMKFjYepZVxPb0ZhXmUJreE1f0=
X-Google-Smtp-Source: AGHT+IF7kkhLn1z00njGE4e92bXbiVlop1aXxNBPa3AH5BLVzElW+qn9UaDTdiBwjWh3hX5hXLR35w==
X-Received: by 2002:a05:6a20:6a06:b0:1f5:6a1a:3284 with SMTP id adf61e73a8af0-1f5c131681dmr22874556637.40.1742271574009;
        Mon, 17 Mar 2025 21:19:34 -0700 (PDT)
Received: from localhost.localdomain ([154.91.3.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694e40sm8732453b3a.139.2025.03.17.21.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:19:33 -0700 (PDT)
From: Chunjie Zhu <chunjie.zhu@cloud.com>
To: smfrench@gmail.com
Cc: chunjie.zhu@cloud.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lsahlber@redhat.com,
	pc@manguebit.com,
	ross.lagerwall@cloud.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	sprasad@microsoft.com,
	tom@talpey.com
Subject: Re: Re: [PATCH] open hardlink on deferred close file return EINVAL
Date: Tue, 18 Mar 2025 04:18:21 +0000
Message-Id: <20250318041821.24433-1-chunjie.zhu@cloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAH2r5mt4ej2EtMHAc9Vro325XoMA++iktxcx28k1OGte_sxhVg@mail.gmail.com>
References: <CAH2r5mt4ej2EtMHAc9Vro325XoMA++iktxcx28k1OGte_sxhVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we run 2 applications on a CIFS client machine, one application opens file A,
the other application opens file B which is hard link of file A, this issue would
happen, as well.

The purpose of this patch is to reduce the CIFS protocol network communication as
we can decide how to responsd to application at client side.

> It is fixed by running with leases disable (via mount parm), but
> wouldn't it be better to fix the error so apps don't break.  Ideas?
> 

Ideas,

Extend SMB SMB_COM_OPEN_ANDX and SMB_COM_NT_CREATE_ANDX messages, add file alias
into open or create request messages, an alias means a hard link of the original
file.

> On Mon, Mar 17, 2025 at 3:41=E2=80=AFAM Chunjie Zhu <chunjie.zhu@cloud.com>=
>  wrote:
> >
> > The following Python script results in unexpected behaviour when run on
> > a CIFS filesystem against a Windows Server:
> >
> >     # Create file
> >     fd =3D os.open('test', os.O_WRONLY|os.O_CREAT)
> >     os.write(fd, b'foo')
> >     os.close(fd)
> >
> >     # Open and close the file to leave a pending deferred close
> >     fd =3D os.open('test', os.O_RDONLY|os.O_DIRECT)
> >     os.close(fd)
> >
> >     # Try to open the file via a hard link
> >     os.link('test', 'new')
> >     newfd =3D os.open('new', os.O_RDONLY|os.O_DIRECT)
> >
> > The final open returns EINVAL due to the server returning
> > STATUS_INVALID_PARAMETER. The root cause of this is that the client
> > caches lease keys per inode, but the spec requires them to be related to
> > the filename which causes problems when hard links are involved:
> >
> > From MS-SMB2 section 3.3.5.9.11:
> >
> > "The server MUST attempt to locate a Lease by performing a lookup in the
> > LeaseTable.LeaseList using the LeaseKey in the
> > SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
> > Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the
> > file name for the incoming request, the request MUST be failed with
> > STATUS_INVALID_PARAMETER"
> >
> > The client side can return EINVAL directly without invoking server
> > operations. This reduces client server network communication overhead.
> >
> > Signed-off-by: Chunjie Zhu <chunjie.zhu@cloud.com>
> > ---
> >  fs/smb/client/cifsproto.h |  2 ++
> >  fs/smb/client/file.c      | 29 +++++++++++++++++++++++++++++
> >  2 files changed, 31 insertions(+)
> >
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 260a6299bddb..b563c227792e 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -157,6 +157,8 @@ extern int cifs_get_writable_path(struct cifs_tcon *t=
> con, const char *name,
> >  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, b=
> ool);
> >  extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *na=
> me,
> >                                   struct cifsFileInfo **ret_file);
> > +extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *=
> inode,
> > +                                 struct file *file);
> >  extern unsigned int smbCalcSize(void *buf);
> >  extern int decode_negTokenInit(unsigned char *security_blob, int length,
> >                         struct TCP_Server_Info *server);
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index 4cbb5487bd8d..0a66cce6e0ff 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -751,6 +751,12 @@ int cifs_open(struct inode *inode, struct file *file=
> )
> >                 } else {
> >                         _cifsFileInfo_put(cfile, true, false);
> >                 }
> > +       } else {
> > +               /* hard link on the defeered close file */
> > +               rc =3D cifs_get_hardlink_path(tcon, inode, file);
> > +               if (rc) {
> > +                       goto out;
> > +               }
> >         }
> >
> >         if (server->oplocks)
> > @@ -2413,6 +2419,29 @@ cifs_get_readable_path(struct cifs_tcon *tcon, con=
> st char *name,
> >         return -ENOENT;
> >  }
> >
> > +int
> > +cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
> > +                               struct file *file)
> > +{
> > +       struct cifsFileInfo *open_file =3D NULL;
> > +       struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> > +       int rc =3D 0;
> > +
> > +       spin_lock(&tcon->open_file_lock);
> > +       spin_lock(&cinode->open_file_lock);
> > +
> > +       list_for_each_entry(open_file, &cinode->openFileList, flist) {
> > +               if (file->f_flags =3D=3D open_file->f_flags) {
> > +                       rc =3D -EINVAL;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       spin_unlock(&cinode->open_file_lock);
> > +       spin_unlock(&tcon->open_file_lock);
> > +       return rc;
> > +}
> > +
> >  void
> >  cifs_writedata_release(struct kref *refcount)
> >  {
> > --
> > 2.34.1
> >
> >
> 
> 
> --=20
> Thanks,
> 
> Steve
> 
