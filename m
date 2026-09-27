Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135EE3A0EB8
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790506278; cv=none; b=aJ0sApqT9cz7webiqakuok/ptLXGLxhjCz/Volm5Zsys87qaNNkkqb0cbgUfRjJ3f0EthqD7TLGpaJ+jesj7w+ciec6Vc3iLpO6cPgU0tyaso1HpiDZ7yz2qpUQEMYXUepi40Deo+lC6RzheTvCzaT9SXhyUK8G4ID2iGjWlYi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790506278; c=relaxed/simple;
	bh=8tC5/i8QRrVWUm5BssqZA6qdhkjetDf3lf54WcvPXIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A1l0Z2MwcFaBMiS2gthoVe1L88Mdl8eFtwQIhpWfnRMgziqUL8ddfMFJH0xAmHFAg8KYOpWDWQJmqoMFSK7AhkhY+miHDoGaI/EZttzusg6HXOuvzLAwo6gsBP0Nx/ZMRS7T1QRUzMkggVBtbh4gduAazLdRg9Sn1+bBCyJhhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQF2w0ZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQF2w0ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E5A1F00898
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 10:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790506276;
	bh=WyzHm72M4EDBJOQY/IEWLocHU2l3lhMX105DP1Q251A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VQF2w0ZNXk5Sv+UzUcWDxVxSeeS4DNvm7L9A8MQ/QZ9YNwrrFEfZksjq+rqB1AUJ9
	 T40PPCE1kHKSriuQl9Iku3QwGgyMToBfcUwaLADnM0+Wl5Z/bgWpkd/K3ckHWpAxU7
	 u7Ogoo+Cn+IVUVgYm/ydZJMUIiX8TOuydo4BFVUawBFUCmr2InTsk4tkuKci+UzwAy
	 f7+K/iQMwry2xL3EKKDDsEPoiKuxeAOU6sZF14g8k/7LOpRUY4pUGpuUq64vxO8PF2
	 RJ0IRGxFeLDcU0FLOcAF8mGtuwHlAi7OL9WImubrlUFRLMw14esCwbmm5xCcs3+NrQ
	 tGwDnrfVXJ3mg==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af3701927so278895066b.3
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 03:51:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByncS9WVWv9WlALvpuydITPQ30ShxoDU2Jqs1d77I0r6ZuvgIDn9TCpWeJQovxIe7r7DA6hfrp4i7C4@vger.kernel.org
X-Gm-Message-State: AFuF++nrUTCdTeElHY1b2KZwXpcXQZFqAZ9wzPTAyIUO1jHmfntR9pmn
	KKlnAIrj1bGv2WaKpt4EqFrJDDyqEPnuXKc4JAANX98yjhZukyt5GcV3F+5Nj1JqjrJptNNmxD5
	bvJwkLlqDJcMREnFiMIRixshXirxBXBc=
X-Received: by 2002:a17:907:7b8d:b0:c2d:c800:d797 with SMTP id
 a640c23a62f3a-c2dc800ea64mr163212366b.6.1790506275360; Sun, 27 Sep 2026
 03:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com> <20260926090518.78547-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260926090518.78547-5-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 19:51:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OTKFO1actbPQUJqorAw4ZW7iBVEmbo_nVe1hjCL-uug@mail.gmail.com>
X-Gm-Features: AclHuK8GKCGotCMg7QIcD53TdrgGq1mmWXZq51TDxsNOddb4qZMqlDJ1SobU_bk
Message-ID: <CAKYAXd9OTKFO1actbPQUJqorAw4ZW7iBVEmbo_nVe1hjCL-uug@mail.gmail.com>
Subject: Re: [PATCH 04/12] smb/server: support non-recursive directory change watches
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +static const struct {
> +       u32 notify_mask;
> +       u32 fsnotify_mask;
> +} ksmbd_notify_mapping[] = {
> +       { FILE_NOTIFY_CHANGE_FILE_NAME,
> +         KSMBD_NOTIFY_NAME_EVENT_MASK },
> +       { FILE_NOTIFY_CHANGE_DIR_NAME,
> +         KSMBD_NOTIFY_NAME_EVENT_MASK },
> +       { FILE_NOTIFY_CHANGE_ATTRIBUTES,
> +         FS_ATTRIB | FS_MOVED_FROM | FS_MOVED_TO | FS_MODIFY },
> +       { FILE_NOTIFY_CHANGE_SIZE, FS_MODIFY },
> +       { FILE_NOTIFY_CHANGE_LAST_WRITE, FS_ATTRIB },
> +       { FILE_NOTIFY_CHANGE_LAST_ACCESS, FS_ATTRIB },
Should we also map FILE_NOTIFY_CHANGE_LAST_WRITE to FS_MODIFY and
FILE_NOTIFY_CHANGE_LAST_ACCESS to FS_ACCESS, then add FS_ACCESS to
KSMBD_NOTIFY_EVENT_MASK? With a LAST_WRITE-only filter, ordinary
writes emit FS_MODIFY, but this watch subscribes only to FS_ATTRIB, so
the request can remain pending. The same issue applies to reads with a
LAST_ACCESS-only filter.
> +       { FILE_NOTIFY_CHANGE_EA, FS_ATTRIB },
> +       { FILE_NOTIFY_CHANGE_SECURITY, FS_ATTRIB },
> +};
