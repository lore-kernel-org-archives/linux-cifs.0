Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3809B408258
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359526; cv=none; b=pviyL2SXdHTD3nYPLkB7Nj4v0OASpR7PWsf8xbHWnhylXyA+tcRPNjPQeY6PhDhdzI17a8rRFbusjXEAxat9QmRxph1VW4Xz5dSL6Ujz/BL2ubcVW2y7RHGAoEDNYCzw7x3sYxB7zbed+SFEebGMW7oEa9c8z275pSodzBBl7Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359526; c=relaxed/simple;
	bh=wOUC16WI4/reo5GvoZO5ESmt8rfD7PE3++Xf9novjKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V7ihGKc3HPorv7pEagNqGWixG5k3kMfeFwQ5F6JMzWX4HXxDi9LEMuIaH2EsT6W32kvKm29j1KQL97zc/rIsF8352EO4LA/IWfEdRelDkb4nhu131WL3dBwtf4gB0Mj8alJhn+XsZcNq5mUutlVKAMOSCri0/oE62/mQPD0BUsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URt82eR5; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URt82eR5"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b96e579c0fcso272280166b.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359523; x=1773964323; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=URt82eR5065VogWweW8w2UD3ELKmxw9p6Drg2T+X8i+EggC+dEeoOyssl8gdzPrtN7
         q+y6I7RbjDxz5bHWER1UFFF6UJ67qWNKdTxmGJQYmX6z/cL3iGUbnAvZq5VMxViTFUyk
         WC+r1z9NDj7+x0GyW2+FjZqZ5rojb9fdzPbow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359523; x=1773964323;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=YYzmq00C9/4cZYgsuy52jZWs64+3sPSYjwvQloKBM8AX574xRx2QcMmiahvcBcHEzt
         6AWkS6NJvrAqp3glsQssEl8Rh4daOlZjWYBNvJVqAyLrML5OVWBudnMeR4TutUTmxlvb
         tox/r9Wg84/c2AvuTDbLUydFPKWwgxv/R4qSvaYyQi0fm/DrXr01HojaSwv3hYjhg71y
         1EyrtifP0uYwgXNRL3uzUbZ47yiL8gQcXrsLKX9o+6wt1KETliqdb2kWFUr1AYu/158Z
         o0g8kPDtLuJ3U2W570QXjCKAhEnIWQ6r9zizpHwPT1jEkYy+feaPkju4dV7wZhobtYH9
         54/A==
X-Forwarded-Encrypted: i=1; AJvYcCXZ7EEmau/sg3hy6GPMdCnrZjX8k0R9jQmSsKnp8Ir1f+LWq9LsiLjLrBGybX34xLGvW6sX6z3e5BwE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5GgTMaqrx3QqYOalRP8OyT534Wz/xCxCdyY+oPmnFMlnRPBf/
	h616We0/bVOgo7cz+eEC1Mg6iQzg0obEx4tiHqTwJ0p6uBgEHWQWmreM/YwAF47k1UIWwwzudXP
	riacl7D0=
X-Gm-Gg: ATEYQzxPPq8tU795uK0GNGSzg81VSujxK2bGnRH6BNwxflQaL/eMTOJPWNVGX2cg+Rm
	FpDzJQcfYoA2keAopGndvqKztAY4m9JniyyRvRicmX5z8I5Jx1fg9PxqnNGDLb7K11dzDJLCGvo
	WfAlZmdcHcfaFSF/PXdsGCyn/i+cKrpP1J9NvKGextTsNDbyIeM+CU49BclOedcSt2moSNIrKAz
	Gw7SuHeoOQ3qXnf59UgS5X49/QLp79pRlAf099sin6I2D2XH8vsGlcKWdiKVXaZS/vmDCsd4Qt5
	i2C7V11K162abS/6UurJMkqIh2N1h0gajDJYNRr7EFsTMqHCuOArlg/sGhYxQYApCOGnTA2t5q9
	D3fHSD/jZ7QonBG5AOZkoFbSr/Q251sQJGFx6YZX14Tq1l/5rfqIXNpRaBCceWajkrJy4aAPzqW
	yuustZsdHKW5HYcN0abMaGc9Q3yTBMmxvc6osG9aPXOBCljwObSaW+R9gT6fF8qvt3B4tDqMxM
X-Received: by 2002:a17:907:3f03:b0:b8d:bf4d:7464 with SMTP id a640c23a62f3a-b97653919cbmr62215066b.39.1773359523444;
        Thu, 12 Mar 2026 16:52:03 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cdb1ec6sm3210566b.33.2026.03.12.16.52.03
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:52:03 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b96f02b4329so272401166b.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 16:52:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX1S41mvmRQYwH25ccVBP0L7RYG0N/RpRlQXMnzAz1CVhvEFsrrMY2cMebn3aYJKjto3dcx0TmAISYA@vger.kernel.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus
