Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B117D1B85C6
	for <linux-cifs@vger.kernel.org>; Sun, 15 Sep 2024 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726361893; cv=none; b=boiXcwah5DpmhDDgs49TtJk736XSinowqb9N7apc8KNteY4asUNUz9fxlGZl+mc5npNTkmk9SPff2TH6htpZueQTBEbllou9MvKnuLQfIdM6zx8EfB3F44k1ifFZZ59/BYbAM/oZ6uDsPJdtlbxy0CBIBYf3SjSHWB/4d4Fa59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726361893; c=relaxed/simple;
	bh=aaYbUbDkI30Wo4N3wpCfu019Ws+p5t6E0pP1yI6GSKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+LTxf/qNXLx8ziPhYHW2w8XDFYFuejs3j+aviiynk1/JXfngPTj39aeMp8MgHwgvD/ueq9UTXfY4YGKs0szcBes3O3YFokh7kx3uptMm62abkL0v0dMtet6NzXKgjrdsn+SAklEnADV4lk8DWL7dM7X+pJKnmu3+olCGsn8J8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aVga3280; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVga3280"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53567b4c3f4so3203906e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 17:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726361889; x=1726966689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPoFrtCDetskueGdyboT6qYilA5K00QKHOWgVVetrog=;
        b=aVga3280MpKhCCtl73uwP0tpMC0cSeiosj0aSBUeBeT3xKglNdkCHY2ulvU8bJ3gcj
         ZbFBOY/JIg/kGKVcZQ5U+m0osrVA1KY4daCBLdHnu36e5rFvgT3tmXOief8jXCwDuzWC
         VqJWuY0hDdnCm/4a+ElJfoknLhKSJ4YF6eUQtuDEY9RKoVMylFaW5L5ISvP8RJERWzw2
         uEcQ7MbUUpE41hlsSROzI/wlqK4HNmCC/QUrcBNNMXq9ureut7jyU9gH0niZTeDl6iie
         p4v5SzzrHCGZLvKZTZ/JBRJhdrKfMeTd0p80veQNNhM4NzKL+2hVrUj3COwmbe0U7Cwd
         EUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726361889; x=1726966689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UPoFrtCDetskueGdyboT6qYilA5K00QKHOWgVVetrog=;
        b=m2uBRSGROqVwxGBl0r8uM2Y/U9GIPCXMtkHFHaJwXy44vSV2qC1/rreCXblPdg9Jph
         M+dbD/IWEqN35SXj/mNiMvwY1sS8l9h0g187US4Ca5UkPqtbg5Y7Tsr2+jICUc8HrbCX
         j3muOURpgs6IIWfcnhJTEGLlvxuLkOt8ifXamXYGMZCk2ze2tKpQB/HZKmbtUzThBLhB
         JlVbYZODevqSf/0ipoj5oaEu7WvYgL5vKjUSA/GaUQnoS4ttwlu1XIR+qled8bfu4AXN
         ydLPKPTw5MY9YcT1xpiF+jJCwIafht1m8KdLe3nE7H4lJWXJgMfdEHl+59jSC8eEXv9p
         tq1g==
X-Gm-Message-State: AOJu0YwCog/Gq//POnHZPRdRgcRp4S+Nco3KmnWCGeuPaJGjy9rno2uV
	8XQJLCiZJJHZ5SjvzRrA7ipjni83xYl+1Ffu9mdLe6Q0q5uJ9NI3qshxUu8bPExsKut2bvzQIfj
	PAXTSk/UUc8kRAHAordrJW6PN7CK/O6ik
X-Google-Smtp-Source: AGHT+IHkOmraX1l/x35ow6jIAuL6/cP4MLR6xFEnuPJLPcTIziaPBQP2rwcY+plzm8tfLVvAENU+W2UF0U3KUoPd6KE=
X-Received: by 2002:a05:6512:3ba3:b0:52c:ebd0:609 with SMTP id
 2adb3069b0e04-53678fb4611mr6133017e87.7.1726361889140; Sat, 14 Sep 2024
 17:58:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtDbD2uNdodE5WsOmzSoswn67eHAqGVjZJPHbX1ipkhSw@mail.gmail.com>
 <cca852e55291d5bb86ea646589b197d5@matoro.tk> <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk> <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com> <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
 <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com> <2925a37f946d1b96a7251f7be72ba341@matoro.tk>
 <2322699.1725442054@warthog.procyon.org.uk> <c8027078-bd61-449e-8199-908af20b1f10@moonlit-rail.com>
 <97a71be9-d274-4e9e-9928-dce062ba2a22@moonlit-rail.com> <693dc625d6be7f0154bcb5e4ee6a3561@matoro.tk>
 <70b36bc9-8b50-4765-b9fa-aa40db873d13@moonlit-rail.com> <CAH2r5mtEdn5tWBn3cs6chxxRdWNT1VFjYwYcsWU7sZkAqsW8rw@mail.gmail.com>
In-Reply-To: <CAH2r5mtEdn5tWBn3cs6chxxRdWNT1VFjYwYcsWU7sZkAqsW8rw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Sep 2024 19:57:57 -0500
Message-ID: <CAH2r5mvyR_qnS0LVJwhgWAJwT4k4hkO+RiqnfQVAkmUOOdAv_w@mail.gmail.com>
Subject: Fwd: CIFS lockup regression on SMB1 in 6.10
To: CIFS <linux-cifs@vger.kernel.org>
Cc: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>, matoro <matoro_mailinglist_kernel@matoro.tk>, 
	Bruno Haible <bruno@clisp.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2024 at 7:51=E2=80=AFPM Kris Karas (Bug Reporting)
<bugs-a21@moonlit-rail.com> wrote:
>
> Matoro wrote:
> > Kris Karas wrote:
> >> Just need a backport for 6.10.x to fix the missing NETFS_SREQ_HIT_EOF
> >> and rdata->actual_len.
> >
> > Hey, I haven't tested this myself but if it fixes the issue for others,
> > is there any way this can go into tip so that it lands in 6.11?
>
> The fix has already landed in 6.10.10.  Big thanks to Greg KH, David
> Howells, and Steve French for pushing this through the queue.
>
> Given 6.10.10, I assume the fix is upstream already, or should land with
> 6.11-rc8.  And if for some reason not, the patch that David Howells
> emailed earlier (Message-ID:
> <2322699.1725442054@warthog.procyon.org.uk>) applies cleanly against
> 6.11-rc should you wish to remediate manually.
>

The fix went into mainline Linux 11 days ago.  See this:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/smb/client?id=3Da68c74865f517e26728735aba0ae05055eaff76c

Let us know if you see other problems.  Thx for the report and testing.


--=20
Thanks,

Steve
