Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B9026A1A3
	for <linux-cifs@vger.kernel.org>; Mon, 28 Apr 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745851246; cv=none; b=QVHbg8rYWlyOTPoOu6frIj40ULdZ7KHQT6uP8cIAgzhwR2XftDZ9+yr3QmX20SlWz4mskoDvoKngh3WQ46UeV6ffHiCJtkp8x21O3+XZ4gA1yv1JB8u294T1aeBERgcrbYi7RtYjbTDOMnuYwHx1CM8M5TQdzFaxD7SQGAtUgcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745851246; c=relaxed/simple;
	bh=LfQJcUwBv+YCtkMkIxXrXaDsOacKgRltiQqquBunaiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpqWX6Jg4yFM8ux1xwlAntJRq5YQjmk6g4yAYHkBN5vXE247Oyys71VH1pqyrApvAogpLSBOTvzUw18fQtLhrJhDu2kIju7cV8cLIq+BpwP65Q8sgB90qNSAxOLB7MFFirZPLGTxWIFUN9GLTdu4hMg6bngsKJ7aoxtX97MxACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RBParBUc; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBParBUc"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5499659e669so5792364e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 28 Apr 2025 07:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745851241; x=1746456041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ok3ThiGGG9aRBf+xjBxelSRRqAmUU8fZ84pCtPMd4z0=;
        b=RBParBUcnSwqr4935NP8XTWj/GJCMF+RcZQPEXPdRFTU+WGSrZ1skyjnw4cJmSoRoZ
         NCQ7TzrJhkOCeAMepBozxwkZXf0JBNtNhv9SHBIjaDK3rcXUUfu0QuWgGVu2mJoVicI+
         vYW/BExG1E0noJ6/vcQ3PBl1Fl0LwYpeYUtYuO+/f310isYvycXQsHgQlzFAnSiWhvmG
         eCSAJhlzIgyQZLUScatgYVsLquHve9L27Q8fJg9vnWjTXpceYR+rvmq5ep0DtjLTjEmg
         mwhkWdYV0hOuOF+G+nohkCPzrN61sOU+ETpoeFCxEtpTBRvHXuXd98nSjiUGFgTk57aE
         asjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745851241; x=1746456041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ok3ThiGGG9aRBf+xjBxelSRRqAmUU8fZ84pCtPMd4z0=;
        b=HMLyN4jGOwJPnuJGvCH7JkYlvXzasYF3915ZxR260WeUczrZp3tOadLuJdjSA20Tyr
         oNzAFIPC8DjrIHPLOM9gnpEC6j8bdpLsouzT3sTnll93UvUmXwo8TjNcGy6tWpABjW8u
         B5DnXEINhYWBhk3u0q0efKNRIQ9NvSMit2cCHjHwhl8qcCGgQEneNxSQ08+9HOD383Cg
         U3sHobM1b2QxC/021D2efXJjuhuBHLb3q4SstORj3q8REWY5LZlt5i4U96oz/DGw2AAM
         ze/SNLF22afcKJ1bdj898a0IU3ZBT2M6xSK8xX3a3rDTENHvFLoHNcmVplvom1R1Vvsg
         LCAA==
X-Gm-Message-State: AOJu0YzkOXDGQzKTAhfNSPnZelu6kI+LLdDzKxzZL6X6DOYrk0ac/qnB
	Wu5z7pyh+a5QF9149Pig+sI7UEVim49XftDPOIu6gJ4xZgOQvgY6MweES2IjtRy6b89ME8dqhSj
	MRtUvYUlCNVmd/JHE6PllR/9w0B0=
X-Gm-Gg: ASbGncuRXUUklB01yzm7dEEgWDImOl8RaV9xVlhqh0UH0/cta3RcxxNliSDPRISSZXT
	KNoSXNJf30HmHbL5e5va6HOsmzG/7+goIDEdpZpL1pEnZpI4C6BRcFT3g02rrk/quO2Jf81wOZA
	y9lUsXs20Smqc6RJqhvsyW6CwRWOC1J/8RBfysHuYQyo7nL+CR0FlqId/u
X-Google-Smtp-Source: AGHT+IFdSHPCLdCky4pD8U9jK9dy6IjTyZWWzZs8qOvg2FE7mkdkFnBPKg6Tah1VZHp8CpES4ba94XByZBb8Txn9JGY=
X-Received: by 2002:a05:6512:1315:b0:54a:f76a:6f83 with SMTP id
 2adb3069b0e04-54e8d05daddmr3085194e87.13.1745851241277; Mon, 28 Apr 2025
 07:40:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428140500.1462107-1-pc@manguebit.com>
In-Reply-To: <20250428140500.1462107-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 28 Apr 2025 09:40:30 -0500
X-Gm-Features: ATxdqUHEdnhrZ2zoN083bjkD8DrBYamoZ8rZMaJUd4M2ZfHUnQ0p5yEhyR0r1yA
Message-ID: <CAH2r5muAjn5XLRFVgqwj6ZPATHj6iWLvTHTixuBx+a0BZnKUOA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Pierguido Lambri <plambri@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Were you able to simulate a reproducer for this?

On Mon, Apr 28, 2025 at 9:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Customers have reported open(2) calls being delayed by 30s or so, and
> looking through the network traces, it is related to the client not
> sending lease break acks to the server when a lease is being
> downgraded from RWH to RW while having an open handle, causing
> concurrent opens to be delayed and then impacting performance.
>
> MS-SMB2 3.2.5.19.2:
>
>   | If all open handles on this file are closed (that is, File.OpenTable
>   | is empty for this file), the client SHOULD consider it as an implicit
>   | acknowledgment of the lease break. No explicit acknowledgment is
>   | required.
>
> Since we hold an active reference of the open file to process the
> lease break, then we should always send a lease break ack if required
> by the server.
>
> Cc: linux-cifs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Reported-by: Pierguido Lambri <plambri@redhat.com>
> Fixes: da787d5b7498 ("SMB3: Do not send lease break acknowledgment if all=
 file handles have been closed")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/file.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 9e8f404b9e56..be9a07f2e8c6 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3146,19 +3146,12 @@ void cifs_oplock_break(struct work_struct *work)
>         oplock_break_cancelled =3D cfile->oplock_break_cancelled;
>
>         _cifsFileInfo_put(cfile, false /* do not wait for ourself */, fal=
se);
> -       /*
> -        * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do no=
t require
> -        * an acknowledgment to be sent when the file has already been cl=
osed.
> -        */
> -       spin_lock(&cinode->open_file_lock);
> -       /* check list empty since can race with kill_sb calling tree disc=
onnect */
> -       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)=
) {
> -               spin_unlock(&cinode->open_file_lock);
> +       /* MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) */
> +       if (!oplock_break_cancelled) {
>                 rc =3D server->ops->oplock_response(tcon, persistent_fid,
>                                                   volatile_fid, net_fid, =
cinode);
>                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
> -       } else
> -               spin_unlock(&cinode->open_file_lock);
> +       }
>
>         cifs_put_tlink(tlink);
>  out:
> --
> 2.49.0
>


--=20
Thanks,

Steve
