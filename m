Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C1D47AF5D
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783618011; cv=pass; b=jRwJ9XrzmpC2dPQJmxQaLz52hUMW2/6LxHwf5HsSLd+LPcuJkxG3Eso2gjD8VrjlCOUwrhfpaMiya3unN1Li41S0MQGxzSyNL7ZkukP6m2qW/tIUP1nYvRFBYafKuhxjhliWxNDGa30fw5JIfq22AZPYU+VCeCPwUD4h6GtZNPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783618011; c=relaxed/simple;
	bh=44+SofjtLmORqg3rncD4AfR8KX3rsGuXPRWkOEfPD68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+6ZENJZx1iznUC/9aS1AsPwjQNNAvn1mcffYdAh/hrFnQVmZokHglx4/dvKgKsAHFxgoFG8pIJYdCZk27bP034l4ieS3PeK3sZ0jW8XE6+qP/Nt0laZD7pGG5VGhqMDd2U13Muu1Gx7UZw7f4j3cZgO5bYIXFd1pBBXwsAqRyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVfiWryZ; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVfiWryZ"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ff88549786so1195186d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 10:26:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783618009; cv=none;
        d=google.com; s=arc-20260327;
        b=J9BD7XMGUZgozffMYPMOo3vwz/H+UfTEfUsKaQ6BGCywTbLJzplnYI3kSgUbm/2krj
         WwKUP4p1eBYENq1pFR1TsDcFr3ZQ+tEN5hDJt4/IM7uUKFBEg58SSkZY9tzABZKMZ7D2
         TkDjA05buYupNE8YOR6CFK8z0xNxxTVKdw/+GxzUrnlaYtMchM58UOIZnJKyud3DGhcM
         B8jvXW8xwGBHWNO3SpxALoIvA9EGG19n69wfbnYgiDt0GmQzGg2t0C82lcFuQqcyaASk
         lxtXh56iDxpY2R/9eRAoHe5/shmvFFFyudLftJGi8SfVn8X2g84HGuZdqOuege4bFTgz
         2OZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m0Sb9vjaFSh4C2dHK/JIngHrRB/oD43G3vbh/5L/SqA=;
        fh=pP/CkbQxzUBVKoYdguD1s0hlrQYRtheClPKBT0CsAb0=;
        b=fCVSd4FIKsA2oKxnt+o9EAsSoKa71GJc5YEw0DPie0olFOlsWf/eBxIqEcnvObIMLw
         Q0hCUs1mPw6v6Bkzp+NJgEsYm8OQa+sqvEG1uQ9ierv3gcLEw4X4s5E2qe7Zk8mq+VBn
         RuYJ+AztI4yGwQwGOyhGCTm9ttAICVmnxFQNp3vXMoyxg4vRNtnk1K/SjN2fN8dFw4qE
         jWsWvytFKsxKy+Psgr+WGmfGStR8OmKBSsun3QzCBof6wuL27aSC2pqfMTc5gtpDZ0MT
         C6pzk7OIuIq3+l+iRuXYiC4DcwXaF8xEvKUWv3vMv4Il6xp1WCwJQhBmABbfABzgAw0H
         qLeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783618009; x=1784222809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m0Sb9vjaFSh4C2dHK/JIngHrRB/oD43G3vbh/5L/SqA=;
        b=PVfiWryZ7WBFXyE9f/R/0RpHUeaxXzcZKxoWMx+A/v5AuxTE8e8tpOWL0oIiFVXWbQ
         SSKL7SENFoVAzibbJIm15qqNiu76O74lhyfyO36tlLFzrSCvm6yZ4k4WLQ4pAUPU86ly
         vWyvTftZj77CTtOADqmT03ZAmNPu5q8kjOIW3a4jRLnbvJ4JFU3O2KQYiryHPpWBJVMS
         2W9aqGtFbtqUlC9jutOOsZeCq+PAKwPm5pk5JW3mXnYDezBiLjlNxo4alJ+kdlabMCqS
         UeWIpPGNWXkNluOvb3ezNlmFT0WYJ/GNkRw4efmocnZqY0sV18wDo8siuxPUkL/qt06B
         126Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783618009; x=1784222809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m0Sb9vjaFSh4C2dHK/JIngHrRB/oD43G3vbh/5L/SqA=;
        b=loBmmBmciqHiPXpYsUDwymZ7M6cOJ61N95mTuGe8c8ysAT+TsOqWmkRuNZuh65uTeM
         7moGbftfsJfhbWsFGvlz2Q0B6BAvj6y0vrDFXswPgK8d84MjBhfJ8ZPoW3cx908GSwjp
         ZdyQ88t0kcKkBbjJZVjMDixQwYMhxAiGcJPgLKNAnjGbR4I3IBQps1NndDi0B9kL2DNz
         KGX3yBBZyVBXvFy6nyjlf1LDQTbmZydl2WfrVEMAHki6YECuUT6JDHU8JrgxLdbk6t46
         /fTEXgfmyO6UoNj945HV8FfpKK/DFz9ewXYeioDt418TFWXw+TpvKktOZzw1SAWr7UIa
         avww==
X-Forwarded-Encrypted: i=1; AHgh+Rqg2VbEQxTrwgWd0xdZ4yH4CAr44p9uoIRj9pj0WCWCznzw0ma64i2QWn7vbtgJcexhxlCNugxS8Ok0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc+KumoxmCQQe+mIhkO9byf+91XI3EXnXoeDMzCZYjHqUCoByW
	i4sRQMkXjzPb+rWKHEdTf0JJ5o/MVCPAqVGSbiQilcGsWtjEuZDgsMa5juIUdR3A3ajqEdUff9Z
	DXeTaAp1DzVcZKrXWkUA7S9fXnU4nPTE=
X-Gm-Gg: AfdE7clgfS2YzI7YaR09oFRXidJTAl9wnPOiKT09CTsjWsRlC54NJ6NJs+IpMj36Luz
	lBYAwN8RXkb44SlHVO95h96jjnPE/iGgAwMHTi5lS8TeseEY+7xxOqPJeSly4VQuLTh0ZrTukJX
	jUbwf1soH162rzRpIfDPN9+lxSjNSZLiwmBObbjgT5XuWlk8oEPOKJz3EgXKg2ijRZBUIj+zGwV
	GZBwHXk6ljTZzi3yfay/bGu6GKfmpc8w2xUwUq00jK0kpZKS4leXBhM6sj5LuCT5dLWDGTL4WTy
	iNLAhakZdDMibvoGr/K4CV3Boe+RWne0vAMDI4fv7BNw2lJBdPO6PZYj/wmMfc1/ogJtFiB37Nj
	uHSoMZkQBsDw+yn1S/9czHHusIoaIXbzDEg0CvQsGSEQW0JpeudIJMHpo201kc+Eti1ok53Ebf3
	KsYfiNoHIgwJw=
X-Received: by 2002:a05:6214:3901:b0:8ef:31b6:74e8 with SMTP id
 6a1803df08f44-8fec04e6cbemr97993726d6.10.1783618008929; Thu, 09 Jul 2026
 10:26:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <527C2DB5ABAE200F+20260707133017.1740557-1-raoxu@uniontech.com> <20260709173628.22eeb7f7@pumpkin>
In-Reply-To: <20260709173628.22eeb7f7@pumpkin>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 12:26:37 -0500
X-Gm-Features: AUfX_mxnR0mimr5UIz726XrEd1tXHGcNWC8r6rYl9X-O8RuA7Y7OGaBpp4uW8ig
Message-ID: <CAH2r5mvxVh_ta1yJgciRgiCpoeJR30U3Z=SDvh+_N3nZ4x_9FA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix atime clamp check in read completion
To: David Laight <david.laight.linux@gmail.com>
Cc: raoxu <raoxu@uniontech.com>, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 11:40=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Tue,  7 Jul 2026 21:30:17 +0800
> raoxu <raoxu@uniontech.com> wrote:
>
> > From: Xu Rao <raoxu@uniontech.com>
> >
> > cifs_rreq_done() updates the inode atime to current_time(inode) after a
> > netfs read.  It then preserves the CIFS rule that atime should not be
> > older than mtime, because some applications break if atime is less than
> > mtime.  That rule only requires clamping when atime < mtime.
> >
> > The current check uses the raw non-zero result of timespec64_compare().
> > It therefore takes the clamp path for both atime < mtime and
> > atime > mtime.  The latter is the normal case when reading an older fil=
e:
> > the newly recorded atime is newer than the file mtime.  The completion
> > handler then immediately moves atime back to mtime, losing the access
> > time that was just recorded.  Userspace tools that rely on atime, such =
as
> > stat, find -atime, backup tools or cold-data classifiers, can therefore
> > see a recently read CIFS file as not recently accessed.
> >
> > This is easy to miss because the bug is silent: read I/O still succeeds=
,
> > no error is reported, and many systems either do not check atime after
> > reads or mount with policies such as relatime/noatime.  It becomes
> > visible when a CIFS file has an mtime older than the current time, the
> > file is read, and the local inode atime is inspected before a later
> > revalidation replaces the cached timestamps.
> >
> > Clamp only when atime is actually older than mtime.  This matches the
> > same atime/mtime rule used when applying CIFS inode attributes.
> >
> > Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xu Rao <raoxu@uniontech.com>
> > ---
> >  fs/smb/client/file.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index 58430ba51b10..62605928d2b8 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -301,7 +301,7 @@ static void cifs_rreq_done(struct netfs_io_request =
*rreq)
> >       /* we do not want atime to be less than mtime, it broke some apps=
 */
> >       atime =3D inode_set_atime_to_ts(inode, current_time(inode));
> >       mtime =3D inode_get_mtime(inode);
> > -     if (timespec64_compare(&atime, &mtime))
> > +     if (timespec64_compare(&atime, &mtime) < 0)
> >               inode_set_atime_to_ts(inode, inode_get_mtime(inode));
>
> Should that be calling inode_get_mtime() again?
> It seems to have the value cached.

Would that be a performance hit?



--=20
Thanks,

Steve
