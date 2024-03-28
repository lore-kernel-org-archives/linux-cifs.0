Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06665657CE
	for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711629805; cv=none; b=XaSFgdraTthYIuYEkXndmPb8EGqshGw6Q3vkE5a38xPPqa8uHgjdtB+xBh/+O9ZeeKJVJD53GMOEGqMygWUEOIkq7gpNL7LI+WfhsPBl/Uh1/zzRwKoM/XqpEhWnJMEVwk+xXQ+mB0DKG2BAorudy0HjvkC348uneCm5Zzdb5vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711629805; c=relaxed/simple;
	bh=wCjLEiLhsGuQ94t3e93iJvctAPVhr0te7y+obw6b26g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fxjZr8vxpa9nSSZNKRGs63MD9a+SAyyayyI5NmA3vRXEHokJndYiiTLKzXbQBC5sLo3ywAqT3UH57/s0KUMRh6lfcoVNBloa23SQ2olC3/1VyPYmWD67PXgVIOGZcrRYTlRXABREzPNx8inTW2shOS2IxjnoYZnC1FOcCT1/hUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Hvf5L1Nj; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Hvf5L1Nj"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dcc80d6004bso872776276.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 05:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1711629803; x=1712234603; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCjLEiLhsGuQ94t3e93iJvctAPVhr0te7y+obw6b26g=;
        b=Hvf5L1NjH4/ykBgdIa5Fxa9+LpTbH2QLO6I6Ik+wPfXD9pU5SOLOmLiJ57FguVH+IW
         tgYv8SqQSDYj5wp9N08GgrTgGKI6pFWXYV4funDAmXQt1GKrD/s1K20jwUKYELyGSyQE
         CngzRlMn41zkjUTCfszyPzDEovaa/ghaCFXANuwriEUJ+1ZWrJoiCs8X9aX8jlXG3QgQ
         wJtH7q64zF/WDtL94P/Veo4cXtPbdogJRNgWCJLmZs5h8tVdB+YssXUf9HUpHLkFA8Pm
         0zshluFnIv9eRPfWuquK8U/NZB0t7+EYTNLYUm0fzjkS2rvBEU3Q//X4FqoNkxJHmmzi
         YQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711629803; x=1712234603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wCjLEiLhsGuQ94t3e93iJvctAPVhr0te7y+obw6b26g=;
        b=QKjIOvtvKSl4Uffz8aURdJnuLzY5mv7n75XQ4M+Rr4DDiCfnCKktWHCMTHmXQPsFc1
         UcmTp90LaYf5rhnK7VtRYKjFvdlv58DymaZgNWKNdwuUkoo/rMKw8VG10QzaGI24np+1
         +GFPwLOGxJ7yDBmD1GVXWUMkASHEU3/7iqlSQydaOI/bRpcjyPwYFYY1o9vpoFlkXwhM
         vBZ3rzpfYj/l8ifRE33fLdwM4X7LD0oe0uvfel86xEWyRGjsLEai3V29b6Td7a4O9F3d
         czADfe0ROzwH2aADqJvgDF+Owe3PsL57QNJlY6q7Z3zyGjTKxHjfq5MPrenPKXYceJvc
         Y39A==
X-Forwarded-Encrypted: i=1; AJvYcCXWDqw8KVnaDuB+zrDd2grWdZgQODpJT1B9h9CvXrB9G5vnRfMm3vW6DWVfjYEyqtnADITnPAqVIXCVAIROmq8MgH2PC0h89KFVMQ==
X-Gm-Message-State: AOJu0YyqG+cb0IfcEEejKz7CZuRe0OEQlSfwBs9yxz4TTUXsyUsdT/5a
	HBBtOKp2SS5yRNPQJsYqoBmK+aYwhLiuai9oejIDwF9eG/I6ZAPQGRd5lKs8Dr05j16tkOVTFA7
	oYgOJ19kabROgNYBLyGg3VELW7Z2jtCa2Jp4o
X-Google-Smtp-Source: AGHT+IG7Hj+v9FZ9/91AWUqhCMCaVjwUtpSrpHnaDe3Rf5wZSA8LmhBKtZJ4gqRDkx5Ku7FJ96Rn9hqsd+NaW27OoP4=
X-Received: by 2002:a25:5f50:0:b0:dbd:4578:5891 with SMTP id
 h16-20020a255f50000000b00dbd45785891mr2423670ybm.65.1711629802827; Thu, 28
 Mar 2024 05:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msAVzxCUHHG8VKrMPUKQHmBpE6K9_vjhgDa1uAvwx4ppw@mail.gmail.com>
 <20240324054636.GT538574@ZenIV> <3441a4a1140944f5b418b70f557bca72@huawei.com>
 <20240325-beugen-kraftvoll-1390fd52d59c@brauner> <cb267d1c7988460094dbe19d1e7bcece@huawei.com>
 <20240326-halbkreis-wegstecken-8d5886e54d28@brauner> <4a0b28ba-be57-4443-b91e-1a744a0feabf@huaweicloud.com>
 <20240328-raushalten-krass-cb040068bde9@brauner> <4ad908dc-ddc5-492e-8ed4-d304156b5810@huaweicloud.com>
In-Reply-To: <4ad908dc-ddc5-492e-8ed4-d304156b5810@huaweicloud.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 28 Mar 2024 08:43:10 -0400
Message-ID: <CAHC9VhR9EL0CQRKpdJ5C9DLnb8YKCNZze+WnpRxn10ZHKCKzPw@mail.gmail.com>
Subject: Re: kernel crash in mknod
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Christian Brauner <brauner@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Christian Brauner <christian@brauner.io>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 7:24=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> On 3/28/2024 12:08 PM, Christian Brauner wrote:

...

> > And one another thing I'd like to point out is that the security hook i=
s
> > called "security_path_post_mknod()" while the evm and ima hooks are
> > called evm_post_path_mknod() and ima_post_path_mknod() respectively. In
> > other words:
> >
> > git grep _path_post_mknod() doesn't show the implementers of that hook
> > which is rather unfortunate. It would be better if the pattern were:
> >
> > <specific LSM>_$some_$ordered_$words()
>
> I know, yes. Didn't want to change just yet since people familiar with
> the IMA code know the current function name. I don't see any problem to
> rename the functions.

I'm sure this is what you are planning Roberto, but just so we are all
clear on this, please do the simple bugfix to resolve the mknod
problem and then do the parameter change and the name bikeshedding in
a separate patch.

--=20
paul-moore.com
