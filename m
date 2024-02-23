Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95691401D
	for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 07:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674317; cv=none; b=hI8BoJYW/DRrnFBzysiWO7UtSCn4LCQYuIG08ATX1rWqICERexmtQoplQ/6VA1eqLxShVp6afoMdIL33N+7906WXZUrKWr6Mf+Ifb4+O/en50xtTNKqO9ual6SzftZOw9GHOmVKJJiqkb5849G1gwZ9eai+nt89Tv8xih24qBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674317; c=relaxed/simple;
	bh=SyDKXQRnqaWeK783WNTA+olO+vFtB3+VPcwSkTpE8R4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxlfPSnC2FXMZIkeJQ/O7P/1REBkHffDjo7h3E4rVKKXoPe1Jhf3YN/kOwGqLSS1qWqypT8qJT9/n26cRrTdYKyw2bzLDS8AnHLAOjXsUCQAeTAawxO9A1SnJ7MZNS/QQ6Q5xpFssnCWFlrFO5ZlzHuirbdiyz64XgFv1li8AVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqw/s2AM; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqw/s2AM"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d0a4e1789cso7098821fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 23:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708674314; x=1709279114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTx0+VDEpjihS0VK4gN+rHpcsxENJM3qscl49fkssaU=;
        b=jqw/s2AMyir2PqS18YOJhwlD+RUDdfceA9iiFdCAlOTiwx6CvkPfoLCXqh827f3r2s
         0N6iR9mdWfFzPGnF8v+HbPBJR15+Au+q+jD70UqOSLp22UFUdngTlIf1fk2gsJXDFl/N
         zt30F/Z3AJp3l0SbKB/vucPKMxLIbMh/l00vi0Pm4GydEgNawtgzY4MirPxusz5X0ohz
         aNZykOT+eX93AIJyngoUYdBTdokJGNBp1KzKw/Pp6znbutAwNxVsJDNUykDSqIGEavra
         ERtaGR5oMrhtQKyKglkN+XrEqdQAJisrMJtJ+Aj47GO07leeerOaGoTfrrjnE5Ndr7Ue
         COCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708674314; x=1709279114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTx0+VDEpjihS0VK4gN+rHpcsxENJM3qscl49fkssaU=;
        b=XBap6XQhn6d9BKeB7Ke6fVXSPyx7I/8fvr9Khz0I2p/SvQLzBbIYCrI1GNIjavupsO
         5dYY1XvK1Xymr7DgCQjBPx4HqoG2IkM1NIWyWbadUDd8txoc/u7ULliF/uNEl9lI4NDQ
         JjQ/bqb+CEukYW2wpwb6VpnwmDHnNWcpUKVwC+DkxsPtTl5NaiV6izE8MOmp9qfm1I74
         79lAuvIdR/fKgLzcsyAySUSX7nCBfby+2KNP/asfbqfRmNpppbnjacIgweFU1EzalFXg
         DbNCXOb6o+cOzU4OPWc2++htTDmrqQ1xhOh4Y1rSL6d2MVAsTbvgg2mrucnZoTjwVvDR
         6vCA==
X-Forwarded-Encrypted: i=1; AJvYcCUdfVxgtAisnpj254dy2NtiAzkguxIr/OJRmPJs5h+9kApC8d+J+CHEh5NpHFFcADA/Y7sUPebm5/Nya8F05HprckfTvOOZvui8Vw==
X-Gm-Message-State: AOJu0Yz+xmVTpVv6fWEoUJql+hyTnR091Xyy5GjbiB9611C2bXXg3qJ4
	pQ/tYOy8d4CvLfljpaJE85Ky7E7zUrSWUunUvu6fksEE06QS/ultK7h4OVCp5QThOLlNySlTQb5
	n24KZgWCPN5IDvo2QTndUm2UEp8g=
X-Google-Smtp-Source: AGHT+IFVrZzOmpjtrN24auFlcWByGCW36InI9s7KQUA+kkUOO+bGjUAeJhunXHJAxLaWEbhtezy/UHv99vB/WMNYJmo=
X-Received: by 2002:a2e:a549:0:b0:2d2:3a89:b97b with SMTP id
 e9-20020a2ea549000000b002d23a89b97bmr904457ljn.24.1708674313641; Thu, 22 Feb
 2024 23:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
 <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com> <CAH2r5mtSB0nDKxAJHtnp6USgoeVN7hNF79NaOcX_pnF5MVPFhA@mail.gmail.com>
In-Reply-To: <CAH2r5mtSB0nDKxAJHtnp6USgoeVN7hNF79NaOcX_pnF5MVPFhA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 23 Feb 2024 13:15:02 +0530
Message-ID: <CANT5p=qTe2XQJYVdYiVkc34WdsE4ekHaH0f4uMwUoDtSNchwug@mail.gmail.com>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	David Howells <dhowells@redhat.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 4:29=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Updated the patch to allow remount to only change the password if
> disconnected and the session fails to reconnect due to continued
> access denied or password expired errors.
>
> Any thoughts on whether I should add another patch to throttle
> repeated session setups after access denied or key expired (currently
> looks like repeated every few seconds) maybe double the time
> repeatedly (e.g. until a max of 10 or 20 or 30 seconds? between
> reconnect attempts) instead of every two seconds.
>
> On Fri, Feb 16, 2024 at 8:41=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > need_recon would also be true in other cases, for example when the
> > > network is temporarily disconnected. This patch will allow changing o=
f
> > > password even then.
> > > We could setup a special flag when the server returns a
> > > STATUS_LOGON_FAILURE for SessionSetup. We can make the check for that
> > > flag and then allow password change on remount.
> >
> > Yes.  Allowing password change over remount simply because network is
> > disconnected is not a good idea.  The user could mistype the password
> > when performing a remount and then everything would stop working.
> >
> > Not to mention that this patch is only handling a specfic case where a
> > mount would have a single SMB session, which isn't true for a DFS mount=
.
> >
> > > Another option is to extend the multiuser keyring mechanism for singl=
e
> > > user use case as well, and use that for password update.
> > > Ideally, we should be able to setup multiple passwords in that keyrin=
g
> > > and iterate through them once to see if SessionSetup goes through.
> >
> > Yes, sounds like the best approach so far.  It would allow users to
> > update their passwords in keyring and sysadmins could drop existing SMB
> > sessions from server side and then the client would reconnect by using
> > new password from keyring.  This wouldn't even require a remount.
> >
> > Besides, marking this for -stable makes no sense.
>
>
>
> --
> Thanks,
>
> Steve

No major objections for this patch. While it may not cover all cases
like DFS, multiuser etc., it's still a starting point to allowing
users to change password on existing mounts without unmounting.

Steve: We may want to check additionally that sec_type is not Kerberos
for this remount.

I also think that we should have a future patch to update passwords
using cifscreds utility even for single user mounts.

--=20
Regards,
Shyam
