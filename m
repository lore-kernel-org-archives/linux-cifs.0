Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6D21CCB36
	for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 17:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724348187; cv=none; b=p6Njws9BXTwjFhgJ4yQBOoKwALkQ+2HwkEn5K3914Sp1+dh7o5ELug7cwvYTbdgDG7+B790ZZHXhi7qXcM33y8AO0i8NIrwDKjWEavOLEVCm9GoH4ZmH8UakVl/3Jp5gqGL3TkngwXOOGAsPsBNaAZahQ5WjNiF5f8qvR0da0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724348187; c=relaxed/simple;
	bh=5y+qleLCtTb8iscVPAti4a9ne9F8ADupxh0NksWfSaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ckMMCPnhgpH8Bf14fFf4ho/G16iJgmU4AINcgJVaDjYCwp57taQ/TepcILzF1EUmcYIEemQ4PAItAabHdTZ8oCi8WyE787t9moepp7UYAOZiZtciYmV+ZRb0F3vr6pH90yVnOFxlvhlrU5MYA1ruwUnDwU5j/si5r46Rx4kxqj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1fYkqvu; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1fYkqvu"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5333b2fbedaso1826436e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 10:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724348183; x=1724952983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gf3rApFCdbSSRJY5b8KpJh8VGwLIsqZJqVP7wUb/lDQ=;
        b=J1fYkqvu3lzgLT/QvWUhFazM77f6ZWbAs+OqXmTpc0KAJjE7uDpysxPYsrNwgcMRQJ
         GIVYLE/lR0PQrhdpDY3ss1uowO0Z2FDOp/40gKnIFbKCn/f+aBBX0WtYpqVdHhp1tmHo
         qxqGmo9XCj9C5DcCzkhywsxbawY87PEv8EB0Kr+MXncoBl8/Mo8/mduzCD0h09arys1B
         O44DR13MVqQISKf38s+5RB9PrlD2LlnMZYM9ABvRu8qG8x9aE7/OOZ4h8RC/tU1Gb+Nj
         ZNRNAehgVoYJonAaS559geZ+1MpyPCu6xTRnXHayyS1MhEuJf5Jiy1GX4/FnpBzCas9q
         TE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724348183; x=1724952983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gf3rApFCdbSSRJY5b8KpJh8VGwLIsqZJqVP7wUb/lDQ=;
        b=OL/nFgsr1bKeCZQbiPDRCFkS3D24+FhE+K8zseY/bGt/6qZiF4BxByXPD7VuKukF0E
         oAXKVoivONuM8O/mvOsCBZYxFfXqP9SN16orBoYe2d//CkXuNWwIuD2mMA8Axa4zd9sE
         tyH1L3BYfEQ2u/s6K9/Swy3WjgZ7Ku3zfllXj6O+TmlJ9PBlYlcoDrKWV10AAv8kA2Id
         HbM+SNEaqwPiIVDZ8TCbowhlX5A/yskuV8xEGd0zXWDSo9dU7YeJxdaUXTEkbER6GWpk
         ATpzjFDymaUrhsldgBsxZlh8soEKO6nu4yksi8BNhnORb6+Cw3gW5FrU7tr0H7zcWjJg
         tIkA==
X-Gm-Message-State: AOJu0YymRfKxBCTXDbMJrTetdhWb3/oH5nE3kQYw8mJWDEdDYYk1/AZn
	dnauPPk45I17weV72bmZ3rIhkOYMFTmdPEdxahmfRZNkQYGfBHlX9oL/HKqOUhWanF2lB/csphq
	6thB46cNHSrtssP1Xki4b8qOlMfc=
X-Google-Smtp-Source: AGHT+IH5nIPoD9jQIVpxtgo+yZnpKYnyKJG2mPXVNsp2EOezd/nvNKuyIcOwnR+FW7r1wFCr2crHP6TbMTo56+H25cU=
X-Received: by 2002:a05:6512:2815:b0:52e:764b:b20d with SMTP id
 2adb3069b0e04-533485c04cemr4235855e87.28.1724348182966; Thu, 22 Aug 2024
 10:36:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJA0AO+5YGXUKhnb0rtnezrNufZkpMAAuJ5tEKTibgig@mail.gmail.com>
 <CAH2r5mt=7PjoDbZYFm8fKN-7YCtMLE4d-fs=U7nc77sxZEmehQ@mail.gmail.com> <CANT5p=rPg=5JcokpqZ-LNTEn823yAHC-QycpWyNzZQcxt=9-zQ@mail.gmail.com>
In-Reply-To: <CANT5p=rPg=5JcokpqZ-LNTEn823yAHC-QycpWyNzZQcxt=9-zQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 22 Aug 2024 12:36:11 -0500
Message-ID: <CAH2r5mtrXMg+EOUkELE+6UQcnoHg6PRCuG16-TA7LQxqM9P8aQ@mail.gmail.com>
Subject: Re: [PATCH][SMB CLIENT] fix refcount issue that shutdown related
 xfstests uncovered
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 12:30=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Sat, Aug 17, 2024 at 10:39=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > This does not fix the umount/mount busy errors you see with tests like
> > generic/043 and generic/048 but it does fix the rmmod problem.   And
> > FYI there is a workaround for fixing the umount/mount issues in those
> > tests - by simply adding a 1 second delay in umount.  We need to
> > continue to debug the generic/043 and generic/048 umount busy errors
> >
> >
> > On Fri, Aug 16, 2024 at 4:56=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > >     smb3: fix problem unloading module due to leaked refcount on shut=
down
> > >
> > >     The shutdown ioctl can leak a refcount on the tlink which can
> > >     prevent rmmod (unloading the cifs.ko) module from working.
> > >
> > >     Found while debugging xfstest generic/043
> > >
> > >     Fixes: 69ca1f57555f ("smb3: add dynamic tracepoints for shutdown =
ioctl")
> > >
> > > See attached
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Looks good to me.
> Did you do a cursory check to see if we drop references in all other
> places where we call cifs_sb_tlink? Just for completeness?

I have checked almost all (46) places we call it last week, but will
check the remaining ones today.


--=20
Thanks,

Steve
