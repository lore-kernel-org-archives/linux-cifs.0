Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67612F690F
	for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 07:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771053539; cv=pass; b=ArS5+QFrgv21KhtIW5/0PERGjQoMgSwpL/aRr0vR/HVuGcimsO/7nmyn+dLpTSsaTxTENPARSO/oGECH+fwwyeIGw/z1ChH6RPspv+BVXoKiQ0DHgEX6PKCuklcGSbqoR//K8JSkJ6Y0fVWkiWlGIke/DvCx5+F2s+Ue2KLGb+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771053539; c=relaxed/simple;
	bh=0Qv8GL8RBzzytpJR0VI+Gyuj9nuOjeBLm77Rd1BVR5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etbg3unn79M3eFH6mMbAvO38cRRrecsfahmqgBt4Tl12bPyOzcC4OxOOvABiqQuFWjDaQbC5prVb/6RExNMIpGs6M5kHOklzlSpiJh2y0WAANljOJRRGpsemQUrQUwFbKHsi7pbBAtSamlSb3bAls/WUqhBmbcw4w8MS+g6gZoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b6pIfWrY; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b6pIfWrY"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b885e8c6727so250742466b.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Feb 2026 23:18:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771053536; cv=none;
        d=google.com; s=arc-20240605;
        b=VOijz4sEKDF+q3XArQ2eYjVFi8YGbgtaGiA0xIkUCE+lusyK6lx/kG8sPWZd67dJZi
         Zq4UzJhmuO/x3W+ie5vMB3t61KQttoFOXsuqVG+dgtZmAVjA0tvYGKhgBr2Me/Gt15fV
         G2JKHSijW86yUdZZt5SGlCZAbtM/UIVq/sq2eg+CcjU4F1m3rxQz1fn5P3XjoIQplVyH
         7iG4/lWdZoNia8dgiFrVuvPOdySSgB9EPQ9+vJA5XQkUj1Q4MPtgQokPhLXaAvgOcDJP
         9GM3jhV/LXvTEfNQ18Fc0sX/maHFCv+6r4kYNoNHVv1Ycn6ttuMpoAHgFyl+Wko4+G4B
         oZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Qv8GL8RBzzytpJR0VI+Gyuj9nuOjeBLm77Rd1BVR5k=;
        fh=B9hwwkLEMc02VaExecPmrkHAUQhWxp5TZoph8qfs308=;
        b=iurdyKTUr4Dhk0uHAxn8VlcnPGBNfARviQmAe4L7V2/j0TRF7+MZNRO+r8iXP0+VuZ
         OdP8QXfY6d2mZjynT04gKfnJix0X+urhAdcTwvW5T2eDMJtUpsbIFHvw4TayA1ZH847/
         FtJIcgdGcijcMcQHv7ZpSFcItmA/p8Y4IrqMFsReyhX2KNz4efngfriZkdvSLcokuKwS
         il2kFP3ajtEyOzy4lb6xyqghllhYgC4O6Npo+C3SHJgzJwpGgTh52pB9uP/9TH6zrHK1
         5o3ANh7kPgXjHsZUFQIRXb/nCZIzGF0YuvLBfa7W8wPeGME5Wvu2JxOJNeGA++LfePPt
         3ihQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771053536; x=1771658336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Qv8GL8RBzzytpJR0VI+Gyuj9nuOjeBLm77Rd1BVR5k=;
        b=b6pIfWrYYcMCt6iLaoVHzoZ6hGNtw+tar0Nyep+iI+U6NSff0Q1+F+bP32NUvVw6qS
         zp5E8xGrqebFVU1+1kHEcwc4NrWSyGjvS1uzqOuaF2Om7zM1o5q3WQzqsaj/jMfXQN6D
         EpVC/6ijQYx/H8HRpbSlbC3f2DIWkbQ1M6q/ZxX7ESsIBFVOzecn1OtPn2r1UZqz8jH6
         1N+1FGz5RBUR4HS4GKXi84oyfhet6DCf34w223Egnvi4zaQHeWTya1oK8mbdA3flXkvn
         LAo7XdOs+rwD5wIPWwUJUE6v1nichzkcQgZ3yxryl5NvXehEFuIeo5RtO+bcD3C4lhZG
         L61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771053536; x=1771658336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Qv8GL8RBzzytpJR0VI+Gyuj9nuOjeBLm77Rd1BVR5k=;
        b=ffYBLzg/GOCsJ1LqRW/qxTKGqo0sNRzKzmRhzCjwN4I6dDgA6v3IMAHryftW3gdjHs
         ybS7VfCrfqHdBU3NGphd2l6Sm4eUdg6ZlAN1kecFA9cfSLAFRREcqvTRYbTs4+USidmt
         FAE6CpUARXx4V2s/e5tL4XsuUOlRK5kHxW88fiCGoqyehzZXa9m9yh8zyAREOtsh+7Oe
         r3lxATEEAWd3tjsbmoiVlYdJk4RFuS124mlHC+xlL3A1bEEq2+rQUkcc+WUagu0z9Hq3
         iKik9/7P360JU9faqhT9OtXVG7iFJjZ9ZfJ+8mYtYoiR+PbMSB0cjC9/sPKX29qiBJRi
         ciAQ==
X-Gm-Message-State: AOJu0YyVesTwYR6BT2uRc5JIPnydAd3K/ZiWteUCy5XVy1WpWLV3RT41
	mz698S/+SZt0iKy5j2NIj4w+eUF3H3u4w1ZoS2gLuYjwhCS37iZjeufdavgPatXhLsXj/8V0K27
	qMBlc1sCpIU4e1BF530GrTWAY2gFGe0Q=
X-Gm-Gg: AZuq6aLXVWmiK+v1fAfhdUg42WkXxasLZG4UaD3o3Hk0CCQDNUV+QA1vHE4H2yys8n2
	tLEUB1RObX+Gn5P+rWtITEsI2twCKlwYOfuKw5h6dNVZzbf9zkOkh2OT8EgFOagmZBs13/4jFLe
	amPjIFCKOg+lu4oKcFEgPwNkA4NL/Wm+k9IUJafYWA3P8/GF2gkFLzWo2RCHQcyKgOCThrXDkgo
	JmrdK8h9Ff8RmcTP3nBKYiUt20nAs18iiKOrvH2fG6wMDn4bB+KLs2pohCRWzjiA4E++TdWEqMH
	8cBiNw==
X-Received: by 2002:a17:906:f581:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b8fc067b1e3mr153007966b.18.1771053535995; Fri, 13 Feb 2026
 23:18:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
 <2463050.1770046784@warthog.procyon.org.uk>
In-Reply-To: <2463050.1770046784@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 14 Feb 2026 12:48:43 +0530
X-Gm-Features: AZwV_QjsC1G_9g69PMQhQv98YIAp_JSZdEXJ11fS2M2tmskYtY5DnQV5oOWVgYI
Message-ID: <CANT5p=qbC9qkYwuH4CNYVSR-SSAgqqxC1iGfLJF=HeHGaNaM9w@mail.gmail.com>
Subject: Re: Problem with existing SMB client mount code
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 2, 2026 at 9:09=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > There's a problem that I noted with SMB client mounting code
> > (cifs_smb3_do_mount). In this function, we first setup a cifs_sb, do
> > the cifs_mount, and then check to see if an existing sb can be reused
> > with sget. If it can be reused, we free the cifs_sb we allocated using
> > cifs_umount and happily share the superblock that sget returned us. We
> > leave the task of superblock maintenance completely up to VFS. The
> > problem comes when we get a remount call on one of the mounts sharing
> > a superblock. Today, we do not have any way to tell whether the mount
> > for which the remount call has come is being shared with another
> > mount. So any remount changes will reflect for all the mounts that
> > share the sb. This might not be what the user intends to do.
> >
> > I did a quick check of which filesystems make use of sget, and there
> > are not a lot. Other than SMB client, there's ext4 that seems to use
> > this for their testing, and 9p who do not provide a test function (SMB
> > client provides a test function in cifs_match_super).
> >
> > I think this maybe a problem for users. I propose calling sget without
> > the test function, so that we do not end up sharing superblock
> > instances. Please let me know your opinion on this.
>
> The problem really is that remount is being overloaded and abused as an A=
PI -
> but there's not a whole lot we can do about that.
>
> The problem with not sharing the superblock is that you don't share any o=
f the
> caches - not pagecache, not fscache.
>
> The question is: Why might someone want to remount?
When a change in mount opts are necessary, what's the alternative?
>
> David
>


--=20
Regards,
Shyam
