Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2E22749ED
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784986319; cv=none; b=FFvHGV2dcBnaLDblDC5EC53po2sBp7eqR7gP99b0ewKpY9oBGL/Jgn6i/NzplFmqhNZyAzpGBFW9Wo8xK3dbmPMIKnAue1rNBioMQkWZ79qOFaCnehAvFeEdwfB7CdSdnYtcrNsVdmpmy++iA/kNowzTsn7dm6QNaZ0blosKALw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784986319; c=relaxed/simple;
	bh=z03Tb+4Mqp3z73/IJZwpEHZpRocncQjnle8ynbfqWMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHsuk16y+bjHxAskQKdtsxzwu4d/diP5n4uHiRD4iFEUJCwjbUS/g0SNPBgXLzuYqMM5iVs80RmHF0rVDDe8RQbDxm5Pvft/S5YRxUVINuU3ArV6ZO4Qs/yb7XIizbRKTGiQ2aAuQYAD0dkeIRuEklBzGK81pywNtofvedYaMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGK6PDT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGK6PDT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A841F00A3E
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784986318;
	bh=WTyNcKTM7PChpxhhdXxef6U+U/bNurxVi9nzS1hKw4E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QGK6PDT8pE15OMsE7994GTqcz4Kojr6aZFFILuUvFocFmIcHj11d2BfHFN367Rpts
	 sK2uRPnjNU1+sIYr45fA2juOm4E12SDj9Fm/44LAkllbmH9LkvgynLoAIsT0C2vanh
	 JttjTvkhpeUxBB8WsVQwI+LAvq6+IwF7VdQk4kBEafnB7YpB/dcoVONUvYOctMxMjh
	 7hdas0Kt/VoYAW0KIYHZ5D3DW3WKe37zciQemU8choJhizeHy5uLKFu+jVuMG2HB1Z
	 ZQJb4gn8XSjvDh4g/dykcSy/fp+bypgY/ZILNY55scRW/9Xn0TzwEVBFiSdZtG9gG/
	 uZidnAq9jhr4A==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69c7c8accffso2034509a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:31:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpT12Dlw/f58tYhilOTvicVCIg6+Yiga6hLQckefR/iDUTXNXY3dwX9HcIlZU+6YGXuYNWldKR5oOpa@vger.kernel.org
X-Gm-Message-State: AOJu0YxF/AuEbKeFi74V7x4BDbW2NVr+d02rrC2w6ihpINF8bwo/HF+f
	AKh0zCDfnAEB7eFsQ0ZGOCzUNDYXogZvU3p7Da+UIPgALkEwm1BkV+WiyeF6nascC8EwmGb7nw1
	/GPSGmFV5iLQEo+MhDKXxhUnAfefSwzo=
X-Received: by 2002:a17:906:6a27:b0:c15:f598:60c0 with SMTP id
 a640c23a62f3a-c1f1eab62demr93724566b.4.1784986316718; Sat, 25 Jul 2026
 06:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com> <20260723031644.312866-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 22:31:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_TNmTA=78JcWvHkZT-RagzmJXoFhNdPbQ6dhTVQnzqPg@mail.gmail.com>
X-Gm-Features: AUfX_mw55iUrzAA6Vj2AxYGDFahYxiFIzy0mT7Byr8Sg3okWIqBpAwn57cYXrrA
Message-ID: <CAKYAXd_TNmTA=78JcWvHkZT-RagzmJXoFhNdPbQ6dhTVQnzqPg@mail.gmail.com>
Subject: Re: [RFC PATCH 02/11] smb/server: validate notify requests
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +       if (!S_ISDIR(file_inode(fp->filp)->i_mode)) {
> +               pr_err("Notify file id is not a directory, fid %llu:%llu\n",
> +                      fp->persistent_id, fp->volatile_id);
> +               rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
CHANGE_NOTIFY request on a non-directory open to fail with
STATUS_INVALID_PARAMETER. Please check [MS-SMB2] section 3.3.5.19.
> +               err = -ENOTDIR;
> +               goto err_put_fp;
> +       }
