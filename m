Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1786D1D12E4
	for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724347854; cv=none; b=OqZ/m1jrTnNrwgVdD1lXyrbbZuVt+/eUbUudRIo7HKIxLu185I0hoS+6ZCBGOjluhErYHU7XldJcMlRyfSC4qXwR0f0PeBPA3xbvhgzZ2tKjhuC39gz8tWpBv4uboiupx/0YhW08FEPysO55Cm8fAh6+DchRIriSW54uQln8bLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724347854; c=relaxed/simple;
	bh=pFF35G4zBee/jFdCz/28ldzEkNT1EJeAqfElqaghaNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uilWWWON8DppW6m1qBATzYVws/WizbS+mnVrmFTKw1AipIyfdP9fP+2YG+4pof7wstDtYBjMa5JXkR0/noK4PRvqpcWE/svplcBemdkKeiZzEAUPbnfSqnS2QUB8QCq35fxHbak2AslPEmMk8ZmhX9GIo48n9jngjFAFAO0l3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gh30R977; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gh30R977"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-533488ffb03so1482966e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 10:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724347851; x=1724952651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xPJH212JwWB7WedVgyWVdLLIwuLeZ8eFNT+sFZG9JY=;
        b=Gh30R977Ct0BleU4ctV5hjrn1IzHZAh5VF5tyZkA+rY/DMB1jidoJ6tSQoGgeUXjM8
         uJlenAhvWZ2QeVGo/3ISJydzBHnkOtibS+6Y4qyoz0F7YXQ55zGopH6SDshM421U3uKd
         Yyyj9LfmiTMZkFZZNhcdul+g42oSS5KIhXQainuRfXwD2cKARl9pSZz51eG4e91+3B1c
         asx7bPEk3NkCQdpQc6OpFbOYYb9OMATN0wiEF399xqt7hj5KvNMrA2KREnYgWOMCfk+S
         iR4A8daCdvEePMWbmStTxAkQ1K/pEqtPMxX8VtmeO4AbqadiAhuZkA+WZiEQHCyUOHqY
         YXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724347851; x=1724952651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+xPJH212JwWB7WedVgyWVdLLIwuLeZ8eFNT+sFZG9JY=;
        b=FCL258zn4rPrEQR72BrIa0yHw6iH/OHnVl23vI/CEFz6ZxtqJ21EEBXSGg76+ZggcZ
         RnZIoj1X3m4jbgMzefGdjV1s+ho2G40r62IFi2vLRyqgr0j7mRTfBG77IEkEmVGmpBDA
         F4/fbXgXpXGjDIFs5De9o62wvjBUeN2qzqPpvO7hY+4MdmWGrf3DLAZtjZymjPe2v2S8
         OrL8auYPFb8/pXsr/rUm9+VMOGcmTXsg1cai6SaNcqGnMAhYtU9C4fKHq2wZBNy4hvpB
         O/yxA8eqyStq7gVdOYkcLjsz/ch8CISnCK4536amYKnzPCMWWQzbt/XWSQHycLSZP5KQ
         Mdfw==
X-Gm-Message-State: AOJu0Yxoy+SpDgq2N90lRKDF0CYU8iJAilCzQfjIxu1gfyvbdXzghKF1
	+Lr/giKT1Mkqua9CXOvpannorGgusZE0TJN8iz8ro9BMkhbEoxl5QjL/5Q4Tlqaz8dQstr8FUUu
	3/Q5lJiBKmNivoWkRzKhehWRpBXk=
X-Google-Smtp-Source: AGHT+IGh4apIP84Ma8peWVdFN0RDF16hCKU/v60PjdFW8p6eWwiaXcv7o3Ndq2C9tO0WU9OvHn1Z1awR9XxmVf18TiI=
X-Received: by 2002:a05:6512:b89:b0:52e:987f:cfc6 with SMTP id
 2adb3069b0e04-5334fd5a353mr1818708e87.51.1724347850608; Thu, 22 Aug 2024
 10:30:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJA0AO+5YGXUKhnb0rtnezrNufZkpMAAuJ5tEKTibgig@mail.gmail.com>
 <CAH2r5mt=7PjoDbZYFm8fKN-7YCtMLE4d-fs=U7nc77sxZEmehQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt=7PjoDbZYFm8fKN-7YCtMLE4d-fs=U7nc77sxZEmehQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 22 Aug 2024 23:00:39 +0530
Message-ID: <CANT5p=rPg=5JcokpqZ-LNTEn823yAHC-QycpWyNzZQcxt=9-zQ@mail.gmail.com>
Subject: Re: [PATCH][SMB CLIENT] fix refcount issue that shutdown related
 xfstests uncovered
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 10:39=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> This does not fix the umount/mount busy errors you see with tests like
> generic/043 and generic/048 but it does fix the rmmod problem.   And
> FYI there is a workaround for fixing the umount/mount issues in those
> tests - by simply adding a 1 second delay in umount.  We need to
> continue to debug the generic/043 and generic/048 umount busy errors
>
>
> On Fri, Aug 16, 2024 at 4:56=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> >     smb3: fix problem unloading module due to leaked refcount on shutdo=
wn
> >
> >     The shutdown ioctl can leak a refcount on the tlink which can
> >     prevent rmmod (unloading the cifs.ko) module from working.
> >
> >     Found while debugging xfstest generic/043
> >
> >     Fixes: 69ca1f57555f ("smb3: add dynamic tracepoints for shutdown io=
ctl")
> >
> > See attached
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

Looks good to me.
Did you do a cursory check to see if we drop references in all other
places where we call cifs_sb_tlink? Just for completeness?

--=20
Regards,
Shyam
