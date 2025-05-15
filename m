Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1E91862A
	for <linux-cifs@vger.kernel.org>; Thu, 15 May 2025 00:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747268902; cv=none; b=UTtOfpm1r+biKHfFkb90NL6EZ9cYUV9lvldmCpm29n04H6tjIiN72YLcsy3ewfacC3XIe8hlBVyeVlzIuiEetDF5jiRkICV6Irz094wOH6uolb8Kfooh5EXzKFaNOF3KvVZJTFIFQTH67K1K+WwfFgaQajIYhJGdGxBv1tHpqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747268902; c=relaxed/simple;
	bh=GPIiN8Z7eX+rJSl4PTdwxmBifh028wCDy+HrI2QR+cM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpPMe5QE4TZjRh1zX9k3THdIQ7Gt8/RPd37vhCmd6pg1hb/BYU+WPGVFdLXQHf3E8ho+UVk4/spyxWoQACCuvt6PDi+nsxxKAAevCpEQuwIxs81OCXgNfEAG9oVfTkDWX39GB3tMemGAEOXdI23hU0ugci+aiV54bV0w0bPA9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jASLV1dy; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jASLV1dy"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-550d7afa0c7so369409e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 17:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747268899; x=1747873699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjocJHYuW7JgE1msvkXieiusqzAbE/x8QvGg6n7sLKQ=;
        b=jASLV1dy4yH32HiUj/Dm2oMctCZ9Z3muzXfD2A+YjXsNCIsQ2epEnSWKvryNhLqXzn
         QbeuQ9bo5uZQ2RtjujpOWPNn/d6jjD9+STYC+TvWfUFypfMOdXj5AaSbHOOZY0xF3v0T
         ZI13fQQROeYe2PwOnCeePzMQi0oC7OAfIi3qlqTLMKG+j6JuLKnltRvCmTR+mAsh6D/w
         Gm/fVNK8gDF8I0nfTu9U+ETh+0SmocrLOFfiJnzWhFjTc+HXM4zZ2yJ2QK7Uht/t1QEI
         zyE2Hfj6hZJD3y4p1xZW6mDxCNunNArgI7V+7ix4mJ8/nog8D+rc4oquhefD4y7tdUxz
         /bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747268899; x=1747873699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjocJHYuW7JgE1msvkXieiusqzAbE/x8QvGg6n7sLKQ=;
        b=dzH7KmcLKeBaW+j3Zp3DzoO39Clc/iBEbp670VTszZ+5oiylgrmA0+MoRSBUxixOVM
         nnb5GCBUNsE0MQO/fWZMGbu8RPB3AfW1J8+WarT+k1i6fC+FfuPdlUSv1EadoHGqUMMy
         IcZZRhpK7AA3CRJEXeAMmi5GPF4kEVxRZ5KzMU+GvU61QOI1ZCeFW5axFqXxmMUCaJOA
         Kfvvq9U9Zr5VgTtHK6hJVtPrhS6GhLGWMLHXypMCWTNGG33jnjD4qJAVBJKIC+BUWnCt
         zC4e9SZlnwdjA9TGwH3NYz9h7V3PXjK6xOB7XJJkl2bP3PgX96razr6/R7lp1rxWBJgC
         RE2Q==
X-Gm-Message-State: AOJu0Yw+VObhsXfctxZTgfhuJrlmqGVx9ud9RI5eJBFVhvydnPDCCRS3
	k+7HTfIPQ3Ay4K/f+eb3uDsR5P7BBb/DYd6+Vrmqf+u8Il/4vX+oIiH0ELuzwVVP7NjoOrNeS+6
	jGfnengCruPlKMYY0X5O89Qfh4I7d0g==
X-Gm-Gg: ASbGncsna7oaekJGdIikSPo6scWmYdVKkD6ZecOkyZpwkgSUsssWSsUrMUiya7f43UO
	84Ok4eLtkmi6iqbPRtMIpGNDIHbeXvk2+dsnbGqvdrYogzgZnYd+3onljp3tpc/yu5Xq+k68j6K
	UrZyST3DZwrY/oA+zJQvlL+2MR90El8Djbsg10DC1LAqoKFcgSTJkZHXMAzKDgVn777bzXYRMjl
	n2QgQ==
X-Google-Smtp-Source: AGHT+IGg7a3d/DLGvAp7pjKEZeUGBHtwNXZOnwexxPknJpPdK7srbzQZ/Kf/YMWpcGx8Bds+pFlSR8qtVQyoG0lLkcY=
X-Received: by 2002:a2e:bd87:0:b0:30d:e104:b795 with SMTP id
 38308e7fff4ca-327ed210058mr21996481fa.39.1747268898636; Wed, 14 May 2025
 17:28:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515012323.28f38839@deetop.local.jro.nz>
In-Reply-To: <20250515012323.28f38839@deetop.local.jro.nz>
From: Steve French <smfrench@gmail.com>
Date: Wed, 14 May 2025 19:28:07 -0500
X-Gm-Features: AX0GCFvCTew1b_QU65zpD2OQQxe-n26ZeGtA9q3OtaXW9FwO-JKmt5o2cQL_iQc
Message-ID: <CAH2r5mvsdGwF7XPb38dMSpK5NVApQL75wsOHyHAt_nS1MZwaEA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix memory leak during error handling for
 POSIX mkdir
To: Jethro Donaldson <devel@jro.nz>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch. Merged into cifs-2.6.git for-next

On Wed, May 14, 2025 at 8:37=E2=80=AFAM Jethro Donaldson <devel@jro.nz> wro=
te:
>
> smb: client: fix memory leak during error handling for POSIX mkdir
>
> The response buffer for the CREATE request handled by smb311_posix_mkdir(=
)
> is leaked on the error path (goto err_free_rsp_buf) because the structure
> pointer *rsp passed to free_rsp_buf() is not assigned until *after* the
> error condition is checked.
>
> As *rsp is initialised to NULL, free_rsp_buf() becomes a no-op and the le=
ak
> is instead reported by __kmem_cache_shutdown() upon subsequent rmmod of
> cifs.ko if (and only if) the error path has been hit.
>
> Pass rsp_iov.iov_base to free_rsp_buf() instead, similar to the code in
> other functions in smb2pdu.c for which *rsp is assigned late.
>
> Signed-off-by: Jethro Donaldson <devel@jro.nz>
> ---
>
> Follow up on "smb: client: fix zero length for mkdir POSIX create context=
"
>
> Am tempted to change all the other calls to free_rsp_buf() in smb2pdu.c
> to pass rsp_iov.iov_base, even though none of the other cases where *rsp =
is
> passed seem to exhibit the above problem. Reasoning:
>
>  a) more robust to re-ordering during future change,
>  b) easier to follow (acquire/release via same pointer), and
>  c) more consistent
>
> If that sounds like a good idea, please advise if a separate patch is
> preferred or a v2 of this one.
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index e7118501fdcc..ed3ffcb80aef 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2967,7 +2967,7 @@ int smb311_posix_mkdir(const unsigned int xid, stru=
ct inode *inode,
>         /* Eventually save off posix specific response info and timestamp=
s */
>
>  err_free_rsp_buf:
> -       free_rsp_buf(resp_buftype, rsp);
> +       free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>         kfree(pc_buf);
>  err_free_req:
>         cifs_small_buf_release(req);
>
>
> base-commit: e2d3e1fdb530198317501eb7ded4f3a5fb6c881c
> --
> 2.49.0
>


--=20
Thanks,

Steve
