Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E502927E07E
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390802; cv=none; b=i9Fcr4DiMV87gQ6iTJbOBZ9I4X1KHsBwdlhU1KWoqHPCLkAX1o/SDzh1C0xqwotwqdAnVwV7zMZn+EnyR71jqpaMRlyCtTUAkJgAADfVDJ+ypQYFkKfk5XjBu252kYRfr3qTqHh2ilAhFPqXs3BjOp08H6/4iw6M4EUe4a0FsKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390802; c=relaxed/simple;
	bh=v5WsSDr2tQsBS6gRjKq1ZuVHOejbvcA+jUUZFzBkAh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bBSwMmsac9z/zkuWZKcmmBjnZcsT0tvU+K+g8vlPboHdBxNCbXv1VPD5rGfuVQuRVmgo2dEpRHxbHe9gxgNhyBlIXiOFKuxPCY2auodqNRKhvLZjWeydSJ+gtfC7IZF+qREG0UhcXw6Z7UfeGHO/Q7bnec2rVm3j0E8t4nlvTUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6xWP7GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6xWP7GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAD0C19422
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770390801;
	bh=v5WsSDr2tQsBS6gRjKq1ZuVHOejbvcA+jUUZFzBkAh8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O6xWP7GZ5Yb6CxXDx2Hf0YMaSJQsvOG+XH7jYb5G27toJapP7F+YIt5qWGIlSvO6I
	 Sv+Jt3ABzzPU6BX3Hzj+Uu7sDR5TGuuj1TpVgbBomSAahFlxCqmedpAojwnhixiJBc
	 +bWVptgvzjYMzC0YEBszKp9Clz1neKjHhPbHDXZos/5oRCJpXFTeG3c88YJ4PAshce
	 tkW3eprDMnlIXBMUorGPJ2tu6UbihfF9X93Ya88UARNAkJQNxFMp3pFF6v0CU9rAwZ
	 srBFZyeZOBKNcx1fVMvubhijgJtNj7Bn6orPL/tAgFQLzusKBPUoY0S6ei8QwfgsSE
	 u8mWp7eUtdL2A==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8850aa5b56so386485266b.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Feb 2026 07:13:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXT99ygu1pM3lQbIbThiUcNQhqZmGFZyVrsynUgbWH0PO0IKfPSA3z5DYxrxUwOTRvnIZQ0qhcMmrUR@vger.kernel.org
X-Gm-Message-State: AOJu0YzdvupaI+KXvB70EYV90rNQbqyVRFOaSJ2j7nKmXYpCoyUx8aFV
	gPflahDUn8LHa1UlK96jpKR2HyPxx7uUsvD0HhtXBSdYIg9Jmpe9Ju5J/rRKDKVs44tzLFhmZzL
	2l6WRtJylR2UhDh0nrheKlBzWsu4+uWw=
X-Received: by 2002:a17:906:f58b:b0:b8d:bf4d:7458 with SMTP id
 a640c23a62f3a-b8edf1ea7c4mr170888366b.24.1770390800136; Fri, 06 Feb 2026
 07:13:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org>
In-Reply-To: <cover.1770311507.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 7 Feb 2026 00:13:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JgWAM-zc5CdNeuHOsKaBYKPp9NQBd9=Z8G-RNOLm9VA@mail.gmail.com>
X-Gm-Features: AZwV_QjkO1J194Rkd9CCx2iguM3WblIOsNq5A4KXpPbfuqLTBvErm-_7ID82bno
Message-ID: <CAKYAXd8JgWAM-zc5CdNeuHOsKaBYKPp9NQBd9=Z8G-RNOLm9VA@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"

> Namjae, can you please test in your setup?
There are no issues in my testing, but since there are a lot of
patches in this series, I need a few more days to review them.
Thanks.
