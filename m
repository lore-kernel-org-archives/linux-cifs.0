Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E3346ADA
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 15:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776872215; cv=none; b=JRwUiBPyo3WgqiVNptfAHQLNG0msAbCL/N03JW/IYYTeo70pvc7rjuD3UMP4EH2MeV2IpQqeT8dMZbfabUmHr0RK1wINA1cDWDglDIw54Npc9eX9wDGsqdw44dpS5hVNN9Nqhz8R+kjd9POEgcrI0+zKSAELZtfMAU8xbOSEf60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776872215; c=relaxed/simple;
	bh=I4Jmwzz1ODBCvCGD3inyJttCoNK7K9OZ/Wca1zGloR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nu/HZHP4mYtRfUNQuZ+0B54cA3Lp26qc/W4RXjpOtNqF7EQxaXWQ+BT+PhVG7Ua8SuNQK4SqtpV5LhSdohls0CHxAtYTcwQZbVG5O/F39oo4YAwKC6RVAD8s36h4rw+MavxipxdzoCGAiy+xksC3Sk8C+17+UDeaJoBvC862RRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vw8CVfaF; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vw8CVfaF"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-671ab90fc1fso11255346a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 08:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776872212; x=1777477012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+DwNRPBKYrcNA3RvMgBSsOLry+hrRQ+hSlc37tD2IM=;
        b=Vw8CVfaFhOWz88/M1ZtiLWDed+XH5OxW/qxk2YX+LBUuRu8wSVkEh2MIoU4+FouNxf
         TsQ3xKv1ZKxmdQz9MAJFDxdRU6OT/TX/Uff9HbM2MTebHLrWb6iGtMp3TGoV2jhGcnsS
         263CeOLl0hEveRCjfN7UA5YYp90Ao3LeK0HFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776872212; x=1777477012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6+DwNRPBKYrcNA3RvMgBSsOLry+hrRQ+hSlc37tD2IM=;
        b=ggpA2qQ0d4AGVV3S5HAlr4yLhW7nnIZukEaUD+oLVN4GTN9RDVAnFHkVG1n9Q56qwk
         r8+AIHDGcRqPypehKUJOwaf4Di6LYkwB2IsW7PXwahfGuz6GZ9glEY8vVCvsn3C5re5F
         7xaytLto/2sfWoXw00tzAVuqKp2dLifqqAcQzEZq6TACyiryhvFqvv0v3CtDaUAZHy++
         OhC1w42DQeMw09wsc9gAAUUeJZZ8oUNo+Zln93XmQSn5eNMElSVi3HkIDg5Zmok7cNiy
         AsY0BGoC6Gu8VFeWCcuVMOYWN9ygYbo7SUY9+I4cmENqTLpK7Ta9ljqHl+sPG+/FHLM/
         YRzQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AuZ5CBCBALEI0Lb0uVDr1BbREbHfsZcuFHgQGhFkcDDEoJ26F3qsMpcaKZiYS1vqBRGyRVAz1HEHl@vger.kernel.org
X-Gm-Message-State: AOJu0YyT8GXI4sj1pOINophHcu0Hk43MpB2GS8Z37VDjuSSA9dVa2U4q
	F2SmyY+5lusPqqT8kTWLteoZ4btxkOKr/fI5UbrjQi646iEVs7SdXRJ3DglDemWoJjPSUT9PfHZ
	pObTSZ+g=
X-Gm-Gg: AeBDieu4Y0x4W28Akblq+eLCZdEoH6mbtmCnedL55YkevHHhBR/KLtxt7gloYayHWO0
	s4ADnR7Ner6mj+ygMwqRaJ90RY9z8QihXC+GPJlC4ShzHlma7Bd7pJQa8TZh399Jr4elzcrqp6S
	dpQRmDq651dvDOxZtmbiqGspHJ4OpEWAF9lFKckQGW/djuCts4XlIPUX3YvvslhErgacbanmpjP
	+vJGc1tQ8X+aJiEcE65H/x5Nlz9xjnFRqjNAwHD9n6hhLIq+N+Lzemv2Wz2CH8j43LpKUxBkVHm
	FAbMc+UK2Lub2c1+Kr0XUGeyIagwuQ8isndc+8WdyIWOu03gV1YJWc00X5Dgiy2tiVuOOwg5xMi
	42jEzc3M++IUK3+KQ36cyzjOsLJ+5lpdTmMLJ9C+eVqTPRSmBNdG194UXF2FB+P2bBADz1s2/je
	LcdY5hbp8wLxt6XZUstpua/SY9CdOWByd6WbrUsrA4WW5tzojo/OCFzkmpGJw0Ddd+N8kBbJwQe
	U6dDBnPS5o=
X-Received: by 2002:a05:6402:13cf:b0:66e:68e1:fc18 with SMTP id 4fb4d7f45d1cf-672bfddcf34mr11542072a12.23.1776872212271;
        Wed, 22 Apr 2026 08:36:52 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-672c4d508e7sm3284190a12.20.2026.04.22.08.36.51
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 08:36:51 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ba922426c5cso506945066b.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 08:36:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+rkQSI5MPBL6KpFgiCUyd5c+nVnH6vcfG4UpiIKWPIXzIUIomCsZS2E3b/lQL5ffUNOzIaymGeXiXh@vger.kernel.org
X-Received: by 2002:a17:907:a646:b0:ba9:3f1a:8735 with SMTP id
 a640c23a62f3a-ba93f1a878amr484489766b.33.1776872209534; Wed, 22 Apr 2026
 08:36:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419192018.3046449-1-metze@samba.org> <aehrPuY60VMcYGU8@infradead.org>
 <9cb0901c-18c5-4858-941c-3b37ee112af9@samba.org> <CAH2r5msb3-HiPSv+HgBknEwDXGsv0xU=TGCxHdmc-VCLKzYCmw@mail.gmail.com>
In-Reply-To: <CAH2r5msb3-HiPSv+HgBknEwDXGsv0xU=TGCxHdmc-VCLKzYCmw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Apr 2026 08:36:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=whHACPH7vBLo8CVSqR5-mgzP4ff7qJU6F=1exKTpQ0-7g@mail.gmail.com>
X-Gm-Features: AQROBzAXxjIZr7XwIp1v_ivj2KCglqqVek-fwbJ8jkNR7q5nEXQKW0WRvzxwAW8
Message-ID: <CAHk-=whHACPH7vBLo8CVSqR5-mgzP4ff7qJU6F=1exKTpQ0-7g@mail.gmail.com>
Subject: Re: [PATCH] smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org, 
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Apr 2026 at 07:49, Steve French <smfrench@gmail.com> wrote:
>
> On Wed, Apr 22, 2026 at 3:16=E2=80=AFAM Stefan Metzmacher <metze@samba.or=
g> wrote:
> > >
> > > Why is this not in net/smbdirect/ or driver/infiniband/ulp/smdirect?
> >
> > Yes, I also thought about net/smbdirect.
>
> I would prefer to leave it in fs/smb for the time being, since it makes i=
t
> easier to track since fs/smb/server and fs/smb/client have dependencies
> on it.   In the long run, I don't mind moving it, if it starts being
> used outside of smb client and server.

I personally have no hugely strong opinions, but I think Christophs
very question that gives two different alternative locations argues
for just leaving it in fs/smb/

That driver/infiniband/ulp/smdirect location in particular is just a
disgusting path.

It sure as hell is *not* a driver, it just uses the rdma infrastructure.

If rdma were to eventually itself split itself up into the driver code
and non-driver code (like networking does), that might change things,
but that's not happening now.

And as long as we expect smbdirect code to go through the smb
maintainer, I'd rather have the location be about that clear situation
rather than some arbitrary "it uses the rdma code" or "it's
networking".

Because that code is not primarily about networking or about rdma.
That code is primarily about smb.

So while I have no *strong* opinions and can deal with whatever
maintainers find convenient, I think fs/smb/smbdirect is at least
currently the sane location.

          Linus
