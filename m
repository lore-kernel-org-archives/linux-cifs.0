Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D634685
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746022573; cv=none; b=b1H31txT86dAKZ3u4bq0i7z4hdjv3kiesY5GYLlK/2QnjQ5kB98GRI5dF4oDA+8+EgE9QSJ9ZomoHKUSBJ/GwlGJw37QkhhJTCYTrQxpUW5yYNtW5GuyRlO3/b9MREsWAq8RMaTd0JNKS0U449uvq3w3UAlPgNw94bCAVhWeWMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746022573; c=relaxed/simple;
	bh=YTIYbYnVOcU+/oarnA/UWBeViIurPH5Z4RAJMpVjJYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PQAh1oRbZQ0+0BKY6uqkwVq3SkG3EqYd1H93JN8XFzoMiItKH4qXAjEpHLwW0m9p/h0GZcZtkY9N4NtO3D5qpnvfkakxjRFcxj5Ms3+HQKKTw4t7dmOydN/WPxVHmVv3z4c23LSIdHERq4oRiYRGeuM3E9YMIgZxdUMrXrGZNyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PP7pNFfv; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PP7pNFfv"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30c0517142bso65859351fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 07:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746022569; x=1746627369; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEZzbQV7LYE4x1kpmB19fKBGKQI511+IbVHRtE4ZwgQ=;
        b=PP7pNFfvn03sNtCO4mjD/SPukzSeJrhyDt4sXCPJfnUiFHYEVsGLqBDx9ba15h1Ykp
         Jzd70CwnGLjH5GdMzelnZrq/y4I6YGJuvqfVACBHELl7FVxsircCF1IgI+ItrO+veAxd
         jLIY9OeAzAvGCb8Gk3QzBFjW2v905D7pD8cMxZFQRP7o80QA+Rvvaf5U6ZIEuD8NUYXf
         N98LAttFnRraCb6q3Bf/h4p+QXTNDwC07DoczRlg5afdv0FAZGRpSSCpAS2SctPtAWl+
         CHDST9VtkXEB3FH6MQ5CJLfbap+sSftt2eEX4kD0Vnx+/RmkXtUHIGimNfxP72Q3Avwl
         mcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746022569; x=1746627369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NEZzbQV7LYE4x1kpmB19fKBGKQI511+IbVHRtE4ZwgQ=;
        b=c5wmjFKuS2K1iKCgLtyDzTknPGK0s4p90WMT+xThsLEuwhpO2eQgk4MXnwWs71zWto
         seBPw0wkStdXc74XaLz/YWo69k60f8YePKriNSgUbHlSThUx4wS1k+NTGDgMRVGi07VX
         BwNwkeDmO32OOlGcj6SuYB2JSOy1pDj55B5ANNe55sHNFL/SL3TfNkyZmyIQ0ge1ZzRZ
         /1I4RJ6v0XV6iMGxzbZOEC8+dqCNjK8eFivI4EbVHbeYPbXJav3LgBfaQItPDZNPlcYR
         pBV/sv86ettWmVeHZXCJ3fs8CoekSSCQQTxiadEuSyyBhVw0fSOeUsFzlkk2WNIr2NI0
         KYfw==
X-Gm-Message-State: AOJu0Yy4Wo8Q2Ov9WoGI7B2oaDbHIIwryYrWxBlK0BjjhjstPYS7dTdl
	NDBezcDFpvfE/+FmxzKusHuaXQ9AYtGuuYTK6dOC//OCYjjmf5/FcPCPzHIKmbt1pXlQUF79l2+
	iiU124CyR90109ZZxofV1pkiATC/Cpv/D
X-Gm-Gg: ASbGnctdrKtHbPzoHkuglFJpE16huq8e2XUcaOMJ3AFWvelyKs6gDzJPss37Beo8xOw
	6BPXNI0gdHdkW8FnEu0Asj4Lv30PWKn7zBeqFCkxNHq9rOKbfWliZm0SpIPRKUrfYoV7Zzj5Wxr
	6C++JFrOL1Anfm2a2vytL4K3WT+pXtKI1BTorpEJdfZGpkawAgC/1JtAeG
X-Google-Smtp-Source: AGHT+IEex6NV1LsJyEU9yR4SF9L1IdoyZZKMvAi7aLxEghkmN8f4dClV49j3Y+NaM0U195cy+cPmaNHUvXjNz7OXUZw=
X-Received: by 2002:a2e:ad13:0:b0:30b:c8b1:dd95 with SMTP id
 38308e7fff4ca-31e6a7f48d1mr13914571fa.22.1746022569169; Wed, 30 Apr 2025
 07:16:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428140500.1462107-1-pc@manguebit.com>
In-Reply-To: <20250428140500.1462107-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 30 Apr 2025 09:15:56 -0500
X-Gm-Features: ATxdqUHzxT_SK6nLzclsaLxB8howipuAV5dTvnxQpZVV-PenL9Jd5Yqam-979CU
Message-ID: <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Pierguido Lambri <plambri@redhat.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Did you mean

downgraded "RWH to RW"  or downgraded from "RWH to RH"

But it is puzzling why file would still be open if not in openfile list

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
