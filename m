Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5707521A447
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253551; cv=pass; b=jpSyKei1MoB2PzuF9X0CWfKbFMAsL+G0azU1PTWRd2imT7m0r8SEhNKpopbkeLV1ghPkcI/uYYwk0HpWV4tB6OvKKVMb7nApykUC5WanWOIXYo1Xxvn6gOmVIXDIclmjS08ZVyLBGuv2ctI9Iz3W04R3lFRUu8rZRj61m9bLjhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253551; c=relaxed/simple;
	bh=y+G0oWOXlpQW64UlBYANwp3syD6CPAqjbzxnvB9nUxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c073DmRVyH4yK3gkQLWpyojQmqxgPgYegUAr5REscxpFIdDHCUTPYhduPlwOA9ALTHj/6GTGT1TpHlb0/dMzWJJEiooiaIRmJMfJ1W8+msJtAePSIEZHheDtMhvp8DENk0+5X+IXNnDIe3Ouxse40dX5caT4xIjZ7LO65wsPHxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmsTlKp7; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmsTlKp7"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65019c1dc32so1061556d50.1
        for <linux-cifs@vger.kernel.org>; Sun, 26 Apr 2026 18:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777253549; cv=none;
        d=google.com; s=arc-20240605;
        b=b3Q//r2OHrjs9up1LDSbIjDIwrtY8Q7QfTc64VpoBktqF4PLhk0qap94U99q6WtdoV
         rmStje6VgFpJt2termkMmR1323o2utHN1dy8rpjo+2mgvQFOKfztlPIf5OEAiFdaYPMe
         c+LmSR4UBGW0CHOutcFAsF7kQa4FnLmfFFJou86SdGeIfPbol9UrDnxXwovkdsHjKezC
         LD2luQ4LrRUBBa3Vjsb2x1Gj2KXgclQqWEJIquOiIL41blo1ynB+X5hFMyo9wVULumbp
         gwwg+FqvYaxy9QpqQ7FLTXAyOC9jPNyXCfg35fNX5CytLK/dPnzxmvFxn+/7BRDm+FiE
         TqNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D3XjL8cqpB+iAJRsk6beyhlYPIlA8zCv1g5vwWdh/Ok=;
        fh=n5BFUCcXln+H6bRy6E3sKhApu+P2MAlJFokHZ/Hp4fI=;
        b=KDOeux1hAqf+I0igxod+Pgdx1glOtd0KHlJWbAbb3pBBBUhBh5R42KepvUgB4ZDXbM
         W+jiRYQclZlk8lIqyaRrv7EfUiCvF1pE1d6+OYqGsnZCorhMAK7d78bZhG6bSuPF8xEZ
         w0EDsVEQPPJaO2j25d35uCw9I9AClWq3ZIz8cJgx2QqckyJfUz75e31D5t4CCHgsBGis
         U6d0cxHoXtRpW6O0jORMbc5Mv6bsCjXO1wQ5VebUJd8lB7tqes+5bTnV+QdUXgT8i4Lt
         9FJdkdwncJ0cvco5PqrvPGIl0sYNkioD2fvqpiXjgBPaqEXHqVjE6+euDqIjjxTW9zrZ
         jSJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777253549; x=1777858349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3XjL8cqpB+iAJRsk6beyhlYPIlA8zCv1g5vwWdh/Ok=;
        b=HmsTlKp7DRwIsf0ato9z+ApYvEKJZmCNbmGBRaJ3Zyy0DkR63U66h3HAm9g+HZM0JU
         OElVjf0G5f6QrCmv+ZSWaiGreFP2F6N3vs6kM2OWVblGCUCxMQhLCWADBreR/7tCfbVa
         gQekqmJgZfV/JcuFeO8bTQsrvfUW67kcBFEYELcBFOzySaQtwhA1/1FIhx8VtTL8JEuM
         5vyWL2kZg51qXj7FXtazZ+fnjTHXu1/DqIuth2rBmUwV5FqsDcXdKGkOs2XVpJefDa6I
         vabs53XzaCU9jmRv8J/HrcQb1gfqPjd9LXIFdgLsahfj97VDBM0g71uh1r+t9zW1Ft3U
         Dthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777253549; x=1777858349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D3XjL8cqpB+iAJRsk6beyhlYPIlA8zCv1g5vwWdh/Ok=;
        b=d9yr5POqDL31ItpuxFkDbcw0wjpINrWcNAdx3Zu8XfPYh6Jy2K7bQ2iZtfCQTLAAcx
         0Bq920zJP+MVyrUq8Yy2cDYTo8c4WcFAEMIaM7wB95ap56OjVdQqL8XBNRFIQasCwuSn
         IuwiP1Ka2E9YdqgG1sEKt+7WziTv217Ad0jH0xbY/W/r+2Pq6nV92wiSYoXFUEYJGb3a
         pcnMYtwEYn3YyVrUyPVhm2zpcvY3yS8OvbZuPvUrz02M8GUrob3YicnrjGSwa0WpV29o
         RHXOm6oB63c76gYTUfqAqGKGSsRqASPIab2989kfsXOLjZ0cBAPaPT57IZNjrOZGhR4i
         pDZA==
X-Forwarded-Encrypted: i=1; AFNElJ/NQrEZ+B9bcTrKXnkvyl4pEcbXiHNtRSfUcwTb5dkxFflVUU1hdfSeeTNAb9lVkxzoKhWdQhe6rGup@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5QpUsrEJKdH/AZ6RjQekVDCsRpQpmvslKOzNNG/5BiMWUXPKB
	gH5OvC2MzZ9Re+uiGG+BcW+LjfmcxnLpxIbjLF1LpLP6b2n1xSOnR1jp1jEei0Erki3223Q2b/V
	TC5yCW/4Av60hrt1Xo99oYHxeOVGt+Fw=
X-Gm-Gg: AeBDietr2rZF+HJIJyFWV9TJU6j9La8/Oe8poA3ScdrOvCi4fYVZ/gioosBcKaU4L9U
	lrTdw08dOICdhR798smxCQai6IDLXOyCJr0i00TVYilnEKxW/0h+ahO4tOaLfNZ1Xoniu2YNcFJ
	QepFWPpZWy0yTzsN0XwuWvDICNkQAp/rjfRgSFaDCayFGS8pfqLsV0BJsj1WO53gnLV02WUxuN7
	1igpEVOfGarsNLR52SnfdmyYMvd84iyQxzm6LbGdrro8wLpPiK7kxq1hQp2x5EqwTGsd97ETztj
	3V/xNM95zuTnXFYCXOmzNFXLNLunueTUOwRY4Q/WLFBJr1JLN8w=
X-Received: by 2002:a53:a844:0:b0:651:e0cd:587a with SMTP id
 956f58d0204a3-65310b49bf4mr18006946d50.7.1777253549333; Sun, 26 Apr 2026
 18:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260425093829.4004785-1-charsyam@gmail.com> <20260425093829.4004785-3-charsyam@gmail.com>
 <CAKYAXd_1q_6jXT+A17s5Q6JgUFJvYAt4=GJ3vYG7ruz5x3PexA@mail.gmail.com>
In-Reply-To: <CAKYAXd_1q_6jXT+A17s5Q6JgUFJvYAt4=GJ3vYG7ruz5x3PexA@mail.gmail.com>
From: CharSyam <charsyam@gmail.com>
Date: Mon, 27 Apr 2026 10:32:18 +0900
X-Gm-Features: AQROBzDHhx-e8S0vlMohUSgaGGrKXX3RzxDI0zOAUgI7i495nH5ec52YhQr4nAM
Message-ID: <CAMrLSE63_CAqUn5JXuSP6RfLMh1r4KArxLet4H56mRudWo4ycQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: centralize ksmbd_conn final release to plug
 transport leak
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

   The intent was to snapshot the key returned by idr_get_next() so
that the idr_remove() target was a separate name from the
  iteration cursor =E2=80=94 the body grew with the two branches and the
unlock/relock around session_fd_check(), and I wanted "the
  key we just resolved" to read independently of "the cursor we bump
at the end of the loop".

  That said, on re-reading the final shape, id is not modified between
idr_get_next() and either idr_remove() call site, so
  saved_id is functionally just an alias. I'll drop it in v3 and pass
id directly.


2026=EB=85=84 4=EC=9B=94 27=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 10:07, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> > -
> > -               if (skip(tcon, fp, sess->user) ||
> > -                   !atomic_dec_and_test(&fp->refcount)) {
> > +               saved_id =3D id;
> What is the reason for backing up the id to saved_id?
>
> > +               if (!atomic_inc_not_zero(&fp->refcount)) {
> >                         id++;
> >                         write_unlock(&ft->lock);
> >                         continue;
> >                 }
