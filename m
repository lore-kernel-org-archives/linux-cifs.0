Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707C7C097
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708533223; cv=none; b=glfHDNay+20G7xM0YEcXP7M/uvgIB0clOWjpe8r2KUiDlQORtdRS9rubDXSguVqFiU1A8zLA4VPQF9S23+Vo1jouqnxuODtOD4xn6/FxQWE+uCW9dQlnO/yTJSIDNPNm02XFvGaWBlabcoaavHY01HKgLaQBo/4DCWB2kbvtOC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708533223; c=relaxed/simple;
	bh=zKQ3JDZORhS0jVuDSnxMBUjAZ4hZWCr0oFWDuWaC8/k=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCClEv1h6+R5GgIiR6/ODFo/2sO6wTcFGgHaXU+G0P0AjAqHsoDLriIt1OS4abXHbxXPrsX8NfJiVLCebMv+WSLmQfOqt5khHDTHfYLgFACYVUUiZQxpsAJB0dVedGhkTPfWDp9qGtr1/Hac3c7i4UibQh6rPHblxNHiSaOGII4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ca3jBMH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ca3jBMH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E27C433F1
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708533223;
	bh=zKQ3JDZORhS0jVuDSnxMBUjAZ4hZWCr0oFWDuWaC8/k=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=Ca3jBMH3NonNKFrLDGJNnsh/fkMhnl59phij5L2RVZ1wMDkpwC/V4ezRRLtcPiElF
	 rA5VF4/LKv62j8yPNXDndYbLa5FkGZyDyvdpAWdxo+UKJdC2nVbpOgsl4wsdVazIb+
	 IV96m8G/CxxM0cZEmCoyYkyRffH7ROiMcDgmNafETvnZ7tg3lY5W/VfJPpJ9/dKdbH
	 bqb01kdm4F3dFEof9+IFl3A2NZvz+dKM+PvXVVvK84Eeqqhbv8r44KloGM5Q3XeqGE
	 WEdvQ1BXeqyQlCW0o8S7uFT8lZyMs1s0oROejTEY3SIEnEAtgo3h2U55vrCEjKlrzn
	 NEjN7m3ihKjuw==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59ffbff2841so942058eaf.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 08:33:43 -0800 (PST)
X-Gm-Message-State: AOJu0YxQcnx4yLlDrD/bS7H6T3mNIPgPky8AG068/2iqHCwf18haYZso
	15Ulnr20s8DzVGuUoUpq2wrtzTcUpTOhPT9ycAGv10/NxNsbwCZUchremfQGMU15xYlaB+YW5yW
	NCDhbRdgEpEKVhDyETvNy/ock6B0=
X-Google-Smtp-Source: AGHT+IFArr72IBSxem0zGK//ygHm05hQndtfAkazpdrZxkSMN5jsvaLkB84rsnLgnwQzksnrcbTtGcSVXCVcCaYPhd4=
X-Received: by 2002:a05:6820:621:b0:59f:c686:1c61 with SMTP id
 e33-20020a056820062100b0059fc6861c61mr12969076oow.0.1708533222651; Wed, 21
 Feb 2024 08:33:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:c12:0:b0:51b:642f:123c with HTTP; Wed, 21 Feb 2024
 08:33:41 -0800 (PST)
In-Reply-To: <20240220142601.3624584-1-mmakassikis@freebox.fr>
References: <20240220142601.3624584-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Feb 2024 01:33:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-6y5Vj2eR+ovf8kSOLQ5B7Wqiffg_EiDHKKFG4sayB+w@mail.gmail.com>
Message-ID: <CAKYAXd-6y5Vj2eR+ovf8kSOLQ5B7Wqiffg_EiDHKKFG4sayB+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: replace generic_fillattr with vfs_getattr
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -5460,17 +5506,24 @@ int smb2_close(struct ksmbd_work *work)
>  		}
>
>  		inode = file_inode(fp->filp);
Now that we no longer need to use inode here, We can delete it,

Thanks for your work.
> +		ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
> +				  AT_STATX_SYNC_AS_STAT);
> +		if (ret) {
> +			ksmbd_fd_put(work, fp);
> +			goto out;
> +		}
> +
>  		rsp->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
> -		rsp->AllocationSize = S_ISDIR(inode->i_mode) ? 0 :
> -			cpu_to_le64(inode->i_blocks << 9);
> -		rsp->EndOfFile = cpu_to_le64(inode->i_size);
> +		rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
> +			cpu_to_le64(stat.blocks << 9);
> +		rsp->EndOfFile = cpu_to_le64(stat.size);
>  		rsp->Attributes = fp->f_ci->m_fattr;
>  		rsp->CreationTime = cpu_to_le64(fp->create_time);
> -		time = ksmbd_UnixTimeToNT(inode_get_atime(inode));
> +		time = ksmbd_UnixTimeToNT(stat.atime);
>  		rsp->LastAccessTime = cpu_to_le64(time);
> -		time = ksmbd_UnixTimeToNT(inode_get_mtime(inode));
> +		time = ksmbd_UnixTimeToNT(stat.mtime);
>  		rsp->LastWriteTime = cpu_to_le64(time);
> -		time = ksmbd_UnixTimeToNT(inode_get_ctime(inode));
> +		time = ksmbd_UnixTimeToNT(stat.ctime);
>  		rsp->ChangeTime = cpu_to_le64(time);
>  		ksmbd_fd_put(work, fp);
>  	} else {
