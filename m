Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3F946F
	for <linux-cifs@vger.kernel.org>; Wed, 25 Sep 2024 02:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727230996; cv=none; b=RAec+jmrn8VMKHJC2AmxQ7IfVg0MVQShwK5hIBlQEkwtStXHeVEXZXyT1HXI4SwCgDgYPUKHMZv4K+Di2sl/aUaO9aZNHU2GDu+V1kmFpiOFgLl1YKvRAnqn1jFRsUfRyjIl8jsiO0+jctiV+rL7Y6aiBF6L3493p/1Mey527FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727230996; c=relaxed/simple;
	bh=0HQpbelJwKnnZwIkuS6EfEq4a7l1Wz+v3oQtvZE1PSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmYs9X2enOBBzYAIccNeHZjg6Hl7MFAAh5KI3yOXB6AtGc0B7fjIgJemOK+VfZbCVHCVp0i7CesFWvQIAWoQEuWpygqYTu/YSD4TdukJMPpJZB2jVMtjFDFXVUh2+5KMzNjfRpJ/KiHf7sfPfSkbajFQudvNraS04uyqb7/pdC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7jIJamu; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7jIJamu"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53660856a21so6089929e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 19:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727230992; x=1727835792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iO8JVqV63/DV9Yoj9tRLWn2/nkaYozr5eKiZDGGbqnA=;
        b=E7jIJamue3H3WqbdloQ8+DLogBdDktDQIZB6dMESLjy1WDGzEkOv8ivkiS2sv2f+h/
         koRygaq3KO6+ZP02dKSzUh1zVYDZ4EJQH+KBgNK16OzjZs1vYjYt2G+Oni+JLcR+SsxJ
         Uim5WRn5CEiUETcCbIKsW6z7ihFFZqPHubviQb6TSuQ+/mYJ6Ui3o4KwczI4k6UhllSL
         MTmqCvd+s1LbTkgQvDGWcrw+767rVTvaADyZyRvzWm2+NDG+tlRNbWHRoamh7PdhFjI+
         773KS7zH1wf59uZtF5T1CY5ub1s/TuZ5Ix1jBOWs/15tfCdt1h84I1gkHOFPLMwhN36n
         BNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727230993; x=1727835793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iO8JVqV63/DV9Yoj9tRLWn2/nkaYozr5eKiZDGGbqnA=;
        b=QOwfzGma5YzjvcfCLP9ZQe9BqoJjcUqefB07zNN0X55OVlqWvVO+I8EF5iLdhXMqWG
         gDnEbWLp8O+cXCnvacdXqWc5FeQqySZ8uQNfXdAjhQPdKqULzgdYuG+M1Tk3wG0gsu2B
         tP51Ese6g1eP1CjB6RmiIfWBvscKtO+J25hh5LMFazaCs3U8qA6I/qvPhzEDh9BNUpKs
         CsRATlmw6cMvoFtUswel5lZpXpKbmn0VJ9rQfzAGuKFJGz/wUTGhR3LJTtlc1a+hp9tE
         WsQHY/178xc8yFRXI8jbDRI0phzqwKpj+zPjBBXgMsMsjLEq9vOa+V6ySmKU7EbQTY5E
         Sr4g==
X-Gm-Message-State: AOJu0YzjhJQcrqq22P/wFAjqjEp0kAQ+omBmLBaZpw432Z0TsHVy2v+i
	Raz0pE0BVUh87mJYZEZYBofhG0t4N1jz123loOOlkjicXYT5b+7yurNAfpOBrjFjJdwFJ5ZtDhu
	eGU/+Mqz3t3w9M4/6ImMvRSVepMU=
X-Google-Smtp-Source: AGHT+IElH3yVD7IHrgfDzz/7OrBEq6MubH63WHfhsN1hJkzNgb3KfnGR7tQHOZM3T/yYy9dBZg2ydSM87Mz/UkB2rQc=
X-Received: by 2002:a05:6512:39d5:b0:52c:daa4:2f5c with SMTP id
 2adb3069b0e04-5387755e209mr552152e87.42.1727230992218; Tue, 24 Sep 2024
 19:23:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240918051542.64349-1-pc@manguebit.com> <20240918051542.64349-4-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-4-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 24 Sep 2024 21:23:01 -0500
Message-ID: <CAH2r5mu5GNh1p4ns_B68AnsNN44o01A7LM6r21zK_j=ZfyyL0Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] smb: client: stop flooding dmesg in smb2_calc_signature()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

any thoughts on whether this should be at least a log once event? How
to make it log at least once, but also something that could be turned
on (doesn't seem like it makes sense to make it an dynamic trace point
though ... right?)

On Wed, Sep 18, 2024 at 12:16=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> When having several mounts that share same credential and the client
> couldn't re-establish an SMB session due to an expired kerberos ticket
> or rotated password, smb2_calc_signature() will end up flooding dmesg
> when not finding SMB sessions to calculate signatures.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index e4636fca821d..c8bf0000f73b 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -242,7 +242,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
>
>         ses =3D smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
>         if (unlikely(!ses)) {
> -               cifs_server_dbg(VFS, "%s: Could not find session\n", __fu=
nc__);
> +               cifs_server_dbg(FYI, "%s: Could not find session\n", __fu=
nc__);
>                 return -ENOENT;
>         }
>
> --
> 2.46.0
>


--=20
Thanks,

Steve
