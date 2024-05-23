Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CAC13B590
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 06:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716445753; cv=none; b=ZrrGvJCqaWg1DD9DFtN+qxi07un4/4V10Kz0/jbxd0XETu+Z2nYVH3SUdE5v4FzrAnn+tgB0wYVpXHgLnlW8Se/KBn43pOz+qa1Q2ACiZfUXncKNHslmUmH+VcWfJwdrwl8ntCn86Xm6bRpsJziDn/lkxjD97+7QtvcMfvhHUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716445753; c=relaxed/simple;
	bh=jZs5oy+5Im7iq9WK4X8+s59CTst+wZ3GkH279z0UpCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nNV1nXCJHCAZMqAgoA98D1jGH9Wj1yFM9TC0UIMOgvYW8YN9DP2A3wOedpp2STzRiDgBRqizf8C927CV9ciVzY5vz07Q35ONkM7l4YwcuHxi0aASQk6oXgIDSvIzAcCQlZ7To4Zp4KEg2gZ5XuMlHvOCBmnI+9Dybc0CMb5D6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKD8JDFF; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKD8JDFF"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ce2aada130so2793725a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 23:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716445751; x=1717050551; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vFzjZ5ldW2IMNMdsxBvmnC/oGknZ3A7UQZXsetPM+EU=;
        b=OKD8JDFFfEE/bNofYDdzRnmxg9xrbZpq6jEGHu10ve82Equa879LRezsw7uCfFiG8h
         4AUmYmZkd3EF011Z8Bi2NN01A0m/axYkwNuKKKrHQk1jtTF3Fgf4IJ6EuvpmEtE3Ghlz
         dwb0iYJYVaKYEN90vbfCMQ/D6Wv/ZIwImQpZYm9XPBozxGl4W8GiLr6pUXAEtY4vxpo8
         I9xFG2g7dortmJY9jM+Og0Di/Km6CuWdiDQDSy8zADUf0QaZI/mljdoaqGsEoM1By6i4
         dj7H8DtJ5jSGkcG6VgQGsju7gRC69Vnv952PcQzN8XscYmEN9VUCOwSXc/Tr3OJZOMUW
         umCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716445751; x=1717050551;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vFzjZ5ldW2IMNMdsxBvmnC/oGknZ3A7UQZXsetPM+EU=;
        b=snQpIiEeb/pEtOmVIc27hpR/v9sqk3ILzWk23tXWXav4SNO1RwGegmwJihBvn3rTqE
         RlFvcXdyd5z2AJDrYhZ4Vm+OO0BvVqJTIo2WEmh+QXUBYgmdw6rP8gAb2bYnR0PeB3Je
         TCmpLETzROFK34jQN8tpMBoqORs0B15fgwt47oE47a9y5teVfVQ0IocGcumXu4K/N844
         wJ7anfQkfgZFstDIhEdWcsaOB4E2PzYY3bnaPWVEBPDSNKX8akkUs7aaBrPv+7PSI8Ic
         0WhqkqI/LJSqiz1e5XAYKrPkqGlv0IRiHfJ77Tnw9/t3VZkaRIBqROHBpd52ahRM0TFi
         e7qA==
X-Forwarded-Encrypted: i=1; AJvYcCXuM03WFjpiuydCNsZ84m0u1DKe1umEhkhcDULMihFewXulWV1xk1ccr4gYSQGYWi17uUKwO4TEkcLjYHjTZzAzQp5u2I7Ds9TvAA==
X-Gm-Message-State: AOJu0Yzd5Ailqob+DXKkhqGWbRmUHX49+zqn4r3CVSP6rDCHEJeqoTem
	sE15E2PM/0/wLpoPG7nJd7/g4KgUDX7FCHvjAbzTFzfXCGFAa6SQ52sR62Vlqcqx99uv1R6C+4y
	od2T5xyD7VV3lqTFHUR0qvjOrngg=
X-Google-Smtp-Source: AGHT+IEG1ejEK6Tf2x1fRgF3lG4AHSfZ5oPqECPkwNzx0zih63Oi6OONR9RYMiHk7P2qdpVWN0xMxf3Iz1ceWB2dIh8=
X-Received: by 2002:a17:90a:604f:b0:2bd:e076:8798 with SMTP id
 98e67ed59e1d1-2bde07687a6mr1009291a91.24.1716445751058; Wed, 22 May 2024
 23:29:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna>
 <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <476489.1716445261@warthog.procyon.org.uk>
In-Reply-To: <476489.1716445261@warthog.procyon.org.uk>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 23 May 2024 16:28:59 +1000
Message-ID: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
To: David Howells <dhowells@redhat.com>
Cc: David Disseldorp <ddiss@samba.org>, 
	David Howells via samba-technical <samba-technical@lists.samba.org>, Steve French <sfrench@samba.org>, 
	Jeremy Allison <jra@samba.org>, linux-cifs@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 May 2024 at 16:21, David Howells <dhowells@redhat.com> wrote:
>
> ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> > On Thu, 23 May 2024 at 14:54, David Disseldorp <ddiss@samba.org> wrote:
> > It might be best to just ignore tests that fail in this area. And just
> > accept that some things, at best, is a best-effort approximation.
> > (as long as dataloss does not happen, of course. That is never acceptable)
> > At the end of the day it is a lot of guesswork and trying to fit a
> > square peg (unpredictable ntfs behavior) into a round hole (linux vfs
> > api).
>
> The problem is that it essentially renders SEEK_DATA/SEEK_HOLE unusable for
> applications on cifs.  If there's more than one extent above the starting
> position, they'll fail with EIO.  The only way to do it is to provide for a
> sufficiently large buffer to accommodate however many extents that there are
> (and there could be millions, in theory) in order to get just the first one.

Wait, I didn't read all the text in the initial posts correctly.
Do you mean if you ask for "max x bytes of response, enough for n
entries" then if there
are > n entries on the server you get nothing back?

I am pretty sure Windows will return as many entries as fits in the
reponse out-data-size
nad some error code.
But you are saying that instead of returning a truncated out-blob that
samba will return nothing?
I will test this tomorrow on a win16 server.



>
> David
>
