Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478028C85B
	for <linux-cifs@vger.kernel.org>; Wed,  9 Jul 2025 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752056792; cv=none; b=qeRJXhNuohJJN+Y8VlN5Y9pLWU3FH/OGTnnHgmUrUIOTuF46ZH0d3Ssq4lZpiSfcNmzT0/OyIkAZF4OG5vyqP5/SwPNrJgrx14gIRoDwBtv8p7zReTwvkTgy2kyIaAPW0qR7WSZ+ETfVpnrzq3QMznsPPKfm3lIGRoMtW+oFxRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752056792; c=relaxed/simple;
	bh=wbnVGbjHNz2co8d+fXBHn4JejafVFSAL2G4zjFDrvs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egWx+lpa3/lMltN1kQslpTi/BvR6L0sxfMp73tjXDjJ13RTsTpaCvKlJLnhlCX26aicUp2u5JwR1suoHzCmbd4sWlzV62TYPAfvIF+GyApJKcKttsxK85qWZxfpCREEOoz8wTYjYVru4PD8x1T7Te+lNzknYoWQmZ9/0L/HTr5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=D1JWyogI; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="D1JWyogI"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae3a604b43bso847443566b.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jul 2025 03:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1752056788; x=1752661588; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q7WBoHo27tCDa77Ry5M8MzBflIzY6f9OMpHwiXcLHSs=;
        b=D1JWyogIFCQUnqEHsgjBo5v8xFFmdw5nxvVF5+3jX7gn+gUeOqTuFIeiKGdQrPcuOe
         M4yWynuUfuCTAH6wUj4MplmTKljf3gHKXGf5xfcILfPbR3pFLhuFmcHc96MVKzh8NgV7
         aCT5PhNylYrNh35vuWZlau4iA0PQuT8a3ep3zn67Y6EUw3Iw80wrBCmMxtpAKaAvi0wf
         AdaERMFYNNo2PU9A1D8OA2KB+ZWwEwkSETbmCrFxUq1+GUwplKL3RB2p7bjd8t3u7zyM
         u3ahRHR1TCPLt5wdiucAaBLkAf47HkvJYZJVDlhCBoyY4Oyq/P8dK9RL9f3Qpa21B3jD
         g7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752056788; x=1752661588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7WBoHo27tCDa77Ry5M8MzBflIzY6f9OMpHwiXcLHSs=;
        b=KZEjv6TxqixdWo6wfj5LPx4OqSg3X3z1/L1qCR9IBV3FJG44+jc+lVXT7VfpT9Y+g/
         gtUJuLB+0nFY+0G55cLtxqVrf+olu7+vU0A0iPonCieZEXzBlQTicMhOODgVnPMbj2yi
         Q/GAGgf/DIKz9HShGY0tTDJOOgmOeN6Z6bA1Ex+gUVSUNsruPWgxE3Xc/NuHmt9q04EP
         JeCXpvRS6NrsN5MsyVhFcPtrNA11XVJAZD+yhwAILTKJJTXTJZVQAsio+L9cgYsJfswI
         S0hSzmibsuytPxjNDeENQ616AguslgnS/uGvThdSuHTfdh8ze4Q4A3Zmnj1IEThuhVEc
         HQ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU02qoHvPbgYRHaKJT/sWXTqPdhLYQfmuXHqVpLljd1gkPJVXrq8Y2kO0SuLFWuSt2Fv5hsm8zY9yJm@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8MilERw0gEJVqn5USy/RR1hFkutiJciPcJ54WMG9YDExabyfu
	66zmS1qB8MWKRrtEocD8JEgliH9OwbGyx5tYcaz+fOCRr8fW+3eCN82kFLkRKp4ztzQKuuHiVhT
	HII6g1XhbTmmL6NxY/+EuVF6MJIzA7mYrn68K4rRNqQ==
X-Gm-Gg: ASbGncusnFHDCqICmfAasihD2enHztCFmO0+TTbMsuwEDiJspaRBbueWz0vB11HdK70
	6i1riQyg+rqUbR6Nu/s7a56RsAg4WZ/H+pZ/szOr/tXFNkYZy497Nulfep+NdV88eM8sgTU9ejW
	WhkQMzWninhYywv7PH2AOLbIEKaF6va8tXxILqqlLidKUoGrHxXe/exlGeQaCN7v7Yd8TSkZfqq
	hDw2uRFtg==
X-Google-Smtp-Source: AGHT+IGbqwygDCctWSd13zB7txA8nj1LhT4JGyQ85VQ1ULmFhI635wDH8IR1PaEr0MvmBrrgrCIFH+uxlqg39uXxl9g=
X-Received: by 2002:a17:907:1c15:b0:ae0:bdc2:9957 with SMTP id
 a640c23a62f3a-ae6cfbd985amr185279366b.61.1752056788493; Wed, 09 Jul 2025
 03:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701163852.2171681-1-dhowells@redhat.com>
In-Reply-To: <20250701163852.2171681-1-dhowells@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 9 Jul 2025 12:26:17 +0200
X-Gm-Features: Ac12FXwp4fbGLXVwqf6tAOr1y42YQrXGTBI6Q0Kfy3_DmIljAuOKBpuGHKZXSZ0
Message-ID: <CAKPOu+8z_ijTLHdiCYGU_Uk7yYD=shxyGLwfe-L7AV3DhebS3w@mail.gmail.com>
Subject: Re: [PATCH 00/13] netfs, cifs: Fixes to retry-related code
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, netfs@lists.linux.dev, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

David Howells <dhowells@redhat.com> wrote:
> Here are some miscellaneous fixes and changes for netfslib and cifs, if you
> could consider pulling them.  All the bugs fixed were observed in cifs, so
> they should probably go through the cifs tree unless Christian would much
> prefer for them to go through the VFS tree.

Hi David,

your commit 2b1424cd131c ("netfs: Fix wait/wake to be consistent about
the waitqueue used") has given me serious headaches; it has caused
outages in our web hosting clusters (yet again - all Linux versions
since 6.9 had serious netfs regressions). Your patch was backported to
6.15 as commit 329ba1cb402a in 6.15.3 (why oh why??), and therefore
the bugs it has caused will be "available" to all Linux stable users.

The problem we had is that writing to certain files never finishes. It
looks like it has to do with the cachefiles subrequest never reporting
completion. (We use Ceph with cachefiles)

I have tried applying the fixes in this pull request, which sounded
promising, but the problem is still there. The only thing that helps
is reverting 2b1424cd131c completely - everything is fine with 6.15.5
plus the revert.

What do you need from me in order to analyze the bug?

Max
