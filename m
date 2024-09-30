Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB11F41C65
	for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 04:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727670162; cv=none; b=glk9ekcTgxOL8m5+AM8B1JJynuC1+9mg/U8hMQ0qLtgS0+x3Ga+NMENuVq/r00JiZTTTbDexkuYTJcy4Qut4DJWD4EoDKmBrhxoY9LQNhpgc/Go5TXGDihsjCAh5Miwt3CzNBIVdFa9TK+5YDdxWYMrg836Oas3exrrJ3pkGfvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727670162; c=relaxed/simple;
	bh=0zMdvOX1v5L3zJs6h8lGoDvWCKWj6QRynB0vfo4xPSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E1pFNDT8TkXRK9aQA9s2cHjI+U++zc43qKWV7MN5Q1/jcYbhu8Jzksg29eUovOnLUiydaf3Hivvr65eGxOIm/LxzEYCI3l/u2/74sdJmZ8Uj7lwwRtkCKk4S1L1JBlIgc5luAveBZeOQJeg38nDTbbqtaKcQCVdWPv9fdTEaMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ITsu2H0Y; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITsu2H0Y"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2faccada15bso4815401fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 21:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727670159; x=1728274959; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlWJAa2wpeqWSyxOAqnjajE81At3dJ2FAnqUtDTKo2I=;
        b=ITsu2H0Y7xSawr3Y0qx1188CB2bcKw2xcb2Fg+cFLzW9ArpBXoXVPdF/7fK7yfLsjt
         tOiYbC5glXd/AUHrvqEi7IicHeuksu6XEmmghLBPXxAnTcBI2JGaN2qD6lI0MzURsM18
         CHgS3CF682GJEO5a279Sm3NBT9xduNpE/Jtxo6qhBDwQHVdwv7xErLNasRHiaaBIfEUc
         /btgknFjkeM9paUEx/83zLxGpW3xpKjDa4eoqbbMR4/90KsV0QMQG9fW/te8UjKdWL/H
         5CuR+f1bfRdVuFT2rEHMT2Jq9n+sZuWa8L0m7P7oNYweyKOnKiNOB8X08Ft6KR0ZTNbS
         qc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727670159; x=1728274959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KlWJAa2wpeqWSyxOAqnjajE81At3dJ2FAnqUtDTKo2I=;
        b=XO0ykpjw/RRBktfuQRI3/wG1j6eZaQwij04vcHb6bHpbbRw/sGICTqmpvz79BnKKpz
         fsU4EUQ/L0JEEhRoXSF5sptpyLDdQF7SEUYm4Jygg2FvdXAzuQmVEax0ym9y1cBQhobA
         o5SS5m52kZ6N2/ZIB/ZH6tn49IBPnCXluag0j2mUjaXSqSt7o7+foMLdflCPu9ADSOLJ
         JRP83AhZnq79ds7AbLkkxB2SXKWD1uz2rbLjKyW5DgHGq/7/3GKP4qimyf4SXPi2Q/Y4
         3uZOR0TM/YvQ++s+4+rVjZFp9qLQZTXvUcTEQ07drirMsvqHe3vkKUUeFHMiJsfljixS
         sIkg==
X-Gm-Message-State: AOJu0YwO/L+I4gUDjoPYeti+OOCjO5aYVhIuZ4vvX9W6h0SVtSrHYnzD
	piFjykLxntgrCPf5s7EzOyXYqlrAolsysxZ4Nxs9NUBlTPPj9OmT/T21tPD8JRUF5jx2S4OeDPF
	Gg7zLEwtr9q8JhzuezJCENwUBOoQ=
X-Google-Smtp-Source: AGHT+IH07JAUSu8aiU+pmumPRjKP9EhaFGJLy6x8XboYuMiX2Fs+ydzP2zI/KlI5nGnJmndbHvRh+lTLjsz6tpiCtts=
X-Received: by 2002:a05:6512:3a96:b0:535:6aa9:9868 with SMTP id
 2adb3069b0e04-5389fc3c27fmr5758146e87.19.1727670158431; Sun, 29 Sep 2024
 21:22:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
 <CAACuyFX7J9Ht2RdbarBFp+VvF9Y8800mezYMFVmQApaAzOKxYQ@mail.gmail.com>
In-Reply-To: <CAACuyFX7J9Ht2RdbarBFp+VvF9Y8800mezYMFVmQApaAzOKxYQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 23:22:26 -0500
Message-ID: <CAH2r5mt-Ui4_R0HMh9hDK-Xe5OhcZ2HJZMDCRffMOv8XsO=4cA@mail.gmail.com>
Subject: Re: xfstests generic/089
To: Anthony Nandaa <profnandaa@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 10:59=E2=80=AFPM Anthony Nandaa <profnandaa@gmail.c=
om> wrote:
>
> Hi Steve --
>
> On Sun, 29 Sept 2024 at 18:32, Steve French <smfrench@gmail.com> wrote:
> >
> > Has anyone seen xfstest generic/089 going forever (sending compounded
> > open/close then open then close forever)?  This was with current
> > for-next, running to current Samba master (localhost) with "linux"
> > mount option
>
> Getting the same, tests gets into an endless loop even in the
> for-next@f9494b6b6dcadd3ee1d70d27d1419d1084e98ff6 (Aug 20).
>
> Could you please remind me how to get more verbose logs, or
> an approach I can take to help debug this?

Take a look at the "Enabling Debugging" section of:

https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

As an alternative, I usually use dynamic tracing.  To start with, as the
problem repros:

"trace-cmd record -e cifs"
and then in another window
"trace-cmd show"

You can more narrowly trace one certain functions by selecting from
among those e.g. in

/sys/kernel/tracing/events/cifs/ and /sys/kernel/tracing/events/syscalls e.=
g.

"trace-cmd record -e smb3_open_* -e smb3_close_err -e smb3_reconnect*"

You can also can get an idea of what commands are being sent by looking at:
/proc/fs/cifs/Stats and see number of requests by command (and
checking to see what changes)
You can also look at what process is doing activity on the share by looking=
 at:
/proc/fs/cifs/open_files  and also seeing the requests in flight
("mids") by periodically looking at the bottom of
/proc/fs/cifs/DebugData

Also the additional Debugging section has an example of getting a call
graph if you can narrow it down more.


--=20
Thanks,

Steve
