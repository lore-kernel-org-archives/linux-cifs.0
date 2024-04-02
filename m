Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D560815CD54
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712087870; cv=none; b=TRuv7FPO0YBLi2pdIAqupd7C3Jgu6I3qbKZERyxB6k6NRdL/LSacZ8ndY7hs9QG/FeNqP/YgV9Jh188TWJAtrOBFtYTr+Bs9DsiZAOfOktsxQVv/WkbxQ49eQcxcEktkjXX7aasVxl3ucRstGJ058M+4dD7Skr01wOpsCTGyTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712087870; c=relaxed/simple;
	bh=dktNbJSE4AMUUSXBqDMDbOSzD2AIdHi/2em6bOnXPak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLV/IfllqhI59XOI03WIRTqk6zmH6Y7+OG7ijEGJR3XJC1c2FljtiTf5xZwcOt3fXD1lSI/vOBTr//UHG32zo7czk1eAI0HPGL9r7iP9fpUHoz3TJ1VcWOmedphCZHTgqAAv/7jAhDB6j7yxKOaNClkXS27qWGMG75RTx0V7QNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JfcLL3i3; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JfcLL3i3"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a466e53f8c0so735857366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 12:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1712087867; x=1712692667; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xZSMPyJcLDwQQyPD929o3b508jAKY9ueBln0f3F7O4Q=;
        b=JfcLL3i3PdK7wv2sEyz4cXov4Z62Zki8RgUy14bG3Eib3XhNuMiPEWOSQiQUzLpHBm
         My2ujZpqcO9taABeOSLgao5uK/YO/SURhEhdHOUMg3CU17XzttDfDRimYVQ4+Kv73Ll/
         +cKbLhlg3uZzDE6d5H0K76Au7a+pLGEs02TX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712087867; x=1712692667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZSMPyJcLDwQQyPD929o3b508jAKY9ueBln0f3F7O4Q=;
        b=sCbsbvyaqqcBejAgFCfVlFIUcj72pU42e9L4S9YEmsBe1cJlVbj+UFdpWV/Xm7uYhx
         X3gGqJz7Nfd4iuBmjB1EWChSzdy9k2jmQS4Dzz8DoDaT31Fi+SmxM83z26cq6PaDZx2B
         P5rIvacuIdSKfIiB/xc58seLQGSh+AeBjnKp7olD4n4hjLWKSoLtF+lp8NiAWla0qdoF
         dPXNhgkqLCqVKde7Jk+f+TBIsYsUmzrCrbI7AR4Qq5oUiPv1740aaVBEl5kyCu2VVvVR
         0MQQKd3orfIISwYdBc3NYylmS7Qqs10VAGVUUMaQiJJk3RcvvIq1V1n51wVl2KIR4hlF
         3oFg==
X-Forwarded-Encrypted: i=1; AJvYcCWy4Tp1+l8NMPCabXsP0L3UMvMUXT7XBc9M9KxaWIHNU4c3YxADb+NH9CbMSW+NKQDKntBYlOvcmCd8KAoBQIEPCBEUpPpMuJxgJw==
X-Gm-Message-State: AOJu0Yyi3SKqaHdwF+ThfG8aW4cC9JZ18+HCRJbSm3mBSsskGghFmIxY
	ECxlM2R03o2h4ETyva/Wt6vrkV+zJWEiKcwIQwT7RYd3OSe7RtS0Z6QvnQn5JWSWNhXz3xreV5V
	HwVU=
X-Google-Smtp-Source: AGHT+IGVZIswv8oxsQPlcBcaAsaaW4Xh7sewFjKfYX+P+OPu5vqDjD7Bndk3R4gVAxCcK99LHruiTw==
X-Received: by 2002:a17:906:144f:b0:a4e:26fc:542c with SMTP id q15-20020a170906144f00b00a4e26fc542cmr10091257ejc.43.1712087867016;
        Tue, 02 Apr 2024 12:57:47 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id x15-20020a170906710f00b00a46cc48ab13sm6883724ejj.62.2024.04.02.12.57.45
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 12:57:46 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a467d8efe78so702648066b.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 12:57:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX2BeErrRYgIXgLnZc/as4w6l1YhfIr2gvO5SY2+dlKldpuyF1IoT3G9kmmHc+HvBcgNNPc66/Hq6rmvNzV+g7Mh0HZLg4PV2y8qw==
X-Received: by 2002:a17:906:5794:b0:a4e:7b8e:35ae with SMTP id
 k20-20020a170906579400b00a4e7b8e35aemr3749307ejq.38.1712087865212; Tue, 02
 Apr 2024 12:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402141145.2685631-1-roberto.sassu@huaweicloud.com> <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com>
In-Reply-To: <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Apr 2024 12:57:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjjx3oZ55Uyaw9N_kboHdiScLkXAu05CmPF_p_UhQ-tbw@mail.gmail.com>
Message-ID: <CAHk-=wjjx3oZ55Uyaw9N_kboHdiScLkXAu05CmPF_p_UhQ-tbw@mail.gmail.com>
Subject: Re: [GIT PULL] security changes for v6.9-rc3
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 12:39, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>

>    void security_path_post_mknod(struct mnt_idmap *idmap, struct dentry *dentry)
>    {
>   -     if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
>   +     struct inode *inode = d_backing_inode(dentry);
>   +     if (unlikely(!inode || IS_PRIVATE(inode)))
>                 return;
>         call_void_hook(path_post_mknod, idmap, dentry);

Hmm. We do have other hooks that get called for this case.

For fsnotify_create() we actually have a comment about this:

 * fsnotify_create - 'name' was linked in
 *
 * Caller must make sure that dentry->d_name is stable.
 * Note: some filesystems (e.g. kernfs) leave @dentry negative and instantiate
 * ->d_inode later

and audit_inode_child() ends up having a

        if (inode)
                handle_one(inode);

in it.

So in other cases we do handle the NULL, but it does seem like the
other cases actually do validaly want to deal with this (ie the
fsnotify case will say "the directory that mknod was done in was
changed" even if it doesn't know what the change is.

But for the security case, it really doesn't seem to make much sense
to check a mknod() that you don't know the result of.

I do wonder if that "!inode" test might also be more specific with
"d_unhashed(dentry)". But that would only make sense if we moved this
test from security_path_post_mknod() into the caller itself, ie we
could possibly do something like this instead (or in addition to):

  -     if (error)
  -             goto out2;
  -     security_path_post_mknod(idmap, dentry);
  +     if (!error && !d_unhashed(dentry))
  +             security_path_post_mknod(idmap, dentry);

which might also be sensible.

Al? Anybody?

                Linus
