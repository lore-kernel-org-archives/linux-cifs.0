Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECCF23507B
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 00:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787705983; cv=none; b=fRCvS07AX63LXZEvTUoBxtF3eQnAIXKrxL3YEpMXYbZnRKv16y9ONQHNxsHVu71hJqE60RBCjuQ258sGWB7OfNTnnvaDSR3lCwpklbRh0+4KQ9LKjwVwo34HLmLXNFwYi3ome0gtAHxEqECANzerooLBN0IfAFdItZ/xEMaoa/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787705983; c=relaxed/simple;
	bh=KCb1T+E2vbQj8UGhAouvaQQCblHWutyZfkzZoRmUhOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=az4NdmpHH5tukQrpDuzXxv/bGM9JdESNOHbtgOuUfd2bJMdDKpzLNEzMO299HeiooOgg269z0JBD2UJpBpWyZJQ3igPQIadT629+OlFTnpiU/9nurAQ7GuJQ2oL4kl8JXsUOrgJxgqXAYuMX/+v4O9R7K8os87VK3uJE2nr93mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDu3grqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDu3grqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A031F00A3D
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787705982;
	bh=ZdEs8POfr9tAeDuibjStxAfJojgAbcwYDGHfH99U70Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FDu3grqqFsBNpk0oYoedp6731PJL2hOFkapxakAKRX5ajbP0Tosz34rpj0ABp1AE1
	 8Wi85AqQrmBwwq3NBrvDHJ2NgicXFLSwG4HUTXViXTkU70VbvJ3dTD51Dgu/cTLsdv
	 9PXjkJcuofhm7HC3GRVFpQwnY82VkH+cJFYuFudM68r1sdbgYHG/TpM7YMB3jLUgu7
	 f4NIEmsM+hfoOSyjvNRbKgTb3pGkg6a/wQ8fImJhm4d5wlrdtt26A7KiRLVUJrsrk5
	 28ff9UXXnjboVtNgiosA/K7Oa6IGaUNb7r7suFKVK/VGQ1ulcKHSU/vXTX89kYvWA3
	 4qI9xSRkaXFew==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15d47266baso36552966b.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 17:59:42 -0700 (PDT)
X-Gm-Message-State: AFuF++kJ311ieFYhHDHqY3HLqcYD4mf/Fh6uVlle8ENnDXcJviHs29ML
	SjCHw5rN4kMPNnFelby169d2hkt1BPGHnHzV9YiF3pZWQeoBPQw1uQqXNKpcbooAUbafPt5uEP1
	eSticsVxVi03eva3U4dp6cFOmBrqwvcc=
X-Received: by 2002:a17:907:9617:b0:c16:4e5:944a with SMTP id
 a640c23a62f3a-c250c3529f9mr306989666b.21.1787705981065; Tue, 25 Aug 2026
 17:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260823185807.3115901-7-sorenson@redhat.com> <20260825221300.3860212-1-sorenson@redhat.com>
In-Reply-To: <20260825221300.3860212-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 26 Aug 2026 09:59:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-fAv+GUahwuPbffD8TWAwLEVyVrNNmQx1jZMcsxHRe0w@mail.gmail.com>
X-Gm-Features: AcwNN1VbxvYf__k2bE7Vep2m9r-Vzm7tqA6n1G8eZiM_vAAIFJZ2dwdnezjcj_I
Message-ID: <CAKYAXd-fAv+GUahwuPbffD8TWAwLEVyVrNNmQx1jZMcsxHRe0w@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 7:13=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> The while (src_size > 0) loop guard allows iteration after
> next_entry_offset advances src past the point where a full struct fits
> in src_size.  Reads of ea_name_length and ea_value_length on the next
> iteration are then out-of-bounds.
>
> Require src_size >=3D sizeof(*src) before reading any struct field,
> and reject next_entry_offset values that are smaller than
> sizeof(*src) or that leave fewer than sizeof(*src) bytes remaining
> after advancing.
>
> For calls where the server returns an EA list with an invalid
> next_entry_offset, the error returned to userspace changes from
> -ENODATA (getxattr) or -ERANGE (listxattr) to -EIO, correctly
> signalling a server protocol error rather than "attribute not present"
> or "output buffer too small".
>
> Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
> v2 changes:
>  -  reject next_entry_offset values that leave fewer than
>     sizeof(*src) bytes remainint after advancing.
Since maintainers might accidentally pick up the v1 patch, I think it
would be better to resend the entire patch-set as v2.
