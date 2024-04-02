Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA37B15B96C
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086788; cv=none; b=ljYjzujIQqhlVDKocK7mqOq1zGUv0kS5PafNTn1NMHb+iicDszQ7tTa0qbwhX05YGZOQb/IAXGtAnyIh0SpqWA3YIBgHI0lHNsP2QC7Qv88+xxMlyRLOFzMVSrVT6hKi+GQ/lUEqlivz48xTBBg0HDVFrwUyIf8Pd3Fnl3T1yzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086788; c=relaxed/simple;
	bh=FUitx7MgiMoEaaLuPTTMRh2BBePYzO9uMUChIAgHet4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qSI/kl8w9FsQyS4sOYVzpJlJkRrVXrzVRe6IBSKjlBKr0dQXt6zow5XMC5oRzBzJw1M3Qh61Z++52q4p1AWJzRQnFE3YBlQJtvaXgY8vMLbJ2fREl+bB0L2sPdsZKMZKMxyAZYupa+/n+CscOFGFiwiEDaFG5bIUG1B7aVMN6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P7FTA2jL; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P7FTA2jL"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-516a0b7f864so2507125e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 12:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1712086785; x=1712691585; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0mQeGyOEkrbKK1USpW42EOtHV5nHSHeR2mY3J6ZfsUg=;
        b=P7FTA2jLoXfsCEtkxUDirRllSwd19LRpNYr/iGBO5t318EPrbrZ39u1tsh47t8Ulo2
         jLLSfOpozJBe/dazhfqMaB1G8OpvLowTauwQQ2YFZKFfUiPvepG3XlWsqEcWAfzsx8nu
         FSOKiZGXPGjOb0JnVv0dIIWsYk5w+O1Y38Uic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712086785; x=1712691585;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mQeGyOEkrbKK1USpW42EOtHV5nHSHeR2mY3J6ZfsUg=;
        b=Dnv5aA8X+FZfbHKGe7wuSFPFemppmO+0iKHmTOB1V1PAvMu0uL8paHFJHtS5aBNFd4
         fiKeEjLf97mY6SQkX36Kof4IwNSj6Q6nxja6J0K+NDDJoW4CryqXf/p1t8zQO0zWhnll
         Wc7mHVwZqRTntdx3jiov/zvaqPpC1Cahas3z59GAkBFzPgsDwIE5Km5GslK7Rld05pQE
         d3swva0lm/Ekk8D6KXAKhXzOliYdja8WgEJ+Kpinrijet8Cde/SlJzKfIMZUQH3ezx3a
         x8FqeQ6bWGc1h8MycYhr1mw8vLh7Ptk2eak/kHqTFTAO3oEiAJ+3oOLe5THpPYoUPFeA
         eL+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyXk4DuMso25VRt3cSpJo14SbqdIHWM/7FP3tSvydkxCTEj/3XTv300NwjoBZPtrveA7e+X47GNfV0JANjq7OPC230HrAs48PLPA==
X-Gm-Message-State: AOJu0YxyxBIPo5T05IqGJ5Qv0OpUPegl/pUFrVl4/5W5a/en3RConB4l
	Q28xIG5PUWEBhCgyodyUZOosA1Hv8Y8UjE/qxVPM2x26374UyhUjicTsBMz3JIRTy/ZSwnmFXLm
	nvy8=
X-Google-Smtp-Source: AGHT+IE68NOGktOPBi4waEXWNP8IweF1o/3g9AkkRo/lvBXFjf8E0YOHYqX601uw8vjUoTCmVHULJw==
X-Received: by 2002:ac2:4e95:0:b0:512:b0a7:2943 with SMTP id o21-20020ac24e95000000b00512b0a72943mr8031398lfr.5.1712086784819;
        Tue, 02 Apr 2024 12:39:44 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id p28-20020a056402501c00b0056c4a5c350asm7077471eda.11.2024.04.02.12.39.43
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 12:39:43 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56c5d05128dso4249619a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 12:39:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWr5aTgIJegJm5OInEEcOT5CNizY5aE75bKyZXkpPNsWx5NxE+VLChAyRPNboZQuyt/84/pG3CPXY6IICUcje1vS+/614+JazCmOA==
X-Received: by 2002:a17:906:2698:b0:a47:4d61:de44 with SMTP id
 t24-20020a170906269800b00a474d61de44mr8673776ejc.55.1712086783205; Tue, 02
 Apr 2024 12:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402141145.2685631-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20240402141145.2685631-1-roberto.sassu@huaweicloud.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Apr 2024 12:39:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com>
Message-ID: <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com>
Subject: Re: [GIT PULL] security changes for v6.9-rc3
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 07:12, Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> A single bug fix to address a kernel panic in the newly introduced function
> security_path_post_mknod.

So I've pulled from you before, but I still don't have a signature
chain for your key (not that I can even find the key itself, much less
a signature chain).

Last time I pulled, it was after having everybody else just verify the
actual commit.

This time, the commit looks like a valid "avoid NULL", but I have to
say that I also think the security layer code in question is ENTIRELY
WRONG.

IOW, as far as I can tell, the mknod() system call may indeed leave
the dentry unhashed, and rely on anybody who then wants to use the new
special file to just do a "lookup()" to actually use it.

HOWEVER.

That also means that the whole notion of "post_path_mknod() is
complete and utter hoghwash. There is not anything that the security
layer can possibly validly do.

End result: instead of checking the 'inode' for NULL, I think the
right fix is to remove that meaningless security hook. It cannot do
anything sane, since one option is always 'the inode hasn't been
initialized yet".

Put another way: any security hook that checks inode in
security_path_post_mknod() seems simply buggy.

But if we really want to do this ("if mknod creates a positive dentry,
I won't see it in lookup, so I want to appraise it now"), then we
should just deal with this in the generic layer with some hack like
this:

  --- a/security/security.c
  +++ b/security/security.c
  @@ -1801,7 +1801,8 @@ EXPORT_SYMBOL(security_path_mknod);
    */
   void security_path_post_mknod(struct mnt_idmap *idmap, struct dentry *dentry)
   {
  -     if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
  +     struct inode *inode = d_backing_inode(dentry);
  +     if (unlikely(!inode || IS_PRIVATE(inode)))
                return;
        call_void_hook(path_post_mknod, idmap, dentry);
   }

and IMA and EVM would have to do any validation at lookup() time for
the cases where the dentry wasn't hashed by ->mknod.

Anyway, all of this is to say that I don't feel like I can pull this without
 (a) more acks by people
and
 (b) explanations for why the simpler fix to just
security_path_post_mknod() isn't the right fix.

                 Linus
