Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88DE38B7D5
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201938; cv=none; b=aZYUVr9ld1sX3iJcipqre7MTeIAmZG4E/IdjVEflL2OGiEU5sI8jsVEfONCrJ9rHNJd/t1MIdEowxNE50aVYTTDWXEbxlCi0MMJsD6q+h0l9lq31MYhAKmtxMMXXgrku62QHFK524DK94OYMrBPAX5lBYniLicbrOlHw07HsrGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201938; c=relaxed/simple;
	bh=A+IAkisreOub8kZfccS+fPhPhhCJ9W3gszsbY06U2Jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/uOkA2W4E6FuToZHpoxBMXjCP3U0jquAF+2nZiZgpfZzMOWmIT+ny+Fgsof0fdS4kxwczti6m4P1CvQPPkvHJdTZb2OgJ0DAYKa56gC4bhWIPI9CoSbItoc/wsd8tnSxkm2nG8/f30iChGDJQamOGGzy4pytaVTkOarE/w5fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ox6S08pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ox6S08pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6A1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201936;
	bh=x5nFbWvZYsL98dmNOQ/GD1LI54Hx0dSFeSNdsceAaAc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ox6S08pcRvNi3rXYWuVLid0o5OGj/524ruRowceTUl9j1dTmWoNd0eN6Dh5l9O6n/
	 hQPEy2PUQnCMQQmuiyJUKmrhYopmoFxWUgPMdWiQifG+V73NAd34lyv+fzWzOU0YAJ
	 D0GJ3TgFMhvDrBb1eQNW3pE2gEG9u2BuLDjjHvZo07dVz5UgyCXWl88WqWmzKnPElj
	 bLqY2tM5+11kSPt5v3XXa+8s+/gkx2NcyKcD6VL4c1s8SokhuYfAPcD2ALQdKb1etL
	 apt5wIPxj58LQeKPI5YeuMzxT+tEiSFY4tBK+Et92ar1fEaOVyFxhrkcCHFkUZ8yYv
	 KvAJd3bBkApdg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c07fcdd75d3so647185366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 01:05:36 -0700 (PDT)
X-Gm-Message-State: AOJu0YzGWDQgubMj2kUySt0StU2EP4NwgUbz+oEfeRjDvxkZ8tLkVgkp
	k+ymthkPKokzrUwrb1F5U1c0jx49OEth/q0L+KGjzL4BmnJageWgip6Lucxleii5E753KqFpUAU
	0a6v4VDI4pTm4jyng5stfRX5MUO6BwfM=
X-Received: by 2002:a17:907:97cc:b0:bfd:6435:92e with SMTP id
 a640c23a62f3a-c108cdf8cacmr62817166b.5.1782201935229; Tue, 23 Jun 2026
 01:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ajozC-8nzNMn_jaK@stanley.mountain>
In-Reply-To: <ajozC-8nzNMn_jaK@stanley.mountain>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 23 Jun 2026 17:05:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_xYL-PqLJGH9SXs1EBjQ_fS7wX+EjLJZ6aBNoO1KzOOw@mail.gmail.com>
X-Gm-Features: AVVi8Cfc3jZKwgLny1qd57OQTscgUZ3yZ7fQa9isE4A2qZKlepBGvJVhq3brPbY
Message-ID: <CAKYAXd_xYL-PqLJGH9SXs1EBjQ_fS7wX+EjLJZ6aBNoO1KzOOw@mail.gmail.com>
Subject: Re: [bug report] ksmbd: compute lease break-in-progress flag on response
To: Dan Carpenter <error27@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 4:17=E2=80=AFPM Dan Carpenter <error27@gmail.com> w=
rote:
>
> Hello Namjae Jeon,
Hi Dan,
>
> Commit 2b6cbd34ed55 ("ksmbd: compute lease break-in-progress flag on
> response") from Jun 18, 2026 (linux-next), leads to the following
> Smatch static checker warning:
>
>         fs/smb/server/oplock.c:1446 smb_grant_oplock()
>         warn: inconsistent indenting
Okay, I will fix it. Thanks for the report.
>
> fs/smb/server/oplock.c
>     1434                 goto set_lev;
>     1435         }
>     1436
>     1437         if (lctx) {
>     1438                 struct oplock_info *m_opinfo;
>     1439
>     1440                 /* is lease already granted ? */
>     1441                 m_opinfo =3D same_client_has_lease(ci, work->con=
n->ClientGUID,
>     1442                                                  lctx);
>     1443                 if (m_opinfo) {
>     1444                         lease_put(opinfo->o_lease);
>     1445                         lease_get(m_opinfo->o_lease);
> --> 1446                                 opinfo->o_lease =3D m_opinfo->o_=
lease;
>
> The commit randomly added an extra tab to these lines...
>
>     1447                                 opinfo->level =3D m_opinfo->leve=
l;
>     1448                                 new_lease =3D false;
>     1449                                 opinfo_put(m_opinfo);
>     1450                                 goto out;
>     1451                         }
>     1452         }
>     1453         prev_opinfo =3D opinfo_get_list(ci);
>
> This email is a free service from the Smatch-CI project [smatch.sf.net].
>
> regards,
> dan carpenter
