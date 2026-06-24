Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83AF1D5ABA
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 03:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782270157; cv=none; b=QYimo39OaMcnoktozf5OXJkdqXRLaKkSHfffREPTMsQVGjZuaFCuZ/7W320rYH5w5ARrYOiaTJRXJVFfRO2bVzVrZuGqsmjcUYUAfE05GaziiQw0odoTGhnDhzmscm0pAPsGIztY6hh+8vCZlWgQRmIkHkk/rSQrfffZSnmtd0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782270157; c=relaxed/simple;
	bh=pGB6DLcYpvwBAiTph7OpaVGI7S0NY+TeRTWO+ZK0An8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFrxhX0MqG/1wCwahd096FAGWWgyfJfcVfzqKGpJOqgSVfCsfCnLxIExrxp04BtCXa5X9HENvP8sKgJwE261KoeBARRwnVLBPEgl9lopW71Cs9prazism1FmH5K6iRdG9uACdxT8lo002UDJA48SAkzWC3DJ1EKCmcBtTbCQi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgNW6JFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgNW6JFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706661F01559
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 03:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782270156;
	bh=FJU5BFG1NhTyzhLsYaoPqLsRV5xkRU9QC4lOArVPz44=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GgNW6JFLMtUmeF5nPiXH6MEX1E1PQ6cn9sgTnjQXGm1ter/zqTe8ks9dQdoX6BTw/
	 s+z7pe6vFSaBR71+w0N8Kq3RZsPcKotOjhEinVRVr1o3fvMWSBBjjcNmUYg9Skm5k/
	 oN8EFyYimKTN4IIalaFkiN0e8cnNv/2Ui/DRroNZK/N6Q4tP2fQhwqaxTuQ6WkSBAH
	 PGdK8v2khEN8F77Uf1Lmwi7mKxcH03pptwPaWARDQc6QCEhPnkMV9az7E+3RRpF3Rh
	 8JI6VZnqzFrgmlq88rRutcJyaH/9zihEIfnmZYUxZFshF/A1tMzV7sgNUoVAbzfRGV
	 AdJYqYRaeYsXw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-695f539fc8cso2704824a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:02:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ983SZFJ8iyYmFS8a5fhLV1kMezpQGr6kd7bD77Xvfq+naGzZbn39hkLnbaevYdXgE0iNQzB/vNfnVs@vger.kernel.org
X-Gm-Message-State: AOJu0YwOwyiXGf41H0KF4jlKVz1UXrBi7MLXW/NFgziYJM8sYArQDdx0
	boWaMrLLPRWrUpLiGpYaTowgQsyUlG1BRB3+5i0FqRrPgkgvGyya4EQdIB9QChYjmjssymqFtjS
	RvDDV2T2x9+ziUGZI0nFdmc7gnajjwQI=
X-Received: by 2002:a17:907:1deb:b0:bfa:9457:b517 with SMTP id
 a640c23a62f3a-c1030ea2b61mr247046466b.23.1782270155128; Tue, 23 Jun 2026
 20:02:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624011320.9146-1-liuqiangneo@163.com>
In-Reply-To: <20260624011320.9146-1-liuqiangneo@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 24 Jun 2026 12:02:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_6ELLJmX+k1H2OmPP-triUk0N6dh0o5kLm7afCvsGvvA@mail.gmail.com>
X-Gm-Features: AVVi8Cf-xeRVCPd3NBWGWZi2QAZycFZxTfcWfM51JBEt5zsNx6zf7VR3IZC7M2w
Message-ID: <CAKYAXd_6ELLJmX+k1H2OmPP-triUk0N6dh0o5kLm7afCvsGvvA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ksmbd: fix some memory leaks in ksmbd_vfs_* functions
To: liuqiangneo@163.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	Qiang Liu <liuqiang@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 10:13=E2=80=AFAM <liuqiangneo@163.com> wrote:
>
> From: Qiang Liu <liuqiang@kylinos.cn>
>
> This series fixes several memory leaks in ksmbd_vfs_* functions,
> where dynamically allocated buffers were not freed on error paths.
>
> ---
> v1->v2:
> - In function ksmbd_vfs_get_sd_xattr, remove the free_n_data branch label=
 and
>   uniformly reuse out_free as the resource cleanup exit for all code path=
s.
> - Use `goto` to free n.data in ksmbd_vfs_set_dos_attrib_xattr function
>
> Link to v1:
> https://lore.kernel.org/linux-cifs/20260623021240.34722-1-liuqiangneo@163=
.com/
> ---
>
> Qiang Liu (3):
>   ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
>   ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
>   ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Applied them to #ksmbd-for-next-next.
Thanks!
