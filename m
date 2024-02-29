Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A77A125
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709233992; cv=none; b=MUtJbYdhUkMbyOMKZqx6KX0G8JuOQEp4ekHkyUOMNrsGyhv/Ct9tJopCDPn4bZl/2lTgq0xQ4Xv3e0NTOkeL8CTE2cm/4xtNPzZgQopswEpzJ1t2Wrh31JOd/yE1eAR4KMRz5TLRSsnL/ULAfN4PBzb91almAHsrusEox9RfJ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709233992; c=relaxed/simple;
	bh=xYXHYdIRS0M2yLAqgI5O9Gm0wB/j+4SpXV13LchZvU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLax77mzQZWW4yOHOasyPqVOBbo8dsTuweN77A1E/dEpPoGKssZJ8pjNi7sAc80PC3ISKLeEZKphPZXtEQvca0EPkona+ZrgtV+Tz5g9I+8XzFpj1bNAcbdbLsdIuusoqqBauP6eieL9EsXVURlcvQIMsxaj0jOkPBRj1SFcCyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZN9XFDq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZN9XFDq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709233989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jej1sBhkxdN1NAiBzWebNP2TZcnnFsyGp0VQDOU7J9U=;
	b=ZZN9XFDqEAR/V7kANm3ku4L4ymauUd9GqHKY9yVgxmUULC92RrihYi1sbyuM4LskSZl2ef
	poJzxuq3HrQpGPTxuOKRv0BfZfb40Y1BahLAwmhNW6e3qmVv37T/9ccQTOxj/c/xvPjZIe
	ph1v5gdRKMboqSk1LJdeggrfPHD7CKg=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-NoeAa1fVPLuzoik7Vy2woA-1; Thu, 29 Feb 2024 14:13:08 -0500
X-MC-Unique: NoeAa1fVPLuzoik7Vy2woA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dc64f63d768so2283836276.2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 11:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709233986; x=1709838786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jej1sBhkxdN1NAiBzWebNP2TZcnnFsyGp0VQDOU7J9U=;
        b=Ig68nNtw2CswgLyUn+A/zMA9Rzb/VqCqI86dyLNbCjIJ51LttC9RALCOc7NLo9tXud
         davTBzqUil3MkVgajo2nLdwXTukJ2DMFProz34QafRFkhub0dFCPbgUodgKOPI9svR5H
         z3D5Lv6yJY8WJZ/+izuQNwcfnypEWMBNrWmoUAs0XrKp7fjphPy4Dg2aiokQFMu50rQg
         Duk5lh8N/OQfAYms8IxO+vzFdOIY/qgQVDIBm8JbOwpU9GmhiPNDR9hIbiJUiM9/zU6Y
         AwhCyO0wLf311feUIQCEv0ey5t6V/flFUgqiWx4Vy1GnXor2OeUM/+3Y8Fc1gbeL3JeJ
         0DvA==
X-Gm-Message-State: AOJu0YzltaKwIsQfIvNrxMN10wwuvSxfZi6hX5+CvMZji8nWZk8dgw80
	sqX0WhVKZMwpm9eKNKSs2HeRQwFyuQ5sCDSMXtfcYdTyh36aqwt/62TINHolAiNLUsh7PWwpEXJ
	G08ajqlEDq0OH5uS1QpdR+2rYASfUKGmWoYQ5a1r38t/RQ5O5kZ+cZ8croAnuilxmx/NltlLx4B
	oD7AvNutoX/YrHdb3MiqMkUnLqZh6WQ9HIYirmAUo/Cw==
X-Received: by 2002:a05:6902:cc9:b0:dcc:8e02:a6b6 with SMTP id cq9-20020a0569020cc900b00dcc8e02a6b6mr3922606ybb.2.1709233984782;
        Thu, 29 Feb 2024 11:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHA59zpRQtAVJA4vyNSPAGfM5CBzPhLKr8lq/O35tnmstVuQuSV9Rxm5tAk81hR4TTTpPuut/kHCSMzA6zHckk=
X-Received: by 2002:a05:6902:cc9:b0:dcc:8e02:a6b6 with SMTP id
 cq9-20020a0569020cc900b00dcc8e02a6b6mr3922530ybb.2.1709233983243; Thu, 29 Feb
 2024 11:13:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
 <20240108181751.natpy6fac7fzdjqd@suse.de> <CALe0_777GL=XQYSochOoph73madKm8DsRn+xQOcTmz9xh+wcHQ@mail.gmail.com>
 <20240109005628.5xbwpkqc75okxmcg@suse.de>
In-Reply-To: <20240109005628.5xbwpkqc75okxmcg@suse.de>
From: Jacob Shivers <jshivers@redhat.com>
Date: Thu, 29 Feb 2024 14:12:26 -0500
Message-ID: <CALe0_77mahrd+ggWApLYRqCLC0k252r=_89qHW7Oa10RK4D4JA@mail.gmail.com>
Subject: Re: Linux client SMB and DFS site awareness
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Enzo,

Sorry for the delay in response. To further clarify the use-case it is
not pertaining to the target shares, but concerning the namespace
server that we connect to as part of the initial mount for the domain
based DFS share. Assume an environment with some N number of DCs where
each DC is in their own site, a DFS namespace member for the same
namespace, and the domain resolves to each DC in a round-robin.

Condition #1
For AD client site members that are in the same subnet as the site
local DC, we only ever connect to said DC when mounting a domain based
DFS share.

Condition #2
For AD client site members that are *not* in the same subnet as the
site local DC, we connect to a DC that the domain name resolves to,
site local DC, and then the SMB target. We have a  1/N chance of
connecting to the site local DC initially which is not desirable.

For condition #2, we could be potentially connecting to DCs that could
be prohibitively far geographically and incur a non-trivial delay with
possible timeout. While certainly the appeal of a domain based DFS
mount is the abstraction to know which SMB server to access, condition
#2 can yield mount issues when the AD client does not have the
capacity/opportunity to add a DC to the subnet for whatever reason.
This could include heavily siloed environments, separate teams, or
cross vendor interactions.

I could see a use-case where should the SMB client want to limit which
DCs to connect to, with the intent to exclude non-desirable DCs, a
flag be passed that invokes a CLDAP ping to affect such a change. This
can already be done with a hacky wrapper script, but I am curious as
to what level of interest there would be for a more durable
implementation.

Hope that helps to clarify the situation and please ask any follow-up
questions should you or anyone else have any.

Regards,

Jacob Shivers

On Mon, Jan 8, 2024 at 7:56=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> Hi Jacob,
>
> On 01/08, Jacob Shivers wrote:
> >Hello Enzo,
> >
> >Thank you for the response!
>
> Thanks for elaborating.
>
> >I failed to mention the initial aspect that is specific to mounting a
> >domain based DFS share. This would contact a random domain controller
> >instead of a DC local to the calling client's site, should it exist. A
> >CLAP ping like that used by SSSD[0] could be used to identify the
> >nearest domain controller prior to initiating a subsequent mount
> >request. This is where the DNS discovery for a ldap entry would be
> >applicable.
> >
> >Hope that helps to clarify the use case.
>
> This is pretty much what I had in mind, but I still see it as a
> server-side situation, both from the spec side, as from a personal POV.
>
> The DC the client connects to should have all the info in-place and
> ordered (either by site location or by cost) to return to the client,
> where it will contain the highest priority target as the first entry on
> the list (that will probably not be itself, see below).
>
> On Windows Server, you can create a registry key [0] on the DC to force t=
o
> put the logon server (the server the client is authenticated to) as the
> topmost entry on the DC referrals list.
>
> This behaviour is disabled by default, and the reason (as I understand),
> just like your proposal, is because it would defeat the transparency that
> DFS offers; the client would be "forced" (either by manual input or by
> discovery) to know beforehand where it's connecting to, where MS-DFSC sho=
ws
> that the client shouldn't be aware of such details.
>
> I haven't tested, but I would expect the DC I'm connecting to to offer
> the closest targets, no matter if on the same domain, different
> domain/same forest, or even in a forest-forest (with a trust
> relationship) scenario.  Do you have a practical test case where this
> doesn't happen?  OS type and version, along with an overview of the DFS
> setup would be helpful to analyze as well.
>
> [0]
> add/set HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dfs\PreferLo=
gonDC
> (DWORD) to 1
>
>
> Cheers,
>
> Enzo
>

