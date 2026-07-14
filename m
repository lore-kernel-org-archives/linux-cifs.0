Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1128842BC4F
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066588; cv=pass; b=P2Pc/Lo4S1OeAr4O+cvYVZZ+JpxKbcdQckXYcmZMmZPle8S9DXLapXdpmj/pQgf/QhFKSUVSXiL1xy+QeC3k96cSFreySvkSjIW6GMAYMakPLrvzKWlf5Iv7SgdTYsq/nsd7SFdAtQHJ3G30GhLihyJjEXhAScz9FTxZFhNqxYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066588; c=relaxed/simple;
	bh=FBfQm+857PVHr6+vUh32kpe3ZESqMRysNWozJedGSC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJGiU55T1X8TLjz1LVrUPjSsB9avM2DGp5FKIt3rIt258gI7b1Bqxi0DVRg0X/T3U07YW2x3+AGt/yEXoqUcZ3HbPvYvECuyUJHwGJ59q3GwPJYxBjOA0jLiRJh4+0etEG+8vyXF8wAdCTkgOSc7r2/rDj6cJLKvOOQ+jpJlnZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPYcR3KA; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPYcR3KA"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e50c5d14cso301188085a.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 15:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784066586; cv=none;
        d=google.com; s=arc-20260327;
        b=k28I+u8AcIObuGEI8AgH1xG2YomUBjMUjqWkBKyruvH3AZy7rNnumhC4O6dQHytnPi
         WcbSbwRMWfV5S9FW0Gon6MThgme++8bYzvsTT4IXdsOOip14HVUTZFBdOiunFHMWdqbl
         tQKPl8iy9qCgK2eeDccjlUYP+6TTFELxT/YtnxscuVtByp9Px3y/kmNcIlRAa/mkAJ8T
         rmeTsveKRVpdAufSsfFWR5xS0SATXk3Zm3cQgNNmN15XgasW6SwiO4en16pvaDpVk7Ow
         sz+7bAtb86DRmdvYeGJto02UFJ35zCatlAWMV1Lt9yyL4X3F9Z7mvqP1XBx/xofcQqtz
         Sw2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KpF4M1nJD592BZEZvzoPJfc+FEmzI9W6Gei4YOVqK3c=;
        fh=Lvzcy18SOqNHJuBru9wYMEH1sDjc+xyrV/z2HgqwY5w=;
        b=XQ1zL2EwccIRuouTi6Yw5VGuHmZQM2dXNMntrNLUshIlONQ00sYpGwhDyL0gFWfuMb
         P+snNz+bfDVi0JivSBrneyuRhBIxLePJ/Sabl5xHs5mCVtk9uIn10jTSR5+uBpUzgc7p
         j2OTQdQBYA1nxwGRAZ3Pqtbk9GvuRME5B+0zDA21xq9XUh/ut9c7ZLBHu3GLnTDVVUfN
         KGNXRY3qXGE2d6tZKSu4xGvA+T14KXVbIzYg7YLbZxntdoxnEm3pkWECc05pu3uzX21y
         ohXb2o1VKNU92BhNYO1rr9o35cdV8kxE7HZwQIvJ9L0lbbM1NcxMA0ND7yUq6DOhLPgZ
         r7+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784066586; x=1784671386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KpF4M1nJD592BZEZvzoPJfc+FEmzI9W6Gei4YOVqK3c=;
        b=DPYcR3KA4JWVCySgzfkVzPfq5j/VzaDDTZ1gh4te8ENXW7Aua/kbxSqNkls4caGi7f
         d6+3MCzY4lvZ9/EWKABcS5aBy8fnFDIrdftSwbF8if4C5hzp0E1nkdN/rX18JC1pXn8f
         OJX9epWxDtFe6PeGJUMuYWdqnnPVEaiWRPmTSaUMduInY9bINVrKD5RRZ575L5BhcS7T
         mvGvbLBeKtENj3Dk0C+wtBOvRHNBE37bxjxPNBXc0yIJMv3r86jm7mhUmfnUG7Of+sBy
         p4T6i31I52R2jnZiGTa8qmV6VfXZ2esMWmRuuYKbAMFr1bxWT/V3hPYSMNZ72E4F4z42
         1uzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784066586; x=1784671386;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpF4M1nJD592BZEZvzoPJfc+FEmzI9W6Gei4YOVqK3c=;
        b=LQj9giyHUcud7DUbuYORyT5Hs1D9tWq4B1Q5L71R8xINkzBdR8U0W+qBlTgA+OaIii
         IHuQyVSuUQrYTZAY2ZCcwHdflh58dncnm6XamI/sZxYYj1m3xd8IAQ9Sb0rDduP99tn3
         7K0bNltcEafLNn9VjmmADBYmU8AFt5p8jXHWZwSSEE2KHXa8X0UpnUowwCLFQHYquDrw
         MIKTVqIem6O+bm0Jqi8cCpLlgPzf0sqXzqhBGznriovfLmnqxkrNHqxZJkrM8Fudcisi
         ntRWWr4oCBTd6oyUzzbOOus3Oe6dpvivB7dnMgS6srNjKPurPgxiKy2zVbdyuc4ZE9IN
         U0yQ==
X-Forwarded-Encrypted: i=1; AHgh+RoUyFFMrGzESYQGB2kkrK4PGxFkbuvLr6DC/OJgsII6K/M0QZ4V9m0ftNsMaJdKkUKBWmw+TdNSIFcV@vger.kernel.org
X-Gm-Message-State: AOJu0YyXkXdZSD22YVW8/HCyHSF/MoVKwgYm3nY1x+ilBN9IYkGpircO
	QrJa/NwZy6oxVFanEX4Y5ARCx1GFrse+eSYgZx8JJm/5UgQMZugR4k+C88p9UATQiKvVopZQmRd
	DfW1SpWe7d9Ny+onqRPo3Tf9Nq5BZNvEpT+HP
X-Gm-Gg: AfdE7cnExwKakNXBVDgWDp3WJj3wFe/dEO1OSjb8eB7P1YNN7qh1EW+5CGih50wWsgx
	+otSMNst+Jp+wpAlaEVoC4p7pIpQlDxkS1ZSgp2jBeA6awKJBfiM3pq5YkMv7tOhIg+1Pzug0b/
	NANvSTLAUPShd5D7M2sRnaB4QZEmg76PBc0RdX31y89OHCR9pvUO2k0LVjPFCRw9YYxL/9H62OK
	T7LTd/rd963EQuMp471ldnHJjjLiVnEt7Z1mzSAB2IWp1QNg1GvE5nRLycAYRS+et6xO5lkoumt
	2QnsEzGwLioUzor/M1ONG5SXHjwMmyXSLPbcKRp9pdQlb+/kjeTKJosymFQESnCFvj+YlHaZmOS
	YPAdn8dNLInmwBANQ4cgvENNehlABn+goqgwTuLVKz9tZQ0Rd04XekhNQt8yvQwJ+z39K9Fsc2V
	TqX4PyfGnLSXDWdkA7ItY=
X-Received: by 2002:a05:620a:4095:b0:92e:7a17:c938 with SMTP id
 af79cd13be357-93083c73530mr547653985a.30.1784066585689; Tue, 14 Jul 2026
 15:03:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714122120.743185-1-andriy.shevchenko@linux.intel.com> <755b2ab6-8aee-49e4-89b0-a05589f0b64b@chenxiaosong.com>
In-Reply-To: <755b2ab6-8aee-49e4-89b0-a05589f0b64b@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Jul 2026 17:02:52 -0500
X-Gm-Features: AUfX_mw330Pvp1emWMl93TdYeFFH9Hu8L6ml9jfQ4tKmn2iJI0Kxc_rnLSvoA9M
Message-ID: <CAH2r5mu1nf-jOVkobrBRv8wQoCYC=+9JkpPsR-zYgwn2MdD8Mg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export symbols
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Steve French <stfrench@microsoft.com>, Youling Tang <tangyouling@kylinos.cn>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	Steve French <sfrench@samba.org>, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Jul 14, 2026 at 7:36=E2=80=AFAM ChenXiaoSong via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Andy, could you also submit a patch to update
> fs/smb/client/smb2maperror.c as well?
>
> =E5=9C=A8 2026/7/14 20:21, Andy Shevchenko =E5=86=99=E9=81=93:
> > Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
> > to mark the symbols as visible only if CONFIG_KUNIT is enabled.
> >
> > Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
> > use these marked symbols. This is the standard way for all KUnit
> > tests.
> >
> > Signed-off-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> > ---
> >   fs/smb/client/smb1maperror.c      | 24 ++++++++++++------------
> >   fs/smb/client/smb1maperror_test.c |  1 +
> >   2 files changed, 13 insertions(+), 12 deletions(-)
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
>


--=20
Thanks,

Steve
