Received: from matoro.tk (matoro.tk [104.188.251.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6EA1754B
	for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.188.251.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726353051; cv=none; b=G1mW+MosaXbMiiitKQd6Qkd5H1ctEoJ0Z6l5nMAK58jbmpU3KOIx7x+FmmGQh9WsEoY5ZOn+MK92hMvAWr3VtBpxx6Zu+wNYuskjTx3nlTVWAMdxost/4DgcRCFo4FRKZB4NnhAVnnGuQShCDCcsNnF3EkyXRXxO4YG/rz4zQR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726353051; c=relaxed/simple;
	bh=JH2DH+d4lVqlrFnMBgF6HnYi6w0UaxjbMOaBR8KrmFQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=g+fzaHIDcjvVpHgNhdLZ1CKYfwLX3Dkt0a1/Z1Vy5flzbaP5M3OE9jBEnU+MBQBGN+Tt8VeX48gpaRzoP5LfbB4voi8gk8HdE2pYUm9Mq+4DfJjyKD+MYTNhubk8vN3vbpss/8WFSsILyIWGc36koyc+48eSM/NBPNvsHCAsxtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk; spf=pass smtp.mailfrom=matoro.tk; dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b=KDWt+e3w; arc=none smtp.client-ip=104.188.251.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matoro.tk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b="KDWt+e3w"
DKIM-Signature: a=rsa-sha256; bh=V1OlKuB3O3pTTQ7qA55blm1tjsdN3HNQYpeN0ArbgFA=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20240828; t=1726352126; v=1; x=1726784126;
 b=KDWt+e3wN4MD7zi4MDDNLO+j4+Cx86x2nolB0qibsDAUjd0PqCKVRmIL4P08kq5lFTJDJqnQ
 ksJOZSkepNynEHKubxPFTekpz5y8C94KqSgWQSZ7WfKyEotbRGv4prYNDfNaBmSIQesEwU8HSQz
 VG7mVWuCBqgjUg0oD+DeV+mY9Xc4OHWKF3MUVvKbBAGrw2aCAA5vyqS5y0B1QHDlY3P6YxLYleQ
 QkE3xyiyGWz89bOiWF9MjBNCTZA84e+/+hn4k35OmY7rEvl6Dr1FcNJAm6R8X3Gz2egBI522O9L
 RHlvvoVhwGi2U7i3UorKZxFsezc0GmOh85sWOpLx/nUXy28AFhAl97rQK8jIz32IPk2Db/Fvo0I
 KqVG52XkAiqRE2OzATevtqZyZQjP86T4OeKGde0zmUy6IbL1WlHDv8dFqjGlP/FKGc/J5YBtCe0
 A70tL/OyG8c6vrBG60TIeOmdfqdJ7wPK5mFUYHLxV2jWQ+eIZ+A3U0dVrGQ3WvAFkHyPg5Ezvgq
 Xndncx3M6lZfE0QLWgtAGPIw42e66gwv1XLqjN7fNFFLREgFnpMs3XVhGp//x2NFOVWmaK9pHeV
 DRubpVnoqBz9NfIRkQJGzNsFSc0xg/tUtGwS1glWl5MWuJYe3vVhVu+lDVyg+ikfOO1wOAWKSRp
 g7YY+Mpj/Q4=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 274e23fa; Sat, 14 Sep
 2024 18:15:26 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 14 Sep 2024 18:15:26 -0400
From: matoro <matoro_mailinglist_kernel@matoro.tk>
To: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
 Bruno Haible <bruno@clisp.org>, Linux Cifs <linux-cifs@vger.kernel.org>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
In-Reply-To: <97a71be9-d274-4e9e-9928-dce062ba2a22@moonlit-rail.com>
References: <CAH2r5mtDbD2uNdodE5WsOmzSoswn67eHAqGVjZJPHbX1ipkhSw@mail.gmail.com>
 <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
 <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
 <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
 <2925a37f946d1b96a7251f7be72ba341@matoro.tk>
 <2322699.1725442054@warthog.procyon.org.uk>
 <c8027078-bd61-449e-8199-908af20b1f10@moonlit-rail.com>
 <97a71be9-d274-4e9e-9928-dce062ba2a22@moonlit-rail.com>
Message-ID: <693dc625d6be7f0154bcb5e4ee6a3561@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2024-09-05 11:40, Kris Karas (Bug Reporting) wrote:
> Kris Karas wrote:
>> David Howells wrote:
>>> The attached may help.
>> 
>> Thanks.  Gave it a whirl.  Alas, FTBFS against 6.10.8:
> 
> OK, I tried this against git master, compiles fine there.
> Success!  The lockup with vers=1.0/unix is gone for me.
> 
> Just need a backport for 6.10.x to fix the missing NETFS_SREQ_HIT_EOF and 
> rdata->actual_len.
> 
> Thanks!
> Kris

Hey, I haven't tested this myself but if it fixes the issue for others, is 
there any way this can go into tip so that it lands in 6.11?
