Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19DB2DB7B8
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787989023; cv=pass; b=TCnS0C7bGRxy5Mvj3us6ahxgRL40XNKlYOkq8JNMSQ2OBaW8wZgnSQo9+GdgzPOE9WEXZACtRs2x9hmgGODSWsWWJP27povf5eGLQ/ZbNJjeXzxNQ3KX0djbwWtgPNsQwwre088rXaE7DqBLjy42vlRDSTS+cViK/APrxmGntDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787989023; c=relaxed/simple;
	bh=Sq0THEICTPM284NMNHXd2EjYwdjNxq1DooR5QncznmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aCGxSHdWJwb7fPpb4w5jzroNAVOY0JBu5aMDuIKWQnsdywjf0bAxdCY5hEO4EZ1rUMty4JxaHoqu6O7q3qpZoLnm7MiOWjGyXI2EABd9bwZHuV3O0hirdG/j/aJ3aRMFoWBInUFHnUKq1+eCt6xiHi3ZTike5hTbDyllmWbP0QQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=ZVWFMtF+; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="ZVWFMtF+"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d01663d816so12535105ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 00:37:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787989021; cv=none;
        d=google.com; s=arc-20260327;
        b=cj59FeTAeIg7Io2R7uZr8+VcjGJ6jb2rzFoyro1O3Q6+UfoCewwVXVs0uvVABPeecw
         aOE1Mi8FW/+0kWqCnn7bpF5lcGRHczYMuBP493FXT/mkhoQQ+NoqKsx8aggnIb1xcbAP
         yNorHn7B2k6D60CNRsFYY5DFyEW4+87cCH2sBrwyJzIuVQwa/2wGRHySGYgfamD/VNYP
         FfsS8mbBbyBalX8Iz8v09qgG9bnBOQmWsEfNfrY8bhGV4+NHWAaeqBOD2hRtDDhOS1W4
         tQ379pwezsnUMPckzu5Bnqxbe8VDrMGf8OOw4b+pfiHwjRxYqc5+Hz2NLfD7PPQe7xA/
         6EQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3MSSL4DpI3S5luBJGd7I2XVsr9+lwZ5Fn38DQgSdC/s=;
        fh=IYDD4vKrLJwLvFzgPK1uifRb8oLrLIv+hFgyWeBeiT8=;
        b=or1JkFldmVtJSTrW9FDtG0EKgtfQFX85zGwk4lYBpOR3cdsw/HPKeBLZK1a0bUWx31
         UrebzC7Rf+45Azq7ZScJjxk8n/XOOzcZq7Tm92MsjCb2rDzfyrNx8Y3O7NFI2sM5mojq
         i+wISRzZfFvP5sY7dhdJ9vv5AA3ZsNvKS2EWe3JOtsB9eDqI3fv4noXziTpGWz5SJcOA
         erQrAVIRRSqjc2gzcAehdsxrVkyrkqdgpXYTl8rSzIPwQV5xvW5LdSanNzG20NoeE68v
         ivdWmUFD1wpjoHdCz/76atj65VDZ1MOsQcYsXXd2rgeNcSW7Xt4o+ktJ7vqfvEYTMtgf
         Y8Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787989021; x=1788593821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3MSSL4DpI3S5luBJGd7I2XVsr9+lwZ5Fn38DQgSdC/s=;
        b=ZVWFMtF+S06GRBvuwt2YMjMS/2gH+x5ENJz/rAEm3Qr9FFhoGhCgJXYOmkhDQxZkeg
         5LrGe/zG/euP+tf4emQ+8bMeyPa1SHrRr2DPRx2YuxCVno6vGflnxx7A3rA6g5RoL7eu
         5etlhYe+RkpwNFgP9GUUZwpWaA6p7TwMZc64xfKvTeGI1H72Emaip+sqVL+nJK9p9Ub0
         shBX6QRbVR7lfsmMtKz/7xVqwW8iRbtZGOaFiB/WIlhdY4+dSc3kvxJNV7p697AqJYbX
         ZJPC0cTcn3Zuyonq+k2NFjD3opzzwRbgQd4Oe1/rx+LVSKnjBXH8kn0qPY/NYq8neMOV
         IBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989021; x=1788593821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3MSSL4DpI3S5luBJGd7I2XVsr9+lwZ5Fn38DQgSdC/s=;
        b=Xzi8grY9y/BtjWDIqtRH17EozDiWg6OGzUFVi9ceDR3b+QPHGrdMSa/xYPdyAZaYXc
         o4avZwgA9DFEADUXNiKGCYigJvMvXMyizdlMArWX5qIIoHJN1Ll4ZmKMXVCPZOt1EFk5
         IBVcQREmUSmFefqsy7JFycld/Wvhk9Nt6ZmJ0sWXkByIiJfSu0tT5Fa4rzA8JEFY0DHn
         mweAFlnbrflY46UaCQhZlg67cwt+q+vf0IhrIyxnHvqh4uPBt3X7mN8hu1GMWLSjF2+n
         l5XotQQ6SrunM337U88yM2RECUIlfwBNFsK+wFakoMcDLiPqnkkNmmqD8/Py5cAk+qRp
         PNVw==
X-Forwarded-Encrypted: i=1; AKwUvBxPByYzFEWeP0Wx+HhyMf9rGtJULryupDERUUDYzfgB7Q8Y9Pc7HH/wOrT0V5z/5XSAJMGnycfHujU8@vger.kernel.org
X-Gm-Message-State: AFuF++mD94CwgQ6JezMYkNqDzt22NujS1tZQGSi7rUTTWWi8AiJSiMpc
	60OECULk7hsR8YjWj9H4KN3X/6fAMtmTMnk1oAF3RSrXooz9aDLPHZfULppnXGTl+GopTP2oLTW
	HKzX6o7Dy3okHLFfkNxFNS1TTUBHCUkcq1FznCQGh
X-Gm-Gg: AYBFou3LywLbLksQOIeWjukCEFA8CLNwxiQ7uPkGCzecHV/t7bzmOtC0Ae3HmpdEteH
	Poi7a/MQkvZaGUBbDsBs2ik8XG2Ee+K5Z6Abog+hgpp9nDmAFrocW65gEvWj2675V8pplG4Hqt4
	OHY84LX7emJk5j4kwx7tvYAi3hshjoVUKKii9XaVNrm/HGUHh+Fp+yNbT4dg32YKHh+wMtozTbs
	oZKGbnS0lKZAT5rZA3mV4h8yU/DPcHApyar628br+D+/IGkdygTbfLJcJg/XpgeZIUhkc+3PMgh
	iyCiFZVNfJKIWw8E4yozm/gqEKDru2UwZKVsmBrFFpu024PO0gOvQrC8GFuiakRT+kQlV1cJPWC
	YyHsZqhWuQmGrgeENZH4wUxeqZKjg+/M=
X-Received: by 2002:a17:903:3803:b0:2c8:2808:3ec9 with SMTP id
 d9443c01a7336-2d74df0328amr245182145ad.12.1787989020140; Sat, 29 Aug 2026
 00:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCjUB=g+56ZCrT4MPfWjqBJX_CO=vfp12JLOrh7B53uVWQ@mail.gmail.com>
 <CAKYAXd-+bctZycpVKNkQTifthktnWdfOHsKdsNBzL2droo_yHQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-+bctZycpVKNkQTifthktnWdfOHsKdsNBzL2droo_yHQ@mail.gmail.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Sat, 29 Aug 2026 00:36:47 -0700
X-Gm-Features: AcwNN1VBtp80MVnTOITevZF0ucoYfN-z3oSxf1HJNZTS2Qs4XRS_nWl-BWNkbVA
Message-ID: <CA+0ovCjKMHB-TquTScxKkmRascnfe6pfrruT_V_W1TXv5fbg4w@mail.gmail.com>
Subject: Re: [BUG] ksmbd: use-after-free on iface_list from the netdev notifier
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>, Steve French <smfrench@gmail.com>, 
	Steve French <sfrench@samba.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, falemi@asu.edu, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested on 388b607d107c07aaade04c7f22f344cab6bdccd3; patched version no
longer panics.
Thanks!

On Thu, Aug 27, 2026 at 7:39=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Fri, Aug 28, 2026 at 8:08=E2=80=AFAM Farhad Alemi <farhad.alemi@berkel=
ey.edu> wrote:
> >
> > Hello Namjae Jeon, Namjae Jeon,
> >
> > While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU'=
s
> > SEFCOM lab, we hit the crash below. Crash reports can be found here:
> >
> >   https://github.com/farhad-alemi/public_bug_reports/tree/main/117-ksmb=
d-unlocked-iface_list-uaf-netdev-event/
> >
> >   refcount_t: addition on 0; use-after-free.
> >   WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110
> > lib/refcount.c:25, CPU#1: kworker/u8:3/9983
> >   Modules linked in:
> >   CPU: 1 UID: 0 PID: 9983 Comm: kworker/u8:3 Not tainted 7.1.0-rc5 #1
> > PREEMPT(full)
> >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> > 1.16.3-debian-1.16.3-2 04/01/2014
> >   Workqueue: netns cleanup_net
> >   RIP: 0010:refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25
> >   Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 db 45 27 fd 48 8d 3d 04 03
> > 1a 0b 67 48 0f b9 3a eb 4a e8 c8 45 27 fd 48 8d 3d 01 03 1a 0b <67> 48
> > 0f b9 3a eb 37 e8 b5 45 27 fd 48 8d 3d fe 02 1a 0b 67 48 0f
> >
> > Our reproducer.c is available upon request.
> >
> > Happy to test a patch if that would help.
> Can you test if the attached patch fixes this issue?
>
> Thanks.
