Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55FD248881
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 02:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896250; cv=none; b=e1gAsbmO8GAlfIdbOdqEkkL8UOArFvu1yb6Rx3uKk/TuNwIt6UfExJYxq9jcv/6rFWV3iciSqPPIGxBK0yweOmuO9Xngmv8VY7gYmnwbZMgf9KB8qL54nvpO+frq63odNyDiy7aHKL2FEEB//vwpdynWceyAjNQtP9B+wkuRUoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896250; c=relaxed/simple;
	bh=Ag7hkB7mLXAdPPYdaXe9Dt/KQRWjtptmZA/8HNpKOJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XkL39nut8NlAnMnQ8xNPJ+lv4OJsk3Qdv4ekqI3iOU64OAL7vZKWsV113KBL+ECmFY1H7miuSa33AgokB36nIvL3AN3YN3ZIXrShS6eP5ZSDFDLzSY/IgSDVU7MCd6N33Mnw1qpzN3b221nbIT6sipvGMCrtcVSEJaeH5GmRfTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSE5kH6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSE5kH6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D72E1F00A3D
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 02:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785896249;
	bh=TlXW4rIY5AYV859ELd0bJH9YIPBYVM5B7tqz1iTmGbg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SSE5kH6LgKqjHBxHUKoBUvXTaVyGH9ZnPTfns0Gaz08sCYxqBGazlZ2XCfYuqpPBM
	 xBeyRWldeQiFIGWbIybuSzynPoB7x3fR31iuO0/SRB5JKEt5TSDQEdXBh+7/nQ1XJi
	 Tfl7iKqg7iEigcSvX+hKeuGUte4XgYfBS/jdzWp5HeXzZ3KFjH1gWyXlEsWRamWLCA
	 MLUVuaIftjamAsacHJ4JoXCZy/u1Uic1r10GgLWHPiKvs6EpMeP2gvrYJ71mVVb9FG
	 7+YXtCRtl/UJBEnzpSXBE2v51N1MVNjU/TpvoJlYp450zaoT59S/Mek9DwVMn/0iov
	 u5F2bSUYHqhLQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15cd3fd760so62563766b.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 19:17:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrym8o2AGgLL/IRGAUeHBhT3+efHlOLMJRUWHx/HkbIlWhqSJkHJdq3t+KDxNtUd4Yc4equKFbITZve@vger.kernel.org
X-Gm-Message-State: AOJu0YyHxAB5p/qLFEgCRgWhqgzgmeq6hlEt3qUWF2LJHx1yRQ9P278j
	zXHNoIPNbbuLSjiCCTi9xYuWzLheEkWQKGMAwsiUdgESCgufzwlNSsw5slQwCi3NZLILnyMitPI
	1QIElYGVPELyV7uStPdFsZdc0ecdLy1E=
X-Received: by 2002:a17:907:1c86:b0:c16:b05c:b9cf with SMTP id
 a640c23a62f3a-c2039cdc721mr154034366b.26.1785896247916; Tue, 04 Aug 2026
 19:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com> <20260804123301.285434-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260804123301.285434-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 5 Aug 2026 11:17:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
X-Gm-Features: AUfX_mxK_Owyxu3xATLs17cXI_ajKncAdUfzMJ8EQq3lw51yo9ve6JUDO0xNnqE
Message-ID: <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb/server: deny overwriting targets with
 non-POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	slow@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +bool ksmbd_has_other_nonposix_open(struct dentry *dentry)
> +{
> +       struct ksmbd_file *fp;
> +       struct ksmbd_inode *ci;
> +       struct inode *inode = d_inode(dentry);
> +       bool ret = false;
> +
> +       if (!inode)
> +               return false;
> +
> +       ci = ksmbd_inode_lookup_lock(dentry);
The new check is limited to the target dentry's
ksmbd_inode->m_fp_list. Therefore, it does not cover a struct
ksmbd_file opened through another hardlink dentry, even though
file_inode(fp->filp) == d_inode(dentry). For example, if file2.link is
a hardlink to file2 and file2.link is opened with a non-POSIX context,
an overwrite rename of another file to file2 can miss that open
handle.
This appears to be an existing limitation rather than a regression
introduced by this patch. However, since this patch is intended to
reject overwrites when the target has a non-POSIX ksmbd_file...

> +       if (!ci)
> +               return false;
> +
> +       down_read(&ci->m_lock);
> +       list_for_each_entry(fp, &ci->m_fp_list, node) {
> +               if (READ_ONCE(fp->f_state) != FP_INITED)
> +                       continue;
> +               if (inode != file_inode(fp->filp))
> +                       continue;
> +               if (fp->is_posix_ctxt)
> +                       continue;
> +
> +               ret = true;
> +               break;
> +       }
> +       up_read(&ci->m_lock);
> +       ksmbd_inode_put(ci);
