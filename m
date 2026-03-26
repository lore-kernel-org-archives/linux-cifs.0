Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E915F289E06
	for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774561746; cv=pass; b=JTU3Z2EVodhe5wO58awbYST/EVIZg3EXggC/rI9nhqlM2RJBK20Kzq1/laMhKENe9GjZ3kJsKBYR/NbBVnmj+egdjETl/hvID4n/UnQP/RDmvhdu8vjI2SdRbLqNiENF0CT7P+tyXMG/o4nK+HAj9jWj7LRNGx87Izb4+wNNMMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774561746; c=relaxed/simple;
	bh=DWb6NDjjhzhDkeF+RBAi3Ju2eFdvktKCdBS03nVrDeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKfecxS/ZQu15LA8oCbdYDeCMomooloLp7KZHpeXnfuP9jziXd4jFyOkt7MTH9lBAXrZcUBExlNRUH8UNwY99JKEhIJnoK1mfo3fdWyGA6C4fQY9128rMU5Lb81uIVuW0MhTcwmbh0MUGBeSvElMwbiwfb0u7XcHZ7FjDkFnwa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ok98R3fM; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ok98R3fM"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-824c9da9928so1346264b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 14:49:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774561743; cv=none;
        d=google.com; s=arc-20240605;
        b=ezEoYNWhqrsvCM1e7DIekg8CejX/yynIOf4I7a47jdmxhQPnd/KtjQUIHJ2hDdCaL2
         XEVRTnGnLvvAbwXq9ZZ4XmZ9365NSKhvWfhHtD43brNcCbL6cVmXtZM3meO4Ilsa0oHg
         8iemySHZY0avB8JRGj6co7c/zwxyG4VhS8d5zEgghQUiBbRXXc5Q8MbBleFUJe2KWuQv
         gay89VAUWXDY4Yl0Jek2fuW7CDr2XckI6nhaMTOsZ1hlwcez54n+AJScTcNs1f9cpi91
         EkF7j+gtzxeloBDWbspaWv7fGxDh6Ew6Hj7HUCbmWgS1VbQBtrFfJNsxSgA8e06onMw3
         RaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LcNk0BhBpunqYjg8xevwO9GWhKeqxSm/v/1iUobDQcs=;
        fh=jCb/qkorszL/uHQBE4mQvPVsAyeSyUZ2mek5tulg1fA=;
        b=QZci3kDP6b9fPx1VoAoQjJomjq+HBInz27NcntvshF+kFscWYF34TmXycSErsyfrLX
         klWpKy1YBNNZnDkp9AyUA8kJ00eZeR+HxHXBqZsAt27PI/1l85kXi4U7swrlU/i8hief
         2AG9Q891xEokhPRuJ/2P4Wlbprvfq8GxHeusbTe5UjqX+sxiZ8jM8qrV808rpBgrOp6h
         Gg0bw0cmm6tlb/jX6ReB9UejMpbJppkH8UL3Aeph5shFLY9+RGnrYRKYgUT60XMdYYVE
         SgAR6uSuSRNPiqXiNcmUBK8am6/BVUf2x36gMP+17Hzr/iDB72FyuRVuTjXn6SREh4Jc
         dYRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774561743; x=1775166543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcNk0BhBpunqYjg8xevwO9GWhKeqxSm/v/1iUobDQcs=;
        b=ok98R3fMT/28v62XhhGk3lcT2qVPm6pNyj18euczkiLhqEsgvTbV6bJoz+Gf/zdewU
         lKpvnjq6qC0+gcTNYzZZ7E8qevJO5HnhbqvPLEj6X1Gqu/lc8Df+pQcHvVzPyvEIulTa
         QZKuxTeyBt4GaC+UJNSQF2UGqpiKjsJWzBrPnVwrhvSwUwkx5Ajy5PDSYJk8HQ7/93Ov
         Dt2kQxam5dp8CVhSp4HcQ8N5qW6eUGmKQVruZvX6wDm6NyDE0nFgpQnLRtI8jSM3+6UC
         mOuj6F96BgrQY1y/cHxf8Hk5J2AFlKuLW2ZqQUkZCNDs9wiNaBWopr+URniQW2o6T8qz
         lEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774561743; x=1775166543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LcNk0BhBpunqYjg8xevwO9GWhKeqxSm/v/1iUobDQcs=;
        b=qaQE9NFDY8d2YqRAjGMnIBqDmZZlypvokf2NgFZQKZBTM/vMNAP5WUb5wRz6sJthrI
         jRrqiaGn4V1y5Xm8ZvLGJjhIbb3+qSgut9QDqZULy11m9ayq5xw43AVmyPEcKiEIiYQO
         A6v8MxKYdqlmE0cPSy6hMKm5C5zs8hYpZDsrb2Nb3dAkrebtdiDnv70cTxjtLqocZDmG
         Jv3urRKifpK7o2gT193HvSIaiEE4AeFdiFVuj/CaHHu8DUHe0MWUDhegHdQPn+xPPXW+
         mjzC8vS7Yxr8VY1COY12ljhSL6iNR0E6svYy21CyvfUs7764JKMdiHjM5bKTcVALsqXl
         wnqA==
X-Forwarded-Encrypted: i=1; AJvYcCWz7bAN7J5gBYPxatw60n8DqiMH0pm+ZjEr9KMIm+x+Wo2c1vx+dmHe5NF+h7ggnc9Cn830ujyy5A1/@vger.kernel.org
X-Gm-Message-State: AOJu0YyhLc0I0+MTYcWOtJDh453E8QhlIliklnZsnm/1jq/mC7hucOB3
	Nj1fca/CHpCKieRISOFr3Bw4E2pnSOW1gS4ZIDzWpLw8rN+fPfGI2qnSZUboMk10sy1uR9Rjgqt
	pZDbmtNlsRxghf2w/e9SgNvWmiJe2xTY=
X-Gm-Gg: ATEYQzzAjuY1VkFMGmzaaHFg3ELVHTAZeF6faINFBL3T1hozAxzmfsxu3vWA/eliK5k
	9lJFPRIpbgLxkTG0H4W70KD6STsn1yZhPnOehHdvIT+a9EPKEVDOuQwYtL4ClmDBf7WCmO8Ua05
	s6gfZY/2a27s8V0wj3aXinmW2nNq/TBKGWAlNEsgKxxD//ZnPnEvlvSrItSjV1x0jMBtVux5s1b
	fHp/up4yHe9vEo8yLw1cD2sgYhw4YYW/iiMxhqpW4pltk93lNizFXrCL4IyQ/ChrePOdhEuPeTR
	eZpQpT5KbD5/uH4LnnT9Fju0+aRWxKWrBgvfVbRBeBes0W8hs1XwwDCbx1+0FIV/BLiPh70Q0XG
	6oHnuNHzaClFDCuX0woi9SyBEDX+DAG2blnUHmaM=
X-Received: by 2002:a05:6a00:148d:b0:81f:394a:4897 with SMTP id
 d2e1a72fcca58-82c96085fcdmr56960b3a.44.1774561743007; Thu, 26 Mar 2026
 14:49:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1774410440.git.lucien.xin@gmail.com> <91c6fd0a44eb15a98f945171ead8062badb89a60.1774410440.git.lucien.xin@gmail.com>
 <CADvbK_eXUfnGGQgGc_k-ecCW3-Co1MpGb7UvMgLonPy3HRhyFA@mail.gmail.com> <20260326130740.74b4c92f@kernel.org>
In-Reply-To: <20260326130740.74b4c92f@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Mar 2026 17:48:51 -0400
X-Gm-Features: AQROBzAemDJ3qW1z4xWRURYJNQELd9N64vs5NQq1QodH8yfoSs3wYDdFxRVPhko
Message-ID: <CADvbK_eyNtAfA=JPR5Y4arFLPpkWMs8io=TO83rHAa-JJkhdAA@mail.gmail.com>
Subject: Re: [PATCH net-next v11 06/15] quic: add stream management
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 26, 2026 at 4:07=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 26 Mar 2026 11:06:26 -0400 Xin Long wrote:
> > The AI report on
> >
> >   https://netdev-ai.bots.linux.dev/ai-review.html?id=3D1624d906-c0b6-4e=
12-a63f-5cbfc51b660e#patch-5
> >
> > is false positive.
> >
> > As the sk_alloc() calls sk_prot_alloc() with __GFP_ZERO, and the stream=
s->head
> > is always initialized to NULL.
>
> Can you also check the google one?
>
> https://sashiko.dev/#/patchset/4019cfba3ffd6f91aee24713d2adc778f858b4c4.1=
774410440.git.lucien.xin@gmail.com

Will do. There are quite a few reports, and it may take me some time
to review them all carefully.

BTW, what's the workflow for the Google AI feedback? should I reply to
each item in this thread like we did with Claude one, or is there a
different workflow?

Thanks.
